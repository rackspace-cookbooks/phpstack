# Encoding: utf-8

require_relative 'spec_helper'

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
  describe file('/etc/phpstack.ini') do
    it { should be_file }
  end
end
