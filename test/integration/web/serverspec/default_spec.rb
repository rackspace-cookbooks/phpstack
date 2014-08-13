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

# php
describe file('/etc/phpstack.ini') do
  it { should be_file }
end

describe command("#{apache2ctl} -M") do
  it { should return_stdout(/^ ssl_module/) }
end
