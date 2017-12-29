FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update  \
      && apt-get install -y --no-install-recommends curl tzdata sendmail openssh-server python-pygments gettext-base php5 php5-mysql php5-ldap php5-gd php5-curl php-apc php5-cli php5-json php-apc git-core ca-certificates libapache2-mod-php5 \
      && a2enmod rewrite \
      && adduser --disabled-login --gecos 'Phabricator' git && passwd -d git \
      && rm /etc/apache2/sites-enabled/000-default.conf \
      && sed -i 's/post_max_size = .*/post_max_size = 4G/g' /etc/php5/apache2/php.ini \
      && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 4G/g' /etc/php5/apache2/php.ini \
      && sed -i 's/;always_populate_raw_post_data.*/always_populate_raw_post_data = -1/g' /etc/php5/apache2/php.ini \
      && sed -i 's/;opcache.validate_timestamps=.*/opcache.validate_timestamps=0/g' /etc/php5/apache2/php.ini \
      && rm -rf /etc/ssh/* \
      && curl -fsSL https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz | tar xzv -C /usr/local/bin && chmod +x /usr/local/bin/forego \
      && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY phabricator.conf /etc/apache2/sites-enabled/
COPY entrypoint.sh update.sh local.init.json preamble.php Procfile /
COPY sshd/phabricator-ssh-hook.sh sshd/sshd_config.phabricator /etc/ssh/

ENV MYSQL_HOST 127.0.0.1
ENV MYSQL_USER root
ENV MYSQL_PASS password
ENV PHABRICATOR_URL http://git.infervision.com
ENV SSH_PORT 2222
ENV MYSQL_PORT 3306
ENV TZ Asia/Shanghai

VOLUME /srv

EXPOSE 80 2222

ENTRYPOINT ["/entrypoint.sh"]
CMD ["forego", "start", "-r"]
