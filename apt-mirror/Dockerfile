FROM alpine:3.7

ENV USER aptsync
ENV UID 1000
ENV TZ Asia/Shanghai

RUN apk add --update --no-cache gzip xz bzip2 tzdata perl su-exec wget curl ca-certificates && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN curl -fsSL https://github.com/apt-mirror/apt-mirror/raw/master/apt-mirror -o /usr/bin/apt-mirror && chmod +x /usr/bin/apt-mirror && \
      mkdir -p /etc/apt && curl -fsSL https://github.com/apt-mirror/apt-mirror/raw/master/mirror.list -o /etc/apt/mirror.list

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apt-mirror"]

