# ITER-002 迭代计划：product-lifecycle v1.7

| 字段 | 值 |
|------|-----|
| 版本 | v1.0（正式版） |
| 作者 | 迭代规划师 |
| 日期 | 2026-05-04 |
| 状态 | 已定稿 |
| 关联文档 | SCOUT-002-侦察报告-v1.5.md, FEEDBACK-002-反馈分析-v1.5.md, docs/WORKFLOW_PLAN.md, CHANGELOG.md（至 1.6.0） |

---

## 1. 迭代概述

### 1.1 迭代目标

> 在 v1.6 清理引用与索引修复的基础上，把工作流做成**可验证、可回滚、可分级控本**的实践：补齐官方最佳实践差距（model、checkpoint、hooks、MVD 文档），并降低跨工具（尤其 Cursor）上手摩擦。

### 1.2 版本号

> **v1.7.0**（minor：新指引与约定为主；不改变用户「先读 orchestrator」的主路径）

### 1.3 时间范围

> 2026-05-04 ~ 2026-05-11（约 1 周；可与实际发布日对齐）

---

## 2. 综合分析

### 2.1 输入来源

| 来源 | 文档 / 事实 | 关键发现 |
|------|----------------|----------|
| 反馈 | FEEDBACK-002 | FB007 仍部分；FB008–FB013 为 v1.6 后主要增量 |
| 侦察 | SCOUT-002 | v1.6 已处理 PRODUCT_PLAN/README；剩余：上下文指令进 Agent、门禁格式统一、QUICKSTART、双轨同步机制 |
| 版本事实 | CHANGELOG [1.6.0] | 引用清理与索引已完成；本轮不重复申报相同条目 |

### 2.2 优先级排序

| 优先级 | 主题 | 对应反馈 / 侦察 |
|--------|------|------------------|
| **P0** | Agent 失败后的标准处置与检查点约定 | FB009 |
| **P0** | Subagent `model` 按角色分级 + SKILL 中策略说明 | FB008（v1.6 虽已有 `model: sonnet`，但未分级） |
| **P1** | 文档「最低合格标准」（MVD）与健康检查升级 | FB010 |
| **P1** | WORKFLOW_PLAN / workflow_plan_template：错误处理章节 | FB009 |
| **P1** | SKILL 与 Subagent 协作边界（含简易流程说明） | FB012 |
| **P2** | CLAUDE.md / `@` 分层引用指引（可选文件或 docs 专章） | FB011 |
| **P2** | 质量门禁可自动化部分 + Hooks / settings 示例 | FB013 |
| **P2** | Cursor rules 与常见问题；OpenCode 步骤补强 | FB007 |
| **P2** | `docs/QUICKSTART.md`；scout_template 差距表示例行 | SCOUT-002 §5.2 |
| **P2** | agents/ 与 .claude/agents/ 同步检查（脚本或文档化 checklist） | SCOUT-002 |

---

## 3. 功能清单

### 3.1 功能列表

| ID | 功能名称 | 来源 | 优先级 | 工作量 | 验收标准 |
|----|----------|------|--------|--------|----------|
| F001 | Subagent `model` 分级 | FB008 | P0 | M | 各 `.claude/agents/*.md` 的 `model` 按角色为 haiku/sonnet/opus 之一；`SKILL.md` 或 `docs/SKILL-CLAUDE-CODE.md` 中有选择策略表 |
| F002 | 错误传播与检查点约定 | FB009 | P0 | M | `templates/workflow_plan_template.md`（及可选 `WORKFLOW_DETAILS.md`）含：失败记录、编排决策、重试/回滚/跳过规则；与质量门禁衔接 |
| F003 | 文档 MVD 与健康检查扩展 | FB010 | P1 | M | 在 `SKILL.md` 或 `WORKFLOW_DETAILS.md` 增加「最低合格文档」表（PRD/ARCH/QA 必填章节非空） |
| F004 | Skill vs Subagent 协作说明 | FB012 | P1 | S | `SKILL.md` 或 `docs/SKILL-CLAUDE-CODE.md` 新增专节：入口、隔离执行、工具边界、推荐调用顺序 |
| F005 | CLAUDE.md 分层与 `@` 引用指引 | FB011 | P2 | S | 新增 `docs/CLAUDE-LAYERING.md` 或在现有 Claude 文档中增加可执行示例 |
| F006 | Hooks / 自动化门禁示例 | FB013 | P2 | M | 仓库内 `examples/` 或 `docs/` 提供可复制片段（注明 Claude Code 版本差异） |
| F007 | Cursor / OpenCode 上手补强 | FB007 | P2 | M | README 或 `docs/SKILL-CURSOR.md` 含 rules 配置示例、常见问题 3+ 条 |
| F008 | QUICKSTART + 模板示例行 | SCOUT-002 | P2 | S | `docs/QUICKSTART.md` 存在；`templates/scout_template.md` 差距分析表至少 1 行示例 |
| F009 | 双轨 Agent 同步检查 | SCOUT-002 | P2 | M | `scripts/` 下脚本或 `docs/` 中发布 checklist：比对 `agents/` 与 `.claude/agents/` 文件名与职责一致性 |

### 3.2 Bug 修复

| ID | Bug 描述 | 严重度 | 影响范围 | 修复方案 |
|----|----------|--------|----------|----------|
| B001 | 无阻塞性缺陷（v1.6 已修复引用与索引） | — | — | 本轮以能力增强为主；若审查中发现死链再开 B00x |

### 3.3 技术任务

| ID | 任务描述 | 原因 | 影响范围 |
|----|----------|------|----------|
| T001 | 统一各 Agent prompt 中「质量门禁」呈现方式（checklist 或表格二选一） | SCOUT-002 | agents/ 与 .claude/agents/ |
| T002 | 在关键 Agent 中增加对 `docs/CONTEXT-MANAGEMENT.md` 的引用或摘要指令 | SCOUT-002 | 长文本协作质量 |

---

## 4. 影响分析

### 4.1 代码 / 内容影响

| 变更项 | 涉及路径 |
|--------|----------|
| F001 | `.claude/agents/*.md`, `SKILL.md` 或 `docs/SKILL-CLAUDE-CODE.md` |
| F002 | `templates/workflow_plan_template.md`, 可选 `docs/WORKFLOW_DETAILS.md` |
| F003 | `SKILL.md`, `docs/WORKFLOW_DETAILS.md` |
| F004–F007 | `SKILL.md`, `docs/SKILL-*.md`, `README.md`, `examples/*` |
| F008 | `docs/QUICKSTART.md`, `templates/scout_template.md` |
| F009 | `scripts/*` 或 `docs/` 发布清单 |
| T001–T002 | `agents/*.md`, `.claude/agents/*.md` |

### 4.2 测试影响

| 验证项 | 方法 | 通过标准 |
|--------|------|----------|
| model 分级 | 逐文件读 frontmatter | 无缺失；与策略表一致 |
| 无回归引用 | `rg PRODUCT_PLAN` | 仅历史文档/CHANGELOG 可出现 |
| 模板完整性 | 人工对照 workflow_plan_template | 含错误处理章节且编号连续 |
| 同步检查 | 运行脚本或按 checklist | 12 对文件职责无遗漏 |

### 4.3 文档影响

| 文档 | 变更类型 |
|------|----------|
| CHANGELOG.md | 新增 [1.7.0] |
| README / SKILL-CURSOR | 入口与 Cross-tool 指引 |
| 新建 QUICKSTART、可选 CLAUDE-LAYERING | Added |

---

## 5. 风险与缓解

| 风险 | 概率 | 影响 | 缓解方案 |
|------|------|------|----------|
| Hooks API 随 Claude Code 变更 | 中 | 中 | 示例标注版本；以「模式」而非强绑定 CLI |
| model 分级与团队习惯冲突 | 低 | 低 | 文档说明可全局改回 sonnet |
| 双轨同步脚本误报 | 中 | 低 | 先文档 checklist，脚本渐进增强 |

### 5.1 回滚方案

| 变更项 | 回滚方式 |
|--------|----------|
| 本轮整体 | `git revert` 合并提交或恢复 tag 前 commit |
| 仅 subagent model | `git checkout HEAD~1 -- .claude/agents/` |

---

## 6. 发布计划

### 6.1 发布步骤

| 步骤 | 内容 | 依赖 |
|------|------|------|
| 1 | 从 main 拉分支 `release/v1.7` | 无 |
| 2 | P0：F001 + F002（model + 错误处理模板） | 步骤 1 |
| 3 | P1：F003 + F004 + T001 + T002 | 步骤 2 |
| 4 | P2：F005–F009 按资源并行 | 步骤 1 |
| 5 | 汇总审查、更新 CHANGELOG、[1.7.0] | 步骤 2–4 |
| 6 | tag `v1.7.0` | 步骤 5 |

### 6.2 发布检查清单

- [ ] F001–F004 已完成或明确推迟到 v1.8（推迟项写入 CHANGELOG Unreleased）
- [ ] `templates/workflow_plan_template.md` 含错误处理与检查点描述
- [ ] CHANGELOG **[1.7.0]** 与日期
- [ ] `rg "PRODUCT_PLAN.md"` 无业务路径误引用
- [ ] README 或 SKILL 可见 QUICKSTART 入口（若已添加文件）
- [ ] 若本轮为「分角色执行」：`docs/ROLE-RUN-LOG-*.md` 可索引到侦察/反馈/市场/产品/架构/开发/测试/门禁等产出（至少六类）

---

## 7. 版本策略

选择 **v1.7.0**：新增工作流与工程化指引，无破坏性删除公共 API（本仓库为文档包，以用户路径兼容性为准）。

---

## 8. 修订记录

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v1.0 | 2026-05-04 | 迭代规划师 | 基于 v1.6 已交付事实 + FEEDBACK-002 / SCOUT-002 |

---

*迭代规划师签名：2026-05-04*  
*建议下轮：v1.8.0 — Agent 执行状态追踪、多项目并行、Teams 模式（见 FEEDBACK-002 Backlog）*
