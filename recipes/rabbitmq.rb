# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: rabbitmq
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

include_recipe 'platformstack::iptables'

# allow application_php nodes to connect
node.default['rabbitmq']['port'] = '5672' if node['rabbitmq']['port'].nil?
search_add_iptables_rules("tags:php_app_node AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m tcp -p tcp --dport #{node['rabbitmq']['port']} -j ACCEPT",
                          70,
                          'web nodes access to rabbitmq')

include_recipe 'rabbitmq'

# disable the default user
node.default['rabbitmq']['disabled_users'] = %w(guest)

node['apache']['sites'].each do |site_name|
  site_name = site_name[0]

  # create the rabbit vhost
  rabbitmq_vhost "/#{site_name}" do
    action 'add'
  end

  # set random app passwords
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  node.set_unless['phpstack']['rabbitmq']['passwords'][site_name] = secure_password

  # add the queue per site
  rabbitmq_user site_name do
    action %w(add set_permissions change_password)
    vhost "/#{site_name}"
    permissions '.* .* .*'
    password node['phpstack']['rabbitmq']['passwords'][site_name]
  end
end
