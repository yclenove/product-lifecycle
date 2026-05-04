#!/usr/bin/env bash
# iterate.sh — 迭代收尾脚本
#
# 每轮迭代完成后执行，自动完成：
#   1. 检查 agents/ 与 .claude/agents/ 是否需要同步
#   2. 同步 .claude/agents/（从 agents/ 派生）
#   3. 更新本机 skill（~/.claude/skills/product-lifecycle）
#
# 用法：
#   bash scripts/iterate.sh              # 完整收尾
#   bash scripts/iterate.sh --check      # 只检查，不执行
#   bash scripts/iterate.sh --sync-only  # 只同步，不更新 skill

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AGENTS_DIR="$ROOT_DIR/agents"
CLAUDE_DIR="$ROOT_DIR/.claude/agents"
SKILL_DIR="$HOME/.claude/skills/product-lifecycle"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_only=false
sync_only=false
for arg in "$@"; do
  case "$arg" in
    --check) check_only=true ;;
    --sync-only) sync_only=true ;;
  esac
done

echo "=========================================="
echo " iterate.sh — 迭代收尾"
echo "=========================================="
echo ""

# ──────────────────────────────────────────────
# Step 1: 检查是否需要同步
# ──────────────────────────────────────────────
echo "Step 1: 检查 agents/ 与 .claude/agents/ 一致性"
echo ""

need_sync=false
for src in "$AGENTS_DIR"/*.md; do
  name=$(basename "$src" .md)
  dst="$CLAUDE_DIR/$name.md"

  if [[ ! -f "$dst" ]]; then
    echo -e "  ${RED}✗${NC} $name.md — .claude/agents/ 中不存在"
    need_sync=true
    continue
  fi

  # 检查 agents/ 的修改时间是否比 .claude/agents/ 新
  if [[ "$src" -nt "$dst" ]]; then
    echo -e "  ${YELLOW}!${NC} $name.md — agents/ 更新，需要同步"
    need_sync=true
  fi
done

if ! $need_sync; then
  echo -e "  ${GREEN}✓${NC} 所有 Agent 已同步"
fi

echo ""

if $check_only; then
  echo "（--check 模式，不执行操作）"
  exit 0
fi

# ──────────────────────────────────────────────
# Step 2: 同步 .claude/agents/
# ──────────────────────────────────────────────
if $need_sync; then
  echo "Step 2: 同步 .claude/agents/"
  echo ""
  bash "$SCRIPT_DIR/sync-agents.sh"
  echo ""
else
  echo "Step 2: 跳过（无需同步）"
  echo ""
fi

if $sync_only; then
  echo "（--sync-only 模式，不更新 skill）"
  echo ""
  echo "=========================================="
  echo " 收尾完成"
  echo "=========================================="
  exit 0
fi

# ──────────────────────────────────────────────
# Step 3: 更新本机 skill
# ──────────────────────────────────────────────
echo "Step 3: 更新本机 skill"
echo ""

if [[ ! -d "$SKILL_DIR" ]]; then
  echo -e "  ${YELLOW}!${NC} 本机 skill 目录不存在: $SKILL_DIR"
  echo "  跳过。如需安装：git clone <repo> $SKILL_DIR"
else
  # 检查是否是 git 仓库
  if [[ -d "$SKILL_DIR/.git" ]]; then
    # Git 仓库：先检查是否有未提交的本地修改
    if [[ -n "$(cd "$SKILL_DIR" && git status --porcelain 2>/dev/null)" ]]; then
      echo -e "  ${YELLOW}!${NC} 本机 skill 有未提交的修改，跳过 pull"
      echo "  请先处理 $SKILL_DIR 中的本地修改"
    else
      # 复制变更的文件（而不是 git pull，因为开发目录可能不是同一个 repo）
      echo "  同步文件到 $SKILL_DIR ..."

      # 核心文件
      for f in SKILL.md README.md CHANGELOG.md; do
        if [[ -f "$ROOT_DIR/$f" ]]; then
          cp "$ROOT_DIR/$f" "$SKILL_DIR/$f"
        fi
      done

      # agents/
      mkdir -p "$SKILL_DIR/agents"
      cp "$AGENTS_DIR"/*.md "$SKILL_DIR/agents/"

      # .claude/agents/
      mkdir -p "$SKILL_DIR/.claude/agents"
      cp "$CLAUDE_DIR"/*.md "$SKILL_DIR/.claude/agents/"

      # templates/
      mkdir -p "$SKILL_DIR/templates"
      cp "$ROOT_DIR/templates"/*.md "$SKILL_DIR/templates/"

      # docs/
      mkdir -p "$SKILL_DIR/docs"
      cp "$ROOT_DIR/docs"/*.md "$SKILL_DIR/docs/" 2>/dev/null || true

      # examples/
      mkdir -p "$SKILL_DIR/examples"
      cp "$ROOT_DIR/examples"/*.md "$SKILL_DIR/examples/" 2>/dev/null || true

      # scripts/
      mkdir -p "$SKILL_DIR/scripts"
      cp "$ROOT_DIR/scripts"/*.sh "$SKILL_DIR/scripts/" 2>/dev/null || true

      echo -e "  ${GREEN}✓${NC} 本机 skill 已更新"
    fi
  else
    echo -e "  ${YELLOW}!${NC} 本机 skill 不是 git 仓库，直接复制文件"
    # 直接复制
    for f in SKILL.md README.md CHANGELOG.md; do
      cp "$ROOT_DIR/$f" "$SKILL_DIR/$f" 2>/dev/null || true
    done
    mkdir -p "$SKILL_DIR/agents" "$SKILL_DIR/.claude/agents" "$SKILL_DIR/templates" "$SKILL_DIR/docs" "$SKILL_DIR/examples" "$SKILL_DIR/scripts"
    cp "$AGENTS_DIR"/*.md "$SKILL_DIR/agents/"
    cp "$CLAUDE_DIR"/*.md "$SKILL_DIR/.claude/agents/"
    cp "$ROOT_DIR/templates"/*.md "$SKILL_DIR/templates/" 2>/dev/null || true
    cp "$ROOT_DIR/docs"/*.md "$SKILL_DIR/docs/" 2>/dev/null || true
    cp "$ROOT_DIR/examples"/*.md "$SKILL_DIR/examples/" 2>/dev/null || true
    cp "$ROOT_DIR/scripts"/*.sh "$SKILL_DIR/scripts/" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} 本机 skill 已更新"
  fi
fi

echo ""
echo "=========================================="
echo " 收尾完成"
echo "=========================================="
echo ""
echo "下一步："
echo "  - 如需提交: git add -A && git commit"
echo "  - 如需检查: bash scripts/iterate.sh --check"
