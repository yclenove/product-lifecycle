#!/usr/bin/env bash
# 把 current/ 整包归档到 iterations/<id>/
# 用法：bash scripts/archive-iteration.sh <iteration-id>

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "用法：bash scripts/archive-iteration.sh <iteration-id>"
  echo "示例：bash scripts/archive-iteration.sh v1.9"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ITER_ID="$1"
CURRENT="$ROOT_DIR/docs/iterations/current"
DEST="$ROOT_DIR/docs/iterations/$ITER_ID"

if [ ! -d "$CURRENT" ]; then
  echo "[!] docs/iterations/current/ 不存在"
  exit 1
fi

if [ -d "$DEST" ]; then
  echo "[!] 目标已存在：$DEST"
  exit 1
fi

if [ "$(find "$CURRENT" -mindepth 1 -type f ! -name '.gitkeep' 2>/dev/null | wc -l)" -eq 0 ]; then
  echo "[!] current/ 为空，无需归档"
  exit 1
fi

if command -v git &>/dev/null && git -C "$ROOT_DIR" rev-parse --git-dir &>/dev/null; then
  git -C "$ROOT_DIR" mv "$CURRENT" "$DEST"
else
  mv "$CURRENT" "$DEST"
fi

mkdir -p "$CURRENT"/{market,product,architecture,dev,qa,scout,feedback,iteration,quality-gate,misc}
touch "$CURRENT/.gitkeep"

echo "[OK] 已归档：current/ → iterations/$ITER_ID/"
echo "     新开一轮：bash scripts/init-iteration.sh <新-id> \"<目标>\""
