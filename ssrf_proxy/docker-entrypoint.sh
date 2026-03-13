#!/bin/sh
set -e

sed "s|\${HTTP_PORT}|${HTTP_PORT}|g; s|\${COREDUMP_DIR}|${COREDUMP_DIR}|g; s|\${REVERSE_PROXY_PORT}|${REVERSE_PROXY_PORT}|g; s|\${SANDBOX_HOST}|${SANDBOX_HOST}|g; s|\${SANDBOX_PORT}|${SANDBOX_PORT}|g" \
  /etc/squid/squid.conf.template > /etc/squid/squid.conf

mkdir -p /var/spool/squid
chown -R proxy:proxy /var/spool/squid

if [ ! -d /var/spool/squid/00 ]; then
    squid -N -z 2>/dev/null || true
fi

exec squid -N -f /etc/squid/squid.conf
