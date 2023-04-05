#!/bin/sh
if [ -z ${GANDI_API_KEY+x} ]; then echo "Environment variable GANDI_API_KEY not set."; exit; fi
if [ -z ${DOMAIN+x} ]; then echo "Environment variable GANDI_DOMAIN not set."; exit; fi
certbot certonly --manual --preferred-challenges=dns --manual-auth-hook /etc/letsencrypt/gandi/authenticator.sh --non-interactiv --agree-tos --manual-public-ip-logging-ok -d $DOMAIN -m $EMAIL
cd /etc/letsencrypt/archive/$DOMAIN
cp cert1.pem /certs/$DOMAIN/cert.pem
cp chain1.pem /certs/$DOMAIN/chain.pem
cp fullchain1.pem /certs/$DOMAIN/fullchain.pem
cp privkey1.pem /certs/$DOMAIN/privkey.pem
