source "https://supermarket.chef.io"

metadata

cookbook 'cron', git: 'git@github.com:rackspace-cookbooks/cron.git'

cookbook 'stack_commons', git: 'git@github.com:rackspace-cookbooks/stack_commons.git'
cookbook 'kibana', git: 'git@github.com:lusis/chef-kibana.git'
cookbook 'logstash', git:'git@github.com:racker/chef-logstash.git'
cookbook 'elasticsearch', git: 'git@github.com:racker/cookbook-elasticsearch.git'

group :integration do
  cookbook 'disable_ipv6', path: 'test/fixtures/cookbooks/disable_ipv6'
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end
