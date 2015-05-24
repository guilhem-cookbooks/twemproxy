default['twemproxy']['apt']['repo'] = 'twemproxy'
default['twemproxy']['apt']['keyserver'] = 'keyserver.ubuntu.com'
default['twemproxy']['apt']['components'] = %w(main)
default['twemproxy']['apt']['deb_src'] = true
default['twemproxy']['apt']['action'] = :add
default['twemproxy']['apt']['uri'] = 'http://ppa.launchpad.net/twemproxy/stable/ubuntu'
default['twemproxy']['apt']['distribution'] = node['lsb']['codename']
default['twemproxy']['apt']['key'] = 'C692420F'
