# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: mysql_holland
#
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# set repository
case node['platform_family']
when 'debian'
  include_recipe 'apt'
  apt_repository 'Holland' do
    uri "http://download.opensuse.org/repositories/home:/holland-backup/x#{node['lsb']['id']}_#{node['lsb']['release']}/"
    key "http://download.opensuse.org/repositories/home:/holland-backup/x#{node['lsb']['id']}_#{node['lsb']['release']}/Release.key"
    components ['./']
    action :add
  end
when 'rhel'
  include_recipe 'yum'
  yum_repository 'Holland' do
    description 'Holland backup repo'
    baseurl 'http://download.opensuse.org/repositories/home:/holland-backup/CentOS_CentOS-6/'
    gpgkey 'http://download.opensuse.org/repositories/home:/holland-backup/CentOS_CentOS-6/repodata/repomd.xml.key'
    action :create
  end
end

# install needed packages
%w(holland holland-mysqldump).each do |pkg|
  package pkg do
    action :install
  end
end

# determine if server is slave or standalone and drop specific backupset file
if node.run_context.loaded_recipe?('phpstack::mysql_slave')
  template '/etc/holland/backupsets/default.conf' do
    source 'mysql/backup_sets.slave.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      backup_user: 'holland',
      backup_password: node['holland']['password']
    )
  end
else
  template '/etc/holland/backupsets/default.conf' do
    source 'mysql/backup_sets.standalone.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables(
      backup_user: 'holland',
      backup_password: node['holland']['password']
    )
  end
end

# set cronjob
cron 'backup' do
  hour node['holland']['cron']['hour']
  minute node['holland']['cron']['minute']
  day node['holland']['cron']['day']
  command '/usr/sbin/holland bk'
  action :create
end
