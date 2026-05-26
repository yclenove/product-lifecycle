#!/usr/bin/env bash
# 文档分门别类一次性脚本（幂等）
# 把 docs/ 根目录下的 26 个 md 移动到 7 个分类子目录

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DOCS="$ROOT_DIR/docs"

# 分类映射：目标目录|文件名
MAPPING=(
    "01-getting-started|QUICK-START.md"
    "01-getting-started|DECISION-TREE.md"
    "01-getting-started|FAQ.md"
    "02-tools|SKILL-CLAUDE-CODE.md"
    "02-tools|SKILL-CURSOR.md"
    "02-tools|SKILL-OTHER-TOOLS.md"
    "02-tools|WINDSURF-GUIDE.md"
    "02-tools|CURSOR-RULES-INTEGRATION.md"
    "03-workflow|WORKFLOW_PLAN.md"
    "03-workflow|WORKFLOW_DETAILS.md"
    "03-workflow|AGENT-COMMUNICATION.md"
    "04-reference|SKILL-ASSETS.md"
    "04-reference|SKILL-INTEGRATION.md"
    "04-reference|MODEL-CONFIG.md"
    "04-reference|DOC-MAP.md"
    "04-reference|CONSISTENCY-CHECKLIST.md"
    "05-advanced|CONTEXT-MANAGEMENT.md"
    "05-advanced|TOKEN-EFFICIENCY.md"
    "05-advanced|PERFORMANCE-BASELINE.md"
    "05-advanced|ACCESSIBILITY.md"
    "05-advanced|INTERNATIONALIZATION.md"
    "05-advanced|SECURITY.md"
    "05-advanced|LINT-RULES.md"
    "05-advanced|QUALITY-METRICS.md"
    "05-advanced|CHANGELOG-GUIDE.md"
    "06-troubleshooting|TROUBLESHOOTING.md"
)

cd "$ROOT_DIR"
moved=0
skipped=0

for entry in "${MAPPING[@]}"; do
    IFS='|' read -r dir file <<< "$entry"
    src="docs/$file"
    dst_dir="docs/$dir"
    dst="$dst_dir/$file"
    
    if [ ! -f "$src" ]; then
        if [ -f "$dst" ]; then
            echo "[SKIP] $file (已在 $dir/)"
            skipped=$((skipped + 1))
        else
            echo "[WARN] $file 既不在源也不在目标，跳过"
            skipped=$((skipped + 1))
        fi
        continue
    fi
    
    mkdir -p "$dst_dir"
    
    if git -C "$ROOT_DIR" ls-files --error-unmatch "$src" > /dev/null 2>&1; then
        git -C "$ROOT_DIR" mv "$src" "$dst"
        echo "[MV]   $src -> $dst"
    else
        mv "$src" "$dst"
        echo "[MV]   $src -> $dst (非 git 跟踪)"
    fi
    moved=$((moved + 1))
done

echo ""
echo "========================================"
echo "  完成：移动 $moved 个，跳过 $skipped 个"
echo "========================================"
