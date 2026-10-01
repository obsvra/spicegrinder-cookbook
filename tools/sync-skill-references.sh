#!/usr/bin/env bash
# Refresh plugins/spicegrinder/skills/*/references/ from the SpiceGrinder source tree.
#
# Why this exists: in the private repo those reference files are symlinks into
# docs/, so they can never go stale. Here they have to be real files, which means
# they drift silently the moment a doc changes. As of 2026-09-13 they were behind
# by one component (Convert, Pro) and three sections of the model-format
# reference, including the compact .sgm format.
#
# SKILL.md is deliberately NOT touched. The public copies differ from the private
# ones on purpose: where the internal version falls back to a connected MCP
# server, the public one points at obsvra.com/get-spicegrinder instead, because a
# reader of this repo has no MCP server. Syncing SKILL.md would clobber that.
#
# Requires a checkout of the private spicegrinder repo.
#
# Usage:
#   ./tools/sync-skill-references.sh                 # refresh, report what changed
#   ./tools/sync-skill-references.sh --check         # report only, exit 1 if stale
#   SPICEGRINDER_REPO=/path/to/repo ./tools/sync-skill-references.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${SPICEGRINDER_REPO:-$(cd "$ROOT/../spicegrinder" 2>/dev/null && pwd || true)}"
CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

if [[ -z "$SRC" || ! -d "$SRC/agent/skills" ]]; then
  echo "ERROR: cannot find the spicegrinder checkout (looked for \$SPICEGRINDER_REPO, then ../spicegrinder)." >&2
  echo "Set SPICEGRINDER_REPO=/path/to/spicegrinder and re-run." >&2
  exit 1
fi

# Files to hold back from the sync, if any ever need to be. Empty by design:
# Customization.md was held back until 2026-09-13, when the decision was made to
# publish it across every channel — this repo, the skills zip, and obsvra.com/docs.
HOLD_BACK=()

changed=0
checked=0
held=0

for skill_dir in "$ROOT"/plugins/spicegrinder/skills/*/; do
  skill="$(basename "$skill_dir")"
  src_refs="$SRC/agent/skills/$skill/references"
  [[ -d "$src_refs" ]] || { echo "  $skill: no references/ upstream, skipping"; continue; }

  for src_file in "$src_refs"/*; do
    [[ -e "$src_file" ]] || continue
    name="$(basename "$src_file")"
    dest="$skill_dir/references/$name"

    for h in "${HOLD_BACK[@]}"; do
      if [[ "$name" == "$h" ]]; then
        echo "  $skill: HOLDING BACK $name (see HOLD_BACK note above)"
        held=$((held + 1))
        continue 2
      fi
    done

    checked=$((checked + 1))

    # -L dereferences: upstream these are symlinks into docs/, and what we want
    # here is the content they point at.
    if [[ -f "$dest" ]] && cmp -s "$src_file" "$dest"; then
      continue
    fi

    old=0; [[ -f "$dest" ]] && old=$(wc -c < "$dest" | tr -d ' ')
    new=$(wc -c < "$src_file" | tr -d ' ')
    printf '  %-26s %-38s %s -> %s bytes\n' "$skill" "$name" "$old" "$new"
    changed=$((changed + 1))

    if [[ $CHECK_ONLY -eq 0 ]]; then
      mkdir -p "$(dirname "$dest")"
      cp -L "$src_file" "$dest"
    fi
  done
done

echo
if [[ $changed -eq 0 ]]; then
  echo "All $checked reference files are current."
  exit 0
fi

if [[ $CHECK_ONLY -eq 1 ]]; then
  echo "$changed of $checked reference files are STALE. Run without --check to refresh."
  exit 1
fi

echo "Refreshed $changed of $checked reference files. SKILL.md files were not touched."
[[ $held -gt 0 ]] && echo "$held file(s) held back deliberately -- see HOLD_BACK in this script." 
echo "Review the diff before committing -- these ship to anyone using the public skills."
