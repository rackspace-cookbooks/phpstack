# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: default
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

if node['phpstack']['flags']['monitoring']['enabled']
  if node['phpstack']['flags']['monitoring']['newrelic']
    include_recipe 'phpstack::newrelic'
  end
end
if node['phpstack']['flags']['webserver']['enabled']
  if node['phpstack']['flags']['webserver']['apache']
    include_recipe 'phpstack::apache'
  end
  if node['phpstack']['flags']['webserver']['nginx']
    include_recipe 'phpstack::nginx'
  end
end
if node['phpstack']['flags']['application']['enabled']
  include_recipe 'phpstack::application_php'
end
if node['phpstack']['flags']['mysql']['enabled']
  if  node['phpstack']['flags']['mysql']['standalone']
    include_recipe 'phpstack::mysql_base'
  end
  if node['phpstack']['flags']['mysql']['master']
    include_recipe 'phpstack::mysql_master'
  end
  if node['phpstack']['flags']['mysql']['slave']
    include_recipe 'phpstack::mysql_slave'
  end
  if node['phpstack']['flags']['mysql']['holland']
    include_recipe 'phpstack::mysql_holland'
  end
end
