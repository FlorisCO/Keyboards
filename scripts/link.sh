#!/usr/bin/env bash
# Symlink every keymap in this repo into qmk_firmware.
# Run from anywhere; script resolves its own location.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
QMK_HOME="${QMK_HOME:-"$HOME/qmk_firmware"}"

if [[ ! -d "$QMK_HOME" ]]; then
    echo "ERROR: QMK firmware not found at $QMK_HOME"
    echo "Run 'qmk setup' first, or set QMK_HOME to the correct path."
    exit 1
fi

linked=0
for cfg in "$REPO_ROOT"/keyboards/*/config.json; do
    [[ -f "$cfg" ]] || continue
    kb=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d['keyboard'])" "$cfg")
    km=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d['keymap'])" "$cfg")
    src="$(dirname "$cfg")/keymap"
    dst="$QMK_HOME/keyboards/$kb/keymaps/$km"

    if [[ ! -d "$(dirname "$dst")" ]]; then
        echo "WARNING: $QMK_HOME/keyboards/$kb/keymaps/ does not exist — is '$kb' a valid keyboard?"
        continue
    fi

    if [[ -L "$dst" ]]; then
        echo "  already linked: $kb/$km"
    elif [[ -d "$dst" ]]; then
        echo "  WARNING: $dst exists and is not a symlink — skipping"
    else
        ln -s "$src" "$dst"
        echo "  linked: $kb/$km -> $dst"
        ((linked++))
    fi
done

echo "Done. $linked new link(s) created."
