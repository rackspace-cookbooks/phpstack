source "https://supermarket.chef.io"

metadata

cookbook 'cron', git: 'git@github.com:rackspace-cookbooks/cron.git'

group :integration do
  cookbook 'disable_ipv6', path: 'test/fixtures/cookbooks/disable_ipv6'
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end
