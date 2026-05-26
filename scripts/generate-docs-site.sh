#!/usr/bin/env bash
# generate-docs-site.sh — 从 agents/*.md 生成角色页；为导航中缺失的 HTML 生成骨架页
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE="$ROOT/docs-site"
AGENTS="$ROOT/agents"

html_escape() {
  sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
}

md_to_html_body() {
  # 极简 markdown → HTML（标题、列表、代码块、段落）
  awk '
    BEGIN { in_pre=0 }
    /^```/ {
      if (in_pre) { print "</code></pre>"; in_pre=0 }
      else { print "<pre><code>"; in_pre=1 }
      next
    }
    in_pre { print; next }
    /^#### / { sub(/^#### /,""); print "<h4>" $0 "</h4>"; next }
    /^### / { sub(/^### /,""); print "<h3>" $0 "</h3>"; next }
    /^## / { sub(/^## /,""); print "<h2>" $0 "</h2>"; next }
    /^# / { sub(/^# /,""); print "<h2>" $0 "</h2>"; next }
    /^- / { sub(/^- /,""); print "<li>" $0 "</li>"; next }
    /^[0-9]+\. / { print "<li>" $0 "</li>"; next }
    /^$/ { next }
    { print "<p>" $0 "</p>" }
  ' | sed 's/<li>/<ul><li>/; s/<\/li>/<\/li><\/ul>/g' 2>/dev/null || cat
}

write_role_page() {
  local agent="$1"
  local src="$AGENTS/${agent}.md"
  local out="$SITE/04-roles/${agent}.html"
  local title
  title=$(head -5 "$src" | grep -E '^你是|^# ' | head -1 | sed 's/^你是 //;s/ 的.*//;s/^# //' || echo "$agent")

  mkdir -p "$SITE/04-roles"
  {
    cat <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${agent} · product-lifecycle</title>
  <link rel="stylesheet" href="../assets/style.css">
  <script src="../assets/nav-data.js"></script>
  <script src="../assets/layout.js" defer></script>
</head>
<body data-current="/docs-site/04-roles/${agent}.html">
<main class="pl-content">
  <h1>${agent}</h1>
  <p class="pl-lead">本页由 <code>agents/${agent}.md</code> 自动生成。修改角色请改真源后重新运行 <code>bash scripts/generate-docs-site.sh</code>。</p>
  <div class="pl-info"><strong>真源文件</strong> <code>agents/${agent}.md</code></div>
  <article class="pl-agent-body">
EOF
    # 跳过 frontmatter if any (agents/ usually no frontmatter)
    sed '1,/^你是 /!b; /^你是 /,$!d' "$src" 2>/dev/null | html_escape | md_to_html_body || html_escape < "$src" | md_to_html_body
    cat <<EOF
  </article>
  <div class="pl-tip"><strong>下一步</strong> 在 Claude Code 用 Agent 工具读取 <code>agents/${agent}.md</code> 并执行任务；或 Cursor 中 <code>@${agent}</code>。</div>
</main>
</body>
</html>
EOF
  } > "$out"
  echo "  role: $out"
}

write_stub() {
  local rel="$1"   # e.g. 03-tutorials/01-quickstart.html
  local title="$2"
  local out="$SITE/$rel"
  mkdir -p "$(dirname "$out")"
  [ -f "$out" ] && return 0
  local depth
  depth=$(echo "$rel" | tr -cd '/' | wc -c)
  local prefix=""
  for ((i=0; i<depth; i++)); do prefix="../$prefix"; done
  local current="/docs-site/$rel"
  cat > "$out" <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${title} · product-lifecycle</title>
  <link rel="stylesheet" href="${prefix}assets/style.css">
  <script src="${prefix}assets/nav-data.js"></script>
  <script src="${prefix}assets/layout.js" defer></script>
</head>
<body data-current="${current}">
<main class="pl-content">
  <h1>${title}</h1>
  <p class="pl-lead">本页为文档站占位，正文将在后续版本补充。请先阅读 <a href="${prefix}index.html">首页</a> 与已完成的入门章节。</p>
  <div class="pl-warning"><strong>建设中</strong> 对应 Markdown 主文档可能已有更完整内容，见仓库 <code>docs/</code> 目录。</div>
  <h2>你可以先看</h2>
  <ul>
    <li><a href="${prefix}01-introduction/01-what-is-product-lifecycle.html">product-lifecycle 是什么</a></li>
    <li><a href="${prefix}02-concepts/01-agent.html">什么是 Agent</a></li>
    <li><a href="${prefix}08-glossary.html">大词典</a></li>
  </ul>
</main>
</body>
</html>
EOF
  echo "  stub: $out"
}

echo "=== 生成角色页 ==="
for f in "$AGENTS"/*.md; do
  write_role_page "$(basename "$f" .md)"
done

write_stub "04-roles/index.html" "20 个角色总览" || true

echo "=== 生成缺失骨架页 ==="
STUBS=(
  "02-concepts/05-workflow.html|2.5 工作流编排"
  "02-concepts/06-iteration.html|2.6 迭代与长程模式"
  "03-tutorials/01-quickstart-claude-code.html|3.1 Claude Code 5 分钟"
  "03-tutorials/02-quickstart-cursor.html|3.2 Cursor 5 分钟"
  "03-tutorials/03-first-project-walkthrough.html|3.3 第一个项目完整走读"
  "03-tutorials/04-long-running.html|3.4 长程跨天迭代"
  "05-deep-dive/01-why-ai-needs-process.html|5.1 为什么 AI 需要流程"
  "05-deep-dive/02-prompt-engineering.html|5.2 Prompt 工程基础"
  "05-deep-dive/03-context-management.html|5.3 上下文管理"
  "05-deep-dive/04-mcp-protocol.html|5.4 MCP 协议深入"
  "05-deep-dive/05-diagramming-theory.html|5.5 画图的认知原理"
  "05-deep-dive/06-token-economy.html|5.6 Token 经济学"
  "06-advanced/01-customize-agent.html|6.1 自定义已有 Agent"
  "06-advanced/02-add-new-role.html|6.2 新增一个角色"
  "06-advanced/03-team-workflow.html|6.3 团队协作工作流"
  "06-advanced/04-cicd-integration.html|6.4 CI/CD 集成"
  "07-cookbook/01-saas-project.html|7.1 SaaS 项目"
  "07-cookbook/02-internal-tool.html|7.2 内部工具"
  "07-cookbook/03-mobile-app.html|7.3 移动应用"
  "07-cookbook/04-microservice.html|7.4 微服务"
  "08-glossary.html|大词典"
  "09-faq.html|FAQ"
  "10-references.html|扩展阅读"
)
for item in "${STUBS[@]}"; do
  rel="${item%%|*}"
  title="${item##*|}"
  write_stub "$rel" "$title"
done

echo "完成。打开 docs-site/index.html 或运行: bash scripts/serve-docs.sh"
