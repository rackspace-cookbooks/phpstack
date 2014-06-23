# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: mysql_master
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

include_recipe 'phpstack::mysql_base'

include_recipe 'mysql-multi::mysql_master'

if node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled')
  template 'mysql-monitor' do
    cookbook 'phpstack'
    source 'monitoring-agent-mysql.yaml.erb'
    path '/etc/rackspace-monitoring-agent.conf.d/agent-mysql-monitor.yaml'
    owner 'root'
    group 'root'
    mode '00600'
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end
