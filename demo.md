# Build Cloud Servers
    nova boot lampstack-web-1 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot lampstack-web-2 --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

    nova boot lampstack-mysql-master --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key
    nova boot lampstack-mysql-slave --poll --image "ffa476b1-9b14-46bd-99a8-862d1d94eb7a" \
    --flavor "performance1-1" --key-name my-ssh-key

## check what the private IPs are for the mysql master and slave, we will need them soon.

    nova show lampstack-mysql-master | grep private\ network | awk '{print $5}'
    nova show lampstack-mysql-slave | grep private\ network | awk '{print $5}'

# Edit the Environment

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

# Create the Roles

## php app node

    knife role edit lampstack-app
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[lampstack::application_php]",
      "recipe[lampstack::demo]"
    ],

## mysql master

    knife role edit lampstack-mysql-master
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[lampstack::mysql_master]",
      "recipe[lampstack::demo]"
    ],

## mysql slave

    knife role edit lampstack-mysql-slave
    
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[lampstack::mysql_master]",
      "recipe[lampstack::demo]"
    ],

# Bootstrap the nodes

    knife bootstrap 0.0.0.0 -N lampstack-app-1 -x root -r 'role[lampstack-app]' -E test
    knife bootstrap 0.0.0.0 -N lampstack-app-2 -x root -r 'role[lampstack-app]' -E test
    knife bootstrap 0.0.0.0 -N lampstack-mysql-master -x root -r 'role[lampstack-mysql-master]' -E test
    knife bootstrap 0.0.0.0 -N lampstack-mysql-slave -x root -r 'role[lampstack-mysql-slave]' -E test

