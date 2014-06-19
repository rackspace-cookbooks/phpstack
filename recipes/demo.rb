#
# Cookbook Name:: lampstack
# Recipe:: demo
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe 'chef-sugar'

#the chef-sugar functions allow us to be first in the runlist if we want
if includes_recipe?('lampstack::mysql_master')
  include_recipe 'lampstack::mysql_master'
  connection_info = {
    host: 'localhost',
    username: 'root',
    password: node['mysql']['server_root_password']
  }

  mysql_database node['lampstack']['app_db_name'] do
    connection connection_info
    action 'create'
  end

  node.set_unless['lampstack']['app_password'] = secure_password

  app_nodes = search(:node, 'recipes:lampstack\:\:application_php' << " AND chef_environment:#{node.chef_environment}")
  app_nodes.each do |app_node|
    mysql_database_user  node['lampstack']['app_user'] do
      connection connection_info
      password node['lampstack']['app_password']
      host "#{app_node['cloud']['local_ipv4']}"
      database_name node['lampstack']['app_db_name']
      privileges ['select', 'update', 'insert']
      retries 2
      retry_delay 2
      action ['create', 'grant']
    end
  end
end

if includes_recipe?('lampstack::application_php')
  node.default['rackspace']['datacenter'] = 'dfw'
  node.default['rackspace_cloudbackup']['backups_defaults']['cloud_notify_email'] = 'mattthode@rackspace.com'
  node.set['rackspace_cloudbackup']['backups'] =
    [
      { location: "/var/www",
        comment:  "Web Content Backup",
        cloud: { notify_email: "matt.thode@rackspace.com" }
      },
      { location: "/etc",
        time: {
          day:     1,
          month:   '*',
          hour:    0,
          minute:  0,
          weekday: '*'
        },
        cloud: { notify_email: "matt.thode@rackspace.com" }
      },
  ]
end