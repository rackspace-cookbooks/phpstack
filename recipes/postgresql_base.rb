#
# Cookbook Name:: phpstack
# Recipe:: postgresql_base
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'
include_recipe 'platformstack::iptables'
include_recipe 'platformstack::monitors'

include_recipe 'pg-multi'

# allow traffic to postgresql port for local addresses only
add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{node['postgresql']['config']['port']} -j ACCEPT", 9999, 'Open port for postgresql')
