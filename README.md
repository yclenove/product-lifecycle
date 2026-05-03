# product-lifecycle

Claude Code skill — 通过 8 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。

## 安装

```bash
# 克隆到 Claude Code skills 目录
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle
```

## 使用

在 Claude Code 中触发：

```
/product-lifecycle
```

或直接描述需求，Claude 会自动匹配此 skill。

## 8 个 Agent 角色

| Agent | 职责 | 产出物 |
|-------|------|--------|
| 编排总监 | 制定框架、协调各 Agent | WORKFLOW_PLAN.md |
| 市场分析师 | 竞品、用户画像、定价 | 市场分析报告 |
| 产品经理 | PRD、用户故事、验收标准 | PRD |
| 架构师 | 技术设计、API、数据模型 | 技术设计文档 |
| 开发工程师 | 代码实现、单元测试 | 代码 + 测试 |
| 测试经理 | 测试策略、用例、质量门禁 | 测试计划 |
| 运维工程师 | 环境搭建、部署、监控 | 可运行环境 |
| 技术文档师 | 用户文档、API 文档 | 用户文档 |

## 执行流程

```
Phase 1: 编排总监 → 市场分析师 + 产品经理
Phase 2: 架构师 → 开发 + 测试 + 运维 + 文档（可并行）
Phase 3: 质量门禁 → 发布
Phase 4: 用户反馈 → 下一迭代
```

## 模板

`templates/` 目录包含 8 个角色的文档模板：

- `workflow_plan_template.md` — 工作流框架模板
- `market_template.md` — 市场分析报告模板
- `product_template.md` — PRD 模板
- `architecture_template.md` — 技术设计模板
- `developer_template.md` — 开发任务模板
- `qa_template.md` — 测试计划模板
- `devops_template.md` — 运维任务模板
- `docwriter_template.md` — 文档任务模板

## 适用场景

- 新产品/项目启动，需要完整生命周期管理
- 进入新 Phase，需要从需求到部署的全流程
- 产品需要持续迭代改进

## 不适用

- 小功能迭代（用 writing-plans）
- Bug 修复（用 systematic-debugging）
- 纯文档生成（无代码产出）

## 语言无关

质量门禁和模板不绑定特定编程语言。根据项目实际技术栈选择对应的测试、lint、部署工具。

## License

MIT
