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

stackname = 'phpstack'

if platform_family?('rhel')
  include_recipe 'yum'
  include_recipe 'yum-epel'
  include_recipe 'yum-ius'
elsif platform_family?('debian')
  include_recipe 'apt'
end
include_recipe 'git'

# set demo if needed
include_recipe "#{stackname}::default"

# if we are nginx we need to install php-fpm before php... (php pulls in apache)
if node[stackname]['webserver'] == 'nginx'
  include_recipe "#{stackname}::nginx"
  include_recipe 'php-fpm'
  node.default[stackname]['gluster_mountpoint'] = node['nginx']['default_root']
end

# we need to run this before apache to pull in the correct version of php
include_recipe 'php'
include_recipe 'php::ini'

if node[stackname]['webserver'] == 'apache'
  include_recipe "#{stackname}::apache"
  node.default[stackname]['gluster_mountpoint'] = node['apache']['docroot_dir']
end

# set gluster mountpoint unless set already
node.default_unless[stackname]['gluster_mountpoint'] = '/var/www'

include_recipe 'build-essential'
# Adding mongod compatibility
php_pear 'mongo' do
  action :install
end

include_recipe 'chef-sugar'

# if gluster is in our environment, install the utils and mount it to /var/www
gluster_cluster = node['rackspace_gluster']['config']['server']['glusters'].values[0]
if gluster_cluster.key?('nodes')
  # get the list of gluster servers and pick one randomly to use as the one we connect to
  gluster_ips = []
  if gluster_cluster['nodes'].respond_to?('each')
    gluster_cluster['nodes'].each do |server|
      gluster_ips.push(server[1]['ip'])
    end
  end
  node.set_unless[stackname]['gluster_connect_ip'] = gluster_ips.sample

  # install gluster mount
  package 'glusterfs-client' do
    action :install
  end

  # set up the mountpoint
  mount 'webapp-mountpoint' do
    fstype 'glusterfs'
    device "#{node[stackname]['gluster_connect_ip']}:/#{node['rackspace_gluster']['config']['server']['glusters'].values[0]['volume']}"
    mount_point node[stackname]['gluster_mountpoint']
    action %w(mount enable)
  end
end

if node.deep_fetch(stackname, 'code-deployment', 'enabled')
  node[node[stackname]['webserver']]['sites'].each do | site_name, site_opts |
    application site_name do
      path site_opts['docroot']
      owner node[node[stackname]['webserver']]['user']
      group node[node[stackname]['webserver']]['group']
      deploy_key site_opts['deploy_key']
      repository site_opts['repository']
      revision site_opts['revision']
    end
  end
end

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  mysql_node = nil
  rabbit_node = nil
else
  mysql_node = search('node', "recipes:#{stackname}\\:\\:mysql_master AND chef_environment:#{node.chef_environment}").first
  rabbit_node = search('node', "recipes:#{stackname}\\:\\:rabbitmq AND chef_environment:#{node.chef_environment}").first
end
template "#{stackname}.ini" do
  path "/etc/#{stackname}.ini"
  cookbook node[stackname]['ini']['cookbook']
  source "#{stackname}.ini.erb"
  owner 'root'
  group node[node[stackname]['webserver']]['group']
  mode '00640'
  variables(
    cookbook_name: cookbook_name,
    # if it responds then we will create the config section in the ini file
    mysql: if mysql_node.respond_to?('deep_fetch')
             if mysql_node.deep_fetch(node[stackname]['webserver'], 'sites').nil?
               nil
             else
               mysql_node.deep_fetch(node[stackname]['webserver'], 'sites').values[0]['mysql_password'].nil? ? nil : mysql_node
             end
           end,
    # need to do here because sugar is not available inside the template
    rabbit_host: if rabbit_node.respond_to?('deep_fetch')
                   best_ip_for(rabbit_node)
                 else
                   nil
                 end,
    rabbit_passwords: if rabbit_node.respond_to?('deep_fetch')
                        rabbit_node.deep_fetch(stackname, 'rabbitmq', 'passwords').values[0].nil? == true ? nil : rabbit_node[stackname]['rabbitmq']['passwords']
                      else
                        nil
                      end
  )
  action 'create'
  # For Nginx the service Uwsgi subscribes to the template, as we need to restart each Uwsgi service
  notifies 'restart', 'service[apache2]', 'delayed' if node[stackname]['webserver'] == 'apache'
end

# backups
node.default['rackspace']['datacenter'] = node['rackspace']['region']
node.set_unless['rackspace_cloudbackup']['backups_defaults']['cloud_notify_email'] = 'example@example.com'
# we will want to change this when https://github.com/rackspace-cookbooks/rackspace_cloudbackup/issues/17 is fixed
node.default['rackspace_cloudbackup']['backups'] =
  [
    {
      location: node[node[stackname]['webserver']]['docroot_dir'],
      enable: node[stackname]['rackspace_cloudbackup']['http_docroot']['enable'],
      comment: 'Web Content Backup',
      cloud: { notify_email: node['rackspace_cloudbackup']['backups_defaults']['cloud_notify_email'] }
    }
  ]

tag('php_app_node')
