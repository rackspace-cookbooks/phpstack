#
# Cookbook Name:: phpstack
# Recipe:: postgresql_slave
#
# Copyright 2014, Rackspace
#

include_recipe 'phpstack::postgresql_base'

include_recipe 'pg-multi::pg_slave'
