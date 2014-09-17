# phpstack Cookbook
-------------------------------

Supported Platforms
-------------------
* CentOS 6.5
* Ubuntu 12.04

Requirements
------------
#### Cookbooks

* `git`
* `rackops_rolebook`  
* `yum`  
* `yum-epel`  
* `yum-ius`
* `apt`  
* `php`  
* `php::ini`  
* `php::module_mysql`  
* `chef-sugar`  
* `platformstack::monitors`  
* `platformstack::iptables`  
* `apache2`  
* `apache2::mod_php5`  
* `database::mysql`  
* `mysql:server`  
* `mysql-multi`
* `pg-multi`  
* `java`  
* `varnish`  
* `rabbitmq`  
* `varnish`

Recipes
----------
#### default
#### apache
Includes recipes: platformstack::monitors platformstack::iptables apt apache2::default apache2::mod_php5
Creates sites coming from node['apache']['sites'] array
Creates monitoring check for each site if node[platformstack][cloud_monitoring] = enabled
#### application_php
Includes recipes: git, yum, yum-epel, yum-ius, apt, php, php::ini, php::module_mysql, phpstack::apache, phpstack::php_fpm, chef-sugar
If gluster is part of the environment attributes, installs the utils and mount it to /var/www (the default of node['apache']['docroot_dir'] on debian/ubuntu)
Creates application_deployment configuration, checking out the code from node['apache']['sites']['repository'] and putting into the path specified in node['apache']['sites']['docroot']
Creates a configuration file for applications using variables for mysql_master node and rabbitmq node and placing this file in /etc/phpstack.ini
#### gluster
Includes recipe chef-sugar
Gets the number of nodes to be part of the cluster
Creates rules to add to iptables web nodes access to gluster
Installs rackspace_gluster cookbook
#### memcache
Installs memcached
#### mongodb_standalone
Installs mongodb:10gen_repo
Installs mongodb::default
#### mysql_add_drive
Formats /dev/xvde1 and will prepare it for the mysql datadir.
Creates mysql user
Creates /var/lib/mysql directory
Mounts /dev/xvde1 on /var/lib/mysql
#### mysql_base
Includes recipe database::mysql, platformstack::monitors, mysql::server, mysql-multi::mysql_base
Set mysql passwords dynamically
Adds mysql holland user if node[holland] = enabled
Adds mysql monitoring user
Creates mysql-monitor template if node[platformstack][cloud_monitoring] = enabled
Creates an iptables rule for application_php nodes in order to connect to this one.
#### mysql_holland
Setup an apt or yum repository for holland
Installs needed packages (holland and holland-mysqldump)
Verifies if this server is a slave or standalone
Setup a cronjob based on holland attributes
#### mysql_master
Includes recipe phpstack::mysql_base, mysql-multi::mysql_master, chef-sugar
Creates mysql-monitor template if node[platformstack][cloud_monitoring] = enabled
Creates an user with select, update and insert permissions, for each server that matches application_php recipe within the specified environment using site_name as username and node['apache']['sites'][site_name]['mysql_password'] for password.
Can configure multiple databases and users with passwords from node['apache']['sites'][site]['databases'] array
#### mysql_slave
Includes recipe phpstack::mysql_base and mysql-multi::mysql_slave
#### php_fpm
Includes recipe php_fpm
#### postgresql_base
Creates base postgresql server in standalone mode
#### postgresql_master
Creates postgresql server in master node configuration
#### postgresql_slave
Creates posgresql server in slave node configuration
#### rabbitmq
Includes recipe platformstack::iptables
Creates an iptables rule for application_php nodes in order to connect to this one.
Disables the default user
Creates the rabbit vhost
Set random App Passwords
Add the queue per site defined in node['apache']['sites'] array
#### redis
Includes recipe redisio
Installs redis-server using attributes
#### varnish
Installs varnish recipe
#### yum
Includes recipe yum
Installs yum-epel and IUS repository



Data_Bag
----------

No Data_Bag configured for this cookbook


Attributes
----------

#### monitoring.rb

* default['phpstack']['cloud_monitoring']['remote_http']['disabled'] = false
* default['phpstack']['cloud_monitoring']['remote_http']['alarm'] = false
* default['phpstack']['cloud_monitoring']['remote_http']['period'] = 60
* default['phpstack']['cloud_monitoring']['remote_http']['timeout'] = 15
* default['phpstack']['cloud_monitoring']['agent_mysql']['disabled'] = false
* default['phpstack']['cloud_monitoring']['agent_mysql']['alarm'] = false
* default['phpstack']['cloud_monitoring']['agent_mysql']['period'] = 60
* default['phpstack']['cloud_monitoring']['agent_mysql']['timeout'] = 15
* default['phpstack']['cloud_monitoring']['agent_mysql']['user'] = 'raxmon-agent'
* default['phpstack']['cloud_monitoring']['agent_mysql']['password'] = nil

#### php.rb

* default['phpstack']['ini']['cookbook'] = 'phpstack'
  * Indicates the cookbook where to get ini template to override

#### rabbitmq.rb
* default['phpstack']['rabbitmq']['passwords'] = {}
  * Indicates admin password for rabbitmq


Usage
-----

#### phpstack

* single node (app and db)
	Include recipe `platformstack::default`, `rackops_rolebook::default`, `phpstack::mysql_base`, `phpstack::application_php` in your node's `run_list`:
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
* single app node - standalone db node
  DB Node: Include recipe `platformstack::default`, `rackops_rolebook::default`, `phpstack::mysql_base` in your node's `run_list`:
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

  App Node: Include recipe `platformstack::default`, `rackops_rolebook::default`, `phpstack::application_php` in your node's `run_list`:
```json
{
  "run_list": [
  "recipe[platformstack::default]",
  "recipe[rackops_rolebook::default]",
  "recipe[phpstack::application_php]"
  ]
}
```
* single app node - multi db node

Ensure the following attributes are set within environment or wrapper cookbook.

```
['mysql']['server_repl_password'] = 'rootlogin'
['mysql']['server_repl_password'] = 'replicantlogin'
['mysql-multi']['master'] = '1.2.3.4'
['mysql-multi']['slaves'] = ['5.6.7.8']
```

MySQL DB Master Node: Include recipe `platformstack::default`, `rackops_rolebook::default`, `phpstack::mysql_master` in your node's `run_list`:
```json
{
  "run_list": [
  "recipe[platformstack::default]",
  "recipe[rackops_rolebook::default]",  
  "recipe[phpstack::mysql_master]"
  ]
}
```

MySQL DB Slave Node: Include recipe `platformstack::default`, `rackops_rolebook::default`, `phpstack::mysql_slave`, `phpstack::mysql_slave` in your node's `run_list`:
```json
{
  "run_list": [
  "recipe[platformstack::default]",
  "recipe[rackops_rolebook::default]",
  "recipe[phpstack::mysql_slave]",
  "recipe[phpstack::application_php]"
  ]
}
```

App Node: Include recipe `platformstack::default`, `rackops_rolebook::default`, `phpstack::application_php` in your node's `run_list`:
```json
{
  "run_list": [
  "recipe[platformstack::default]",
  "recipe[rackops_rolebook::default]",
  "recipe[phpstack::application_php]"
  ]
}
```

* Building a PostgreSQL cluster for phpstack.

Ensure the following attributes are set within environment or wrapper cookbook.

```
['postgresql']['version'] = '9.3'
['postgresql']['password'] = 'postgresdefault'
['pg-multi']['replication']['password'] = 'useagudpasswd'
['pg-multi']['master_ip'] = '1.2.3.4'
['pg-multi']['slave_ip'] = ['5.6.7.8']

Depending on OS one of the following two must be set:
['postgresql']['enable_pdgd_yum'] = true  (Redhat Family)
['postgresql']['enable_pdgd_apt'] = true  (Debian Family)
```

Master Postgresql node:
```json
{
  "run_list": [
  "recipe[platformstack::default]",
  "recipe[rackops_rolebook::default]",
  "recipe[phpstack::postgresql_master]"
  ]
}
```
Slave node:
```json
{
  "run_list": [
  "recipe[platformstack::default]",
  "recipe[rackops_rolebook::default]",
  "recipe[phpstack::postgresql_slave]"
  ]
}
```

New Relic Monitoring
--------------------

To configure New Relic, make sure the `node['newrelic']['license']`
attribute is set and include the `platformstack` cookbook in your run_list.

New Relic monitoring plugins can be configured by including the `newrelic::meetme-plugin`
recipe in your run_list and setting the following attribute hash in an application
cookbook:

```ruby
node.override['newrelic']['meetme-plugin']['services'] = {
  "memcached": {
    "name": "localhost",
    "host":  "host",
    "port":  11211
  }
}
```

More examples can be found [here](https://github.com/escapestudios-cookbooks/newrelic#meetme-pluginrb)
and [here](https://github.com/MeetMe/newrelic-plugin-agent#configuration-example).

Contributing
------------

https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md


Authors
-------
Authors:: Rackspace DevOps (devops@rackspace.com)
