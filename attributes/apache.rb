# Encoding: utf-8
#
# Cookbook Name:: lampstack
# Recipe:: apache
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

site1 = 'example.com'
version1 = '0.0.2'

node.default['apache']['sites'][site1]['port']         = 80
node.default['apache']['sites'][site1]['cookbook']     = 'lampstack'
node.default['apache']['sites'][site1]['template']     = "apache2/sites/#{site1}.erb"
node.default['apache']['sites'][site1]['tarfile']      = "https://github.com/rackops/php-test-app/archive/v#{version1}.tar.gz"
node.default['apache']['sites'][site1]['sha512sum']    = 'e2cbfbaabe3f5b7381b0a29aa6f7e595d71767b5292d943521de9512931f9e75'
node.default['apache']['sites'][site1]['version']      = version1
node.default['apache']['sites'][site1]['server_name']  = site1
node.default['apache']['sites'][site1]['server_alias'] = "test.#{site1} www.#{site1}"
node.default['apache']['sites'][site1]['docroot']      = "/var/www/#{site1}/current"
node.default['apache']['sites'][site1]['errorlog']     = "#{node['apache']['log_dir']}/#{site1}-error.log"
node.default['apache']['sites'][site1]['customlog']    = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
node.default['apache']['sites'][site1]['loglevel']     = 'warn'
node.default['apache']['sites'][site1]['server_admin'] = 'demo@demo.com'
node.default['apache']['sites'][site1]['revision'] = 'master'
node.default['apache']['sites'][site1]['repository'] = 'https://github.com/panique/php-login-minimal'
node.default['apache']['sites'][site1]['deploy_key'] = '/root/.ssh/id_rsa'
