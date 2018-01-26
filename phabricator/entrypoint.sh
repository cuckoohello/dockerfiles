#!/usr/bin/env bash
mkdir -p /srv/data /srv/repo /srv/ssh /var/tmp/phd/pid/ /var/run/sshd && chmod 777 /var/tmp/phd/pid/ && chown www-data:www-data /srv/data && chown git:git /srv/repo
touch /var/log/aphlict.log && chown git:git /var/log/aphlict.log

generate_ssh_key() {
  echo -n "${1^^} "
  ssh-keygen -qt ${1} -N '' -f ${2}
}

generate_ssh_host_keys() {
  if [[ ! -e /srv/ssh/ssh_host_rsa_key ]]; then
    echo -n "Generating OpenSSH host keys... "
    generate_ssh_key rsa      /srv/ssh/ssh_host_rsa_key
    generate_ssh_key dsa      /srv/ssh/ssh_host_dsa_key
    generate_ssh_key ecdsa    /srv/ssh/ssh_host_ecdsa_key
    generate_ssh_key ed25519  /srv/ssh/ssh_host_ed25519_key
    echo
  fi

  # ensure existing host keys have the right permissions
  chmod 0600 /srv/ssh/*_key
}
generate_ssh_host_keys
sudo -u git -H -E /update.sh
exec $*
