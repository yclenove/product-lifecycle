#!/usr/bin/env bash
# install-skills.sh — 一键安装 product-lifecycle 推荐的通用方法论 skill
#
# 用法：
#   bash scripts/install-skills.sh             # 安装到 ~/.claude/skills/ 和 ~/.cursor/skills/
#   bash scripts/install-skills.sh --claude    # 只装到 Claude Code
#   bash scripts/install-skills.sh --cursor    # 只装到 Cursor
#   bash scripts/install-skills.sh --dry-run   # 只显示会做什么，不实际克隆

set -euo pipefail

TARGET_CLAUDE=true
TARGET_CURSOR=true
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --claude) TARGET_CURSOR=false ;;
    --cursor) TARGET_CLAUDE=false ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help)
      head -10 "$0" | grep -E '^#'
      exit 0
      ;;
  esac
done

# 推荐 skill 仓库清单
declare -A REPOS=(
  ["superpowers-zh"]="https://github.com/obra/superpowers.git"
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

log_ok "完成。详见 docs/SKILL-INTEGRATION.md"
