# Harness（宿主环境）支持说明

在 Superpowers 体系里，**Harness** 指运行 Skill / Agent 的宿主工具，不是 product-lifecycle 里的一个「角色」。

| Harness | 支持级别 | 说明 |
|---------|----------|------|
| **Claude Code** | ⭐ 一等 | `/product-lifecycle`、`Agent` 子代理、`hooks/`、`.mcp.json` |
| **Codex** | ⭐ 一等 | 根 `SKILL.md`、`.agents/skills/` 显式入口、可选并行角色 |
| **Cursor** | ⭐ 一等 | `.cursor/agents/` 薄封装、`/orchestrator`、`create-subagent` |
| **OpenCode** | ✅ 可用 | 读根 Skill、`agents/` 与 `templates/` |
| **其他 IDE** | ⚠️ 部分 | 只要能读 markdown prompt，即可按角色文件驱动 |

## 什么叫「完整」？

product-lifecycle **本体** = 20 个角色 prompt + 20 个核心模板 + 20 个内置方法 Skill + 脚本 + 文档。

要接近「开箱即用」的完整体验，建议在 Harness 上叠加：

1. **本仓库**（角色、流程与内置 superpowers-zh 方法 Skill）
2. **drawio MCP**（`bash scripts/install-mcp.sh`）
3. **Harness 原生能力**（子代理、工具白名单、项目级 MCP）

缺第 2 步：图可手写 Mermaid，但无法用 drawio MCP 一键出图。
缺第 3 步：例如在纯 Chat 里无法派发子 Agent，只能单会话串行扮演角色。

## 与 superpowers-zh 的 harness 概念对齐

superpowers-zh 要求：给**新 Harness** 加支持时，需提供干净 session 的验收记录（例如用户说「做一个 React Todo」应自动触发 `brainstorming`）。

product-lifecycle 的验收建议：

```text
/product-lifecycle demo "做一个团队待办小工具"
```

期望：编排总监先诊断模式，再按链路派发或引导市场/产品/架构等角色，产出写入 `docs/iterations/current/`。

## 各 Harness 入口

| Harness | 文档 |
|---------|------|
| Codex | [SKILL-CODEX.md](./SKILL-CODEX.md) |
| Claude Code | [SKILL-CLAUDE-CODE.md](./SKILL-CLAUDE-CODE.md) |
| Cursor | [SKILL-CURSOR.md](./SKILL-CURSOR.md) |
| 其他 | [SKILL-OTHER-TOOLS.md](./SKILL-OTHER-TOOLS.md) |

## 常见问题

**Q：要不要在 skill 里再写一个 harness skill？**  
A：一般**不需要**。Harness 是环境，不是方法论。保持 `agents/` 与 `docs/02-tools/` 分 Harness 说明即可。若你维护多 IDE，可为每个 IDE 写一页「安装 + 验收」而不是塞进 orchestrator prompt。

**Q：Cursor 和 Claude Code 能共用同一套 agents 吗？**  
A：真源在 `agents/`；`.claude/agents/` 带 frontmatter；`.cursor/agents/` 为薄封装。改角色请改 `agents/` 后运行 `bash scripts/sync-agents.sh`。
