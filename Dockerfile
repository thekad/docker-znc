FROM docker.io/alpine:latest

ENV SSL_PEM=/ssl/znc.pem

RUN apk update && \
    apk add dumb-init g++ znc znc-dev znc-extra ca-certificates

RUN mkdir -pv /ssl /data/configs && chmod -R 0775 /data /ssl

ADD entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default

VOLUME ["/data"]
VOLUME ["/ssl"]

EXPOSE 6667

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/entrypoint.sh"]
