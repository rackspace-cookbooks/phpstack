# Encoding: utf-8
#
# Cookbook Name:: phpstack
#
# Copyright 2014, Rackspace UK, Ltd.
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

default['phpstack']['demo']['enabled'] = false

site1 = 'example.com'
site2 = 'test.com'
version1 = '0.1.0'
port1 = '80'
port2 = '8080'

# apache site1
default['phpstack']['demo']['apache']['sites'][port1][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['apache']['sites'][port1][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port1][site1]['repository']     = 'https://github.com/rackops/php-test-app'

default['phpstack']['demo']['apache']['sites'][port2][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['apache']['sites'][port2][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port2][site1]['repository']     = 'https://github.com/rackops/php-test-app'

# apache site2
default['phpstack']['demo']['apache']['sites'][port1][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['apache']['sites'][port1][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port1][site2]['repository']     = 'https://github.com/rackops/php-test-app'

default['phpstack']['demo']['apache']['sites'][port2][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['apache']['sites'][port2][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['apache']['sites'][port2][site2]['repository']     = 'https://github.com/rackops/php-test-app'

# nginx site1
default['phpstack']['demo']['nginx']['sites'][port1][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['nginx']['sites'][port1][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port1][site1]['repository']     = 'https://github.com/rackops/php-test-app'

default['phpstack']['demo']['nginx']['sites'][port2][site1]['server_alias']   = ["test.#{site1}", "www.#{site1}"]
default['phpstack']['demo']['nginx']['sites'][port2][site1]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port2][site1]['repository']     = 'https://github.com/rackops/php-test-app'

# nginx site2
default['phpstack']['demo']['nginx']['sites'][port1][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['nginx']['sites'][port1][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port1][site2]['repository']     = 'https://github.com/rackops/php-test-app'

default['phpstack']['demo']['nginx']['sites'][port2][site2]['server_alias']   = ["test.#{site2}", "www.#{site2}"]
default['phpstack']['demo']['nginx']['sites'][port2][site2]['revision']       = "v#{version1}"
default['phpstack']['demo']['nginx']['sites'][port2][site2]['repository']     = 'https://github.com/rackops/php-test-app'
