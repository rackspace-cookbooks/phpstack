# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: redis
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

include_recipe 'redisio'

redisio_install 'redis-servers' do
  version node['redisio']['version']
  download_url node['redisio']['download_url']
  default_settings node['redisio']['default_settings']
  servers node['redisio']['servers']
  safe_install node['redisio']['safe_install']
  base_piddir node['redisio']['base_piddir']
end

node['redisio']['servers'].each do |current_server|
  service "redis#{current_server['port']}" do
    action :start
  end
end
