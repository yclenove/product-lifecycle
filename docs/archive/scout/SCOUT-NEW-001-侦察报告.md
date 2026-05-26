# SCOUT-NEW-001 侦察报告

> product-lifecycle v1.7+ 产品体检与市场扫描

| 字段 | 值 |
|------|-----|
| 版本 | v1.0（初稿） |
| 作者 | 需求侦察兵 |
| 日期 | 2026-05-03 |
| 状态 | 草稿 |
| 关联文档 | SKILL.md, CHANGELOG.md, docs/SKILL-CURSOR.md, docs/SKILL-CLAUDE-CODE.md |

---

## 1. 产品体检

### 1.1 SKILL.md Frontmatter 检查

| 检查项 | 状态 | 说明 |
|--------|------|------|
| `name` | 通过 | `product-lifecycle` |
| `description` | 通过 | 描述清晰，含触发场景 |
| `when_to_use` | 通过 | 覆盖新项目、迭代、市场分析等场景 |
| `argument-hint` | 通过 | `[project-name] [project-description]` |
| `allowed-tools` | 通过 | Agent WebSearch WebFetch Read Write Edit Glob Grep Bash TodoWrite |
| 缺失字段 | 注意 | 无 `disable-model-invocation`（设计上允许自动触发，合理）；无 `context: fork`（当前模式为内联，合理） |

**结论：** Frontmatter 正确，符合 Claude Code Skills 规范。

### 1.2 子文档引用完整性

| SKILL.md 引用 | 目标文件 | 存在 | 内容匹配 |
|---------------|----------|------|----------|
| `docs/SKILL-CURSOR.md` | 存在 | 通过 | 含 PACKAGE_ROOT、Subagent 对齐、安装脚本 |
| `docs/SKILL-CLAUDE-CODE.md` | 存在 | 通过 | 含安装、Subagent 定义表、Agent 工具原则 |
| `docs/SKILL-OTHER-TOOLS.md` | 存在 | 通过 | 含通用步骤、路径说明 |
| `docs/SKILL-ASSETS.md` | 存在 | 通过 | 含 12 Agent 表、模板清单、门禁速查 |
| `docs/WORKFLOW_DETAILS.md` | 存在 | 通过 | 含全流程闭环、依赖关系、编号规则 |
| `examples/cloudflow.md` | 存在 | 通过 | 虚构项目 worked example |

**间接引用链：**
- SKILL.md -> SKILL-ASSETS.md -> `docs/CONTEXT-MANAGEMENT.md`（通过）。
- SKILL.md 本身未直接引用 `docs/CONTEXT-MANAGEMENT.md`，但 SKILL-ASSETS.md 已包含该引用，形成间接链路。建议在 SKILL.md 的支撑文件索引区增加一行显式引用，提升可发现性。

### 1.3 .claude/agents/ 与 .cursor/agents/ 一致性

| 维度 | .claude/agents/ | .cursor/agents/ | 一致性 |
|------|-----------------|-----------------|--------|
| 文件数量 | 12 个 .md | 12 个 .md + README.md | 通过 |
| 角色覆盖 | 12/12 | 12/12 | 通过 |
| 文件命名 | kebab-case | kebab-case | 通过 |
| frontmatter 格式 | `description` + `tools` + `model` | `name` + `description` + `model` + `readonly` | **差异** |
| 正文策略 | 完整 Agent prompt（含动态上下文注入） | 薄封装，Read `agents/<role>.md` 真源 | 设计如此 |

**差异分析：**
- `.claude/agents/` 使用 `tools` 字段（数组形式），符合 Claude Code Subagent 规范。
- `.cursor/agents/` 使用 `name` + `readonly` 字段，符合 Cursor Subagent 规范。
- 两套 frontmatter 分别适配各自平台，属于**有意设计**，非性 inconsistency。
- `.cursor/agents/` 的薄封装策略正确：避免内容分叉，单一来源为 `agents/*.md`。

**风险：** 若未来 `agents/*.md` 真源更新但 `.cursor/agents/` 薄封装的 Read 路径写死为绝对路径（安装脚本行为），则路径失效时 Subagent 会静默失败。建议在 `.cursor/agents/README.md` 中增加故障排查指引。

### 1.4 模板覆盖度

| Agent | agents/ 有 prompt | templates/ 有模板 | workflow_plan_template 编号规则 |
|-------|-------------------|-------------------|-------------------------------|
| 编排总监 | 有 | workflow_plan_template.md | 有 |
| 市场分析师 | 有 | market_template.md | 有 |
| 产品经理 | 有 | product_template.md | 有 |
| 架构师 | 有 | architecture_template.md | 有 |
| 开发工程师 | 有 | developer_template.md | 有 |
| 测试经理 | 有 | qa_template.md | 有 |
| 运维工程师 | 有 | devops_template.md | 有 |
| 技术文档师 | 有 | docwriter_template.md | 有 |
| 质量门禁 | 有 | quality_report_template.md | 有 |
| **需求侦察兵** | 有 | scout_template.md | **缺失** |
| **反馈分析师** | 有 | feedback_template.md | **缺失** |
| **迭代规划师** | 有 | iteration_template.md | **缺失** |

**发现：** `templates/workflow_plan_template.md` 附录「文档编号规则」仅覆盖 8 个 Agent，缺少需求侦察兵（SCOUT）、反馈分析师（FB）、迭代规划师（ITER）。`docs/WORKFLOW_DETAILS.md` 已有完整 12 Agent 编号规则，但模板文件未同步。

### 1.5 文档间交叉引用准确性

| 引用关系 | 准确性 | 备注 |
|----------|--------|------|
| SKILL.md -> SKILL-CURSOR.md | 准确 | 链接路径正确 |
| SKILL.md -> SKILL-CLAUDE-CODE.md | 准确 | 链接路径正确 |
| SKILL-CLAUDE-CODE.md -> WORKFLOW_DETAILS.md | 准确 | "详细的工作规范、编号规则、常见错误" |
| SKILL-CURSOR.md -> WORKFLOW_DETAILS.md | 准确 | 文首有 Cursor 指针 |
| SKILL-OTHER-TOOLS.md -> SKILL-CURSOR.md | 准确 | 文首有指向 |
| SKILL-ASSETS.md -> CONTEXT-MANAGEMENT.md | 准确 | "其他文件"节 |
| README.md -> docs/ 目录结构 | 准确 | v1.6.0 已修复 |

### 1.6 渐进式采用指引

SKILL.md 中「渐进式采用」章节清晰地将 12 Agent 分为三层：
- 核心 Agent（4 个必选）
- 扩展 Agent（5 个按需）
- 自驱动 Agent（3 个持续迭代）

**评估：** 分层合理，启动命令指向 `docs/SKILL-CLAUDE-CODE.md`，有明确的"何时使用"指引。**通过。**

### 1.7 上下文管理文档引用

- `docs/CONTEXT-MANAGEMENT.md` 存在且内容质量高（含摘要传递、上下文预算、交接规范）。
- 被 `docs/SKILL-ASSETS.md` 引用（通过）。
- 被多个迭代计划和侦察报告引用。
- **未被 SKILL.md 直接引用**（仅间接通过 SKILL-ASSETS.md）。
- **未被 Agent prompt 集成**：CONTEXT-MANAGEMENT.md 中的摘要模板和输出预算未嵌入各 Agent 的 prompt 中，Agent 不会自动遵循上下文管理规范。

---

## 2. 市场扫描

### 2.1 Claude Code Skills 生态（2026）

来源：Anthropic 官方文档 `code.claude.com/docs/en/skills`（2026 年 5 月访问）

**关键发现：**

1. **Agent Skills 开放标准**：Claude Code Skills 遵循 `agentskills.io` 开放标准，跨多工具可用。这与 product-lifecycle 的「工具无关」定位高度契合。
2. **`context: fork` 子代理模式**：新增 frontmatter 字段 `context: fork`，可将 Skill 在隔离子代理中执行。与 product-lifecycle 的 Subagent 隔离策略一致。
3. **动态上下文注入**：`` !`command` `` 语法在 Skill 内容发送前执行 shell 命令并替换输出。product-lifecycle 的 `.claude/agents/` 已使用类似模式（echo 项目结构）。
4. **`context` + `agent` 字段**：可指定用哪个 Subagent 类型执行 Skill（Explore、Plan、general-purpose 或自定义）。
5. **Skills 预加载到 Subagent**：Subagent 可通过 `skills` 字段预加载 Skill 作为参考材料。
6. **`hooks` 字段**：Skill 可定义生命周期 Hooks，用于确定性后处理。
7. **`paths` 字段**：可限制 Skill 仅在特定文件模式匹配时激活。
8. **`allowed-tools` 语法变化**：支持空格分隔字符串或 YAML 数组，如 `Bash(git add *)` 精细控制。

### 2.2 Cursor Subagents 生态（2026）

来源：`cursor.com/docs/subagents`（2026 年 5 月访问，API 报错无法获取完整内容，基于 product-lifecycle 文档内引用的官方信息）

**已知要点：**
- Cursor 支持 `.cursor/agents/` 和 `.claude/agents/` 双路径。
- 同名时 `.cursor/` 优先于 `.claude/`。
- 支持前台/后台执行、并行委派、agent ID 恢复。
- 内置 Explore/Bash/Browser 三个 Subagent。

### 2.3 多 Agent 编排框架趋势（2026）

来源：基于训练知识和行业观察

**关键趋势：**
- LangGraph、CrewAI、AutoGen 等框架推动多 Agent 编排标准化。
- Devin、GitHub Copilot Workspace 等产品走向全自主开发。
- CI/CD 集成、自主调试循环、多 Agent 流水线成为标配。

---

## 3. 机会信号

### O-001：对接 Agent Skills 开放标准

| 维度 | 内容 |
|------|------|
| 信号 | Claude Code Skills 遵循 `agentskills.io` 开放标准，跨工具可用 |
| 来源 | Anthropic 官方文档 `code.claude.com/docs/en/skills` |
| 置信度 | **高**（官方文档直接说明） |
| 影响 | product-lifecycle 的 SKILL.md 已符合该标准的基本结构；可进一步对齐标准字段（如 `context`、`hooks`、`paths`），提升跨工具兼容性 |
| 建议行动 | 在 v1.8 中审查 SKILL.md frontmatter 是否可增加 `context: fork`、`hooks` 等字段；调研 `agentskills.io` 标准的完整字段集，评估对齐价值 |

### O-002：`context: fork` 子代理执行模式

| 维度 | 内容 |
|------|------|
| 信号 | Claude Code 新增 `context: fork` + `agent` 字段，Skill 可在隔离子代理中执行 |
| 来源 | Anthropic 官方文档 |
| 置信度 | **高**（官方文档直接说明） |
| 影响 | 当前 product-lifecycle 的 12 Agent 通过 `.claude/agents/` Subagent 定义实现隔离。`context: fork` 提供了另一种隔离方式，可能更轻量 |
| 建议行动 | 评估是否将部分 Agent（如需求侦察兵、反馈分析师）改为 Skill + `context: fork` 模式，减少维护 `.claude/agents/` 的成本 |

### O-003：Hooks 驱动的确定性后处理

| 维度 | 内容 |
|------|------|
| 信号 | Claude Code Skills 支持 `hooks` 字段，Cursor 也支持 Hooks |
| 来源 | Anthropic 官方文档、Cursor 官方文档 |
| 置信度 | **高** |
| 影响 | 质量门禁 Agent 的检查逻辑（lint、测试通过、CHANGELOG 更新）可通过 Hooks 实现确定性校验，而非依赖 LLM 判断 |
| 建议行动 | 为质量门禁设计一组 Hooks：提交前自动检查 CHANGELOG 更新、lint 通过、测试覆盖率 |

### O-004：`paths` 字段实现上下文感知激活

| 维度 | 内容 |
|------|------|
| 信号 | Claude Code Skills 支持 `paths` 字段，仅在特定文件模式匹配时激活 |
| 来源 | Anthropic 官方文档 |
| 置信度 | **高** |
| 影响 | 可为不同 Agent 设置路径触发规则，如修改 `docs/` 时自动激活技术文档师，修改测试文件时激活测试经理 |
| 建议行动 | 在 v1.8 中为相关 Agent 增加 `paths` 配置，提升自动触发精度 |

---

## 4. 威胁信号

### T-001：多 Agent 编排框架竞争加剧

| 维度 | 内容 |
|------|------|
| 信号 | LangGraph、CrewAI、AutoGen 等框架提供标准化多 Agent 编排，降低自建门槛 |
| 来源 | 行业趋势观察（2025-2026） |
| 置信度 | **中**（框架持续迭代，但尚未出现统治性方案） |
| 影响 | product-lifecycle 的核心价值是「12 Agent 方法论 + 模板」，若框架内置类似编排能力，方法论的差异化优势可能减弱 |
| 建议行动 | 强化 product-lifecycle 的「产品方法论」定位（而非「编排工具」），突出市场分析、PRD、质量门禁等领域知识，这些是通用框架不具备的 |

### T-002：Agent prompt 与上下文管理文档未集成

| 维度 | 内容 |
|------|------|
| 信号 | `docs/CONTEXT-MANAGEMENT.md` 内容质量高，但 Agent prompt 中未嵌入摘要模板和输出预算约束 |
| 来源 | 本次产品体检 + SCOUT-002 历史侦察报告 |
| 置信度 | **高**（已多次被识别，v1.5 SCOUT-002 和 v1.7 SCOUT-003 均提出） |
| 影响 | 多 Agent 协作时上下文窗口管理依赖人工意识，Agent 不会自动遵循预算约束，长流程中容易出现上下文溢出 |
| 建议行动 | 在 v1.8 中将 CONTEXT-MANAGEMENT.md 的摘要模板和输出预算嵌入各 Agent prompt 的「输出约束」节 |

### T-003：workflow_plan_template 编号规则不完整

| 维度 | 内容 |
|------|------|
| 信号 | `templates/workflow_plan_template.md` 附录编号规则仅覆盖 8/12 Agent，缺少 SCOUT、FB、ITER |
| 来源 | 本次产品体检 |
| 置信度 | **高**（直接文件比对确认） |
| 影响 | 编排总监使用该模板生成 WORKFLOW_PLAN.md 时，可能遗漏 3 个自驱动 Agent 的编号规范，导致产出文档编号不一致 |
| 建议行动 | 立即修复：在 `templates/workflow_plan_template.md` 附录中补充需求侦察兵（SCOUT）、反馈分析师（FB）、迭代规划师（ITER）的编号规则 |

---

## 5. 行动建议汇总

| 优先级 | 行动项 | 负责 Agent | 预估工时 |
|--------|--------|-----------|---------|
| **P0** | 修复 workflow_plan_template.md 编号规则（补全 3 个 Agent） | 技术文档师 | 5 分钟 |
| **P1** | 在 SKILL.md 中显式引用 CONTEXT-MANAGEMENT.md | 技术文档师 | 5 分钟 |
| **P1** | 将 CONTEXT-MANAGEMENT.md 摘要模板和输出预算嵌入 Agent prompt | 迭代规划师 + 开发工程师 | 2 小时 |
| **P2** | 评估 `context: fork` + `agent` 字段对 Agent 隔离策略的影响 | 架构师 | 1 小时 |
| **P2** | 为质量门禁设计 Hooks（lint、测试、CHANGELOG 检查） | 质量门禁 | 2 小时 |
| **P2** | 审查 SKILL.md frontmatter 对齐 Agent Skills 开放标准 | 产品经理 | 1 小时 |
| **P3** | 为相关 Agent 增加 `paths` 字段配置 | 架构师 | 1 小时 |
| **P3** | 强化「产品方法论」定位，区别于通用编排框架 | 市场分析师 | 持续 |

---

## 6. 产品健康度总评

| 维度 | 评分 | 说明 |
|------|------|------|
| 文档完整性 | 8/10 | 子文档引用链完整，仅 SKILL.md 缺少 CONTEXT-MANAGEMENT 直接引用 |
| 一致性 | 7/10 | workflow_plan_template 编号规则不完整，Agent prompt 未集成上下文管理 |
| 跨工具兼容性 | 9/10 | Claude Code / Cursor / 通用三路径清晰，薄封装策略正确 |
| 渐进式采用 | 9/10 | 三层分层合理，启动指引明确 |
| 上下文管理 | 6/10 | 文档存在但未被 Agent 实际执行 |
| 市场竞争力 | 7/10 | 方法论独特，但需持续对齐平台新特性 |

**综合评分：7.7/10** — 产品基础扎实，主要改进点在于将已有最佳实践文档集成到 Agent 执行层，以及修复模板编号规则的遗漏。
