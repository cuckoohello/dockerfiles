#!/bin/sh
mkdir -p $(jq -r .storage_path /etc/rslsync.conf)
adduser -u $UID -D -H $SYNC_USER
chown -R $SYNC_USER:$SYNC_USER /data/
exec su-exec $SYNC_USER /usr/local/bin/rslsync $*
