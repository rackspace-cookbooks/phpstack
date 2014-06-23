# Encoding: utf-8
#
# Cookbook Name:: phpstack
# Recipe:: elasticsearch
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

# See the community elasticsearch cookbook for examples
#
# http://github.com/elasticsearch/cookbook-elasticsearch/tree/master/attributes
#

normal['elasticsearch']['discovery.zen.ping.multicast.enabled'] = 'false'
normal['elasticsearch']['bootstrap.mlockall'] = 'true'
normal['elasticsearch']['network.host'] = '_local_'
