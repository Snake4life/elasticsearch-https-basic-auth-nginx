#!/bin/bash
set -e

# generate NGINX certificates
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
