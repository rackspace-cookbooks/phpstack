# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: demo
#
# Copyright 2014, Rackspace Hosting
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

include_recipe 'chef-sugar'

if includes_recipe?('phpstack::application_php')
  node.default['rackspace']['datacenter'] = node['rackspace']['region']
  node.default['rackspace_cloudbackup']['backups_defaults']['cloud_notify_email'] = 'example@example.com'
  node.set['rackspace_cloudbackup']['backups'] =
    [
      { location: '/var/www',
        comment:  'Web Content Backup',
        cloud: { notify_email: 'example@example.com' }
      },
      { location: '/etc',
        time: {
          day:     1,
          month:   '*',
          hour:    0,
          minute:  0,
          weekday: '*'
        },
        cloud: { notify_email: 'example@example.com' }
      }
    ]
end
