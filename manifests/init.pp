# == Class: xenserver
#
# Full description of class xenserver here.
#
# === Parameters
#
# Document parameters here.
#
# [*backup*]
#   Whether or not to enable local (or nfs) backups.
#
# [*log_dir*]
#   The directory our logfiles should use by default
#
# [*use_logrotate*]
#   Whether or not to use the logrotate defined type to automatically setup log rotation for our files
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { xenserver:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class xenserver(
  $backup        = false,
  $log_dir       = '/usr/local/log',
  $use_logrotate = false,
  ) {
  include xenserver::package
  include xenserver::service
  include xenserver::config
  #take advantage of the Anchor pattern
  anchor{'xenserver::begin':
    before => Class['xenserver::package'],
  }
  Class['xenserver::package'] -> Class['xenserver::config']
  Class['xenserver::package'] -> Class['xenserver::service']
  Class['xenserver::config']  -> Class['xenserver::service']

  anchor {'xenserver::end':
    require => [
      Class['xenserver::package'],
      Class['xenserver::config'],
      Class['xenserver::service'],
    ],
  }

}
