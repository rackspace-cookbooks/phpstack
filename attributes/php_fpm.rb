# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: php-fpm
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

if node['phpstack']['webserver'] == 'apache'
  default['php-fpm']['user'] = node['apache']['user']
  default['php-fpm']['group'] = node['apache']['group']
else
  default['php-fpm']['user'] = node['nginx']['user']
  default['php-fpm']['group'] = node['nginx']['group']
end

# default['php-fpm']['pools'] = false

case node['platform_family']
when 'rhel'
  default['php-fpm']['package_name'] = 'php55u-fpm'
  default['php-fpm']['service_name'] = 'php-fpm'
when 'debian'
  default['php']['package-name'] = %w(php5-fpm)
end
