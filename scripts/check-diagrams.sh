#!/usr/bin/env bash
# 检查关键文档是否包含必需的图（或图引用）
# 用法：bash scripts/check-diagrams.sh
#
# 校验规则（详见 docs/05-advanced/DIAGRAMMING.md 第 4 节）：
#   - 文档命名前缀决定它是哪种类型（PRD-* → product，ARCH-* → architecture …）
#   - 每种类型至少出现 N 张图（svg 引用、drawio 引用、或 mermaid 代码块）
#
# 检查范围：docs/iterations/current/ 下当前迭代产物
# 退出码：0 ok，1 失败，2 警告但不阻断

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCAN_DIR="$ROOT_DIR/docs/iterations/current"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
ERR=0
WARN=0

ok()   { printf "${GREEN}[ OK ]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; WARN=$((WARN+1)); }
fail() { printf "${RED}[FAIL]${NC} %s\n" "$*"; ERR=$((ERR+1)); }

# prefix|min_diagrams|category
RULES="
PRD-|2|PRD（用户旅程 + 流程图）
ARCH-|3|架构（上下文 + 容器 + 时序）
DEV-|1|开发任务
DEV-BE-|2|后端（时序 + 状态机）
DEV-FE-|2|前端（组件层级 + 状态机）
QA-|2|测试（用例脑图 + 流程图）
UI-|2|UI 设计（信息架构 + 旅程）
SEC-|1|安全（威胁建模）
DATA-|2|数据分析（漏斗 + 流程）
DEPLOY-|2|部署（架构 + CI/CD）
PMO-|2|项目（甘特 + 依赖）
"

# 计数函数：返回文件里图引用的次数（svg + drawio + mermaid 代码块）
count_diagrams() {
  local f="$1"
  local svg drawio mermaid
  svg=$(grep -cE '!\[.*\]\([^)]*\.svg' "$f" 2>/dev/null || echo 0)
  drawio=$(grep -cE '\.drawio' "$f" 2>/dev/null || echo 0)
  mermaid=$(grep -cE '^```mermaid' "$f" 2>/dev/null || echo 0)
  echo $((svg + drawio + mermaid))
}

if [ ! -d "$SCAN_DIR" ]; then
  warn "docs/iterations/current/ 不存在，没有迭代产物可校验"
  echo
  echo "汇总：错误 0，警告 $WARN"
  exit 0
fi

# 找当前迭代下所有 md
FOUND=0
while IFS= read -r -d '' f; do
  base=$(basename "$f")
  while IFS='|' read -r prefix min cat; do
    [ -z "$prefix" ] && continue
    if [[ "$base" == "$prefix"* ]]; then
      FOUND=$((FOUND+1))
      n=$(count_diagrams "$f")
      if [ "$n" -ge "$min" ]; then
        ok "$base 含 $n 张图（要求 ≥$min·$cat）"
      else
        fail "$base 仅 $n 张图（要求 ≥$min·$cat） → 用 drawio 或 mermaid 补图"
      fi
      break
    fi
  done <<< "$RULES"
done < <(find "$SCAN_DIR" -type f -name '*.md' -print0)

if [ "$FOUND" -eq 0 ]; then
  warn "docs/iterations/current/ 下未找到带前缀的产物 md（PRD-/ARCH- 等）"
fi

echo
echo "========================================"
echo "  汇总：错误 $ERR，警告 $WARN，扫描 $FOUND"
echo "========================================"
[ "$ERR" -gt 0 ] && exit 1
exit 0
