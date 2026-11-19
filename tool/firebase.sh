#!/usr/bin/env bash
# Menjalankan Firebase CLI dengan JDK >= 21 (syarat Firebase Emulator).
# Bila `java` default lebih lama, cari JDK 21+ tanpa mengubah default sistem.
set -euo pipefail

java_major() { "$1" -version 2>&1 | sed -nE 's/.*version "([0-9]+).*/\1/p' | head -1; }

if [ "$(java_major java 2>/dev/null || echo 0)" -lt 21 ] 2>/dev/null; then
  for home in "${JAVA21_HOME:-}" "$(/usr/libexec/java_home -v 21+ 2>/dev/null || true)" \
    /opt/homebrew/opt/openjdk@21 /usr/local/opt/openjdk@21 /opt/homebrew/opt/openjdk; do
    if [ -n "$home" ] && [ -x "$home/bin/java" ] && [ "$(java_major "$home/bin/java")" -ge 21 ]; then
      export JAVA_HOME="$home" PATH="$home/bin:$PATH"
      break
    fi
  done
fi

exec firebase "$@"
