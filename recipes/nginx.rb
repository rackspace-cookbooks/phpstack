# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: nginx
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
# Include the necessary recipes.
%w(apt platformstack::monitors platformstack::iptables nginx).each do |recipe|
  include_recipe recipe
end

template '/etc/nginx/conf.d/php.conf' do
  source 'nginx/php-fpm.erb'
  notifies :restart, 'service[nginx]', :delayed
end

template "/etc/nginx/sites-available/#{node['nginx']['domain']}" do
  source 'nginx/nginx-site.erb'
  notifies :restart, 'service[nginx]'
end

# Workaround for default config in conf.d instead of sites-enabled.
template '/etc/nginx/conf.d/default.conf' do
  source 'nginx/nginx-default.erb'
  notifies :restart, 'service[nginx]', :delayed
end

nginx_site 'default' do
  enable false
end

nginx_site node['nginx']['domain'] do
  enable true
end
