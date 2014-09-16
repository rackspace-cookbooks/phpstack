# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: format_disk
#
# Copyright 2014, Rackspace, US Inc.
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This recipe will format /dev/xvde1 (datadisk on Rackspace performance cloud nodes) and will prepare it for the mysql datadir.

device = node['disk']['name']
fs = node['disk']['fs']

execute 'mkfs' do
  command "mkfs -t #{fs} #{device}"
  only_if do
    loop do
      if File.blockdev?(device)
        Chef::Log.info("device #{device} exists")
        break
      else
        fail("device #{device} does not exist")
      end
    end
    # check volume filesystem
    cmd = Mixlib::ShellOut.new("blkid -s TYPE -o value #{device}")
    cmd.run_command.error?
  end
end
