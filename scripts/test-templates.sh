#!/usr/bin/env bash
# test-templates.sh — 模板测试
set -euo pipefail

ROOT="$(dirname "$(dirname "$0")")"
errors=0
total=0

echo "=== 模板测试 ==="

for f in "$ROOT"/templates/*.md; do
  name=$(basename "$f")
  total=$((total+1))
  echo -n "$name: "

  # 检查元数据表
  if grep -q "| 字段 |" "$f"; then
    echo -n "元数据✓ "
  else
    echo -n "元数据✗ "
    errors=$((errors+1))
  fi

  # 检查修订记录
  if grep -q "修订记录" "$f"; then
    echo -n "修订✓ "
  else
    echo -n "修订✗ "
    errors=$((errors+1))
  fi

  # 检查必填标记
  if grep -q "\[必填\]" "$f"; then
    echo -n "必填✓ "
  else
    echo -n "必填? "
  fi

  # 检查可选标记
  if grep -q "\[可选\]" "$f"; then
    echo "可选✓"
  else
    echo "可选?"
  fi
done

echo ""
echo "测试结果: $total 个模板"
if [ $errors -eq 0 ]; then
  echo "全部通过 ✓"
  exit 0
else
  echo "$errors 项问题"
  exit 1
fi
