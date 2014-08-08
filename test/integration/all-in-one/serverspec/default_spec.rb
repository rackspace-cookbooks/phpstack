# Encoding: utf-8

require_relative 'spec_helper'

# apache
if os[:family] == 'RedHat'
  describe service('httpd') do
    it { should be_enabled }
  end
  apache2ctl = '/usr/sbin/apachectl'
else
  describe service('apache2') do
    it { should be_enabled }
  end
  apache2ctl = '/usr/sbin/apache2ctl'
end
describe port(80) do
  it { should be_listening }
end

# memcache
describe service('memcached') do
  it { should be_enabled }
  it { should be_running }
end
describe port(11_211) do
  it { should be_listening }
end

# mysql-master
if os[:family] == 'RedHat'
  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('mysqld') do
    it { should be_running }
  end
else
  describe service('mysql') do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('mysql') do
    it { should be_running }
  end
end

describe port(3306) do
  it { should be_listening }
end

# varnish
describe service('varnish') do
  it { should be_enabled }
  it { should be_running }
end
describe port(6081) do
  it { should be_listening }
end

# mongo
describe port(27_017) do
  it { should be_listening }
end

# php
describe file('/etc/phpstack.ini') do
  it { should be_file }
end

describe command("#{apache2ctl} -M") do
  it { should return_stdout(/^ ssl_module/) }
end
