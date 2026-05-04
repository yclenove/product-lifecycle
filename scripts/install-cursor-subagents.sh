#!/usr/bin/env bash
# 将 product-lifecycle 的 Cursor Subagent 安装到业务项目，并把 Read 路径替换为技能包绝对路径。
#
# 用法:
#   export PRODUCT_LIFECYCLE_ROOT="$HOME/.cursor/skills/product-lifecycle"
#   cd /path/to/new-app
#   bash /path/to/product-lifecycle/scripts/install-cursor-subagents.sh
#
# 或:
#   bash install-cursor-subagents.sh /path/to/new-app "$HOME/.cursor/skills/product-lifecycle"

set -euo pipefail

TARGET="${1:-$(pwd)}"
SKILL_ROOT="${2:-${PRODUCT_LIFECYCLE_ROOT:-}}"

if [[ -z "$SKILL_ROOT" ]]; then
  echo "错误: 请设置 PRODUCT_LIFECYCLE_ROOT 或传入第二个参数作为技能包根目录。" >&2
  exit 1
fi

if [[ ! -f "$SKILL_ROOT/agents/orchestrator.md" ]]; then
  echo "错误: SKILL_ROOT 无效（缺少 agents/orchestrator.md）: $SKILL_ROOT" >&2
  exit 1
fi

if [[ ! -d "$SKILL_ROOT/.cursor/agents" ]]; then
  echo "错误: 缺少 $SKILL_ROOT/.cursor/agents" >&2
  exit 1
fi

SKILL_UNIX="$(cd "$SKILL_ROOT" && pwd)"
DEST="$TARGET/.cursor/agents"
mkdir -p "$DEST"

for f in "$SKILL_ROOT"/.cursor/agents/*.md; do
  base="$(basename "$f")"
  if [[ "$base" == "README.md" ]]; then continue; fi
  sed -e "s|\`agents/|\`${SKILL_UNIX}/agents/|g" \
      -e "s|\`templates/|\`${SKILL_UNIX}/templates/|g" \
      -e 's/From the workspace root (the repo that contains `\.cursor\/agents\/`), //' \
      "$f" > "$DEST/$base"
  echo "Wrote $DEST/$base"
done

if [[ -f "$SKILL_ROOT/.cursor/agents/README.md" ]]; then
  cp "$SKILL_ROOT/.cursor/agents/README.md" "$DEST/README.md"
  echo "Wrote $DEST/README.md (copy)"
fi

echo ""
echo "完成。在新项目重载 Cursor 后使用 /orchestrator 等。"
echo "技能包路径: $SKILL_UNIX"
