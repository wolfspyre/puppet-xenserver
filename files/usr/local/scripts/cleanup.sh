#!/bin/bash
umount /mnt/backup
mount /dev/sdb1 /mnt/backup
sleep 20

#How many copies to keep
#If you want 3 copies, uncomment keep 3 AND keep 2
#If you want 4 copies, uncomment keep 4 AND keep 3 AND keep 2
#etc.

#Keep four copies
#find /mnt/backup/*.xva -type f -mtime 3 -delete

#Keep three copies
#find /mnt/backup/*.xva -type f -mtime 2 -delete

#Keep two copies
find /mnt/backup/*.xva -type f -mtime 1 -delete

#Keep one copy only
#Use ONLY the line below when drive isn't big enough for two copies anymore
#Removes all backup copies so we can start fresh every time, somewhat dangerous...
#rm -f /mnt/backup/*.xva
#If you are keeping more than one, don't uncomment this line

rm -f /root/message.tmp
cat /root/mailheader.txt > /root/message.tmp
echo "Subject: Cleaned Backup Drive" >> /root/message.tmp
echo "I cleaned up the backup drive" >> /root/message.tmp
ls /mnt/backup >> /root/message.tmp
df -h >> /root/message.tmp
/usr/sbin/ssmtp  me@mydomain.com < /root/message.tmp

