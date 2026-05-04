# Product-Lifecycle 10 轮迭代 Backlog

> 需求侦察兵全面产品体检报告，基于 v1.9 版本，规划 10 轮迭代。
>
> 生成日期：2026-05-05
> 当前健康度：~8.5/10

---

## 体检摘要

### 已解决（v1.5-v1.9）

- frontmatter 修复（SKILL.md `## name:` → `name:`）
- 编号规则补全（SCOUT、FB、ITER 三个 Agent）
- model 分级（opus/sonnet/haiku 三级策略）
- Cursor 同步（`.cursor/agents/` 与 `.claude/agents/` 对齐）
- 健康检查表（4 列格式统一）

### 未解决 Backlog

| ID | 问题 | 优先级 | 状态 |
|----|------|--------|------|
| FB019 | Skill vs Subagent 概念澄清 | P1 | 待处理 |
| FB020 | Hooks 集成指南 | P2 | 待处理 |
| FB024 | @引用语法统一 | P2 | 待处理 |

### 新发现问题

| ID | 问题 | 优先级 |
|----|------|--------|
| FB025 | 模板年份过时（CONTEXT-MANAGEMENT.md 示例用 2025） | P2 |
| FB026 | Agent prompt 未嵌入上下文管理指令 | P1 |
| FB027 | 文档交叉引用未验证 | P2 |
| FB028 | examples/ 仅一个示例，缺乏多样性 | P3 |
| FB029 | README 未反映 v1.5-v1.9 全部变更 | P1 |
| FB030 | agents/ 与 .claude/agents/ 内容重复但不同步 | P1 |
| FB031 | 渐进式采用缺少快速入门指南 | P2 |
| FB032 | 模板缺少使用示例 | P3 |
| FB033 | 质量门禁模板未在 workflow_plan_template 中引用 | P2 |
| FB034 | 反馈分析师/迭代规划师 agent prompt 较简略 | P2 |

---

## 轮次 1：Skill vs Subagent + Hooks 专项

**主题：** 解决 FB019（Skill vs Subagent）和 FB020（Hooks）两个历史遗留 P1 问题。

**预估工作量：** M（中等）

**依赖：** 无

### 任务 1.1：澄清 Skill vs Subagent 概念（FB019）

**文件路径：**
- `docs/SKILL-CURSOR.md`
- `docs/SKILL-CLAUDE-CODE.md`
- `SKILL.md`

**变更描述：**

在 `docs/SKILL-CURSOR.md` 中新增「Skill vs Subagent 概念辨析」章节：

1. **Cursor Skill**：指 `SKILL.md` 入口文件，提供方法论和流程指引，通过 `/product-lifecycle` 调用
2. **Cursor Subagent**：指 `.cursor/agents/*.md` 定义的独立 Agent，通过 `/orchestrator` 等调用
3. **Claude Code Skill**：指 `SKILL.md` 入口文件，通过 `/product-lifecycle` 调用
4. **Claude Code Subagent**：指 `.claude/agents/*.md` 定义的 Agent，通过 Agent 工具调用

明确两者的关系：
- Skill 是「入口」，Subagent 是「执行者」
- product-lifecycle 同时包含 Skill（方法论入口）和 12 个 Subagent（角色执行）
- 在 Cursor 中可同时使用：先用 Skill 拉起流程，再用 Subagent 执行各角色

**验收标准：**

- [ ] `docs/SKILL-CURSOR.md` 包含「Skill vs Subagent」概念辨析章节
- [ ] 用表格对比 Skill 和 Subagent 的定义、调用方式、适用场景
- [ ] 包含至少 2 个使用场景示例
- [ ] `SKILL.md` 工具表中 Cursor 条目增加指向该章节的引用

### 任务 1.2：Hooks 集成指南（FB020）

**文件路径：**
- `docs/SKILL-CURSOR.md`
- `docs/SKILL-CLAUDE-CODE.md`

**变更描述：**

在 `docs/SKILL-CURSOR.md` 中新增「Hooks 集成」章节：

1. **什么是 Hooks**：Cursor 的确定性后处理机制，可在 Agent 产出后自动执行校验
2. **适用场景**：
   - 文档格式校验（frontmatter 完整性、必填章节）
   - 编号规则检查（MKT-xxx、PRD-xxx 格式）
   - 交叉引用验证（链接有效性）
   - 敏感信息扫描（密钥、密码）
3. **配置示例**：提供 `.cursor/hooks.json` 配置模板
4. **与质量门禁的关系**：Hooks 做确定性检查，质量门禁做语义审查

**验收标准：**

- [ ] `docs/SKILL-CURSOR.md` 包含「Hooks 集成」章节
- [ ] 提供至少 2 个 Hooks 配置示例
- [ ] 说明 Hooks 与质量门禁的分工
- [ ] `docs/SKILL-CLAUDE-CODE.md` 中提及 Claude Code 的 pre-commit hook 对应做法

### 任务 1.3：更新 SKILL.md 工具表

**文件路径：**
- `SKILL.md`

**变更描述：**

更新 SKILL.md 工具表中 Cursor 条目，增加：
- Skill vs Subagent 概念澄清链接
- Hooks 集成指南链接

**验收标准：**

- [ ] SKILL.md 工具表 Cursor 条目包含新增章节引用
- [ ] 链接可跳转

---

## 轮次 2：@引用语法统一 + 工具文档表

**主题：** 解决 FB024（@引用语法），统一文档中的引用方式。

**预估工作量：** S（小）

**依赖：** 无

### 任务 2.1：统一 @引用语法（FB024）

**文件路径：**
- `docs/SKILL-CURSOR.md`
- `docs/SKILL-CLAUDE-CODE.md`
- `docs/SKILL-OTHER-TOOLS.md`
- `docs/SKILL-ASSETS.md`
- `agents/*.md`（所有 agent 文件）

**变更描述：**

定义并统一文档引用语法规范：

1. **文件路径引用**：使用反引号包裹，如 `agents/orchestrator.md`
2. **章节引用**：使用 `§` 符号，如 `docs/PRD-*.md §5`
3. **文档编号引用**：使用编号，如 `MKT-001`、`PRD-001`
4. **@引用（Cursor 特有）**：在 Cursor 中可用 `@file` 引用文件，但文档中不使用此语法（避免工具绑定）

审查所有文档，确保引用语法一致。

**验收标准：**

- [ ] `docs/SKILL-ASSETS.md` 新增「引用语法规范」章节
- [ ] 所有 `agents/*.md` 中的引用语法统一
- [ ] 所有 `docs/SKILL-*.md` 中的引用语法统一
- [ ] 不出现 Cursor 特有的 `@file` 语法（保持工具无关）

### 任务 2.2：工具文档索引表优化

**文件路径：**
- `SKILL.md`
- `docs/SKILL-ASSETS.md`

**变更描述：**

优化 SKILL.md 中的工具文档索引表：

1. 增加「何时读取」列，说明每篇文档的使用场景
2. 增加「依赖关系」列，说明文档间的引用关系
3. 确保所有 `docs/SKILL-*.md` 都被索引

**验收标准：**

- [ ] SKILL.md 工具表增加「何时读取」列
- [ ] `docs/SKILL-ASSETS.md` 包含完整的文档依赖关系图
- [ ] 所有 `docs/SKILL-*.md` 都在索引中

---

## 轮次 3：Agent Prompt 上下文管理嵌入

**主题：** 将 CONTEXT-MANAGEMENT.md 中的最佳实践嵌入各 Agent prompt。

**预估工作量：** M（中等）

**依赖：** 无

### 任务 3.1：为 agents/*.md 添加上下文管理指令

**文件路径：**
- `agents/orchestrator.md`
- `agents/market-analyst.md`
- `agents/product-manager.md`
- `agents/architect.md`
- `agents/developer.md`
- `agents/qa-manager.md`
- `agents/devops.md`
- `agents/docwriter.md`
- `agents/quality-gatekeeper.md`
- `agents/proactive-scout.md`
- `agents/feedback-analyst.md`
- `agents/iteration-planner.md`

**变更描述：**

在每个 `agents/*.md` 文件末尾添加「上下文管理」章节，包含：

```markdown
## 上下文管理

### 输入管理
- 优先读取摘要，按需读取原文
- 如果文档超过 5000 字，只读取与你任务相关的段落
- 使用 grep 定位关键词

### 输出管理
- 总长度控制在 [预算] 字以内
- 使用表格和列表，避免长段落
- 代码示例不超过 20 行
- 关键信息前置

### 状态更新
- 完成后更新 WORKFLOW_PLAN.md 的项目状态快照
- 生成结构化摘要供下游使用
```

预算参考 CONTEXT-MANAGEMENT.md 中的预算表。

**验收标准：**

- [ ] 所有 12 个 `agents/*.md` 都包含「上下文管理」章节
- [ ] 每个 Agent 的输出预算与 CONTEXT-MANAGEMENT.md 一致
- [ ] 包含输入管理、输出管理、状态更新三个子章节

### 任务 3.2：同步 .claude/agents/ 和 .cursor/agents/

**文件路径：**
- `.claude/agents/*.md`
- `.cursor/agents/*.md`

**变更描述：**

将 `agents/*.md` 中新增的上下文管理指令同步到 `.claude/agents/` 和 `.cursor/agents/`。

对于 `.claude/agents/`：直接添加上下文管理章节。
对于 `.cursor/agents/`：在薄封装中增加「遵循 agents/*.md 中的上下文管理指令」。

**验收标准：**

- [ ] `.claude/agents/*.md` 包含上下文管理章节（或引用 `agents/*.md` 中的章节）
- [ ] `.cursor/agents/*.md` 中增加上下文管理引用
- [ ] 三个目录的 Agent 能力描述一致

---

## 轮次 4：模板质量提升

**主题：** 更新模板中的过时内容，补充使用示例，统一格式。

**预估工作量：** M（中等）

**依赖：** 无

### 任务 4.1：更新模板年份（FB025）

**文件路径：**
- `docs/CONTEXT-MANAGEMENT.md`
- `templates/*.md`（所有模板文件）

**变更描述：**

1. `docs/CONTEXT-MANAGEMENT.md` 第 150 行示例中的 `2025-01-01` 更新为 `2026-01-01`
2. 检查所有 `templates/*.md` 中的年份引用，确保使用 2026 年
3. 将 `YYYY-MM-DD` 占位符保持不变（这是正确的）

**验收标准：**

- [ ] `docs/CONTEXT-MANAGEMENT.md` 中无 2025 年的硬编码日期
- [ ] 所有模板中的示例日期使用 2026 年
- [ ] `YYYY-MM-DD` 占位符保持不变

### 任务 4.2：为模板添加使用示例（FB032）

**文件路径：**
- `templates/market_template.md`
- `templates/product_template.md`
- `templates/architecture_template.md`

**变更描述：**

在核心模板中添加「使用示例」折叠区块，展示填写后的示例内容：

1. `market_template.md`：添加一个简化的市场分析示例（竞品对比表、用户画像）
2. `product_template.md`：添加一个简化的 PRD 示例（功能清单、验收标准）
3. `architecture_template.md`：添加一个简化的架构设计示例（模块划分、API 清单）

使用 HTML `<details>` 标签实现折叠。

**验收标准：**

- [ ] 3 个核心模板都包含「使用示例」折叠区块
- [ ] 示例内容简洁，不超过 50 行
- [ ] 示例展示必填章节的填写方式

### 任务 4.3：统一模板格式

**文件路径：**
- `templates/*.md`（所有模板文件）

**变更描述：**

审查所有模板，统一格式：

1. **元数据表**：确保所有模板使用相同的表格格式
2. **章节标记**：确保 `[必填]`、`[可选]`、`[条件：xxx]` 标记一致
3. **修订记录**：确保所有模板都有「修订记录」章节
4. **关联文档**：确保所有模板都有「关联文档」字段

**验收标准：**

- [ ] 所有 12 个模板的元数据表格式一致
- [ ] 所有模板都使用 `[必填]`/`[可选]`/`[条件：xxx]` 标记
- [ ] 所有模板都有「修订记录」章节
- [ ] 所有模板都有「关联文档」字段

---

## 轮次 5：文档交叉引用审计

**主题：** 全量检查文档间的交叉引用，修复无效链接。

**预估工作量：** S（小）

**依赖：** 无

### 任务 5.1：建立交叉引用清单

**文件路径：**
- 所有 `docs/*.md`
- 所有 `agents/*.md`
- 所有 `templates/*.md`
- `SKILL.md`
- `README.md`
- `CHANGELOG.md`

**变更描述：**

1. 使用 grep 扫描所有 markdown 文件中的链接引用
2. 建立交叉引用清单，包含：
   - 源文件
   - 引用目标
   - 引用类型（文件路径、章节、编号）
   - 状态（有效/无效/待验证）
3. 修复所有无效引用

**验收标准：**

- [ ] 建立完整的交叉引用清单（可在 docs/ 中作为临时文件）
- [ ] 所有文件路径引用指向存在的文件
- [ ] 所有章节引用指向存在的章节
- [ ] 无断链

### 任务 5.2：修复 PRODUCT_PLAN.md 虚引用残留

**文件路径：**
- 所有文件

**变更描述：**

搜索所有文件中的 `PRODUCT_PLAN.md` 引用，确认已全部清理（v1.6 已修复大部分）。

**验收标准：**

- [ ] grep 搜索 `PRODUCT_PLAN` 无结果（除了 CHANGELOG 中的历史记录）

---

## 轮次 6：渐进式采用增强

**主题：** 为新用户提供快速入门指南和 5 分钟体验。

**预估工作量：** M（中等）

**依赖：** 轮次 1（Skill vs Subagent 澄清）

### 任务 6.1：创建快速入门指南

**文件路径：**
- `docs/QUICK-START.md`（新建）

**变更描述：**

创建独立的快速入门指南，包含：

1. **30 秒理解**：product-lifecycle 是什么、解决什么问题
2. **5 分钟体验**：
   - Claude Code 用户：`/product-lifecycle myapp "..."` + 查看产出
   - Cursor 用户：`/orchestrator` + 查看产出
   - 其他工具：读取 `agents/orchestrator.md` + 查看产出
3. **最小可用集**：只用 4 个核心 Agent（编排总监、开发、测试、质量门禁）
4. **常见问题**：3-5 个 FAQ

**验收标准：**

- [ ] 新建 `docs/QUICK-START.md`
- [ ] 包含 30 秒理解、5 分钟体验、最小可用集、FAQ 四个章节
- [ ] 每种工具都有具体的命令示例
- [ ] SKILL.md 和 README.md 中增加指向快速入门的链接

### 任务 6.2：增强渐进式采用指引

**文件路径：**
- `SKILL.md`
- `docs/SKILL-ASSETS.md`

**变更描述：**

在 SKILL.md 的「渐进式采用」章节增加：

1. **决策树**：根据项目规模推荐 Agent 子集
2. **阶段式采用**：
   - 阶段 1：只用编排总监 + 开发（最小可行）
   - 阶段 2：加入测试 + 质量门禁（质量保障）
   - 阶段 3：加入市场 + 产品（需求驱动）
   - 阶段 4：加入全部 12 个 Agent（完整流程）
3. **精简模式说明**：如何只用核心 Agent 完成任务

**验收标准：**

- [ ] SKILL.md 包含决策树（文字版）
- [ ] 包含阶段式采用说明
- [ ] `docs/SKILL-ASSETS.md` 包含 Agent 子集推荐表

---

## 轮次 7：examples/ 扩展

**主题：** 增加更多类型的项目示例，展示不同场景下的用法。

**预估工作量：** L（大）

**依赖：** 轮次 4（模板质量提升）

### 任务 7.1：添加持续迭代示例

**文件路径：**
- `examples/saas-iteration.md`（新建）

**变更描述：**

创建一个 SaaS 产品的持续迭代示例，展示模式 B 的完整流程：

1. **项目背景**：一个已上线的 SaaS 协作工具
2. **触发条件**：用户反馈 + 竞品动态
3. **执行过程**：
   - 需求侦察兵：产品体检 + 市场扫描
   - 反馈分析师：收集用户反馈
   - 市场分析师：竞品分析
   - 迭代规划师：制定迭代计划
   - 架构师 → 开发 → 测试 → 质量门禁 → 发布
4. **产出物清单**：完整的文档产出
5. **关键决策**：迭代中的取舍

**验收标准：**

- [ ] 新建 `examples/saas-iteration.md`
- [ ] 展示模式 B（持续迭代）的完整流程
- [ ] 包含 12 个 Agent 的协作过程
- [ ] 产出物清单完整

### 任务 7.2：添加小型项目示例

**文件路径：**
- `examples/cli-tool.md`（新建）

**变更描述：**

创建一个 CLI 工具的简化示例，展示渐进式采用：

1. **项目背景**：一个简单的命令行工具
2. **采用策略**：只用 4 个核心 Agent
3. **执行过程**：
   - 编排总监：制定计划
   - 开发工程师：实现代码
   - 测试经理：编写测试
   - 质量门禁：代码审查
4. **产出物清单**：精简的文档产出

**验收标准：**

- [ ] 新建 `examples/cli-tool.md`
- [ ] 展示渐进式采用（4 个核心 Agent）
- [ ] 流程简洁，适合小项目
- [ ] 产出物清单精简

### 任务 7.3：更新 examples/cloudflow.md

**文件路径：**
- `examples/cloudflow.md`

**变更描述：**

更新 CloudFlow 示例：

1. 更新时间线，反映实际执行时间
2. 增加「上下文管理」示例，展示摘要传递
3. 增加「质量门禁」详细检查过程
4. 增加「迭代」章节，展示从 v1.0 到 v1.1 的迭代过程

**验收标准：**

- [ ] CloudFlow 示例包含上下文管理示例
- [ ] 包含质量门禁详细检查过程
- [ ] 包含迭代过程
- [ ] 时间线合理

---

## 轮次 8：README 全面更新

**主题：** 更新 README.md，反映 v1.5-v1.9 的所有变更。

**预估工作量：** M（中等）

**依赖：** 轮次 1-7 的内容

### 任务 8.1：更新 README 目录结构

**文件路径：**
- `README.md`

**变更描述：**

更新 README.md 中的目录结构树，确保包含：

1. `.claude/agents/` 目录
2. `.cursor/agents/` 目录
3. `docs/CONTEXT-MANAGEMENT.md`
4. `docs/QUICK-START.md`（轮次 6 新建）
5. `templates/scout_template.md`
6. `templates/quality_report_template.md`
7. `examples/saas-iteration.md`（轮次 7 新建）
8. `examples/cli-tool.md`（轮次 7 新建）

**验收标准：**

- [ ] 目录结构树包含所有实际存在的文件和目录
- [ ] 无遗漏
- [ ] 无多余的不存在的文件

### 任务 8.2：更新 Cursor 使用说明

**文件路径：**
- `README.md`

**变更描述：**

更新 README.md 中的 Cursor 使用说明：

1. 增加 Skill vs Subagent 的简要说明（指向 `docs/SKILL-CURSOR.md`）
2. 增加 Hooks 的简要说明
3. 更新安装脚本说明
4. 增加快速入门链接

**验收标准：**

- [ ] Cursor 使用说明包含 Skill vs Subagent 简述
- [ ] 包含 Hooks 简述
- [ ] 安装脚本说明准确
- [ ] 包含快速入门链接

### 任务 8.3：更新 12 Agent 角色表

**文件路径：**
- `README.md`

**变更描述：**

更新 README.md 中的 12 Agent 角色表：

1. 确保所有 12 个 Agent 都在表中
2. 更新「产出物」列，与 `docs/SKILL-ASSETS.md` 一致
3. 增加「模型」列，说明 opus/sonnet/haiku 分级

**验收标准：**

- [ ] 角色表包含 12 个 Agent
- [ ] 产出物描述准确
- [ ] 包含模型分级信息

---

## 轮次 9：一致性总审

**主题：** 审查 agents/、.claude/agents/、.cursor/agents/ 之间的一致性。

**预估工作量：** M（中等）

**依赖：** 轮次 3（Agent Prompt 上下文管理嵌入）

### 任务 9.1：建立一致性检查清单

**文件路径：**
- `docs/CONSISTENCY-CHECKLIST.md`（新建）

**变更描述：**

建立一致性检查清单，定义三个目录的同步规则：

1. **agents/*.md**：通用 Agent prompt（真源）
2. **.claude/agents/*.md**：Claude Code Subagent 定义（含 frontmatter + 动态上下文注入）
3. **.cursor/agents/*.md**：Cursor Subagent 薄封装（含 frontmatter + Read 真源）

同步规则：
- `agents/*.md` 的核心 prompt 必须与 `.claude/agents/*.md` 一致
- `.cursor/agents/*.md` 必须引用 `agents/*.md` 作为真源
- frontmatter 字段（description、tools、model）必须一致

**验收标准：**

- [ ] 新建 `docs/CONSISTENCY-CHECKLIST.md`
- [ ] 包含三个目录的同步规则
- [ ] 包含检查步骤
- [ ] 包含常见不一致场景

### 任务 9.2：执行一致性检查并修复

**文件路径：**
- `agents/*.md`
- `.claude/agents/*.md`
- `.cursor/agents/*.md`

**变更描述：**

按照检查清单执行一致性检查：

1. 对比 `agents/*.md` 和 `.claude/agents/*.md` 的核心 prompt
2. 检查 `.cursor/agents/*.md` 的 Read 引用是否正确
3. 检查 frontmatter 字段是否一致
4. 修复所有不一致

**验收标准：**

- [ ] 所有 12 个 Agent 的三个目录版本一致
- [ ] frontmatter 字段一致
- [ ] Read 引用正确

### 任务 9.3：同步反馈分析师和迭代规划师（FB034）

**文件路径：**
- `agents/feedback-analyst.md`
- `agents/iteration-planner.md`
- `.claude/agents/feedback-analyst.md`
- `.claude/agents/iteration-planner.md`

**变更描述：**

增强反馈分析师和迭代规划师的 agent prompt：

1. **feedback-analyst.md**：
   - 增加详细的反馈收集策略
   - 增加反馈分类和优先级判定规则
   - 增加与竞品对比的分析方法
2. **iteration-planner.md**：
   - 增加详细的迭代计划制定流程
   - 增加影响分析方法
   - 增加回滚方案模板

**验收标准：**

- [ ] feedback-analyst.md 从 ~40 行增强到 ~80 行
- [ ] iteration-planner.md 从 ~40 行增强到 ~80 行
- [ ] 两个 Agent 的 prompt 与 `.claude/agents/` 同步
- [ ] 包含具体的方法论和检查清单

---

## 轮次 10：版本收尾 + CHANGELOG

**主题：** 打 tag、CHANGELOG 定稿、发布 v2.0。

**预估工作量：** S（小）

**依赖：** 轮次 1-9 全部完成

### 任务 10.1：CHANGELOG 定稿

**文件路径：**
- `CHANGELOG.md`

**变更描述：**

将轮次 1-9 的所有变更写入 CHANGELOG：

```markdown
## [2.0.0] - 2026-05-XX

### Added
- docs/QUICK-START.md: 快速入门指南
- docs/CONSISTENCY-CHECKLIST.md: 一致性检查清单
- examples/saas-iteration.md: SaaS 持续迭代示例
- examples/cli-tool.md: CLI 工具简化示例
- docs/SKILL-CURSOR.md: Skill vs Subagent 概念辨析
- docs/SKILL-CURSOR.md: Hooks 集成指南
- docs/SKILL-ASSETS.md: 引用语法规范
- templates/*.md: 使用示例折叠区块

### Changed
- agents/*.md: 添加上下文管理指令
- agents/feedback-analyst.md: 增强 prompt
- agents/iteration-planner.md: 增强 prompt
- .claude/agents/*.md: 同步上下文管理指令
- .cursor/agents/*.md: 同步上下文管理引用
- SKILL.md: 更新工具文档索引表
- SKILL.md: 增强渐进式采用指引
- README.md: 全面更新反映 v1.5-v2.0 变更
- docs/CONTEXT-MANAGEMENT.md: 修复年份引用
- templates/*.md: 统一格式、更新年份

### Fixed
- 修复所有文档交叉引用断链
- 清理 PRODUCT_PLAN.md 虚引用残留
- 统一 @引用语法
```

**验收标准：**

- [ ] CHANGELOG 包含所有轮次的变更
- [ ] 格式遵循 Keep a Changelog
- [ ] 变更分类准确（Added/Changed/Fixed）

### 任务 10.2：版本号更新

**文件路径：**
- `CHANGELOG.md`
- `SKILL.md`（如果需要版本号）

**变更描述：**

1. 将 `[Unreleased]` 条目移到 `[2.0.0]`
2. 更新日期
3. 清理 `[Unreleased]` 区域

**验收标准：**

- [ ] `[Unreleased]` 区域为空或只有占位注释
- [ ] `[2.0.0]` 条目包含完整日期
- [ ] 版本号遵循语义化版本

### 任务 10.3：打 Git Tag

**文件路径：**
- 无（Git 操作）

**变更描述：**

```bash
git add .
git commit -m "v2.0.0: Skill vs Subagent 澄清、Hooks 集成、上下文管理嵌入、模板增强、一致性总审"
git tag v2.0.0
git push origin master --tags
```

**验收标准：**

- [ ] Git tag v2.0.0 创建成功
- [ ] 所有变更已提交
- [ ] 远程仓库已同步

---

## 依赖关系图

```
轮次 1 (Skill vs Subagent + Hooks)
    │
    ├──────────────────┐
    │                  │
轮次 2 (@引用)    轮次 6 (渐进式采用)
    │                  │
    │                  │
轮次 3 (上下文管理)  │
    │                  │
    ├──────────────────┤
    │                  │
轮次 4 (模板质量)    │
    │                  │
轮次 5 (交叉引用)    │
    │                  │
轮次 7 (examples/)   │
    │                  │
    └──────────────────┘
            │
轮次 8 (README 更新)
            │
轮次 9 (一致性总审)
            │
轮次 10 (版本收尾)
```

**关键依赖：**
- 轮次 6 依赖轮次 1（需要 Skill vs Subagent 概念澄清）
- 轮次 7 依赖轮次 4（需要模板质量提升）
- 轮次 8 依赖轮次 1-7（需要所有内容就绪）
- 轮次 9 依赖轮次 3（需要上下文管理嵌入完成）
- 轮次 10 依赖轮次 1-9（需要所有变更完成）

**可并行的轮次：**
- 轮次 1、2、3 可部分并行
- 轮次 4、5 可并行
- 轮次 6、7 可并行（但 7 依赖 4）

---

## 工作量汇总

| 轮次 | 主题 | 工作量 | 预估时间 |
|------|------|--------|----------|
| 1 | Skill vs Subagent + Hooks | M | 2-3 小时 |
| 2 | @引用语法统一 | S | 1-2 小时 |
| 3 | Agent Prompt 上下文管理嵌入 | M | 2-3 小时 |
| 4 | 模板质量提升 | M | 2-3 小时 |
| 5 | 文档交叉引用审计 | S | 1-2 小时 |
| 6 | 渐进式采用增强 | M | 2-3 小时 |
| 7 | examples/ 扩展 | L | 4-6 小时 |
| 8 | README 全面更新 | M | 2-3 小时 |
| 9 | 一致性总审 | M | 2-3 小时 |
| 10 | 版本收尾 + CHANGELOG | S | 1-2 小时 |
| **总计** | | | **19-30 小时** |

---

## 优先级建议

如果时间有限，建议按以下优先级执行：

1. **P0（必须做）**：轮次 1、3、8、10
2. **P1（应该做）**：轮次 2、4、9
3. **P2（可以做）**：轮次 5、6、7

---

## 质量门禁

每个轮次完成后，检查：

- [ ] 所有变更的文件都已保存
- [ ] 交叉引用有效（无断链）
- [ ] 格式一致（markdown 渲染正常）
- [ ] 内容准确（与实际代码/功能一致）
- [ ] 无敏感信息泄露
