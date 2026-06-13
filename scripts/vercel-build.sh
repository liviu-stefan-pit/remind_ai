#!/usr/bin/env bash
set -euo pipefail

# Always run from repo root regardless of Vercel working directory.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> remind_ai build starting (root: ${ROOT})"

FLUTTER_DIR="${HOME}/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  echo "==> Cloning Flutter stable to ${FLUTTER_DIR}"
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
fi

export PATH="${PATH}:${FLUTTER_DIR}/bin"

flutter --version
flutter pub get
flutter build web --release --pwa-strategy=none

# Killer SW for browsers that still have an old Flutter caching worker.
cp web/sw_migration.js build/web/flutter_service_worker.js

# Per-deploy cache bust: inline script in index.html clears SW + Cache API once.
BUILD_ID="${VERCEL_GIT_COMMIT_SHA:-$(date +%s)}"
sed -i.bak "s/__BUILD_ID__/${BUILD_ID}/g" build/web/index.html
rm -f build/web/index.html.bak

echo "==> Build complete (BUILD_ID=${BUILD_ID})"
test -f build/web/index.html
test -f build/web/main.dart.js
test -f build/web/flutter_service_worker.js
ls -la build/web/index.html build/web/main.dart.js build/web/flutter_service_worker.js
