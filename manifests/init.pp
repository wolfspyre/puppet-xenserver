# == Class: xenserver
#
# Full description of class xenserver here.
#
# === Parameters
#
# Document parameters here.
#
#
# [*app_autostart*] - Boolean - Determine if we should add something to /etc/rc.local to start our apps
#
# [*app_uuids*] - Array - List of vApp uuids to start automatically
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
#
# === Examples
#
#  class { xenserver:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <wolf@wolfspyre.com>
#
# === Copyright
#
# Copyright 2013 Wolf Noble
#
class xenserver(
  $ensure        = present,
  $app_autostart = false,
  $app_uuids     = [],
  $backup        = false,
  $enable_email  = true,
  $log_dir       = '/usr/local/log',
  $mail_hostname = $::fqdn,
  $mailhub       = undef,
  $recipient     = 'root@localhost',
  $use_logrotate = false,
  ) {
  #input validation
  $ensure_vals = ['present', 'enabled', 'active', 'disabled', 'stopped', 'absent']
  validate_re($ensure,$ensure_vals)
  validate_bool($app_autostart)
  validate_bool($enable_email)
  validate_bool($use_logrotate)
  if ($app_autostart == true) {
    validate_array($app_uuids)
  }
# include xenserver::package
# include xenserver::service
  include xenserver::config
  #take advantage of the Anchor pattern
  anchor{'xenserver::begin':
    before => Class['xenserver::config'],
  }
# Class['xenserver::package'] -> Class['xenserver::config']
# Class['xenserver::package'] -> Class['xenserver::service']
# Class['xenserver::config']  -> Class['xenserver::service']

  anchor {'xenserver::end':
    require => [
#     Class['xenserver::package'],
      Class['xenserver::config'],
#     Class['xenserver::service'],
    ],
  }
  if ( ($enable_email == true) and (!($mailhub) or ($mailhub=="UNDEF")) ) {
    fail('You must provide a mailhub for ssmtp to be able to send your mail.')
  }

}
