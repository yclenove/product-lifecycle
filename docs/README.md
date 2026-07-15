# 文档导航

> product-lifecycle 文档分门别类索引。新人从「入门」开始，进阶看「参考」和「高级」。

运行时入口、真源和宿主适配层的边界见 [`04-reference/SKILL-ASSETS.md`](04-reference/SKILL-ASSETS.md#包结构与真源)。

**给人看的 HTML 教程站**：[`docs-site/`](../docs-site/) · 本地预览 `bash scripts/serve-docs.sh`

## 01-getting-started — 入门

| 文档 | 适合谁 |
|------|--------|
| [QUICK-START](01-getting-started/QUICK-START.md) | 第一次接触本项目，3 分钟跑通流程 |
| [DECISION-TREE](01-getting-started/DECISION-TREE.md) | 不知道用哪几个 Agent，按场景挑组合 |
| [FAQ](01-getting-started/FAQ.md) | 常见问题汇总 |

## 02-tools — 工具适配

| 文档 | 工具 |
|------|------|
| [HARNESS](02-tools/HARNESS.md) | 宿主能力与支持级别总览 |
| [SKILL-CODEX](02-tools/SKILL-CODEX.md) | Codex |
| [SKILL-CLAUDE-CODE](02-tools/SKILL-CLAUDE-CODE.md) | Claude Code |
| [SKILL-CURSOR](02-tools/SKILL-CURSOR.md) | Cursor |
| [SKILL-OTHER-TOOLS](02-tools/SKILL-OTHER-TOOLS.md) | 其它工具通用集成 |
| [WINDSURF-GUIDE](02-tools/WINDSURF-GUIDE.md) | Windsurf 专用 |
| [CURSOR-RULES-INTEGRATION](02-tools/CURSOR-RULES-INTEGRATION.md) | Cursor Rules 整合 |

## 03-workflow — 工作流详解

| 文档 | 内容 |
|------|------|
| [WORKFLOW_PLAN](03-workflow/WORKFLOW_PLAN.md) | 工作流编排总览 |
| [WORKFLOW_DETAILS](03-workflow/WORKFLOW_DETAILS.md) | 每个阶段的详细步骤 |
| [AGENT-COMMUNICATION](03-workflow/AGENT-COMMUNICATION.md) | Agent 之间的协作与移交协议 |

## 04-reference — 参考资料

| 文档 | 用途 |
|------|------|
| [SKILL-ASSETS](04-reference/SKILL-ASSETS.md) | 包结构、真源边界、20 个 Agent + 20 个核心模板 |
| [SKILL-INTEGRATION](04-reference/SKILL-INTEGRATION.md) | 角色 × Skill 矩阵 + 一键安装 |
| [MODEL-CONFIG](04-reference/MODEL-CONFIG.md) | 模型分级配置（强 / 均衡 / 经济） |
| [DOC-MAP](04-reference/DOC-MAP.md) | 文档与 Agent 的对应关系 |
| [CONSISTENCY-CHECKLIST](04-reference/CONSISTENCY-CHECKLIST.md) | 角色数量 / 模板 / 文档口径一致性自检清单 |
| [OUTPUT-PATHS](04-reference/OUTPUT-PATHS.md) | Agent 产出应写到 `iterations/current/` 的哪 |

## 05-advanced — 高级专题

| 文档 | 主题 |
|------|------|
| [CONTEXT-MANAGEMENT](05-advanced/CONTEXT-MANAGEMENT.md) | 大型项目上下文管理 |
| [TOKEN-EFFICIENCY](05-advanced/TOKEN-EFFICIENCY.md) | 节省 token 的技巧 |
| [PERFORMANCE-BASELINE](05-advanced/PERFORMANCE-BASELINE.md) | 性能基线与监控 |
| [ACCESSIBILITY](05-advanced/ACCESSIBILITY.md) | 可访问性（A11y）规范 |
| [INTERNATIONALIZATION](05-advanced/INTERNATIONALIZATION.md) | 国际化（i18n） |
| [SECURITY](05-advanced/SECURITY.md) | 安全基线 |
| [LINT-RULES](05-advanced/LINT-RULES.md) | Lint 规则配置 |
| [QUALITY-METRICS](05-advanced/QUALITY-METRICS.md) | 质量度量 |
| [CHANGELOG-GUIDE](05-advanced/CHANGELOG-GUIDE.md) | Changelog 编写规范 |
| [DIAGRAMMING](05-advanced/DIAGRAMMING.md) | **绘图规范**：11 种图、drawio MCP、角色×图矩阵、反模式 |

## 06-troubleshooting — 故障排查

| 文档 | 内容 |
|------|------|
| [TROUBLESHOOTING](06-troubleshooting/TROUBLESHOOTING.md) | 常见故障与解决方案 |

## 07-long-running — 长程迭代（v3.1+ 新增）

跨多 session 持久化的"心跳"机制，适合周期超过 3 天的项目。

| 文档 | 内容 |
|------|------|
| [README](07-long-running/README.md) | 长程迭代模式介绍 |
| [STATE.template](07-long-running/STATE.template.md) | 状态快照模板 |
| [HANDOFF.template](07-long-running/HANDOFF.template.md) | 跨 session 移交单模板 |
| `CHECKPOINTS/` | 各阶段里程碑 snapshot |

启用：

```bash
cp docs/07-long-running/STATE.template.md docs/07-long-running/STATE.md
bash scripts/resume.sh   # 查看当前状态
```

## iterations — 迭代产物（按迭代归档，推荐）

| 路径 | 用途 |
|------|------|
| [`iterations/current/`](iterations/current/) | **进行中**本轮：PRD、架构、测试报告等 |
| [`iterations/<迭代ID>/`](iterations/README.md) | **已结束**整轮快照（如 `v1.8/`） |
| [`iterations/_legacy-by-role/`](iterations/_legacy-by-role/README.md) | v3.0 前按角色分类的历史（只读） |

新开一轮：`bash scripts/init-iteration.sh v1.9 "目标"` · 结束归档：`bash scripts/archive-iteration.sh v1.9`

产出路径规范：[`04-reference/OUTPUT-PATHS.md`](04-reference/OUTPUT-PATHS.md)

## 不知道从哪开始？

| 目标 | 推荐路径 |
|------|---------|
| 我是新人想跑通流程 | 01 → 02（你的工具）→ 然后跑 orchestrator |
| 我要给团队推广 | 01-getting-started 整套 + 04-reference 的 SKILL-ASSETS |
| 我要做大版本迭代 | 03-workflow + 07-long-running |
| 出问题了 | 06-troubleshooting → 然后翻 04-reference 的 CONSISTENCY-CHECKLIST |
| 我要优化成本 | 05-advanced 的 TOKEN-EFFICIENCY + 04-reference 的 MODEL-CONFIG |
