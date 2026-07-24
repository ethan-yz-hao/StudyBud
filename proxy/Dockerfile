FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="ethanhao.org"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./ssl.conf.tpl /etc/nginx/ssl.conf.tpl
COPY ./locations.tpl /etc/nginx/locations.tpl
COPY ./uwsgi_params /etc/nginx/uwsgi_params
COPY ./run.sh /run.sh

# Unprivileged nginx cannot bind below 1024, so compose maps 80->8000, 443->8443.
ENV LISTEN_PORT=8000
ENV LISTEN_PORT_SSL=8443
ENV APP_HOST=app
ENV APP_PORT=9000
ENV SSL_CERT=/etc/nginx/certs/origin.pem
ENV SSL_KEY=/etc/nginx/certs/origin.key

USER root

RUN mkdir -p /vol/assets /etc/nginx/certs && \
    chmod 755 /vol/assets && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf /etc/nginx/locations.conf 2>/dev/null || true && \
    touch /etc/nginx/locations.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf /etc/nginx/locations.conf && \
    chown nginx:nginx /etc/nginx/conf.d && \
    chmod +x /run.sh

VOLUME /vol/assets

USER nginx

CMD ["/run.sh"]