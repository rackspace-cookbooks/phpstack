# Encoding: utf-8

require_relative 'spec_helper'

if os[:family] == 'RedHat'
  describe service('httpd') do
    it { should be_enabled }
  end
else
  describe service('apache2') do
    it { should be_enabled }
  end
end

describe port(80) do
  it { should be_listening }
end

describe file('/etc/phpstack.ini') do
  it { should be_file }
end
