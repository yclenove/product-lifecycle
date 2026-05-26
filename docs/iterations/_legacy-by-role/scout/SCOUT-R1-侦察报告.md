# SCOUT-R1 侦察报告

> 需求侦察兵 | v2.4.0 产品体检 | 2026-05-05

---

## 一、产品健康度评分

| 维度 | 得分 | 说明 |
|------|------|------|
| Agent 定义同步 | 8/10 | 三目录（agents/、.claude/agents/、.cursor/agents/）均为 13 Agent，但 .claude/agents/ 为独立维护版本（含 frontmatter + model 配置），与 agents/ 真源存在内容结构差异 |
| 文档完整性 | 9/10 | 18 篇核心指南文档齐全（QUICK-START、FAQ、TROUBLESHOOTING、SECURITY 等），覆盖面广 |
| 模板覆盖 | 9/10 | 13 个模板覆盖 13 个 Agent，但缺少 reviewer 专用模板（reviewer_template.md） |
| 版本管理 | 7/10 | CHANGELOG 格式规范（Keep a Changelog），但同日连发 5 个版本（v2.0.0-v2.4.0），节奏过快；v2.4.0 无对应迭代过程文档 |
| 验证脚本 | 10/10 | validate.sh 8 项检查全部通过 |
| 文档卫生 | 5/10 | docs/ 积压 46 个历史迭代过程稿，占 73 个文件的 63%，严重影响导航 |

**综合健康度：8.0 / 10**

---

## 二、机会信号

### 机会 1：AI 原生产品开发方法论的开源商业化

- **来源**：SKILL.md + README.md
- **置信度**：高
- **描述**：13 Agent 全流程框架在 AI 编码工具生态中具有稀缺性。当前框架已覆盖 Claude Code、Cursor、OpenCode/Codex 四类工具，且具备自驱动能力（需求侦察兵、反馈分析师、市场分析师可主动工作）。这不只是一个 skill——它是一套 AI 原生的产品开发方法论。
- **建议**：考虑将方法论部分（Agent 角色定义、工作流模式、质量门禁体系）独立为品牌化内容（博客系列、白皮书），吸引潜在用户。

### 机会 2：Agent 框架模板化输出

- **来源**：agents/ 目录 + templates/ 目录
- **置信度**：高
- **描述**：当前 13 个 Agent prompt 已高度标准化（80-400 行，含任务、输出、质量门禁、上下文管理四大必需章节）。这套标准化结构可以模板化，允许用户自定义 Agent 或创建行业特化版本（如金融产品、电商、SaaS）。
- **建议**：提供 Agent Builder 工具或文档，降低自定义门槛，扩展生态。

### 机会 3：多工具适配层可抽象为 SDK

- **来源**：docs/SKILL-CURSOR.md + docs/SKILL-CLAUDE-CODE.md + docs/SKILL-OTHER-TOOLS.md
- **置信度**：中
- **描述**：当前通过 .cursor/agents/ 薄封装 + .claude/agents/ 定义 + agents/ 真源的三层架构适配不同工具。这个模式可以抽象为一个轻量 SDK，自动为目标工具生成适配文件。
- **建议**：开发 `product-lifecycle init --tool=cursor|claude-code|opencode` 命令，一键生成工具适配文件。

### 机会 4：自驱动 Agent 是差异化壁垒

- **来源**：SKILL.md「自驱动能力」章节 + agents/proactive-scout.md
- **置信度**：高
- **描述**：需求侦察兵、反馈分析师、市场分析师的主动发现能力（不等待输入，主动搜索竞品、扫描市场、收集反馈）是当前 AI 编码工具生态中极为少见的能力。大多数 AI 工具仍是被动响应式的。
- **建议**：强化自驱动能力的演示和文档，作为核心卖点突出。

### 机会 5：国际化扩展潜力

- **来源**：docs/INTERNATIONALIZATION.md + README.md
- **置信度**：中
- **描述**：框架已支持中英文项目，Agent prompt 自动适配语言。但当前文档、README、CHANGELOG 均为中文，限制了国际用户获取。英文 README + 英文文档可打开全球市场。
- **建议**：优先产出英文版 README.md 和 QUICK-START.md。

---

## 三、威胁信号

### 威胁 1：docs/ 目录严重膨胀，迭代过程稿堆积

- **来源**：docs/ 目录文件列表
- **置信度**：高
- **严重度**：中
- **描述**：docs/ 目录包含 73 个文件，其中 46 个（63%）为历史迭代过程稿（SCOUT-001~006、FEEDBACK-001~006、MKT-001~005、PRD-002~005、ARCH-001~004、DEV-001~004、QA-002~005、QG-001~004、ITER-001~005 等）。这些文件是自进化迭代的副产物，但对新用户而言是噪音。
- **影响**：新用户打开 docs/ 目录会迷失在过程稿中，难以找到核心指南文档（QUICK-START、FAQ 等）。
- **建议**：将历史迭代过程稿移至 `docs/archive/` 或 `iterations/` 目录，docs/ 只保留核心指南。

### 威胁 2：README.md 表格格式损坏

- **来源**：README.md 第 110-129 行
- **置信度**：高
- **严重度**：低
- **描述**：README 中「13 个 Agent 角色」的两个表格使用了错误的分隔行格式 `| -----  ------`（缺少管道符），导致在 GitHub 上渲染为纯文本而非表格。这是项目的门面文档，格式损坏影响第一印象。
- **影响**：潜在用户在 GitHub 上浏览时无法正确阅读 Agent 角色表。
- **建议**：修复表格分隔行为 `| --- | --- | --- |`。

### 威胁 3：模板覆盖缺口（reviewer_template.md 缺失）

- **来源**：agents/reviewer.md（v2.2.0 新增）vs templates/ 目录
- **置信度**：高
- **严重度**：低
- **描述**：代码审查员（reviewer）在 v2.2.0 引入，但 templates/ 目录中没有对应的 reviewer_template.md。其他 12 个 Agent 均有专用模板。
- **影响**：使用代码审查员时缺少标准化输出格式指引。
- **建议**：补充 templates/reviewer_template.md。

### 威胁 4：模型配置硬编码为特定供应商

- **来源**：.claude/agents/ frontmatter
- **置信度**：中
- **严重度**：中
- **描述**：.claude/agents/ 中的 model 字段硬编码为 mimo-v2.5-pro 和 mimo-v2.5。CHANGELOG v2.4.0 记录了从 Claude 模型迁移到小米 Mimo 系列。虽然这解决了非 Claude API 的兼容性问题，但将模型绑定从一个供应商转移到了另一个供应商。
- **影响**：用户如果使用其他模型（如 GPT-4、Gemini），需要手动修改所有 agent 文件的 model 字段。
- **建议**：考虑将 model 配置提取为全局变量或配置文件，允许用户一次性指定。

---

## 四、行动建议

| 优先级 | 行动 | 预期收益 | 工作量 |
|--------|------|----------|--------|
| P0 | 修复 README.md 表格格式 | 改善项目门面，提升 GitHub 展示效果 | 5 分钟 |
| P0 | 补充 templates/reviewer_template.md | 模板覆盖 13/13 | 15 分钟 |
| P1 | 将 46 个历史迭代过程稿移至 docs/archive/ | docs/ 从 73 文件降至 27 文件，导航清晰 | 30 分钟 |
| P2 | 提取模型配置为全局变量 | 降低用户自定义成本 | 1 小时 |
| P3 | 产出英文版 README.md | 打开国际市场 | 2 小时 |

---

## 五、数据附录

### Agent 定义同步状态

| 目录 | 文件数 | 说明 |
|------|--------|------|
| agents/ | 13 | 真源，纯 prompt，无 frontmatter |
| .claude/agents/ | 13 | 独立维护，含 frontmatter + model 配置 |
| .cursor/agents/ | 13 + README | 薄封装，Read agents/ 真源 |

### 模板覆盖状态

| 模板 | 对应 Agent | 状态 |
|------|-----------|------|
| workflow_plan_template.md | 编排总监 | OK |
| market_template.md | 市场分析师 | OK |
| product_template.md | 产品经理 | OK |
| architecture_template.md | 架构师 | OK |
| developer_template.md | 开发工程师 | OK |
| qa_template.md | 测试经理 | OK |
| devops_template.md | 运维工程师 | OK |
| docwriter_template.md | 技术文档师 | OK |
| feedback_template.md | 反馈分析师 | OK |
| iteration_template.md | 迭代规划师 | OK |
| scout_template.md | 需求侦察兵 | OK |
| quality_report_template.md | 质量门禁 | OK |
| adr_template.md | 通用 | OK |
| reviewer_template.md | 代码审查员 | **缺失** |

### validate.sh 检查结果

```
SKILL.md frontmatter: OK
.claude/agents/ 数量: OK (13)
PRODUCT_PLAN 残留: 无残留
trends 2025 残留: 无残留
上下文管理覆盖: OK (13/13)
Agent 必需章节: OK
模板元数据: OK
Agent 行数范围: OK (全部在 80-400 行范围)
全部通过
```

---

*报告生成时间：2026-05-05 | 需求侦察兵 Agent*
