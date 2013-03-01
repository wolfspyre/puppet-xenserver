# == Class: xenserver::backup
#
# Full description of class xenserver::backup here.
#
# === Parameters
#
# Document parameters here.
#
# [*audit_logfile*]
#   The file to save auditlogs to
#
# [*backup*]
#   Whether or not to enable local (or nfs) backups.
#
# [*cluster_prettyname*]
#   The name to use in the email messages. Defaults to hostname.
#
# [*device*]
#    The block (or network) device to mount.
#
# [*enable_email*]
#   whether or not to send notification emails
#
# [*manage_mountpoint*]
#    whether or not to manage the mountpoint via puppet
#
# [*mountpoint*]
#    The directory the device should be mounted
#
#  [*recipient*]
#    The address to send emails to
#
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
#  class { xenserver::backup:
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
class xenserver::backup(
  $audit_logfile      = "${xenserver::log_file}/audit_${::hostname}.log",
  $backup             = false,
  $cluster_prettyname = $::hostname,
  $device             = '/dev/sdb1',
  $enable_email       = true,
  $fstype             = 'ext3',
  $manage_mountpoint  = false,
  $mountpoint         = '/backup',
  $recipient          = 'root@localhost',
  ) {
  include xenserver::backup::service
  include xenserver::backup::config
  #take advantage of the Anchor pattern
  anchor{'xenserver::backup::begin':
    before => Class['xenserver::backup::package'],
  }
  Class['xenserver::backup::package'] -> Class['xenserver::backup::config']
  Class['xenserver::backup::package'] -> Class['xenserver::backup::service']
  Class['xenserver::backup::config']  -> Class['xenserver::backup::service']

  anchor {'xenserver::backup::end':
    require => [
      Class['xenserver::backup::package'],
      Class['xenserver::backup::config'],
      Class['xenserver::backup::service'],
    ],
  }

}