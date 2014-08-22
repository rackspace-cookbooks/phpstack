# Encoding: utf-8

require_relative 'spec_helper'

# postgresql-master
if os[:family] == 'RedHat'
  # process is named postgres
  describe service('postgres') do
    it { should be_running }
  end
  # service is named postgresql...
  describe service('postgresql') do
    it { should be_enabled }
  end
  describe service('postgres') do
    it { should be_running }
  end
else
  describe service('postgresql') do
    it { should be_enabled }
    it { should be_running }
  end
  describe service('postgresql') do
    it { should be_running }
  end
end

describe port(5432) do
  it { should be_listening }
end
