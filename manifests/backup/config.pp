# == Class: xenserver::backup::config
#  wrapper class
#
class xenserver::backup::config {
  #clean up our parameters
  $ensure             = $xenserver::backup

  #set some default file attributes
  File{
    owner  => 'root',
    group  => 'root',
  } -> Anchor['xenserver::end']
  #do stuff
  case $ensure {
    present, enabled, active, disabled, stopped: {

##scripts
#audit.sh
#cleanup.sh
#meta-backup.sh
#vm_backup.sh

##etc
#mailheader.txt
#vm_backup.cfg

##bin
#dbtool

    }#end configfiles should be present case
    absent: {
      file {'xenserver::backup_conf':
        ensure  => 'absent',
        path    =>  $configfilepath,
      }#end xenserver::backupd.conf file
      file {'/etc/init.d/xenserver::backup':
        ensure => 'absent',
      }#End init file
      file {'xenserver::backup_logfile':
        ensure  => 'absent',
        path    => $logfile,
      }#end xenserver::backup logfile file
    }#end configfiles should be absent case
    default: {
      notice "xenserver::backup::ensure has an unsupported value of ${xenserver::backup::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
