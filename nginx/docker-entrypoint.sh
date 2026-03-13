#!/bin/sh
set -e

envsubst '${NGINX_SERVER_NAME} ${NGINX_PORT} ${NGINX_SSL_PORT} ${NGINX_SSL_CERT_FILENAME} ${NGINX_SSL_CERT_KEY_FILENAME} ${NGINX_SSL_PROTOCOLS} ${NGINX_WORKER_PROCESSES} ${NGINX_CLIENT_MAX_BODY_SIZE} ${NGINX_KEEPALIVE_TIMEOUT} ${NGINX_PROXY_READ_TIMEOUT} ${NGINX_PROXY_SEND_TIMEOUT}' \
  < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

nginx -t

exec nginx -g 'daemon off;'
