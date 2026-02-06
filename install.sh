#!/usr/bin/env bash
set -euo pipefail

# install.sh — Local development setup for nycapt.github.io
# Usage: curl -fsSL https://nycapt.github.io/install.sh | bash

REPO_URL="https://github.com/nycapt/nycapt.github.io.git"
REPO_DIR="nycapt.github.io"
DEFAULT_PORT=8000

info() { printf '\033[1;34m%s\033[0m\n' "$*"; }
error() { printf '\033[1;31mError: %s\033[0m\n' "$*" >&2; exit 1; }

# Check for git
command -v git >/dev/null 2>&1 || error "git is not installed. Please install git first."

# Clone or update the repository
if [ -d "$REPO_DIR/.git" ]; then
  info "Repository already exists. Pulling latest changes..."
  git -C "$REPO_DIR" pull --ff-only origin main
else
  info "Cloning $REPO_URL..."
  git clone "$REPO_URL" "$REPO_DIR"
fi

cd "$REPO_DIR"

info "Repository ready at $(pwd)"

# Find an available server command and start a local preview
if command -v python3 >/dev/null 2>&1; then
  info "Starting local server at http://localhost:$DEFAULT_PORT"
  python3 -m http.server "$DEFAULT_PORT"
elif command -v python >/dev/null 2>&1; then
  info "Starting local server at http://localhost:$DEFAULT_PORT"
  python -m SimpleHTTPServer "$DEFAULT_PORT"
elif command -v npx >/dev/null 2>&1; then
  info "Starting local server at http://localhost:$DEFAULT_PORT"
  npx -y serve -l "$DEFAULT_PORT"
else
  info "No local server available (python3, python, or npx)."
  info "Open $(pwd)/index.html in your browser to view the site."
fi
