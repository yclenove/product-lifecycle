#!/usr/bin/env bash
# 初始化新一轮迭代目录
# 用法：bash scripts/init-iteration.sh <iteration-id> "<目标描述>"
# 示例：bash scripts/init-iteration.sh v1.9 "v1.9 批量导出功能"

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法：bash scripts/init-iteration.sh <iteration-id> [目标描述]"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ITER_ID="$1"
GOAL="${2:-}"
CURRENT="$ROOT_DIR/docs/iterations/current"
TEMPLATE="$ROOT_DIR/docs/iterations/_template"

if [ -d "$CURRENT/market" ] && [ "$(find "$CURRENT" -mindepth 2 -type f ! -name '.gitkeep' 2>/dev/null | wc -l)" -gt 0 ]; then
  echo "[!] current/ 里还有上一轮产物，请先归档："
  echo "    bash scripts/archive-iteration.sh <上一轮-id>"
  exit 1
fi

mkdir -p "$CURRENT"/{market,product,architecture,dev,qa,scout,feedback,iteration,quality-gate,misc}

if [ -f "$TEMPLATE/ITERATION.md" ]; then
  sed -e "s/{{ITERATION_ID}}/$ITER_ID/g" -e "s/{{一句话目标}}/$GOAL/g" \
    "$TEMPLATE/ITERATION.md" > "$CURRENT/ITERATION.md"
else
  echo "# 迭代 $ITER_ID" > "$CURRENT/ITERATION.md"
  echo "$GOAL" >> "$CURRENT/ITERATION.md"
fi

echo "[OK] 已初始化 docs/iterations/current/（迭代 ID: $ITER_ID）"
echo "     Agent 产出请写到 docs/iterations/current/<类型>/ 下"
