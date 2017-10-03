FROM docker.io/alpine:latest

ENV PORT 6667

RUN apk update && \
    apk add bash g++ znc znc-dev znc-extra

RUN mkdir -p /data/configs && chmod -R 0775 /data

ADD entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default

VOLUME ["/data"]

EXPOSE ${PORT}

ENTRYPOINT ["/entrypoint.sh"]
