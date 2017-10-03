FROM docker.io/alpine:latest

RUN apk update && \
    apk add bash g++ znc znc-dev znc-extra ca-certificates

RUN mkdir -p /data/configs && chmod -R 0775 /data

ADD entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default

VOLUME ["/data"]

EXPOSE 6667

ENTRYPOINT ["/entrypoint.sh"]
