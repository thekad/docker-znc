FROM docker.io/library/alpine:latest

ENV SSL_CRT=/ssl/fullchain.pem
ENV SSL_KEY=/ssl/privkey.pem
ENV SSL_DHP=/ssl/dhparam.pem
ENV CXXFLAGS=
ARG VERSION=1.7.4-r0

RUN apk update && \
    apk upgrade && \
    apk add dumb-init g++ ca-certificates znc=${VERSION} znc-dev=${VERSION} znc-extra=${VERSION}

ADD entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default

# Cheat a little bit, we need to let apk run even with --user
RUN mkdir -pv /ssl /data/configs && \
    chmod -Rv 0775 /data /ssl && \
    chmod u+s /sbin/apk

VOLUME ["/data"]
VOLUME ["/ssl"]

EXPOSE 6667

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/entrypoint.sh"]
