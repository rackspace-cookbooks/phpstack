#
# Cookbook Name:: phpstack
# Recipe:: postgresql_base
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'
include_recipe 'platformstack::monitors'
include_recipe 'pg-multi'

directory '/usr/lib/rackspace-monitoring-agent/plugins/' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

remote_file '/usr/lib/rackspace-monitoring-agent/plugins/pg_check.py' do
  owner 'root'
  group 'root'
  mode 00755
  source 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/pg_check.py'
  only_if { node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled') }
end

template '/etc/rackspace-monitoring-agent.conf.d/pg-monitor.yaml' do
  cookbook 'phpstack'
  source 'pg_monitor.erb'
  owner 'root'
  group 'root'
  mode 00600
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action :create
  only_if { node.deep_fetch('platformstack', 'cloud_monitoring', 'enabled') }
end
