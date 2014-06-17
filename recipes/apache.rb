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

# Include the necessary recipes.
%w(platformstack::monitors platformstack::iptables apt apache2::default apache2::mod_php5).each do |recipe|
  include_recipe recipe
end

# Create the sites.
node['apache']['sites'].each do | site_name |
  site_name = site_name[0]
  site = node['apache']['sites'][site_name]

  add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{site['port']} -j ACCEPT", 100, 'Allow access to apache')

  web_app site_name do
    port site['port']
    cookbook site['cookbook']
    template site['template']
    server_name site['server_name']
    server_alias site['server_alias']
    docroot site['docroot']
    errorlog site['errorlog']
    customlog site['customlog']
    loglevel site['loglevel']
  end
  if node['platformstack']['cloud_monitoring']['enabled'] == true
    template "http-monitor-#{site['server_name']}" do
      cookbook 'lampstack'
      source 'monitoring-remote-http.yaml.erb'
      path "/etc/rackspace-monitoring-agent.conf.d/#{site['server_name']}-http-monitor.yaml"
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        apache_port: site['port'],
        server_name: site['server_name']
      )
      notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
      action 'create'
    end
  end
end
