#
# Cookbook Name:: phpstack
# Recipe:: postgresql_base
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'
include_recipe 'platformstack::monitors'
include_recipe 'stack_commons::postgresql_base'
