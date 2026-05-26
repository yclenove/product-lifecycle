#!/usr/bin/env bash
# install-skills.sh — 一键安装 product-lifecycle 推荐的通用方法论 skill
#
# 用法：
#   bash scripts/install-skills.sh             # 安装到 ~/.claude/skills/ 和 ~/.cursor/skills/
#   bash scripts/install-skills.sh --claude    # 只装到 Claude Code
#   bash scripts/install-skills.sh --cursor    # 只装到 Cursor
#   bash scripts/install-skills.sh --dry-run   # 只显示会做什么，不实际克隆
#   bash scripts/install-skills.sh --uninstall # 删除本脚本安装的 skill 目录
#
# 推荐优先：npx superpowers-zh（含 hooks，见 docs/04-reference/SKILL-INTEGRATION.md）

set -euo pipefail

TARGET_CLAUDE=true
TARGET_CURSOR=true
DRY_RUN=false
UNINSTALL=false

for arg in "$@"; do
  case "$arg" in
    --claude) TARGET_CURSOR=false ;;
    --cursor) TARGET_CLAUDE=false ;;
    --dry-run) DRY_RUN=true ;;
    --uninstall) UNINSTALL=true ;;
    -h|--help)
      head -15 "$0" | grep -E '^#'
      exit 0
      ;;
  esac
done

# 推荐 skill 仓库清单
declare -A REPOS=(
  ["superpowers-zh"]="https://github.com/jnMetaCode/superpowers-zh.git"
  ["anthropics-skills"]="https://github.com/anthropics/skills.git"
)

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
log_ok()    { echo -e "${GREEN}[ OK ]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_err()   { echo -e "${RED}[FAIL]${NC} $*"; }

# 检查 git
if ! command -v git &>/dev/null; then
  log_err "git 未安装，请先安装 git"
  exit 1
fi

install_to() {
  local target_root="$1"
  local platform="$2"

  log_info "目标平台：$platform"
  log_info "安装目录：$target_root"

  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$target_root"
  fi

  for name in "${!REPOS[@]}"; do
    local url="${REPOS[$name]}"
    local dest="$target_root/$name"

    if [ -d "$dest/.git" ]; then
      log_ok "$name 已存在，跳过（更新可在该目录运行 git pull）"
      continue
    fi

    log_info "安装 $name ← $url"
    if [ "$DRY_RUN" = true ]; then
      echo "  [dry-run] git clone --depth 1 $url $dest"
    else
      if git clone --depth 1 "$url" "$dest" 2>/dev/null; then
        log_ok "$name 安装完成"
      else
        log_err "$name 克隆失败"
      fi
    fi
  done

  echo ""
}

uninstall_from() {
  local target_root="$1"
  local platform="$2"
  log_info "卸载 $platform → $target_root"
  for name in "${!REPOS[@]}"; do
    local dest="$target_root/$name"
    if [ -d "$dest" ]; then
      if [ "$DRY_RUN" = true ]; then
        echo "  [dry-run] rm -rf $dest"
      else
        rm -rf "$dest"
        log_ok "已删除 $name"
      fi
    fi
  done
}

if [ "$UNINSTALL" = true ]; then
  [ "$TARGET_CLAUDE" = true ] && uninstall_from "$HOME/.claude/skills" "Claude Code"
  [ "$TARGET_CURSOR" = true ] && uninstall_from "$HOME/.cursor/skills" "Cursor"
  log_ok "卸载完成（CLAUDE.md 中 <!-- product-lifecycle:* --> 段需手工检查）"
  exit 0
fi

if [ "$TARGET_CLAUDE" = true ]; then
  install_to "$HOME/.claude/skills" "Claude Code"
fi

if [ "$TARGET_CURSOR" = true ]; then
  install_to "$HOME/.cursor/skills" "Cursor"
fi

# 简单校验
verify() {
  local target_root="$1"
  [ ! -d "$target_root" ] && return
  log_info "校验 $target_root ..."
  local count
  count=$(find "$target_root" -name SKILL.md 2>/dev/null | wc -l | xargs)
  log_ok "  发现 $count 个 SKILL.md"
}

if [ "$DRY_RUN" = false ]; then
  [ "$TARGET_CLAUDE" = true ] && verify "$HOME/.claude/skills"
  [ "$TARGET_CURSOR" = true ] && verify "$HOME/.cursor/skills"
fi

log_ok "完成。详见 docs/04-reference/SKILL-INTEGRATION.md"