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

BUILD_ID="${VERCEL_GIT_COMMIT_SHA:-$(date +%s)}"
echo "==> BUILD_ID=${BUILD_ID}"

# Manual recovery only — not used in automatic migration (Trojan SW handles that).
cp web/update.html build/web/update.html
sed -i.bak "s/__BUILD_ID__/${BUILD_ID}/g" build/web/update.html
rm -f build/web/update.html.bak

# Trojan killer SW: byte change every deploy; clears caches, unregisters, silent same-URL refresh.
cp web/sw_migration.js build/web/flutter_service_worker.js
sed -i.bak "s/__BUILD_ID__/${BUILD_ID}/g" build/web/flutter_service_worker.js
rm -f build/web/flutter_service_worker.js.bak

# Per-deploy cache bust in index.html (script URLs + inline migration).
sed -i.bak "s/__BUILD_ID__/${BUILD_ID}/g" build/web/index.html
rm -f build/web/index.html.bak

# Preamble forces SW update() on every bootstrap load; version main.dart.js URL.
cat web/bootstrap_preamble.js build/web/flutter_bootstrap.js > build/web/flutter_bootstrap.tmp.js
mv build/web/flutter_bootstrap.tmp.js build/web/flutter_bootstrap.js
sed -i.bak "s/main\\.dart\\.js/main.dart.js?v=${BUILD_ID}/g" build/web/flutter_bootstrap.js
rm -f build/web/flutter_bootstrap.js.bak

echo "==> Build complete"
test -f build/web/index.html
test -f build/web/update.html
test -f build/web/main.dart.js
test -f build/web/flutter_service_worker.js
ls -la build/web/index.html build/web/update.html build/web/main.dart.js build/web/flutter_service_worker.js
