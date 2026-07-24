server {
    listen ${LISTEN_PORT};

    include /etc/nginx/locations.conf;
}
