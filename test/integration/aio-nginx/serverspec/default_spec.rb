# Encoding: utf-8

require_relative 'spec_helper'

# nginx
describe 'configures and runs Nginx' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(80) do
    it { should be_listening }
  end
end
describe 'configures our application' do
  describe file('/etc/nginx/sites-available/example.com') do
    it { should be_file }
  end
  describe file('/etc/nginx/sites-enabled/example.com') do
    it { should be_linked_to '/etc/nginx/sites-available/example.com' }
  end
  describe file('/var/www/example.com') do
    it { should be_directory }
  end
end

# memcache
describe service('memcached') do
  it { should be_enabled }
  it { should be_running }
end
describe port(11_211) do
  it { should be_listening }
end

# mysql base
if os[:family] == 'RedHat'
  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('mysql') do
    it { should be_enabled }
    it { should be_running }
  end
end
describe port(3306) do
  it { should be_listening }
end

# postgresql base
if os[:family] == 'RedHat'
  # process is named postgres
  describe service('postgres') do
    it { should be_running }
  end
  # service is named postgresql...
  describe service('postgresql') do
    it { should be_enabled }
  end
else
  describe service('postgres') do
    it { should be_enabled }
    it { should be_running }
  end
end
describe port(5432) do
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

# rabbitmq
describe service('rabbitmq-server') do
  it { should be_enabled }
  it { should be_running }
end
describe port(5672) do
  it { should be_listening }
end

# redis
# cannot name the service redis6379 because the check uses ps, not the actual service name
describe service('redis') do
  it { should be_running }
end
if os[:family] == 'RedHat'
  describe service('redis6379') do
    it { should be_enabled }
  end
end
describe port(6379) do
  it { should be_listening }
end

# php
describe file('/etc/phpstack.ini') do
  it { should be_file }
end
