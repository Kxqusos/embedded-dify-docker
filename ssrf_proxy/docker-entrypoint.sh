#!/bin/bash
set -e

envsubst '${HTTP_PORT} ${COREDUMP_DIR} ${REVERSE_PROXY_PORT} ${SANDBOX_HOST} ${SANDBOX_PORT}' \
  < /etc/squid/squid.conf.template > /etc/squid/squid.conf

mkdir -p /var/spool/squid
chown -R proxy:proxy /var/spool/squid

if [ ! -d /var/spool/squid/00 ]; then
    squid -N -z 2>/dev/null || true
fi

exec squid -N -f /etc/squid/squid.conf
