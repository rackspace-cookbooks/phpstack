# Encoding: utf-8

require_relative 'spec_helper'

# the runlist came from test-kitchen's default suite
describe 'phpstack all in one demo' do
  recipes_for_demo = %w(stack_commons::mysql_base stack_commons::postgresql_base stack_commons::mongodb_standalone
                        stack_commons::memcached stack_commons::varnish stack_commons::rabbitmq
                        stack_commons::redis_single phpstack::application_php platformstack::monitors).map { |r| "#{r}" }
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version) do |node, server|
            node_resources(node) # stub this node
            stub_nodes(platform, version, server) # stub other nodes for chef-zero

            # Stub the node and any calls to Environment.Load to return this environment
            env = Chef::Environment.new
            env.name 'chefspec' # matches ./test/integration/
            allow(node).to receive(:chef_environment).and_return(env.name)
            allow(Chef::Environment).to receive(:load).and_return(env)

            node.set['phpstack']['demo']['enabled'] = true
            node.set['stack_commons']['stackname'] = 'phpstack'
          end.converge(*recipes_for_demo) # *splat operator for array to vararg
        end

        property = load_platform_properties(platform: platform, platform_version: version)
        property.to_s # pacify rubocop

        it 'renders /etc/phpstack.ini' do
          expect(chef_run).to create_template('/etc/phpstack.ini')
          ['[MySQL-foo]',
           'master-host = 10.20.30.40',
           'slave-hosts = 10.20.20.20, 10.20.20.30',
           'port = 3306',
           'db_name = foo',
           'username = fooUser',
           'password = bar'].each do |l|
            expect(chef_run).to render_file('/etc/phpstack.ini').with_content(/#{l}/i)
          end
        end
      end
    end
  end
end
