# Encoding: utf-8

require_relative 'spec_helper'

# mysql-master
if ['RedHat', 'RedHat7'].include?(os[:family])
  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('mysqld') do
    it { should be_running }
  end
elsif ['Debian', 'Ubuntu'].include?(os[:family])
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
