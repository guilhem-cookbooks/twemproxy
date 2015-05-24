#
# Cookbook Name:: twemproxy
# Recipe:: install
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

include_recipe 'twemproxy::package_dependency'

[node['twemproxy']['log_dir'],
 node['twemproxy']['conf_dir'],
 node['twemproxy']['data_dir']
].each do |dir|
  directory dir do
    owner node['twemproxy']['user']
    group node['twemproxy']['group']
    mode node['twemproxy']['dir_mode']
    recursive true
  end
end

include_recipe "twemproxy::install_#{node['twemproxy']['install_method']}"
