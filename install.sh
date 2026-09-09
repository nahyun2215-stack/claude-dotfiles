#!/usr/bin/env bash
# Links every skill in ./skills into ~/.claude/skills (Linux / macOS).
# Re-run any time; it is idempotent.

set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$repo/skills"
dest="$HOME/.claude/skills"

mkdir -p "$dest"

for d in "$src"/*/; do
  name="$(basename "$d")"
  ln -sfn "$d" "$dest/$name"
  echo "linked  $name  ->  $d"
done

# Optional: also link into Codex (~/.codex/skills). Uncomment if you use Codex.
# codex="$HOME/.codex/skills"
# mkdir -p "$codex"
# for d in "$src"/*/; do
#   ln -sfn "$d" "$codex/$(basename "$d")"
# done

echo
echo "Done. Skills linked into $dest"
