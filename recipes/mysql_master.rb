# Encoding: utf-8
#
# Cookbook Name:: lampstack
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

include_recipe 'chef-sugar::default'
include_recipe 'platformstack::monitors'
include_recipe 'database::mysql'
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# determine best IP for bind_address in MySQL
if node.attribute?('cloud')
  bindip = node['cloud']['local_ipv4']
else
  bindip = node['ipaddress']
end

# Unique serverid via ipaddress to an int
require 'ipaddr'
serverid = IPAddr.new node['ipaddress']
serverid = serverid.to_i

# run apt-get update to clear cache issues
include_recipe 'apt' if node.platform_family?('debian')

include_recipe 'mysql::server'

directory '/etc/mysql/conf.d' do
  action :create
  recursive true
end

template '/etc/mysql/conf.d/master.cnf' do
  source 'mysql/master.cnf.erb'
  variables(
    cookbook_name: cookbook_name
  )
end

template '/etc/mysql/conf.d/my.cnf' do
  source 'mysql/my.cnf.erb'
  variables(
    serverid: serverid,
    cookbook_name: cookbook_name,
    bind_address: bindip
  )
  notifies :restart, 'service[mysql]', :delayed
end

# Grant replication on slave
node['mysql']['slaves'].each do |slave|

  execute 'grant-slave' do
    command <<-EOH
    /usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < /root/grant-slaves.sql
    rm -f /root/grant-slaves.sql
    EOH
    action :nothing
  end

  template '/root/grant-slaves.sql' do
    path '/root/grant-slaves.sql'
    source 'mysql/grant.slave.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables(
      user: node['mysql']['slave_user'],
      password: node['mysql']['server_repl_password'],
      host: slave
    )
    notifies :run, 'execute[grant-slave]', :immediately
  end
end

# add holland user
if node.deep_fetch('holland', 'enabled')
  execute 'grant-holland' do
    command <<-EOH
    /usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < /root/grant-holland.sql
    rm -f /root/grant-holland.sql
    EOH
    action :nothing
  end
  template '/root/grant-holland.sql' do
    path '/root/grant-holland.sql'
    source 'mysql/grant.holland.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables(
      user: 'holland',
      password: node['holland']['password'],
      host: '%'
    )
    notifies :run, 'execute[grant-holland]', :immediately
  end
end

# add /root/.my.cnf file to system
template '/root/.my.cnf' do
  source 'mysql/user.my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    user: 'root',
    pass: node['mysql']['server_root_password']
  )
end

case node['platform_family']
when 'rhel'
  service 'mysql' do
    service_name 'mysqld'
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
when 'debian'
  service 'mysql' do
    service_name 'mysql'
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
end

node.set_unless['lampstack']['cloud_monitoring']['agent_mysql']['password'] = secure_password

mysql_connection_info = {
  host:     'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

mysql_database_user node['lampstack']['cloud_monitoring']['agent_mysql']['user'] do
  connection mysql_connection_info
  password node['lampstack']['cloud_monitoring']['agent_mysql']['password']
  action 'create'
end

template 'mysql-monitor' do
  cookbook 'lampstack'
  source 'monitoring-agent-mysql.yaml.erb'
  path '/etc/rackspace-monitoring-agent.conf.d/agent-mysql-monitor.yaml'
  owner 'root'
  group 'root'
  mode '00600'
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
  only_if node['platformstack']['cloud_monitoring']['enabled'] == true
end
