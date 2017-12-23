FROM alpine:3.7

ENV USER bandersnatch
ENV UID 1000
ENV TZ Asia/Shanghai
ENV MASTER https://pypi.python.org
ENV WORKERS 10
ENV DIRECTORY /srv/pypi

RUN apk add --update --no-cache tzdata su-exec && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN apk add --update python3 && easy_install-3.6 pip && pip install bandersnatch && bandersnatch mirror || exit 0

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bandersnatch", "mirror"]

