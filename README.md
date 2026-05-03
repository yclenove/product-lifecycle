# product-lifecycle

通过 12 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。

**工具无关** — 核心价值（Agent prompt + 文档模板 + 方法论）可在任何 AI 编码工具中使用。

## 多工具使用

### Claude Code

```bash
# 安装
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle

# 使用
/product-lifecycle [项目名] [一句话描述]
```

SKILL.md 作为入口，自动加载 Agent prompt 和模板。

### Cursor

```bash
# 安装
git clone https://github.com/yclenove/product-lifecycle.git .product-lifecycle
```

在 `.cursorrules` 中引用：
```markdown
## 产品开发流程

遵循 .product-lifecycle/ 下的 Agent prompt 和模板：
1. 先读 .product-lifecycle/agents/orchestrator.md 启动编排总监
2. 按编排总监的指示启动其他 Agent
3. 使用 .product-lifecycle/templates/ 下的模板
```

或直接在对话中告诉 Cursor：
```
读取 .product-lifecycle/agents/market-analyst.md，按照里面的指引做市场分析。
输出到 docs/MKT-001-市场分析报告.md，格式参考 .product-lifecycle/templates/market_template.md。
```

### OpenCode / Codex / 其他 AI 工具

```bash
# 安装
git clone https://github.com/yclenove/product-lifecycle.git
```

直接使用 prompt 文件：
1. 读取 `agents/orchestrator.md`，让 AI 按照指引执行编排总监角色
2. 按编排总监的指示，依次读取其他 Agent prompt 执行
3. 使用 `templates/` 下的模板作为输出格式

示例对话：
```
你是本项目的编排总监。请读取 agents/orchestrator.md 并按照指引执行。
项目描述：[你的项目描述]
```

### 通用方法

不管用什么工具，核心流程一样：

1. **启动编排总监** — 读取 `agents/orchestrator.md`，制定工作流
2. **并行启动调研 Agent** — 读取 `agents/market-analyst.md` + `agents/product-manager.md`
3. **启动架构师** — 读取 `agents/architect.md`，产出技术设计
4. **并行启动执行 Agent** — 开发、测试、运维、文档、质量门禁
5. **测试循环** — 测试不通过 → 开发修复 → 重新测试
6. **部署循环** — 部署失败 → 运维修复 → 重新部署
7. **发布** — 质量门禁通过后发布

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

## 工作流（含反馈循环）

```
模式 A（0-to-1）：
编排总监 → 市场分析师 + 产品经理 → 架构师
  → 开发 → 测试 ⇄ 开发修复（循环）→ 部署 ⇄ 运维修复（循环）→ 质量门禁 → 发布

模式 B（持续迭代）：
需求侦察兵 + 反馈分析师 → 市场分析师 + 产品经理 → 迭代规划师
  → 架构师 → 开发 → 测试 ⇄ 开发修复（循环）→ 质量门禁 → 发布
```

**关键：工作流不是单向的**
- 测试不通过 → 开发修复 → 重新测试（可能多轮）
- 部署失败 → 运维修复 → 重新部署（可能多轮）
- 质量门禁不通过 → 开发修复 → 回到测试

## 目录结构

```
product-lifecycle/
├── SKILL.md              # Claude Code 入口（其他工具可忽略）
├── CHANGELOG.md          # 版本记录
├── README.md             # 本文件
├── agents/               # 12 个 Agent 的可直接使用 prompt
│   ├── orchestrator.md   # 编排总监
│   ├── market-analyst.md # 市场分析师
│   ├── product-manager.md # 产品经理
│   ├── architect.md      # 架构师
│   ├── developer.md      # 开发工程师
│   ├── qa-manager.md     # 测试经理
│   ├── devops.md         # 运维工程师
│   ├── docwriter.md      # 技术文档师
│   ├── quality-gatekeeper.md # 质量门禁
│   ├── proactive-scout.md # 需求侦察兵
│   ├── feedback-analyst.md # 反馈分析师
│   └── iteration-planner.md # 迭代规划师
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

- 小功能迭代（直接写代码）
- Bug 修复（直接修）

## License

MIT
