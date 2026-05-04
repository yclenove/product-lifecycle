#!/usr/bin/env bash
# test-agents.sh — Agent prompt 测试
set -euo pipefail

ROOT="$(dirname "$(dirname "$0")")"
errors=0
total=0

echo "=== Agent Prompt 测试 ==="

for f in "$ROOT"/agents/*.md; do
  name=$(basename "$f")
  total=$((total+1))
  echo -n "$name: "

  # 检查必需章节
  missing=0
  for section in "任务" "输出" "质量门禁" "上下文管理"; do
    if ! grep -q "## .*${section}" "$f"; then
      echo -n "${section}✗ "
      missing=$((missing+1))
    fi
  done

  # 检查上下文管理指令
  if grep -q "上下文管理" "$f"; then
    echo -n "上下文✓ "
  else
    echo -n "上下文✗ "
    missing=$((missing+1))
  fi

  # 检查输出格式规范
  if grep -q "输出" "$f" && grep -q "格式" "$f"; then
    echo -n "格式✓ "
  else
    echo -n "格式? "
  fi

  if [ $missing -eq 0 ]; then
    echo "✓"
  else
    echo "✗ ($missing 项缺失)"
    errors=$((errors+1))
  fi
done

echo ""
echo "测试结果: $total 个 Agent, $errors 个失败"
if [ $errors -eq 0 ]; then
  echo "全部通过 ✓"
  exit 0
else
  echo "$errors 项失败 ✗"
  exit 1
fi
