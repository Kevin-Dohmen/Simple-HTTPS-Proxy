#!/bin/bash

DOMAIN="yourdomain.com" # Change to your actual domain

# Create necessary directories for certbot challenges
mkdir -p "./certbot/www"
mkdir -p "./certbot/conf"

# Start nginx and certbot containers
echo "Starting nginx and certbot containers..."
docker compose up -d nginx certbot

sleep 5

# Run certbot to obtain certificates using HTTP challenge
echo "Requesting SSL certificate for $DOMAIN using certbot..."
docker compose run --rm certbot certbot certonly --webroot \
    --webroot-path=/var/www/certbot \
    --register-unsafely-without-email \
    --agree-tos \
    -d "$DOMAIN"

echo "Certificate request complete. Reloading nginx..."

docker compose exec nginx nginx -s reload

echo "First run setup complete."