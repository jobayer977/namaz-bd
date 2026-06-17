#!/bin/bash
set -euo pipefail

# Builds NamazBD.app and packages it into a drag-to-Applications DMG.
# No Apple Developer account required (app is ad-hoc signed).

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/dist/NamazBD.app"
DMG="$ROOT/dist/NamazBD.dmg"
STAGE="$ROOT/dist/dmg-stage"

"$ROOT/scripts/build-app.sh" release

rm -rf "$STAGE" "$DMG"
mkdir -p "$STAGE"
cp -R "$APP" "$STAGE/NamazBD.app"
ln -s /Applications "$STAGE/Applications"

hdiutil create \
    -volname "Namaz BD" \
    -srcfolder "$STAGE" \
    -ov -format UDZO \
    "$DMG" >/dev/null

rm -rf "$STAGE"
echo "Built: $DMG"
