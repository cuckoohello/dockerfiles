#!/bin/sh
[ -d  /opt/zbox/data/mysql/zentao ] || cp -rf /opt/zbox/data/mysql.sav/* /opt/zbox/data/mysql

/opt/zbox/zbox start && tail -f /dev/null
