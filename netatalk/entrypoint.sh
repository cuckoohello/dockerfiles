#!/bin/sh
if [ ! -f /.initialized_afp ]
then
  rm /etc/afp.conf
  adduser -u $UID -D -H $USER
  echo $USER:$PASSWD | chpasswd
  echo "[Global]
mimic model = Xserve
log file = /var/log/afpd.log
log level = default:warn
zeroconf = no
[$NAME]
path = /data
valid users = $USER" >> /etc/afp.conf
  touch /.initialized_afp
fi

exec netatalk -d
