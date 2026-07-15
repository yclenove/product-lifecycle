# Skill 集成指南

本文档说明如何为 product-lifecycle 的 20 个 Agent 配套**通用方法论 skill**，让每个角色不止有产品流程 prompt，还能调用社区/官方沉淀的最佳实践。

## 方法论 Skills（已内置）

product-lifecycle 已将 superpowers-zh 的 20 个通用方法论 skill **内置在 `skills/` 目录中**，安装 product-lifecycle 即可直接使用，无需单独安装 superpowers-zh。当前同步基线为 **superpowers-zh v1.7.0**（commit `84026e57664cbb4d042f22b816db250f84890d62`），来源记录见 `skills/.superpowers-zh-source.json`。

内置 skill 列表：brainstorming、writing-plans、executing-plans、test-driven-development、systematic-debugging、verification-before-completion、requesting-code-review、receiving-code-review、chinese-code-review、chinese-commit-conventions、chinese-documentation、chinese-git-workflow、dispatching-parallel-agents、subagent-driven-development、using-git-worktrees、finishing-a-development-branch、mcp-builder、using-superpowers、workflow-runner、writing-skills

## Codex 使用方式

运行 `/pl` 或 `/product-lifecycle` 时，编排 Skill 会直接读取 `skills/<name>/SKILL.md`。这条包内路径不依赖 Codex 是否把 20 个方法 Skill 单独显示在技能列表里，也是本仓库的默认方式。

如果还希望在 product-lifecycle 之外独立调用这些方法 Skill，可选用上游安装器。与内置版本严格对齐：

```bash
npx superpowers-zh@1.7.0 --global --tool codex
```

上游 v1.7.0 的 Codex 全局安装会写入 `~/.agents/skills/`。项目级安装可在项目根目录运行 `npx superpowers-zh@1.7.0 --tool codex`；不要在 `~` 目录运行项目级安装。安装后新开 Codex 会话以刷新技能发现。

| 参数 | 用途 |
|------|------|
| `--tool codex` | 显式选择 Codex，避免自动检测装错宿主 |
| `--global` | 安装到用户级目录，让多个项目共享 |
| `--uninstall` | 卸载对应范围内由上游安装器复制的 Skill |
| `@latest` | 独立升级到高于本仓库内置基线的版本；可能与内置内容不同 |

## MCP 集成（绘图能力）

product-lifecycle 还推荐一个 MCP server：**drawio**，提供 AI 画图能力。

- 仓库根目录已配 `.mcp.json` / `.cursor/mcp.json`，本仓库内**自动生效**
- 跨项目使用：`bash scripts/install-mcp.sh`（详见 [`DIAGRAMMING.md`](../05-advanced/DIAGRAMMING.md)）
- 让 AI 给文档配图、画架构、画时序、画 ER 都用它

| 能力 | 用途 | 触发例 |
|------|------|--------|
| **drawio MCP** | 流程/架构/时序/ER/状态机/部署/威胁等 11 种图 | 「用 drawio 画一张下单时序图」 |
| **Mermaid** | 简单图、嵌入 markdown 直接版本化 | 「给我画一个 mermaid 流程图」 |

绘图规范、角色×图矩阵、反模式：[`docs/05-advanced/DIAGRAMMING.md`](../05-advanced/DIAGRAMMING.md)

## 安装方式关系

与本仓库脚本的关系：

- `skills/` → product-lifecycle 内置的 20 个方法 Skill，编排时按路径直接读取
- `npx superpowers-zh@1.7.0 --global --tool codex` → 可选的 Codex 原生发现安装
- `bash scripts/install-skills.sh` / `scripts/install-skills.ps1` → 只安装 Anthropic 官方补充 Skill，不更新内置 superpowers-zh
- 三者可以并存；product-lifecycle 编排始终优先使用包内明确路径，避免同名版本漂移

卸载上面的 Codex 全局安装：`npx superpowers-zh@1.7.0 --global --tool codex --uninstall`

## Harness（宿主环境）与 skill 的关系

- **Harness**：运行本技能包的 IDE/CLI（Claude Code、Cursor、OpenCode 等）。详见 [`docs/02-tools/HARNESS.md`](../02-tools/HARNESS.md)。
- **product-lifecycle**：20 个**产品角色** prompt + 模板（本仓库）。
- **superpowers-zh**：**通用方法论** skill（TDD、调试、计划…），已按 v1.7.0 内置；`npx` 仅用于可选的宿主原生发现安装。

三者关系：**Harness 提供执行环境 → product-lifecycle 提供角色与流程 + 内置方法论 skill（原 superpowers-zh）**。  
superpowers-zh 已内置，无需单独安装；只有需要在 product-lifecycle 之外独立发现这些 Skill 时才运行 `npx`。

## 为什么需要方法 Skill？

每个 Agent 的 prompt 聚焦「**做什么**」（What），通用 skill 聚焦「**怎么做**」（How）。两者结合后：

- Agent 知道自己的产出物
- skill 提供该领域的方法论、检查清单、反模式提醒

例：开发工程师 Agent 知道「要写单元测试」，但 `test-driven-development` skill 教它「红 → 绿 → 重构」的具体节奏。

## 角色 × Skill 推荐矩阵

| 角色 | 必装 skill | 建议 skill |
|---|---|---|
| **orchestrator** | writing-plans、dispatching-parallel-agents | brainstorming |
| **project-manager** | writing-plans、dispatching-parallel-agents | chinese-documentation、chinese-commit-conventions |
| **proactive-scout** | brainstorming | chinese-documentation |
| **market-analyst** | brainstorming | chinese-documentation |
| **product-manager** | brainstorming、writing-plans | chinese-documentation |
| **ui-designer** | brainstorming | chinese-documentation |
| **architect** | writing-plans | systematic-debugging、mcp-builder |
| **dba** | writing-plans | systematic-debugging |
| **developer**（通用） | test-driven-development、systematic-debugging、using-git-worktrees | chinese-commit-conventions、requesting-code-review |
| **frontend-developer** | test-driven-development、systematic-debugging、using-git-worktrees | chinese-commit-conventions、requesting-code-review |
| **backend-developer** | test-driven-development、systematic-debugging、using-git-worktrees | chinese-commit-conventions、requesting-code-review、mcp-builder |
| **qa-manager** | test-driven-development、verification-before-completion | systematic-debugging |
| **devops** | verification-before-completion | systematic-debugging、writing-plans |
| **security-engineer** | systematic-debugging | chinese-documentation、chinese-code-review |
| **docwriter** | chinese-documentation | chinese-commit-conventions |
| **data-analyst** | brainstorming | chinese-documentation |
| **feedback-analyst** | brainstorming | chinese-documentation |
| **iteration-planner** | writing-plans、brainstorming | — |
| **reviewer** | chinese-code-review、receiving-code-review | systematic-debugging |
| **quality-gatekeeper** | verification-before-completion、chinese-code-review | receiving-code-review |

## 推荐 Skill 来源

### 1. Anthropic 官方 skill 仓库

- **仓库**：[https://github.com/anthropics/skills](https://github.com/anthropics/skills)
- **特点**：官方维护，质量稳定
- **安装位置**：`~/.claude/skills/`

### 2. Superpowers 中文版（推荐）

- **仓库**：[https://github.com/jnMetaCode/superpowers-zh](https://github.com/jnMetaCode/superpowers-zh)（14 个上游 Skill 汉化 + 4 个中文团队 Skill + `mcp-builder` / `workflow-runner`）
- **npm**：`npx superpowers-zh@1.7.0`（可选原生发现安装；hooks / bootstrap 行为按宿主而异）
- **包含**：
  - `brainstorming` — 创造性工作前先探索
  - `writing-plans` — 多步任务的实现计划
  - `executing-plans` — 执行计划并设审查检查点
  - `test-driven-development` — TDD 实践
  - `systematic-debugging` — 系统化排查
  - `verification-before-completion` — 完成前必验证
  - `requesting-code-review` / `receiving-code-review` — review 协作
  - `chinese-code-review` / `chinese-commit-conventions` / `chinese-documentation` / `chinese-git-workflow` — 中文团队规范
  - `dispatching-parallel-agents` — 并行派发
  - `subagent-driven-development` — subagent 协作
  - `using-git-worktrees` — 多分支隔离
  - `finishing-a-development-branch` — 分支收尾
  - `mcp-builder` — MCP 服务器构建
  - `using-superpowers` — 元 skill，教 Agent 怎么发现/使用 skill
  - `workflow-runner` — 跑 YAML 工作流

### 3. awesome-claude-code 社区精选

- **仓库**：[https://github.com/hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)
- **特点**：社区精选清单，含大量优质 skill 链接

### 4. Cursor Skills（如果用 Cursor）

- **入口**：[https://cursor.com/skills](https://cursor.com/skills)
- **特点**：Cursor 原生支持，按工作流场景组织
- **安装位置**：`~/.cursor/skills/`

## 可选安装 Anthropic 补充 Skill

以下脚本只为 Claude Code / Cursor 克隆 Anthropic 官方 Skill，**不会**覆盖 `skills/` 中内置的 superpowers-zh，也不是 Codex 使用 product-lifecycle 的前置条件。

### macOS / Linux

```bash
bash scripts/install-skills.sh
```

### Windows PowerShell

```powershell
.\scripts\install-skills.ps1
```

脚本会：
1. 检测已安装的 skill（避免重复克隆）
2. 克隆 Anthropic 官方 Skill 到 `~/.claude/skills/` 和 `~/.cursor/skills/`
3. 验证 skill 完整性（SKILL.md 存在、frontmatter 合法）

## 在 Agent prompt 中引用 skill

每个 `agents/*.md` 顶部已经内置了 **「## 推荐方法论 skills」** 小节。Agent 在开始工作前会读取该清单，按需调用对应 skill。

例（`agents/developer.md`）：

```markdown
## 推荐方法论 skills（开始工作前按需读取）

| skill | 用途 |
|---|---|
| test-driven-development | 写测试在写实现之前 |
| systematic-debugging | 系统化排查 bug |
| using-git-worktrees | 多分支并行隔离开发 |
| chinese-commit-conventions | 中文 commit 规范 |
| requesting-code-review | 完成功能后发起 review |
```

Agent 不会盲目读取所有 skill，只在场景匹配时按需调用。

## 命名空间冲突处理

如果同名 skill 存在于多个来源：

1. product-lifecycle 编排中显式读取的 `PACKAGE_ROOT/skills/<name>/SKILL.md`
2. 宿主发现的项目级同名 Skill
3. 宿主发现的用户级同名 Skill

冲突时显式用完整路径引用，避免歧义。

## 自定义 skill

如果团队有自己的方法论沉淀，可以参考 [Anthropic Skill 规范](https://github.com/anthropics/skills) 创建：

```
~/.claude/skills/my-team-style/
├── SKILL.md         # 包含 frontmatter 的 skill 描述
├── examples/
└── references/
```

`SKILL.md` 必须包含 frontmatter：

```yaml
---
name: my-team-style
description: 团队代码风格与协作约定。当用户说"按团队规范"时使用。
---
```

## FAQ

**Q: 推荐 skill 都需要装吗？**

A: 不需要。20 个 superpowers-zh 方法 Skill 已内置并按需读取；只有独立调用或补充其他来源时才需要额外安装。

**Q: skill 太多会拖慢 Agent 吗？**

A: 不会。skill 是按需读取（lazy load），Agent 不读就不会消耗 token。

**Q: 怎么知道 Agent 用了哪些 skill？**

A: 看 Agent 的工具调用日志（Read 调用记录）。质量门禁 Agent 可以在 review 时把"是否引用了相应 skill"作为加分项。

**Q: 我的 skill 是 Cursor 专用，能给 Claude Code Agent 用吗？**

A: 大部分跨工具兼容。检查 `SKILL.md` 是否有工具特定字段（如 `allowed-tools`、`hooks`），通用方法论 skill 一般可跨工具。
