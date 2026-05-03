# product-lifecycle

Claude Code skill — 通过 12 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。

## 安装

```bash
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle
```

## 使用

```
/product-lifecycle [项目名] [一句话描述]
```

示例：`/product-lifecycle myapp "SaaS 协作平台"`

## 12 个 Agent 角色

### 自驱动层（不需要输入）

| Agent | 职责 | 产出物 |
|-------|------|--------|
| 需求侦察兵 | 持续监控市场 + 产品体检 | 侦察报告 |
| 市场分析师 | 竞品、用户画像、定价 | 市场分析报告 |
| 产品经理 | PRD、用户故事、验收标准 | PRD |

### 执行层（需要输入）

| Agent | 职责 | 产出物 |
|-------|------|--------|
| 编排总监 | 制定框架、协调各 Agent | WORKFLOW_PLAN.md |
| 架构师 | 技术设计、API、数据模型 | 技术设计文档 |
| 开发工程师 | 代码实现、单元测试 | 代码 + 测试 |
| 测试经理 | 测试策略、用例、质量门禁 | 测试计划 |
| 运维工程师 | 环境搭建、部署、监控 | 可运行环境 |
| 技术文档师 | 用户文档、API 文档 | 用户文档 |
| 质量门禁 | 代码审查、lint、MCP | 质量报告 |
| 反馈分析师 | 收集用户反馈、bug 报告 | 反馈分析报告 |
| 迭代规划师 | 影响分析、迭代计划 | 迭代计划 |

## 两种模式

```
模式 A（0-to-1）：编排总监 → 市场分析师 + 产品经理 → 架构师 → 开发 + 测试 + 运维 + 文档 + 质量门禁 → 发布

模式 B（持续迭代）：需求侦察兵 → 反馈分析师 → 迭代规划师 → 架构师 → 开发 + 测试 + 质量门禁 → 发布
```

## 目录结构

```
product-lifecycle/
├── SKILL.md              # 主文档（skill 入口）
├── CHANGELOG.md          # 版本记录
├── README.md             # 本文件
├── agents/               # 12 个 Agent 的可直接使用 prompt
│   ├── orchestrator.md
│   ├── market-analyst.md
│   ├── product-manager.md
│   ├── architect.md
│   ├── developer.md
│   ├── qa-manager.md
│   ├── devops.md
│   ├── docwriter.md
│   ├── quality-gatekeeper.md
│   ├── proactive-scout.md
│   ├── feedback-analyst.md
│   └── iteration-planner.md
├── templates/            # 文档模板
│   ├── workflow_plan_template.md
│   ├── market_template.md
│   ├── product_template.md
│   ├── architecture_template.md
│   ├── developer_template.md
│   ├── qa_template.md
│   ├── devops_template.md
│   ├── docwriter_template.md
│   ├── feedback_template.md
│   └── iteration_template.md
├── scripts/              # 工具脚本
│   └── detect.sh         # 项目自动检测
└── examples/             # 完整示例
    └── cloudflow.md      # CloudFlow 虚构项目 worked example
```

## 适用场景

- 新产品/项目启动，需要完整生命周期管理
- 已有产品需要持续迭代改进
- 需要主动发现市场机会和用户需求

## 不适用

- 小功能迭代（用 writing-plans）
- Bug 修复（用 systematic-debugging）

## License

MIT
