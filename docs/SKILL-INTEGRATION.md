# Skill 集成指南

本文档说明如何为 product-lifecycle 的 20 个 Agent 配套**通用方法论 skill**，让每个角色不止有产品流程 prompt，还能调用社区/官方沉淀的最佳实践。

## 为什么需要外部 skill？

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

- **仓库**：[https://github.com/obra/superpowers](https://github.com/obra/superpowers)（中文版叫 `superpowers-zh`）
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

## 一键安装推荐 skill

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
2. 克隆官方 + superpowers-zh 到 `~/.claude/skills/` 和 `~/.cursor/skills/`
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

1. **项目级 skill** 优先（`.claude/skills/` 在仓库内）
2. **用户级 skill** 次之（`~/.claude/skills/` 在 home 目录）
3. **官方 skill** 兜底

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

A: 不需要。`必装` 是高频场景，`建议` 是按需扩展。最小可用集只需装 `superpowers-zh` 一个仓库即可覆盖 80%。

**Q: skill 太多会拖慢 Agent 吗？**

A: 不会。skill 是按需读取（lazy load），Agent 不读就不会消耗 token。

**Q: 怎么知道 Agent 用了哪些 skill？**

A: 看 Agent 的工具调用日志（Read 调用记录）。质量门禁 Agent 可以在 review 时把"是否引用了相应 skill"作为加分项。

**Q: 我的 skill 是 Cursor 专用，能给 Claude Code Agent 用吗？**

A: 大部分跨工具兼容。检查 `SKILL.md` 是否有工具特定字段（如 `allowed-tools`、`hooks`），通用方法论 skill 一般可跨工具。
