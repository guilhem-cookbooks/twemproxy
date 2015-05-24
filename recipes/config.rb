#
# Cookbook Name:: twemproxy
# Recipe:: config
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

template node['twemproxy']['environment_file'] do
  source 'environment_file.erb'
  mode node['twemproxy']['dir_mode']
  owner node['twemproxy']['user']
  group node['twemproxy']['group']
  variables(:launch_options => node['twemproxy']['launch_options'])
  notifies :restart, 'service[twemproxy]', :delayed if node['twemproxy']['notify_restart']
end

file node['twemproxy']['config_file'] do
  owner node['twemproxy']['user']
  group node['twemproxy']['group']
  mode node['twemproxy']['dir_mode']
  # Use JSON to workaround https://tickets.opscode.com/browse/CHEF-3953
  # Use lines.to_a to suppress first yaml line
  content JSON.parse(node['twemproxy']['config'].to_json).to_yaml.lines.to_a[1..-1].join
  notifies :restart, 'service[twemproxy]', :delayed if node['twemproxy']['notify_restart']
end

service 'twemproxy' do
  provider Chef::Provider::Service::Upstart if node['platform_family'] == 'debian'
  supports :status => true, :restart => true
  action [:enable, :start]
end
