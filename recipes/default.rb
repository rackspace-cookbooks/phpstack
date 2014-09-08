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

if node['phpstack']['webserver'] == 'apache' && node['phpstack']['demo']['enabled']
  site1 = 'example.com'
  version1 = '0.0.9'

  node.default['apache']['sites'][site1]['port']         = 80
  node.default['apache']['sites'][site1]['cookbook']     = 'phpstack'
  node.default['apache']['sites'][site1]['template']     = "apache2/sites/#{site1}.erb"
  node.default['apache']['sites'][site1]['server_name']  = site1
  node.default['apache']['sites'][site1]['server_alias'] = ["test.#{site1}", "www.#{site1}"]
  node.default['apache']['sites'][site1]['docroot']      = "#{node['apache']['docroot_dir']}/#{site1}"
  node.default['apache']['sites'][site1]['errorlog']     = "#{node['apache']['log_dir']}/#{site1}-error.log"
  node.default['apache']['sites'][site1]['customlog']    = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
  node.default['apache']['sites'][site1]['allow_override'] = ['All']
  node.default['apache']['sites'][site1]['loglevel']     = 'warn'
  node.default['apache']['sites'][site1]['server_admin'] = 'demo@demo.com'
  node.default['apache']['sites'][site1]['revision'] = "v#{version1}"
  node.default['apache']['sites'][site1]['repository'] = 'https://github.com/rackops/php-test-app'
  node.default['apache']['sites'][site1]['deploy_key'] = '/root/.ssh/id_rsa'
end

if node['phpstack']['webserver'] == 'nginx' && node['phpstack']['demo']['enabled']
  site1 = 'example.com'
  version1 = '0.0.9'

  node.default['nginx']['sites'][site1]['port']         = '80'
  node.default['nginx']['sites'][site1]['cookbook']     = 'phpstack'
  node.default['nginx']['sites'][site1]['template']     = "nginx/sites/#{site1}.erb"
  node.default['nginx']['sites'][site1]['server_name']  = site1
  node.default['nginx']['sites'][site1]['server_alias'] = ["test.#{site1}", "www.#{site1}"]
  node.default['nginx']['sites'][site1]['docroot']      = "#{node['nginx']['default_root']}/#{site1}"
  node.default['nginx']['sites'][site1]['errorlog']     = "#{node['nginx']['log_dir']}/#{site1}-error.log info"
  node.default['nginx']['sites'][site1]['customlog']    = "#{node['nginx']['log_dir']}/#{site1}-access.log combined"
  node.default['nginx']['sites'][site1]['server_admin'] = 'demo@demo.com'
  node.default['nginx']['sites'][site1]['revision'] = "v#{version1}"
  node.default['nginx']['sites'][site1]['repository'] = 'https://github.com/rackops/php-test-app'
  node.default['nginx']['sites'][site1]['deploy_key'] = '/root/.ssh/id_rsa'
end
