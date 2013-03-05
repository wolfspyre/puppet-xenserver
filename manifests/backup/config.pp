# == Class: xenserver::backup::config
#  wrapper class
#
class xenserver::backup::config {
  #clean up our parameters
  $device            = $xenserver::backup::device
  $ensure            = $xenserver::backup
  $fstype            = $xenserver::backup::fstype
  $manage_mountpoint = $xenserver::backup::manage_mountpoint
  $mountpoint        = $xenserver::backup::mountpoint
  $options           = $xenserver::backup::options
  #set some default file attributes
  File{
    before => Anchor['xenserver::end'],
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  #do stuff
  case $ensure {
    present, enabled, active, disabled, stopped, true: {
      if $manage_mountpoint {
        #The scripts mount and unmount the filesystem.
        #We're just putting it here for convenience
        mount {'backup_mountpoint':
          device  => $device,
          ensure  => 'present',
          fstype  => $fstype,
          name    => $mountpoint,
          options => $options,
        }
      }
      #scripts
      file {'/usr/local/scripts/audit.sh':
        ensure  => 'present',
        content => template('xenserver/usr/local/scripts/audit.sh.erb'),
      }
      file {'/usr/local/scripts/backups_cleanup.sh':
        ensure  => 'present',
        content => template('xenserver/usr/local/scripts/cleanup.sh.erb'),
      }
      file {'/usr/local/scripts/meta-backup.sh':
        ensure  => 'present',
        content => template('xenserver/usr/local/scripts/meta-backup.sh.erb'),
      }
      file {'/usr/local/scripts/vm_backup.sh':
        ensure  => 'present',
        content => template('xenserver/usr/local/scripts/vm_backup.sh.erb'),
      }
      file {'/usr/local/etc/mailheader.txt':
        ensure  => 'present',
        content => template('xenserver/usr/local/etc/mailheader.txt.erb'),
        mode    => '0600',
      }
      file {'/usr/local/etc/vm_backup.cfg':
        ensure  => 'present',
        content => template('xenserver/usr/local/etc/vm_backup.cfg.erb'),
        mode    => '0600',
      }
      file {'/usr/local/etc/vm_backup.lib':
        ensure  => 'present',
        mode    => '0600',
        source  => 'puppet:///modules/xenserver/usr/local/etc/vm_backup.lib',
      }
      file {'/usr/local/bin/dbtool':
        ensure  => 'present',
        mode    => '0700',
        source  => 'puppet:///modules/xenserver/usr/local/bin/dbtool',
      }
#cronjob

#logrotate stub

    }#end configfiles should be present case
    absent,false: {
      $backup_files = ['/usr/local/scripts/audit.sh','/usr/local/scripts/backups_cleanup.sh','/usr/local/scripts/meta-backup.sh','/usr/local/scripts/vm_backup.sh','/usr/local/etc/mailheader.txt','/usr/local/etc/vm_backup.cfg','/usr/local/etc/vm_backup.lib','/usr/local/bin/dbtool']
      file {$backup_files:
        ensure  => 'absent',
      }
    }#end configfiles should be absent case
    default: {
      notice "xenserver::backup::ensure has an unsupported value of ${xenserver::backup::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
