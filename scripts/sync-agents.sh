#!/usr/bin/env bash
# sync-agents.sh — 从 agents/（真源）自动派生 .claude/agents/
#
# 用法：
#   bash scripts/sync-agents.sh              # 同步全部
#   bash scripts/sync-agents.sh orchestrator # 只同步指定 Agent
#
# 规则：
#   1. agents/*.md 是真源，所有实质性编辑在这里
#   2. 本脚本自动派生 .claude/agents/*.md（frontmatter + 精简内容 + 动态上下文注入）
#   3. .cursor/agents/ 不需要同步（它 Read agents/ 真源）

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AGENTS_DIR="$ROOT_DIR/agents"
CLAUDE_DIR="$ROOT_DIR/.claude/agents"

# ──────────────────────────────────────────────
# Agent 配置：description / tools / model
# 新增 Agent 时在这里加一行即可
# ──────────────────────────────────────────────
declare -A DESCRIPTIONS=(
  [orchestrator]="编排总监：制定工作流框架、协调各 Agent、质量把关。当用户说'启动编排总监'或'制定工作流计划'时使用。"
  [market-analyst]="市场分析师：主动搜索竞品动态、用户痛点、市场趋势。当用户说'分析市场'、'看看竞品'、'市场调研'时使用。"
  [product-manager]="产品经理：主动发现需求、定义PRD、用户故事。当用户说'写PRD'、'定义需求'、'产品规划'时使用。"
  [architect]="架构师：技术设计、API设计、数据模型。当用户说'架构设计'、'技术方案'、'API设计'时使用。"
  [developer]="开发工程师：代码实现、单元测试、代码质量。当用户说'写代码'、'实现功能'、'开发'时使用。"
  [qa-manager]="测试经理：测试策略、测试用例、质量验证。当用户说'写测试'、'测试计划'、'验证'时使用。"
  [devops]="运维工程师：环境搭建、容器化、部署验证。当用户说'部署'、'搭建环境'、'Docker'时使用。"
  [docwriter]="技术文档师：编写README、API文档、CHANGELOG。当用户说'写文档'、'更新README'、'API文档'时使用。"
  [quality-gatekeeper]="质量门禁：代码审查、lint配置、质量报告。当用户说'代码审查'、'质量检查'、'lint'时使用。"
  [proactive-scout]="需求侦察兵：持续监控市场+产品体检，主动发现机会和威胁。当用户说'侦察市场'、'产品体检'、'市场扫描'时使用。"
  [feedback-analyst]="反馈分析师：收集用户反馈、bug报告，分类量化分析。当用户说'分析反馈'、'用户反馈'、'bug分析'时使用。"
  [iteration-planner]="迭代规划师：影响分析、制定迭代计划、版本策略。当用户说'迭代计划'、'版本规划'、'下个迭代'时使用。"
  [reviewer]="代码审查员：审查代码质量、安全性、可维护性。当用户说'代码审查'、'review'、'检查代码'时使用。"
  [dba]="数据库管理员：数据库架构、SQL优化、数据迁移、性能调优。当用户说'数据库'、'建表'、'SQL'、'迁移'、'DBA'时使用。需配置 mysql-mcp-server 或 polyglot-db-mcp-server。"
)

declare -A TOOLS=(
  [orchestrator]='["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
  [market-analyst]='["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
  [product-manager]='["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
  [architect]='["Read", "Glob", "Grep", "Write", "Edit"]'
  [developer]='["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
  [qa-manager]='["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
  [devops]='["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
  [docwriter]='["Read", "Glob", "Grep", "Write", "Edit"]'
  [quality-gatekeeper]='["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
  [proactive-scout]='["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
  [feedback-analyst]='["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
  [iteration-planner]='["Read", "Glob", "Grep", "Write", "Edit"]'
  [reviewer]='["Read", "Glob", "Grep", "Bash", "Write"]'
  [dba]='["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
)


# 动态上下文注入代码块
CONTEXT_INJECTION='## 项目现状

```!
echo "=== 项目结构 ==="
ls -la 2>/dev/null || echo "空目录"
echo ""
echo "=== docs/ 目录 ==="
ls docs/ 2>/dev/null || echo "无 docs/ 目录"
echo ""
echo "=== Git 状态 ==="
git log --oneline -5 2>/dev/null || echo "非 Git 仓库"
echo ""
echo "=== 技术栈 ==="
[ -f "go.mod" ] && echo "Go: $(head -1 go.mod)"
[ -f "package.json" ] && echo "Node.js: 有 package.json"
[ -f "requirements.txt" ] && echo "Python: 有 requirements.txt"
[ -f "Cargo.toml" ] && echo "Rust: 有 Cargo.toml"
```'

CONTEXT_MGMT_LINE='**上下文管理：** 遵循 `agents/AGENT_NAME.md` 中的上下文管理指令，控制输出长度。'

# ──────────────────────────────────────────────
# 派生函数
# ──────────────────────────────────────────────
derive_agent() {
  local name="$1"
  local src="$AGENTS_DIR/$name.md"
  local dst="$CLAUDE_DIR/$name.md"

  if [[ ! -f "$src" ]]; then
    echo "  ✗ 源文件不存在: $src"
    return 1
  fi

  # 提取核心内容：
  #   1. 去掉 {{PROJECT_DESCRIPTION}} 占位符行及其周围的空行
  #   2. 去掉 "## 背景" 章节（只有占位符）
  #   3. 去掉 "## 上下文管理" 整个章节（在末尾以单行引用替代）
  local core_content
  core_content=$(awk '
    /^## 背景/ { skip=1; next }
    /^## 上下文管理/ { skip=1; next }
    skip && /^## / { skip=0 }
    skip { next }
    /^\{\{PROJECT_/ { next }
    { print }
  ' "$src" | sed '/^[[:space:]]*$/{ N; /^[[:space:]]*\n[[:space:]]*$/d; }')

  # 生成 .claude/agents/ 文件
  cat > "$dst" <<EOF
---
description: "${DESCRIPTIONS[$name]}"
tools: ${TOOLS[$name]}
---

${core_content}

${CONTEXT_INJECTION}

${CONTEXT_MGMT_LINE//AGENT_NAME/$name}
EOF

  local lines
  lines=$(wc -l < "$dst")
  echo "  ✓ $name.md ($lines 行)"
}

# ──────────────────────────────────────────────
# 主逻辑
# ──────────────────────────────────────────────
echo "=== sync-agents.sh ==="
echo "真源: $AGENTS_DIR"
echo "派生: $CLAUDE_DIR"
echo ""

mkdir -p "$CLAUDE_DIR"

if [[ $# -gt 0 ]]; then
  # 只同步指定的 Agent
  for name in "$@"; do
    derive_agent "$name"
  done
else
  # 同步全部
  for src in "$AGENTS_DIR"/*.md; do
    name=$(basename "$src" .md)
    derive_agent "$name"
  done
fi

echo ""
echo "完成。真源在 agents/，编辑那里，然后跑本脚本同步。"
