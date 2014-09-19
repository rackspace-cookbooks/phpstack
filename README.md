# phpstack

## Supported Platforms

- CentOS 6.5
- Ubuntu 12.04
- Ubuntu 14.04

## Requirements

### Cookbooks

- `apache2`
- `application`
- `application_php`
- `apt`
- `build-essential`
- `chef-sugar`
- `database`
- `git`
- `memcached`
- `mongodb`
- `mysql`
- `mysql-multi`
- `newrelic`
- `newrelic_meetme_plugin`
-` nginx`
- `openssl`
- `pg-multi`
- `php`
- `php-fpm`
- `platformstack`
- `rabbitmq`
- `rackspace_gluster`
- `redis-multi`
- `varnish`
- `yum`
- `yum-ius`
- `yum-epel`

## Recipes

### default
- what it does
  - nothing
- toggles
  - nothing

### apache
- what it does
  - Creates sites coming from `node['phpstack']['apache']['sites']` array
  - Creates monitoring check for each site if `node[platformstack][cloud_monitoring]` is true
- toggles
  - can be disabled by setting `node['phpstack']['webserver_deployment']['enabled']` to false

### application_php
- what it does
  - installs php and some libraries
  - includes the nginx or apache recipe if `node['phpstack']['webserver']` is either apache or nginx
  - if glusterfs is set up via `node['rackspace_gluster']['config']['server']['glusters']` glusterfs will be set up as a client
  - deploys your apps, from attributes, depending on what `node['phpstack']['webserver']` is set to
    - deploys from `node['phpstack'][node['phpstack']['webserver']]['sites']`
  - creates a `/etc/phpstack.ini` file with authentication info for the other nodes in the environment
    - only finding mysql and rabbitmq nodes right now
  - creates a backup job that backs up `/var/www` by default
    - only runs if `node['phpstack']['rackspace_cloudbackup']['http_docroot']['enable']` is set
  - tags the node with the `php_app_node` tag
- toggles
  - application deployment can be disabled via the `node['phpstack']['code-deployment']['enabled']` flag

### gluster
- what it does
  - sets up glusterfs based on the `node['rackspace_gluster']['config']['server']['glusters']` attribute
    - this may involve some manual setup, it is glusterfs afterall

### memcache
- what it does
  - sets up memcache
  - sets up the memcache cloud monitoring plugin if enabled

### mongodb_standalone
- what it does
  - sets up mongodb from the 10gen repo

### mysql_add_drive
- what it does
  - formats /dev/xvde1 and will prepare it for the mysql datadir.
  - creates the mysql user and manages the /var/lib/mysql mountpoint

### mysql_base
- what it does
  - sets a random root mysql password if the default password would normally be set
  - sets up mysql
  - sets up a holland user if `node['holland']['enabled']`
  - sets up a monitoring mysql user and monitor if `node['platformstack']['cloud_monitoring']['enabled']`
  - allow app nodes in the environment to attempt to connect
  - auto-generates mysql databases and assiciated users/passwords for sites installed (can be disabled)
  - installs phpstack specific databases (will autogenerate the user and password if needed still)
- toggles
  -  `node['phpstack']['db-autocreate']['enabled']` controls database autocreation at a global level
  -  if the site has the `db_autocreate` attribute, it will control database autocreation for that site
- info
  - auto-generated databases are based on site name and port number the site is on, same for username

### mysql_holland
-  what it does
  -  installs holland
  -  will set up a backup job based on if you are running as a slave or not

### mysql_master
- what it does
  - sets up mysql master (runs the mysql_base recipe as well)
  - will allow slaves to connect (via iptables)

### mysql_slave
- what it does
  - sets up the mysql slave (runs the mysql_base recipe as well)
  - allows the master to connect (via iptables)

### newrelic
- what it does
  - sets up newrelic and the php agent for newrelic
  - sets up the following plugins (as needed)
    - memcache
    - rabbit
    - nginx

### nginx
- what it does
  - sets up the nginx vhosts as defined in `node['phpstack']['nginx']['sites']`
  - sets up the monitors for the for each vhost / port combo
- toggles
  - `node['phpstack']['webserver_deployment']['enabled']` controls whether this recipe runs

### postgresql_base
- what it does
  - sets up a basic postgresql server and the associated monitoring checks (if enabled)
- toggles
  - `node['platformstack']['cloud_monitoring']['enabled']` controls the monitoring checks

### postgresql_master
- what it does
  - sets up postgresql as a master
  - allows postgresql slaves to connect (via iptables)

### postgresql_slave
- what it does
  - sets up postgresql as a slave
  - allows the postgresql master to connect (via iptables)

### rabbitmq
- what it does
  - allows nodes tagged as `php_app_node` to connect (via iptables)
  - disables guest user
  - sets up the cloud monitoring plugin
  - sets up a monitoring user for rabbit (with password)
  - sets up rabbitmq vhost/user/password combinations for each vhost and port combination

### redis_base
- what it does
  - sets up redis (basic)
  - allows nodes tagged as `php_app_node` to connect (via iptables)
  - allows nodes tagged as `phpstack-redis` to connect (via iptables)

### redis_master
- what it does
  - sets up redis in a master capacity

### redis_sentinel
- what it does
  - sets up redis sentinel
  - allows nodes tagged as `php_app_node` to connect (via iptables)
  - allows nodes tagged as `phpstack-redis_sentinel` to connect (via iptables)
  - allows nodes tagged as `phpstack-redis` to connect (via iptables)

### redis_single
- what it does
  - sets up redis in a standalone capacity

### redis_slave
- what it does
  - sets up redis in a slave capacity

### varnish
- what it does
  - allows clients to connect to the varnish port (via iptables)
  - enables the cloud monitoring plugin for varnish
  - sets the default backend port to the first useful port it can find
  - sets up varnish if for multi backend load ballancing per vhost/port combination
- toggles
  - `node['varnish']['multi']` controls if varnish is simple or complex (multi backend or not)
    - it is also controled by if any backend nodes are found


## Data_Bags

No Data_Bag configured for this cookbook

## Attributes

### default

- `default['phpstack']['newrelic']['application_monitoring'] = ''`
  - controls if we allow newrelic to to do application monitoring
    - is set to `'true'` in the newrelic recipe
- `default['phpstack']['webserver'] = 'apache'`
  - sets the webserver want to use
    - you can set this to anything, but for acutally running a webserver we only support nginx and apache
    - you can set this to something like `'not_a_webserver'` and then use that namespace if you still want to deploy your application
- `default['phpstack']['ini']['cookbook'] = 'phpstack'`
  - sets where the `/etc/phpstack.ini` template is sourced from
- `default['phpstack']['mysql']['databases'] = []`
  - contains a list of databases to set up (along with users / passwords)
- `default['phpstack']['apache']['sites'] = []`
  - contains a list of ports and vhosts to set up for apache
- `default['phpstack']['nginx']['sites'] = []`
  - contains a list of ports and vhosts to set up for nginx
- `default['phpstack']['webserver_deployment']['enabled'] = true`
  - allows apache and/or nginx recipes to run
- `default['phpstack']['code-deployment']['enabled'] = true`
  - allows code deployment to run
- `default['phpstack']['db-autocreate']['enabled'] = true`
  - controls database autocreation for each site / port combination globally

### demo

contains attributes that used in a demo site, useful as an example of what to set to deploy a site

### gluster

contains attributes used in setting up gluster, node the commented out section, it helps to actually hard code these IPs

### monitoring

controls how cloud_monitoring is used within phpstack

### nginx

- `default['nginx']['default_site_enabled'] = false`
  - no need for the default site to be set up (as is default)
- `set['nginx']['init_style'] = 'upstart'`
  - useful on ubuntu...
- `default['nginx']['listen_ports'] = %w(80)`
  - need to set this up as a default for things like varnish
- `default['nginx']['default_root'] = '/var/www'`
  - we don't want sites going into `/var/www/nginx-default`

### php

- `default['php']['packages'] = []`
  - list of packages needed based on platform_family

### php_fpm

shouldn't really be messed with

### rabbitmq
- `default['phpstack']['rabbitmq']['passwords'] = {}`
  - sets the admin password for rabbitmq

### varnish
- `default['phpstack']['varnish']['multi'] = true`
  - allows us to use more complex logic for the varnish configuration

## Usage

### useful datastructures

- vhosts (apache here can be what you like, but to actually deploy a web server you need to set it to apache or nginx):
```json
{
    "phpstack": {
      "apache": {
        "user": "apache",
        "group": "apache",
        "sites": {
          80: {
            "example.com": {
              "template": "apache2/sites/example.com-80.erb",
              "cookbook": "phpstack",
              "server_name": "example.com",
              "server_aliases": [
                "www.example.com",
                "test.example.com"
              ],
              "docroot": "/var/www/example.com/80",
              "errorlog": "/var/log/apache/example.com-error.log",
              "customlog": "/var/log/apache/example.com-access.log combined",
              "allow_override": [
                "All"
              ],
              "loglevel": "warn",
              "server_admin": "test@example.com",
              "revision": "v1.0.1",
              "repository": "https://github.com/rackops/php-test-app",
              "deploy_key": "/root/.ssh/id_rsa"
            }
          }
        }
      }
    }
}
```

- applications (combine this with the vhost to deploy a full site)
```json
{
    "phpstack": {
      "apache": {
        "user": "apache",
        "group": "apache",
        "sites": {
          80: {
            "example.com": {
              "docroot": "/var/www/example.com/80",
              "revision": "v1.0.1",
              "repository": "https://github.com/rackops/php-test-app",
              "deploy_key": "/root/.ssh/id_rsa"
            }
          }
        }
      }
    }
}
```

- databases
```json
{
    "phpstack": {
      "mysql": {
        "example_db": {
          "user": "exampleuser",
          "password": "do_not_use_this_password"
        }
      }
    }
}
```

### phpstack

- single node (app and db):
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::mysql_base]",
      "recipe[phpstack::application_php]"
    ]
}
```
- app node - standalone app:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::application_php]"
    ]
}
```
- MySQL DB Single Node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",  
      "recipe[phpstack::mysql_base]"
    ]
}
```

- MySQL DB Master Node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",  
      "recipe[phpstack::mysql_master]"
    ]
}
```

- MySQL DB Slave Node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::mysql_slave]"
    ]
}
```


- PostgreSQL cluster for phpstack

Ensure the following attributes are set within environment or wrapper cookbook

```ruby
node['postgresql']['version'] = '9.3'
node['postgresql']['password'] = 'postgresdefault'
node['pg-multi']['replication']['password'] = 'useagudpasswd'
node['pg-multi']['master_ip'] = '1.2.3.4'
node['pg-multi']['slave_ip'] = ['5.6.7.8']

# Depending on OS one of the following two must be set:
node['postgresql']['enable_pdgd_yum'] = true  # (Redhat Family)
node['postgresql']['enable_pdgd_apt'] = true  # (Debian Family)
```

- Master PostgreSQL node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::postgresql_master]"
    ]
}
```
- Slave PostgreSQL node:
```json
{
    "run_list": [
      "recipe[platformstack::default]",
      "recipe[rackops_rolebook::default]",
      "recipe[phpstack::postgresql_slave]"
    ]
}
```

## New Relic Monitoring

To configure New Relic, make sure the `node['newrelic']['license']` attribute is set and include the `platformstack` cookbook in your run_list.  You can also run the `phpstack::newrelic` recipe for some more advanced monitors.


# Contributing

https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md


# Authors
Authors:: Matthew Thode <matt.thode@rackspace.com>
