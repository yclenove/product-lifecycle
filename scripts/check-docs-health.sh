#!/usr/bin/env bash
# check-docs-health.sh — 检查文档健康度（数量口径、链接、模板对应）

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

# 期望的角色总数
EXPECTED_COUNT=20

# 真源 agents 数量
TRUTH_COUNT=$(ls "$ROOT_DIR"/agents/*.md | wc -l | xargs)

if [ "$TRUTH_COUNT" -ne "$EXPECTED_COUNT" ]; then
  log_err "agents/ 真源数量 $TRUTH_COUNT != 期望 $EXPECTED_COUNT"
else
  log_ok "agents/ 真源数量 = $EXPECTED_COUNT"
fi

# ───────────────────────────────────────────
# 数量口径检查：关键文档中的「N 个 Agent」描述
# ───────────────────────────────────────────
echo ""
echo "=== 数量口径检查 ==="

check_count_in() {
  local file="$1"
  local pattern="$2"
  local label="$3"

  local actual
  actual=$(grep -oE "$pattern" "$file" 2>/dev/null | head -1 | grep -oE "[0-9]+" || echo "")

  if [ -z "$actual" ]; then
    log_warn "$file: 未找到「$label」"
    return
  fi

  if [ "$actual" != "$EXPECTED_COUNT" ]; then
    log_err "$file: $label = $actual，期望 $EXPECTED_COUNT"
  else
    log_ok "$file: $label = $actual ✓"
  fi
}

check_count_in "$ROOT_DIR/SKILL.md" "[0-9]+个Agent" "frontmatter description"
check_count_in "$ROOT_DIR/SKILL.md" "通过 [0-9]+ 个专业" "概述段"
check_count_in "$ROOT_DIR/README.md" "通过 \\*\\*[0-9]+ 个" "顶部段"
check_count_in "$ROOT_DIR/README.md" "## [0-9]+ 个 Agent 角色" "角色表标题"
check_count_in "$ROOT_DIR/docs/SKILL-ASSETS.md" "## [0-9]+ Agent 角色与产出" "速览表标题"
check_count_in "$ROOT_DIR/docs/SKILL-CURSOR.md" "固定 \\*\\*[0-9]+ 个角色" "Best practices"
check_count_in "$ROOT_DIR/docs/DECISION-TREE.md" "企业级 → 全部 [0-9]+ 个" "决策树企业级"
check_count_in "$ROOT_DIR/docs/QUICK-START.md" "不需要一次用全部 [0-9]+ 个" "QUICK-START 提示"
check_count_in "$ROOT_DIR/docs/FAQ.md" "小项目也需要 [0-9]+ 个" "FAQ"
check_count_in "$ROOT_DIR/docs/DOC-MAP.md" "agents/\\*\\.md（[0-9]+ 个）" "DOC-MAP"
check_count_in "$ROOT_DIR/templates/workflow_plan_template.md" "本文档定义 [0-9]+ 个专业" "workflow_plan_template"

# ───────────────────────────────────────────
# 模板与角色对应检查
# ───────────────────────────────────────────
echo ""
echo "=== 模板覆盖检查 ==="

declare -A ROLE_TO_TEMPLATE=(
  [orchestrator]=workflow_plan_template.md
  [project-manager]=pmo_template.md
  [proactive-scout]=scout_template.md
  [market-analyst]=market_template.md
  [product-manager]=product_template.md
  [ui-designer]=ui_design_template.md
  [architect]=architecture_template.md
  [dba]="(uses ARCH or DB doc)"
  [developer]=developer_template.md
  [frontend-developer]=frontend_template.md
  [backend-developer]=backend_template.md
  [qa-manager]=qa_template.md
  [devops]=devops_template.md
  [security-engineer]=security_template.md
  [docwriter]=docwriter_template.md
  [data-analyst]=data_template.md
  [feedback-analyst]=feedback_template.md
  [iteration-planner]=iteration_template.md
  [reviewer]=reviewer_template.md
  [quality-gatekeeper]=quality_report_template.md
)

for role in "${!ROLE_TO_TEMPLATE[@]}"; do
  tpl="${ROLE_TO_TEMPLATE[$role]}"
  if [[ "$tpl" == "("* ]]; then
    log_ok "$role: 共享模板（$tpl）"
    continue
  fi
  if [ -f "$ROOT_DIR/templates/$tpl" ]; then
    log_ok "$role → templates/$tpl"
  else
    log_err "$role 缺少模板：templates/$tpl"
  fi
done

# ───────────────────────────────────────────
# Skill 推荐章节覆盖率
# ───────────────────────────────────────────
echo ""
echo "=== 推荐方法论 skills 覆盖率 ==="

WITH_SKILL=0
WITHOUT_SKILL=0
for f in "$ROOT_DIR"/agents/*.md; do
  if grep -q "推荐方法论 skills" "$f"; then
    WITH_SKILL=$((WITH_SKILL+1))
  else
    WITHOUT_SKILL=$((WITHOUT_SKILL+1))
    log_warn "$(basename "$f"): 缺少「推荐方法论 skills」"
  fi
done

log_ok "覆盖：$WITH_SKILL / $((WITH_SKILL+WITHOUT_SKILL))"

# ───────────────────────────────────────────
# docs/ 根目录文件数（应该比较精简）
# ───────────────────────────────────────────
echo ""
echo "=== docs/ 根目录健康度 ==="

ROOT_MD_COUNT=$(ls "$ROOT_DIR"/docs/*.md 2>/dev/null | wc -l | xargs)
ARCHIVE_COUNT=$(find "$ROOT_DIR"/docs/archive -name "*.md" 2>/dev/null | wc -l | xargs)

echo "  docs/*.md（活文档）: $ROOT_MD_COUNT"
echo "  docs/archive/**/*.md（归档）: $ARCHIVE_COUNT"

if [ "$ROOT_MD_COUNT" -gt 40 ]; then
  log_warn "docs/ 根目录文件过多（$ROOT_MD_COUNT > 40），考虑归档历史产物"
fi

# ───────────────────────────────────────────
# 汇总
# ───────────────────────────────────────────
echo ""
echo "=== 汇总 ==="
echo "  错误：$ERRORS"
echo "  警告：$WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
echo "全部通过 ✓"
