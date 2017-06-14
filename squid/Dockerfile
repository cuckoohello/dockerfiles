FROM alpine:3.5

RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata

RUN apk add --update --no-cache squid
COPY conf/squid.conf /etc/squid/squid.conf
COPY docker-compose.yml /
CMD [ "/usr/sbin/squid", "-N" ]
EXPOSE 3128 3130
