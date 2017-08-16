FROM alpine:edge
RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata

RUN apk add --update --no-cache nginx nginx-mod-stream && mkdir -p /run/nginx /etc/nginx/stream.d/

RUN echo "stream { include /etc/nginx/stream.d/*.conf; }" >> /etc/nginx/nginx.conf

RUN apk add --update --no-cache py-cffi py-cryptography py-pip && pip install certbot certbot-nginx

RUN apk add --update curl bash && curl -fsSL https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz | tar xzv -C /usr/local/bin && chmod +x /usr/local/bin/forego

RUN echo '0 0 1 * * /usr/bin/certbot renew --no-self-upgrade -n' >> /var/spool/cron/crontabs/root

ADD conf.d/cuckoo.conf /etc/nginx/conf.d/

ADD Procfile docker-compose.yml docker-entrypoint.sh /
ADD example.conf /etc/nginx/
VOLUME ["/etc/nginx/site.d/", "/etc/letsencrypt/", "/var/log/"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
