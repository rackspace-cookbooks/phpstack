# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: gluster
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

cluster = node['rackspace_gluster']['config']['server']['glusters'].values[0]

# set the replica count to the number of gluster nodes
if cluster['nodes'].values.count == 2
  replica_count = 2
elsif cluster['nodes'].values.count >= 3
  replica_count = 3
else
  Chef::Application.fatal!('gluster node count is not 2 or greater', 1)
end
node.default['rackspace_gluster']['config']['server']['glusters'].values[0]['replica'] = replica_count
# node.default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['replica'] = cluster['nodes'].values.count

# allow application_php nodes to connect
search_add_iptables_rules("tags:php_app_node AND chef_environment:#{node.chef_environment}", 'INPUT', '-j ACCEPT', 70, 'web nodes access to gluster')

# dynamically generate the authorized clients
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  gluster_servers = search('node', "(tags:php_app_node OR recipes:phpstack\\:\\:gluster) AND chef_environment:#{node.chef_environment}")
  gluster_ips = ['127.0.0.1']
  gluster_servers.each do |gluster_server|
    gluster_ips.push best_ip_for(gluster_server)
  end
  node.default['rackspace_gluster']['config']['server']['glusters'].values[0]['auth_clients'] = gluster_ips.join(',')
end

# allow the gluster nodes to connect to eachother
cluster['nodes'].values.each do |gluster_node|
  add_iptables_rule('INPUT', "-s #{gluster_node['ip']} -j ACCEPT", 50, 'allow gluster')
end

include_recipe 'rackspace_gluster'
