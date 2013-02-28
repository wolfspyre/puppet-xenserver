<%
address = scope.lookupvar(xenserver::backup::recipient)
cluster = scope.lookupvar(xenserver::backup::cluster_prettyname)
logfile = scope.lookupvar(xenserver::backup::audit_logfile)
send    = scope.lookupvar(xenserver::backup::enable_email)
-%>
#!/bin/bash
/usr/local/bin/dbtool -a -v /var/xapi/state.db > <%=logfile%>
rm -f /tmp/auditmessage.tmp
<% if send -%>
/bin/cat /usr/local/etc/mailheader.txt > /tmp/auditmessage.tmp
/bin/echo "Subject: Auditlog from <%=cluster%>" >> /tmp/auditmessage.tmp
/bin/echo "Here is the auditlog from the Xen Cluster" >> /tmp/auditmessage.tmp
/bin/cat <%=logfile%> >> /tmp/auditmessage.tmp
/usr/sbin/ssmtp  <%=address-%> < /tmp/auditmessage.tmp&& rm /tmp/auditmessage.tmp
<%end -%>
