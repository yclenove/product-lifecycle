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

check_count_in "$ROOT_DIR/SKILL.md" "[0-9]+-agent" "frontmatter description"
check_count_in "$ROOT_DIR/README.md" "通过 \\*\\*[0-9]+ 个" "顶部段"
check_count_in "$ROOT_DIR/README.md" "## [0-9]+ 个 Agent 角色" "角色表标题"
check_count_in "$ROOT_DIR/docs/04-reference/SKILL-ASSETS.md" "## [0-9]+ Agent 角色与产出" "速览表标题"
check_count_in "$ROOT_DIR/docs/02-tools/SKILL-CURSOR.md" "固定 \\*\\*[0-9]+ 个角色" "Best practices"
check_count_in "$ROOT_DIR/docs/01-getting-started/DECISION-TREE.md" "企业级 → 全部 [0-9]+ 个" "决策树企业级"
check_count_in "$ROOT_DIR/docs/01-getting-started/QUICK-START.md" "不需要一次用全部 [0-9]+ 个" "QUICK-START 提示"
check_count_in "$ROOT_DIR/docs/01-getting-started/FAQ.md" "小项目也需要 [0-9]+ 个" "FAQ"
check_count_in "$ROOT_DIR/templates/workflow_plan_template.md" "本文档定义 [0-9]+ 个专业" "workflow_plan_template"

# ───────────────────────────────────────────
# 双根目录与薄适配器
# ───────────────────────────────────────────
echo ""
echo "=== Skill 结构检查 ==="

for f in \
  "$ROOT_DIR/SKILL.md" \
  "$ROOT_DIR/.agents/skills/pl/SKILL.md" \
  "$ROOT_DIR/.agents/skills/product-lifecycle/SKILL.md" \
  "$ROOT_DIR/.claude/skills/pl/SKILL.md" \
  "$ROOT_DIR/.cursor/skills/product-lifecycle/SKILL.md"; do
  if [ ! -f "$f" ]; then
    log_err "缺少宿主入口：${f#$ROOT_DIR/}"
    continue
  fi
  if grep -q "PACKAGE_ROOT" "$f" && grep -q "WORKSPACE_ROOT" "$f"; then
    log_ok "${f#$ROOT_DIR/}: 双根目录"
  else
    log_err "${f#$ROOT_DIR/}: 缺少 PACKAGE_ROOT / WORKSPACE_ROOT"
  fi
done

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

ROOT_MD_COUNT=$(find "$ROOT_DIR"/docs -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | xargs)
LEGACY_COUNT=$(find "$ROOT_DIR"/docs/iterations/_legacy-by-role -name "*.md" 2>/dev/null | wc -l | xargs)
CURRENT_EXISTS=false
[ -d "$ROOT_DIR/docs/iterations/current" ] && CURRENT_EXISTS=true

echo "  docs/*.md（根导航）: $ROOT_MD_COUNT"
echo "  docs/iterations/_legacy-by-role（历史）: $LEGACY_COUNT 个 md"
echo "  docs/iterations/current（进行中）: $CURRENT_EXISTS"

if [ "$ROOT_MD_COUNT" -gt 5 ]; then
  log_warn "docs/ 根目录 md 过多（$ROOT_MD_COUNT > 5），指南应放在 01-07 子目录"
fi

if [ ! -f "$ROOT_DIR/docs/iterations/README.md" ]; then
  log_warn "缺少 docs/iterations/README.md"
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
