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
default['nginx']['listen_ports'] = %w(80)

if node['phpstack']['demo']['enabled']
  site1 = 'example.com'
  version1 = '0.0.9'

  default['nginx']['sites'][site1]['port']         = '80'
  default['nginx']['sites'][site1]['cookbook']     = 'phpstack'
  default['nginx']['sites'][site1]['template']     = "nginx/sites/#{site1}.erb"
  default['nginx']['sites'][site1]['server_name']  = site1
  default['nginx']['sites'][site1]['server_alias'] = ["test.#{site1}", "www.#{site1}"]
  default['nginx']['sites'][site1]['docroot']      = "#{node['nginx']['default_root']}/#{site1}"
  default['nginx']['sites'][site1]['errorlog']     = "#{node['nginx']['log_dir']}/#{site1}-error.log info"
  default['nginx']['sites'][site1]['customlog']    = "#{node['nginx']['log_dir']}/#{site1}-access.log combined"
  default['nginx']['sites'][site1]['server_admin'] = 'demo@demo.com'
  default['nginx']['sites'][site1]['revision'] = "v#{version1}"
  default['nginx']['sites'][site1]['repository'] = 'https://github.com/rackops/php-test-app'
  default['nginx']['sites'][site1]['deploy_key'] = '/root/.ssh/id_rsa'
end
