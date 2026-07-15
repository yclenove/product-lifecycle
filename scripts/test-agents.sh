#!/usr/bin/env bash
# test-agents.sh — Agent prompt 测试
set -euo pipefail

ROOT="$(dirname "$(dirname "$0")")"
errors=0
total=0
expected=20

echo "=== Agent Prompt 测试 ==="

for f in "$ROOT"/agents/*.md; do
  name=$(basename "$f")
  total=$((total+1))
  echo -n "$name: "

  # 与 lint-prompts.sh 使用同一套核心结构口径。
  missing=0
  grep -qE "你的职责|你的核心能力|你的目标|你的工作" "$f" || { echo -n "职责✗ "; missing=$((missing+1)); }
  grep -qE "## 产出|## 输出" "$f" || { echo -n "产出✗ "; missing=$((missing+1)); }
  grep -q "Step 0" "$f" || { echo -n "Step0✗ "; missing=$((missing+1)); }
  grep -q "推荐方法论 skills" "$f" || { echo -n "skills✗ "; missing=$((missing+1)); }
  grep -q "质量门禁" "$f" || { echo -n "门禁✗ "; missing=$((missing+1)); }

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
if [ "$total" -ne "$expected" ]; then
  echo "Agent 数量错误：$total/$expected ✗"
  exit 1
elif [ $errors -eq 0 ]; then
  echo "全部通过 ✓"
  exit 0
else
  echo "$errors 项失败 ✗"
  exit 1
fi
