include_recipe 'apt'

apt_repository 'twemproxy' do
  uri 'http://ppa.launchpad.net/twemproxy/stable/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'C692420F'
end
