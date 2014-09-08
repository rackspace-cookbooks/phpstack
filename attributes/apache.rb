# Encoding: utf-8
#
# Cookbook Name:: phpstack
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

include_attribute 'phpstack::demo'

lazy do
  if node['phpstack']['demo']['enabled']
    site1 = 'example.com'
    version1 = '0.0.9'

    default['apache']['sites'][site1]['port']         = 80
    default['apache']['sites'][site1]['cookbook']     = 'phpstack'
    default['apache']['sites'][site1]['template']     = "apache2/sites/#{site1}.erb"
    default['apache']['sites'][site1]['server_name']  = site1
    default['apache']['sites'][site1]['server_alias'] = ["test.#{site1}", "www.#{site1}"]
    default['apache']['sites'][site1]['docroot']      = "%{node['apache']['docroot_dir']}/#{site1}"
    default['apache']['sites'][site1]['allow_override'] = ['All']
    default['apache']['sites'][site1]['errorlog']     = "%{node['apache']['log_dir']}/#{site1}-error.log"
    default['apache']['sites'][site1]['customlog']    = "%{node['apache']['log_dir']}/#{site1}-access.log combined"
    default['apache']['sites'][site1]['loglevel']     = 'warn'
    default['apache']['sites'][site1]['server_admin'] = 'demo@demo.com'
    default['apache']['sites'][site1]['revision'] = "v#{version1}"
    default['apache']['sites'][site1]['repository'] = 'https://github.com/rackops/php-test-app'
    default['apache']['sites'][site1]['deploy_key'] = '/root/.ssh/id_rsa'
  end
end
