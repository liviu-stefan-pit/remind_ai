#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="${HOME}/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
fi

export PATH="${PATH}:${FLUTTER_DIR}/bin"

flutter pub get
flutter build web --release --pwa-strategy=none
cp web/sw_migration.js build/web/flutter_service_worker.js
