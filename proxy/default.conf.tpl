server {
    listen ${LISTEN_PORT};

    location /static {
        alias /vol/assets/static;
    }

    location /media {
        alias /vol/assets/media/;
    }

    location / {
        proxy_pass              http://${APP_HOST}:${APP_PORT};
        #include                 /etc/nginx/uwsgi_params;
        client_max_body_size    10M;
    }
}
