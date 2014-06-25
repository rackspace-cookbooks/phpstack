# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: varnish
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
listen_port = node['varnish']['listen_port']
backend_port = node['varnish']['backend_port']

add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{listen_port} -j ACCEPT", 100, 'Allow access to Varnish')
add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{backend_port} -j REJECT", 101, 'Deny access to backend')

include_recipe 'varnish'
