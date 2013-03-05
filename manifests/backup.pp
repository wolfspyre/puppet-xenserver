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
#   The block (or network) device to mount.
#
# [*enable_email*]
#   Whether or not to send notification emails
#
# [*enable_logs*]
#   Whether or not to enable logging in the vm backup script
#
# [*manage_mountpoint*]
#   Whether or not to manage the mountpoint via puppet
#
# [*mountpoint*]
#   The directory the device should be mounted
#
# [*mountpoint_opts*]
#   The options for the mountpoint
#
# [*recipient*]
#   The address to send emails to
#
# [*retention*]
#   The number of copies to retain
#
# [*sender*]
#   The email address to send from.
#
# [*state_toggle*]
#   Which states of VMs to backup. supported options are 'all', 'list', 'none', and 'running'
#
# [*uuids*]
#   A hash of uuids to backup. Must be specified if state_toggle is 'list', otherwise unused.
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
  $audit_logfile      = "audit_${::hostname}.log",
  $backup             = false,
  $cluster_prettyname = $::hostname,
  $device             = '/dev/sdb1',
  $enable_email       = true,
  $enable_logs        = true,
  $log_dir            = '/var/log',
  $fstype             = 'ext3',
  $hypervisors        = undef,
  $manage_mountpoint  = false,
  $mountpoint         = '/backup',
  $mountpoint_opts    = 'defaults',
  $recipient          = 'root@localhost',
  $retention          = '3',
  $sender             = 'root@localhost',
  $state_toggle       = 'running',
  $uuids              = undef,
  ) {
  include xenserver::backup::config
  #take advantage of the Anchor pattern
  anchor{'xenserver::backup::begin':
    before  => Class['xenserver::backup::config'],
    require => File['ssmtp_conf'],
  }

  anchor {'xenserver::backup::end':
    require => [
      Class['xenserver::backup::config'],
    ],
  }
  case $state_toggle{
    'all','running','none':{
      #no sanitization needed
    }
    'list':{
      #check to see if we have a list of VMs
      if !($uuids) {
        fail("state_toggle set to list, but no uuids were given.")
      }
    }
    default:{
      fail("unsupported value of ${state_toggle} set for state_toggle. Supported values: all, list, none, running")
    }
  }

}
