# == Class: xenserver::rhel::config
#  wrapper class
#Class['xenserver::config']
class xenserver::config {
#make sure shared config dirs exist
  $xenserver_config_dirs = [ '/usr/local/scripts', '/usr/local/etc', '/usr/local/bin', "$xenserver::log_dir" ]
  @file { $xenserver_config_dirs:
    ensure => 'directory',
    tag    => 'xenserver_configuration_directories',
  }
  File <| tag == 'xenserver_configuration_directories' |>
  #clean up our parameters
  $ensure             = $xenserver::ensure
  case $ensure {
    present, enabled, active, disabled, stopped: {
      file{'ssmtp_conf':
        ensure  => 'present',
        content => template('xenserver/etc/ssmtp/ssmtp.conf.erb'),
        group   => 'root',
        mode    => '0644',
        owner   => 'root',
        path    => '/etc/ssmtp/ssmtp.conf',

      }
    }#end configfiles should be present case
    absent: {
    }#end configfiles should be absent case
    default: {
      notice "xenserver::ensure has an unsupported value of ${xenserver::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
