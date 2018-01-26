#!/bin/sh
mkdir -p ~/phacility && cd ~/phacility

if [ ! -e libphutil ]
then
  git clone https://github.com/phacility/libphutil.git -b stable --depth=1
else
  (cd libphutil && git pull --rebase)
fi

if [ ! -e arcanist ]
then
  git clone https://github.com/phacility/arcanist.git -b stable --depth=1
else
  (cd arcanist && git pull --rebase)
fi

if [ ! -e phabricator ]
then
  git clone https://github.com/phacility/phabricator.git -b stable --depth=1
  cd ~/phacility/phabricator/support/aphlict/server/ && npm install ws
else
  (cd phabricator && git pull --rebase)
fi

# Parse $NOTIFICATION_CLIENT and $NOTIFICATION_ADMIN
NOTIFICATION_CLIENT_PROTOCOL="$(echo $PHABRICATOR_URL | sed -e's@^\(.*\)://.*@\1@g')"
NOTIFICATION_CLIENT=$(echo $PHABRICATOR_URL | sed -e"s@$NOTIFICATION_CLIENT_PROTOCOL://@@g")

if echo $NOTIFICATION_CLIENT | grep -q ':' ; then
  NOTIFICATION_CLIENT_HOST="$(echo $NOTIFICATION_CLIENT | cut -d: -f1)"
  NOTIFICATION_CLIENT_PORT="$(echo $NOTIFICATION_CLIENT | cut -d: -f2)"
else
  NOTIFICATION_CLIENT_HOST=$NOTIFICATION_CLIENT
  if [ "$NOTIFICATION_CLIENT_PROTOCOL" = "https" ] ; then
    NOTIFICATION_CLIENT_PORT=443
  else
    NOTIFICATION_CLIENT_PORT=80
  fi
fi

export NOTIFICATION_CLIENT_PROTOCOL NOTIFICATION_CLIENT_HOST NOTIFICATION_CLIENT_PORT

# Apply configuration template
cat /local.init.json | envsubst > /home/git/phacility/phabricator/conf/local/local.json

cp /preamble.php /home/git/phacility/phabricator/support/preamble.php

cd ~/phacility/phabricator && ./bin/storage upgrade --force
