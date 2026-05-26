#!/usr/bin/env bash
# 长程迭代模式：保存阶段 checkpoint
# 用法：bash scripts/checkpoint.sh <agent-name> [描述]
#
# 把当前 STATE.md 复制为 CHECKPOINTS/CKP-<date>-<agent>-done.md，附带 git diff 摘要。

set -e

if [ -z "$1" ]; then
    echo "用法：bash scripts/checkpoint.sh <agent-name> [描述]"
    echo "示例：bash scripts/checkpoint.sh product-manager 'PRD v1 完成'"
    exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE="$ROOT_DIR/docs/07-long-running/STATE.md"
CKP_DIR="$ROOT_DIR/docs/07-long-running/CHECKPOINTS"
AGENT="$1"
DESC="${2:-}"
DATE="$(date +%Y%m%d)"
CKP_FILE="$CKP_DIR/CKP-${DATE}-${AGENT}-done.md"

if [ ! -f "$STATE" ]; then
    echo "[!] STATE.md 不存在，请先启用长程模式："
    echo "    cp docs/07-long-running/STATE.template.md docs/07-long-running/STATE.md"
    exit 1
fi

mkdir -p "$CKP_DIR"

cat > "$CKP_FILE" <<EOF
# Checkpoint: ${AGENT} 完成

| 字段 | 值 |
|------|-----|
| Agent | ${AGENT} |
| 日期 | $(date +%Y-%m-%d) |
| 时间 | $(date +%H:%M:%S) |
| 描述 | ${DESC} |

## STATE 快照

\`\`\`markdown
EOF

cat "$STATE" >> "$CKP_FILE"

cat >> "$CKP_FILE" <<EOF
\`\`\`

## 本次新增/修改文件

EOF

if git -C "$ROOT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    echo '```' >> "$CKP_FILE"
    git -C "$ROOT_DIR" status --short >> "$CKP_FILE" 2>/dev/null || echo "(git status 失败)" >> "$CKP_FILE"
    echo '```' >> "$CKP_FILE"
    echo "" >> "$CKP_FILE"
    echo "## 最近 5 个 commit" >> "$CKP_FILE"
    echo "" >> "$CKP_FILE"
    echo '```' >> "$CKP_FILE"
    git -C "$ROOT_DIR" log --oneline -5 >> "$CKP_FILE" 2>/dev/null || echo "(git log 失败)" >> "$CKP_FILE"
    echo '```' >> "$CKP_FILE"
else
    echo "(非 git 仓库，跳过 diff 摘要)" >> "$CKP_FILE"
fi

echo "[OK] Checkpoint 已保存：$CKP_FILE"
echo ""
echo "提示：建议把它加进 git 跟踪团队里程碑"
echo "  git add $CKP_FILE"