# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: mysql
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

default['mysql-multi']['master'] = ''
default['mysql-multi']['slaves'] = []
default['mysql-multi']['slave_user'] = 'replicant'

default['phpstack']['app_db_name'] = 'exampledb'
default['phpstack']['app_user'] = 'foobar'
default['phpstack']['app_password'] = nil
