#!/usr/bin/env bash
# Quality gate lokal (setara CI): format, analyze, test Flutter, typecheck &
# test Cloud Functions, lalu test Security Rules di Firebase Emulator.
#   tool/check.sh            → semua
#   tool/check.sh --no-emulator → lewati test emulator
set -euo pipefail
cd "$(dirname "$0")/.."

FLUTTER="flutter"; DART="dart"
if command -v fvm >/dev/null; then FLUTTER="fvm flutter"; DART="fvm dart"; fi

step() { printf '\n\033[1m▶ %s\033[0m\n' "$1"; }

step "dart format (cek)"
$DART format --output=none --set-exit-if-changed lib test

step "flutter analyze"
$FLUTTER analyze

step "flutter test"
$FLUTTER test

step "functions: install & typecheck"
(cd functions && { [ -d node_modules ] || npm ci; } && npm run typecheck)

step "functions: unit test"
(cd functions && npm test)

if [ "${1:-}" != "--no-emulator" ]; then
  step "functions + Security Rules: test di Emulator"
  (cd functions && npm run test:emulator)
fi

printf '\n\033[32m✔ Semua pemeriksaan lolos\033[0m\n'
