#!/usr/bin/env bash
# bin/compile <build-dir> <cache-dir>

# Fail fast
set -e
set -o pipefail

# Debug
set -x

# Parse params
BUILD_DIR=$1
CACHE_DIR=$2
ENV_DIR=$3

# Set buildpack dir
BUILDPACK_DIR=$(cd "$(dirname "$0")"; cd ..; pwd)

# Set pinned version
MERCURE_VERSION="0.15.7"

# If a version hasn't been specified, use the pinned version
if [ -f "$ENV_DIR/MERCURE_VERSION" ]; then
  VERSION=$(cat "$ENV_DIR/MERCURE_VERSION")
else
  VERSION="$MERCURE_VERSION"
fi

MERCURE_BINARY="mercure"

# Download
if [ ! -f "$CACHE_DIR/${MERCURE_BINARY}-${VERSION}" ] || [ -n "$NOCACHE_MERCURE" ]; then
  echo "-----> Installing v${VERSION} of the Mercure Hub"
  wget --quiet -O mercure.tar.gz https://github.com/dunglas/mercure/releases/download/v${VERSION}/${MERCURE_BINARY}-legacy_Linux_x86_64.tar.gz

  tar -xzf mercure.tar.gz

  rm -f "$CACHE_DIR/${MERCURE_BINARY}-*" || true
  mv ${MERCURE_BINARY} "$CACHE_DIR/${MERCURE_BINARY}-${VERSION}"
else
  echo "-----> Mercure Hub v${VERSION} found in cache"
fi

# Copy binaries
mkdir -p "$BUILD_DIR/bin"
cp "$CACHE_DIR/${MERCURE_BINARY}-${VERSION}" "$BUILD_DIR/bin/mercure"

# Install the runner
echo "-----> Installing Mercure Hub runner"
mkdir -p "$BUILD_DIR/.profile.d"
cp "$BUILDPACK_DIR/extra/mercure.sh" "$BUILD_DIR/.profile.d/"
chmod +x "$BUILD_DIR/.profile.d/mercure.sh"
