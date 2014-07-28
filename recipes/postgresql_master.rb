#
# Cookbook Name:: phpstack
# Recipe:: postgresql_master
#
# Copyright 2014, Rackspace
#

include_recipe 'phpstack::postgresql_base'

include_recipe 'pg-multi::pg_master'
