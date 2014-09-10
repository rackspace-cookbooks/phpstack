# Encoding: utf-8
require 'serverspec'
require 'net/http'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/bin'
  end
end

def page_returns(url = 'http://localhost/')
  Net::HTTP.get(URI(url))
end
