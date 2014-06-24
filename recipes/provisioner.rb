# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: provisioner
#
# Copyright 2014, Rackspace Hosting
#
case node['platform']
when 'debian', 'ubuntu'
  node.set['apt']['compile_time_update'] = true
  include_recipe 'apt'
when 'redhat', 'centos', 'fedora', 'amazon', 'scientific'
  include_recipe 'yum'
end

node.set['build-essential']['compile_time'] = true
include_recipe 'build-essential'

chef_gem 'chef-metal' do
  version '0.12.1'
  action 'install'
end

chef_gem 'chef-metal-fog' do
  version '0.6.1'
  action 'install'
end

require 'chef_metal'
require 'chef_metal_fog'
require 'cheffish'
require 'fog'

# Get credentials
rackspace = Chef::DataBagItem.load('secrets', 'rackspacecloud')
username = rackspace['username']
apikey = rackspace['apikey']

with_driver 'fog:Rackspace:https://identity.api.rackspacecloud.com/v2.0',
            compute_options: {
              rackspace_api_key: apikey,
              rackspace_username: username,
              rackspace_region: node['phpstack']['provisioner']['region']
            }

# You need to generate a keypair in ~/.ssh for use with Metal
fog_key_pair node['phpstack']['provisioner']['key_name']

with_machine_options ssh_username: 'root',
                     bootstrap_options: {
                       key_name: node['phpstack']['provisioner']['key_name'],
                       flavor_id: node['phpstack']['provisioner']['flavor_id'],
                       image_id: node['phpstack']['provisioner']['image_id']
                     }

# Read Chef Config from knife.rb
with_chef_server Chef::Config[:chef_server_url],
                 client_name: Chef::Config[:node_name],
                 signing_key_filename: Chef::Config[:client_key]

machine 'phpstack-mysql-master' do
  chef_environment '_default'
  recipe 'apt'
  recipe 'platformstack::default'
  recipe 'rackops_rolebook::default'
  recipe 'phpstack::mysql_master'
  recipe 'phpstack::demo'
  attributes(
    platformstack: {
      cloud_monitoring: {
        enabled: 'true'
      }
    },
    rackspace: {
      cloudbackup: {
        enabled: 'true'
      },
      cloud_credentials: {
        username: username,
        api_key: apikey
      }
    }
  )
end

machine 'phpstack-mysql-slave' do
  chef_environment '_default'
  recipe 'apt'
  recipe 'platformstack::default'
  recipe 'rackops_rolebook::default'
  recipe 'phpstack::mysql_slave'
  recipe 'phpstack::demo'
  attributes(
    platformstack: {
      cloud_monitoring: {
        enabled: 'true'
      }
    },
    rackspace: {
      cloudbackup: {
        enabled: 'true'
      },
      cloud_credentials: {
        username: username,
        api_key: apikey
      }
    }
  )
end

num_app = node['phpstack']['provisioner']['app_nodes']

1.upto(num_app) do |i|
  machine "phpstack-app-#{i}" do
    chef_environment '_default'
    recipe 'apt'
    recipe 'platformstack::default'
    recipe 'rackops_rolebook::default'
    recipe 'phpstack::application_php'
    recipe 'phpstack::demo'
    attributes(
      platformstack: {
        cloud_monitoring: {
          enabled: 'true'
        }
      },
      rackspace: {
        cloudbackup: {
          enabled: 'true'
        },
        cloud_credentials: {
          username: username,
          api_key: apikey
        }
      }
    )
  end
end
