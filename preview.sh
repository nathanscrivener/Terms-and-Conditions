#!/usr/bin/env bash
# Build and serve the site locally for review.
# Nothing here touches GitHub — pushes to `main` never deploy.
#
#   ./preview.sh          → http://localhost:3300/Terms-and-Conditions/
#
# Requires Docker (host has no Ruby/Jekyll).

set -euo pipefail
cd "$(dirname "$0")"

PORT="${1:-3300}"

echo "Building site with the github-pages gem (same versions as GitHub Pages)..."
echo "Review at: http://localhost:${PORT}/Terms-and-Conditions/"
echo "Press Ctrl+C to stop."

docker run --rm -it \
  --volume="$PWD:/srv/jekyll" \
  --publish="${PORT}:4000" \
  ghcr.io/github/pages-github-pages:jekyll \
  bash -c "bundle install --quiet && bundle exec jekyll serve --host 0.0.0.0 --port 4000 --livereload"