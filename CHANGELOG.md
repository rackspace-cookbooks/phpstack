phpstack CHANGELOG
==================

4.0.2
------

* @jujugrrr - reverted "remove static assignment to (dir)/current in templates"

4.0.1
------

* @martinb3 - do not force users to set up iptables
* @prometheanfire - Adding LogFormat option to apache config
* @prometheanfire - installing openssl dev packages for the mongo pecl module
* @prometheanfire - remove static assignment to (dir)/current in templates
* @prometheanfire - update min version of stack_commons for the mysql-multi pin it has
* @prometheanfire - update min version of apache to help fix the apache 2.4 problems

4.0.0
------

* @bobross419 - added support for more deployment options (pre exec, post exec, etc)
* @prometheanfire - generalized the installation of php pear modules
* @jujugrrr - pin stack_commons so berkshelf can resolve faster
* @prometheanfire - make sure apache supports 2.4
* @martinb3 - pin kibana to branch
* @prometheanfire - fixing usage of before_symlink_script
* @prometheanfire - namespacing of the http monitor config files
* @prometheanfire - set attributes to default values if not set
* @jujugrrr - Pinned application cookbook to at least 4.1.6, remove application_php support
* @prometheanfire - updating stack_commons min required version
* @prometheanfire - cleaning up the sites datastructure
* @prometheanfire - cleaning up stub recipes
* @prometheanfire - added monitoring_hostname, as it should be seperate from the hostname

3.0.22
------
@jujugrrr - empty bump for new release to the supermarket

3.0.21
------
@martinb3 - Unbreak the build by stubbing postgres commands for chefspec
@prometheanfire - generalizing the instalation of php modules (through pear)

3.0.20
------
Sheppy - Enable additional application properties

3.0.19
------
[@jujugrrr] - Use stack_commons for phpstack::gluster

3.0.18
------
[@jujugrrr] - Clean memcached attributes, they are not required anymore as they are in stack_commons

3.0.17
------
[@prometheanfire] - Add support to application_php for before_migrate/before_symlink

3.0.15
------
[@jujugrrr] - Use stack_commons for phpstack::newrelic

3.0.12
------
[@jujugrrr] - Use stack_commons for phpstack::mongodb_standalone

3.0.2
------
[@jujugrrr] - Fixed default type (array->hash) #205

