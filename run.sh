#!/bin/bash
set -e

# NGINX certificates
DH="/etc/nginx/dh.pem"
DH_SIZE="2048"

if [ ! -e "$DH" ]; then
    echo ">> seems like the first start of nginx"
    echo ">> doing some preparations..."
    echo ""
    echo ">> generating $DH with size: $DH_SIZE"
    openssl dhparam -out "$DH" $DH_SIZE
fi

if [ ! -e "/etc/nginx/cert.pem" ] || [ ! -e "/etc/nginx/key.pem" ]; then
    echo ">> generating self signed cert"
    openssl req -x509 -newkey rsa:4086 \
    -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost" \
    -keyout "/etc/nginx/key.pem" \
    -out "/etc/nginx/cert.pem" \
    -days 3650 -nodes -sha256
fi

echo ">> exec docker CMD"

# ELASTICSEARCH auth
if [ "${ELASTICSEARCH_USER}" == "None" ] && [ "${ELASTICSEARCH_PASS}" == "None" ]; then
    echo "=> Starting Elasticsearch with no base auth ..."
    echo "========================================================================"
    echo "You can now connect to this Elasticsearch Server using:"
    echo ""
    echo "    curl localhost:9200"
    echo ""
    echo "========================================================================"
    exec /usr/share/elasticsearch/bin/elasticsearch -Des.http.port=9200
else
    USER=${ELASTICSEARCH_USER:-user}
    echo "=> Starting Elasticsearch with basic auth ..."
    echo ${ELASTICSEARCH_PASS} | htpasswd -i -c /htpasswd ${USER}
    echo "========================================================================"
    echo "You can now connect to this Elasticsearch Server using:"
    echo ""
    echo "    curl ${USER}:${ELASTICSEARCH_PASS}@localhost:9200"
    echo ""
    echo "========================================================================"
    exec supervisord -n
fi

echo "$@"
exec "$@"

