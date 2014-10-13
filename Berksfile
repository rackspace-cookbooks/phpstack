source 'https://api.berkshelf.com'

cookbook 'rackops_rolebook', git: 'git@github.com:rackops/rackops_rolebook.git'
cookbook 'cron', git: 'git@github.com:rackspace-cookbooks/cron.git'

group :integration do
  cookbook 'disable_ipv6', path: 'test/fixtures/cookbooks/disable_ipv6'
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end

metadata
