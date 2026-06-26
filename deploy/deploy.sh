#!/usr/bin/env bash
# deploy.sh — build and sync pressgangmutiny.com to web root
# Run from the site root: ./deploy/deploy.sh
set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WEB_ROOT="/var/www/pressgangmutiny.com"

echo "Building..."
cd "$SITE_DIR"
hugo --minify

echo "Syncing to $WEB_ROOT..."
rsync -av --delete public/ "$WEB_ROOT/"

echo "Reloading nginx..."
nginx -t && systemctl reload nginx

echo "Done. https://www.pressgangmutiny.com"
