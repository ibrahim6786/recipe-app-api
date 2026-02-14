FROM python:3.11-alpine3.23

ENV PYTHONUNBUFFERED=1

ARG DEV=false

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# System deps for psycopg2 + Pillow + Django
RUN apk add --no-cache \
        postgresql-dev \
        gcc \
        python3-dev \
        musl-dev \
        libffi-dev \
        jpeg-dev \
        zlib-dev \
        build-base \
    && python -m venv /py \
    && /py/bin/pip install --upgrade pip \
    && /py/bin/pip install -r /tmp/requirements.txt \
    && if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi \
    && adduser -D django-user \
    && rm -rf /tmp

ENV PATH="/py/bin:$PATH"
USER django-user
