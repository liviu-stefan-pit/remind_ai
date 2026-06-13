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
cp web/sw_migration.js build/web/flutter_service_worker.js

echo "==> Build complete"
test -f build/web/index.html
test -f build/web/main.dart.js
test -f build/web/flutter_service_worker.js
ls -la build/web/index.html build/web/main.dart.js build/web/flutter_service_worker.js
