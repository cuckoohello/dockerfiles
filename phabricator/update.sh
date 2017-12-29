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
else
  (cd phabricator && git pull --rebase)
fi
cat /local.init.json | envsubst > /home/git/phacility/phabricator/conf/local/local.json
cp /preamble.php /home/git/phacility/phabricator/support/preamble.php

cd ~/phacility/phabricator && ./bin/storage upgrade --force
