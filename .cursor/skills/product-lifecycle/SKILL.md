---
name: product-lifecycle
description: >-
  Orchestrates full product lifecycle with 12 role-based prompts (market → PRD →
  architecture → dev → QA → release) plus shared templates. Use when starting a
  new product or phase, planning iteration from feedback, writing PRD/architecture
  docs with gated quality, or when the user mentions product lifecycle, 编排总监,
  WORKFLOW_PLAN, or multi-agent product workflow.
---

# Cursor 中的 product-lifecycle

本技能与根目录 `SKILL.md`、`agents/`、`templates/`、`docs/` **共用同一套内容**。未设置 `disable-model-invocation`，便于在相关对话中**自动加载**。

在 Cursor 中**没有** Claude Code 的 `Agent` 工具与 `/product-lifecycle` 命令，但可按 [Cursor 官方 Subagents](https://cursor.com/docs/subagents) 在业务项目 **`.cursor/agents/*.md`** 中为每角色建薄定义（或用 **`/create-subagent`** 等 IDE 入口生成），使编排与隔离执行**与 Claude Code 对齐**；亦可仅在单会话中按 `PACKAGE_ROOT` **Read** `agents/*.md` 扮演角色（轻量）。**完整步骤、路径优先级、frontmatter 与 CC 对照见 `{PACKAGE_ROOT}/docs/SKILL-CURSOR.md`**。

## 技能包路径（PACKAGE_ROOT）

业务仓库与技能包**不必**是同一目录。读取 prompt 前必须先解析 **`PACKAGE_ROOT`**；**完整规则与全局安装命令**见 `{PACKAGE_ROOT}/docs/SKILL-CURSOR.md`（与根 `SKILL.md` 中「各工具用法」表一致）。

解析到 `PACKAGE_ROOT` 后：

| 用途 | 路径 |
|------|------|
| 角色 prompt | `{PACKAGE_ROOT}/agents/<role>.md` |
| 输出格式 | `{PACKAGE_ROOT}/templates/<name>_template.md` |
| 流程与门禁细节 | `{PACKAGE_ROOT}/docs/WORKFLOW_DETAILS.md` |
| 主技能索引（工具分文档） | `{PACKAGE_ROOT}/SKILL.md` |
| Cursor 专用说明（本节的权威展开） | `{PACKAGE_ROOT}/docs/SKILL-CURSOR.md` |
| 角色/模板/门禁表 | `{PACKAGE_ROOT}/docs/SKILL-ASSETS.md` |
| Subagent 源（CC 优化；Cursor 亦可加载项目内 `.claude/agents/`，与 `.cursor/agents/` 同名时以前者优先） | `{PACKAGE_ROOT}/.claude/agents/*.md` |

启动任意角色前，将 prompt 中的 `{{PROJECT_NAME}}`、`{{PROJECT_DESCRIPTION}}` 换成当前项目信息。产出文档默认写在**当前业务工作区**的 `docs/`。

## 推荐用法

1. **必读**：`{PACKAGE_ROOT}/agents/orchestrator.md` — 判断模式 A（0→1）或 B（持续迭代），协调顺序与并行。
2. 按编排总监产出或用户指定，依次读取 `{PACKAGE_ROOT}/agents/*.md`，并引用 `{PACKAGE_ROOT}/templates/` 中匹配的模板，将产出写入**业务工作区**的 `docs/`（或用户指定路径）。
3. 市场/产品类任务需要 **联网检索** 时，使用 WebSearch / WebFetch（若当前环境可用），不得只凭空编造竞品与市场数据。
4. 质量门禁与阶段依赖见 `{PACKAGE_ROOT}/docs/WORKFLOW_DETAILS.md` 与 `{PACKAGE_ROOT}/docs/SKILL-ASSETS.md`。

## 模式速览

- **模式 A**：编排 → 市场 + 产品 → 架构 → 开发 / 测试 / 运维 / 文档 / 质量门禁 → 发布。
- **模式 B**：需求侦察兵 + 反馈分析 → 市场 + 产品 → **迭代规划师** → 架构 → 开发 → 测试 → 质量门禁 → 发布。

自驱动角色与「文档缺失时如何反推」见 `{PACKAGE_ROOT}/SKILL.md` 的「文档健康检查」「自驱动能力」两节。

## 可选脚本

`{PACKAGE_ROOT}/scripts/detect.sh` 用于项目体检；在 Windows 上可在 Git Bash 或 WSL 中执行，或用手动阅读业务项目与 `{PACKAGE_ROOT}/docs/` 代替。

## 示例启动话术

```
你是本项目的编排总监。已加载 product-lifecycle 技能。
先解析 PACKAGE_ROOT，再读取 {PACKAGE_ROOT}/agents/orchestrator.md，替换项目占位符后执行；
产出遵循 {PACKAGE_ROOT}/templates/workflow_plan_template.md，写入当前业务工作区的 docs/。
```

精简子集（编排 + 开发 + 测试 + 质量门禁）见 `{PACKAGE_ROOT}/SKILL.md`「渐进式采用」。
