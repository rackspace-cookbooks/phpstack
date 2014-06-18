#
# Cookbook Name:: lampstack
# Recipe:: mysql_base
#

# run apt-get update to clear cache issues
include_recipe 'apt' if node.platform_family?('debian')

include_recipe 'chef-sugar'
include_recipe 'database::mysql'
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'mysql::server'

# determine best IP for bind_address in MySQL
if node.attribute?('cloud')
  bindip = node['cloud']['local_ipv4']
else
  bindip = node['ipaddress']
end

# Unique serverid via ipaddress to an int
require 'ipaddr'
serverid = IPAddr.new node['ipaddress']
serverid = serverid.to_i

directory '/etc/mysql/conf.d' do
  action :create
  recursive true
end

template '/etc/mysql/conf.d/my.cnf' do
  cookbook 'lampstack'
  source 'mysql/my.cnf.erb'
  variables(
    serverid: serverid,
    cookbook_name: cookbook_name,
    bind_address: bindip
  )
  notifies :restart, 'service[mysql]', :delayed
end

connection_info = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

# add holland user (if holland is enabled)
if node.deep_fetch('holland', 'enabled')
  mysql_database_user 'holland' do
    connection connection_info
    password ['holland']['password']
    host 'localhost'
    privileges [:usage, :select, :'lock tables', :'show view', :reload, :super, :'replication client']
    retries 2
    retry_delay 2
    action [:create, :grant]
  end
end

node.set_unless['lampstack']['cloud_monitoring']['agent_mysql']['password'] = secure_password

mysql_database_user node['lampstack']['cloud_monitoring']['agent_mysql']['user'] do
  connection connection_info
  password node['lampstack']['cloud_monitoring']['agent_mysql']['password']
  action 'create'
end

if node['platformstack']['cloud_monitoring']['enabled'] == true
  template 'mysql-monitor' do
    cookbook 'lampstack'
    source 'monitoring-agent-mysql.yaml.erb'
    path '/etc/rackspace-monitoring-agent.conf.d/agent-mysql-monitor.yaml'
    owner 'root'
    group 'root'
    mode '00600'
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end

# add /root/.my.cnf file to system
template '/root/.my.cnf' do
  source 'mysql/user.my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    user: 'root',
    pass: node['mysql']['server_root_password']
  )
end

case node['platform_family']
when 'rhel'
  service 'mysql' do
    service_name 'mysqld'
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
when 'debian'
  service 'mysql' do
    service_name 'mysql'
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
end
