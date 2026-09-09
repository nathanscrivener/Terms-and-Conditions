#!/usr/bin/env bash
# Build and serve the site locally for review.
# Nothing here touches GitHub — pushes to `main` never deploy.
#
#   ./preview.sh          → http://localhost:3300/
#   ./preview.sh 3400     → http://localhost:3400/
#
# Serves at the ROOT of the port (baseurl is stripped for the preview build).
# The container runs detached and keeps running until you stop it:
#
#   docker rm -f tc-preview
#
# Requires Docker (host has no Ruby/Jekyll).

set -euo pipefail
cd "$(dirname "$0")"

PORT="${1:-3300}"

echo "Building preview site (baseurl stripped, served at the port root)..."
docker run --rm -v "$PWD:/srv/jekyll" jekyll/jekyll:4.2.2 sh -c '
  gem install jekyll-seo-tag jekyll-theme-minimal --no-document >/dev/null 2>&1
  jekyll build --source /srv/jekyll --destination /srv/jekyll/_preview --config /srv/jekyll/_config.yml,/srv/jekyll/_config.preview.yml 2>&1 | tail -2
'

# Replace any previous preview container.
docker rm -f tc-preview >/dev/null 2>&1 || true
docker run -d --name tc-preview \
  --publish "${PORT}:80" \
  --volume "$PWD/_preview:/usr/share/nginx/html:ro" \
  nginx:alpine >/dev/null

echo "Review at: http://localhost:${PORT}/"
echo "Rebuild after edits: ./preview.sh    ·    Stop: docker rm -f tc-preview"