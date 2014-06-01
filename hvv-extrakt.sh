#!/bin/bash
MAILBOX=/var/dovecot/mail/user/INBOX/
cd /home/tickets
find /home/tickets -type f -ctime +14 -exec rm {} \;
find  $MAILBOX/cur $MAILBOX/new  -ctime -1 -type f -exec grep -l onlineshop@hochbahn.de {} \; |xargs -n1 munpack -q -f >/dev/null 2>&1