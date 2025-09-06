#!/bin/bash

DOMAIN="yourdomain.com" # Change to your actual domain
EMAIL="your_email@example.com" # Change to your email for certbot notifications

# Create necessary directories for certbot challenges
mkdir -p "./certbot/www"
mkdir -p "./certbot/conf"
CERT_DIR="./certbot/conf/live/$DOMAIN"
mkdir -p "$CERT_DIR"

echo "Replacing placeholder domain with actual domain: $DOMAIN"

# Replace 'yourdomain.com' in nginx config with actual domain
sed -i "s/yourdomain.com/$DOMAIN/g" ./nginx/conf.d/default.conf

# Start nginx and certbot containers
echo "Starting nginx and certbot containers..."
docker compose up -d nginx certbot

sleep 5

# Run certbot to obtain certificates using HTTP challenge
echo "Requesting SSL certificate for $DOMAIN using certbot..."
docker compose run --rm certbot certbot certonly --webroot \
    --webroot -w /var/www/certbot \
    -d "$DOMAIN" \
    --force-renewal \
    --non-interactive --agree-tos -m "$EMAIL" \
    -v --debug-challenges

echo "Certificate request complete. Reloading nginx..."

# Uncomment commented lines in nginx config between `## <HTTPS BLOCK>` and `## </HTTPS BLOCK>`
sed -i '/## <HTTPS BLOCK>/, /## <\/HTTPS BLOCK>/ s/^#//g' ./nginx/conf.d/default.conf
# Uncomment HTTPS redirect and comment out proxy in HTTP block
sed -i '/## <HTTPS REDIRECT>/, /## <\/HTTPS REDIRECT>/ s/^#//g' ./nginx/conf.d/default.conf

docker compose exec nginx nginx -s reload

echo "First run setup complete."