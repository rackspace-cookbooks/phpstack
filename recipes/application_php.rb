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
