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

        # Forward the real client details so Django sees the actual hostname and
        # scheme. Without these it sees "Host: app:9000" over plain HTTP, which
        # breaks ALLOWED_HOSTS and, once TLS is terminated upstream by
        # Cloudflare, CSRF validation on every form submission.
        proxy_set_header        Host              $host;
        proxy_set_header        X-Real-IP         $remote_addr;
        proxy_set_header        X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $http_x_forwarded_proto;
    }
}
