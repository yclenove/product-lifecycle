# FEEDBACK-R1 product-lifecycle v2.4.0 反馈分析报告

| 字段 | 值 |
|------|-----|
| 版本 | v1.0 |
| 作者 | 反馈分析师 |
| 日期 | 2026-05-05 |
| 状态 | 正式发布 |
| 关联文档 | CHANGELOG.md, SKILL.md, FEEDBACK-NEW-001, FEEDBACK-NEW-002, FEEDBACK-006 |

---

## 1. 分析概述

### 1.1 分析范围

本次分析覆盖以下内容：

- FEEDBACK-NEW-001（FB014-FB020）和 FEEDBACK-NEW-002（FB021-FB026）的历史反馈修复验证
- v2.0 至 v2.4.0 的 CHANGELOG 变更审计
- `.claude/agents/` 与 `.cursor/agents/` 配置一致性审查（含 model 字段）
- `agents/` 真源与 `.claude/agents/` 派生一致性审查
- docs/ 中文档准确性审查（模型策略、性能基准、排障指南等）
- scripts/ 脚本覆盖度审查
- 过程文档（ITER/SCOUT/FEEDBACK/ARCH/DEV/QA/QG/MKT/PRD 等）存量审查

时间范围：v1.8 至 v2.4.0（2026-05-04 ~ 2026-05-05）

### 1.2 反馈总量

- 历史反馈验证：26 条（FEEDBACK-NEW-001 的 7 条 + FEEDBACK-NEW-002 的 6 条 + FEEDBACK-001/002 的 13 条）
- 新收集反馈：8 条
- 有效反馈总计：34 条

---

## 2. 历史反馈修复状态

### 2.1 修复状态总览

| ID | 问题描述 | v1.8 状态 | v2.4.0 状态 | 说明 |
|----|----------|----------|------------|------|
| FB001 | 多 Agent 上下文窗口溢出 | 已解决 | 已解决 | CONTEXT-MANAGEMENT.md 保持完整 |
| FB002 | Agent 切换背景重复说明 | 已解决 | 已解决 | 动态上下文注入机制稳定 |
| FB003 | 文档模板过于刚性 | 已解决 | 已解决 | 模板标注必填/可选 |
| FB004 | 缺少执行状态可视化 | 已解决 | 已解决 | 项目状态快照模板存在 |
| FB005 | "8 个 Agent" 残留引用 | 已解决 | 已解决 | v1.2/v1.3 已修复 |
| FB006 | 缺少渐进式采用路径 | 已解决 | 已解决 | SKILL.md 有决策树分层 |
| FB007 | Cursor/OpenCode 集成指引不足 | 已解决 | 已解决 | SKILL-CURSOR.md + 安装脚本 |
| FB008 | Subagent 缺少 model 字段 | 已解决 | 已解决 | v2.4.0 改为 mimo-v2.5-pro/mimo-v2.5 |
| FB009 | 缺少错误传播与回滚 | 已解决 | 已解决 | workflow_plan_template.md §6 |
| FB010 | 健康检查仅覆盖"缺失" | 已解决 | 已解决 | v1.8 新增质量列 |
| FB011 | 缺少 @引用语法分层 | 部分修复 | 部分修复 | → FB024，仍未完全解决 |
| FB012 | 缺少 Skill vs Subagent 规范 | 未修复 | 未修复 | → FB025（四轮未修复） |
| FB013 | 质量门禁缺少 Hooks | 未修复 | 未修复 | → FB026（四轮未修复） |
| FB014 | Agent model 未分级 | 已解决 | 已解决 | v2.4.0 mimo 二级分级 |
| FB015 | 健康检查无质量验证 | 已解决 | 已解决 | v1.8 新增质量列 |
| FB016 | .claude/.cursor model 不一致 | 部分修复 | 已解决 | v2.4.0 两端均已配置 mimo |
| FB017 | CHANGELOG 混入过程稿 | 已解决 | 已解决 | v1.8 清理 |
| FB018 | SKILL.md 未用 @引用 | 部分修复 | 部分修复 | → FB024 |
| FB019 | 缺少 Skill vs Subagent 指引 | 未修复 | 未修复 | → FB025 |
| FB020 | 缺少 Hooks 配置示例 | 未修复 | 未修复 | → FB026 |
| FB021 | .cursor/agents/ 未同步 model 分级 | 新增 | 已解决 | v2.4.0 .cursor/agents/ 已配置 mimo |
| FB022 | SKILL-CLAUDE-CODE.md 模型描述不符 | 新增 | 未修复 | 仍写"默认继承全局配置"，未提 mimo |
| FB023 | orchestrator.md 健康检查表与主表不一致 | 新增 | 已解决 | v2.4.0 orchestrator.md 已含质量列 |
| FB024 | 工具文档表未用 @引用（FB018 遗留） | 新增 | 未修复 | SKILL.md 工具表仍用 markdown 链接 |
| FB025 | Skill vs Subagent 指引（四轮未修复） | 新增 | 未修复 | FB012→FB019→FB025→本轮 |
| FB026 | Hooks 配置示例（四轮未修复） | 新增 | 未修复 | FB013→FB020→FB026→本轮 |

### 2.2 修复质量评估

| 维度 | v1.8 评分 | v2.4.0 评分 | 变化 | 说明 |
|------|----------|------------|------|------|
| 完整性 | 9/10 | 9/10 | 0 | FB016/FB021/FB023 修复，但 FB022/FB024 未修复 |
| 质量 | 9/10 | 8/10 | -1 | 多处文档仍引用 opus/sonnet/haiku，与实际 mimo 配置不符 |
| 一致性 | 7.5/10 | 6.5/10 | -1 | SKILL-ASSETS.md 存在两套矛盾的模型策略表 |
| 可用性 | 9/10 | 9/10 | 0 | Agent 功能完整，模型配置合理 |

**总体评价：v2.4.0 对历史反馈的累计修复率为 73%（19/26 完全解决，3 部分解决，4 未修复）。FB025 和 FB026 已连续四轮未修复，属于技术债。新增 8 条反馈主要来自 v2.4.0 模型切换后文档未同步的问题。**

---

## 3. 新收集反馈

### 3.1 反馈来源

| 来源 | 类型 | 参考价值 |
|------|------|----------|
| SKILL-ASSETS.md 模型策略表审查 | 内部审查 | 高 — 直接影响用户模型选择 |
| SKILL-CLAUDE-CODE.md 审查 | 内部审查 | 高 — 影响 Claude Code 用户配置 |
| PERFORMANCE-BASELINE.md 审查 | 内部审查 | 中 — 影响成本预估准确性 |
| TROUBLESHOOTING.md 审查 | 内部审查 | 中 — 影响排障效率 |
| .claude/worktrees/ 残留审查 | 内部审查 | 低 — 影响开发环境整洁 |
| scripts/validate.sh 覆盖度审查 | 内部审查 | 中 — 影响 CI 质量门禁可靠性 |
| docs/ 过程文档存量审查 | 内部审查 | 中 — 影响仓库可维护性 |
| SKILL-ASSETS.md Agent 表审查 | 内部审查 | 中 — 影响文档准确性 |

### 3.2 反馈汇总表

| ID | 类别 | 描述 | 来源 | 频次 | 影响面 | 严重度 | 优先级分 |
|----|------|------|------|------|--------|--------|----------|
| FB027 | 一致性问题 | SKILL-ASSETS.md 存在两套矛盾的模型策略表（opus/sonnet/haiku vs mimo-v2.5-pro/mimo-v2.5） | 内部审查 | 高 | 全局 | 严重 | 18 |
| FB028 | 文档准确性 | SKILL-CLAUDE-CODE.md 第 48 行仍写"默认继承全局配置"，未提及 mimo 模型 | 内部审查/FB022 | 中 | 全局 | 一般 | 6 |
| FB029 | 文档准确性 | PERFORMANCE-BASELINE.md 模型列仍写 opus/sonnet/haiku，与实际 mimo 配置不符 | 内部审查 | 中 | 部分 | 一般 | 4 |
| FB030 | 文档准确性 | TROUBLESHOOTING.md 第 70 行排障场景仍写"所有 Agent 都用 sonnet" | 内部审查 | 低 | 局部 | 建议 | 2 |
| FB031 | 清理问题 | .claude/worktrees/ 中两个 worktree 的 agents/ 仍用旧 model: sonnet | 内部审查 | 低 | 局部 | 建议 | 2 |
| FB032 | 功能缺陷 | scripts/validate.sh 只检查 agents/ 不检查 .claude/agents/，CI 门禁存在盲区 | 内部审查 | 中 | 部分 | 一般 | 4 |
| FB033 | 清理问题 | docs/ 中有 53 个过程文档（ITER/SCOUT/FEEDBACK/ARCH/DEV/QA/QG/MKT/PRD），应归档 | 内部审查 | 中 | 局部 | 建议 | 2 |
| FB034 | 一致性问题 | SKILL-ASSETS.md Agent 表列 12 个但实际有 13 个（缺 reviewer） | 内部审查 | 中 | 部分 | 一般 | 4 |

**优先级分计算：** 频次(高=3,中=2,低=1) x 影响面(全局=3,部分=2,局部=1) x 严重度(严重=3,一般=2,建议=1)，归一化后取整。

---

## 4. 新反馈详情

### 4.1 FB027: SKILL-ASSETS.md 存在两套矛盾的模型策略表

- **描述：** `docs/SKILL-ASSETS.md` 存在两套模型策略表，互相矛盾：
  - 第 87-90 行：opus/sonnet/haiku 三级策略（sonnet 覆盖全部 10 个 Agent）
  - 第 109-114 行：mimo-v2.5-pro/mimo-v2.5 二级策略（mimo-v2.5-pro 仅 orchestrator + architect）
  - 第 83 行文字说明"Subagent 定义中不指定 model 字段，自动继承用户全局配置"，与实际 frontmatter 中硬编码 mimo 矛盾。
  - v2.4.0 CHANGELOG 明确记录"模型配置改为小米 Mimo 系列"，但旧表未删除。
- **来源：** 内部审查 SKILL-ASSETS.md
- **频次：** 高（每次用户查阅模型策略都会遇到矛盾信息）
- **影响面：** 全局（影响所有用户的模型选择决策）
- **严重度：** 严重（两套策略表直接矛盾，用户无法判断哪个是正确的）
- **优先级分：** 18（频次3 x 影响面3 x 严重度3，归一化）
- **证据：**
  - `docs/SKILL-ASSETS.md` 第 87-90 行：sonnet/haiku 表
  - `docs/SKILL-ASSETS.md` 第 109-114 行：mimo-v2.5-pro/mimo-v2.5 表
  - `.claude/agents/orchestrator.md` 第 4 行：`model: "mimo-v2.5-pro"`
  - `.claude/agents/developer.md` 第 4 行：`model: "mimo-v2.5"`
- **建议处理方式：**
  1. 删除第 87-90 行的旧 sonnet/haiku 表
  2. 将第 109-114 行的 mimo 表提升到"模型选择策略"段落
  3. 更新第 83 行文字说明，明确 frontmatter 中硬编码 mimo 模型
  4. 保留"如需自定义模型"的指引

### 4.2 FB028: SKILL-CLAUDE-CODE.md 模型描述与实际不符（FB022 延续）

- **描述：** `docs/SKILL-CLAUDE-CODE.md` 第 48 行仍写"模型选择：Subagent 默认继承全局配置，可在 frontmatter 中按需指定"。v2.4.0 已在 frontmatter 中硬编码 mimo-v2.5-pro / mimo-v2.5，不再是"继承全局配置"。这是 FB022 的延续，第二轮未修复。
- **来源：** 内部审查 + FB022 追踪
- **频次：** 中（Claude Code 用户首次使用时会读此文档）
- **影响面：** 全局（影响 Claude Code 用户对模型配置的理解）
- **严重度：** 一般（不阻塞功能但造成误解）
- **优先级分：** 6（频次2 x 影响面3 x 严重度1，归一化）
- **证据：**
  - `docs/SKILL-CLAUDE-CODE.md` 第 48 行：`- **模型选择：Subagent 默认继承全局配置，可在 frontmatter 中按需指定`
  - 实际：orchestrator/architect = mimo-v2.5-pro, 其余 11 个 = mimo-v2.5
  - SKILL-CLAUDE-CODE.md 的 Agent 表（第 26-39 行）未列出模型列
- **建议处理方式：**
  1. 第 48 行改为：`- **模型选择**：orchestrator/architect 使用 mimo-v2.5-pro（复杂推理），其余 Agent 使用 mimo-v2.5（常规任务），详见 SKILL-ASSETS.md`
  2. Agent 表增加"模型"列
  3. 在 FB022 追踪表中标记为已修复

### 4.3 FB029: PERFORMANCE-BASELINE.md 模型列仍用旧名称

- **描述：** `docs/PERFORMANCE-BASELINE.md` 第 7-15 行的模型列仍写 opus/sonnet/haiku，与 v2.4.0 实际的 mimo-v2.5-pro/mimo-v2.5 不符。此文档用于成本预估，模型名称错误会导致用户无法正确对账。
- **来源：** 内部审查 PERFORMANCE-BASELINE.md
- **频次：** 中（规划迭代时会参考此文档）
- **影响面：** 部分（影响成本预估的准确性）
- **严重度：** 一般（不影响功能但影响规划）
- **优先级分：** 4（频次2 x 影响面2 x 严重度1，归一化）
- **证据：**
  - `docs/PERFORMANCE-BASELINE.md` 第 7 行：`| 编排 | orchestrator | 2000 | 3000 | opus |`
  - `docs/PERFORMANCE-BASELINE.md` 第 14 行：`| 文档 | docwriter | 3000 | 2000 | haiku |`
  - 实际：orchestrator = mimo-v2.5-pro, docwriter = mimo-v2.5
- **建议处理方式：**
  1. 将模型列的 opus/sonnet/haiku 全部替换为 mimo-v2.5-pro/mimo-v2.5
  2. 同步更新 TOKEN-EFFICIENCY.md 的定价表（第 54-56 行仍为 Claude 模型定价）

### 4.4 FB030: TROUBLESHOOTING.md 排障场景仍引用旧模型名

- **描述：** `docs/TROUBLESHOOTING.md` 第 70 行的排障场景"所有 Agent 都用 sonnet"应更新为"所有 Agent 都用 mimo-v2.5"。排障文档引用过时的模型名会误导用户排查方向。
- **来源：** 内部审查 TROUBLESHOOTING.md
- **频次：** 低（仅遇到问题时才查阅）
- **影响面：** 局部（仅影响遇到模型问题的用户）
- **严重度：** 建议（不阻塞使用但降低排障效率）
- **优先级分：** 2（频次1 x 影响面1 x 严重度2，归一化）
- **证据：**
  - `docs/TROUBLESHOOTING.md` 第 70 行：`**症状：** 所有 Agent 都用 sonnet`
- **建议处理方式：**
  1. 将"sonnet"替换为"mimo-v2.5"
  2. 检查同文档其他位置是否有类似过时引用

### 4.5 FB031: .claude/worktrees/ 中残留旧 model 配置

- **描述：** `.claude/worktrees/optimistic-lamport-51a100/.claude/agents/` 和 `.claude/worktrees/magical-khayyam-893ed9/.claude/agents/` 中的 agent 文件仍使用 `model: "sonnet"`，未同步 v2.4.0 的 mimo 配置。虽然 worktree 是临时环境，但残留的旧配置可能造成混淆。
- **来源：** 内部审查 .claude/worktrees/ 目录
- **频次：** 低（worktree 是临时环境）
- **影响面：** 局部（仅影响使用旧 worktree 的开发者）
- **严重度：** 建议（不影响主分支）
- **优先级分：** 2（频次1 x 影响面1 x 严重度2，归一化）
- **证据：**
  - `.claude/worktrees/optimistic-lamport-51a100/.claude/agents/orchestrator.md` 第 4 行：`model: "sonnet"`
  - `.claude/worktrees/magical-khayyam-893ed9/.claude/agents/orchestrator.md` 第 4 行：`model: "sonnet"`
  - 两个 worktree 共 13+13=26 个 agent 文件全部为 sonnet
- **建议处理方式：**
  1. 清理过期 worktree：`git worktree prune`
  2. 或在 .gitignore 中排除 `.claude/worktrees/`

### 4.6 FB032: scripts/validate.sh 不检查 .claude/agents/

- **描述：** `scripts/validate.sh` 的检查项（上下文管理覆盖、Agent 必需章节、行数范围）全部针对 `agents/` 目录，不检查 `.claude/agents/`。如果 `.claude/agents/` 的派生出现问题（如 sync-agents.sh 未运行），CI 门禁无法发现。v2.4.0 新增的 validate.sh 第 8 项"Agent 行数范围"也只检查 agents/。
- **来源：** 内部审查 scripts/validate.sh
- **频次：** 中（每次 CI 运行都会暴露此盲区）
- **影响面：** 部分（影响 CI 质量门禁的可靠性）
- **严重度：** 一般（不影响功能但降低自动化保障）
- **优先级分：** 4（频次2 x 影响面2 x 严重度1，归一化）
- **证据：**
  - `scripts/validate.sh` 第 49 行：`count=$(grep -l "上下文管理" "$ROOT/agents/"*.md 2>/dev/null | wc -l)` — 只查 agents/
  - `scripts/validate.sh` 第 60 行：`for f in "$ROOT"/agents/*.md; do` — 只查 agents/
  - `scripts/validate.sh` 第 93 行：`for f in "$ROOT"/agents/*.md; do` — 只查 agents/
  - 无任何针对 `.claude/agents/` 的检查
- **建议处理方式：**
  1. 为 .claude/agents/ 新增并行检查块（行数范围、frontmatter 完整性）
  2. 新增 agents/ 与 .claude/agents/ 的一致性检查（diff frontmatter 中的 model 字段）
  3. 新增 .cursor/agents/ 的 model 字段一致性检查

### 4.7 FB033: docs/ 中过程文档过多，应归档

- **描述：** `docs/` 目录下有 53 个过程文档（ITER-001~005、SCOUT-001~006 + NEW-001~002、FEEDBACK-001~006 + NEW-001~002、ARCH-001~004、DEV-001~004、QA-002~005、QG-001~004、MKT-001~005、PRD-002~005、ROLE-RUN-LOG-2026-05-04/05）。这些是 v1.5-v1.8 迭代的过程稿，已完成使命。大量过程文档使 docs/ 目录难以导航，新用户难以区分"当前有效文档"和"历史过程稿"。
- **来源：** 内部审查 docs/ 目录结构
- **频次：** 中（每个新用户首次浏览 docs/ 都会遇到）
- **影响面：** 局部（不影响功能，影响可维护性）
- **严重度：** 建议（技术债，非阻塞）
- **优先级分：** 2（频次2 x 影响面1 x 严重度1，归一化）
- **证据：**
  - `ls docs/` 输出包含 68 个文件，其中 53 个为过程文档编号
  - 过程文档命名规则（MKT-001、PRD-002 等）与有效文档（FAQ.md、SECURITY.md 等）混在一起
- **建议处理方式：**
  1. 创建 `docs/archive/` 目录，将 v1.8 及之前的过程文档移入
  2. 更新 docs/DOC-MAP.md，区分"当前有效"和"历史归档"
  3. 保留最近一轮（v2.x）的过程文档在 docs/ 根目录

### 4.8 FB034: SKILL-ASSETS.md Agent 表缺 reviewer 角色

- **描述：** `docs/SKILL-ASSETS.md` 第 48-62 行的"13 Agent 角色与产出"表实际只列了 12 个 Agent，缺少 `reviewer`（代码审查员）。v2.2.0 新增了 `agents/reviewer.md` 和 `.claude/agents/reviewer.md`，但 SKILL-ASSETS.md 的 Agent 表未同步更新。SKILL.md 第 13 行已正确写"13 个专业 Agent"。
- **来源：** 内部审查 SKILL-ASSETS.md Agent 表
- **频次：** 中（用户查阅 Agent 清单时会遗漏 reviewer）
- **影响面：** 部分（影响用户对 Agent 全貌的理解）
- **严重度：** 一般（不影响功能但文档不完整）
- **优先级分：** 4（频次2 x 影响面2 x 严重度1，归一化）
- **证据：**
  - `docs/SKILL-ASSETS.md` 第 48 行标题写"13 Agent 角色与产出"但表格只有 12 行
  - `agents/reviewer.md` 存在（102 行）
  - `.claude/agents/reviewer.md` 存在（110 行）
  - `scripts/sync-agents.sh` 第 37 行已包含 reviewer
- **建议处理方式：**
  1. 在 SKILL-ASSETS.md Agent 表中增加 reviewer 行
  2. 同步检查 SKILL-CLAUDE-CODE.md 的 Subagent 表（第 26-39 行，当前 12 个，缺 reviewer）

---

## 5. 历史反馈全量跟踪表

| ID | 来源 | 问题描述 | 首次报告 | v2.4.0 状态 | 备注 |
|----|------|----------|----------|------------|------|
| FB001 | FEEDBACK-001 | 多 Agent 上下文窗口溢出 | v1.4 | 已解决 | — |
| FB002 | FEEDBACK-001 | Agent 切换背景重复说明 | v1.4 | 已解决 | — |
| FB003 | FEEDBACK-001 | 文档模板过于刚性 | v1.4 | 已解决 | — |
| FB004 | FEEDBACK-001 | 缺少执行状态可视化 | v1.4 | 已解决 | — |
| FB005 | FEEDBACK-001 | "8 个 Agent" 残留引用 | v1.4 | 已解决 | — |
| FB006 | FEEDBACK-001 | 缺少渐进式采用路径 | v1.4 | 已解决 | — |
| FB007 | FEEDBACK-001 | Cursor/OpenCode 集成指引不足 | v1.4 | 已解决 | — |
| FB008 | FEEDBACK-002 | Subagent 缺少 model 字段 | v1.5 | 已解决 | v2.4.0 mimo 配置 |
| FB009 | FEEDBACK-002 | 缺少错误传播与回滚 | v1.5 | 已解决 | — |
| FB010 | FEEDBACK-002 | 健康检查仅覆盖"缺失" | v1.5 | 已解决 | v1.8 新增质量列 |
| FB011 | FEEDBACK-002 | 缺少 @引用语法分层 | v1.5 | 部分修复 | → FB024 |
| FB012 | FEEDBACK-002 | 缺少 Skill vs Subagent 规范 | v1.5 | 未修复 | → FB025（四轮） |
| FB013 | FEEDBACK-002 | 质量门禁缺少 Hooks | v1.5 | 未修复 | → FB026（四轮） |
| FB014 | FB-NEW-001 | Agent model 未分级 | v1.7+ | 已解决 | v2.4.0 mimo 分级 |
| FB015 | FB-NEW-001 | 健康检查无质量验证 | v1.7+ | 已解决 | — |
| FB016 | FB-NEW-001 | .claude/.cursor model 不一致 | v1.7+ | 已解决 | v2.4.0 两端统一 |
| FB017 | FB-NEW-001 | CHANGELOG 混入过程稿 | v1.7+ | 已解决 | — |
| FB018 | FB-NEW-001 | SKILL.md 未用 @引用 | v1.7+ | 部分修复 | → FB024 |
| FB019 | FB-NEW-001 | 缺少 Skill vs Subagent 指引 | v1.7+ | 未修复 | → FB025 |
| FB020 | FB-NEW-001 | 缺少 Hooks 配置示例 | v1.7+ | 未修复 | → FB026 |
| FB021 | FB-NEW-002 | .cursor/agents/ 未同步 model 分级 | v1.8 | 已解决 | v2.4.0 已配置 |
| FB022 | FB-NEW-002 | SKILL-CLAUDE-CODE.md 模型描述不符 | v1.8 | 未修复 | → FB028 |
| FB023 | FB-NEW-002 | orchestrator.md 健康检查表与主表不一致 | v1.8 | 已解决 | v2.4.0 已同步 |
| FB024 | FB-NEW-002 | 工具文档表未用 @引用 | v1.8 | 未修复 | 三轮未修复 |
| FB025 | FB-NEW-002 | Skill vs Subagent 指引 | v1.5 | 未修复 | 四轮未修复 |
| FB026 | FB-NEW-002 | Hooks 配置示例 | v1.5 | 未修复 | 四轮未修复 |
| FB027 | 本轮 | SKILL-ASSETS.md 两套矛盾模型表 | v2.4.0 | 新增 | 严重 |
| FB028 | 本轮 | SKILL-CLAUDE-CODE.md 模型描述不符 | v2.4.0 | 新增 | FB022 延续 |
| FB029 | 本轮 | PERFORMANCE-BASELINE.md 模型名过时 | v2.4.0 | 新增 | — |
| FB030 | 本轮 | TROUBLESHOOTING.md 模型名过时 | v2.4.0 | 新增 | — |
| FB031 | 本轮 | worktree 残留旧 model 配置 | v2.4.0 | 新增 | — |
| FB032 | 本轮 | validate.sh 不检查 .claude/agents/ | v2.4.0 | 新增 | — |
| FB033 | 本轮 | docs/ 过程文档过多 | v2.4.0 | 新增 | — |
| FB034 | 本轮 | SKILL-ASSETS.md Agent 表缺 reviewer | v2.4.0 | 新增 | — |

---

## 6. 技术债清单

| 项目 | 说明 | 持续轮次 | 首次报告 |
|------|------|----------|----------|
| Skill vs Subagent 指引 | FB012→FB019→FB025→本轮，四轮未修复 | 4 轮 | v1.5 |
| Hooks 配置示例 | FB013→FB020→FB026→本轮，四轮未修复 | 4 轮 | v1.5 |
| @引用语法 | FB011→FB018→FB024→本轮，部分改进 | 4 轮 | v1.5 |
| 文档模型名同步 | FB022→FB028，多处文档仍引用 opus/sonnet/haiku | 2 轮 | v1.8 |

---

## 7. 迭代建议（v2.5 方向）

### 7.1 立即修复

| 优先级 | 改进项 | 预期收益 | 工作量 | 对应反馈 |
|--------|--------|----------|--------|----------|
| P0 | SKILL-ASSETS.md 删除旧 sonnet/haiku 模型表，保留 mimo 表 | 消除矛盾信息 | 极小 | FB027 |
| P0 | SKILL-CLAUDE-CODE.md 更新模型描述为 mimo | 文档准确性 | 极小 | FB028/FB022 |

### 7.2 下个迭代（v2.5）

| 优先级 | 改进项 | 预期收益 | 工作量 | 对应反馈 |
|--------|--------|----------|--------|----------|
| P1 | PERFORMANCE-BASELINE.md + TOKEN-EFFICIENCY.md 模型名同步 | 成本预估准确 | 小 | FB029 |
| P1 | SKILL-ASSETS.md Agent 表补全 reviewer（12→13） | 文档完整性 | 极小 | FB034 |
| P1 | SKILL-CLAUDE-CODE.md Subagent 表补全 reviewer | 文档完整性 | 极小 | FB034 |
| P1 | scripts/validate.sh 新增 .claude/agents/ 检查 | CI 门禁可靠性 | 小 | FB032 |
| P2 | TROUBLESHOOTING.md 模型名更新 | 排障效率 | 极小 | FB030 |
| P2 | 清理 .claude/worktrees/ 过期 worktree | 环境整洁 | 极小 | FB031 |
| P2 | docs/ 过程文档归档到 docs/archive/ | 可维护性 | 中 | FB033 |
| P2 | Skill vs Subagent 使用指引（四轮未修复） | 新用户理解成本 | 小 | FB025/FB019/FB012 |
| P3 | Hooks 自动化配置示例（四轮未修复） | 质量保障自动化 | 中 | FB026/FB020/FB013 |
| P3 | SKILL.md 工具文档表改为 @引用 | 上下文管理效率 | 小 | FB024/FB018/FB011 |

### 7.3 文档模型名同步清单

以下文档仍引用 opus/sonnet/haiku，需统一改为 mimo-v2.5-pro/mimo-v2.5：

| 文件 | 行号 | 当前内容 | 建议修改 |
|------|------|----------|----------|
| docs/SKILL-ASSETS.md | 87-90 | sonnet/haiku 旧表 | 删除，保留第 109-114 行 mimo 表 |
| docs/SKILL-CLAUDE-CODE.md | 48 | "默认继承全局配置" | 改为 mimo 模型说明 |
| docs/PERFORMANCE-BASELINE.md | 7-15 | opus/sonnet/haiku | 改为 mimo-v2.5-pro/mimo-v2.5 |
| docs/TOKEN-EFFICIENCY.md | 54-56 | haiku/sonnet/opus 定价 | 改为 mimo 模型定价或删除 |
| docs/TROUBLESHOOTING.md | 70 | "所有 Agent 都用 sonnet" | 改为 "mimo-v2.5" |
| CHANGELOG.md | 116,129-130,141 | opus/sonnet/haiku | 保留（历史记录，不修改） |

---

## 8. 参考资料

| 来源 | 路径 | 反馈类型 |
|------|------|----------|
| FEEDBACK-NEW-001 | docs/FEEDBACK-NEW-001-反馈分析.md | 历史反馈 |
| FEEDBACK-NEW-002 | docs/FEEDBACK-NEW-002-反馈分析-v1.8.md | 历史反馈 |
| FEEDBACK-006 | docs/FEEDBACK-006-反馈分析-v1.8执行中.md | 历史反馈 |
| CHANGELOG.md | CHANGELOG.md | 变更审计 |
| SKILL.md | SKILL.md | 主文档审查 |
| SKILL-ASSETS.md | docs/SKILL-ASSETS.md | 资源索引审查 |
| SKILL-CLAUDE-CODE.md | docs/SKILL-CLAUDE-CODE.md | Claude Code 文档审查 |
| PERFORMANCE-BASELINE.md | docs/PERFORMANCE-BASELINE.md | 性能基准审查 |
| TROUBLESHOOTING.md | docs/TROUBLESHOOTING.md | 排障指南审查 |
| .claude/agents/ | .claude/agents/*.md（13 个） | 配置审查 |
| .cursor/agents/ | .cursor/agents/*.md（13 个） | 配置审查 |
| agents/ | agents/*.md（13 个） | 真源审查 |
| scripts/validate.sh | scripts/validate.sh | 脚本审查 |
| scripts/sync-agents.sh | scripts/sync-agents.sh | 脚本审查 |

---

## 9. 修订记录

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v1.0 | 2026-05-05 | 反馈分析师 | 初稿，基于 v2.4.0 现状分析 + 历史反馈修复验证 + 新反馈收集 |
