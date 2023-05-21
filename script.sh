#!/bin/bash


DOMAIN="test20.f5xcdns.f5experiences.com"
TENANT="tcs-poc"
APIKEY="p8yF+m1RsvL+UEzozHiMGsOWUF4="
EMAIL="d.alperov@f5.com"


# Request the certificate with a manual DNS challenge.
certbot certonly \
  --email $EMAIL\
  --agree-tos\
  --manual \
  --preferred-challenges dns \
  --manual-auth-hook "./dns_register.sh $TENANT $APIKEY"\
  --manual-cleanup-hook "./dns_register.sh $TENANT $APIKEY"\
  -d $DOMAIN

current_dir="$(dirname "$0")"

if cp "/etc/letsencrypt/live/test20.f5xcdns.f5experiences.com/fullchain.pem" "$current_dir"; then
    cp "/etc/letsencrypt/live/test20.f5xcdns.f5experiences.com/privkey.pem" "$current_dir"
    echo "File has been copied."
else
    echo "File could not be copied!" >&2
fi