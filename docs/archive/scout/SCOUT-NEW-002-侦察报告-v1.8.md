# SCOUT-NEW-002 侦察报告

> product-lifecycle v1.8 变更验证与残留问题扫描

| 字段 | 值 |
|------|-----|
| 版本 | v1.0（初稿） |
| 作者 | 需求侦察兵 |
| 日期 | 2026-05-03 |
| 状态 | 草稿 |
| 关联文档 | SKILL.md, CHANGELOG.md, docs/SKILL-ASSETS.md, templates/workflow_plan_template.md, .claude/agents/ |

---

## 1. v1.8 变更验证

### 1.1 SKILL.md Frontmatter

| 检查项 | 预期 | 实际 | 状态 |
|--------|------|------|------|
| `name:` 字段 | `name:`（非 `## name:`） | 第 2 行 `name: product-lifecycle` | 通过 |
| 关闭 `---` | frontmatter 末尾有 `---` | 第 7 行 `---` | 通过 |
| `description` | 存在 | 第 3 行，含触发场景 | 通过 |
| `when_to_use` | 存在 | 第 4 行，覆盖新项目、迭代等场景 | 通过 |
| `argument-hint` | 存在 | 第 5 行 `[project-name] [project-description]` | 通过 |
| `allowed-tools` | 存在 | 第 6 行，10 个工具 | 通过 |

**结论：** Frontmatter 修复成功，符合 Claude Code Skills 规范。

### 1.2 文档健康检查表

| 检查项 | 预期 | 实际 | 状态 |
|--------|------|------|------|
| 表头列数 | 4 列（Agent / 必需文档 / 缺失时行动 / 质量不达标时） | 4 列，第 91 行 | 通过 |
| "质量不达标时" 列 | 有实质内容 | 7 个 Agent 均有对应行动 | 通过 |
| 行数 | 7 行（编排总监、架构师、开发、测试、运维、技术文档、迭代规划） | 7 行 | 通过 |

**结论：** 健康检查表新增列完整，内容合理。

### 1.3 CONTEXT-MANAGEMENT 引用

| 检查项 | 预期 | 实际 | 状态 |
|--------|------|------|------|
| SKILL.md 直接引用 | 引用 `docs/CONTEXT-MANAGEMENT.md` | 第 155 行，直接引用 | 通过 |
| SKILL-ASSETS.md 引用 | 引用 `docs/CONTEXT-MANAGEMENT.md` | 第 90 行 | 通过 |
| 文件存在性 | `docs/CONTEXT-MANAGEMENT.md` 存在 | 存在 | 通过 |

**结论：** SKILL.md 已从间接引用升级为直接引用，可发现性提升。

**遗留：** SCOUT-NEW-001 指出的 "Agent prompt 未嵌入上下文管理摘要模板和输出预算" 仍未解决（见本报告 T-001）。

### 1.4 workflow_plan_template.md 编号规则

| 检查项 | 预期 | 实际 | 状态 |
|--------|------|------|------|
| SCOUT 编号 | 附录中有需求侦察兵 | 第 237 行 `SCOUT-001-侦察报告` | 通过 |
| FB 编号 | 附录中有反馈分析师 | 第 238 行 `FB-001-反馈分析` | 通过 |
| ITER 编号 | 附录中有迭代规划师 | 第 239 行 `ITER-001-迭代计划` | 通过 |
| 编号规则表总行数 | 11 行（不含表头） | 11 行 | 通过 |

**结论：** SCOUT-NEW-001 T-003 已修复，编号规则从 8/12 补全至 12/12。

### 1.5 .claude/agents/ model 字段三级分布

| 模型 | Agent | 文件数 | 状态 |
|------|-------|--------|------|
| opus | orchestrator, architect | 2 | 通过 |
| sonnet | developer, devops, feedback-analyst, iteration-planner, market-analyst, proactive-scout, product-manager, qa-manager | 8 | 通过 |
| haiku | docwriter, quality-gatekeeper | 2 | 通过 |

**分布合理性评估：**
- opus（2 个）：全局协调 + 复杂推理，合理
- sonnet（8 个）：常规任务 + 代码实现，合理
- haiku（2 个）：模式固定、低复杂度，合理

**结论：** 三级分布与 SKILL-ASSETS.md 模型选择策略表一致。

### 1.6 SKILL-ASSETS.md 模型选择策略

| 检查项 | 预期 | 实际 | 状态 |
|--------|------|------|------|
| 模型选择策略表 | 存在 | 第 82-86 行，含 opus/sonnet/haiku 三行 | 通过 |
| Agent 分配与 .claude/agents/ 一致 | 12 个 Agent 全覆盖 | 覆盖 12/12 | 通过 |
| 适用场景描述 | 每个模型有场景说明 | 有 | 通过 |

**结论：** 模型选择策略表完整，与 .claude/agents/ 实际配置一致。

### 1.7 CHANGELOG.md

| 检查项 | 预期 | 实际 | 状态 |
|--------|------|------|------|
| v1.8.0 条目 | 存在 | 第 11 行 `[1.8.0] - 2026-05-04` | 通过 |
| Fixed 分类 | 有 | frontmatter、编号规则、CHANGELOG 清理 | 通过 |
| Changed 分类 | 有 | model 分级、健康检查表、CONTEXT-MANAGEMENT 引用、模型策略 | 通过 |
| [Unreleased] | 清空 | 第 9 行仅 `<!-- 下一版本条目写于此 -->` | 通过 |
| 版本记录完整性 | v1.0-v1.8 连续 | 连续，无缺失 | 通过 |

**结论：** CHANGELOG 版本记录完整，Unreleased 已清空。

---

## 2. 残留问题扫描

### 2.1 .cursor/agents/ 与 .claude/agents/ model 字段同步

| 维度 | .claude/agents/ | .cursor/agents/ | 差异 |
|------|-----------------|-----------------|------|
| model 字段 | 显式指定（opus/sonnet/haiku） | 全部 `model: inherit` | **差异** |

**分析：**
- `.cursor/agents/` 使用 `model: inherit` 是 Cursor 平台的合理默认——继承工作区当前模型。
- `.claude/agents/` 显式指定模型是 Claude Code 的最佳实践——确保复杂任务用强模型。
- 两套策略分别适配各自平台，属于**有意设计差异**，非性 inconsistency。

**建议：** 无需同步。但建议在 `docs/SKILL-CURSOR.md` 中补充说明：Cursor 用户可通过修改 `.cursor/agents/*.md` 的 `model` 字段覆盖继承值，以获得与 Claude Code 相同的模型分配效果。

### 2.2 文档间交叉引用准确性

| 引用关系 | 准确性 | 备注 |
|----------|--------|------|
| SKILL.md -> SKILL-CURSOR.md | 准确 | 第 22 行 |
| SKILL.md -> SKILL-CLAUDE-CODE.md | 准确 | 第 23 行 |
| SKILL.md -> SKILL-OTHER-TOOLS.md | 准确 | 第 24 行 |
| SKILL.md -> SKILL-ASSETS.md | 准确 | 第 27、151 行 |
| SKILL.md -> WORKFLOW_DETAILS.md | 准确 | 第 153 行 |
| SKILL.md -> CONTEXT-MANAGEMENT.md | 准确 | 第 155 行（v1.8 新增直接引用） |
| SKILL.md -> examples/cloudflow.md | 准确 | 第 158 行 |
| SKILL-ASSETS.md -> CONTEXT-MANAGEMENT.md | 准确 | 第 90 行 |
| SKILL-ASSETS.md -> examples/cloudflow.md | 准确 | 第 91 行 |
| README.md -> docs/ 目录结构 | 准确 | 目录树与实际一致 |

**结论：** 核心文档交叉引用全部正确。

### 2.3 SKILL-ASSETS.md Markdown 格式问题

**发现：** 第 90-91 行的 markdown 格式有误：

```
- `**docs/CONTEXT-MANAGEMENT.md`** — ...
- `**examples/cloudflow.md`** — ...
```

正确格式应为：

```
- **`docs/CONTEXT-MANAGEMENT.md`** — ...
- **``examples/cloudflow.md`** — ...
```

当前格式中，反引号包裹了 `**` 的一部分，导致渲染时加粗和代码样式混合异常。

**影响：** 低——功能不受影响，但渲染效果不佳。

### 2.4 模板中的年份过期

**发现：** `templates/market_template.md` 第 34 行：

```
> **调研要求：** 使用 WebSearch 搜索 "[领域] market size"、"[领域] market report 2025" 等关键词
```

当前为 2026 年，搜索关键词中的 `2025` 应更新为 `2026`。

**影响：** 中——Agent 使用该模板时，搜索结果可能返回过时数据。

### 2.5 README.md 目录结构树

**发现：** README.md 目录树中 `scripts/` 部分（第 192-193 行）仅列出 `detect.sh`，缺少 v1.7 新增的两个安装脚本：

```
├── scripts/              # 工具脚本
│   └── detect.sh         # 项目自动检测
```

实际 scripts/ 目录包含：
- `detect.sh`
- `install-cursor-subagents.ps1`（v1.7 新增）
- `install-cursor-subagents.sh`（v1.7 新增）

**影响：** 中——用户查看 README 目录树时无法发现安装脚本。

### 2.6 Agent prompt 未集成上下文管理规范

**持续遗留（SCOUT-NEW-001 T-002）：**

`docs/CONTEXT-MANAGEMENT.md` 内容质量高，但各 Agent prompt（`agents/*.md` 和 `.claude/agents/*.md`）中未嵌入摘要模板和输出预算约束。SKILL.md v1.8 已增加直接引用，但引用仅是"知道有这个文档"，Agent 不会自动执行其中的规范。

**影响：** 高——多 Agent 长流程协作时，上下文窗口管理依赖人工意识。

---

## 3. 机会信号

### O-001：Cursor model 字段显式化

| 维度 | 内容 |
|------|------|
| 信号 | `.cursor/agents/` 全部使用 `model: inherit`，未利用 Cursor 支持的显式 model 指定能力 |
| 来源 | 本次侦察 |
| 置信度 | **中**（取决于 Cursor 对 model 字段的支持程度） |
| 影响 | 若 Cursor 支持显式 model 指定，则可将 .claude/agents/ 的三级模型策略同步到 .cursor/agents/，获得一致的性能/成本平衡 |
| 建议行动 | 验证 Cursor model 字段是否支持 opus/sonnet/haiku 值；若支持，在 .cursor/agents/ 中同步模型分配 |

### O-002：docs/ 过程稿清理与归档

| 维度 | 内容 |
|------|------|
| 信号 | docs/ 目录下有大量过程稿文件（SCOUT-001~006、FEEDBACK-001~006、MKT-001~005 等），共 50+ 文件 |
| 来源 | 本次侦察 |
| 置信度 | **高** |
| 影响 | 过程稿与正式文档混杂，新用户难以区分哪些是当前有效的参考文档。docs/ 目录膨胀也会降低导航效率 |
| 建议行动 | 将历史过程稿移至 `docs/archive/` 子目录，仅保留最新版本和正式文档在 docs/ 根目录；或在 docs/ 根目录增加 INDEX.md 索引 |

### O-003：质量门禁 Hooks 自动化

| 维度 | 内容 |
|------|------|
| 信号 | SCOUT-NEW-001 O-003 提出的 Hooks 驱动质量门禁方案未被 v1.8 采纳 |
| 来源 | SCOUT-NEW-001 + 本次侦察确认 |
| 置信度 | **高** |
| 影响 | 质量门禁检查（CHANGELOG 更新、lint、测试覆盖率）仍依赖 LLM 判断，存在遗漏风险 |
| 建议行动 | 在 v1.9 中为质量门禁设计 pre-commit Hooks：自动检查 CHANGELOG 是否更新、lint 是否通过、测试覆盖率是否达标 |

### O-004：SKILL-ASSETS.md 作为统一配置入口

| 维度 | 内容 |
|------|------|
| 信号 | SKILL-ASSETS.md 已包含模型选择策略表，可扩展为 Agent 行为的统一配置入口 |
| 来源 | 本次侦察 |
| 置信度 | **中** |
| 影响 | 当前 Agent 行为配置分散在各 Agent prompt 中（输出约束、质量标准等），若集中在 SKILL-ASSETS.md 维护，可降低跨文件一致性维护成本 |
| 建议行动 | 评估将 Agent 的输出约束、上下文预算等配置项统一到 SKILL-ASSETS.md 的可行性 |

---

## 4. 威胁信号

### T-001：上下文管理规范仍未嵌入 Agent 执行层

| 维度 | 内容 |
|------|------|
| 信号 | SCOUT-NEW-001 T-002 和 SCOUT-002（v1.5）均指出此问题，v1.8 仅增加 SKILL.md 直接引用，未解决根本问题 |
| 来源 | SCOUT-NEW-001 T-002、SCOUT-002、本次侦察确认 |
| 置信度 | **高**（连续 3 次侦察报告均指出） |
| 影响 | 12 Agent 长流程协作时，上下文窗口溢出风险持续存在。尤其在模式 A（从 0 到 1）全流程中，编排总监需要协调 8+ Agent，上下文管理至关重要 |
| 建议行动 | 在 v1.9 中将 CONTEXT-MANAGEMENT.md 的核心约束（摘要模板、输出预算、交接规范）嵌入各 Agent prompt 的「输出约束」节，或在 SKILL.md 中增加全局上下文管理指令 |

### T-002：market_template 搜索关键词年份过期

| 维度 | 内容 |
|------|------|
| 信号 | `templates/market_template.md` 第 34 行搜索关键词为 `2025`，当前为 2026 年 |
| 来源 | 本次侦察 |
| 置信度 | **高**（直接文件验证） |
| 影响 | 市场分析师使用该模板时，WebSearch 返回的结果可能偏向 2025 年数据，影响市场分析的时效性 |
| 建议行动 | 立即修复：将 `2025` 更新为 `2026`；建议在模板中使用 `{{CURRENT_YEAR}}` 占位符或注释提醒维护者更新年份 |

### T-003：README 目录结构树与实际不一致

| 维度 | 内容 |
|------|------|
| 信号 | README.md scripts/ 部分缺少 `install-cursor-subagents.ps1` 和 `install-cursor-subagents.sh` |
| 来源 | 本次侦察 |
| 置信度 | **高**（直接文件比对） |
| 影响 | 用户查看 README 时无法发现 Cursor 安装脚本，可能手动创建 .cursor/agents/ 而非使用自动化脚本 |
| 建议行动 | 更新 README.md 目录树，补充两个安装脚本 |

### T-004：SKILL-ASSETS.md Markdown 格式瑕疵

| 维度 | 内容 |
|------|------|
| 信号 | 第 90-91 行反引号与加粗标记嵌套错误 |
| 来源 | 本次侦察 |
| 置信度 | **高**（直接文件验证） |
| 影响 | 渲染时代码样式和加粗混合，影响文档专业度 |
| 建议行动 | 修复为 `` **`path`** `` 格式 |

---

## 5. v1.8 迭代质量评估

### SCOUT-NEW-001 建议采纳情况

| 原建议 | 优先级 | v1.8 是否采纳 | 说明 |
|--------|--------|--------------|------|
| 修复 workflow_plan_template 编号规则 | P0 | **已采纳** | SCOUT、FB、ITER 三个编号已补全 |
| SKILL.md 显式引用 CONTEXT-MANAGEMENT.md | P1 | **已采纳** | 第 155 行直接引用 |
| 将上下文管理嵌入 Agent prompt | P1 | **未采纳** | 仅增加引用，未嵌入执行层 |
| 评估 `context: fork` | P2 | **未采纳** | 下一迭代评估 |
| 为质量门禁设计 Hooks | P2 | **未采纳** | 下一迭代评估 |
| 审查 frontmatter 对齐开放标准 | P2 | **部分采纳** | frontmatter 已修复，但未新增 `context`、`hooks` 等字段 |
| 增加 `paths` 字段 | P3 | **未采纳** | 下一迭代评估 |

**v1.8 迭代评价：** 聚焦于文档修复和模型策略，完成了 P0 和部分 P1 建议。P2/P3 建议合理延后。迭代节奏健康。

### 产品健康度总评

| 维度 | v1.7 评分 | v1.8 评分 | 变化 | 说明 |
|------|-----------|-----------|------|------|
| 文档完整性 | 8/10 | 9/10 | +1 | SKILL.md 直接引用 CONTEXT-MANAGEMENT.md；健康检查表新增列 |
| 一致性 | 7/10 | 8/10 | +1 | 编号规则补全 12/12；frontmatter 修复 |
| 跨工具兼容性 | 9/10 | 9/10 | 不变 | 三路径清晰 |
| 渐进式采用 | 9/10 | 9/10 | 不变 | 三层分层合理 |
| 上下文管理 | 6/10 | 7/10 | +1 | 直接引用提升可发现性，但仍未嵌入执行层 |
| 模型策略 | N/A | 8/10 | 新增 | 三级分布合理，与 SKILL-ASSETS.md 一致 |

**综合评分：8.3/10**（v1.7 为 7.7/10）

---

## 6. 行动建议汇总

| 优先级 | 行动项 | 负责 Agent | 预估工时 |
|--------|--------|-----------|---------|
| **P0** | 修复 market_template.md 年份（2025 -> 2026） | 技术文档师 | 2 分钟 |
| **P0** | 修复 SKILL-ASSETS.md 第 90-91 行 Markdown 格式 | 技术文档师 | 2 分钟 |
| **P1** | 更新 README.md 目录树（补充 scripts/ 安装脚本） | 技术文档师 | 5 分钟 |
| **P1** | 将 CONTEXT-MANAGEMENT.md 核心约束嵌入 Agent prompt | 迭代规划师 + 开发工程师 | 2 小时 |
| **P2** | 评估 .cursor/agents/ model 字段显式化可行性 | 架构师 | 30 分钟 |
| **P2** | docs/ 过程稿归档（移至 archive/ 子目录） | 技术文档师 | 30 分钟 |
| **P2** | 为质量门禁设计 pre-commit Hooks | 质量门禁 | 2 小时 |
| **P3** | 评估 SKILL-ASSETS.md 作为统一配置入口的可行性 | 架构师 | 1 小时 |

---

## 7. 下轮侦察重点

1. **上下文管理执行层集成**：验证 Agent prompt 是否已嵌入 CONTEXT-MANAGEMENT.md 核心约束
2. **Hooks 自动化**：验证质量门禁 Hooks 设计与实现
3. **Cursor model 显式化**：验证 .cursor/agents/ 是否支持显式 model 指定
4. **docs/ 归档**：验证过程稿是否已归档，docs/ 导航是否改善
5. **agentskills.io 标准对齐**：验证 SKILL.md frontmatter 是否对齐开放标准
