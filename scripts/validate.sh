#!/usr/bin/env bash
# validate.sh — 与 quality-gate.yml 对齐的汇总校验（v3.x · 20 Agent）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXPECTED=20
errors=0

echo "=== validate.sh（期望 ${EXPECTED} 个 Agent）==="

fail() {
  echo "✗ $*"
  errors=$((errors + 1))
}

pass() {
  echo "✓ $*"
}

# 1. SKILL.md frontmatter
echo -n "SKILL.md frontmatter: "
if head -1 "$ROOT/SKILL.md" | grep -q "^---"; then
  pass ""
else
  fail "缺少 frontmatter"
fi

# 2–4. 三套 agents 数量
for dir in agents .claude/agents; do
  echo -n "${dir}/ 数量: "
  count=$(find "$ROOT/$dir" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
  if [ "$count" -eq "$EXPECTED" ]; then
    pass "($count)"
  else
    fail "($count/${EXPECTED})"
  fi
done

echo -n ".cursor/agents/ 数量: "
cursor_count=$(find "$ROOT/.cursor/agents" -maxdepth 1 -name '*.md' ! -name 'README.md' | wc -l | tr -d ' ')
if [ "$cursor_count" -eq "$EXPECTED" ]; then
  pass "($cursor_count)"
else
  fail "($cursor_count/${EXPECTED})"
fi

# 5. PRODUCT_PLAN 残留
echo -n "PRODUCT_PLAN 残留: "
if grep -rn "PRODUCT_PLAN" --include="*.md" \
  "$ROOT/agents/" "$ROOT/templates/" "$ROOT/.claude/agents/" "$ROOT/SKILL.md" 2>/dev/null \
  | grep -v quality-gatekeeper | grep -q .; then
  fail "有残留"
else
  pass "无"
fi

# 6. 硬编码年份（搜索关键词）
echo -n "trends 2025/2024 残留: "
if grep -rnE "trends 202[45]" \
  "$ROOT/agents/" "$ROOT/.claude/agents/" "$ROOT/templates/" 2>/dev/null \
  | grep -v quality-gatekeeper | grep -q .; then
  fail "有残留"
else
  pass "无"
fi

# 7. Agent 结构（与 lint-prompts 口径一致）
echo -n "Agent 结构（职责/产出/Step0/skills）: "
struct_missing=0
for f in "$ROOT"/agents/*.md; do
  name=$(basename "$f" .md)
  grep -qE "你的职责|你的核心能力|你的目标|你的工作" "$f" || { echo -n "${name}(职责) "; struct_missing=$((struct_missing + 1)); }
  grep -qE "## 产出|## 输出" "$f" || { echo -n "${name}(产出) "; struct_missing=$((struct_missing + 1)); }
  grep -q "Step 0" "$f" || { echo -n "${name}(Step0) "; struct_missing=$((struct_missing + 1)); }
  grep -q "推荐方法论 skills" "$f" || { echo -n "${name}(skills) "; struct_missing=$((struct_missing + 1)); }
done
if [ "$struct_missing" -eq 0 ]; then
  pass ""
else
  fail "($struct_missing 项)"
fi

# 8. .claude/agents 与 agents 文件名对齐
echo -n "agents ↔ .claude/agents 同步: "
sync_issues=0
for f in "$ROOT"/agents/*.md; do
  name=$(basename "$f")
  [ -f "$ROOT/.claude/agents/$name" ] || { echo -n "${name%.md}(缺) "; sync_issues=$((sync_issues + 1)); }
done
if [ "$sync_issues" -eq 0 ]; then
  pass "(${EXPECTED}/${EXPECTED})"
else
  fail "($sync_issues 个缺失)"
fi

# 9. 残留旧 Agent 数量文案（11–19，当前应为 20）
echo -n "残留旧 Agent 数字(11-19): "
stale_count=0
for f in \
  "$ROOT/SKILL.md" \
  "$ROOT/README.md" \
  "$ROOT/docs/01-getting-started/QUICK-START.md" \
  "$ROOT/docs/01-getting-started/DECISION-TREE.md" \
  "$ROOT/docs/01-getting-started/FAQ.md" \
  "$ROOT/docs/04-reference/SKILL-ASSETS.md" \
  "$ROOT/docs/02-tools/SKILL-CURSOR.md" \
  "$ROOT/docs/02-tools/SKILL-CLAUDE-CODE.md" \
  "$ROOT/.cursor/agents/README.md"; do
  if [ -f "$f" ]; then
    if grep -nE '(1[1-9])\s*(个|位)?\s*(Agent|角色)|1[1-9]\s*角色' "$f" 2>/dev/null | grep -v '其余' | grep -q .; then
      stale_count=$((stale_count + 1))
      echo -n "$(basename "$f") "
    fi
  fi
done
if [ "$stale_count" -eq 0 ]; then
  pass "无"
else
  fail "($stale_count 个文件)"
fi

echo ""
if [ "$errors" -eq 0 ]; then
  echo "validate.sh 全部通过 ✓"
  exit 0
fi
echo "validate.sh：$errors 项失败 ✗"
exit 1
