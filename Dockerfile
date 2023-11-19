FROM python:3.9-alpine3.13
LABEL maintainer="ethanhao.org"

ENV PYTHONUNBUFFERED 1

COPY . /app

WORKDIR /app

EXPOSE 9000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
      build-base postgresql-dev musl-dev linux-headers && \
    /py/bin/pip install -r requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    mkdir -p /app/assets/static /app/assets/media && \
    chown -R app:app /app/assets/static /app/assets/media && \
    chmod -R 755 /app/assets/static /app/assets/media && \
    chmod -R +x /app/scripts

ENV PATH="/app/scripts:/py/bin:$PATH"

USER app

CMD ["run.sh"]
