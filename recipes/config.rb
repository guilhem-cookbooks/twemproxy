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
  # Use JSON to workaround https://tickets.opscode.com/browse/CHEF-3953
  # Use lines.to_a to suppress first yaml line
  content JSON.parse(node['twemproxy']['config'].to_json).to_yaml.lines.to_a[1..-1].join
end
