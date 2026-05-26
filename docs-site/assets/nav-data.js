// 文档站导航数据（手工维护，与目录结构对应）
// 后续可由 scripts/generate-nav.sh 自动生成

window.PL_NAV = [
  {
    title: "首页",
    items: [
      { text: "项目介绍", href: "/docs-site/index.html" }
    ]
  },
  {
    title: "01 · 入门 · 这是什么",
    items: [
      { text: "1.1 product-lifecycle 是什么", href: "/docs-site/01-introduction/01-what-is-product-lifecycle.html" },
      { text: "1.2 为什么要 20 个 Agent", href: "/docs-site/01-introduction/02-why-multi-agent.html" },
      { text: "1.3 关键名词速查", href: "/docs-site/01-introduction/03-glossary-mini.html" },
      { text: "1.4 心智模型：把它当作公司", href: "/docs-site/01-introduction/04-mental-model.html" }
    ]
  },
  {
    title: "02 · 核心概念",
    items: [
      { text: "2.1 什么是 Agent", href: "/docs-site/02-concepts/01-agent.html" },
      { text: "2.2 Prompt 与模板", href: "/docs-site/02-concepts/02-prompt-template.html" },
      { text: "2.3 Skill 是什么", href: "/docs-site/02-concepts/03-skill.html" },
      { text: "2.4 MCP 协议入门", href: "/docs-site/02-concepts/04-mcp.html" },
      { text: "2.5 工作流编排", href: "/docs-site/02-concepts/05-workflow.html" },
      { text: "2.6 迭代与长程模式", href: "/docs-site/02-concepts/06-iteration.html" }
    ]
  },
  {
    title: "03 · 动手教程",
    items: [
      { text: "3.1 Claude Code 5 分钟", href: "/docs-site/03-tutorials/01-quickstart-claude-code.html" },
      { text: "3.2 Cursor 5 分钟", href: "/docs-site/03-tutorials/02-quickstart-cursor.html" },
      { text: "3.3 第一个项目完整走读", href: "/docs-site/03-tutorials/03-first-project-walkthrough.html" },
      { text: "3.4 长程跨天迭代", href: "/docs-site/03-tutorials/04-long-running.html" }
    ]
  },
  {
    title: "04 · 20 个角色",
    items: [
      { text: "角色总览", href: "/docs-site/04-roles/index.html" },
      { text: "编排总监 orchestrator", href: "/docs-site/04-roles/orchestrator.html" },
      { text: "项目经理 project-manager", href: "/docs-site/04-roles/project-manager.html" },
      { text: "需求侦察兵 proactive-scout", href: "/docs-site/04-roles/proactive-scout.html" },
      { text: "市场分析师 market-analyst", href: "/docs-site/04-roles/market-analyst.html" },
      { text: "产品经理 product-manager", href: "/docs-site/04-roles/product-manager.html" },
      { text: "UI/UX 设计师 ui-designer", href: "/docs-site/04-roles/ui-designer.html" },
      { text: "架构师 architect", href: "/docs-site/04-roles/architect.html" },
      { text: "DBA dba", href: "/docs-site/04-roles/dba.html" },
      { text: "开发工程师 developer", href: "/docs-site/04-roles/developer.html" },
      { text: "前端工程师 frontend-developer", href: "/docs-site/04-roles/frontend-developer.html" },
      { text: "后端工程师 backend-developer", href: "/docs-site/04-roles/backend-developer.html" },
      { text: "测试经理 qa-manager", href: "/docs-site/04-roles/qa-manager.html" },
      { text: "运维工程师 devops", href: "/docs-site/04-roles/devops.html" },
      { text: "安全工程师 security-engineer", href: "/docs-site/04-roles/security-engineer.html" },
      { text: "数据分析师 data-analyst", href: "/docs-site/04-roles/data-analyst.html" },
      { text: "反馈分析师 feedback-analyst", href: "/docs-site/04-roles/feedback-analyst.html" },
      { text: "迭代规划师 iteration-planner", href: "/docs-site/04-roles/iteration-planner.html" },
      { text: "技术文档师 docwriter", href: "/docs-site/04-roles/docwriter.html" },
      { text: "代码审查员 reviewer", href: "/docs-site/04-roles/reviewer.html" },
      { text: "质量门禁 quality-gatekeeper", href: "/docs-site/04-roles/quality-gatekeeper.html" }
    ]
  },
  {
    title: "05 · 深入原理",
    items: [
      { text: "5.1 为什么 AI 需要流程", href: "/docs-site/05-deep-dive/01-why-ai-needs-process.html" },
      { text: "5.2 Prompt 工程基础", href: "/docs-site/05-deep-dive/02-prompt-engineering.html" },
      { text: "5.3 上下文管理", href: "/docs-site/05-deep-dive/03-context-management.html" },
      { text: "5.4 MCP 协议深入", href: "/docs-site/05-deep-dive/04-mcp-protocol.html" },
      { text: "5.5 画图的认知原理", href: "/docs-site/05-deep-dive/05-diagramming-theory.html" },
      { text: "5.6 Token 经济学", href: "/docs-site/05-deep-dive/06-token-economy.html" }
    ]
  },
  {
    title: "06 · 高级用法",
    items: [
      { text: "6.1 自定义已有 Agent", href: "/docs-site/06-advanced/01-customize-agent.html" },
      { text: "6.2 新增一个角色", href: "/docs-site/06-advanced/02-add-new-role.html" },
      { text: "6.3 团队协作工作流", href: "/docs-site/06-advanced/03-team-workflow.html" },
      { text: "6.4 CI/CD 集成", href: "/docs-site/06-advanced/04-cicd-integration.html" }
    ]
  },
  {
    title: "07 · 场景配方",
    items: [
      { text: "7.1 SaaS 项目", href: "/docs-site/07-cookbook/01-saas-project.html" },
      { text: "7.2 内部工具", href: "/docs-site/07-cookbook/02-internal-tool.html" },
      { text: "7.3 移动应用", href: "/docs-site/07-cookbook/03-mobile-app.html" },
      { text: "7.4 微服务", href: "/docs-site/07-cookbook/04-microservice.html" }
    ]
  },
  {
    title: "参考",
    items: [
      { text: "📖 大词典（150+ 名词）", href: "/docs-site/08-glossary.html" },
      { text: "❓ FAQ", href: "/docs-site/09-faq.html" },
      { text: "🔗 扩展阅读", href: "/docs-site/10-references.html" }
    ]
  }
];

// 站点元信息（用于搜索索引、面包屑等）
window.PL_SITE = {
  title: "product-lifecycle 文档",
  subtitle: "v3.3 · 20 Agent 产品生命周期框架",
  repo: "https://github.com/yclenove/product-lifecycle"
};
