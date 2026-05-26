#!/usr/bin/env bash
# configure-models.sh — 探测 API 模型 + 为 20 个 Agent 自动分级配置

set -euo pipefail

SKILL_DIR="${CLAUDE_SKILL_DIR:-$HOME/.claude/skills/product-lifecycle}"
[ ! -d "$SKILL_DIR/.claude/agents" ] && SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$SKILL_DIR/.claude/agents"

if [ ! -d "$AGENTS_DIR" ]; then
  echo "找不到 .claude/agents/，请确认 SKILL_DIR=$SKILL_DIR"
  exit 1
fi

# 复杂推理角色（建议用最强模型）
STRONG_ROLES=(orchestrator project-manager architect)
# 常规任务角色（建议用平衡模型）— 17 个
BALANCED_ROLES=(proactive-scout market-analyst product-manager ui-designer dba developer frontend-developer backend-developer qa-manager devops security-engineer docwriter data-analyst feedback-analyst iteration-planner reviewer quality-gatekeeper)

# ===== Step 1: 探测可用模型 =====
echo "=== 探测可用模型 ==="
MODELS=""
MODEL_COUNT=0

if [ -n "${ANTHROPIC_BASE_URL:-}" ]; then
  API_URL="${ANTHROPIC_BASE_URL%/anthropic}/v1/models"
  TOKEN="${ANTHROPIC_AUTH_TOKEN:-${ANTHROPIC_API_KEY:-}}"
  MODELS=$(curl -s --connect-timeout 5 "$API_URL" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null \
    | tr ',' '\n' | grep '"id"' | sed 's/.*"id":"\([^"]*\)".*/\1/' \
    | grep -vi tts | grep -vi omni | head -20)
  if [ -n "$MODELS" ]; then
    echo "$MODELS" | sed 's/^/  - /'
    MODEL_COUNT=$(echo "$MODELS" | wc -l | xargs)
  else
    echo "  （API 探测无结果）"
  fi
else
  echo "  （未设置 ANTHROPIC_BASE_URL，跳过探测）"
fi

# ===== Step 2: 显示当前配置 =====
echo ""
echo "=== 当前 20 个 Agent 模型配置 ==="
for f in "$AGENTS_DIR"/*.md; do
  name=$(basename "$f" .md)
  model=$(grep "^model:" "$f" 2>/dev/null | sed 's/model: *//' | tr -d '"' | head -1)
  echo "  $name: ${model:-（继承当前模型）}"
done

# ===== Step 3: 推荐方案 =====
echo ""
echo "=== 推荐方案 ==="
STRONG=""
BALANCED=""

if [ "$MODEL_COUNT" -eq 0 ]; then
  echo "  无法探测 → 推荐：保持全部继承当前模型"
elif [ "$MODEL_COUNT" -eq 1 ]; then
  STRONG=$(echo "$MODELS" | head -1)
  BALANCED="$STRONG"
  echo "  只有 1 个模型 → 全部用 $STRONG"
else
  STRONG=$(echo "$MODELS" | head -1)
  BALANCED=$(echo "$MODELS" | sed -n '2p')
  echo "  分级配置："
  echo "    复杂推理（3 个：${STRONG_ROLES[*]}）→ $STRONG"
  echo "    常规任务（17 个：其余）→ $BALANCED"
  echo "  预计省钱：~30-40%"
fi

# ===== Step 4: 询问 =====
echo ""
echo "选项："
echo "  1) 采用推荐方案"
echo "  2) 继承当前模型（移除所有 model 字段）"
echo "  3) 自定义"
echo "  q) 退出，不做改动"
echo ""
read -r -p "请选择 [1/2/3/q]: " choice

set_model() {
  local model="$1"; shift
  for name in "$@"; do
    local f="$AGENTS_DIR/$name.md"
    [ ! -f "$f" ] && continue
    if grep -q "^model:" "$f" 2>/dev/null; then
      # macOS sed 需要 -i ''
      if sed --version >/dev/null 2>&1; then
        sed -i "s|^model:.*|model: \"$model\"|" "$f"
      else
        sed -i '' "s|^model:.*|model: \"$model\"|" "$f"
      fi
    else
      if sed --version >/dev/null 2>&1; then
        sed -i "/^description:/a model: \"$model\"" "$f"
      else
        sed -i '' "/^description:/a\\
model: \"$model\"
" "$f"
      fi
    fi
    echo "  ✓ $name → $model"
  done
}

remove_model() {
  for f in "$AGENTS_DIR"/*.md; do
    if sed --version >/dev/null 2>&1; then
      sed -i '/^model:/d' "$f"
    else
      sed -i '' '/^model:/d' "$f"
    fi
  done
  echo "  ✓ 已移除所有 model 字段"
}

case "$choice" in
  1)
    if [ "$MODEL_COUNT" -eq 0 ]; then
      echo "无法探测模型，请使用选项 2 或 3"
      exit 1
    fi
    echo ""
    echo "应用推荐方案..."
    set_model "$STRONG" "${STRONG_ROLES[@]}"
    set_model "$BALANCED" "${BALANCED_ROLES[@]}"
    ;;
  2)
    echo ""
    echo "移除所有 model 字段..."
    remove_model
    ;;
  3)
    echo ""
    read -r -p "复杂推理用什么模型？" model_strong
    read -r -p "常规任务用什么模型？" model_balanced
    set_model "$model_strong" "${STRONG_ROLES[@]}"
    set_model "$model_balanced" "${BALANCED_ROLES[@]}"
    ;;
  q|*)
    echo "已退出，未做改动"
    exit 0
    ;;
esac

echo ""
echo "完成。重启 Claude Code / Cursor 生效。"
