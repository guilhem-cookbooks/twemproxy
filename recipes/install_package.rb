#
# Cookbook Name:: twemproxy
# Recipe:: install_package
#
# Copyright 2014, Virender Khatri
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

case node['platform_family']
when 'debian'
  include_recipe 'apt'
  # apt repository configuration
  apt_repository 'twemproxy' do
    uri node['twemproxy']['apt']['uri']
    distribution node['twemproxy']['apt']['distribution']
    components node['twemproxy']['apt']['components']
    keyserver node['twemproxy']['apt']['keyserver']
    key node['twemproxy']['apt']['key']
    deb_src node['twemproxy']['apt']['deb_src']
    action node['twemproxy']['apt']['action']
  end
else
  fail "package install is not available for platform #{node['platform']}"
end

package 'twemproxy' do
  version node['twemproxy']['ppa_version'] if node['twemproxy']['ppa_version']
end
