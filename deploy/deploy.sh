#!/usr/bin/env bash
# build.sh (historically deploy.sh) — build the Hugo site.
#
# WHAT THIS DOES *NOT* DO ANY MORE: publish the live site.
#
# The live site at https://www.pressgangmutiny.com is served by Cloudflare Pages,
# built from the GitHub repo pressgangmutiny/website. The ONLY thing that
# publishes it is a push to that repo. Verified 2026-07-27: `curl -I` on the
# live host returns `server: cloudflare`.
#
# Until 2026-07-27 this script also rsynced public/ to /var/www/pressgangmutiny.com
# and reloaded nginx. That target is dead — no nginx server block references it
# (checked across sites-enabled/ and conf.d/). The rsync succeeded, the script
# printed "Done. https://www.pressgangmutiny.com", and nothing about the live
# site changed. That is the worst shape a deploy script can have: confident
# success, zero effect. Both steps removed rather than repaired.
#
# The build below IS still load-bearing. nginx serves the droplet preview and
# several content paths (/about, /tour, /music, /news, /releases, /press-kit,
# /the-shanty-show, /videos, /preview/) by aliasing this repo's public/ directory
# directly — so `hugo` alone updates those surfaces the moment it finishes.
# No sync step is needed for them, and none ever was.
#
# Run from anywhere: ./deploy/deploy.sh
set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

echo "Building Hugo site..."
hugo --minify

cat <<EOF

Build complete.

  Droplet preview  — LIVE NOW, nginx reads public/ directly:
                     https://bellweatherprotocol.com/preview/

  Public site      — NOT updated by this script. Cloudflare Pages publishes it
                     from GitHub. To ship, review the diff and push:

                       git -C $SITE_DIR status
                       git -C $SITE_DIR add -A
                       git -C $SITE_DIR commit -m "your message"
                       git -C $SITE_DIR push origin main

                     Cloudflare rebuilds on push; allow a minute, then confirm
                     the change is actually visible on www.pressgangmutiny.com
                     before calling it done.

EOF
