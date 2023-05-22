#!/bin/bash


DOMAIN="<FQDN>"
TENANT="<TENANT>"
APIKEY="<APIKEY>"
EMAIL="<EMAIL>"


# Request the certificate with a manual DNS challenge.
certbot certonly \
  --email $EMAIL\
  --agree-tos\
  --manual \
  --preferred-challenges dns \
  --manual-auth-hook "./dns_challenge.sh $TENANT $APIKEY"\
  --manual-cleanup-hook "./dns_challenge.sh $TENANT $APIKEY"\
  -d $DOMAIN

current_dir="$(dirname "$0")"

if sudo cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$current_dir"; then
    sudo cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$current_dir"
    echo "File has been copied, starting to blindfold the private key"
    file_path="/Users/d.alperov/Desktop/terraform/tcs/fullchain.pem"
    output_path="base64cert.txt"

# Read the file content and encode as Base64
base64_content=$(openssl base64 -in "$file_path" -A)

# Save the Base64 content to a file
echo "$base64_content" > "$output_path"



else
    echo "File could not be copied!" >&2
fi