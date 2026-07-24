#!/bin/sh

set -e

# Substitute ONLY these three. Bare `envsubst` would also expand nginx's own
# runtime variables ($host, $remote_addr, $proxy_add_x_forwarded_for, ...) to
# empty strings, producing an invalid config that nginx refuses to start.
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' \
  < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

nginx -t
nginx -g 'daemon off;'