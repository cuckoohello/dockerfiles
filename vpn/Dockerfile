FROM alpine

ENV DNSMASQ_REGEX_VERSION 2.78-r1

RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata
RUN apk add --update curl bash su-exec && curl -fsSL https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz | tar xzv -C /usr/local/bin && chmod +x /usr/local/bin/forego

RUN curl -LOsS https://github.com/cuckoohello/dnsmasq-regex/raw/alpine/dnsmasq-regex-${DNSMASQ_REGEX_VERSION}.apk && \
    apk add --update --no-cache --allow-untrusted dnsmasq-regex-${DNSMASQ_REGEX_VERSION}.apk && \
    rm dnsmasq-regex-${DNSMASQ_REGEX_VERSION}.apk

RUN apk add --update --no-cache openvpn openvpn-auth-pam nss-pam-ldapd ipset iptables && echo 'auth      sufficient    pam_ldap.so' > /etc/pam.d/openvpn

ADD Procfile docker-compose.yml docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
