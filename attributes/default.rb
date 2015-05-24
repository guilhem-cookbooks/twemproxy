# ubuntu package version
default['twemproxy']['ppa_version'] = nil # '0.4.0-2~ubuntu' +  node['platform_version'] + '.1'

# git source revision
default['twemproxy']['version'] = 'v0.4.0'
default['twemproxy']['git_url'] = 'git://github.com/twitter/twemproxy.git'

# set default install_method in favor of exisiting users
default['twemproxy']['install_method'] = value_for_platform_family(
  'rhel' => 'source',
  'debian' => 'package'
)

# twemproxy user / group, set to root if ubuntu package install
default['twemproxy']['user'] = node['twemproxy']['install_method'] == 'package' ? 'root' : 'twemproxy'
default['twemproxy']['group'] = node['twemproxy']['install_method'] == 'package' ? 'root' : 'twemproxy'
# setup user, used by source install
default['twemproxy']['manage_user'] = true
default['twemproxy']['home'] = nil

default['twemproxy']['config_dir'] = '/etc/twemproxy'
default['twemproxy']['config_file'] = ::File.join(node['twemproxy']['config_dir'], 'config.yml')

default['twemproxy']['umask']         = '0022'
default['twemproxy']['dir_mode']      = '0755'
default['twemproxy']['parent_dir']    = '/usr/local/twemproxy'
default['twemproxy']['log_dir']       = '/var/log/twemproxy'
default['twemproxy']['conf_dir']      = '/etc/twemproxy'
default['twemproxy']['data_dir']      = '/opt/twemproxy'

# for tarball installation
default['twemproxy']['version_dir']   = ::File.join(node['twemproxy']['parent_dir'], node['twemproxy']['version'])
default['twemproxy']['install_dir']   = ::File.join(node['twemproxy']['version_dir'], 'installed')
default['twemproxy']['source_dir']    = ::File.join(node['twemproxy']['version_dir'], "twemproxy-#{node['twemproxy']['version']}")

default['twemproxy']['notify_restart']  = true # notify service restart on config change
default['twemproxy']['service_name']    = 'twemproxy'

# twemproxy daemon args
default['twemproxy']['launch_options']['conf_file']   = node['twemproxy']['config_file']
default['twemproxy']['launch_options']['log_file']    = ::File.join(node['twemproxy']['log_dir'], 'twemproxy.log')
default['twemproxy']['launch_options']['verbosity']   = 5
default['twemproxy']['launch_options']['stats_port']  = 22_222
default['twemproxy']['launch_options']['stats_address']   = node['ipaddress']
default['twemproxy']['launch_options']['stats_interval']  = 30_000
default['twemproxy']['launch_options']['mbuf_size'] = 16_384
default['twemproxy']['launch_options']['pid_file'] = nil

default['twemproxy']['config'] = {}

# twemproxy compile options
default['twemproxy']['force_compile'] = false
default['twemproxy']['compile_options']['--prefix'] = node['twemproxy']['install_dir']
default['twemproxy']['compile_options']['--sysconfdir'] = node['twemproxy']['conf_dir']
default['twemproxy']['compile_options']['--datadir']    = node['twemproxy']['data_dir']

# twemproxy process limits
default['twemproxy']['limits']['memlock'] = 'unlimited'
default['twemproxy']['limits']['nofile']  = 48_000
default['twemproxy']['limits']['nproc']   = 'unlimited'

default['twemproxy']['environment_file'] = value_for_platform_family(
  'rhel' => '/etc/sysconfig/twemproxy',
  'debian' => '/etc/default/twemproxy.override'
)

# required for source install init script, but could
# be useful to package install
default['twemproxy']['daemon'] = case node['twemproxy']['install_method']
                                 when 'source'
                                   ::File.join(node['twemproxy']['install_dir'], 'sbin', 'nutcracker')
                                 else
                                   '/usr/bin/nutcracker'
                                 end

default['twemproxy']['packages'] = value_for_platform_family(
  'rhel' => %w(gcc gcc-c++ make autoconf libtool git),
  'debian' => %w(gcc make autoconf libtool git-core)
)
