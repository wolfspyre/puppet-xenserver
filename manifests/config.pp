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
    }#end configfiles should be present case
    absent: {
      file {'xenserver_conf':
        ensure  => 'absent',
        path    =>  $configfilepath,
      }#end xenserverd.conf file
      file {'/etc/init.d/xenserver':
        ensure => 'absent',
      }#End init file
      file {'xenserver_logfile':
        ensure  => 'absent',
        path    => $logfile,
      }#end xenserver logfile file
    }#end configfiles should be absent case
    default: {
      notice "xenserver::ensure has an unsupported value of ${xenserver::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
