#!/usr/bin/env bash
set -euo pipefail

GODOT_VERSION="${GODOT_VERSION:-4.4.1}"
GODOT_BIN="${GODOT_BIN:-/tmp/godot}"

if ! command -v godot >/dev/null 2>&1 && [ ! -x "$GODOT_BIN" ]; then
  echo "Downloading Godot ${GODOT_VERSION}..."
  curl -L --fail --retry 3 \
    "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip" \
    -o /tmp/godot.zip
  unzip -oq /tmp/godot.zip -d /tmp/godot-bin
  mv "/tmp/godot-bin/Godot_v${GODOT_VERSION}-stable_linux.x86_64" "$GODOT_BIN"
  chmod +x "$GODOT_BIN"
fi

GODOT="${GODOT_BIN}"
command -v godot >/dev/null 2>&1 && GODOT="$(command -v godot)"

mkdir -p build
"$GODOT" --headless --editor --path . --quit
"$GODOT" --headless --path . --export-debug "Android" build/neon-wastes-debug.apk
echo "APK: $(pwd)/build/neon-wastes-debug.apk"
