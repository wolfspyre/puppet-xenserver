/usr/local/bin/dbtool -a -v /var/xapi/state.db > /root/auditlog-xenshuttle.txt
/usr/local/bin/dbtool -a -v /var/xapi/state.db > /mnt/backup/auditlog-xenshuttle.txt

rm -f /root/message.tmp
cat /root/mailheader.txt > /root/message.tmp
echo "Subject: Auditlog from Xen Cluster" >> /root/message.tmp
echo "Here is the auditlog from the Xen Cluster" >> /root/message.tmp
cat /mnt/backup/auditlog-xenshuttle.txt >> /root/message.tmp
/usr/sbin/ssmtp  me@mydomain.com < /root/message.tmp

