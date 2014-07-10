# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: mysql_master
#
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'phpstack::mysql_base'
include_recipe 'mysql-multi::mysql_master'
include_recipe 'chef-sugar'
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

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

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

node['apache']['sites'].each do |site_name|
  site_name = site_name[0]

  mysql_database site_name do
    connection connection_info
    action 'create'
  end

  node.set_unless['apache']['sites'][site_name]['mysql_password'] = secure_password
  if Chef::Config[:solo]
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
    app_nodes = []
  else
    app_nodes = search(:node, 'recipes:phpstack\:\:application_php' << " AND chef_environment:#{node.chef_environment}")
  end

  app_nodes.each do |app_node|
    mysql_database_user site_name do
      connection connection_info
      password node['apache']['sites'][site_name]['mysql_password']
      host best_ip_for(app_node)
      database_name site_name
      privileges %w(select update insert)
      retries 2
      retry_delay 2
      action %w(create grant)
    end
  end
end
