#!/usr/bin/env bash
# 安装 product-lifecycle 推荐的 MCP server（用户级 / 全局）
# 用法：bash scripts/install-mcp.sh [--list|--uninstall|--dry-run]
#
# 项目级 MCP 已经在仓库根目录 .mcp.json / .cursor/mcp.json 配好。
# 本脚本只负责把它们注册到 Claude Code 全局，便于跨项目使用。

set -e

LIST=false
UNINSTALL=false
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --list) LIST=true ;;
    --uninstall) UNINSTALL=true ;;
    --dry-run) DRY_RUN=true ;;
    -h|--help)
      head -10 "$0" | grep '^#'
      exit 0 ;;
  esac
done

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { printf "${GREEN}[ OK ]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }

# MCP 清单（名称|包名|说明）
MCP_LIST=(
  "drawio|@next-ai-drawio/mcp-server@latest|画 draw.io 图（流程图/架构图/ER/时序图等）"
)

if [ "$LIST" = true ]; then
  echo "推荐的 MCP servers："
  for entry in "${MCP_LIST[@]}"; do
    IFS='|' read -r name pkg desc <<<"$entry"
    printf "  - %-10s %s\n              %s\n" "$name" "$pkg" "$desc"
  done
  exit 0
fi

if ! command -v claude >/dev/null 2>&1; then
  warn "未检测到 claude CLI"
  echo
  echo "请改用以下方式（任选其一）："
  echo "  1) 项目级（已配置）：直接在本仓库使用 .mcp.json 自动生效"
  echo "  2) Cursor：把 .cursor/mcp.json 内容合并到 ~/.cursor/mcp.json"
  echo "  3) 手动：claude mcp add drawio -- npx -y @next-ai-drawio/mcp-server@latest"
  exit 0
fi

for entry in "${MCP_LIST[@]}"; do
  IFS='|' read -r name pkg desc <<<"$entry"

  if [ "$UNINSTALL" = true ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "[dry-run] claude mcp remove $name"
    else
      claude mcp remove "$name" 2>/dev/null && ok "卸载 $name" || warn "$name 未注册"
    fi
    continue
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "[dry-run] claude mcp add $name -- npx -y $pkg"
  else
    if claude mcp list 2>/dev/null | grep -q "^$name"; then
      ok "$name 已注册（跳过）"
    else
      claude mcp add "$name" -- npx -y "$pkg" && ok "已注册 $name → $pkg"
    fi
  fi
done

echo
ok "完成。在 Claude Code 中可让 AI 调用 drawio 工具绘图。"
echo "详见 docs/05-advanced/DIAGRAMMING.md"
