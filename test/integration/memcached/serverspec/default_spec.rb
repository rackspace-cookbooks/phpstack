# Encoding: utf-8

require_relative 'spec_helper'

describe service('memcached') do
  it { should be_enabled }
  it { should be_running }
end

describe port(11_211) do
  it { should be_listening }
end
