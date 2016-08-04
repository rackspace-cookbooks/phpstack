source "https://supermarket.chef.io"

metadata

cookbook 'cron', git: 'git@github.com:rackspace-cookbooks/cron.git'
cookbook 'platformstack', git: 'git@github.com:AutomationSupport/platformstack.git'
cookbook 'rackspace_cloudbackup', git: 'git@github.com:rackspace-cookbooks/rackspace_cloudbackup.git'
cookbook 'logstash_stack', git: 'git@github.com:rackspace-cookbooks/logstash_stack.git'
cookbook 'rackspace_iptables', git: 'git@github.com:rackspace-cookbooks/rackspace_iptables.git'
cookbook 'stack_commons', git: 'git@github.com:rackspace-cookbooks/stack_commons.git'

cookbook 'kibana', git: 'git@github.com:lusis/chef-kibana.git'
cookbook 'logstash', git:'git@github.com:racker/chef-logstash.git'
cookbook 'elasticsearch', git: 'git@github.com:racker/cookbook-elasticsearch.git'

cookbook 'kibana', git: 'git@github.com:lusis/chef-kibana.git', branch: 'KIBANA3'
cookbook 'logstash', git:'git@github.com:racker/chef-logstash.git'
cookbook 'elasticsearch', git: 'git@github.com:racker/cookbook-elasticsearch.git'

group :integration do
  cookbook 'disable_ipv6', path: 'test/fixtures/cookbooks/disable_ipv6'
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end
