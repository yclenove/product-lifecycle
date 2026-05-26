#!/usr/bin/env bash
# lint-prompts.sh — 检查 agents/ 与 .claude/agents/ 的 prompt 结构完整性
#
# 检查项：
#   1. 必备章节：你的职责、你的任务、产出 / 输出、质量门禁
#   2. {{PROJECT_NAME}} 占位符存在
#   3. 推荐方法论 skills 章节存在
#   4. .claude/agents/*.md 含 frontmatter
#   5. .cursor/agents/*.md 含 frontmatter + Read 引用

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_err()  { echo -e "${RED}[FAIL]${NC} $*"; ERRORS=$((ERRORS+1)); }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; WARNINGS=$((WARNINGS+1)); }
log_ok()   { echo -e "${GREEN}[ OK ]${NC} $*"; }

# 必备章节 anchor
REQUIRED_SECTIONS=("你的职责" "## 你的任务" "## 产出\\|## 输出" "## 质量门禁\\|## 项目现状")

check_agents_truth() {
  echo "=== 检查 agents/（真源） ==="
  for f in "$ROOT_DIR"/agents/*.md; do
    local name
    name=$(basename "$f" .md)
    local issues=0

    # 推荐方法论 skills 章节
    if ! grep -q "推荐方法论 skills" "$f"; then
      log_warn "$name: 缺少「推荐方法论 skills」小节"
      issues=$((issues+1))
    fi

    # {{PROJECT_NAME}} 占位符
    if ! grep -q "{{PROJECT_NAME}}" "$f"; then
      log_err "$name: 缺少 {{PROJECT_NAME}} 占位符"
      issues=$((issues+1))
    fi

    # 必备章节（接受多种说法）
    if ! grep -qE "你的职责|你的核心能力|你的目标|你的工作" "$f"; then
      log_err "$name: 缺少「你的职责/核心能力/目标」"
      issues=$((issues+1))
    fi
    grep -qE "## 你的任务|## 工作流程" "$f" || log_warn "$name: 缺少「## 你的任务」"

    if grep -q "## 产出\\|## 输出" "$f"; then :; else
      log_err "$name: 缺少「## 产出」或「## 输出」"; issues=$((issues+1))
    fi

    [ "$issues" -eq 0 ] && log_ok "$name"
  done
  echo ""
}

check_claude_agents() {
  echo "=== 检查 .claude/agents/（带 frontmatter） ==="
  for f in "$ROOT_DIR"/.claude/agents/*.md; do
    local name
    name=$(basename "$f" .md)
    local issues=0

    # 必须以 --- 开头（frontmatter）
    if ! head -1 "$f" | grep -q "^---"; then
      log_err "$name: 缺少 frontmatter"
      issues=$((issues+1))
    fi

    # frontmatter 必含 description 和 tools
    head -10 "$f" | grep -q "^description:" || { log_err "$name: frontmatter 缺 description"; issues=$((issues+1)); }
    head -10 "$f" | grep -q "^tools:" || { log_err "$name: frontmatter 缺 tools"; issues=$((issues+1)); }

    [ "$issues" -eq 0 ] && log_ok "$name"
  done
  echo ""
}

check_cursor_agents() {
  echo "=== 检查 .cursor/agents/（薄封装） ==="
  for f in "$ROOT_DIR"/.cursor/agents/*.md; do
    local name
    name=$(basename "$f" .md)
    [ "$name" = "README" ] && continue

    local issues=0
    head -1 "$f" | grep -q "^---" || { log_err "$name: 缺少 frontmatter"; issues=$((issues+1)); }
    head -10 "$f" | grep -q "^name:" || { log_err "$name: frontmatter 缺 name"; issues=$((issues+1)); }
    head -10 "$f" | grep -q "^description:" || { log_err "$name: frontmatter 缺 description"; issues=$((issues+1)); }
    grep -qE "agents/$name\\.md" "$f" || log_warn "$name: 未引用 agents/$name.md"

    [ "$issues" -eq 0 ] && log_ok "$name"
  done
  echo ""
}

check_three_dirs_alignment() {
  echo "=== 检查三套 agents 目录角色对齐 ==="
  local truth=$(ls "$ROOT_DIR"/agents/*.md | xargs -n1 basename | sort | tr '\n' ' ')
  local claude=$(ls "$ROOT_DIR"/.claude/agents/*.md | xargs -n1 basename | sort | tr '\n' ' ')
  local cursor=$(ls "$ROOT_DIR"/.cursor/agents/*.md | xargs -n1 basename | grep -v "^README" | sort | tr '\n' ' ')

  if [ "$truth" != "$claude" ]; then
    log_err "agents/ 与 .claude/agents/ 角色集合不一致"
    echo "  agents/: $truth"
    echo "  .claude/agents/: $claude"
  else
    log_ok "agents/ 与 .claude/agents/ 角色集合一致"
  fi

  if [ "$truth" != "$cursor" ]; then
    log_err "agents/ 与 .cursor/agents/ 角色集合不一致"
    echo "  agents/: $truth"
    echo "  .cursor/agents/: $cursor"
  else
    log_ok "agents/ 与 .cursor/agents/ 角色集合一致"
  fi
  echo ""
}

check_agents_truth
check_claude_agents
check_cursor_agents
check_three_dirs_alignment

echo "=== 汇总 ==="
echo "  错误：$ERRORS"
echo "  警告：$WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
echo "全部通过 ✓"
