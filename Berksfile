source 'https://api.berkshelf.com'

cookbook 'rackspace_iptables', git: 'git@github.com:rackspace-cookbooks/rackspace_iptables.git'
cookbook 'rackspacecloud', git: 'git@github.com:rackspace-cookbooks/rackspacecloud.git'
cookbook 'rackspace_cloudbackup', git: 'git@github.com:rackspace-cookbooks/rackspace_cloudbackup.git'
cookbook 'rackspace_gluster', git: 'git@github.com:rackspace-cookbooks/rackspace_gluster.git'
cookbook 'rackops_rolebook', git: 'git@github.com:rackops/rackops_rolebook.git'
cookbook 'cron', git: 'git@github.com:rackspace-cookbooks/cron.git'
cookbook 'pg-multi', git: 'git@github.com:rackspace-cookbooks/pg-multi.git'

cookbook 'kibana', '~> 1.3', git:'git@github.com:lusis/chef-kibana.git'

# until https://github.com/elasticsearch/cookbook-elasticsearch/pull/230
cookbook 'elasticsearch', '~> 0.3', git:'git@github.com:racker/cookbook-elasticsearch.git'

group :integration do
  cookbook 'disable_ipv6', path: 'test/fixtures/cookbooks/disable_ipv6'
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end

metadata
