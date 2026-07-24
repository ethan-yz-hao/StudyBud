#!/bin/sh

set -e

# Substitute ONLY the template variables. Bare `envsubst` would also expand
# nginx's own runtime variables ($host, $remote_addr, $proxy_add_x_forwarded_for,
# ...) to empty strings, producing an invalid config that nginx refuses to start.
envsubst '${APP_HOST} ${APP_PORT}' \
  < /etc/nginx/locations.tpl > /etc/nginx/locations.conf

envsubst '${LISTEN_PORT}' \
  < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# HTTPS is optional: enabled only when a certificate is actually mounted, so the
# same image still works without one.
if [ -f "${SSL_CERT}" ] && [ -f "${SSL_KEY}" ]; then
  echo "TLS certificate found, enabling HTTPS on ${LISTEN_PORT_SSL}"
  envsubst '${LISTEN_PORT_SSL} ${SSL_CERT} ${SSL_KEY}' \
    < /etc/nginx/ssl.conf.tpl > /etc/nginx/conf.d/ssl.conf
else
  echo "No TLS certificate at ${SSL_CERT}, serving HTTP only"
  rm -f /etc/nginx/conf.d/ssl.conf
fi

nginx -t
nginx -g 'daemon off;'
