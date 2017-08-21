FROM docker:dind

RUN apk add --update --no-cache curl bash && curl -fsSL https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz | tar xzv -C /usr/local/bin && chmod +x /usr/local/bin/forego

RUN apk add --update --no-cache dropbear dropbear-ssh && mkdir /etc/dropbear && touch /var/log/lastlog &&  mkdir -m 700 -p /root/.ssh

ADD Procfile docker-compose.yml docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
