#!/bin/bash

rm -f /mnt/backup/xenshuttle-metadata.bak
rm -f /mnt/backup/xenshuttle-host-backup.bak 
#rm -f /mnt/backup/xenserver1-host-backup.bak 
#rm -f /mnt/backup/xenserver2-host-backup.bak

xe pool-dump-database file-name=/mnt/backup/xenshuttle-metadata.bak
xe host-backup file-name=/mnt/backup/xenshuttle-host-backup.bak host=xenshuttle.layer8.local 
#xe host-backup file-name=/mnt/backup/xenserver1-host-backup.bak host=xenserver1.layer8.local 
#xe host-backup file-name=/mnt/backup/xenserver2-host-backup.bak host=xenserver2.layer8.local 

rm -f /root/message.tmp
cat /root/mailheader.txt > /root/message.tmp
echo "Subject: Metadata Backed up" >> /root/message.tmp
ls /mnt/backup/*.bak >> /root/message.tmp
/usr/sbin/ssmtp  me@mydomain.com < /root/message.tmp
