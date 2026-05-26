#!/usr/bin/env bash
# 给关键模板顶部加「图示要求」段。幂等。

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# template|图示要求清单（短描述）
DATA="
product_template|用户旅程图（必）、主要业务流程图（必）；用例图、信息架构（建议）
architecture_template|系统上下文 C4-L1（必）、容器图 C4-L2（必）、关键时序图（必）；组件图、部署架构（建议）
backend_template|时序图（关键链路，必）、状态机（核心实体，必）；组件图、API 调用图（建议）
frontend_template|组件层级图（必）、关键状态机（必）；路由图（建议）
qa_template|测试用例脑图（必）、关键流程图（必）；状态覆盖图（建议）
ui_design_template|信息架构（必）、用户旅程（必）、关键页面线框（必）；组件库示意图（建议）
security_template|威胁建模图 STRIDE（必）；信任边界图（建议）
data_template|漏斗图或桑基图（必）、关键流程图（必）；数据流图（建议）
devops_template|部署架构图（必）、CI/CD 流水线图（必）；网络拓扑（建议）
pmo_template|甘特图（必）、依赖关系图（必）；里程碑路线图（建议）
"

count=0
while IFS='|' read -r tmpl req; do
  [ -z "$tmpl" ] && continue
  file="$ROOT_DIR/templates/$tmpl.md"
  [ ! -f "$file" ] && { echo "[MISS] $tmpl"; continue; }

  if grep -q "^## 图示要求" "$file"; then
    echo "[SKIP] $tmpl"
    continue
  fi

  block=$(cat <<EOF

## 图示要求 [必填]

> 完整规范见 \`docs/05-advanced/DIAGRAMMING.md\`。优先用 **drawio MCP** 生成 SVG，放到同级 \`assets/\` 下。

**本类文档至少包含：**

$req

**嵌入语法：**

\`\`\`markdown
![<图标题>](assets/<文档ID>-<图类型>.svg)
> 源文件：\`assets/<文档ID>-<图类型>.drawio\`
\`\`\`

**离线 / 简图可降级 Mermaid**（\`\`\`mermaid 代码块）。

EOF
  )

  # 插到第一个 "---" 之后或文件最早位置
  tmpfile=$(mktemp)
  awk -v blk="$block" '
    BEGIN { inserted=0; sep_seen=0 }
    /^---$/ && !inserted {
      sep_seen++
      print
      if (sep_seen == 1) {
        print blk
        inserted=1
      }
      next
    }
    { print }
    END {
      if (!inserted) { print blk }
    }
  ' "$file" > "$tmpfile"

  mv "$tmpfile" "$file"
  echo "[OK]   $tmpl"
  count=$((count + 1))
done <<< "$DATA"

echo
echo "更新 $count 个 template"
