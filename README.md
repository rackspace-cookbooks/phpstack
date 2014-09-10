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

#### apache.rb
* site1 = 'example.com'
  * Indicate the fqdn of the site number 1
* node.default['apache']['sites'][site1]['port']         = 80
  * Indicates what port should be this site listening on
* node.default['apache']['sites'][site1]['cookbook']     = 'phpstack'
  * Indicates the name of the cookbook to get templates from
* node.default['apache']['sites'][site1]['template']     = "apache2/sites/#{site1}.erb"
  * Indicates template file location for this site
* node.default['apache']['sites'][site1]['server_name']  = site1
  * Indicates server_name variable to be used in template file
* node.default['apache']['sites'][site1]['server_alias'] = ["test.#{site1}", "www.#{site1}"]
  * Indicates server_alias variable to be used in template file
* node.default['apache']['sites'][site1]['docroot']      = "/var/www/#{site1}"
  * Indicates docroot variable to be used in template file
* node.default['apache']['sites'][site1]['allow_override'] = ['All']
  * Indicates allow_override variable to be used in template file
* node.default['apache']['sites'][site1]['errorlog']     = "#{node['apache']['log_dir']}/#{site1}-error.log"
  * Indicates errorlog variable to be used in template file
* node.default['apache']['sites'][site1]['customlog']    = "#{node['apache']['log_dir']}/#{site1}-access.log combined"
  * Indicates customlog variable to be used in template file
* node.default['apache']['sites'][site1]['loglevel']     = 'warn'
  * Indicates loglevel variable to be used in template file
* node.default['apache']['sites'][site1]['server_admin'] = 'demo@demo.com'
  * Indicates server_admin variable to be used in template file
* node.default['apache']['sites'][site1]['revision'] = "v#{version1}"
  * Indicates revision variable to be used to deploy this site files
* node.default['apache']['sites'][site1]['repository'] = 'https://github.com/rackops/php-test-app'
  * Indicates repository variable to be used to deploy this site
* node.default['apache']['sites'][site1]['deploy_key'] = '/root/.ssh/id_rsa'
  * Indicates deploy_key variable to be used when getting data from repository
* node.default['apache']['sites'][site1]['databases'][site1]['mysql_user'] = site1
  * Indicates a database and database user to be configured
* node.default['apache']['sites'][site1]['databases'][site1]['mysql_password'] = ''
  * Indicates the password to configure for database user with blank being random

#### gluster.rb

* default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1'] = {}
* default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['volume'] = 'vol0'

#### holland.rb

* default['holland']['enabled'] = false
  * Defines if holland is enabled or not in this node
* default['holland']['password'] = 'notagudpassword'
  * Defines the password for holland user in mysql database
* default['holland']['cron']['day'] = '*'
  * Defines day for backup
* default['holland']['cron']['hour'] = '3'
  * Defines hour for backup
* default['holland']['cron']['minute'] = '12'
  * Defines minute for backup

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

#### mysql.rb

* default['mysql-multi']['master'] = ''
* default['mysql-multi']['slaves'] = []
* default['mysql-multi']['slave_user'] = 'replicant'

#### php.rb

* default['php']['packages'] = []
  * List of packages needed based on platform_family
* default['phpstack']['ini']['cookbook'] = 'phpstack'
  * Indicates the cookbook where to get ini template to override

#### php_fpm.rb
* default['php-fpm']['pools'] = false
  * Defines if a pool needs to be created at this time
* default['php']['package-name'] = []
  * Installs required packages based on platform_family

#### postgresql.rb
* default['postgresql']['password']['postgres'] = 'randompasswordforpostgresql'
  * Indicates admin password for postgresql

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
