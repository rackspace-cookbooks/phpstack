# Encoding: utf-8
#
# Cookbook Name:: lampstack
# Recipe:: mysql_slave
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

include_recipe 'lampstack::mysql_base'

template '/etc/mysql/conf.d/mysql_slave.cnf' do
  source 'mysql/slave.cnf.erb'
  variables(
    cookbook_name: cookbook_name
  )
end

# Connect slave to master
execute 'change master' do
  command <<-EOH
/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < /root/change.master.sql
rm -f /root/change.master.sql
EOH
  action :nothing
end

template '/root/change.master.sql' do
  path '/root/change.master.sql'
  source 'mysql/change.master.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    host: node['mysql']['master'],
    user: node['mysql']['slave_user'],
    password: node['mysql']['server_repl_password']
  )
  notifies :run, 'execute[change master]', :immediately
end