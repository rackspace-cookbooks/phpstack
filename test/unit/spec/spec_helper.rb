# Encoding: utf-8
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/server'
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
end

def stub_resources
  stub_command("/usr/sbin/httpd -t").and_return(0)
end

at_exit { ChefSpec::Coverage.report! }
