# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: default_unless
#
# Copyright 2014, Rackspace US, Inc.
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

stackname = 'phpstack'

# general stuff
node.default_unless[node[stackname]['webserver']]['user'] = 'nobody'
node.default_unless[node[stackname]['webserver']]['group'] = 'nobody'
node.default_unless[stackname][node[stackname]['webserver']]['sites'] = {}

# server specific stuff
node[stackname][node[stackname]['webserver']]['sites'].each do |port, sites|
  sites.each do |site_name, site_opts|
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['revision'] = 'master'
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['repository'] = 'https://github.com/rackops/php-test-app'
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['deploy_key'] = '/root/.ssh/id_rsa'
    # now for some apache/nginx specific stuff
    next unless %w(apache nginx).include?(node[stackname]['webserver'])
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['cookbook'] = stackname
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['server_name'] = site_name
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['server_alias'] = ["test.#{site_name}", "www.#{site_name}"]
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['docroot'] = "/var/www/#{site_name}/#{port}"
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['customlog'] =
      "#{node[node[stackname]['webserver']]['log_dir']}/#{site_name}-#{port}-access.log combined"
    node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['server_admin'] = 'demo@demo.com'
    if node[stackname]['webserver'] == 'apache'
      node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['template'] = "apache2/sites/#{site_name}-#{port}.erb"
      node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['errorlog'] = # ~FC047
        "#{node['apache']['log_dir']}/#{site_name}-#{port}-error.log"
      node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['allow_override'] = ['All']
      node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['loglevel'] = 'warn'
    elsif node[stackname]['webserver'] == 'nginx'
      node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['template'] = "nginx/sites/#{site_name}-#{port}.erb"
      node.default_unless[stackname][node[stackname]['webserver']]['sites'][port][site_name]['errorlog'] = # ~FC047
        "#{node['nginx']['log_dir']}/#{site_name}-#{port}-error.log info"
    end
  end
end
