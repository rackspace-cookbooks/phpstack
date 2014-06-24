# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Attributes:: provisioner
#
# Copyright 2014, Rackspace Hosting
#
default['phpstack']['provisioner']['region'] = 'ord'
default['phpstack']['provisioner']['key_name'] = 'metal-key'
default['phpstack']['provisioner']['app_nodes'] = 2
default['phpstack']['provisioner']['flavor_id'] = 'performance1-1'
default['phpstack']['provisioner']['image_id'] = 'ffa476b1-9b14-46bd-99a8-862d1d94eb7a'
