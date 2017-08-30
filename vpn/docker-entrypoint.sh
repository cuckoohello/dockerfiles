#!/bin/sh
set -e

[ -f /init.sh ] && sh /init.sh

exec "$@"
