template '/etc/default/twemproxy.override' do
  source 'default.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables :args => "--conf-file=#{node['twemproxy']['config_file']}"
  notifies :reload, 'service[twemproxy]'
end

directory ::File.dirname(node['twemproxy']['config_file']) do
  recursive true
end

file node['twemproxy']['config_file'] do
  owner 'root'
  group 'root'
  mode '0644'
  content node['twemproxy']['config'].to_yaml
end
