lampstack
=========

LAMP Stack Development Repository

## Role usage
```
chef_type:           role
default_attributes:
description:         
env_run_lists:
json_class:          Chef::Role
name:                lampstack
override_attributes:
run_list:
  recipe[platformstack::default]
  recipe[rackops_rolebook::default]
  recipe[lampstack::mysql_standalone]
  recipe[lampstack::application_php]
```

## Knife bootstrap usage
```
knife rackspace server create --no-tcp-test-ssh --ssh-wait-timeout 120  --image a4286a42-137c-46ce-a796-dbd2b12a078c --flavor performance1-1 -E test -r "role[lampstack]" -N martin-lampstack-1204-6
```
