#!/bin/bash
set -e

FLUTTER_VERSION="3.24.5"
FLUTTER_DIR="$HOME/flutter"

# Remove corrupted Flutter installation if exists
if [ -d "$FLUTTER_DIR" ] && [ ! -d "$FLUTTER_DIR/packages/flutter_tools" ]; then
  echo "==> Removing corrupted Flutter installation..."
  rm -rf "$FLUTTER_DIR"
fi

if [ ! -d "$FLUTTER_DIR" ]; then
  echo "==> Downloading Flutter $FLUTTER_VERSION..."
  curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o /tmp/flutter.tar.xz
  tar -xf /tmp/flutter.tar.xz -C "$HOME"
fi

export PATH="$PATH:$FLUTTER_DIR/bin"

flutter config --no-analytics
flutter pub get
# --web-renderer html: drop the 6.75 MB CanvasKit WASM, restore native browser
#   scroll, native text, native a11y tree. Biggest single mobile win.
# --pwa-strategy offline-first (default): emit flutter_service_worker.js so
#   repeat visits serve from cache. Paired with the deletion of the
#   cache-wipe script in web/index.html.
flutter build web --release --web-renderer html --pwa-strategy offline-first
