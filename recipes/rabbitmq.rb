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

include_recipe 'chef-sugar'
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

# create a rabbit vhost and associated user for each site
node[stackname][node[stackname]['webserver']]['sites'].each do |port, sites|
  sites.each do |site_name, site_opts|
    rabbit_vhost = "#{site_name}-#{port}"

    rabbitmq_vhost "/#{rabbit_vhost}" do
      action 'add'
    end

    node.set_unless[stackname]['rabbitmq']['passwords'][rabbit_vhost] = secure_password

    rabbitmq_user rabbit_vhost do
      action %w(add set_permissions change_password)
      vhost "/#{rabbit_vhost}"
      permissions '.* .* .*'
      password node[stackname]['rabbitmq']['passwords'][rabbit_vhost]
    end
  end
end

# set the best ip to reach rabbit at for searching
node.default[stackname]['rabbitmq']['best_ip_for'] = best_ip_for(node)
