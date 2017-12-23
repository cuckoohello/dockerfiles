#!/bin/sh
[ -f /init.sh ] && sh /init.sh
getent passwd $USER > /dev/null || adduser -u $UID -D -H $USER
sed -i "s%^master = .*%master = $MASTER%" /etc/bandersnatch.conf
sed -i "s%^directory = .*%directory = $DIRECTORY%" /etc/bandersnatch.conf
sed -i "s%^workers = .*%workers = $WORKERS%" /etc/bandersnatch.conf
mkdir -p $DIRECTORY && chown $USER:$USER $DIRECTORY
exec su-exec $USER $*
