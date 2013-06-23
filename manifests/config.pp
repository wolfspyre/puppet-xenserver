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
  $app_autostart = $xenserver::app_autostart
  $app_uuids     = $xenserver::app_uuids
  $ensure        = $xenserver::ensure
  case $ensure {
    present, enabled, active, disabled, stopped: {
      File{
        ensure => 'present',
        group  => 'root',
        owner  => 'root',
        mode   => '0644',
      }
      file{'ssmtp_conf':
        content => template('xenserver/etc/ssmtp/ssmtp.conf.erb'),
        path    => '/etc/ssmtp/ssmtp.conf',
      }
      if $app_autostart {
        file{'/etc/rc.autostart':
          ensure  => 'present',
          content => template('xenserver/etc/rc.autostart.erb'),
          mode    => 0777,
        }
        exec{'add_autostart_to_rc_init':
          command => '/bin/echo "/etc/rc.autostart" >>/etc/rc.d/rc.local',
          unless  => '/bin/grep -c \'/etc/rc.autostart\' /etc/rc.d/rc.local',
        }

      }
    }#end configfiles should be present case
    absent: {
    }#end configfiles should be absent case
    default: {
      notice "xenserver::ensure has an unsupported value of ${xenserver::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
