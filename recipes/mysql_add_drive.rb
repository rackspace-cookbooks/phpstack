# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: mysql_add_drive
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

# This recipe will format /dev/xvde1 (datadisk on Rackspace performance cloud nodes) and will prepare it for the mysql datadir.

include_recipe 'phpstack::format_disk'

user 'mysql' do
  comment 'MySQL Server'
  home '/var/lib/mysql'
  shell '/sbin/nologin'
end

directory '/var/lib/mysql' do
  owner 'mysql'
  group 'mysql'
  mode '0700'
  action :create
  not_if do
    File.directory?('/var/lib/mysql')
  end
end

mount '/var/lib/mysql' do
  device node['disk']['name']
  fstype node['disk']['fs']
  action [:mount, :enable]
end
