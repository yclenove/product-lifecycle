#!/usr/bin/env bash
# 给 agents/*.md 批量注入「## 应该画的图」段
# 插入位置：在「## Step 0」段之后、下一个 `## ` 之前
# 幂等：已有该段则跳过

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# 各角色对应的必画图清单（CSV 风格 name|必画图|建议图）
DIAGRAMS_DATA="
orchestrator|甘特图（项目里程碑）|思维导图（工作流总览）
project-manager|甘特图、依赖关系图|风险矩阵
market-analyst|—|用户旅程、思维导图
product-manager|用户旅程图、流程图、用例图|信息架构
ui-designer|用户旅程、信息架构、关键页面线框|组件层级
architect|系统上下文图（C4-L1）、容器图（C4-L2）、关键时序图|组件图、部署架构
dba|ER 图|分片/索引示意图
developer|时序图、状态机|组件图
backend-developer|时序图（关键链路）、状态机（核心实体）|组件图、API 调用图
frontend-developer|组件层级图、关键状态机|路由图
qa-manager|测试用例脑图、关键流程图|状态覆盖图
devops|部署架构图、CI/CD 流水线图|网络拓扑
security-engineer|威胁建模图（STRIDE）|信任边界图
data-analyst|漏斗图/桑基图、关键流程图|数据流图
feedback-analyst|—|鱼骨图、亲和图、思维导图
docwriter|—|看产出物自身需要的图
iteration-planner|—|思维导图（backlog 优先级）
proactive-scout|—|思维导图（市场扫描）
reviewer|—|按被审产物需要补图
quality-gatekeeper|—|按门禁项需要补图
"

count_updated=0
count_skipped=0

while IFS='|' read -r name must suggest; do
  [ -z "$name" ] && continue
  file="$ROOT_DIR/agents/$name.md"
  [ ! -f "$file" ] && continue

  if grep -q "^## 应该画的图" "$file"; then
    echo "[SKIP] $name (已注入)"
    count_skipped=$((count_skipped + 1))
    continue
  fi

  block=$(cat <<EOF

## 应该画的图

> 文档配图能让结论一眼可读。本角色至少要画下面这些图。详细规范见 \`docs/05-advanced/DIAGRAMMING.md\`。

| 类别 | 内容 |
|------|------|
| **必画** | $must |
| **建议** | $suggest |

**工具优先级**：

1. **drawio MCP**（首选）—— 仓库已配 \`.mcp.json\`，直接让 AI 画。例：
   > 用 drawio 画一张 \`$name\` 阶段所需的关键图，保存为 SVG 到 \`docs/iterations/current/<类型>/assets/\`。
2. **Mermaid**（备用 / 嵌入 markdown）—— drawio 不可用或图很简单时使用。
3. 反模式与视觉规范见 \`docs/05-advanced/DIAGRAMMING.md\` 第 5-6 节。

EOF
  )

  tmpfile=$(mktemp)
  awk -v blk="$block" '
    BEGIN { in_step0=0; inserted=0 }
    /^## Step 0：/ { in_step0=1; print; next }
    in_step0 && /^## / && !inserted {
      print blk
      inserted=1
      in_step0=0
      print
      next
    }
    { print }
    END {
      if (in_step0 && !inserted) {
        print blk
      }
    }
  ' "$file" > "$tmpfile"

  mv "$tmpfile" "$file"
  echo "[OK]   $name"
  count_updated=$((count_updated + 1))
done <<< "$DIAGRAMS_DATA"

echo ""
echo "更新 $count_updated 个，跳过 $count_skipped 个"
