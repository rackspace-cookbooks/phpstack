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

stackname = 'phpstack'

include_recipe 'platformstack::iptables'

# allow app nodes to connect
node.default['rabbitmq']['port'] = '5672' if node['rabbitmq']['port'].nil?
search_add_iptables_rules("tags:#{stackname.gsub('stack', '')}_app_node AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m tcp -p tcp --dport #{node['rabbitmq']['port']} -j ACCEPT",
                          70,
                          'web nodes access to rabbitmq')

# disable the default user
node.default['rabbitmq']['disabled_users'] = %w(guest)
node.default['rabbitmq']['job_control'] = 'upstart'

# enable cloud_monitoring plugin
node.set['platformstack']['cloud_monitoring']['plugins']['rabbitmq']['disabled'] = false

include_recipe 'rabbitmq'

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[stackname]['rabbitmq']['monitor_password'] = secure_password
rabbitmq_user 'monitor' do
  action %w(add set_permissions change_password)
  permissions '.* .* .*'
  password node[stackname]['rabbitmq']['monitor_password']
end

node[node[stackname]['webserver']]['sites'].each do |site_name|
  site_name = site_name[0]

  # create the rabbit vhost
  rabbitmq_vhost "/#{site_name}" do
    action 'add'
  end

  # set random app passwords
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  node.set_unless[stackname]['rabbitmq']['passwords'][site_name] = secure_password

  # add the queue per site
  rabbitmq_user site_name do
    action %w(add set_permissions change_password)
    vhost "/#{site_name}"
    permissions '.* .* .*'
    password node[stackname]['rabbitmq']['passwords'][site_name]
  end
end
