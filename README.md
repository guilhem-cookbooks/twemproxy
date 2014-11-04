# Description

Installs/Configures twemproxy

# Requirements

## Platform:

* Ubuntu

## Cookbooks:

* apt

# Attributes

* `node['twemproxy']['install_method']` -  Defaults to `"package"`.
* `node['twemproxy']['repo']` -  Defaults to `"ppa"`can be nil.
* `node['twemproxy']['config_file']` -  Defaults to `"/etc/twemproxy/config.yml"`.

# Recipes

* twemproxy::config
* twemproxy::default
* twemproxy::install_package
* twemproxy::repo_ppa

# License and Maintainer

Maintainer:: Guilhem Lettron (<guilhem@lettron.fr>)

License:: apache 2.0
