#
# Cookbook Name:: wrapper
# Recipe:: default
#
# Copyright 2014, Rackspace
#
#
%w(
  phpstack::mysql_base
  phpstack::postgresql_base
  phpstack::mongodb_standalone
  phpstack::memcache
  phpstack::varnish
  phpstack::rabbitmq
  phpstack::redis_single
  phpstack::application_php
).each do |recipe|
  include_recipe recipe
end
