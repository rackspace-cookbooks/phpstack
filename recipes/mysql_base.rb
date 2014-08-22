# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: mysql_base
#
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# run apt-get update to clear cache issues
include_recipe 'apt' if node.platform_family?('debian')
include_recipe 'chef-sugar'
include_recipe 'platformstack::monitors'

# set passwords dynamically...
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['phpstack']['cloud_monitoring']['agent_mysql']['password'] = secure_password
if node['mysql']['server_root_password'] == 'ilikerandompasswords'
  node.set['mysql']['server_root_password'] = secure_password
end

include_recipe 'build-essential'
include_recipe 'mysql-multi'
include_recipe 'database::mysql'

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

# add holland user (if holland is enabled)
mysql_database_user 'holland' do
  connection connection_info
  password node['holland']['password']
  host 'localhost'
  privileges [:usage, :select, :'lock tables', :'show view', :reload, :super, :'replication client']
  retries 2
  retry_delay 2
  action [:create, :grant]
  only_if { node.deep_fetch('holland', 'enabled') }
end

mysql_database_user node['phpstack']['cloud_monitoring']['agent_mysql']['user'] do
  connection connection_info
  password node['phpstack']['cloud_monitoring']['agent_mysql']['password']
  action 'create'
  only_if { node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled') }
end

template 'mysql-monitor' do
  cookbook 'phpstack'
  source 'monitoring-agent-mysql.yaml.erb'
  path '/etc/rackspace-monitoring-agent.conf.d/agent-mysql-monitor.yaml'
  owner 'root'
  group 'root'
  mode '00600'
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
  only_if { node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled') }
end

# allow the app nodes to connect
search_add_iptables_rules(
  "tags:php_app_node AND chef_environment:#{node.chef_environment}",
  'INPUT', "-p tcp --dport #{node['mysql']['port']} -j ACCEPT",
  9998,
  'allow app nodes to connect')

# we don't want to create DBs or users and the like on slaves, do we?
unless includes_recipe?('phpstack::mysql_slave')
  node['apache']['sites'].each do |site_name|
    site_name = site_name[0]
    if node['apache']['sites'][site_name]['databases'].nil?
      db_name = site_name[0...64]
      node.set['apache']['sites'][site_name]['databases'][db_name]['mysql_user'] = site_name[0...16]
    end

    node['apache']['sites'][site_name]['databases'].each do |database|
      mysql_database database[0] do
        connection connection_info
        action 'create'
      end
    end

    if Chef::Config[:solo]
      Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
      app_nodes = []
    else
      app_nodes = search(:node, "tags:php_app_node AND chef_environment:#{node.chef_environment}")
    end

    app_nodes.each do |app_node|
      node['apache']['sites'][site_name]['databases'].each do |database|
        database = database[0]
        mysql_password = node['apache']['sites'][site_name]['databases'][database]['mysql_password']
        if mysql_password.nil? || mysql_password.empty? || !node['apache']['sites'][site_name]['databases'][database]['mysql_password']
          mysql_password = secure_password
        end

        mysql_database_user node['apache']['sites'][site_name]['databases'][database]['mysql_user'] do
          connection connection_info
          password mysql_password
          host best_ip_for(app_node)
          database_name database
          privileges %w(select update insert)
          retries 2
          retry_delay 2
          action %w(create grant)
        end
      end
    end
  end
end
