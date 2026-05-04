# FB-NEW-002 product-lifecycle v1.8 反馈分析报告

| 字段 | 值 |
|------|-----|
| 版本 | v1.0 |
| 作者 | 反馈分析师 |
| 日期 | 2026-05-03 |
| 状态 | 正式发布 |
| 关联文档 | CHANGELOG.md, SKILL.md, FEEDBACK-NEW-001 |

---

## 1. 分析概述

### 1.1 分析范围

本次分析覆盖以下内容：

- FEEDBACK-NEW-001（FB014-FB020）在 v1.8 迭代中的修复验证
- v1.8 CHANGELOG 变更审计
- `.claude/agents/` 与 `.cursor/agents/` 配置一致性复审
- SKILL.md 与 SKILL-ASSETS.md 文档质量审查
- 新收集反馈的识别与分级

时间范围：v1.8 迭代（2026-05-04）

### 1.2 反馈总量

- FEEDBACK-NEW-001 修复验证：7 条
- 新收集反馈：6 条
- 有效反馈总计：13 条

---

## 2. FEEDBACK-NEW-001 修复验证（FB014-FB020）

### 2.1 修复状态总览

| ID | 问题描述 | 预期修复 | 实际状态 | 验证结果 |
|----|----------|----------|----------|----------|
| FB014 | Agent model 字段未分级 | opus/sonnet/haiku 三级 | 已修复 | 通过 |
| FB015 | 健康检查缺质量列 | 新增"质量不达标时"列 | 已修复 | 通过 |
| FB016 | .claude/ vs .cursor/ model 差异 | 统一说明 | 部分修复 | 有条件通过 |
| FB017 | CHANGELOG Unreleased 混乱 | 清理过程稿条目 | 已修复 | 通过 |
| FB018 | @引用语法 | 改用 @path 语法 | 部分修复 | 有条件通过 |
| FB019 | Skill vs Subagent 规范 | 新增使用指引 | 未修复 | 未通过 |
| FB020 | Hooks 配置示例 | 新增 Hooks 示例 | 未修复 | 未通过 |

**修复率：3/7 完全修复，2/7 部分修复，2/7 未修复（43% 完全修复率）**

### 2.2 逐条验证详情

#### FB014: Agent model 字段分级 — 已修复

**验证证据：**

- `.claude/agents/orchestrator.md` 第 4 行：`model: "opus"`
- `.claude/agents/architect.md` 第 4 行：`model: "opus"`
- `.claude/agents/developer.md` 等 8 个：`model: "sonnet"`
- `.claude/agents/docwriter.md` 第 4 行：`model: "haiku"`
- `.claude/agents/quality-gatekeeper.md` 第 4 行：`model: "haiku"`
- `docs/SKILL-ASSETS.md` 第 82-87 行新增「模型选择策略」表

**评估：** 分级方案与 FEEDBACK-NEW-001 建议一致，且在 SKILL-ASSETS.md 中有说明文档。完全满足预期。

#### FB015: 文档健康检查增加质量列 — 已修复

**验证证据：**

- `SKILL.md` 第 91-100 行的健康检查表已新增「质量不达标时」列
- 7 个 Agent 均有对应的质量不达标行动（如「重新制定框架」「重新评审设计方案」「代码审查+重构」等）

**评估：** 修复完整，覆盖了所有列出的 Agent。满足预期。

#### FB016: .claude/ vs .cursor/ model 策略一致性 — 部分修复

**验证证据：**

- `docs/SKILL-ASSETS.md` 第 82-87 行有模型选择策略表
- `.claude/agents/` 已按 opus/sonnet/haiku 三级分布
- `.cursor/agents/` 全部 12 个仍为 `model: inherit`（未同步分级策略）
- `docs/SKILL-CURSOR.md` 未提及 model 策略差异及原因
- `docs/SKILL-CLAUDE-CODE.md` 第 48 行仍写「默认使用 Sonnet，可按需调整」，与实际 opus 分级不符

**评估：** SKILL-ASSETS.md 的策略表解决了"为什么这样分"的问题，但存在两处残留不一致：
1. `.cursor/agents/` 未同步（12 个全部 inherit），且无文档解释差异原因
2. SKILL-CLAUDE-CODE.md 的描述与实际分级不一致

#### FB017: CHANGELOG [Unreleased] 清理 — 已修复

**验证证据：**

- `CHANGELOG.md` 第 7-9 行：`[Unreleased]` 段落仅保留 `<!-- 下一版本条目写于此 -->` 注释
- 原有的 ITER-004/ITER-005 过程稿条目已移除
- v1.8 条目第 16 行记录了「CHANGELOG [Unreleased] 清理混入的过程稿条目」

**评估：** 完全满足预期。清理干净且有变更记录。

#### FB018: SKILL.md @引用语法 — 部分修复

**验证证据：**

- `SKILL.md` 第 155 行：`docs/CONTEXT-MANAGEMENT.md` 使用了直接路径引用（非 markdown 链接格式）
- `SKILL.md` 第 21-24 行的工具文档表仍使用 `[docs/SKILL-CURSOR.md](docs/SKILL-CURSOR.md)` markdown 链接格式
- `SKILL.md` 第 27 行同样使用 markdown 链接
- CHANGELOG v1.8 记录了「SKILL.md 直接引用 docs/CONTEXT-MANAGEMENT.md」

**评估：** 部分改进——CONTEXT-MANAGEMENT.md 改为直接引用，但核心工具文档表（SKILL-CURSOR.md、SKILL-CLAUDE-CODE.md、SKILL-OTHER-TOOLS.md）仍为 markdown 链接格式。未完全采用 `@` 引用语法。

#### FB019: Skill vs Subagent 使用指引 — 未修复

**验证证据：**

- `SKILL.md` 全文无「Skill vs Subagent」相关段落
- `docs/SKILL-CLAUDE-CODE.md` 无 Skill 与 Subagent 的协作关系说明
- `docs/SKILL-CURSOR.md` 无相关内容
- 无新增独立文档说明两者关系

**评估：** 未修复。FEEDBACK-002 FB012 → FEEDBACK-NEW-001 FB019 延续未解决。

#### FB020: Hooks 配置示例 — 未修复

**验证证据：**

- `docs/SKILL-CLAUDE-CODE.md` 全文无 Hooks 相关配置示例
- 无 `.claude/settings.json` 模板文件
- 无 PreToolUse/PostToolUse hooks 示例
- CHANGELOG v1.8 无相关变更记录

**评估：** 未修复。FEEDBACK-002 FB013 → FEEDBACK-NEW-001 FB020 延续未解决。

---

## 3. 新收集反馈

### 3.1 反馈来源

| 来源 | 类型 | 参考价值 |
|------|------|----------|
| .claude/agents/ 复审 | 内部审查 | 高 — 验证 model 分级修复 |
| .cursor/agents/ 复审 | 内部审查 | 高 — 跨工具一致性 |
| SKILL-CLAUDE-CODE.md 审查 | 内部审查 | 中 — 文档准确性 |
| SKILL.md 审查 | 内部审查 | 高 — 主文档质量 |
| CHANGELOG.md 审计 | 内部审查 | 中 — 规范遵循 |
| FEEDBACK-NEW-001 遗留追踪 | 历史追踪 | 高 — 修复闭环 |

### 3.2 反馈汇总表

| ID | 类别 | 描述 | 来源 | 频次 | 影响面 | 严重度 | 优先级分 |
|----|------|------|------|------|--------|--------|----------|
| FB021 | 一致性问题 | .cursor/agents/ 12 个 agent 全部 model: inherit，未同步 .claude/agents/ 的三级分级策略 | 内部审查 | 中 | 全局 | 一般 | 6 |
| FB022 | 文档准确性 | SKILL-CLAUDE-CODE.md 第 48 行仍写"默认使用 Sonnet"，与 v1.8 实际 opus/sonnet/haiku 分级不符 | 内部审查 | 中 | 部分 | 一般 | 4 |
| FB023 | 一致性问题 | orchestrator.md 内置健康检查表（第 63-70 行）与 SKILL.md 主表不一致：缺"质量不达标时"列、缺 5 个 Agent | 内部审查 | 中 | 部分 | 一般 | 4 |
| FB024 | 功能请求 | SKILL.md 工具文档表仍用 markdown 链接而非 @引用语法（FB018 遗留，仅 CONTEXT-MANAGEMENT.md 改进） | 内部审查/FEEDBACK-NEW-001 | 中 | 全局 | 建议 | 6 |
| FB025 | 功能请求 | 缺少 Skill vs Subagent 使用指引（FB012→FB019 延续，三轮未修复） | 内部审查/FEEDBACK-002 | 中 | 全局 | 建议 | 4 |
| FB026 | 功能请求 | 缺少 Hooks 自动化配置示例（FB013→FB020 延续，三轮未修复） | 内部审查/FEEDBACK-002 | 中 | 全局 | 建议 | 4 |

**优先级分计算：** 频次(高=3,中=2,低=1) x 影响面(全局=3,部分=2,局部=1)

---

## 4. 新反馈详情

### 4.1 FB021: .cursor/agents/ 未同步 model 分级策略

- **描述：** v1.8 为 `.claude/agents/` 实施了 opus/sonnet/haiku 三级 model 分级（FB014 修复），但 `.cursor/agents/` 的 12 个 agent 全部仍为 `model: inherit`。两套配置的 model 策略完全不同，且无文档解释差异原因。这导致在 Cursor 中使用时无法享受模型分级带来的成本优化。
- **来源：** 内部审查 `.cursor/agents/` 配置
- **频次：** 中（跨工具用户会遇到）
- **影响面：** 全局（影响所有 Cursor 用户的成本）
- **优先级分：** 6（频次2 x 影响面3）
- **证据：**
  - `.cursor/agents/orchestrator.md` 第 4 行：`model: inherit`
  - `.cursor/agents/architect.md` 第 4 行：`model: inherit`
  - `.cursor/agents/docwriter.md` 第 4 行：`model: inherit`
  - 其余 9 个 agent 同样全部为 `model: inherit`
- **建议处理方式：**
  1. 如 Cursor 支持 model 字段的相同语义：将 `.cursor/agents/` 同步为与 `.claude/agents/` 相同的三级分布
  2. 如 Cursor 不支持：在 SKILL-CURSOR.md 中明确说明差异原因，并指引用户在 Cursor 设置中手动配置模型
  3. 在 SKILL-ASSETS.md 模型选择策略表中增加 Cursor 列

### 4.2 FB022: SKILL-CLAUDE-CODE.md 模型描述与实际不符

- **描述：** `docs/SKILL-CLAUDE-CODE.md` 第 48 行仍写「模型选择：默认使用 Sonnet，可按需调整」。v1.8 已将 orchestrator 和 architect 改为 opus，docwriter 和 quality-gatekeeper 改为 haiku，不再"默认 Sonnet"。
- **来源：** 内部审查 SKILL-CLAUDE-CODE.md
- **频次：** 低（文档准确性问题，不影响功能）
- **影响面：** 部分（影响新用户对模型策略的理解）
- **优先级分：** 4（频次2 x 影响面2）
- **证据：**
  - `docs/SKILL-CLAUDE-CODE.md` 第 48 行：`- **模型选择**：默认使用 Sonnet，可按需调整`
  - 实际：orchestrator/architect = opus, 8 个 = sonnet, docwriter/quality-gatekeeper = haiku
- **建议处理方式：**
  1. 将第 48 行改为：`- **模型选择**：按任务复杂度分级（opus/sonnet/haiku），详见 SKILL-ASSETS.md`
  2. 或直接删除此行，避免信息重复

### 4.3 FB023: orchestrator.md 内置健康检查表与 SKILL.md 主表不一致

- **描述：** `.claude/agents/orchestrator.md` 第 63-70 行有自己的「文档健康检查」表，但该表与 `SKILL.md` 第 91-100 行的主表存在两处不一致：(1) 缺少「质量不达标时」列（v1.8 新增）；(2) 只列了 5 个 Agent（编排总监/架构师/开发/测试/运维/技术文档/迭代规划），缺少市场分析师、产品经理、需求侦察兵、反馈分析师、质量门禁。
- **来源：** 内部审查 orchestrator.md 与 SKILL.md 对比
- **频次：** 中（orchestrator 是最常启动的 agent）
- **影响面：** 部分（影响 orchestrator 的健康检查准确性）
- **优先级分：** 4（频次2 x 影响面2）
- **证据：**
  - `.claude/agents/orchestrator.md` 第 63-70 行：只有 3 列（文档/检查/缺失时行动），5 个 Agent
  - `SKILL.md` 第 91-100 行：有 4 列（含「质量不达标时」），7 个 Agent
- **建议处理方式：**
  1. 将 orchestrator.md 的健康检查表改为引用 SKILL.md 主表，避免重复维护
  2. 或同步更新 orchestrator.md，使其与 SKILL.md 一致（含「质量不达标时」列）

### 4.4 FB024: SKILL.md 工具文档表未用 @引用语法（FB018 遗留）

- **描述：** FB018 建议将 SKILL.md 的支撑文件引用改为 `@` 引用语法。v1.8 仅将 `docs/CONTEXT-MANAGEMENT.md` 改为直接路径引用，但核心工具文档表（第 21-24 行）的三个条目（SKILL-CURSOR.md、SKILL-CLAUDE-CODE.md、SKILL-OTHER-TOOLS.md）仍使用 markdown 链接格式 `[text](path)`。这是第二轮未完全修复的遗留问题。
- **来源：** 内部审查 + FEEDBACK-NEW-001 FB018 追踪
- **频次：** 中（影响上下文自动加载效率）
- **影响面：** 全局（工具文档是用户最常访问的支撑文件）
- **优先级分：** 6（频次2 x 影响面3）
- **证据：**
  - `SKILL.md` 第 21 行：`[docs/SKILL-CURSOR.md](docs/SKILL-CURSOR.md)`
  - `SKILL.md` 第 23 行：`[docs/SKILL-CLAUDE-CODE.md](docs/SKILL-CLAUDE-CODE.md)`
  - `SKILL.md` 第 24 行：`[docs/SKILL-OTHER-TOOLS.md](docs/SKILL-OTHER-TOOLS.md)`
  - 第 155 行的 CONTEXT-MANAGEMENT.md 已改为直接引用（修复了一处）
- **建议处理方式：**
  1. 将工具文档表的三个条目改为 `@docs/SKILL-CURSOR.md` 等格式
  2. 保留 markdown 链接作为人类可读的备用（双格式）
  3. 注意：需确认 Claude Code 的 @引用是否支持 frontmatter 中的路径

### 4.5 FB025: Skill vs Subagent 使用指引（三轮未修复）

- **描述：** 此问题自 FEEDBACK-002 FB012 首次提出，经 FEEDBACK-NEW-001 FB019 延续，至今三轮未修复。Claude Code 区分 Skill（可复用工作流）和 Subagent（独立上下文助手），当前框架同时定义了两者但未说明协作关系和使用边界。
- **来源：** 内部审查 + FEEDBACK-002 FB012 + FEEDBACK-NEW-001 FB019
- **频次：** 中（新用户常见困惑）
- **影响面：** 全局（影响用户对框架的理解）
- **优先级分：** 4（频次2 x 影响面2）
- **证据：**
  - SKILL.md 全文无 Skill vs Subagent 相关段落
  - SKILL-CLAUDE-CODE.md 无相关内容
  - 历史反馈记录：FB012(v1.5) → FB019(v1.7+) → 本轮仍未修复
- **建议处理方式：**
  1. 在 SKILL.md 中增加「Skill vs Subagent 使用指引」段落
  2. 明确：`/product-lifecycle` = 全流程编排入口，subagent = 单角色独立执行
  3. 提供典型使用场景对照表

### 4.6 FB026: Hooks 自动化配置示例（三轮未修复）

- **描述：** 此问题自 FEEDBACK-002 FB013 首次提出，经 FEEDBACK-NEW-001 FB020 延续，至今三轮未修复。质量门禁仍主要依赖人工审查，缺少 Hooks 自动化配置示例。
- **来源：** 内部审查 + FEEDBACK-002 FB013 + FEEDBACK-NEW-001 FB020
- **频次：** 中（人工审查效率低）
- **影响面：** 全局（影响质量保障可靠性）
- **优先级分：** 4（频次2 x 影响面2）
- **证据：**
  - SKILL-CLAUDE-CODE.md 全文无 Hooks 配置示例
  - 无 .claude/settings.json 模板
  - 历史反馈记录：FB013(v1.5) → FB020(v1.7+) → 本轮仍未修复
- **建议处理方式：**
  1. 在 SKILL-CLAUDE-CODE.md 中增加 Hooks 配置示例
  2. 提供 `.claude/settings.json` 模板（含 PreToolUse/PostToolUse hooks）
  3. 区分"可自动化门禁"和"需人工审查门禁"

---

## 5. 历史反馈全量跟踪表

| ID | 来源 | 问题描述 | 首次报告 | v1.7+ 状态 | v1.8 状态 | 备注 |
|----|------|----------|----------|-----------|----------|------|
| FB001 | FEEDBACK-001 | 多 Agent 上下文窗口溢出 | v1.4 | 已解决 | 已解决 | — |
| FB002 | FEEDBACK-001 | Agent 切换背景重复说明 | v1.4 | 已解决 | 已解决 | — |
| FB003 | FEEDBACK-001 | 文档模板过于刚性 | v1.4 | 已解决 | 已解决 | — |
| FB004 | FEEDBACK-001 | 缺少执行状态可视化 | v1.4 | 已解决 | 已解决 | — |
| FB005 | FEEDBACK-001 | "8 个 Agent" 残留引用 | v1.4 | 已解决 | 已解决 | — |
| FB006 | FEEDBACK-001 | 缺少渐进式采用路径 | v1.4 | 已解决 | 已解决 | — |
| FB007 | FEEDBACK-001 | Cursor/OpenCode 集成指引不足 | v1.4 | 已解决 | 已解决 | — |
| FB008 | FEEDBACK-002 | Subagent 缺少 model 字段 | v1.5 | 部分修复 | 已解决 | v1.8 三级分级 |
| FB009 | FEEDBACK-002 | 缺少错误传播与回滚 | v1.5 | 已修复 | 已解决 | — |
| FB010 | FEEDBACK-002 | 健康检查仅覆盖"缺失" | v1.5 | 未修复 | 已解决 | v1.8 新增质量列 |
| FB011 | FEEDBACK-002 | 缺少 @引用语法分层 | v1.5 | 未修复 | 部分修复 | → FB024 |
| FB012 | FEEDBACK-002 | 缺少 Skill vs Subagent 规范 | v1.5 | 未修复 | 未修复 | → FB025（三轮） |
| FB013 | FEEDBACK-002 | 质量门禁缺少 Hooks | v1.5 | 未修复 | 未修复 | → FB026（三轮） |
| FB014 | FB-NEW-001 | Agent model 未分级 | v1.7+ | 新增 | 已解决 | v1.8 修复 |
| FB015 | FB-NEW-001 | 健康检查无质量验证 | v1.7+ | 新增 | 已解决 | v1.8 修复 |
| FB016 | FB-NEW-001 | .claude/.cursor model 不一致 | v1.7+ | 新增 | 部分修复 | → FB021 |
| FB017 | FB-NEW-001 | CHANGELOG 混入过程稿 | v1.7+ | 新增 | 已解决 | v1.8 修复 |
| FB018 | FB-NEW-001 | SKILL.md 未用 @引用 | v1.7+ | 新增 | 部分修复 | → FB024 |
| FB019 | FB-NEW-001 | 缺少 Skill vs Subagent 指引 | v1.7+ | 新增 | 未修复 | → FB025 |
| FB020 | FB-NEW-001 | 缺少 Hooks 配置示例 | v1.7+ | 新增 | 未修复 | → FB026 |
| FB021 | FB-NEW-002 | .cursor/agents/ 未同步 model 分级 | v1.8 | — | 新增 | FB016 延续 |
| FB022 | FB-NEW-002 | SKILL-CLAUDE-CODE.md 模型描述不符 | v1.8 | — | 新增 | 文档准确性 |
| FB023 | FB-NEW-002 | orchestrator.md 健康检查表与主表不一致 | v1.8 | — | 新增 | 一致性问题 |
| FB024 | FB-NEW-002 | 工具文档表未用 @引用（FB018 遗留） | v1.8 | — | 新增 | 二轮未完全修复 |
| FB025 | FB-NEW-002 | Skill vs Subagent 指引（三轮未修复） | v1.5 | — | 新增 | FB012→FB019→FB025 |
| FB026 | FB-NEW-002 | Hooks 配置示例（三轮未修复） | v1.5 | — | 新增 | FB013→FB020→FB026 |

---

## 6. 修复质量评估

| 维度 | v1.7+ 评分 | v1.8 评分 | 变化 | 说明 |
|------|-----------|----------|------|------|
| 完整性 | 8.5/10 | 9/10 | +0.5 | FB014/FB015/FB017 修复，覆盖率提升 |
| 质量 | 9/10 | 9/10 | 0 | 修复质量保持水准 |
| 一致性 | 8/10 | 7.5/10 | -0.5 | .cursor/agents/ 未同步 + orchestrator.md 内置表不一致 |
| 可用性 | 8.5/10 | 9/10 | +0.5 | 模型分级 + 质量列提升了实际可用性 |

**总体评价：v1.8 对 FEEDBACK-NEW-001 的修复率为 43%（3/7 完全解决，2 部分解决，2 未修复）。加上历史反馈，累计 20 条中 15 条已解决（75%）。但 FB025 和 FB026 已连续三轮未修复，建议优先处理。**

---

## 7. 迭代建议（v1.9 方向）

### 7.1 立即修复

无阻塞性 Bug。

### 7.2 下个迭代（v1.9）

| 优先级 | 改进项 | 预期收益 | 工作量 | 对应反馈 |
|--------|--------|----------|--------|----------|
| P0 | .cursor/agents/ 同步 model 分级（或文档说明差异） | 消除跨工具不一致 | 小 | FB021/FB016 |
| P0 | SKILL-CLAUDE-CODE.md 模型描述更新 | 文档准确性 | 极小 | FB022 |
| P1 | orchestrator.md 健康检查表与 SKILL.md 主表对齐 | 消除重复维护隐患 | 极小 | FB023 |
| P1 | Skill vs Subagent 使用指引（三轮未修复） | 降低新用户理解成本 | 小 | FB025/FB019/FB012 |
| P2 | SKILL.md 工具文档表改为 @引用 | 提升上下文管理效率 | 小 | FB024/FB018/FB011 |
| P2 | Hooks 自动化配置示例（三轮未修复） | 自动化质量保障 | 中 | FB026/FB020/FB013 |

### 7.3 技术债清单

| 项目 | 说明 | 持续轮次 |
|------|------|----------|
| Skill vs Subagent 指引 | FB012(v1.5) → FB019(v1.7+) → FB025(v1.8)，三轮未修复 | 3 轮 |
| Hooks 配置示例 | FB013(v1.5) → FB020(v1.7+) → FB026(v1.8)，三轮未修复 | 3 轮 |
| @引用语法 | FB011(v1.5) → FB018(v1.7+) → FB024(v1.8)，部分改进 | 3 轮 |
| .cursor model 同步 | FB016(v1.7+) → FB021(v1.8)，部分改进 | 2 轮 |

---

## 8. 参考资料

| 来源 | 路径/链接 | 反馈类型 |
|------|----------|----------|
| FEEDBACK-NEW-001 | docs/FEEDBACK-NEW-001-反馈分析.md | 历史反馈 |
| FEEDBACK-002 | docs/FEEDBACK-002-反馈分析-v1.5.md | 历史反馈 |
| FEEDBACK-001 | docs/FEEDBACK-001-反馈分析.md | 历史反馈 |
| CHANGELOG.md | CHANGELOG.md | 变更审计 |
| SKILL.md | SKILL.md | 主文档审查 |
| SKILL-ASSETS.md | docs/SKILL-ASSETS.md | 资源索引审查 |
| SKILL-CLAUDE-CODE.md | docs/SKILL-CLAUDE-CODE.md | Claude Code 文档审查 |
| .claude/agents/ | .claude/agents/*.md | 配置审查 |
| .cursor/agents/ | .cursor/agents/*.md | 配置审查 |

---

## 9. 修订记录

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v1.0 | 2026-05-03 | 反馈分析师 | 初稿，基于 v1.8 现状分析 + FEEDBACK-NEW-001 修复验证 + 新反馈收集 |
