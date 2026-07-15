# product-lifecycle

[![Quality Gate](https://github.com/yclenove/product-lifecycle/actions/workflows/quality-gate.yml/badge.svg)](https://github.com/yclenove/product-lifecycle/actions/workflows/quality-gate.yml)

通过 **20 个专业 Agent**、20 个核心模板和 20 个内置方法 Skill，组织从市场分析、PRD、架构、实现、QA 到持续迭代的完整产品开发流程。

这不是一次性加载全部角色的“大提示词”。它采用显式触发、精简模式优先和按需读取，适用于 Codex、Claude Code、Cursor 以及能读取 Markdown 的其他 AI 编码工具。

## 快速开始

### Codex

```bash
git clone https://github.com/yclenove/product-lifecycle.git "${CODEX_HOME:-$HOME/.codex}/skills/product-lifecycle"
```

新建 Codex 任务后显式调用：

```text
$product-lifecycle 为现有 SaaS 增加团队账单功能，使用精简模式
```

在本仓库工作区中，项目入口还提供 `/product-lifecycle` 与 `/pl`。完整说明见 [Codex 指南](docs/02-tools/SKILL-CODEX.md)。

### Claude Code

```bash
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle
```

```text
/product-lifecycle myapp "SaaS 协作平台"
```

完整说明见 [Claude Code 指南](docs/02-tools/SKILL-CLAUDE-CODE.md)。

### Cursor 与其他工具

| 工具 | 推荐入口 |
|---|---|
| Cursor | [Cursor 安装、`PACKAGE_ROOT` 与 Subagent 指南](docs/02-tools/SKILL-CURSOR.md) |
| OpenCode / Windsurf / 通用工具 | [通用文件读取方式](docs/02-tools/SKILL-OTHER-TOOLS.md) |
| 不确定如何开始 | [3 分钟快速入门](docs/01-getting-started/QUICK-START.md) |

## 选择运行方式

| 模式 | 适用场景 | 角色范围 |
|---|---|---|
| A. 完整生命周期 | 新产品、重大版本、企业级迭代 | 全部 20 个角色 |
| B. 精简迭代 | 现有产品功能、产品级重构、常规迭代 | 编排总监 + 2-6 个相关角色 |
| C. 单角色 | 只需要 PM、架构、QA、审查等一个专业视角 | 1 个角色 |

未指定模式但目标清楚时，默认采用 B。普通小修、单文件修改和简单解释不需要启动本 Skill。

角色选择可直接查 [决策树](docs/01-getting-started/DECISION-TREE.md)。

## 工作方式

```text
确定范围
  -> 编排与依赖
  -> 调研 / 产品 / 设计
  -> 实现
  -> QA <-> 修复
  -> 审查与质量门禁
  -> 归档并进入下一轮
```

工作流不是固定瀑布：测试失败回到实现，门禁失败回到修复，反馈和数据进入下一轮计划。详细依赖见 [工作流说明](docs/03-workflow/WORKFLOW_DETAILS.md)。

## Skill 包结构

| 层 | 路径 | 作用 |
|---|---|---|
| 执行入口 | `SKILL.md` | 触发、范围、按需路由、完成标准 |
| 运行资产 | `agents/`、`templates/`、`skills/` | 20 角色真源、20 核心模板、20 方法 Skill |
| 宿主适配 | `.agents/`、`.claude/`、`.cursor/` | Codex、Claude Code、Cursor 的薄入口 |
| 参考文档 | `docs/` | 入门、工具、工作流、参考、排障、长程迭代 |
| 展示站点 | `docs-site/` | 面向人的 HTML 教程，不是运行真源 |
| 维护工具 | `scripts/` | 同步、校验、归档、预览 |

运行时区分两个根：

- `PACKAGE_ROOT` 保存 Skill 资产，安装后默认只读。
- `WORKSPACE_ROOT` 是当前业务仓库，代码和迭代产出写在这里。

完整真源和修改归属见 [资源与结构索引](docs/04-reference/SKILL-ASSETS.md)。

## 20 个 Agent 角色

| 层 | 角色 |
|---|---|
| 协调 | orchestrator、project-manager |
| 调研与产品 | proactive-scout、market-analyst、product-manager |
| 设计 | ui-designer、architect、dba |
| 实现与交付 | developer、frontend-developer、backend-developer、qa-manager、devops、security-engineer、docwriter |
| 反馈与质量 | data-analyst、feedback-analyst、iteration-planner、reviewer、quality-gatekeeper |

职责、输入、输出和模板映射统一维护在 [SKILL-ASSETS](docs/04-reference/SKILL-ASSETS.md)，README 不复制第二份角色百科。

## 产出与长程迭代

进行中的迭代产出统一写到业务项目：

```text
WORKSPACE_ROOT/docs/iterations/current/<type>/
```

结束一轮后归档到 `docs/iterations/<迭代ID>/`。路径、前缀和生命周期见 [OUTPUT-PATHS](docs/04-reference/OUTPUT-PATHS.md) 与 [迭代归档说明](docs/iterations/README.md)。

框架级 `WORKFLOW_PLAN.md` 可保留在 `WORKSPACE_ROOT/docs/03-workflow/`，不随单轮归档。

跨天或跨会话项目使用 [长程迭代机制](docs/07-long-running/README.md)：

```bash
bash scripts/resume.sh
```

## 内置方法与配套能力

- **方法论**：内置 superpowers-zh v1.7.0，覆盖头脑风暴、计划、TDD、调试、审查和验证；无需额外安装即可被本 Skill 按路径读取。见 [方法 Skill 集成](docs/04-reference/SKILL-INTEGRATION.md)。
- **AI 绘图**：仓库配置 [next-ai-draw-io](https://github.com/DayuanJiang/next-ai-draw-io) MCP；规范见 [DIAGRAMMING](docs/05-advanced/DIAGRAMMING.md)。
- **模型成本**：模型分层与配置见 [MODEL-CONFIG](docs/04-reference/MODEL-CONFIG.md)。

## 文档导航

| 目标 | 文档 |
|---|---|
| 第一次运行 | [QUICK-START](docs/01-getting-started/QUICK-START.md) |
| 选择角色 | [DECISION-TREE](docs/01-getting-started/DECISION-TREE.md) |
| 选择宿主 | [Codex](docs/02-tools/SKILL-CODEX.md) / [Claude Code](docs/02-tools/SKILL-CLAUDE-CODE.md) / [Cursor](docs/02-tools/SKILL-CURSOR.md) |
| 理解依赖和循环 | [WORKFLOW_DETAILS](docs/03-workflow/WORKFLOW_DETAILS.md) |
| 查角色、模板和真源 | [SKILL-ASSETS](docs/04-reference/SKILL-ASSETS.md) |
| 查全部文档 | [docs/README.md](docs/README.md) |
| 浏览 HTML 教程 | [docs-site/README.md](docs-site/README.md) |

## 维护与验证

编辑角色时只改 `agents/*.md` 真源，再运行同步。编辑入口、模板或方法 Skill 时保持宿主适配器为薄包装。

```bash
python scripts/check-product-lifecycle-skill.py --root .
bash scripts/check-docs-health.sh
bash scripts/validate.sh
```

维护规则见 [一致性清单](docs/04-reference/CONSISTENCY-CHECKLIST.md)。

## 贡献

提交前运行上面的验证命令，并更新受影响的真源与文档索引。问题反馈使用 [Bug 模板](https://github.com/yclenove/product-lifecycle/issues/new?template=bug_report.md) 或 [功能请求模板](https://github.com/yclenove/product-lifecycle/issues/new?template=feature_request.md)。

## License

MIT
