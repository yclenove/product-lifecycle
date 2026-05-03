---
name: product-lifecycle
description: Use when starting a new product/project and need to orchestrate a full development lifecycle from market analysis through architecture, implementation, testing, deployment, and continuous iteration
when_to_use: "new product launch, full lifecycle management, Phase kickoff, product iteration, market analysis needed, PRD creation, architecture design, product upgrade, new feature lifecycle"
argument-hint: "[project-name] [project-description]"
allowed-tools: Agent WebSearch WebFetch Read Write Edit Glob Grep Bash TodoWrite
---

# 多 Agent 产品开发全流程

## 概述

通过 12 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。不是只生成文档——是从需求到可运行产品的端到端流程。

## 何时使用

- 新产品/项目启动，需要完整生命周期管理
- 进入新 Phase，需要从需求到部署的全流程
- 产品需要持续迭代改进
- 团队需要标准化的开发流程

**不适用：**
- 小功能迭代（直接用 writing-plans）
- Bug 修复（用 systematic-debugging）
- 纯文档生成（无代码产出）

## 两种模式

### 模式 A：从 0 到 1（新产品）

```
编排总监 → 市场分析师 + 产品经理 → 架构师
    → 开发 + 测试 + 运维 + 文档 + 质量门禁 → 发布
```

适用：新项目启动、新 Phase、从零构建。

### 模式 B：持续迭代（已有产品）

```
需求侦察兵 + 反馈分析师 → 市场分析师 + 产品经理 → 迭代规划师
    → 架构师（影响分析）→ 开发 + 测试 + 质量门禁 → 发布
```

适用：已有产品、用户反馈驱动、版本升级。

**迭代流程：**
1. 需求侦察兵主动扫描市场 + 产品体检
2. 反馈分析师收集用户反馈、bug 报告
3. 市场分析师分析竞品动态、市场趋势（主动搜索）
4. 产品经理综合反馈 + 市场分析，定义迭代需求
5. 迭代规划师制定迭代计划（功能清单 + 影响分析 + 回滚方案）
6. 架构师评估变更影响
7. 开发工程师增量实现（向后兼容）
8. 测试经理回归测试
9. 质量门禁审查
10. 发布 + 更新 CHANGELOG

### 自驱动能力

市场分析师、产品经理、需求侦察兵不需要等待输入，它们会：
- **主动搜索** 竞品动态、用户痛点、市场趋势
- **主动发现** 机会和威胁
- **主动提出** 功能建议和行动方案
- **主动输出** 侦察报告和机会清单

你可以直接说"帮我看看市场上有什么新动态"，它们就会自主工作。

### 文档健康检查

每个 Agent 启动时会先检查输入文档是否齐全。如果缺失，会自动从代码和反馈中反推补充：

| Agent | 必需文档 | 缺失时行动 |
|-------|---------|-----------|
| 编排总监 | docs/ 目录 | 创建目录结构 |
| 架构师 | PRD | 从代码反推 PRD 初稿 |
| 开发工程师 | PRD + 架构设计 | 先补文档再开发 |
| 测试经理 | PRD + 架构设计 | 先补文档再测试 |
| 运维工程师 | 架构设计 | 从代码反推架构 |
| 技术文档师 | PRD | 从代码反推 PRD |
| 迭代规划师 | PRD + 反馈分析 | 先收集反馈再规划 |

这样即使项目文档不全，Agent 也能工作——先补全文档，再执行本职任务。

## 快速启动

```
/product-lifecycle [项目名] [一句话描述]
```

示例：`/product-lifecycle myapp "SaaS 协作平台"`

## 支撑文件

### Claude Code Subagent 定义（推荐）

`.claude/agents/` 目录包含正式的 subagent 定义，可直接在 Claude Code 中使用：

| 文件 | 角色 | 工具限制 |
|------|------|---------|
| `.claude/agents/orchestrator.md` | 编排总监 | Read, Glob, Grep, Write, Edit, Bash |
| `.claude/agents/market-analyst.md` | 市场分析师 | Read, Glob, Grep, WebSearch, WebFetch, Write |
| `.claude/agents/architect.md` | 架构师 | Read, Glob, Grep, Write, Edit |
| `.claude/agents/developer.md` | 开发工程师 | Read, Glob, Grep, Write, Edit, Bash |
| `.claude/agents/qa-manager.md` | 测试经理 | Read, Glob, Grep, Write, Edit, Bash |
| `.claude/agents/quality-gatekeeper.md` | 质量门禁 | Read, Glob, Grep, Write, Edit, Bash |

用法：在 Claude Code 中说"使用编排总监 agent"或"启动市场分析师 agent"。

特性：
- **动态上下文注入**：自动注入项目结构、技术栈、Git 状态
- **工具限制**：每个 Agent 只能使用指定的工具
- **模型选择**：默认使用 Sonnet，可按需调整

### Agent Prompts（通用版本）

`agents/` 目录包含 12 个 Agent 的通用 prompt，适用于任何 AI 工具：

| 文件 | 角色 |
|------|------|
| `agents/orchestrator.md` | 编排总监 |
| `agents/market-analyst.md` | 市场分析师 |
| `agents/product-manager.md` | 产品经理 |
| `agents/architect.md` | 架构师 |
| `agents/developer.md` | 开发工程师 |
| `agents/qa-manager.md` | 测试经理 |
| `agents/devops.md` | 运维工程师 |
| `agents/docwriter.md` | 技术文档师 |
| `agents/quality-gatekeeper.md` | 质量门禁 |
| `agents/feedback-analyst.md` | 反馈分析师 |
| `agents/iteration-planner.md` | 迭代规划师 |
| `agents/proactive-scout.md` | 需求侦察兵 |

用法：读取 prompt 文件，替换 `{{PROJECT_NAME}}` 和 `{{PROJECT_DESCRIPTION}}`，传给 Agent 工具。

### 文档模板

`templates/` 目录包含各角色的文档模板：

| 模板 | 用途 |
|------|------|
| `workflow_plan_template.md` | 工作流框架（编排总监用） |
| `market_template.md` | 市场分析报告 |
| `product_template.md` | PRD |
| `architecture_template.md` | 技术设计文档 |
| `developer_template.md` | 开发任务 |
| `qa_template.md` | 测试计划 |
| `devops_template.md` | 运维任务 |
| `docwriter_template.md` | 文档任务 |
| `feedback_template.md` | 反馈分析报告（持续迭代用） |
| `iteration_template.md` | 迭代计划（持续迭代用） |

### 项目检测

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/detect.sh [项目路径]
```

自动识别：技术栈、已有文档、测试覆盖、Git 状态。

### Worked Example

`examples/cloudflow.md` — 虚构项目 CloudFlow 的完整生命周期示例，包含时间线和产出物清单。

## 核心模式

### 12 Agent 角色

| Agent | 职责 | 输入 | 输出 | 模式 |
|-------|------|------|------|------|
| **编排总监** | 制定框架、协调各 Agent、质量把关 | 项目文档 | 工作流框架 + 模板 | A/B |
| **市场分析师** | 竞品、用户画像、定价、GTM | 主动搜索 | 市场分析报告 | A |
| **产品经理** | PRD、用户故事、验收标准 | 主动搜索 | PRD | A |
| **架构师** | 技术设计、API、数据模型 | PRD + 代码现状 | 技术设计文档 | A/B |
| **开发工程师** | 代码实现、单元测试 | PRD + 架构设计 | 代码 + 测试 | A/B |
| **测试经理** | 测试策略、用例、质量门禁 | PRD + 架构设计 | 测试计划 | A/B |
| **运维工程师** | 环境搭建、部署、监控 | 架构设计 + 代码 | 可运行环境 | A |
| **技术文档师** | 用户文档、API 文档、变更日志 | 代码 + PRD | 用户文档 | A/B |
| **质量门禁** | 代码审查、lint 规则、MCP 配置 | 代码 + 测试 | 质量报告 | A/B |
| **需求侦察兵** | 持续监控市场 + 产品体检 | 主动搜索 | 侦察报告 | B |
| **反馈分析师** | 收集用户反馈、bug 报告 | 反馈渠道 | 反馈分析报告 | B |
| **迭代规划师** | 影响分析、迭代计划、版本策略 | 反馈分析 | 迭代计划 | B |

> 模式 A = 从 0 到 1，模式 B = 持续迭代

### 全流程闭环（含反馈循环）

工作流不是单向的，包含反馈循环：
- 测试不通过 → 开发修复 → 重新测试（可能多轮）
- 部署失败 → 运维修复 → 重新部署（可能多轮）
- 质量门禁不通过 → 开发修复 → 重新测试 + 重新部署

详细流程图和依赖关系见 `docs/WORKFLOW_DETAILS.md`。

## 快速参考

### 质量门禁（全流程）

| 阶段 | 门禁 |
|------|------|
| 调研 | ≥3 竞品、≥2 用户画像、数据来源标注 |
| 需求 | 每功能有验收标准、优先级标注、NFR 对齐 |
| 设计 | 技术栈对齐、数据模型有 ER、API 有示例 |
| 实现 | 单元测试通过、静态分析无警告、代码 review 通过 |
| 测试 | P0 用例 100% 通过、无阻塞缺陷 |
| 部署 | 健康检查通过、监控就绪 |
| 文档 | README 准确、API 文档完整、CHANGELOG 更新 |

## 实现

### 在 Claude Code 中执行

使用 `Agent` 工具启动每个角色。关键原则：

1. **编排总监先启动** — 制定 WORKFLOW_PLAN.md，确认模板和门禁
2. **市场分析师 + 产品经理可并行** — 用多个 Agent 工具调用
3. **架构师等 PRD 初稿** — 依赖就绪后再启动
4. **开发、测试、运维、文档可并行** — 都依赖架构设计
5. **质量门禁逐项检查** — 发布前必须全部通过

**在线调研能力：** 市场分析师和产品经理 Agent 必须使用 WebSearch/WebFetch 工具进行在线调研，不能仅依赖项目文档。

### Agent 启动模板

```
你是 [项目名] 的 [角色]。

## 背景
[项目简介]

## 你的任务
1. 读取以下文件获取上下文：
   - [PROJECT]/docs/PRODUCT_PLAN.md
   - Read templates/[角色]_template.md
   - [相关代码文件]

2. [具体任务描述]

3. 输出到指定位置

## 质量要求
[从 WORKFLOW_PLAN 复制对应 Agent 的质量门禁]

## 约束
- 只写入指定目录
- 遵循双仓规范
```

详细的工作规范、编号规则、常见错误见 `docs/WORKFLOW_DETAILS.md`。

## 实际效果

详见 `examples/cloudflow.md` — 虚构项目 CloudFlow 的完整生命周期演示。
