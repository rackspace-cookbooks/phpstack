# Encoding: utf-8
#
# Cookbook Name:: lampstack
# Recipe:: app
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

node['apache']['sites'].each do | site_name |
  site_name = site_name[0]
  site = node['apache']['sites'][site_name]

  ark site_name do
    url site['tarfile']
    checksum site['sha512sum']
    version site['version']
    prefix_root '/var/www'
    home_dir "/var/www/#{site_name}"
#    path site['docroot']
    action 'install'
  end
end
