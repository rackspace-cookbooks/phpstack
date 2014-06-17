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

node['apache']['sites'].each do | site_name |
  site_name = site_name[0]
  site = node['apache']['sites'][site_name]
  
  application site_name do
    path  node['apache']['sites'][site_name]['docroot']
    owner node['apache']['user']
    group node['apache']['group']
    deploy_key node['apache']['sites'][site_name]['deploy_key']
    repository node['apache']['sites'][site_name]['repository']
    revision   node['apache']['sites'][site_name]['revision']
  end
  web_app site_name do
    cookbook node['apache']['sites'][site_name]['cookbook']
    template node['apache']['sites'][site_name]['template']
    Port node['apache']['sites'][site_name]['port']
    ServerAdmin node['apache']['sites'][site_name]['server_admin']
    ServerName node['apache']['sites'][site_name]['server_name']
    ServerAlias node['apache']['sites'][site_name]['server_alias']
    DocumentRoot node['apache']['sites'][site_name]['docroot']
    CustomLog node['apache']['sites'][site_name]['customlog']
    ErrorLog node['apache']['sites'][site_name]['errorlog']
  end
end

# Apache Iptables Access
add_iptables_rule('INPUT', '-p tcp --dport 80 -j ACCEPT', 515, 'Apache Access')
