# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: newrelic
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

# The node['newrelic']['license'] attribute needs to be set for NewRelic to work

fail 'The NewRelic license attribute is not set.' if node['newrelic']['license'].nil?

node.override['newrelic']['application_monitoring']['daemon']['ssl'] = true
node.override['newrelic']['server_monitoring']['ssl'] = true
node.override['newrelic']['php-agent']['agent_action'] = 'upgrade'
include_recipe 'newrelic::php-agent'
