#!/bin/sh

set -ex

cat > /usr/local/etc/php/conf.d/zzz-nuphp.ini <<EOF
extension=memcached.so

upload_max_filesize=${NUPHP_UPLOAD_MAX_FILESIZE:-2M}
post_max_size=${NUPHP_POST_MAX_FILESIZE:-8M}
memory_limit=${NUPHP_MEMORY_LIMIT:-128M}
expose_php=${NUPHP_EXPOSE_VERSION:-Off}
session.cookie_httponly=${NUPHP_SESSION_COOKIE_HTTPONLY:-On}
session.cookie_secure=${NUPHP_SESSION_COOKIE_SECURE:-Off}
session.name=${NUPHP_SESSION_NAME:-PHPSESSID}
session.save_handler=${NUPHP_SESSION_SAVE_HANDLER:-files}
session.save_path=${NUPHP_SESSION_SAVE_PATH:-}
sendmail_path = "/usr/bin/msmtp -t"
EOF

cat > /etc/msmtprc <<EOF
account ${MSMTP_ACCOUNT_NAME:-default}
tls ${MSMTP_TLS:-on}
tls_starttls ${MSMTP_TLS_STARTTLS:-on}
tls_certcheck ${MSMTP_TLS_CERTCHECK:-off}
auth ${MSMTP_AUTH:-on}
host ${MSMTP_HOST:-smtp.gmail.com}
port ${MSMTP_PORT:-587}
user ${MSMTP_USER:-}
from ${MSMTP_FROM:-}
password ${MSMTP_PASSWORD:-}
logfile /proc/self/fd/1
EOF

chown www-data:www-data /etc/msmtprc
chmod 600 /etc/msmtprc

if [ ! -z "$NEW_WWW_DATA_UID" ]; then
    usermod -u $NEW_WWW_DATA_UID www-data
fi

if [ ! -z "$NEW_WWW_DATA_GID" ]; then
    groupmod -g $NEW_WWW_DATA_GID www-data
fi
