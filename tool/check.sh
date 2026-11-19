#!/usr/bin/env bash
# Quality gate lokal (setara CI): format, analyze, test Flutter.
set -euo pipefail
cd "$(dirname "$0")/.."

FLUTTER="flutter"; DART="dart"
if command -v fvm >/dev/null; then FLUTTER="fvm flutter"; DART="fvm dart"; fi

step() { printf '\n\033[1m▶ %s\033[0m\n' "$1"; }

step "dart format (cek)"
$DART format --output=none --set-exit-if-changed lib test integration_test

step "flutter analyze"
$FLUTTER analyze

step "flutter test"
$FLUTTER test

printf '\n\033[32m✔ Semua pemeriksaan lolos\033[0m\n'
