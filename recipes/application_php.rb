# Encoding: utf-8
#
# Cookbook Name:: lampstack
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
  include_recipe 'lampstack::yum'
elsif platform_family?('debian')
  include_recipe 'lampstack::apt'
end
include_recipe 'php'
include_recipe 'php::ini'
include_recipe 'php::module_mysql'
include_recipe 'lampstack::apache'
include_recipe 'lampstack::php_fpm'
include_recipe 'chef-sugar'

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

mysql_node = search(:node, 'recipes:lampstack\:\:mysql_master' << " AND chef_environment:#{node.chef_environment}").first
template 'lampstack.ini' do
  path '/etc/lampstack.ini'
  cookbook node['lampstack']['ini']['cookbook']
  source 'lampstack.ini.erb'
  owner 'root'
  group node['apache']['group']
  mode '00640'
  variables(
    cookbook_name: cookbook_name,
    mysql_password: mysql_node.deep_fetch('lampstack', 'app_password').nil? == true  ? nil : mysql_node['lampstack']['app_password']
  )
  action 'create'
end
