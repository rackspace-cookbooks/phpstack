# Encoding: utf-8

require_relative 'spec_helper'

# this will pass on templatestack, fail elsewhere, forcing you to
# write those chefspec tests you always were avoiding
describe 'phpstack::default all in one demo' do
  recipes_for_demo = ['mysql_base', 'postgresql_base', 'mongodb_standalone', 'memcache', 'varnish', 'rabbitmq', 'redis_single', 'application_php'].map{|r| "phpstack::#{r}"}
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node_resources(node)
            node.set['phpstack']['demo']['enabled'] = true
          end.converge(*recipes_for_demo) # *splat operator for array to vararg
        end

        property = load_platform_properties(platform: platform, platform_version: version)

        it 'renders /etc/phpstack.ini' do
          expect(chef_run).to create_template('/etc/phpstack.ini')
        end
      end
    end
  end
end
