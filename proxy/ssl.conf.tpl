# HTTPS listener, used when a Cloudflare Origin CA certificate is mounted.
# Origin CA certificates are trusted only by Cloudflare, not by browsers, so
# this is meant to sit behind a proxied Cloudflare zone in Full (strict) mode.

server {
    listen ${LISTEN_PORT_SSL} ssl;
    http2 on;

    ssl_certificate     ${SSL_CERT};
    ssl_certificate_key ${SSL_KEY};

    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    include /etc/nginx/locations.conf;
}
