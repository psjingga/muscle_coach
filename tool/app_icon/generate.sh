#!/usr/bin/env bash
# Membuat ulang semua ikon aplikasi dari lib/app/theme/app_logo.dart.
#   bash tool/app_icon/generate.sh
set -euo pipefail
cd "$(dirname "$0")/../.."
FLUTTER="${FLUTTER:-fvm flutter}"
$FLUTTER test tool/app_icon/render_icons_test.dart
# App Store menolak ikon iOS yang punya kanal alpha → simpan sebagai RGB.
IOS=ios/Runner/Assets.xcassets/AppIcon.appiconset
if python3 -c "import PIL" 2>/dev/null; then
  python3 - "$IOS" <<'PY'
import glob, sys
from PIL import Image
for f in glob.glob(sys.argv[1] + "/*.png"):
    Image.open(f).convert("RGB").save(f, optimize=True)
PY
else
  # Cadangan tanpa Pillow: lewat JPEG kualitas maksimum.
  for f in "$IOS"/*.png; do
    sips -s format jpeg -s formatOptions 100 "$f" --out "$f.jpg" >/dev/null
    sips -s format png "$f.jpg" --out "$f" >/dev/null
    rm "$f.jpg"
  done
fi
echo "Ikon diperbarui."
