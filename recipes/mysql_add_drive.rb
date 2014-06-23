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

device = '/dev/xvde1'

execute 'mkfs' do
  command "mkfs -t ext3 #{device}"
  not_if do
    # wait for the device
    loop do
      if File.blockdev?(device)
        Chef::Log.info("device #{device} ready")
        break
      else
        Chef::Log.info("device #{device} not ready - waiting")
        sleep 10
      end
    end
    # check volume filesystem
    cmd = Mixlib::ShellOut.new("blkid -s TYPE -o value #{device}")
    cmd.run_command
    cmd.error!
  end
end

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
  device device
  fstype 'ext3'
  action [:mount, :enable]
end
