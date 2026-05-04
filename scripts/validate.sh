#!/usr/bin/env bash
# validate.sh — 自动化验证脚本
set -euo pipefail

ROOT="$(dirname "$(dirname "$0")")"
errors=0

echo "=== 验证检查 ==="

# 1. SKILL.md frontmatter
echo -n "SKILL.md frontmatter: "
if head -1 "$ROOT/SKILL.md" | grep -q "^---"; then
  echo "✓"
else
  echo "✗ 缺少 frontmatter"
  errors=$((errors+1))
fi

# 2. .claude/agents/ 数量
echo -n ".claude/agents/ 数量: "
count=$(ls "$ROOT/.claude/agents/"*.md 2>/dev/null | wc -l)
if [ "$count" -eq 13 ]; then
  echo "✓ ($count)"
else
  echo "✗ ($count/13)"
  errors=$((errors+1))
fi

# 3. PRODUCT_PLAN 残留（排除 checklist 自身引用）
echo -n "PRODUCT_PLAN 残留: "
if grep -rn "PRODUCT_PLAN" --include="*.md" "$ROOT/agents/" "$ROOT/templates/" "$ROOT/.claude/agents/" "$ROOT/SKILL.md" 2>/dev/null | grep -v CHANGELOG | grep -v worktrees | grep -v quality-gatekeeper | grep -q .; then
  echo "✗ 有残留"
  errors=$((errors+1))
else
  echo "✓ 无残留"
fi

# 4. trends 2025（排除 checklist 自身引用）
echo -n "trends 2025 残留: "
if grep -rn "trends 2025" "$ROOT/agents/" "$ROOT/.claude/agents/" "$ROOT/templates/" 2>/dev/null | grep -v quality-gatekeeper | grep -q .; then
  echo "✗ 有残留"
  errors=$((errors+1))
else
  echo "✓ 无残留"
fi

# 5. 上下文管理
echo -n "上下文管理覆盖: "
count=$(grep -l "上下文管理" "$ROOT/agents/"*.md 2>/dev/null | wc -l)
if [ "$count" -eq 13 ]; then
  echo "✓ ($count/13)"
else
  echo "✗ ($count/13)"
  errors=$((errors+1))
fi

# 6. 检查 agent 必需章节
echo -n "Agent 必需章节: "
missing=0
for f in "$ROOT"/agents/*.md; do
  for section in "任务" "输出" "质量门禁" "上下文管理"; do
    if ! grep -q "## .*${section}" "$f"; then
      echo -n "$(basename $f) 缺少 ${section} "
      missing=$((missing+1))
    fi
  done
done
if [ $missing -eq 0 ]; then
  echo "✓"
else
  echo "✗ ($missing 项缺失)"
  errors=$((errors+1))
fi

# 7. 检查模板元数据
echo -n "模板元数据: "
missing=0
for f in "$ROOT"/templates/*.md; do
  if ! grep -q "| 字段 |" "$f" && ! grep -q "| 字段" "$f"; then
    echo -n "$(basename $f) "
    missing=$((missing+1))
  fi
done
if [ $missing -eq 0 ]; then
  echo "✓"
else
  echo "✗ ($missing 个缺失)"
fi

# 8. 检查 Agent 行数范围
echo -n "Agent 行数范围: "
line_issues=0
for f in "$ROOT"/agents/*.md; do
  name=$(basename "$f" .md)
  lines=$(wc -l < "$f")
  if [ $lines -lt 80 ]; then
    echo -n "$name($lines 行偏少) "
    line_issues=$((line_issues+1))
  elif [ $lines -gt 400 ]; then
    echo -n "$name($lines 行偏多) "
    line_issues=$((line_issues+1))
  fi
done
if [ $line_issues -eq 0 ]; then
  echo "✓ (全部在 80-400 行范围)"
else
  echo " ⚠ ($line_issues 个超出范围)"
fi

echo ""
if [ $errors -eq 0 ]; then
  echo "全部通过 ✓"
  exit 0
else
  echo "$errors 项失败 ✗"
  exit 1
fi
