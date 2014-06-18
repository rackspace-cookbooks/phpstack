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

include_recipe 'lampstack::mysql_base'

template '/etc/mysql/conf.d/master.cnf' do
  source 'mysql/master.cnf.erb'
  variables(
    cookbook_name: cookbook_name
  )
end

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

# Grant replication on slave
node['mysql']['slaves'].each do |slave|
  mysql_database_user 'replicant' do
    connection connection_info
    password node['mysql']['server_repl_password']
    host slave
    privileges [:'replication slave', :usage]
    action [:create, :grant]
    retries 2
  end
end

if node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled')
  template 'mysql-monitor' do
    cookbook 'lampstack'
    source 'monitoring-agent-mysql.yaml.erb'
    path '/etc/rackspace-monitoring-agent.conf.d/agent-mysql-monitor.yaml'
    owner 'root'
    group 'root'
    mode '00600'
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end
