# Encoding: utf-8

require_relative 'spec_helper'

if os[:family] == 'RedHat'
  describe service('mysqld') do
    it { should be_enabled }
  end
  describe service('mysqld') do
    it { should be_running }
  end
else
  describe service('mysql') do
    it { should be_enabled }
  end
  describe service('mysql') do
    it { should be_running }
  end
end



describe port(3306) do
  it { should be_listening }
end
