---
name: product-lifecycle
description: 20-Agent 产品开发全流程编排框架。仅在用户明确说「/product-lifecycle」「启动产品生命周期」「跑全流程」「全量迭代」时激活；不要为普通编码、单一功能修改或 bug 修复自动触发。小任务请用 writing-plans 或 systematic-debugging。
when_to_use: "/product-lifecycle, /pl, 启动产品生命周期, 跑全流程迭代, 全量产品迭代, run product lifecycle, start full product workflow, orchestrate all agents, 编排总监开始工作, 20个Agent"
argument-hint: "[项目名] [一句话描述]"
allowed-tools: Agent WebSearch WebFetch Read Write Edit Glob Grep Bash TodoWrite
---

# 多 Agent 产品开发全流程

## 概述

通过 20 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。不是只生成文档——是从需求到可运行产品的端到端流程。

**角色分层：**

- **协调层（2）**：编排总监、项目经理
- **自驱动层（3）**：需求侦察兵、市场分析师、产品经理
- **设计层（3）**：UI/UX 设计师、架构师、数据库管理员
- **执行层（6）**：开发工程师（通用）、前端工程师、后端工程师、测试经理、运维工程师、技术文档师
- **反馈层（3）**：数据分析师、反馈分析师、迭代规划师
- **质量层（3）**：安全工程师、代码审查员、质量门禁

## 启动前可选：模型分级配置

**默认无需配置**：所有 Agent 自动继承用户当前模型，最稳定。

如果你想按角色复杂度分级配置（用最强模型给 orchestrator/project-manager/architect，平衡模型给其余 17 个角色，预计省钱 30-40%），运行：

```bash
# macOS / Linux
bash scripts/configure-models.sh

# Windows PowerShell
.\scripts\configure-models.ps1
```

脚本会自动探测可用模型、显示当前配置、给出推荐方案，然后等你选择。详见 [docs/04-reference/MODEL-CONFIG.md](docs/04-reference/MODEL-CONFIG.md)。

---

## Phase 0：确认范围（必须在派发任何 Agent 之前执行）

**不要跳过此步骤。** 在读取任何角色文件或调用 Agent 工具之前，先问用户：

> 我可以启动 product-lifecycle 工作流。**请先确认执行范围：**
>
> | 模式 | 说明 | 预计工具调用 |
> |------|------|------------|
> | **A. 完整流程** | 20 Agent 全量运行（模式 A 或 B）| ~80-140 次 |
> | **B. 精简模式** | 编排 + 指定 2-4 个角色 | ~20-40 次 |
> | **C. 单角色** | 只运行 1 个 Agent | ~8-15 次 |
>
> 你想要哪种模式？如果不确定，推荐先用 **B 精简模式** 并告诉我需要哪些角色。

收到确认后，再继续执行后续步骤。**若用户未明确选择，默认使用精简模式（B），不自动启动全量流程。**

---

## Agent 调用示例

**在完成 Phase 0 确认后**，你作为编排总监按用户选择的范围派发子代理（精简模式只派发用户指定的角色，不要全量跑）。

配置完成后，这样调用第一个子代理：

```
Agent(
  subagent_type: "",
  description: "需求侦察兵：产品体检",
  prompt: "读取 ~/.claude/skills/product-lifecycle/agents/proactive-scout.md，按照里面的指引对当前项目执行产品体检和市场扫描。产出到 docs/iterations/current/scout/SCOUT-xxx-侦察报告.md。"
)
```

然后按模式 B 的顺序依次派发：反馈分析师 → 市场分析师 → 产品经理 → 迭代规划师 → 架构师 → 开发工程师 → 测试经理 → 质量门禁。

**子代理模型继承用户当前配置，无需指定。**

## 各工具用法（分文档）

工具相关安装、命令与执行细节已拆出，便于单独维护；**需要时再 Read 对应文件**。


| 工具                        | 文档                                                                                                                   | 何时读取                                                                                          |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Harness 总览**          | `[docs/02-tools/HARNESS.md](docs/02-tools/HARNESS.md)` — 什么是 Harness、Claude Code/Cursor/其他 IDE 支持级别、完整体验要装什么 | 换 IDE、问「skill 要不要加 harness」、评估环境是否配齐时 |
| **Cursor**                | `[docs/02-tools/SKILL-CURSOR.md](docs/02-tools/SKILL-CURSOR.md)` — PACKAGE_ROOT、`**/create-subagent` 与 CC 对齐的多角色编排**、全局安装、与业务工作区并用、Skill vs Subagent 辨析、Hooks 集成     | 在 Cursor 中首次使用本技能包时；需要理解 Skill/Subagent 关系或配置 Hooks 时                                     |
| **Claude Code**           | `[docs/02-tools/SKILL-CLAUDE-CODE.md](docs/02-tools/SKILL-CLAUDE-CODE.md)` — `/product-lifecycle`、Subagent、Agent 工具原则、启动模板、`detect.sh` | 在 Claude Code 中首次使用时；需要了解 slash 命令或 Agent 工具策略时                                            |
| **OpenCode / Codex / 其他** | `[docs/02-tools/SKILL-OTHER-TOOLS.md](docs/02-tools/SKILL-OTHER-TOOLS.md)` — 读 `agents/` 与 `templates/`                                | 使用 Cursor/Claude Code 以外的工具时；只需读取 `agents/` 与 `templates/` 即可                                  |


**角色文件与模板清单、20 角色产出表、质量门禁速查**：`[docs/04-reference/SKILL-ASSETS.md](docs/04-reference/SKILL-ASSETS.md)`

## 何时使用

- 新产品/项目启动，需要完整生命周期管理
- 进入新 Phase，需要从需求到部署的全流程
- 产品需要持续迭代改进
- 团队需要标准化的开发流程

**不适用：**

- 小功能迭代（直接用 writing-plans）
- Bug 修复（用 systematic-debugging）
- 纯文档生成（无代码产出）

**国际化与可访问性：**

- 支持中文和英文项目，Agent prompt 自动适配语言（详见 `docs/INTERNATIONALIZATION.md`）
- 文档输出遵循可访问性最佳实践：正确标题层级、描述性链接、颜色无关的状态标识（详见 `docs/ACCESSIBILITY.md`）

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


| Agent | 必需文档       | 缺失时行动        | 质量不达标时         |
| ----- | ---------- | ------------ | -------------- |
| 编排总监  | docs/ 目录   | 创建目录结构       | 重新制定框架        |
| 架构师   | PRD        | 从代码反推 PRD 初稿 | 重新评审设计方案      |
| 开发工程师 | PRD + 架构设计 | 先补文档再开发      | 代码审查+重构       |
| 测试经理  | PRD + 架构设计 | 先补文档再测试      | 补充测试用例        |
| 运维工程师 | 架构设计       | 从代码反推架构      | 重新验证部署        |
| 技术文档师 | PRD        | 从代码反推 PRD    | 重写不达标部分       |
| 迭代规划师 | PRD + 反馈分析 | 先收集反馈再规划     | 重新评估优先级       |


这样即使项目文档不全，Agent 也能工作——先补全文档，再执行本职任务。

## 渐进式采用

不需要一次使用全部 20 个 Agent。根据项目规模选择合适的子集：

### 核心 Agent（最小可用集）


| Agent | 职责             | 何时使用              |
| ----- | -------------- | ----------------- |
| 编排总监  | 制定框架、协调各 Agent | **必选** — 每次都从这里开始 |
| 开发工程师 | 代码实现           | **必选** — 有代码要写时   |
| 测试经理  | 测试策略和执行        | **必选** — 验证实现时    |
| 质量门禁  | 代码审查           | **必选** — 发布前审查    |
| 代码审查员 | 代码质量、安全性、可维护性审查 | 按需 — 深度代码审查时    |


### 扩展 Agent（按需添加）


| Agent | 职责       | 何时使用        |
| ----- | -------- | ----------- |
| 市场分析师 | 竞品、用户画像  | 需要市场调研时     |
| 产品经理  | PRD、用户故事 | 需要定义需求时     |
| 架构师   | 技术设计     | 复杂系统需要架构设计时 |
| 运维工程师 | 部署、监控    | 需要容器化或部署时   |
| 技术文档师 | 用户文档     | 需要正式文档时     |
| 数据库管理员 | 数据库架构、SQL优化 | 项目涉及 SQL 时 |


### 自驱动 Agent（持续迭代时使用）


| Agent | 职责   | 何时使用      |
| ----- | ---- | --------- |
| 需求侦察兵 | 市场监控 | 产品上线后持续监控 |
| 反馈分析师 | 用户反馈 | 有用户反馈渠道时  |
| 迭代规划师 | 迭代计划 | 规划下个版本时   |


### 决策树

根据项目规模选择 Agent 子集：

- **原型/MVP**（1-2 天）→ 编排总监 + 开发（通用） + 测试（3 个）
- **小型项目**（1-2 周）→ 核心 4 个 + 架构师 + UI 设计师（6 个）
- **中型项目**（1-2 月）→ 核心 4 个 + 市场 + 产品 + UI 设计师 + 架构师（8 个）
- **大型项目**（3 月+）→ 全部 20 个 Agent；developer 拆分为 frontend + backend，加上 项目经理 + 安全工程师 + 数据分析师

**启动命令与精简模式**（Claude Code）：见 `[docs/02-tools/SKILL-CLAUDE-CODE.md](docs/02-tools/SKILL-CLAUDE-CODE.md)`。

## 核心模式与闭环

工作流不是单向的，包含反馈循环：

- 测试不通过 → 开发修复 → 重新测试（可能多轮）
- 部署失败 → 运维修复 → 重新部署（可能多轮）
- 质量门禁不通过 → 开发修复 → 重新测试 + 重新部署

**各角色文件、模板、20 角色产出表、质量门禁表**：`[docs/04-reference/SKILL-ASSETS.md](docs/04-reference/SKILL-ASSETS.md)`

**流程图、依赖与编号规则**：`[docs/03-workflow/WORKFLOW_DETAILS.md](docs/03-workflow/WORKFLOW_DETAILS.md)`

**安全指南**：`[docs/SECURITY.md](docs/SECURITY.md)` — 安全检查工具集成、Agent 输出安全审查、最佳实践

**上下文管理：** 多 Agent 协作时的上下文预算、摘要传递、信息交接规范见 `docs/CONTEXT-MANAGEMENT.md`。

## 实际效果

- `[examples/cloudflow.md](examples/cloudflow.md)` — CloudFlow 完整生命周期演示（模式 A，从 0 到 1）
- `[examples/saas-iteration.md](examples/saas-iteration.md)` — SaaS 产品持续迭代演示（模式 B）
- `[examples/cli-tool.md](examples/cli-tool.md)` — CLI 工具渐进式采用演示（4 核心 Agent）
- `[examples/microservice.md](examples/microservice.md)` — 微服务项目演示（模式 A，含代码审查）

## 进阶资源

- `[docs/01-getting-started/DECISION-TREE.md](docs/01-getting-started/DECISION-TREE.md)` — Agent 选择决策树，帮你快速选择合适的 Agent 组合
- `[docs/01-getting-started/FAQ.md](docs/01-getting-started/FAQ.md)` — 常见问题解答，覆盖使用、技术、工作流、集成等场景
- `[docs/01-getting-started/QUICK-START.md](docs/01-getting-started/QUICK-START.md)` — 快速入门指南，包含进阶用法（自定义 Agent、CI/CD 集成、多项目管理）
- `[docs/CONTEXT-MANAGEMENT.md](docs/CONTEXT-MANAGEMENT.md)` — 上下文管理策略，解决 Agent 输出过多/过少问题
- `[docs/04-reference/DOC-MAP.md](docs/04-reference/DOC-MAP.md)` — 文档导航地图，帮你快速找到需要的文档

## 快速入门

首次使用？请阅读 `docs/01-getting-started/QUICK-START.md` — 30 秒理解框架，5 分钟完成首次体验。