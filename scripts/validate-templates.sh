#!/usr/bin/env bash
# validate-templates.sh — 验证所有模板格式一致性
#
# 用法：bash scripts/validate-templates.sh
#
# 说明：
#   - 检查 templates/ 目录下 20 个 *_template.md 核心模板
#   - 验证三项格式规范：
#     1. 元数据表（包含"| 字段 | 值 |"或"| 字段 |"）
#     2. 修订记录（包含"修订记录"标题）
#     3. 必填标记（包含"[必填]"标记）
#   - 输出每个文件的验证结果和问题统计

set -euo pipefail

ROOT="$(dirname "$(dirname "$0")")"
ERRORS=0
EXPECTED=20
TOTAL=0

echo "=== 模板验证 ==="

for f in "$ROOT"/templates/*_template.md; do
  TOTAL=$((TOTAL+1))
  name=$(basename "$f")
  echo -n "$name: "

  # 检查元数据表
  if grep -q "| 字段 | 值 |" "$f" || grep -q "| 字段 |" "$f"; then
    echo -n "元数据✓ "
  else
    echo -n "元数据✗ "
    ERRORS=$((ERRORS+1))
  fi

  # 检查修订记录
  if grep -q "修订记录" "$f"; then
    echo -n "修订✓ "
  else
    echo -n "修订✗ "
    ERRORS=$((ERRORS+1))
  fi

  # 检查必填标记
  if grep -q "\[必填\]" "$f"; then
    echo "必填✓"
  else
    echo "必填✗ (可能无必填章节)"
  fi
done

echo ""
if [ "$TOTAL" -ne "$EXPECTED" ]; then
  echo "核心模板数量错误：$TOTAL/$EXPECTED"
  exit 1
elif [ $ERRORS -eq 0 ]; then
  echo "全部通过 ✓"
  exit 0
else
  echo "$ERRORS 项问题"
  exit 1
fi
