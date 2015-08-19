# == Class: nodecellar
#
# Full description of class nodecellar here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'nodecellar':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class nodecellar {

  package { 'wget':
    ensure  => present,
  }

  exec { 'nodecellar_source':
    path    => "/usr/bin",
    command => "wget https://github.com/cloudify-cosmo/nodecellar/archive/master.tar.gz -O /tmp/master.tar.gz",
    unless  => "test -f /tmp/master.tar.gz",
    notify  => Exec['extract_nodecellar'],
  }

  exec { 'extract_nodecellar':
    path        => "/usr/bin",
    command     => "tar xzvf /tmp/master.tar.gz",
    unless      => "test -d /tmp/nodecellar-master",
    cwd         => "/tmp",
    notify      => Exec['install_nodecellar'],
  }

  exec { 'install_nodecellar':
    path        => "/usr/bin",
    command     => "npm install",
    cwd         => "/tmp/nodecellar-master",
    notify      => Exec['run_nodecellar'],
  }

  exec { 'run_nodecellar':
    path        => "/usr/bin",
    environment => ["MONGO_PORT=27017","MONGO_HOST=mongodb_host","NODECELLAR_PORT=8080"]
    command     => "/usr/bin/nohup /usr/bin/node server.js &",
    cwd         => "/tmp/nodecellar-master",
  }

}
