#!/usr/bin/env bash
# SessionStart：长程迭代模式下注入当前进度摘要
# 由 hooks/hooks.json 在 Claude Code 会话启动时调用

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$ROOT/docs/07-long-running/STATE.md"
ITER="$ROOT/docs/iterations/current/ITERATION.md"

echo "<!-- product-lifecycle:session-context -->"

if [ -f "$STATE" ]; then
  echo "## 长程迭代状态（自动注入）"
  echo ""
  echo "检测到 \`docs/07-long-running/STATE.md\`，请先读该文件恢复上下文。"
  echo ""
  awk '/^## 当前进行中/,/^## 已完成 Agent 清单/' "$STATE" 2>/dev/null | head -n 12
  echo ""
  awk '/^## 下一步建议/,/^## 关键产出索引/' "$STATE" 2>/dev/null | head -n 10
fi

if [ -f "$ITER" ]; then
  echo ""
  echo "## 当前迭代"
  head -n 8 "$ITER"
fi

echo "<!-- /product-lifecycle:session-context -->"
