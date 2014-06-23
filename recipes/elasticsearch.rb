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

# recommends Oracle JDK for production, but we haven't resolved that yet
include_recipe 'java'

# elasticsearch cookbook defaults to 60% of available RAM
# this invokes oomkiller on smaller (512M) systems *and*
#
# not all ES memory is in heap, so we aim for 40% of system memory for heap,
# and combined with stack, this will end up around 50%
allocated_memory = "#{(node['memory']['total'].to_i * 0.4).floor / 1024}m"
node.set_unless['elasticsearch']['allocated_memory'] = allocated_memory

include_recipe 'elasticsearch'
