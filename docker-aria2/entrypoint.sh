#!/bin/sh
adduser -u $UID -D -H $USER
touch /data/.aria2.session
chown -R $USER:$USER /data/
exec su-exec $USER aria2c $*
