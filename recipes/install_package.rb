include_recipe "twemproxy::repo_#{node['twemproxy']['repo']}" if node['twemproxy']['repo']

package 'twemproxy'

service 'twemproxy' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action [:enable, :start]
end
