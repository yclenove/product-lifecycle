#!/usr/bin/env bash
# 批量更新文档路径引用
# 用法：bash scripts/relink-docs.sh [--dry-run]

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

apply_replacements() {
  local file="$1"
  local tmp
  tmp=$(mktemp)
  cp "$file" "$tmp"

  sed -i \
    -e 's|docs/long-running/|docs/07-long-running/|g' \
    -e 's|docs/QUICK-START\.md|docs/01-getting-started/QUICK-START.md|g' \
    -e 's|docs/DECISION-TREE\.md|docs/01-getting-started/DECISION-TREE.md|g' \
    -e 's|docs/FAQ\.md|docs/01-getting-started/FAQ.md|g' \
    -e 's|docs/SKILL-CLAUDE-CODE\.md|docs/02-tools/SKILL-CLAUDE-CODE.md|g' \
    -e 's|docs/SKILL-CURSOR\.md|docs/02-tools/SKILL-CURSOR.md|g' \
    -e 's|docs/SKILL-OTHER-TOOLS\.md|docs/02-tools/SKILL-OTHER-TOOLS.md|g' \
    -e 's|docs/WINDSURF-GUIDE\.md|docs/02-tools/WINDSURF-GUIDE.md|g' \
    -e 's|docs/CURSOR-RULES-INTEGRATION\.md|docs/02-tools/CURSOR-RULES-INTEGRATION.md|g' \
    -e 's|docs/WORKFLOW_PLAN\.md|docs/03-workflow/WORKFLOW_PLAN.md|g' \
    -e 's|docs/WORKFLOW_DETAILS\.md|docs/03-workflow/WORKFLOW_DETAILS.md|g' \
    -e 's|docs/AGENT-COMMUNICATION\.md|docs/03-workflow/AGENT-COMMUNICATION.md|g' \
    -e 's|docs/SKILL-ASSETS\.md|docs/04-reference/SKILL-ASSETS.md|g' \
    -e 's|docs/SKILL-INTEGRATION\.md|docs/04-reference/SKILL-INTEGRATION.md|g' \
    -e 's|docs/MODEL-CONFIG\.md|docs/04-reference/MODEL-CONFIG.md|g' \
    -e 's|docs/DOC-MAP\.md|docs/04-reference/DOC-MAP.md|g' \
    -e 's|docs/CONSISTENCY-CHECKLIST\.md|docs/04-reference/CONSISTENCY-CHECKLIST.md|g' \
    -e 's|docs/TROUBLESHOOTING\.md|docs/06-troubleshooting/TROUBLESHOOTING.md|g' \
    -e 's|docs/archive/|docs/iterations/_legacy-by-role/|g' \
    -e 's|docs/PRD-|docs/iterations/current/product/PRD-|g' \
    -e 's|docs/MKT-|docs/iterations/current/market/MKT-|g' \
    -e 's|docs/ARCH-|docs/iterations/current/architecture/ARCH-|g' \
    -e 's|docs/DEV-|docs/iterations/current/dev/DEV-|g' \
    -e 's|docs/QA-|docs/iterations/current/qa/QA-|g' \
    -e 's|docs/QG-|docs/iterations/current/quality-gate/QG-|g' \
    -e 's|docs/SCOUT-|docs/iterations/current/scout/SCOUT-|g' \
    -e 's|docs/FEEDBACK-|docs/iterations/current/feedback/FEEDBACK-|g' \
    -e 's|docs/ITER-|docs/iterations/current/iteration/ITER-|g' \
    "$tmp" 2>/dev/null || {
      # macOS/BSD sed fallback without -i same syntax
      sed \
        -e 's|docs/long-running/|docs/07-long-running/|g' \
        "$file" > "$tmp"
    }

  if ! cmp -s "$file" "$tmp"; then
    if [ "$DRY_RUN" = true ]; then
      echo "[would update] $file"
    else
      mv "$tmp" "$file"
      echo "[updated] $file"
    fi
    return 0
  fi
  rm -f "$tmp"
  return 1
}

count=0
while IFS= read -r -d '' f; do
  case "$f" in
    */_legacy-by-role/*|*/scripts/relink-docs.sh) continue ;;
  esac
  if apply_replacements "$f"; then
    count=$((count + 1))
  fi
done < <(find "$ROOT_DIR" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.ps1' -o -name '*.yml' \) \
  ! -path '*/.git/*' ! -path '*/node_modules/*' -print0)

echo ""
echo "完成：${count} 个文件已更新"
