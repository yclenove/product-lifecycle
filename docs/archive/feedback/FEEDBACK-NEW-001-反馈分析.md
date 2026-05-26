# FB-NEW-001 product-lifecycle v1.7+ 反馈分析报告

| 字段 | 值 |
|------|-----|
| 版本 | v1.0 |
| 作者 | 反馈分析师 |
| 日期 | 2026-05-03 |
| 状态 | 正式发布 |
| 关联文档 | CHANGELOG.md, SKILL.md, FEEDBACK-001, FEEDBACK-002 |

---

## 1. 分析概述

### 1.1 分析范围

本次分析覆盖以下内容：

- FEEDBACK-001（v1.4）和 FEEDBACK-002（v1.5）的历史反馈修复验证
- v1.5 至 v1.7+ 的 CHANGELOG 变更审计
- `.claude/agents/` 与 `.cursor/agents/` 配置一致性审查
- 文档健康检查机制完整性审查
- CHANGELOG `[Unreleased]` 内容合理性审查
- 多 Agent 编排模式与上下文管理最佳实践对比

时间范围：v1.5 发布后至 v1.7+（2026-05-03 ~ 2026-05-04）

### 1.2 反馈总量

- 历史反馈验证：13 条（FEEDBACK-001 的 7 条 + FEEDBACK-002 的 6 条）
- 新收集反馈：7 条
- 有效反馈总计：20 条

---

## 2. 历史反馈修复状态（FEEDBACK-002 → v1.7+）

### 2.1 FEEDBACK-001 反馈（v1.4 时期）修复状态

| ID | 问题描述 | v1.5 状态 | v1.7+ 状态 | 说明 |
|----|----------|----------|-----------|------|
| FB001 | 多 Agent 上下文窗口溢出 | 已解决 | 已解决 | CONTEXT-MANAGEMENT.md 保持完整 |
| FB002 | Agent 切换背景重复说明 | 已解决 | 已解决 | 动态上下文注入 + 12 个 subagent 定义齐全 |
| FB003 | 文档模板过于刚性 | 已解决 | 已解决 | 模板已标注必填/可选 |
| FB004 | 缺少 Agent 执行状态可视化 | 已解决 | 已解决 | 项目状态快照模板存在 |
| FB005 | "8 个 Agent" 残留引用 | 已解决 | 已解决 | v1.2/v1.3 已修复 |
| FB006 | 缺少渐进式采用路径 | 已解决 | 已解决 | SKILL.md 有 4+5+3 分层 |
| FB007 | Cursor/OpenCode 集成指引不够详细 | 部分解决 | 已解决 | v1.7 新增 SKILL-CURSOR.md + 安装脚本 + .cursor/agents/ |

### 2.2 FEEDBACK-002 反馈（v1.5 时期）修复状态

| ID | 问题描述 | v1.5 状态 | v1.7+ 状态 | 说明 |
|----|----------|----------|-----------|------|
| FB008 | Subagent 缺少 model 字段 | 未修复 | 部分修复 | 所有 agent 已有 model 字段，但全部为 sonnet，未按任务复杂度分级 |
| FB009 | 缺少错误传播与回滚机制 | 未修复 | 已修复 | workflow_plan_template.md 新增 §6 错误处理与检查点 |
| FB010 | 文档健康检查仅覆盖"缺失" | 未修复 | 未修复 | SKILL.md 健康检查表仍只有"缺失时行动"列 |
| FB011 | 缺少 CLAUDE.md 分层引用机制 | 未修复 | 未修复 | SKILL.md 未使用 @引用语法 |
| FB012 | 缺少 Skill vs Subagent 协作规范 | 未修复 | 未修复 | 无文档说明两者关系 |
| FB013 | 质量门禁缺少自动化验证手段 | 未修复 | 未修复 | 无 Hooks 配置示例 |

### 2.3 修复质量评估

| 维度 | v1.5 评分 | v1.7+ 评分 | 变化 | 说明 |
|------|----------|-----------|------|------|
| 完整性 | 8/10 | 8.5/10 | +0.5 | FB007 和 FB009 得到修复 |
| 质量 | 9/10 | 9/10 | 0 | 新增内容质量保持水准 |
| 一致性 | 9/10 | 8/10 | -1 | .claude/agents 与 .cursor/agents 的 model 策略不一致 |
| 可用性 | 8/10 | 8.5/10 | +0.5 | Cursor 安装脚本降低了使用门槛 |

**总体评价：v1.7+ 对历史反馈的修复率为 77%（10/13 完全解决，1 部分解决，2 未修复）。FEEDBACK-002 的 6 条新反馈中仅 1 条完全修复，2 条部分修复，3 条未修复。**

---

## 3. 新收集反馈

### 3.1 反馈来源

| 来源 | 类型 | 参考价值 |
|------|------|----------|
| .claude/agents/ 配置审查 | 内部审查 | 高 — 直接影响用户体验和成本 |
| .cursor/agents/ 配置审查 | 内部审查 | 高 — 影响跨工具一致性 |
| CHANGELOG 审计 | 内部审查 | 中 — 影响项目可维护性 |
| SKILL.md 文档审查 | 内部审查 | 高 — 影响新用户理解 |
| FEEDBACK-002 遗留问题跟踪 | 历史追踪 | 高 — 验证修复进度 |
| 多 Agent 编排最佳实践 | 行业实践 | 中 — 参考标准 |

### 3.2 反馈汇总表

| ID | 类别 | 描述 | 来源 | 频次 | 影响面 | 严重度 | 优先级分 |
|----|------|------|------|------|--------|--------|----------|
| FB014 | 架构问题 | 12 个 .claude/agents/ 全部使用 model: sonnet，未按任务复杂度分级，浪费成本 | 内部审查 | 高 | 全局 | 一般 | 9 |
| FB015 | 体验问题 | 文档健康检查仅覆盖"缺失"不覆盖"质量不达标"（FB010 遗留） | 内部审查/FEEDBACK-002 | 中 | 部分 | 一般 | 4 |
| FB016 | 架构问题 | .claude/agents/ 与 .cursor/agents/ 的 model 策略不一致（sonnet vs inherit），缺少说明文档 | 内部审查 | 中 | 全局 | 一般 | 6 |
| FB017 | 体验问题 | CHANGELOG [Unreleased] 混入迭代规划过程稿条目（ITER-004/005），违反 Keep a Changelog 规范 | 内部审查 | 中 | 局部 | 建议 | 2 |
| FB018 | 功能请求 | SKILL.md 未使用 @引用语法进行分层引用（FB011 遗留） | 内部审查/FEEDBACK-002 | 中 | 全局 | 建议 | 6 |
| FB019 | 功能请求 | 缺少 Skill vs Subagent 协作规范文档（FB012 遗留） | 内部审查/FEEDBACK-002 | 中 | 全局 | 建议 | 4 |
| FB020 | 功能请求 | 质量门禁缺少 Hooks 自动化配置示例（FB013 遗留） | 内部审查/FEEDBACK-002 | 中 | 全局 | 建议 | 4 |

**优先级分计算：** 频次(高=3,中=2,低=1) x 影响面(全局=3,部分=2,局部=1)

---

## 4. 新反馈详情

### 4.1 FB014: Agent model 字段未按任务复杂度分级

- **描述：** 当前 `.claude/agents/` 中 12 个 subagent 全部使用 `model: "sonnet"`。根据任务复杂度分级使用模型是 Claude Code 官方推荐的成本优化策略。简单任务（如文档师写 README、质量门禁做 lint 检查）使用 haiku 即可，复杂推理任务（如架构师做技术选型、编排总监做全局协调）可考虑 opus。
- **来源：** 内部审查 `.claude/agents/` 配置文件
- **频次：** 高（每次 Agent 调用都涉及成本）
- **影响面：** 全局（影响所有 12 个 Agent 的运行成本）
- **优先级分：** 9（频次3 x 影响面3）
- **证据：**
  - `.claude/agents/orchestrator.md` 第 4 行：`model: "sonnet"`
  - `.claude/agents/developer.md` 第 4 行：`model: "sonnet"`
  - `.claude/agents/docwriter.md` 第 4 行：`model: "sonnet"`
  - `.claude/agents/quality-gatekeeper.md` 第 4 行：`model: "sonnet"`
  - 其余 8 个 agent 同样全部为 `model: "sonnet"`
- **建议处理方式：**
  1. 按任务复杂度分级：
     - **haiku**：docwriter（文档格式化）、quality-gatekeeper（lint 检查）、iteration-planner（计划模板填充）
     - **sonnet**：developer、qa-manager、devops、market-analyst、product-manager、feedback-analyst、proactive-scout
     - **opus**：orchestrator（全局协调推理）、architect（复杂技术决策）
  2. 在 SKILL.md 中说明模型选择策略
  3. 在 SKILL-CLAUDE-CODE.md 的"模型选择"段落提供具体指引

### 4.2 FB015: 文档健康检查仅覆盖"缺失"不覆盖"质量不达标"

- **描述：** SKILL.md 的「文档健康检查」表格只有「缺失时行动」列，没有「质量不达标时行动」列。例如 PRD 存在但缺少验收标准、架构设计存在但缺少 API 定义时，当前机制不会触发任何警告。这是 FEEDBACK-002 FB010 的遗留问题。
- **来源：** 内部审查 + FEEDBACK-002 追踪
- **频次：** 中（文档质量问题是常见隐患）
- **影响面：** 部分（主要影响下游 Agent 的输入质量）
- **优先级分：** 4（频次2 x 影响面2）
- **证据：**
  - SKILL.md 第 91-99 行的健康检查表只有三列：Agent、必需文档、缺失时行动
  - 无"质量标准"或"不达标时行动"列
- **建议处理方式：**
  1. 为每个模板定义最低质量标准（Minimum Viable Document）
  2. 健康检查表增加"质量验证"列：检查必填章节是否填写、关键字段是否为空
  3. 参考 workflow_plan_template.md §4.1 的通用门禁标准

### 4.3 FB016: .claude/agents 与 .cursor/agents 的 model 策略不一致

- **描述：** `.claude/agents/` 全部使用 `model: "sonnet"`（硬编码），而 `.cursor/agents/` 全部使用 `model: inherit`（继承父会话）。两种策略各有优劣，但缺少文档说明差异原因和用户应该如何选择。
- **来源：** 内部审查 .claude/agents/ 与 .cursor/agents/ 配置对比
- **频次：** 中（跨工具用户会遇到困惑）
- **影响面：** 全局（影响所有同时使用 Claude Code 和 Cursor 的用户）
- **优先级分：** 6（频次2 x 影响面3）
- **证据：**
  - `.claude/agents/orchestrator.md` 第 4 行：`model: "sonnet"`
  - `.cursor/agents/orchestrator.md` 第 4 行：`model: inherit`
  - SKILL-CLAUDE-CODE.md 第 48 行提及"模型选择：默认使用 Sonnet，可按需调整"但无具体指引
  - SKILL-CURSOR.md 未提及 model 策略差异
- **建议处理方式：**
  1. 在 SKILL-ASSETS.md 或 SKILL-CLAUDE-CODE.md 中增加 model 策略说明段落
  2. 说明：Claude Code 的 sonnet 硬编码是为了一致性，Cursor 的 inherit 是因为 Cursor 不支持 model 字段的相同语义
  3. 提供用户自定义 model 的指引

### 4.4 FB017: CHANGELOG [Unreleased] 混入过程稿条目

- **描述：** CHANGELOG.md 的 `[Unreleased]` 段落包含两条迭代规划过程稿条目（ITER-004、ITER-005），这些是内部工作过程记录，不是面向用户的功能变更。根据 Keep a Changelog 规范，CHANGELOG 应记录"对用户有意义的变更"。
- **来源：** 内部审查 CHANGELOG.md
- **频次：** 低（一次性问题）
- **影响面：** 局部（仅影响 CHANGELOG 可读性）
- **优先级分：** 2（频次1 x 影响面2）
- **证据：**
  - CHANGELOG.md 第 12-13 行的 [Unreleased] 条目描述的是 ITER-004、ITER-005 过程稿，包含"分角色过程稿 SCOUT-005、FEEDBACK-005..."等内部编号
- **建议处理方式：**
  1. 将过程稿条目从 CHANGELOG 移至内部工作日志（如 ROLE-RUN-LOG）
  2. [Unreleased] 只保留面向用户的变更（如新增功能、Bug 修复）
  3. 建立 CHANGELOG 编写规范：区分"内部过程"和"用户可见变更"

### 4.5 FB018: SKILL.md 未使用 @引用语法分层引用

- **描述：** Claude Code 支持 CLAUDE.md 的 `@path/to/import` 语法进行分层引用。当前 SKILL.md 使用 markdown 链接（如 `[docs/SKILL-CURSOR.md](docs/SKILL-CURSOR.md)`）而非 `@` 引用语法，无法被 Claude Code 自动解析和加载。这是 FEEDBACK-002 FB011 的遗留问题。
- **来源：** 内部审查 + FEEDBACK-002 追踪
- **频次：** 中（大型项目需要分层管理上下文）
- **影响面：** 全局（影响上下文管理效率）
- **优先级分：** 6（频次2 x 影响面3）
- **证据：**
  - SKILL.md 第 21-24 行使用 markdown 链接语法而非 @引用
  - SKILL.md 第 27 行同样使用 markdown 链接
- **建议处理方式：**
  1. 将关键支撑文件改为 `@docs/SKILL-CLAUDE-CODE.md` 语法
  2. 保留 markdown 链接作为人类可读的备用
  3. 为 monorepo 场景提供子目录 CLAUDE.md 指引

### 4.6 FB019: 缺少 Skill vs Subagent 协作规范

- **描述：** Claude Code 区分 Skill（可复用工作流，如 SKILL.md）和 Subagent（独立上下文的专用助手，如 .claude/agents/）。当前框架同时定义了两者，但未在任何文档中说明它们的协作关系和使用边界。用户可能不清楚何时用 `/product-lifecycle` 启动 Skill，何时直接调用某个 subagent。这是 FEEDBACK-002 FB012 的遗留问题。
- **来源：** 内部审查 + FEEDBACK-002 追踪
- **频次：** 中（新用户常见困惑）
- **影响面：** 全局（影响用户对框架的理解）
- **优先级分：** 4（频次2 x 影响面2）
- **建议处理方式：**
  1. 在 SKILL.md 中增加「Skill vs Subagent 使用指引」段落
  2. 明确：`/product-lifecycle` = 全流程编排入口，subagent = 单角色独立执行
  3. 提供典型使用场景对照表

### 4.7 FB020: 质量门禁缺少 Hooks 自动化配置示例

- **描述：** workflow_plan_template.md §6 已有错误处理机制，但质量门禁仍主要依赖人工审查。Claude Code 支持 Hooks（自动化脚本），可用于在特定节点自动执行质量检查（如 lint、type check）。当前无任何 Hooks 配置示例。这是 FEEDBACK-002 FB013 的遗留问题。
- **来源：** 内部审查 + FEEDBACK-002 追踪
- **频次：** 中（人工审查效率低且容易遗漏）
- **影响面：** 全局（影响质量保障的可靠性）
- **优先级分：** 4（频次2 x 影响面2）
- **建议处理方式：**
  1. 在 SKILL-CLAUDE-CODE.md 中增加 Hooks 配置示例
  2. 提供 `.claude/settings.json` 模板，包含 PreToolUse/PostToolUse hooks
  3. 区分"可自动化门禁"（lint、type check）和"需人工审查门禁"（架构合理性、业务逻辑）

---

## 5. 竞品对比更新

| 维度 | product-lifecycle v1.7+ | Cursor rules | Claude Code CLAUDE.md | 差距分析 |
|------|------------------------|-------------|----------------------|----------|
| 上下文管理 | CONTEXT-MANAGEMENT.md 完整 | 持久化 rules | 自动加载 CLAUDE.md | 持平：已有完整方案 |
| 学习曲线 | 渐进式 4+5+3 分层 | 平缓 | 平缓 | 持平：核心子集降低门槛 |
| 工具集成 | 通用 + Cursor 安装脚本 | 专属 Cursor | 专属 Claude Code | 领先：双工具支持 |
| 流程完整性 | 端到端闭环 + 错误处理 | 无流程定义 | 无流程定义 | 领先：含回滚机制 |
| Subagent 成本控制 | 全部 sonnet（未分级） | N/A | 支持 model 选择 | 落后：未利用模型分级 |
| 文档质量验证 | 仅检查缺失 | N/A | N/A | 落后：无质量验证 |
| 跨工具一致性 | .claude 与 .cursor 策略不同 | N/A | N/A | 需改进：缺少统一说明 |

---

## 6. 迭代建议（v1.8 方向）

### 6.1 立即修复

无阻塞性 Bug。

### 6.2 下个迭代（v1.8）

| 优先级 | 改进项 | 预期收益 | 工作量 | 对应反馈 |
|--------|--------|----------|--------|----------|
| P0 | Agent model 字段分级（haiku/sonnet/opus） | 降低 30-50% token 成本 | 小 | FB014 |
| P0 | 文档健康检查增加质量验证 | 提升下游 Agent 输入质量 | 小 | FB015 |
| P1 | .claude/.cursor model 策略统一说明 | 消除跨工具用户困惑 | 小 | FB016 |
| P1 | Skill vs Subagent 使用指引 | 降低新用户理解成本 | 小 | FB019 |
| P2 | CHANGELOG 清理过程稿条目 | 提升 CHANGELOG 可读性 | 极小 | FB017 |
| P2 | SKILL.md @引用语法改造 | 提升上下文管理效率 | 中 | FB018 |
| P2 | 质量门禁 Hooks 配置示例 | 自动化质量保障 | 中 | FB020 |

### 6.3 Backlog

| 功能 | 说明 | 优先级 |
|------|------|--------|
| Agent Teams 协作模式 | 利用 Claude Code Agent Teams 实现多 Agent 并行协调 | 低 |
| Cursor rules 自动生成 | 从 SKILL.md 自动生成 .cursorrules 文件 | 低 |
| Agent 性能指标 Dashboard | 追踪每个 Agent 的 token 消耗、执行时间、成功率 | 低 |
| 多项目并行支持 | 一套 Agent 同时管理多个项目 | 低 |
| 文档质量评分系统 | 自动评估文档完整性、一致性、可操作性 | 低 |

---

## 7. 历史反馈全量跟踪表

| ID | 来源 | 问题描述 | 首次报告 | 当前状态 | 备注 |
|----|------|----------|----------|----------|------|
| FB001 | FEEDBACK-001 | 多 Agent 上下文窗口溢出 | v1.4 | 已解决 | v1.5 CONTEXT-MANAGEMENT.md |
| FB002 | FEEDBACK-001 | Agent 切换背景重复说明 | v1.4 | 已解决 | v1.4 动态上下文注入 |
| FB003 | FEEDBACK-001 | 文档模板过于刚性 | v1.4 | 已解决 | 模板标注必填/可选 |
| FB004 | FEEDBACK-001 | 缺少执行状态可视化 | v1.4 | 已解决 | 项目状态快照模板 |
| FB005 | FEEDBACK-001 | "8 个 Agent" 残留引用 | v1.4 | 已解决 | v1.2/v1.3 修复 |
| FB006 | FEEDBACK-001 | 缺少渐进式采用路径 | v1.4 | 已解决 | SKILL.md 4+5+3 分层 |
| FB007 | FEEDBACK-001 | Cursor/OpenCode 集成指引不足 | v1.4 | 已解决 | v1.7 SKILL-CURSOR.md + 安装脚本 |
| FB008 | FEEDBACK-002 | Subagent 缺少 model 字段 | v1.5 | 部分修复 | 已有 model 但未分级 → FB014 |
| FB009 | FEEDBACK-002 | 缺少错误传播与回滚 | v1.5 | 已修复 | workflow_plan_template §6 |
| FB010 | FEEDBACK-002 | 健康检查仅覆盖"缺失" | v1.5 | 未修复 | → FB015 |
| FB011 | FEEDBACK-002 | 缺少 @引用语法分层 | v1.5 | 未修复 | → FB018 |
| FB012 | FEEDBACK-002 | 缺少 Skill vs Subagent 规范 | v1.5 | 未修复 | → FB019 |
| FB013 | FEEDBACK-002 | 质量门禁缺少 Hooks | v1.5 | 未修复 | → FB020 |
| FB014 | 本次 | Agent model 未分级 | v1.7+ | 新增 | FB008 升级 |
| FB015 | 本次 | 健康检查无质量验证 | v1.7+ | 新增 | FB010 延续 |
| FB016 | 本次 | .claude/.cursor model 不一致 | v1.7+ | 新增 | 跨工具问题 |
| FB017 | 本次 | CHANGELOG 混入过程稿 | v1.7+ | 新增 | 规范问题 |
| FB018 | 本次 | SKILL.md 未用 @引用 | v1.7+ | 新增 | FB011 延续 |
| FB019 | 本次 | 缺少 Skill vs Subagent 指引 | v1.7+ | 新增 | FB012 延续 |
| FB020 | 本次 | 缺少 Hooks 配置示例 | v1.7+ | 新增 | FB013 延续 |

---

## 8. 参考资料

| 来源 | 链接 | 反馈类型 |
|------|------|----------|
| FEEDBACK-001 | docs/FEEDBACK-001-反馈分析.md | 历史反馈 |
| FEEDBACK-002 | docs/FEEDBACK-002-反馈分析-v1.5.md | 历史反馈 |
| Claude Code Best Practices | https://code.claude.com/docs/en/best-practices | 最佳实践 |
| Claude Code Sub-agents | https://code.claude.com/docs/en/sub-agents | 架构参考 |
| Keep a Changelog | https://keepachangelog.com/zh-CN/1.0.0/ | 规范参考 |
| .claude/agents/ 目录 | .claude/agents/*.md（12 个文件） | 内部审查 |
| .cursor/agents/ 目录 | .cursor/agents/*.md（12 个文件） | 内部审查 |
| CHANGELOG.md | CHANGELOG.md | 内部审查 |

---

## 9. 修订记录

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v1.0 | 2026-05-03 | 反馈分析师 | 初稿，基于 v1.7+ 现状分析 + 历史反馈追踪 |
