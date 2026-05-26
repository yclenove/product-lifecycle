#!/usr/bin/env bash
# evolve.sh — 自进化迭代脚本
#
# 自动执行 N 轮迭代，每轮：
#   1. 重新读取 SKILL.md（自进化：吸收上轮的改进）
#   2. 执行迭代（由 Claude 完成，本脚本准备上下文）
#   3. 同步 + 更新本机 skill
#   4. 写入 checkpoint
#
# 用法：
#   bash scripts/evolve.sh              # 准备自进化上下文
#   bash scripts/evolve.sh --status     # 查看进化状态
#   bash scripts/evolve.sh --reset      # 重置 checkpoint

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SKILL_DIR="$HOME/.claude/skills/product-lifecycle"
CHECKPOINT="$ROOT_DIR/.evolve-checkpoint.json"

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ──────────────────────────────────────────────
# 状态查询
# ──────────────────────────────────────────────
if [[ "${1:-}" == "--status" ]]; then
  echo "=========================================="
  echo " evolve.sh — 自进化状态"
  echo "=========================================="
  echo ""
  if [[ -f "$CHECKPOINT" ]]; then
    echo "Checkpoint: $(cat "$CHECKPOINT")"
  else
    echo "Checkpoint: 无（首次运行）"
  fi
  echo ""
  echo "SKILL.md 最后修改: $(stat -c %y "$ROOT_DIR/SKILL.md" 2>/dev/null || stat -f %Sm "$ROOT_DIR/SKILL.md" 2>/dev/null)"
  echo "本机 skill 最后同步: $(stat -c %y "$SKILL_DIR/SKILL.md" 2>/dev/null || stat -f %Sm "$SKILL_DIR/SKILL.md" 2>/dev/null || echo '未同步')"
  echo ""
  # 版本
  local_ver=$(grep -m1 '^\## \[' "$ROOT_DIR/CHANGELOG.md" | head -2 | tail -1 | sed 's/## \[\(.*\)\].*/\1/')
  echo "当前版本: $local_ver"
  exit 0
fi

if [[ "${1:-}" == "--reset" ]]; then
  rm -f "$CHECKPOINT"
  echo "Checkpoint 已重置"
  exit 0
fi

# ──────────────────────────────────────────────
# 准备自进化上下文
# ──────────────────────────────────────────────
echo "=========================================="
echo " evolve.sh — 准备自进化上下文"
echo "=========================================="
echo ""

# Step 1: 检查并同步
echo "Step 1: 同步检查"
bash "$SCRIPT_DIR/iterate.sh" --check
echo ""

# Step 2: 生成自进化指令
echo "Step 2: 生成自进化指令"
echo ""

# 读取当前版本
current_ver=$(grep -m1 '^\## \[' "$ROOT_DIR/CHANGELOG.md" | head -2 | tail -1 | sed 's/## \[\(.*\)\].*/\1/')

# 读取 checkpoint
if [[ -f "$CHECKPOINT" ]]; then
  last_iteration=$(cat "$CHECKPOINT" | grep -o '"iteration":[0-9]*' | cut -d: -f2 || echo "0")
else
  last_iteration=0
fi

next_iteration=$((last_iteration + 1))

cat <<EOF
┌─────────────────────────────────────────────┐
│ 自进化模式 — 第 ${next_iteration} 轮                          │
├─────────────────────────────────────────────┤
│ 当前版本: ${current_ver}                              │
│                                               │
│ 每轮迭代流程：                                  │
│  1. 重新读取 SKILL.md（自进化刷新）              │
│  2. 侦察 → 反馈 → 规划 → 开发 → 验证           │
│  3. bash scripts/iterate.sh（同步+更新skill）   │
│  4. 写入 checkpoint                            │
│                                               │
│ 编辑位置：agents/*.md（真源）                   │
│ 同步命令：bash scripts/iterate.sh              │
└─────────────────────────────────────────────┘
EOF

echo ""
echo "Step 3: 自进化指令（给 Claude 的 prompt）"
echo ""
echo "──────────────────────────────────────────"
cat <<'PROMPT'
开始自进化迭代。请严格按以下步骤执行：

1. **重新加载 skill**：读取以下文件获取最新指令：
   - $ROOT/SKILL.md
   - $ROOT/docs/04-reference/CONSISTENCY-CHECKLIST.md（迭代工作流）

2. **执行迭代**：
   - 侦察 + 反馈分析（识别改进点）
   - 规划 + 开发实现（在 agents/*.md 上编辑）
   - 质量门禁验证

3. **收尾**：
   - 运行 bash scripts/iterate.sh（自动同步 + 更新本机 skill）
   - 更新 CHANGELOG
   - 写入 checkpoint

4. **继续下一轮**（除非达到目标轮次）
PROMPT
echo "──────────────────────────────────────────"
echo ""

# 写入 checkpoint
cat > "$CHECKPOINT" <<EOF
{
  "iteration": ${next_iteration},
  "version": "${current_ver}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%Y-%m-%dT%H:%M:%SZ)",
  "skill_md": "$ROOT_DIR/SKILL.md",
  "skill_install": "$SKILL_DIR/SKILL.md"
}
EOF

echo -e "${GREEN}✓${NC} Checkpoint 已写入: 第 ${next_iteration} 轮"
echo ""
echo "用法："
echo "  告诉 Claude：'开始自进化迭代，目标 N 轮'"
echo "  Claude 会自动读取最新 SKILL.md 并执行迭代"