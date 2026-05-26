#!/usr/bin/env bash
# 长程迭代模式：会话结束前生成移交单
# 用法：bash scripts/handoff.sh
#
# 把 HANDOFF.template.md 拷贝到 HANDOFF.md（如果不存在），并提示填写要点。

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT_DIR/docs/07-long-running/HANDOFF.template.md"
HANDOFF="$ROOT_DIR/docs/07-long-running/HANDOFF.md"

if [ ! -f "$TEMPLATE" ]; then
    echo "[!] HANDOFF.template.md 不存在，请先 git pull 同步"
    exit 1
fi

if [ -f "$HANDOFF" ]; then
    echo "[!] HANDOFF.md 已存在。"
    echo
    read -p "覆盖？(y/N): " ans
    if [ "$ans" != "y" ] && [ "$ans" != "Y" ]; then
        echo "已取消。"
        exit 0
    fi
fi

cp "$TEMPLATE" "$HANDOFF"
echo "[OK] 已生成 $HANDOFF"
echo
echo "请填写以下重点字段："
echo "  - 本轮主要产出"
echo "  - 本轮关键决策"
echo "  - 遗留 / 未决策项（特别是 P0）"
echo "  - 给下一个 AI 的话（口语 ok）"
echo
echo "可以让 AI 自动填："
echo "  > 帮我填 docs/07-long-running/HANDOFF.md，"
echo "  > 基于本次 session 的产出和未完成项"