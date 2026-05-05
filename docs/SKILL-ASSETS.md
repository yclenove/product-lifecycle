# 技能包资源索引（工具无关）

根目录 `SKILL.md` 引用本文件，避免在正文中重复长表格。

## 通用 Agent Prompts（`agents/`）

适用于任意 AI 工具；用法：读取文件，替换 `{{PROJECT_NAME}}` 与 `{{PROJECT_DESCRIPTION}}`，在会话中作为系统/用户指令使用。**Claude Code** 优先用 `.claude/agents/`（见 `docs/SKILL-CLAUDE-CODE.md`）。**Cursor** 推荐在业务项目 `.cursor/agents/` 中为每角色建薄 Subagent，正文 Read 本表所列 `agents/*.md`；官方亦支持加载项目内 `.claude/agents/`（与 `.cursor/agents/` 同名时以前者优先），详见 `docs/SKILL-CURSOR.md` 与 [Cursor 文档：Subagents](https://cursor.com/docs/subagents)。


| 文件                             | 角色    |
| ------------------------------ | ----- |
| `agents/orchestrator.md`       | 编排总监  |
| `agents/market-analyst.md`     | 市场分析师 |
| `agents/product-manager.md`    | 产品经理  |
| `agents/architect.md`          | 架构师   |
| `agents/developer.md`          | 开发工程师 |
| `agents/qa-manager.md`         | 测试经理  |
| `agents/devops.md`             | 运维工程师 |
| `agents/docwriter.md`          | 技术文档师 |
| `agents/quality-gatekeeper.md` | 质量门禁  |
| `agents/feedback-analyst.md`   | 反馈分析师 |
| `agents/iteration-planner.md`  | 迭代规划师 |
| `agents/proactive-scout.md`    | 需求侦察兵 |


## 文档模板（`templates/`）


| 模板                           | 用途            |
| ---------------------------- | ------------- |
| `workflow_plan_template.md`  | 工作流框架（编排总监用）  |
| `market_template.md`         | 市场分析报告        |
| `product_template.md`        | PRD           |
| `architecture_template.md`   | 技术设计文档        |
| `developer_template.md`      | 开发任务          |
| `qa_template.md`             | 测试计划          |
| `devops_template.md`         | 运维任务          |
| `docwriter_template.md`      | 文档任务          |
| `feedback_template.md`       | 反馈分析报告（持续迭代用） |
| `iteration_template.md`      | 迭代计划（持续迭代用）   |
| `scout_template.md`          | 侦察报告（需求侦察兵用）  |
| `quality_report_template.md` | 质量报告（质量门禁用）   |
| `reviewer_template.md`       | 代码审查报告（代码审查员用） |


## 13 Agent 角色与产出（速览）


| Agent     | 职责                  | 输入         | 输出         | 模式  |
| --------- | ------------------- | ---------- | ---------- | --- |
| **编排总监**  | 制定框架、协调各 Agent、质量把关 | 项目文档       | 工作流框架 + 模板 | A/B |
| **市场分析师** | 竞品、用户画像、定价、GTM      | 主动搜索       | 市场分析报告     | A   |
| **产品经理**  | PRD、用户故事、验收标准       | 主动搜索       | PRD        | A   |
| **架构师**   | 技术设计、API、数据模型       | PRD + 代码现状 | 技术设计文档     | A/B |
| **开发工程师** | 代码实现、单元测试           | PRD + 架构设计 | 代码 + 测试    | A/B |
| **测试经理**  | 测试策略、用例、质量门禁        | PRD + 架构设计 | 测试计划       | A/B |
| **运维工程师** | 环境搭建、部署、监控          | 架构设计 + 代码  | 可运行环境      | A   |
| **技术文档师** | 用户文档、API 文档、变更日志    | 代码 + PRD   | 用户文档       | A/B |
| **质量门禁**  | 代码审查、lint 规则、MCP 配置 | 代码 + 测试    | 质量报告       | A/B |
| **需求侦察兵** | 持续监控市场 + 产品体检       | 主动搜索       | 侦察报告       | B   |
| **反馈分析师** | 收集用户反馈、bug 报告       | 反馈渠道       | 反馈分析报告     | B   |
| **迭代规划师** | 影响分析、迭代计划、版本策略      | 反馈分析       | 迭代计划       | B   |
| **代码审查员** | 代码质量、安全性、可维护性审查    | 代码 + 测试    | 代码审查报告     | A/B |
| **数据库管理员** | 数据库架构、SQL优化、数据迁移、性能调优 | 架构设计 + 代码 | 数据库架构文档     | A/B |


> 模式 A = 从 0 到 1，模式 B = 持续迭代

## 质量门禁（全流程速查）


| 阶段  | 门禁                              |
| --- | ------------------------------- |
| 调研  | ≥3 竞品、≥2 用户画像、数据来源标注            |
| 需求  | 每功能有验收标准、优先级标注、NFR 对齐           |
| 设计  | 技术栈对齐、数据模型有 ER、API 有示例          |
| 实现  | 单元测试通过、静态分析无警告、代码 review 通过     |
| 测试  | P0 用例 100% 通过、无阻塞缺陷             |
| 部署  | 健康检查通过、监控就绪                     |
| 文档  | README 准确、API 文档完整、CHANGELOG 更新 |
| 安全  | 无硬编码密钥、依赖无高危 CVE、.env 不入库、安全检查通过 |


## 引用语法规范

| 引用类型 | 语法 | 示例 |
|----------|------|------|
| 文件路径 | 反引号包裹 | `agents/orchestrator.md` |
| 章节引用 | 文件路径 + §符号 | `docs/PRD-*.md §5` |
| 文档编号 | 编号前缀 | MKT-001、PRD-001 |
| 模板引用 | templates/ 前缀 | `templates/market_template.md` |

**注意：** 不使用 Cursor 特有的 `@file` 语法，保持工具无关。

## 其他文件

- **`docs/CONTEXT-MANAGEMENT.md`** — 多 Agent 协作时的上下文管理（摘要传递、上下文预算、交接规范）。
- **`examples/cloudflow.md`** — 虚构项目 CloudFlow 的完整生命周期示例（时间线与产出物清单）。


### 模型选择策略

模型选择取决于你的 API 提供商。Subagent 定义中不指定 model 字段，自动继承用户全局配置。

如需指定模型，在 .claude/agents/*.md 的 frontmatter 中添加 `model: "模型名"`。

当前默认模型配置（小米 Mimo）：

| 模型 | 适用场景 | Agent |
|------|----------|-------|
| 继承用户当前模型 | 复杂推理、全局协调 | orchestrator, architect |
| 继承用户当前模型 | 常规任务 | 其余 11 个 Agent |
