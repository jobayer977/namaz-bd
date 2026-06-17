#!/bin/bash
set -euo pipefail

# Builds NamazBD.app from the Swift Package Manager binary.
# Use this when full Xcode is not installed (Command Line Tools only,
# so `xcodebuild` is unavailable). Produces a signed, double-clickable
# menu-bar app under dist/NamazBD.app.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${1:-release}"
VERSION="${APP_VERSION:-0.1.0}"
APP="$ROOT/dist/NamazBD.app"
CONTENTS="$APP/Contents"

cd "$ROOT"
swift build -c "$CONFIG"
BIN="$(swift build -c "$CONFIG" --show-bin-path)/NamazBD"

rm -rf "$APP"
mkdir -p "$CONTENTS/MacOS"
cp "$BIN" "$CONTENTS/MacOS/NamazBD"

cat > "$CONTENTS/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key><string>NamazBD</string>
	<key>CFBundleDisplayName</key><string>Namaz BD</string>
	<key>CFBundleExecutable</key><string>NamazBD</string>
	<key>CFBundleIdentifier</key><string>dev.jobayer.namazbd</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>CFBundleShortVersionString</key><string>${VERSION}</string>
	<key>CFBundleVersion</key><string>${VERSION}</string>
	<key>LSMinimumSystemVersion</key><string>13.0</string>
	<key>LSUIElement</key><true/>
	<key>NSHumanReadableCopyright</key><string>Namaz BD</string>
</dict>
</plist>
PLIST

printf 'APPL????' > "$CONTENTS/PkgInfo"

codesign --force --sign - "$APP" >/dev/null 2>&1 || true

echo "Built: $APP"
