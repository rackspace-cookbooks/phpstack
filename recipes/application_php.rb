# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: application_php
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

include_recipe 'git'
if platform_family?('rhel')
  include_recipe 'phpstack::yum'
elsif platform_family?('debian')
  include_recipe 'phpstack::apt'
end
include_recipe 'php'
include_recipe 'php::ini'
include_recipe 'php::module_mysql'
include_recipe 'phpstack::apache'
include_recipe 'phpstack::php_fpm'
include_recipe 'chef-sugar'

# if gluster is in our environment, install the utils and mount it to /var/www
if node.deep_fetch['rackspace_gluster']['config']['server']['glusters'].values[0].key?('nodes')
  if Chef::Config[:solo]
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  else
    # get the list of gluster servers and pick one randomly to use as the one we connect to
    gluster_ips = []
    servers = node.deep_fetch['rackspace_gluster']['config']['server']['glusters'].values[0]['nodes']
    if servers.respond_to?('each')
      servers.each do |server|
        gluster_ips.push(server[1]['ip'])
      end
    end
    node.set_unless['phpstack']['gluster_connect_ip'] = gluster_ips.sample

    # install gluster mount
    package 'glusterfs-client' do
      action :install
    end

    # set up the mountpoint
    mount 'webapp-mountpoint' do
      fstype 'glusterfs'
      device "#{node['phpstack']['gluster_connect_ip']}:/#{node['rackspace_gluster']['config']['server']['glusters'].values[0]['volume']}"
      mount_point '/var/www/'
      action %w(mount enable)
    end
  end
end

node['apache']['sites'].each do | site_name |
  site_name = site_name[0]

  application site_name do
    path node['apache']['sites'][site_name]['docroot']
    owner node['apache']['user']
    group node['apache']['group']
    deploy_key node['apache']['sites'][site_name]['deploy_key']
    repository node['apache']['sites'][site_name]['repository']
    revision node['apache']['sites'][site_name]['revision']
  end
end

mysql_node = search(:node, 'recipes:phpstack\:\:mysql_master' << " AND chef_environment:#{node.chef_environment}").first
template 'phpstack.ini' do
  path '/etc/phpstack.ini'
  cookbook node['phpstack']['ini']['cookbook']
  source 'phpstack.ini.erb'
  owner 'root'
  group node['apache']['group']
  mode '00640'
  variables(
    cookbook_name: cookbook_name,
    mysql_password: if mysql_node.respond_to?('deep_fetch')
                      mysql_node.deep_fetch('phpstack', 'app_password').nil? == true  ? nil : mysql_node['phpstack']['app_password']
                    else
                      nil
                    end
  )
  action 'create'
end
