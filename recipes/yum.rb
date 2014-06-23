# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: yum
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

include_recipe 'yum'

yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end

yum_repository 'IUS' do
  description 'IUS Community Packages for Enterprise Linux/CentOS 6'
  mirrorlist 'http://dmirr.iuscommunity.org/mirrorlist/?repo=ius-centos6&arch=$basearch'
  gpgkey 'http://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY'
  action :create
end
