# Encoding: utf-8

require_relative 'spec_helper'

# apache
if os[:family] == 'redhat'
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
describe command("#{apache2ctl} -M") do
  its(:stdout) { should match(/^ ssl_module/) }
end
describe 'the app returns the expected content' do
  it { expect(page_returns).to match(/MySQL Service/) }
end

# memcache
describe service('memcached') do
  it { should be_enabled }
  it { should be_running }
end
describe port(11_211) do
  it { should be_listening }
end

# postgresql base
if os[:family] == 'redhat'
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

# mongo
describe port(27_017) do
  it { should be_listening }
end

# redis
# cannot name the service redis6379 because the check uses ps, not the actual service name
describe service('redis') do
  it { should be_running }
end
if os[:family] == 'redhat'
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
