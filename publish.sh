#!/usr/bin/env bash
# Publish reviewed work live.
#
# Promotes the current `main` to `gh-pages`, which is the GitHub Pages
# source branch. The live site (terms.scrivener.co.nz via the Nginx proxy)
# updates only when this script is run — pushing `main` alone never deploys.
#
#   ./publish.sh "optional message"

set -euo pipefail
cd "$(dirname "$0")"

# Must be on main and up to date before publishing.
git fetch origin
git checkout main
if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree is dirty — commit or stash before publishing." >&2
  exit 1
fi
git pull --ff-only origin main

MSG="${1:-Publish $(git rev-parse --short HEAD)}"
git push origin "main:gh-pages" -m "$MSG"

echo "Pushed main → gh-pages. GitHub Pages will rebuild and the site will go live shortly."
echo "Track the build: https://github.com/nathanscrivener/Terms-and-Conditions/deployments"