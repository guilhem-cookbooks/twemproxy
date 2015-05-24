#
# Cookbook Name:: twemproxy
# Recipe:: install_source
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

# setup user
include_recipe 'twemproxy::user'

compile_options = ''
node['twemproxy']['compile_options'].each do |k, v|
  if v
    compile_options << " #{k}=#{v}"
  else
    compile_options << " #{k}"
  end
end

# setup directories for twemproxy
[node['twemproxy']['parent_dir'],
 node['twemproxy']['version_dir'],
 node['twemproxy']['conf_dir'],
 node['twemproxy']['install_dir']
].each do |dir|
  directory dir do
    owner node['twemproxy']['user']
    group node['twemproxy']['group']
    mode node['twemproxy']['dir_mode']
    recursive true
  end
end

# download source
git node['twemproxy']['source_dir'] do
  repository node['twemproxy']['git_url']
  revision node['twemproxy']['version']
  user node['twemproxy']['user']
  group node['twemproxy']['group']
  notifies :run, 'execute[compile_twemproxy]', :immediately
end

# compile
execute 'compile_twemproxy' do
  user node['twemproxy']['user']
  group node['twemproxy']['group']
  umask node['twemproxy']['umask']
  cwd node['twemproxy']['source_dir']
  # set node['twemproxy']['force_compile'] attribute to re-compile
  # caution: if set, will compile on each chef run
  creates ::File.join(node['twemproxy']['install_dir'], 'sbin', 'nutcracker') unless node['twemproxy']['force_compile']
  command "autoreconf -fvi ; ./configure #{compile_options} ; make && make install"
end

template '/etc/init.d/twemproxy' do
  cookbook node['twemproxy']['cookbook']
  source "init.#{node['platform_family']}.erb"
  owner 'root'
  group 'root'
  mode 0750
  variables(:user => node['twemproxy']['user'],
            :daemon => node['twemproxy']['daemon'])
  notifies :restart, 'service[twemproxy]', :delayed if node['twemproxy']['notify_restart']
  only_if { node['platform_family'] == 'rhel' }
end
