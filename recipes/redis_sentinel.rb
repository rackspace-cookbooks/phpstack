# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: redis_sentinel
#
# Copyright 2014, Rackspace US, Inc.
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

include_recipe 'redis-multi::sentinel'
include_recipe 'redis-multi::sentinel_default'
include_recipe 'redis-multi::sentinel_enable'

# allow app nodes to connect
search_add_iptables_rules("tags:#{stackname.gsub('stack', '')}_app_node AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m tcp -p tcp --dport #{node['redis-multi']['bind_port']} -j ACCEPT",
                          9999,
                          'Open port for redis from app')

# allow redis to connect to eachother
search_add_iptables_rules("tags:#{stackname}-redis_sentinel AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m tcp -p tcp --dport #{node['redis-multi']['sentinel_port']} -j ACCEPT",
                          9999,
                          'Open port for redis to redis for sentinel')
search_add_iptables_rules("tags:#{stackname}-redis AND chef_environment:#{node.chef_environment}",
                          'INPUT',
                          "-m tcp -p tcp --dport #{node['redis-multi']['bind_port']} -j ACCEPT",
                          9999,
                          'Open port for redis to redis')

tag("#{stackname}-redis_sentinel")
