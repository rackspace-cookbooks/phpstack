## Notes

If using the gluster recipe you must fill the `['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']` hash with your gluster Nodes IPs, check the commented out section of attributes/gluster.rb

## Add your ssh key
    nova keypair-add my-ssh-key --pub-key /path/to/pub/key

## Build Cloud Servers
    nova boot phpstack-web-1 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot phpstack-web-2 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

    nova boot phpstack-mysql-master --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot phpstack-mysql-slave --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

    nova boot phpstack-gluster-1 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot phpstack-gluster-2 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

#### create the block storage

    nova volume-create --display-name phpstack-gluster-1 --volume-type SATA 100
    nova volume-create --display-name phpstack-gluster-2 --volume-type SATA 100

#### get the volume IDs

    nova volume-show phpstack-gluster-1 | grep ' id' | awk '{print $4}'
    nova volume-show phpstack-gluster-2 | grep ' id' | awk '{print $4}'

#### attach the volumes to the servers

    nova volume-attach phpstack-gluster-1 GLUSTER_1_VOLUME_ID /dev/xvdd
    nova volume-attach phpstack-gluster-2 GLUSTER_2_VOLUME_ID /dev/xvdd

#### check what the private IPs are for the mysql master and slave, we will need them soon.

    nova show phpstack-mysql-master | grep private\ network | awk '{print $5}'
    nova show phpstack-mysql-slave | grep private\ network | awk '{print $5}'

#### check the private IPs for gluster
    nova show phpstack-gluster-1 | grep private\ network | awk '{print $5}'
    nova show phpstack-gluster-2 | grep private\ network | awk '{print $5}'

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
      },
      "rackspace_gluster": {
        "config": {
          "server": {
            "glusters": {
              "Gluster Cluster 1": {
                "nodes": {
                  "phpstack-gluster-1": {
                    "ip": "192.0.2.5",
                    "block_device": "/dev/xvdd",
                    "mount_point": "/mnt/brick0",
                    "brick_dir": "/mnt/brick0/brick"
                  },
                  "phpstack-gluster-2": {
                    "ip": "192.0.2.6",
                    "block_device": "/dev/xvdd",
                    "mount_point": "/mnt/brick0",
                    "brick_dir": "/mnt/brick0/brick"
                  }
                }
              }
            }
          }
        }
      }
    }

## Create the Roles

### php app node

    knife role edit phpstack-app
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::application_php]"
    ],

### mysql master

    knife role edit phpstack-mysql-master
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::mysql_master]"
    ],

### mysql slave

    knife role edit phpstack-mysql-slave
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::mysql_slave]"
    ],

### gluster node

    knife role edit phpstack-gluster

    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[lampstack::gluster]"
    ],


## Bootstrap the nodes

    knife bootstrap 0.0.0.0 -N phpstack-app-1 -x root -r 'role[phpstack-app]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-app-2 -x root -r 'role[phpstack-app]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-mysql-master -x root -r 'role[phpstack-mysql-master]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-mysql-slave -x root -r 'role[phpstack-mysql-slave]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-gluster-1 -x root -r 'role[phpstack-gluster]' -E test
    knife bootstrap 0.0.0.0 -N phpstack-gluster-2 -x root -r 'role[phpstack-gluster]' -E test

### reconverge and restart the gluster volume

This is needed because gluster doesn't allow the IPs it allows to connect to the volume to be set dynamically.

So, on the gluster servers, run the following.

    chef-client
    echo yes | gluster volume stop vol0 && gluster volume start vol0
