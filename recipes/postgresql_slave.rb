#
# Cookbook Name:: phpstack
# Recipe:: postgresql_slave
#
# Copyright 2014, Rackspace
#

include_recipe 'phpstack::postgresql_base'
include_recipe 'pg-multi::pg_slave'
include_recipe 'platformstack::iptables'

add_iptables_rule('INPUT', "-p tcp --dport #{node['postgresql']['config']['port']} -s #{node['pg-multi']['master_ip']} -j ACCEPT", 9243, 'allow master to connect to slaves')
