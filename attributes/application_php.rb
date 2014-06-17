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

default['lampstack']['application_php']['revision'] = 'master'
default['lampstack']['application_php']['repository'] = 'https://github.com/panique/php-login-minimal'
default['lampstack']['application_php']['gid'] = 'apache'
default['lampstack']['application_php']['uid'] = 'apache'
default['lampstack']['application_php']['path'] = '/var/www'
