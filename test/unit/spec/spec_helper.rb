# Encoding: utf-8
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'
require 'json'

Dir['./test/unit/spec/support/**/*.rb'].sort.each { |f| require f }

::LOG_LEVEL = :fatal
::CHEFSPEC_OPTS = {
  log_level: ::LOG_LEVEL
}

def node_resources(node)
  # for chefspec, so we don't have to converge elkstack
  node.default['elkstack']['config']['additional_logstash_templates'] = []

  # for postgres cookbook, https://github.com/hw-cookbooks/postgresql#chef-solo-note
  node.set['postgresql']['password']['postgres'] = 'chef-solo'
end

def stub_resources
  stub_command('/usr/sbin/httpd -t').and_return(0)
  stub_command('/usr/sbin/apache2 -t').and_return(0)
  stub_command('which php').and_return('/usr/bin/php')
  stub_command('ls /var/lib/postgresql/9.1/main/recovery.conf').and_return(0)
  stub_command('ls /var/lib/pgsql/data/recovery.conf').and_return(0)
  stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf').and_return(0)
  stub_command('ls /recovery.conf').and_return(0)
end

def stub_nodes(platform, version, server)
  Dir['./test/integration/nodes/*.json'].sort.each do |f|
    node_data = JSON.parse(IO.read(f), symbolize_names: false)
    node_name = node_data['name']
    server.create_node(node_name, node_data)
    platform.to_s # pacify rubocop
    version.to_s # pacify rubocop
  end

  Dir['./test/integration/environments/*.json'].sort.each do |f|
    env_data = JSON.parse(IO.read(f), symbolize_names: false)
    env_name = env_data['name']
    server.create_environment(env_name, env_data)
  end
end

at_exit { ChefSpec::Coverage.report! }
