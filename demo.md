## Notes

If using the gluster recipe you must fill the `['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']` hash with your gluster Nodes IPs, check the commented out section of attributes/gluster.rb

## Build Cloud Servers
    nova boot phpstack-web-1 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot phpstack-web-2 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

    nova boot phpstack-mysql-master --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot phpstack-mysql-slave --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

#### check what the private IPs are for the mysql master and slave, we will need them soon.

    nova show phpstack-mysql-master | grep private\ network | awk '{print $5}'
    nova show phpstack-mysql-slave | grep private\ network | awk '{print $5}'

## Edit the Environment

    "default_attributes": {
      "mysql": {
        "master": "192.0.2.10",
        "slave": [
          "192.0.2.20"
        ]
      },
      "rackspace": {
        "cloud_credentials": {
          "username": "example_user",
          "api_key": "example_api_key"
        }
      }
    }

## Create the Roles

### php app node

    knife role edit phpstack-app
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::application_php]",
      "recipe[phpstack::demo]"
    ],

### mysql master

    knife role edit phpstack-mysql-master
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::mysql_master]",
      "recipe[phpstack::demo]"
    ],

### mysql slave

    knife role edit phpstack-mysql-slave
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::mysql_slave]",
      "recipe[phpstack::demo]"
    ],

## Bootstrap the nodes

    knife bootstrap 0.0.0.0 -N phpstack-app-1 -x root -r 'role[phpstack-app]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-app-2 -x root -r 'role[phpstack-app]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-mysql-master -x root -r 'role[phpstack-mysql-master]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-mysql-slave -x root -r 'role[phpstack-mysql-slave]' -E test

