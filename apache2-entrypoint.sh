#!/bin/sh

set -ex

cat > /etc/apache2/mods-available/mpm_prefork.conf <<EOF
<IfModule mpm_prefork_module>
    StartServers              ${PREFORK_START_SERVERS:-3}
    MinSpareServers           ${PREFORK_MIN_SPARE_SERVERS:-3}
    MaxSpareServers           ${PREFORK_MAX_SPARE_SERVERS:-10}
    MaxRequestWorkers         ${PREFORK_MAX_REQUEST_WORKERS:-150}
    MaxConnectionsPerChild    ${PREFORK_MAX_CONNECTIONS_PER_CHILD:-0}
</IfModule>
EOF

common-config.sh

docker-entrypoint.sh "$@"
