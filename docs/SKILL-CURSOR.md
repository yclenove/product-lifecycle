# Cursor 中的用法

本文件供根目录 `SKILL.md` 与 `.cursor/skills/product-lifecycle/SKILL.md` 引用；**Cursor 与 Claude Code 对齐的权威展开见本文件**。内容已与 [Cursor 官方文档：Subagents](https://cursor.com/docs/subagents)（及其中 Skills / Hooks 链接）校对；**功能名与菜单以你本机 Cursor 版本为准**（Subagents 能力自 2.4 起在文档站系统化描述）。

---

## 技能包根目录（PACKAGE_ROOT）

本仓库是**可安装的技能包**；业务工作区打开在别的目录时，`agents/`、`templates/` **不在**当前工作区根下也属正常。在 Cursor 中读取 prompt 与模板前，必须先解析 **PACKAGE_ROOT**（本技能包在磁盘上的根目录），**禁止**默认用「工作区相对路径」去读 `agents/…`（除非已判定 PACKAGE_ROOT 就是工作区根）。

按顺序确定 `PACKAGE_ROOT`：

1. 环境变量 `**PRODUCT_LIFECYCLE_ROOT`**：若已设置且该目录下存在 `agents/orchestrator.md`，则 `PACKAGE_ROOT` 取该目录（推荐全局安装后配置一次）。
2. 若工作区根下存在 `**agents/orchestrator.md**`：视为正在以本仓库为工作区打开 → `PACKAGE_ROOT` = 工作区根。
3. 否则在工作区内搜索 `**agents/orchestrator.md**`（嵌套目录如 `.product-lifecycle/`）：命中路径为 `…/agents/orchestrator.md` 时，`PACKAGE_ROOT` = 含 `agents` 目录的那一层上级（与 `agents`、`templates` 同级的那棵树的根）。
4. 若仍无法确定：向用户询问本仓库在本机的路径，在本对话中沿用为 `PACKAGE_ROOT`。

之后所有 **Read** 使用：`{PACKAGE_ROOT}/agents/…`、`{PACKAGE_ROOT}/templates/…`、`{PACKAGE_ROOT}/docs/…`。**产出物**（如 `docs/MKT-001-…`）默认写在**当前业务工作区**，除非用户另有指定。

---

## 全局安装（任意项目可用）

将本仓库克隆到 Cursor 个人技能目录，使该目录下同时存在根 `SKILL.md` 与 `agents/`、`templates/`：

```bash
# Windows PowerShell
git clone https://github.com/yclenove/product-lifecycle.git "$env:USERPROFILE\.cursor\skills\product-lifecycle"

# macOS / Linux
git clone https://github.com/yclenove/product-lifecycle.git ~/.cursor/skills/product-lifecycle
```

建议同时设置用户或系统环境变量 `**PRODUCT_LIFECYCLE_ROOT**` 指向上述路径，避免个别环境下解析歧义。

---

## 新业务项目：能否「自动」添加 Subagent？

**不能。** Cursor / Agent Skills **不会在**你新建或打开业务仓库时**静默**写入 `.cursor/agents/`（没有类似 `npm install` 的全局 post-install 钩子）。

**推荐做法（一键、半自动）：** 设置好 `PRODUCT_LIFECYCLE_ROOT` 后，在**新业务项目根目录**执行一次安装脚本，会创建 `业务项目/.cursor/agents/*.md`，并把各 Subagent 中的 `` `agents/ ``、`` `templates/ `` 替换为技能包**绝对路径**，然后重载 Cursor 即可用 `/orchestrator` 等。

**Windows（PowerShell）：**

```powershell
$env:PRODUCT_LIFECYCLE_ROOT = "$env:USERPROFILE\.cursor\skills\product-lifecycle"
pwsh -File "$env:PRODUCT_LIFECYCLE_ROOT\scripts\install-cursor-subagents.ps1" -Target "H:\path\to\new-app"
```

**macOS / Linux：**

```bash
export PRODUCT_LIFECYCLE_ROOT="$HOME/.cursor/skills/product-lifecycle"
bash "$PRODUCT_LIFECYCLE_ROOT/scripts/install-cursor-subagents.sh" /path/to/new-app
```

脚本仓库路径：`scripts/install-cursor-subagents.ps1`、`scripts/install-cursor-subagents.sh`。更多说明见 **`.cursor/agents/README.md`**。

---

## 项目内技能入口

若仅以本仓库为工作区开发：可使用 `.cursor/skills/product-lifecycle/SKILL.md`（与根 `SKILL.md` 共享同一套 `PACKAGE_ROOT` 规则；执行指引见本文件）。

**本仓库已自带参考实现：** 根目录下 **`.cursor/agents/*.md`**（12 个角色 + `README.md`）。以本仓库为工作区打开时，可在 Agent 输入框使用 **`/orchestrator`**、**`/market-analyst`** 等调用（与 [官方说明：Explicit invocation](https://cursor.com/docs/subagents) 一致）。与 `.claude/agents/` 同名时，Cursor **优先**加载 `.cursor/agents/`。

---

## Cursor 官方机制摘要（与 product-lifecycle 对齐）

以下要点摘自 [Subagents 官方文档](https://cursor.com/docs/subagents)，便于与下文「对齐 Claude Code」一节对照。

### Subagent 是什么

- 主 **Agent** 可将任务**委派**给 Subagent；每个 Subagent **独立上下文**，完成后把结果交回父 Agent。
- 适用于：**长研究**、**并行工作流**、**领域专精多步任务**；简单一步动作可优先考虑 [Skill](https://cursor.com/docs/skills.md)（与本仓库根 `SKILL.md` 的「方法论入口」不同：官方 Skill 指 Cursor 的 `SKILL.md` 能力单元，见官方文档区分）。

### 内置 Subagent（无需配置）


| 名称（概念）      | 用途                       |
| ----------- | ------------------------ |
| **Explore** | 代码库搜索与分析（默认更快模型、可并行搜索）   |
| **Bash**    | 串联 shell；隔离冗长输出          |
| **Browser** | 通过 MCP 控制浏览器；隔离 DOM/截图噪声 |


编排多角色时，仍可让主 Agent 自动使用上述能力；**产品生命周期 12 角色**用下文**自定义** Subagent 承载。

### 自定义 Subagent 的存放位置（官方）


| 类型             | 路径                    | 范围       |
| -------------- | --------------------- | -------- |
| 项目级            | `**.cursor/agents/`** | 仅当前项目    |
| 项目级（Claude 兼容） | `**.claude/agents/**` | 仅当前项目    |
| 用户级            | `~/.cursor/agents/`   | 当前用户所有项目 |
| 用户级（Claude 兼容） | `~/.claude/agents/`   | 同上       |


**同名冲突时**：官方说明 `**.cursor/` 优先于** `.claude/` / `.codex/`。

因此：**本仓库自带的 `.claude/agents/`** 在「以本仓库为工作区」时，可被 Cursor 作为 **Claude 兼容** Subagent 定义加载；业务项目若同时维护 `.cursor/agents/` 与 `.claude/agents/`，注意命名不要无意冲突。

### 文件格式（官方）

每个 Subagent 为一个 **Markdown 文件**，顶部为 **YAML frontmatter**，正文为提示词。常用字段：


| 字段              | 必填  | 默认        | 说明                                                                       |
| --------------- | --- | --------- | ------------------------------------------------------------------------ |
| `name`          | 否   | 来自文件名     | 小写与连字符；展示名与标识                                                            |
| `description`   | 否   | —         | **强烈建议写清**：主 Agent 依此决定是否自动委派；可用 “Use proactively when…” 等措辞             |
| `model`         | 否   | `inherit` | `inherit` 或与父级不同的 [模型 ID](https://cursor.com/docs/models-and-pricing.md) |
| `readonly`      | 否   | `false`   | `true` 时限制写文件、限制状态型 shell                                                |
| `is_background` | 否   | `false`   | `true` 时后台运行，不阻塞父 Agent                                                  |


**前台 vs 后台**（官方）：前台适合**必须等结果再往下走**的串行任务；后台适合长任务或与主对话并行的工作流。

### 创建方式（官方）

1. **让 Agent 生成**：在对话里描述要创建的 Subagent 及路径（官方 Quick start 示例指向 `.cursor/agents/*.md`）。
2. **手动新建**：在 `.cursor/agents/` 或 `~/.cursor/agents/` 增加 `.md` 文件。
3. **IDE 命令**：若你的版本提供 `**/create-subagent`**（或同类入口），可与上述方式**等价**使用；以界面为准。

### 调用方式（官方）

- **显式**：`/子agent文件名逻辑名` 例如文档中的 `/verifier`；或自然语言「Use the verifier subagent to …」。
- **自动**：主 Agent 根据任务复杂度、`description`、当前上下文决定是否委派。
- **并行**：在同一条用户消息里要求多项工作并行（父 Agent 可发起多个 Subagent）。
- **恢复**：官方支持用 **agent ID** 恢复子对话以延续长任务（见官方 *Resuming subagents*）。

### 与 Skills、Hooks 的关系（官方）

- **Subagent vs Skill**：多步、要隔离上下文 → Subagent；单目的、一步完成、不必新开窗口 → 官方 [Skill](https://cursor.com/docs/skills.md)。本仓库 **product-lifecycle** 根 `SKILL.md` 是「全流程方法论」入口，在 Cursor 里可**同时**加载该 Skill + 为 12 角色配置 Subagent，二者互补。
- **Hooks**：若需对 Subagent 产出做**确定性**后处理，官方建议见 [Hooks](https://cursor.com/docs/hooks.md)。

### 成本与行为（官方摘要）

- 多个 Subagent **各自计费上下文**；并行 ≈ 多倍 token，需权衡。
- `model` 可能被团队策略、Max Mode、套餐限制覆盖，见官方 *When the configured model won't be used*。

---

## 在 Cursor 上与 Claude Code（CC）对齐的目标

本技能包在 **Claude Code** 上的体验是：**slash 命令** → **编排** → **多个带工具限制的 Subagent** 按依赖执行（见 `docs/SKILL-CLAUDE-CODE.md`）。

在 **Cursor** 上没有同一个 `Agent` 工具与 `/product-lifecycle` 实现，但可通过 **Cursor 原生 Subagent + 本仓库 `agents/*.md` 真源** 达到同一套工作流与隔离执行：


| CC 概念                             | Cursor 上的等价做法                                                                                                                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `/product-lifecycle` 拉起流程         | 主对话先 **Read** `{PACKAGE_ROOT}/agents/orchestrator.md`，产出 `docs/WORKFLOW_PLAN.md`；或用 **Rules / AGENTS.md** 固定「先编排」                                                                          |
| Subagent（独立上下文 + 工具策略）            | 在**业务项目** `.cursor/agents/*.md` 建**薄定义**（官方格式），正文要求 **Read** `{PACKAGE_ROOT}/agents/<role>.md` 并遵守模板与 `docs/` 产出；**或**依赖 Cursor 对项目级 `.claude/agents/` 的兼容加载（见上表），但 `.cursor/agents/` 同名优先 |
| `Agent` 工具「启动某角色」                 | 使用 `**/name`** 或自然语言委派；与官方 *Explicit invocation* 一致                                                                                                                                        |
| `.claude/agents/*.md`（仓库内为 CC 优化） | CC 直接使用；Cursor 亦可加载（兼容路径）。**推荐**业务仓仍用 `.cursor/agents/` 薄封装指向 `PACKAGE_ROOT`，避免与 CC frontmatter 细节长期分叉                                                                                     |
| 联网调研                              | 市场 / 产品 / 侦察 / 反馈类：在工具可用时必须 **WebSearch / WebFetch / 浏览器 MCP**，与 CC 一致                                                                                                                     |


---

## 推荐：业务项目中的落地步骤（与 CC 同编排）

### 1. 准备

1. 解析 `**PACKAGE_ROOT*`*（全局技能路径或嵌套 clone 路径）。
2. 在**业务工作区**确保有 `docs/`。
3. 在业务工作区创建 `**.cursor/agents/`**（若尚无）。

### 2. 为 12 角色各建一个「薄」Subagent（官方格式）

对每个 `agents/*.md` 角色，新建 `**.cursor/agents/<role-kebab>.md**`（文件名小写连字符，与官方 `name` 习惯一致），**frontmatter** 务必写好 `**description`**（决定自动委派质量），正文保持简短，**强制 Read 真源**：

**示例：`.cursor/agents/market-analyst.md`（将 `YOUR_PACKAGE_ROOT` 换为实际路径或说明用环境变量/用户规则注入）**

```markdown
---
name: market-analyst
description: Product-lifecycle market analyst. Use proactively for competitor research, market trends, or docs/MKT-* deliverables.
model: inherit
readonly: false
---

You are the market analyst for this workspace.

1. Read `YOUR_PACKAGE_ROOT/agents/market-analyst.md` and follow every step (replace {{PROJECT_NAME}} and {{PROJECT_DESCRIPTION}} with the current project).
2. For output structure, read `YOUR_PACKAGE_ROOT/templates/market_template.md`.
3. Write all deliverables under this project's `docs/` (e.g. `docs/MKT-001-市场分析报告.md`).
4. When the source agent requires web research, use available browser / web tools; do not fabricate data.
```

- `**readonly**`：若角色仅需读盘与写 `docs/`，可按团队策略设为 `false`；若希望强只读，可设 `true` 并仅在提示词中允许写 `docs/`（以 Cursor 实际权限为准）。
- `**model**`：简单角色可用官方允许的具体模型 ID 控费；需与父 Agent 一致时用 `inherit`（见官方 *Model configuration*）。

**不必**把整份 `agents/market-analyst.md` 粘进 Subagent 正文：避免官方所述「过长提示稀释焦点」；以 **Read 真源** 为主。

### 3. 编排顺序（与 CC、WORKFLOW_DETAILS 一致）

在**主对话**（或单独的 orchestrator Subagent）中：

1. Read `{PACKAGE_ROOT}/agents/orchestrator.md` → 产出 `docs/WORKFLOW_PLAN.md`。
2. 按 `WORKFLOW_PLAN` 使用 `**/role-name*`* 或自然语言 **并行 / 串行** 调用各 Subagent（与官方 *Parallel execution* 一致）。
3. **依赖**：架构师待 PRD 初稿；质量门禁待开发与测试完成（见 `docs/WORKFLOW_DETAILS.md`）。

### 4. 与「仅单会话扮演」的关系

未配置 `.cursor/agents/` 时，仍可在**单一会话**中依次 Read `agents/*.md` 扮演各角色（轻量、**无**独立上下文）。要对齐 CC 的隔离与委派体验，优先采用 `**.cursor/agents/` 薄封装**。

### 5. 官方建议与本项目规模的匹配

官方 **Best practices** 提醒：避免几十个含混 Subagent；本技能包固定 **12 个角色**，属于「数量可控、职责清晰」——请为每个 Subagent 写**高质量 `description`**，否则主 Agent 难以稳定自动委派（见官方 *Invest in descriptions*）。

---

## 其他可选增强


| 手段                                          | 作用                                                          |
| ------------------------------------------- | ----------------------------------------------------------- |
| **项目 Rules**（`.cursor/rules` 或 `AGENTS.md`） | 固定 PACKAGE_ROOT 解析、先编排、`docs/` 产出位置                         |
| **多窗口**                                     | 每窗一角色的应急并行（需自行合并到 `WORKFLOW_PLAN`）                          |
| **Hooks**                                   | 对写盘/提交做确定性校验，见 [Hooks 文档](https://cursor.com/docs/hooks.md) |


---

## 执行方式摘要（速查）


| 方式                                              | 适用                           | 与 CC 接近度                    |
| ----------------------------------------------- | ---------------------------- | --------------------------- |
| `**.cursor/agents/` 薄封装 + Read `agents/*.md*`*  | 长期、多角色、要隔离上下文                | **最高**                      |
| 依赖 Cursor 加载项目内 `.claude/agents/`（与本仓库 CC 定义一致） | 团队以 CC 文件为单一来源、Cursor 侧不重复维护 | **高**（注意与 `.cursor/` 同名优先级） |
| 单会话依次扮演                                         | 临时、轻量                        | 中                           |


## Skill vs Subagent 概念辨析

| 维度 | Skill（技能） | Subagent（子代理） |
|------|--------------|-------------------|
| **定义** | SKILL.md 入口文件，提供方法论和流程指引 | .cursor/agents/*.md 或 .claude/agents/*.md 定义的独立 Agent |
| **调用方式** | `/product-lifecycle` | `/orchestrator`、`/market-analyst` 等 |
| **职责** | 协调全局流程、选择模式、分配任务 | 执行具体角色任务（调研、开发、测试等） |
| **数量** | 1 个 | 12 个 |
| **关系** | Skill 是「入口」，负责启动和协调 | Subagent 是「执行者」，负责具体工作 |

**使用场景：**

1. **完整流程**：先用 `/product-lifecycle` 启动 Skill，它会自动编排 12 个 Subagent 协作
2. **单独执行**：直接用 `/orchestrator` 或 `/market-analyst` 执行单个角色任务
3. **混合使用**：用 Skill 启动流程，中途用 Subagent 执行特定任务

---

## Hooks 集成

Hooks 是确定性后处理机制，可在 Agent 产出后自动执行校验。

### 适用场景

| 场景 | 说明 | 优先级 |
|------|------|--------|
| 文档格式校验 | frontmatter 完整性、必填章节 | 高 |
| 编号规则检查 | MKT-xxx、PRD-xxx 格式 | 高 |
| 交叉引用验证 | 链接有效性 | 中 |
| 敏感信息扫描 | 密钥、密码 | 高 |

### Hooks 与质量门禁的分工

| 检查类型 | Hooks（确定性） | 质量门禁（语义性） |
|----------|----------------|-------------------|
| 格式检查 | 自动执行 | 不涉及 |
| 编号规则 | 自动执行 | 不涉及 |
| 内容质量 | 不涉及 | Agent 审查 |
| 业务逻辑 | 不涉及 | Agent 审查 |

---

**角色与模板清单、门禁速查**：`docs/SKILL-ASSETS.md`。
**流程依赖与闭环**：`docs/WORKFLOW_DETAILS.md`（文首有 Cursor 指针）。
**Claude Code / `.claude/agents` 工具表**：`docs/SKILL-CLAUDE-CODE.md`。