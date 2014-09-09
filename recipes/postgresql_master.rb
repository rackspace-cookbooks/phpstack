#
# Cookbook Name:: phpstack
# Recipe:: postgresql_master
#
# Copyright 2014, Rackspace
#

include_recipe 'phpstack::postgresql_base'
include_recipe 'pg-multi::pg_master'
include_recipe 'platformstack::iptables'

node['pg-multi']['slave_ip'].each do |slave|
  add_iptables_rule('INPUT', "-p tcp --dport #{node['postgresql']['config']['port']} -s #{slave} -j ACCEPT", 9243, 'allow slaves to connect to master')
end
