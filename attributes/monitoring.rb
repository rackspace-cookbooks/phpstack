# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: monitoring
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

stackname = 'phpstack'

default[stackname]['cloud_monitoring']['remote_http']['disabled'] = false
default[stackname]['cloud_monitoring']['remote_http']['alarm'] = false
default[stackname]['cloud_monitoring']['remote_http']['period'] = 60
default[stackname]['cloud_monitoring']['remote_http']['timeout'] = 15

default['platformstack']['cloud_monitoring']['plugins'] = {}

default['platformstack']['cloud_monitoring']['plugins']['memcached']['label'] = 'memcached'
default['platformstack']['cloud_monitoring']['plugins']['memcached']['disabled'] = true
default['platformstack']['cloud_monitoring']['plugins']['memcached']['period'] = 60
default['platformstack']['cloud_monitoring']['plugins']['memcached']['timeout'] = 30
default['platformstack']['cloud_monitoring']['plugins']['memcached']['file_url'] = 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/memcached_stats.py'
default['platformstack']['cloud_monitoring']['plugins']['memcached']['cookbook'] = 'platformstack'
default['platformstack']['cloud_monitoring']['plugins']['memcached']['details']['file'] = 'memcached_stats.py'
default['platformstack']['cloud_monitoring']['plugins']['memcached']['details']['args'] = []
default['platformstack']['cloud_monitoring']['plugins']['memcached']['details']['timeout'] = 60
default['platformstack']['cloud_monitoring']['plugins']['memcached']['alarm']['label'] = ''
default['platformstack']['cloud_monitoring']['plugins']['memcached']['alarm']['notification_plan_id'] = 'npMANAGED'
default['platformstack']['cloud_monitoring']['plugins']['memcached']['alarm']['criteria'] = ''
