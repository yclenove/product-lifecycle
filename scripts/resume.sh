#!/usr/bin/env bash
# 长程迭代模式：恢复上下文
# 用法：bash scripts/resume.sh
#
# 输出当前状态摘要，提示下一步该做什么。

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE="$ROOT_DIR/docs/07-long-running/STATE.md"
HANDOFF="$ROOT_DIR/docs/07-long-running/HANDOFF.md"

echo "========================================"
echo "  长程迭代恢复"
echo "========================================"
echo

if [ ! -f "$STATE" ]; then
    echo "[!] 未检测到 STATE.md，看起来这是新项目或未启用长程模式。"
    echo
    echo "启用长程模式："
    echo "  cp docs/07-long-running/STATE.template.md docs/07-long-running/STATE.md"
    echo
    echo "然后正常走 orchestrator 流程即可。"
    exit 0
fi

echo "[OK] 检测到 STATE.md，正在恢复上下文…"
echo
echo "----------------------------------------"
echo "  当前状态摘要"
echo "----------------------------------------"

# 提取元数据表格
awk '/^## 元数据/,/^## 当前进行中/' "$STATE" | head -n 20
echo
echo "----------------------------------------"
echo "  当前进行中"
echo "----------------------------------------"
awk '/^## 当前进行中/,/^## 已完成 Agent 清单/' "$STATE" | sed '$d'
echo
echo "----------------------------------------"
echo "  最近 3 个已完成 Agent"
echo "----------------------------------------"
awk '/^## 已完成 Agent 清单/,/^## 未完成/' "$STATE" | grep -E "^### " | head -n 3 || echo "(暂无)"
echo
echo "----------------------------------------"
echo "  阻塞项"
echo "----------------------------------------"
awk '/^## 未完成 \/ 阻塞项/,/^## 下一步建议/' "$STATE" | sed '$d'
echo
echo "----------------------------------------"
echo "  下一步建议"
echo "----------------------------------------"
awk '/^## 下一步建议/,/^## 关键产出索引/' "$STATE" | sed '$d'

# 读取 HANDOFF（如果存在）
if [ -f "$HANDOFF" ]; then
    echo
    echo "========================================"
    echo "  上次 Session 移交单"
    echo "========================================"
    echo
    awk '/^## 给下一个 AI 的话/,/^## 风险预警/' "$HANDOFF" | sed '$d' || echo "(HANDOFF 中无该段)"
fi

echo
echo "========================================"
echo "  建议下一步操作"
echo "========================================"
echo
echo "1. 在 AI 工具里粘贴："
echo
echo "   > 我正在长程迭代中，请先读 docs/07-long-running/STATE.md 和"
echo "   > docs/07-long-running/HANDOFF.md 恢复上下文，然后接着上次进度继续。"
echo
echo "2. 关键文档清单已在 STATE.md 的「关键产出索引」表里"
echo