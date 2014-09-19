# Encoding: utf-8
#
# Cookbook Name:: phpstack
#
# Copyright 2014, Rackspace UK, Ltd.
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

default['phpstack']['demo']['enabled'] = false

site1 = 'example.com'
site2 = 'test.com'
version1 = '0.0.9'
port1 = '80'
port2 = '8080'

# apache site1
default['phpstack']['demo']['apache']['sites'][port1][site1]['template']       = "apache2/sites/#{site1}-#{port1}.erb"
default['phpstack']['demo']['apache']['sites'][port1][site1]['cookbook']       = 'phpstack'
default['phpstack']['demo']['apache']['sites'][port1][site1]['server_name']    = site1
default['phpstack']['demo']['apache']['sites'][port1][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['apache']['sites'][port1][site1]['docroot']        = "/var/www/#{site1}/#{port1}"
default['phpstack']['demo']['apache']['sites'][port1][site1]['errorlog']       = "#{node['apache']['log_dir']}/#{site1}-error.log"
default['phpstack']['demo']['apache']['sites'][port1][site1]['customlog']      = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
default['phpstack']['demo']['apache']['sites'][port1][site1]['allow_override'] = ['All']
default['phpstack']['demo']['apache']['sites'][port1][site1]['loglevel']       = 'warn'
default['phpstack']['demo']['apache']['sites'][port1][site1]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['apache']['sites'][port1][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port1][site1]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['apache']['sites'][port1][site1]['deploy_key']     = '/root/.ssh/id_rsa'

default['phpstack']['demo']['apache']['sites'][port2][site1]['template']       = "apache2/sites/#{site1}-#{port2}.erb"
default['phpstack']['demo']['apache']['sites'][port2][site1]['cookbook']       = 'phpstack'
default['phpstack']['demo']['apache']['sites'][port2][site1]['server_name']    = site1
default['phpstack']['demo']['apache']['sites'][port2][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['apache']['sites'][port2][site1]['docroot']        = "/var/www/#{site1}/#{port2}"
default['phpstack']['demo']['apache']['sites'][port2][site1]['errorlog']       = "#{node['apache']['log_dir']}/#{site1}-error.log"
default['phpstack']['demo']['apache']['sites'][port2][site1]['customlog']      = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
default['phpstack']['demo']['apache']['sites'][port2][site1]['allow_override'] = ['All']
default['phpstack']['demo']['apache']['sites'][port2][site1]['loglevel']       = 'warn'
default['phpstack']['demo']['apache']['sites'][port2][site1]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['apache']['sites'][port2][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port2][site1]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['apache']['sites'][port2][site1]['deploy_key']     = '/root/.ssh/id_rsa'

# apache site2
default['phpstack']['demo']['apache']['sites'][port1][site2]['template']       = "apache2/sites/#{site2}-#{port1}.erb"
default['phpstack']['demo']['apache']['sites'][port1][site2]['cookbook']       = 'phpstack'
default['phpstack']['demo']['apache']['sites'][port1][site2]['server_name']    = site2
default['phpstack']['demo']['apache']['sites'][port1][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['apache']['sites'][port1][site2]['docroot']        = "/var/www/#{site2}/#{port1}"
default['phpstack']['demo']['apache']['sites'][port1][site2]['errorlog']       = "#{node['apache']['log_dir']}/#{site2}-error.log"
default['phpstack']['demo']['apache']['sites'][port1][site2]['customlog']      = "#{node['apache']['log_dir']}/#{site2}-access.log combined"
default['phpstack']['demo']['apache']['sites'][port1][site2]['allow_override'] = ['All']
default['phpstack']['demo']['apache']['sites'][port1][site2]['loglevel']       = 'warn'
default['phpstack']['demo']['apache']['sites'][port1][site2]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['apache']['sites'][port1][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port1][site2]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['apache']['sites'][port1][site2]['deploy_key']     = '/root/.ssh/id_rsa'

default['phpstack']['demo']['apache']['sites'][port2][site2]['template']       = "apache2/sites/#{site2}-#{port2}.erb"
default['phpstack']['demo']['apache']['sites'][port2][site2]['cookbook']       = 'phpstack'
default['phpstack']['demo']['apache']['sites'][port2][site2]['server_name']    = site2
default['phpstack']['demo']['apache']['sites'][port2][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['apache']['sites'][port2][site2]['docroot']        = "/var/www/#{site2}/#{port2}"
default['phpstack']['demo']['apache']['sites'][port2][site2]['errorlog']       = "#{node['apache']['log_dir']}/#{site2}-error.log"
default['phpstack']['demo']['apache']['sites'][port2][site2]['customlog']      = "#{node['apache']['log_dir']}/#{site2}-access.log combined"
default['phpstack']['demo']['apache']['sites'][port2][site2]['allow_override'] = ['All']
default['phpstack']['demo']['apache']['sites'][port2][site2]['loglevel']       = 'warn'
default['phpstack']['demo']['apache']['sites'][port2][site2]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['apache']['sites'][port2][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port2][site2]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['apache']['sites'][port2][site2]['deploy_key']     = '/root/.ssh/id_rsa'

# nginx site1
default['phpstack']['demo']['nginx']['sites'][port1][site1]['template']       = "nginx/sites/#{site1}-#{port1}.erb"
default['phpstack']['demo']['nginx']['sites'][port1][site1]['cookbook']       = 'phpstack'
default['phpstack']['demo']['nginx']['sites'][port1][site1]['server_name']    = site1
default['phpstack']['demo']['nginx']['sites'][port1][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['nginx']['sites'][port1][site1]['docroot']        = "/var/www/#{site1}/#{port1}"
default['phpstack']['demo']['nginx']['sites'][port1][site1]['errorlog']       = "#{node['nginx']['log_dir']}/#{site1}-error.log info"
default['phpstack']['demo']['nginx']['sites'][port1][site1]['customlog']      = "#{node['nginx']['log_dir']}/#{site1}-access.log combined"
default['phpstack']['demo']['nginx']['sites'][port1][site1]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['nginx']['sites'][port1][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port1][site1]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['nginx']['sites'][port1][site1]['deploy_key']     = '/root/.ssh/id_rsa'

default['phpstack']['demo']['nginx']['sites'][port2][site1]['template']       = "nginx/sites/#{site1}-#{port2}.erb"
default['phpstack']['demo']['nginx']['sites'][port2][site1]['cookbook']       = 'phpstack'
default['phpstack']['demo']['nginx']['sites'][port2][site1]['server_name']    = site1
default['phpstack']['demo']['nginx']['sites'][port2][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['nginx']['sites'][port2][site1]['docroot']        = "/var/www/#{site1}/#{port2}"
default['phpstack']['demo']['nginx']['sites'][port2][site1]['errorlog']       = "#{node['nginx']['log_dir']}/#{site1}-error.log info"
default['phpstack']['demo']['nginx']['sites'][port2][site1]['customlog']      = "#{node['nginx']['log_dir']}/#{site1}-access.log combined"
default['phpstack']['demo']['nginx']['sites'][port2][site1]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['nginx']['sites'][port2][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port2][site1]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['nginx']['sites'][port2][site1]['deploy_key']     = '/root/.ssh/id_rsa'

# nginx site2
default['phpstack']['demo']['nginx']['sites'][port1][site2]['template']       = "nginx/sites/#{site2}-#{port1}.erb"
default['phpstack']['demo']['nginx']['sites'][port1][site2]['cookbook']       = 'phpstack'
default['phpstack']['demo']['nginx']['sites'][port1][site2]['server_name']    = site2
default['phpstack']['demo']['nginx']['sites'][port1][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['nginx']['sites'][port1][site2]['docroot']        = "/var/www/#{site2}/#{port1}"
default['phpstack']['demo']['nginx']['sites'][port1][site2]['errorlog']       = "#{node['nginx']['log_dir']}/#{site2}-error.log info"
default['phpstack']['demo']['nginx']['sites'][port1][site2]['customlog']      = "#{node['nginx']['log_dir']}/#{site2}-access.log combined"
default['phpstack']['demo']['nginx']['sites'][port1][site2]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['nginx']['sites'][port1][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port1][site2]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['nginx']['sites'][port1][site2]['deploy_key']     = '/root/.ssh/id_rsa'

default['phpstack']['demo']['nginx']['sites'][port2][site2]['template']       = "nginx/sites/#{site2}-#{port2}.erb"
default['phpstack']['demo']['nginx']['sites'][port2][site2]['cookbook']       = 'phpstack'
default['phpstack']['demo']['nginx']['sites'][port2][site2]['server_name']    = site2
default['phpstack']['demo']['nginx']['sites'][port2][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['nginx']['sites'][port2][site2]['docroot']        = "/var/www/#{site2}/#{port2}"
default['phpstack']['demo']['nginx']['sites'][port2][site2]['errorlog']       = "#{node['nginx']['log_dir']}/#{site2}-error.log info"
default['phpstack']['demo']['nginx']['sites'][port2][site2]['customlog']      = "#{node['nginx']['log_dir']}/#{site2}-access.log combined"
default['phpstack']['demo']['nginx']['sites'][port2][site2]['server_admin']   = 'demo@demo.com'
default['phpstack']['demo']['nginx']['sites'][port2][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port2][site2]['repository']     = 'https://github.com/rackops/php-test-app'
default['phpstack']['demo']['nginx']['sites'][port2][site2]['deploy_key']     = '/root/.ssh/id_rsa'
