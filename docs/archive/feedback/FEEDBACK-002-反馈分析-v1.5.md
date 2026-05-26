# FB-002 product-lifecycle v1.5 反馈分析报告

| 字段 | 值 |
|------|-----|
| 版本 | v1.0 |
| 作者 | 反馈分析师 |
| 日期 | 2026-05-03 |
| 状态 | 正式发布 |
| 关联文档 | CHANGELOG.md, SKILL.md, CONTEXT-MANAGEMENT.md, FEEDBACK-001 |

---

## 1. 分析概述

### 1.1 分析范围

本次分析覆盖以下内容：

- FEEDBACK-001 中 7 条反馈的 v1.5 修复验证
- Anthropic Claude Code 官方最佳实践文档（code.claude.com/docs）
- Claude Code sub-agents 官方文档
- 多 Agent 协作模式与上下文管理最佳实践

时间范围：v1.5 发布后（2026-05-03）

### 1.2 反馈总量

- 上轮反馈验证：7 条
- 新收集反馈：6 条
- 有效反馈总计：13 条

---

## 2. 上轮反馈修复状态（FEEDBACK-001 → v1.5）

### 2.1 修复状态总览

| ID | 类别 | 问题描述 | v1.5 状态 | 修复说明 |
|----|------|----------|----------|----------|
| FB001 | 架构问题 | 多 Agent 上下文窗口溢出 | ✅ 已解决 | 创建 `docs/CONTEXT-MANAGEMENT.md`，含摘要传递机制、上下文预算（12 个 Agent 各有输入/输出预算）、分层读取策略、紧急压缩策略 |
| FB002 | 体验问题 | Agent 切换背景重复说明 | ✅ 已解决 | v1.4 动态上下文注入 + v1.5 补全 6 个 subagent 定义（`.claude/agents/` 目录），每个 Agent 启动时自动检测项目结构、技术栈、Git 状态 |
| FB003 | 体验问题 | 文档模板过于刚性 | ✅ 已解决 | 模板已标注 `[必填]`/`[可选]` 章节（见 `templates/market_template.md`、`templates/product_template.md`），SKILL.md 添加渐进式采用指引支持精简模式 |
| FB004 | 功能请求 | 缺少 Agent 执行状态可视化 | ✅ 已解决 | `CONTEXT-MANAGEMENT.md` §4.1 定义「项目状态快照」模板，含当前阶段、已完成产出表、关键决策记录、待解决问题表、下游启动条件检查清单 |
| FB005 | Bug | "8 个 Agent" 残留引用 | ✅ 已解决 | v1.2 已修复，v1.3 进一步清理一致性问题 |
| FB006 | 功能请求 | 缺少渐进式采用路径 | ✅ 已解决 | SKILL.md 新增「渐进式采用」章节，定义核心 Agent（4 个）、扩展 Agent（5 个）、自驱动 Agent（3 个）三层结构，支持精简模式启动 |
| FB007 | 体验问题 | Cursor/OpenCode 集成指引不够详细 | ⚠️ 部分解决 | README.md 有基本 Cursor/OpenCode 使用指引，但缺少 Cursor rules 配置示例、OpenCode 详细步骤、常见问题排查 |

### 2.2 修复质量评估

| 维度 | 评分 | 说明 |
|------|------|------|
| 完整性 | 8/10 | 7 条中 6 条完全解决，1 条部分解决 |
| 质量 | 9/10 | CONTEXT-MANAGEMENT.md 内容详实，含模板、预算表、最佳实践 |
| 一致性 | 9/10 | SKILL.md、CHANGELOG.md、模板文件之间保持一致 |
| 可用性 | 8/10 | 渐进式采用指引清晰，但缺少实际使用示例 |

**总体评价：v1.5 对上轮反馈的修复率为 86%（6/7 完全解决），质量优秀。**

---

## 3. 新收集反馈

### 3.1 反馈来源

| 来源 | 类型 | 参考价值 |
|------|------|----------|
| Anthropic Claude Code 官方文档 | 最佳实践 | 高 — 权威来源 |
| Claude Code Sub-agents 文档 | 架构参考 | 高 — 官方推荐模式 |
| Claude Code Best Practices | 工程实践 | 高 — 经过内部验证 |

### 3.2 反馈汇总表

| ID | 类别 | 描述 | 来源 | 频次 | 影响面 | 严重度 | 优先级分 |
|----|------|------|------|------|--------|--------|----------|
| FB008 | 架构问题 | Subagent 配置缺少 model 字段，无法控制成本 | 官方文档 | 中 | 全局 | 一般 | 6 |
| FB009 | 功能请求 | 缺少 Agent 间错误传播与回滚机制 | 官方最佳实践 | 中 | 全局 | 一般 | 6 |
| FB010 | 体验问题 | 文档健康检查仅覆盖"缺失"，未覆盖"质量不达标" | 内部审查 | 中 | 部分 | 一般 | 4 |
| FB011 | 架构问题 | 缺少 CLAUDE.md 分层引用机制 | 官方最佳实践 | 中 | 全局 | 建议 | 6 |
| FB012 | 功能请求 | 缺少 Skill 与 Subagent 的协作规范 | 官方文档 | 中 | 全局 | 建议 | 4 |
| FB013 | 功能请求 | 质量门禁缺少自动化验证手段 | 官方最佳实践 | 中 | 全局 | 建议 | 4 |

**优先级分计算：** 频次(高=3,中=2,低=1) × 影响面(全局=3,部分=2,局部=1)

---

## 4. 新反馈详情

### 4.1 FB008: Subagent 配置缺少 model 字段

- **描述：** 当前 `.claude/agents/` 中的 subagent 定义未指定 `model` 字段。Claude Code 官方文档建议根据任务复杂度选择模型（Haiku 用于简单任务，Sonnet 用于常规任务，Opus 用于复杂推理），以优化成本和性能。
- **来源：** Anthropic Claude Code Sub-agents 文档（https://code.claude.com/docs/en/sub-agents）
- **频次：** 中（每次 Agent 调用都会消耗不必要的 token）
- **影响面：** 全局（影响所有 Agent 的成本效率）
- **优先级分：** 6（频次2 × 影响面3）
- **关键引用：**
  > "Control costs by routing tasks to faster, cheaper models like Haiku"
  > Subagent 配置支持 `model: opus` / `model: sonnet` / `model: haiku` 字段
- **建议处理方式：**
  1. 为每个 subagent 添加 `model` 字段，按任务复杂度分级
  2. 推荐分级：简单任务（质量门禁、文档师）→ Haiku，常规任务（开发、测试）→ Sonnet，复杂推理（架构师、编排总监）→ Opus
  3. 在 SKILL.md 中说明模型选择策略

### 4.2 FB009: 缺少 Agent 间错误传播与回滚机制

- **描述：** 当某个 Agent 执行失败时（如测试不通过、质量门禁不通过），当前框架描述了反馈循环（测试→开发→测试），但缺少明确的错误传播机制和回滚策略。官方最佳实践强调 "Give Claude a way to verify its work" 和 checkpoint/rewind 机制。
- **来源：** Anthropic Claude Code Best Practices（https://code.claude.com/docs/en/best-practices）
- **频次：** 中（多 Agent 协作时 Agent 失败是常见场景）
- **影响面：** 全局（影响工作流的健壮性）
- **优先级分：** 6（频次2 × 影响面3）
- **关键引用：**
  > "Claude performs dramatically better when it can verify its own work"
  > "Every action Claude makes creates a checkpoint. You can restore conversation, code, or both to any previous checkpoint."
- **建议处理方式：**
  1. 在 WORKFLOW_PLAN.md 模板中增加「错误处理」章节
  2. 定义 Agent 失败后的标准流程：记录错误 → 通知编排总监 → 决定重试/回滚/跳过
  3. 引入 checkpoint 概念，每个 Agent 完成后创建状态快照
  4. 在质量门禁中增加「可回滚性检查」

### 4.3 FB010: 文档健康检查仅覆盖"缺失"

- **描述：** 当前文档健康检查机制（SKILL.md「文档健康检查」章节）只检查文档是否存在，未检查文档质量是否达标。例如，PRD 存在但缺少验收标准，架构设计存在但缺少 API 定义。
- **来源：** 内部审查
- **频次：** 中（文档质量问题是常见隐患）
- **影响面：** 部分（主要影响下游 Agent 的输入质量）
- **优先级分：** 4（频次2 × 影响面2）
- **建议处理方式：**
  1. 为每个模板定义「最低质量标准」（Minimum Viable Document）
  2. 健康检查增加质量验证：检查必填章节是否填写、关键字段是否为空
  3. 引入文档质量评分（如：完整性、一致性、可操作性）

### 4.4 FB011: 缺少 CLAUDE.md 分层引用机制

- **描述：** Claude Code 官方支持 CLAUDE.md 的 `@path/to/import` 语法进行分层引用，以及多位置 CLAUDE.md（项目根目录、子目录、用户级）。当前 product-lifecycle 未利用这一机制，所有指引集中在 SKILL.md 中。
- **来源：** Anthropic Claude Code Best Practices
- **频次：** 中（大型项目需要分层管理上下文）
- **影响面：** 全局（影响上下文管理效率）
- **优先级分：** 6（频次2 × 影响面3）
- **关键引用：**
  > "CLAUDE.md files can import additional files using `@path/to/import` syntax"
  > "You can place CLAUDE.md files in several locations: Home folder, Project root, Child directories"
- **建议处理方式：**
  1. 利用 `@` 引用语法，在 SKILL.md 中引用而非内联详细内容
  2. 为 monorepo 场景提供子目录 CLAUDE.md 指引
  3. 提供用户级 `~/.claude/CLAUDE.md` 配置示例

### 4.5 FB012: 缺少 Skill 与 Subagent 的协作规范

- **描述：** Claude Code 区分 Skill（可复用工作流）和 Subagent（独立上下文的专用助手）。当前 product-lifecycle 同时定义了 SKILL.md 和 `.claude/agents/`，但未明确说明两者的协作关系和使用边界。
- **来源：** Anthropic Claude Code Sub-agents 文档
- **频次：** 中（用户可能混淆两者用途）
- **影响面：** 全局（影响用户对框架的理解）
- **优先级分：** 4（频次2 × 影响面2）
- **关键引用：**
  > "Skills extend Claude's knowledge with information specific to your project"
  > "Subagents run in their own context window with a custom system prompt, specific tool access"
- **建议处理方式：**
  1. 在 SKILL.md 中增加「Skill vs Subagent」说明
  2. 明确：SKILL.md = 入口编排 + 知识注入，Subagent = 隔离执行 + 工具限制
  3. 提供协作流程图

### 4.6 FB013: 质量门禁缺少自动化验证手段

- **描述：** SKILL.md 定义了 7 个阶段的质量门禁（调研、需求、设计、实现、测试、部署、文档），但主要依赖人工审查。Claude Code 支持 Hooks（自动化脚本）和验证工具，可用于自动化质量检查。
- **来源：** Anthropic Claude Code Best Practices
- **频次：** 中（人工审查效率低且容易遗漏）
- **影响面：** 全局（影响质量保障的可靠性）
- **优先级分：** 4（频次2 × 影响面2）
- **关键引用：**
  > "Hooks run scripts automatically at specific points in Claude's workflow"
  > "Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and guarantee the action happens"
- **建议处理方式：**
  1. 为关键质量门禁提供 Hooks 配置示例（如：代码审查后自动运行 lint）
  2. 提供 `.claude/settings.json` 中的 hooks 配置模板
  3. 区分「可自动化门禁」和「需人工审查门禁」

---

## 5. 竞品对比更新

| 维度 | product-lifecycle v1.5 | Cursor rules | Claude Code CLAUDE.md | 差距分析 |
|------|------------------------|-------------|----------------------|----------|
| 上下文管理 | ✅ 已建立摘要传递 + 上下文预算 | 持久化 rules 文件 | 自动加载 CLAUDE.md | **差距缩小**：v1.5 补齐了上下文管理文档 |
| 学习曲线 | ✅ 渐进式采用（4+5+3 分层） | 平缓 | 平缓 | **差距缩小**：核心 Agent 子集降低入门门槛 |
| 工具集成 | 通用（支持多工具） | 专属 Cursor | 专属 Claude Code | **领先**：工具无关设计 |
| 流程完整性 | 端到端闭环 | 无流程定义 | 无流程定义 | **领先**：完整生命周期管理 |
| 可视化 | ✅ 项目状态快照模板 | IDE 集成 | CLI 输出 | **差距缩小**：状态快照弥补部分可视化需求 |
| Subagent 成本控制 | ❌ 缺少 model 字段 | N/A | 支持 model 选择 | **落后**：未利用模型分级降低成本 |
| 错误恢复 | ⚠️ 有反馈循环但无 checkpoint | N/A | checkpoint + rewind | **落后**：缺少显式回滚机制 |

---

## 6. 迭代建议（v1.6 方向）

### 6.1 立即修复

无阻塞性 Bug。所有上轮反馈的核心问题已在 v1.5 解决。

### 6.2 下个迭代（v1.6）

| 优先级 | 改进项 | 预期收益 | 工作量 | 对应反馈 |
|--------|--------|----------|--------|----------|
| P0 | Subagent 添加 model 字段 | 降低 30-50% token 成本 | 小 | FB008 |
| P0 | Agent 错误传播与回滚机制 | 提升工作流健壮性 | 中 | FB009 |
| P1 | 文档质量验证（超越"缺失检查"） | 提升下游 Agent 输入质量 | 小 | FB010 |
| P1 | SKILL.md 利用 @引用语法分层 | 减少 SKILL.md 体积，提升可维护性 | 小 | FB011 |
| P2 | Skill vs Subagent 协作规范 | 降低用户理解成本 | 小 | FB012 |
| P2 | 质量门禁 Hooks 配置示例 | 自动化质量保障 | 中 | FB013 |

### 6.3 Backlog

| 功能 | 说明 | 优先级 |
|------|------|--------|
| Agent Teams 协作模式 | 利用 Claude Code Agent Teams 实现多 Agent 并行协调 | 低 |
| Cursor rules 自动生成 | 从 SKILL.md 自动生成 .cursorrules 文件 | 低 |
| Agent 性能指标 Dashboard | 追踪每个 Agent 的 token 消耗、执行时间、成功率 | 低 |
| 多项目并行支持 | 一套 Agent 同时管理多个项目 | 低 |

---

## 7. 参考资料

| 来源 | 链接 | 反馈类型 |
|------|------|----------|
| Claude Code Best Practices | https://code.claude.com/docs/en/best-practices | 最佳实践 |
| Claude Code Sub-agents | https://code.claude.com/docs/en/sub-agents | 架构参考 |
| Claude Code Overview | https://code.claude.com/docs/en/overview | 产品特性 |
| FEEDBACK-001 | docs/FEEDBACK-001-反馈分析.md | 上轮反馈 |
| CONTEXT-MANAGEMENT.md | docs/CONTEXT-MANAGEMENT.md | v1.5 新增 |

---

## 8. 修订记录

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v1.0 | 2026-05-03 | 反馈分析师 | 初稿，基于 v1.5 现状分析 + 官方最佳实践对比 |
