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

include_recipe 'chef-sugar'

# If not defined drop out
if node.deep_fetch('apache', 'sites').nil?
  return 0
elsif node.deep_fetch('apache', 'sites').values[0].nil?
  return 0
end

if rhel?
  include_recipe 'yum-epel'
  include_recipe 'yum-ius'
end

# Include the necessary recipes.
%w(
  platformstack::monitors
  platformstack::iptables
  apt
  apache2
  apache2::mod_php5
  apache2::mod_ssl
).each do |recipe|
  include_recipe recipe
end

# Initialize listen_ports
listen_ports = []

# Create the sites.
node['apache']['sites'].each do |site_name, site_opts|
  listen_ports.push(site_opts['port']) unless listen_ports.include? site_opts['port']

  add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{site_opts['port']} -j ACCEPT", 100, 'Allow access to apache') unless site_opts['port'].nil?

  web_app site_name do
    port site_opts['port']
    cookbook site_opts['cookbook']
    template site_opts['template']
    server_name site_opts['server_name']
    server_aliases site_opts['server_alias']
    docroot site_opts['docroot']
    allow_override site_opts['allow_override']
    errorlog site_opts['errorlog']
    customlog site_opts['customlog']
    loglevel site_opts['loglevel']
  end
  template "http-monitor-#{site_opts['server_name']}" do
    cookbook 'phpstack'
    source 'monitoring-remote-http.yaml.erb'
    path "/etc/rackspace-monitoring-agent.conf.d/#{site_opts['server_name']}-http-monitor.yaml"
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      http_port: site_opts['port'],
      server_name: site_opts['server_name']
    )
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
    only_if { node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled') }
    only_if { node.deep_fetch('phpstack', 'flags', 'monitoring', 'enabled') && node.deep_fetch('phpstack', 'flags', 'monitoring', 'cloudmonitoring') }
  end
end

# Set listen_ports attribute
node.set['apache']['listen_ports'] = listen_ports
