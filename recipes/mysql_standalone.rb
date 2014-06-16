# Encoding: utf-8
#
# Cookbook Name:: lampstack
# Recipe:: mysql_standalone
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

include_recipe 'chef-sugar'
include_recipe 'database::mysql'

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

template '/etc/mysql/conf.d/my.cnf' do
  source 'mysql/my.cnf.erb'
  variables(
    serverid: serverid,
    cookbook_name: cookbook_name,
    bind_address: bindip
  )
  notifies :restart, 'service[mysql]', :delayed
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

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

mysql_database_user 'root' do
  connection connection_info
  privileges [:all]
  password node['mysql']['server_root_password']
  action [:create, :grant]
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
