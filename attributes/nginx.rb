# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Attributes:: nginx
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

default['nginx']['default_site_enabled'] = false
# needs setting because by default it is set to runit
if platform?('ubuntu')
  set['nginx']['init_style'] = 'upstart'
end

# needed to be like this so it acts like apache
default['nginx']['listen_ports'] = %w(80)

default['nginx']['default_root'] = '/var/www'
