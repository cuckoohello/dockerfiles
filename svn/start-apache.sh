#!/bin/bash

chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP /var/lib/svn
exec /usr/sbin/apache2 -D FOREGROUND
