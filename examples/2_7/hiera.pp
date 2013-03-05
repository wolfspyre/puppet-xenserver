#example implementation Class: 2_7::hiera
#
# Example hiera parameters
#
#xenserver::backup:        true
#xenserver::enable_email:  true
#xenserver::log_dir:       '/var/log'
#xenserver::mail_hostname: %{fqdn}
#xenserver::mailhub:       'UNDEF'
#xenserver::recipient:     'root@localhost'
#xenserver::use_logrotate: false
#######################################################################
#xenserver::backup::audit_logfile:      "audit_%{hostname}.log"
#xenserver::backup::backup:             true
#xenserver::backup::cluster_prettyname: "%{hostname}"
#xenserver::backup::device:             '/dev/sdb1'
#xenserver::backup::enable_email:       true
#xenserver::backup::enable_logs:        true
#xenserver::backup::fstyppe:            'ext3'
#xenserver::backup::log_dir:            '/var/log'
#xenserver::backup::hypervisors:
# - %{fqdn}
#xenserver::backup::manage_mountpoint:  true
#xenserver::backup::mountpoint:         '/backup'
#xenserver::backup::mountpoint_opts:    'defaults'
#xenserver::backup::recipient:          'root@localhost'
#xenserver::backup::retention:          '3'
#xenserver::backup::sender:             "root@%{fqdn}"
#xenserver::backup::state_toggle:       'running'
#xenserver::backup::uuids:              undef
#
class 2_7::hiera {
  $backup        = hiera('xenserver::backup',        true )
  $enable_email  = hiera('xenserver::enable_email',  true )
  $log_dir       = hiera('xenserver::log_dir',       '/var/log' )
  $mail_hostname = hiera('xenserver::mail_hostname', $::fqdn )
  $mailhub       = hiera('xenserver::mailhub',       undef )
  $recipient     = hiera('xenserver::recipient',     'root@localhost' )
  $use_logrotate = hiera('xenserver::use_logrotate', false )

  $xsb_audit_logfile      = hiera('xenserver::backup::audit_logfile',      "audit_${::hostname}.log" )
  $xsb_backup             = hiera('xenserver::backup::backup',             true )
  $xsb_cluster_prettyname = hiera('xenserver::backup::cluster_prettyname', $::hostname )
  $xsb_device             = hiera('xenserver::backup::device',             '/dev/sdb1' )
  $xsb_enable_email       = hiera('xenserver::backup::enable_email',       true )
  $xsb_enable_logs        = hiera('xenserver::backup::enable_logs',        true )
  $xsb_log_dir            = hiera('xenserver::backup::log_dir',            '/var/log' )
  $xsb_fstype             = hiera('xenserver::backup::fstype',             'ext3' )
  $xsb_hypervisors        = hiera('xenserver::backup::hypervisors',        undef )
  $xsb_manage_mountpoint  = hiera('xenserver::backup::manage_mountpoint',  true )
  $xsb_mountpoint         = hiera('xenserver::backup::mountpoint',         '/backup' )
  $xsb_mountpoint_opts    = hiera('xenserver::backup::mountpoint_opts',    'defaults' )
  $xsb_recipient          = hiera('xenserver::backup::recipient',          'root@localhost' )
  $xsb_retention          = hiera('xenserver::backup::retention',          '3' )
  $xsb_sender             = hiera('xenserver::backup::sender',             "root@${::fqdn}" )
  $xsb_state_toggle       = hiera('xenserver::backup::state_toggle',       'running' )
  $xsb_uuids              = hiera('xenserver::backup::uuids',              undef )
  if $use_logrotate {
    #declare logrotate dependency
  }
  $xs_params = {
    backup        => $backup,
    enable_email  => $enable_email,
    log_dir       => $log_dir,
    mail_hostname => $mail_hostname,
    mailhub       => $mailhub,
    recipient     => $recipient,
    use_logrotate => $use_logrotate,
  }
  $xsb_params = {
    audit_logfile      => $xsb_audit_logfile,
    backup             => $xsb_backup,
    cluster_prettyname => $xsb_cluster_prettyname,
    device             => $xsb_device,
    enable_email       => $xsb_enable_email,
    enable_logs        => $xsb_enable_logs,
    log_dir            => $xsb_log_dir,
    fstype             => $xsb_fstype,
    hypervisors        => $xsb_hypervisors,
    manage_mountpoint  => $xsb_manage_mountpoint,
    mountpoint         => $xsb_mountpoint,
    mountpoint_opts    => $xsb_mountpoint_opts,
    recipient          => $xsb_recipient,
    retention          => $xsb_retention,
    sender             => $xsb_sender,
    state_toggle       => $xsb_state_toggle,
    uuids              => $xsb_uuids,
  }
  create_resources('class', {'xenserver'         => $xs_params  })
  create_resources('class', {'xenserver::backup' => $xsb_params })

}