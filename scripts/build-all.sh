#!/usr/bin/env bash
# Build all keyboards defined in this repo.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

failed=()

for cfg in "$REPO_ROOT"/keyboards/*/config.json; do
    [[ -f "$cfg" ]] || continue
    kb=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d['keyboard'])" "$cfg")
    km=$(python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print(d['keymap'])" "$cfg")
    echo "==> Building $kb:$km"
    if ! qmk compile -kb "$kb" -km "$km"; then
        failed+=("$kb:$km")
    fi
done

if [[ ${#failed[@]} -gt 0 ]]; then
    echo ""
    echo "FAILED builds:"
    printf '  %s\n' "${failed[@]}"
    exit 1
else
    echo ""
    echo "All builds succeeded."
fi
