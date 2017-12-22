#!/bin/sh
[ -f /init.sh ] && sh /init.sh
getent passwd $USER > /dev/null || adduser -u $UID -D -H $USER
mkdir -p /var/spool/apt-mirror/mirror /var/spool/apt-mirror/skel /var/spool/apt-mirror/var
chown $USER:$USER /var/spool/apt-mirror /var/spool/apt-mirror/mirror /var/spool/apt-mirror/skel /var/spool/apt-mirror/var
exec su-exec $USER $*
