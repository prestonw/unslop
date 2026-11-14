#!/usr/bin/env bash
# Install the unslop skill into Hermes Agent (~/.hermes/skills/creative/unslop).
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/prestonw/unslop/main/install-hermes.sh | bash
#   # or from a local clone:
#   bash install-hermes.sh
#
# Re-running updates the skill in place (your SKILL.md is replaced by upstream).
set -euo pipefail

REPO="${UNSLOP_REPO:-https://github.com/prestonw/unslop.git}"
DEST="${HOME}/.hermes/skills/creative/unslop"

SRC="$(mktemp -d)"/unslop
trap 'rm -rf "${SRC%/*}"' EXIT

echo "→ cloning ${REPO} (shallow)"
git clone --depth 1 -q "$REPO" "$SRC"
SRC_SKILL="$SRC/skills/unslop"

[ -f "$SRC_SKILL/SKILL.md" ] || { echo "✗ skills/unslop/SKILL.md not found in repo" >&2; exit 1; }

mkdir -p "$(dirname "$DEST")"
echo "→ installing to ${DEST}"
# Replace cleanly: keep the destination dir name, swap contents.
rm -rf "${DEST}.tmp"
cp -R "$SRC_SKILL" "${DEST}.tmp"
if [ -d "$DEST" ]; then rm -rf "$DEST"; fi
mv "${DEST}.tmp" "$DEST"

echo "✓ installed:"
find "$DEST" -type f | sort | sed 's/^/    /'
echo
echo "Done. Load it in a fresh Hermes session with: skill_view(name='unslop')"
