#!/bin/sh -e
export OPENLDAP_CONFIG_DIR="/etc/openldap/slapd.d"
export OPENLDAP_RUN_PIDFILE="/var/run/slapd/slapd.pid"

export LDAP_DOMAIN_RDC="$(echo ${LDAP_DOMAIN} | sed 's/^\.//; s/\..*$//')"
export LDAP_SUFFIX="$(echo dc=$(echo ${LDAP_DOMAIN} | sed 's/^\.//; s/\./,dc=/g'))"
export LDAP_PASSWORD_ENCRYPTED="$(slappasswd -u -h '{SSHA}' -s ${LDAP_PASSWORD})"
export LDAP_ADMIN_PASSWORD_ENCRYPTED="$(slappasswd -u -h '{SSHA}' -s ${LDAP_ADMIN_PASSWORD})"

if [[ ! -d ${OPENLDAP_CONFIG_DIR}/cn=config ]]; then
    mkdir -p ${OPENLDAP_CONFIG_DIR} /var/run/slapd /srv/openldap.d /var/lib/openldap/openldap-data/ /var/lib/openldap/run/

    cat /srv/openldap/slapd.init.ldif | envsubst > /etc/openldap/slapd.ldif

    slapadd -n0 -F ${OPENLDAP_CONFIG_DIR} -l /etc/openldap/slapd.ldif > /var/log/slapd.ldif.log

    chown -R ldap:ldap /var/run/slapd ${OPENLDAP_CONFIG_DIR} /var/lib/openldap

    if [[ -d /srv/openldap.d ]]; then
        if [[ ! -s /srv/openldap.d/000-domain.ldif ]]; then
            cat /srv/openldap/domain.init.ldif | envsubst > /srv/openldap.d/000-domain.ldif
        fi

        slapd_exe=$(which slapd)
        echo >&2 "$0 ($slapd_exe): starting initdb daemon"
        slapd -u ldap -g ldap -h ldapi:/// -F /etc/openldap/slapd.d

        for f in $(find /srv/openldap.d -type f | sort); do
            case "$f" in
                *.sh)   echo "$0: sourcing $f"; . "$f" ;;
                *.ldif) echo "$0: applying $f"; ldapadd -Y EXTERNAL -f "$f" 2>&1;;
                *)      echo "$0: ignoring $f" ;;
            esac
        done

        if [[ ! -s ${OPENLDAP_RUN_PIDFILE} ]]; then
            echo >&2 "$0 ($slapd_exe): ${OPENLDAP_RUN_PIDFILE} is missing, did the daemon start?"
            exit 1
        else
            slapd_pid=$(cat ${OPENLDAP_RUN_PIDFILE})
            echo >&2 "$0 ($slapd_exe): sending SIGINT to initdb daemon with pid=$slapd_pid"
            kill -s INT "$slapd_pid" || true
            while : ; do
                [[ ! -f ${OPENLDAP_RUN_PIDFILE} ]] && break
                sleep 1
                echo >&2 "$0 ($slapd_exe): initdb daemon is still up, sleeping ..."
            done
            echo >&2 "$0 ($slapd_exe): initdb daemon stopped"
        fi
    fi
fi

exec "$@"
