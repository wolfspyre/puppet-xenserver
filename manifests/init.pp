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
# [*enable_email*]
#   whether or not to send notification emails
#
# [*log_dir*]
#   The directory our logfiles should use by default
#
# [*mail_hostname*]
#   The hostname to use in ssmtp's config
#
# [*mailhub*]
#   The mailserver to tell ssmtp to deliver mail to. Must be set if enable_email is true.
#
#  [*recipient*]
#    The address to send emails to
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
  $enable_email  = true,
  $log_dir       = '/usr/local/log',
  $mail_hostname = $::fqdn,
  $mailhub       = undef,
  $recipient     = 'root@localhost',
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
  if ( ($enable_email == true) and !($mailhub) ) {
    fail('You must provide a mailhub for ssmtp to be able to send your mail.')
  }

}
