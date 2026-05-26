# 一致性检查清单

## 迭代工作流（每次迭代必读）

```
1. 在 agents/*.md 上编辑（真源）
2. 检查脚本是否需要改：bash scripts/iterate.sh --check
3. 如需改脚本（新增 Agent 等），先改 scripts/sync-agents.sh
4. 一键收尾：bash scripts/iterate.sh
   → 自动同步 .claude/agents/
   → 自动更新本机 skill (~/.claude/skills/product-lifecycle)
```

**脚本已配置免授权**（.claude/settings.json），跑 `bash scripts/iterate.sh` 不需要点确认。

| 命令 | 用途 |
|------|------|
| `bash scripts/iterate.sh` | 完整收尾（检查 + 同步 + 更新 skill） |
| `bash scripts/iterate.sh --check` | 只检查，不执行 |
| `bash scripts/iterate.sh --sync-only` | 只同步，不更新 skill |
| `bash scripts/sync-agents.sh` | 只同步 .claude/agents/ |
| `bash scripts/sync-agents.sh orchestrator` | 只同步指定 Agent |

## 三个目录的角色

| 目录 | 角色 | 真源？ | 内容 |
|------|------|--------|------|
| `agents/*.md` | 通用 Agent prompt | **是** | 完整的任务指引和方法论 |
| `.claude/agents/*.md` | Claude Code Subagent | 否 | frontmatter + 动态上下文注入 + 精简 prompt |
| `.cursor/agents/*.md` | Cursor Subagent 薄封装 | 否 | frontmatter + Read `agents/*.md` |

## 同步规则

**核心原则：只在 `agents/*.md`（主干）上编辑，然后跑脚本派生。**

```bash
# 改完 agents/ 后，一条命令同步：
bash scripts/sync-agents.sh

# 只同步单个 Agent：
bash scripts/sync-agents.sh orchestrator
```

1. **所有实质性编辑在 `agents/*.md`** — 这是真源
2. **跑 `scripts/sync-agents.sh`** 自动派生 `.claude/agents/*.md`（加 frontmatter + 动态上下文注入）
3. **不要直接编辑 `.claude/agents/*.md`** — 下次同步会覆盖
4. `.cursor/agents/*.md` 不需要同步 — 它 Read `agents/` 真源
5. frontmatter（description/tools/model）配置在 `scripts/sync-agents.sh` 的关联数组中

## 检查步骤

1. 对比 agents/ 和 .claude/agents/ 的核心 prompt
2. 检查 .cursor/agents/ 的 Read 引用路径
3. 检查 frontmatter 字段一致性
4. 检查上下文管理章节是否都有

## 常见不一致场景

| 场景 | 检查方法 | 修复方法 |
|------|----------|----------|
| agents/ 更新但 .claude/ 未同步 | diff 对比 | `bash scripts/sync-agents.sh` |
| .claude/ 被直接编辑 | git diff 检查 | 丢弃改动，从 agents/ 重新派生 |
| 新增 Agent 未配置 | sync 脚本报错 | 在脚本的 DESCRIPTIONS/TOOLS/MODELS 中添加配置 |
| .cursor/ Read 路径错误 | 检查 frontmatter | 修正路径 |
| model 字段不一致 | grep 对比 | 统一值 |
| 缺少上下文管理章节 | grep 检查 | 补充 |

## 20 Agent 一致性状态

| Agent | agents/ | .claude/agents/ | .cursor/agents/ | 模板 | 状态 |
|-------|---------|-----------------|-----------------|------|------|
| orchestrator | 有 | 有 | 有 | workflow_plan | OK |
| project-manager | 有 | 有 | 有 | pmo | OK |
| proactive-scout | 有 | 有 | 有 | scout | OK |
| market-analyst | 有 | 有 | 有 | market | OK |
| product-manager | 有 | 有 | 有 | product | OK |
| ui-designer | 有 | 有 | 有 | ui_design | OK |
| architect | 有 | 有 | 有 | architecture | OK |
| dba | 有 | 有 | 有 | （ADR） | OK |
| developer | 有 | 有 | 有 | developer | OK |
| frontend-developer | 有 | 有 | 有 | frontend | OK |
| backend-developer | 有 | 有 | 有 | backend | OK |
| qa-manager | 有 | 有 | 有 | qa | OK |
| devops | 有 | 有 | 有 | devops | OK |
| security-engineer | 有 | 有 | 有 | security | OK |
| docwriter | 有 | 有 | 有 | docwriter | OK |
| data-analyst | 有 | 有 | 有 | data | OK |
| feedback-analyst | 有 | 有 | 有 | feedback | OK |
| iteration-planner | 有 | 有 | 有 | iteration | OK |
| reviewer | 有 | 有 | 有 | reviewer | OK |
| quality-gatekeeper | 有 | 有 | 有 | quality_report | OK |

## 角色数量口径检查（自动化）

每次新增/移除角色后，必须同步以下位置：

| 位置 | 关键词 | 当前值 |
|------|--------|--------|
| `SKILL.md` frontmatter description | `XX个Agent` | 20 |
| `SKILL.md` 概述段 | `通过 XX 个专业 Agent` | 20 |
| `README.md` 顶部段 | `通过 XX 个专业 Agent` | 20 |
| `README.md` 角色表标题 | `## XX 个 Agent 角色` | 20 |
| `docs/04-reference/SKILL-ASSETS.md` 速览表标题 | `## XX Agent 角色与产出` | 20 |
| `docs/02-tools/SKILL-CURSOR.md` Best practices | `固定 XX 个角色` | 20 |
| `docs/01-getting-started/DECISION-TREE.md` | `全部 XX 个` | 20 |
| `docs/01-getting-started/QUICK-START.md` | `全部 XX 个` | 20 |
| `docs/01-getting-started/FAQ.md` Q: 小项目 | `XX 个 Agent` | 20 |
| `docs/04-reference/DOC-MAP.md` | `agents/*.md（XX 个）` | 20 |
| `templates/workflow_plan_template.md` | `XX 个专业 Agent` | 20 |
| `agents/orchestrator.md` | `全部 XX 个` | 20 |
| `.claude/agents/orchestrator.md` | `全部 XX 个` | 20 |

运行 `bash scripts/check-docs-health.sh` 自动检查。