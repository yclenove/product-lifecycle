# Changelog

All notable changes to this skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/).

## [Unreleased]

<!-- 下一版本条目写于此 -->

## [2.1.0] - 2026-05-05

### Added
- `docs/TROUBLESHOOTING.md`：排障指南（10 个常见问题）
- `docs/SECURITY.md`：安全指南
- `docs/TOKEN-EFFICIENCY.md`：Token 效率指南
- `docs/PERFORMANCE-BASELINE.md`：性能基准
- `docs/DECISION-TREE.md`：Agent 选择决策树
- `docs/FAQ.md`：常见问题（22 个问答）
- `docs/INTERNATIONALIZATION.md`：国际化指南
- `docs/ACCESSIBILITY.md`：可访问性指南
- `templates/adr_template.md`：架构决策记录模板
- `scripts/validate.sh`：自动化验证脚本
- `scripts/evolve.sh`：自进化迭代脚本
- `scripts/iterate.sh`：迭代收尾脚本
- `.github/workflows/quality-gate.yml`：CI 质量门禁
- `.github/PULL_REQUEST_TEMPLATE.md`：PR 模板
- `.github/ISSUE_TEMPLATE/`：Issue 模板（bug + feature）
- `templates/*.md`：全部 13 个模板的使用示例

### Changed
- `agents/orchestrator.md`：添加错误处理、Agent 组合推荐、输出精简规则
- `agents/qa-manager.md`：添加验证规则
- `agents/quality-gatekeeper.md`：添加安全检查、自动化检查清单
- `agents/developer.md`：添加安全编码规范
- `docs/CONTEXT-MANAGEMENT.md`：添加实战案例
- `docs/WORKFLOW_DETAILS.md`：添加并行策略详解
- `docs/QUICK-START.md`：添加进阶用法
- `SKILL.md`：添加进阶资源章节、安全门禁
- `README.md`：更新目录结构、Agent 表、CI 说明

## [2.0.0] - 2026-05-05

### Added
- `docs/QUICK-START.md`：快速入门指南（30 秒理解 + 5 分钟体验 + 最小可用集 + FAQ）
- `docs/CONSISTENCY-CHECKLIST.md`：agents/ vs .claude/agents/ vs .cursor/agents/ 一致性检查清单
- `examples/saas-iteration.md`：SaaS 产品持续迭代示例（模式 B）
- `examples/cli-tool.md`：CLI 工具渐进式采用示例（4 核心 Agent）
- `docs/SKILL-CURSOR.md`：Skill vs Subagent 概念辨析章节
- `docs/SKILL-CURSOR.md`：Hooks 集成指南
- `docs/SKILL-ASSETS.md`：引用语法规范 + 模型选择策略
- `templates/*.md`：3 个核心模板新增使用示例折叠区块
- `agents/*.md`：全部 12 个 Agent 嵌入上下文管理指令（含输出预算）
- `agents/feedback-analyst.md`：增强 prompt（69→126 行，含收集策略、分类规则、优先级公式）
- `agents/iteration-planner.md`：增强 prompt（107→203 行，含影响分析、回滚方案模板）

### Changed
- SKILL.md：工具文档索引表增加「何时读取」列
- SKILL.md：渐进式采用增加决策树（按项目规模分 4 档）
- SKILL.md：实际效果章节扩展为 3 个示例
- README.md：目录结构树全面更新、Agent 角色表增加模型列
- `.cursor/agents/`：description 字段统一为中文（与 .claude/agents/ 一致）
- `.cursor/agents/`：model 字段同步（orchestrator/architect → opus，docwriter/quality-gatekeeper → haiku）
- `examples/cloudflow.md`：新增上下文管理与迭代章节
- `templates/*.md`：年份统一更新为 2026
- `docs/CONTEXT-MANAGEMENT.md`：年份更新

### Fixed
- 统一文档引用语法规范
- 清理 PRODUCT_PLAN.md 虚引用残留
- 模板格式统一（元数据表、[必填]/[可选] 标记、修订记录）

## [1.9.0] - 2026-05-04

### Changed
- .cursor/agents/ model 字段同步：orchestrator/architect → opus，docwriter/quality-gatekeeper → haiku，其余 inherit
- docs/SKILL-CLAUDE-CODE.md 模型描述更新为 opus/sonnet/haiku 三级策略
- agents/orchestrator.md 和 .claude/agents/orchestrator.md 健康检查表同步为 4 列

## [1.8.0] - 2026-05-04

### Fixed
- SKILL.md frontmatter 修复（`## name:` → `name:`，补充关闭 `---`）
- workflow_plan_template.md 编号规则补全（新增 SCOUT、FB、ITER 三个 Agent）
- CHANGELOG [Unreleased] 清理混入的过程稿条目

### Changed
- .claude/agents/ model 字段三级分布：opus（orchestrator, architect）/ sonnet（8 个）/ haiku（docwriter, quality-gatekeeper）
- SKILL.md 文档健康检查表新增"质量不达标时"列
- SKILL.md 直接引用 docs/CONTEXT-MANAGEMENT.md
- docs/SKILL-ASSETS.md 新增模型选择策略说明

## [1.7.0] - 2026-05-04

### Added
- `scripts/install-cursor-subagents.ps1`、`scripts/install-cursor-subagents.sh`：向新业务项目一键安装 `.cursor/agents/` 并写入技能包绝对路径（因 Cursor 无法自动注入）。
- `.cursor/agents/`：12 个 Cursor Subagent 薄封装（YAML frontmatter + Read `agents/<role>.md`），含 `README.md`；可在 Agent 中用 `/orchestrator`、`/market-analyst` 等显式调用。
- 规划迭代（2026-05-05）：`docs/ITER-003-迭代计划-v1.8.md`、`docs/ROLE-RUN-LOG-2026-05-05.md`、`docs/WORKFLOW_PLAN.md`（更新）；分角色过程稿 SCOUT-004、FEEDBACK-004、MKT-003、PRD-003、ARCH-002、DEV-002、QA-003、QG-002。
- `docs/SKILL-CURSOR.md`：在 Cursor 上用 `/create-subagent` 与 `agents/*.md` 对齐 Claude Code 的编排与多 Subagent 体验；含能力对照表、系统提示词模板、并行与依赖说明。
- `README.md`：Cursor 小节增加「与 Claude Code 对齐」用法（第 3 条）。

### Changed
- `docs/SKILL-OTHER-TOOLS.md`：文首增加 Cursor 安装与 Subagent 指向 `SKILL-CURSOR.md` 的说明。
- `SKILL.md`：工具表中 Cursor 条目指向上述 CC 对齐说明。
- `.cursor/skills/product-lifecycle/SKILL.md`：明确 Subagent 路径与 `SKILL-CURSOR.md` 权威展开。
- `docs/SKILL-CURSOR.md`：按 [Cursor 官方 Subagents 文档](https://cursor.com/docs/subagents) 扩充——内置 Explore/Bash/Browser、`.cursor/agents/` / `.claude/agents/` 路径与优先级、`frontmatter` 字段、`/name` 与并行/恢复、Skills/Hooks 链接、成本提示；推荐改为「薄封装 `.md` + Read `agents/` 真源」；修正早期稿中错误 markdown（如 `**/create-subagent**`）。
- `docs/WORKFLOW_DETAILS.md`：文首增加 Cursor 执行指针与官方文档链接。
- `docs/SKILL-ASSETS.md`：通用 Agent 表处补充 Cursor Subagent 与官方文档引用。
- `README.md`：Cursor 段补充官方 Subagents 文档链接。

## [1.6.0] - 2026-05-03

### Fixed
- 清理所有 PRODUCT_PLAN.md 虚引用（templates/、agents/orchestrator.md）
- 更新 README.md 目录结构树（添加 scout_template、quality_report_template、CONTEXT-MANAGEMENT.md）
- SKILL.md 支撑文件索引添加上下文管理文档引用

## [1.5.0] - 2026-05-03

### Added
- .claude/agents/: 补全 6 个缺失的 subagent 定义（product-manager, devops, docwriter, proactive-scout, feedback-analyst, iteration-planner）
- templates/scout_template.md: 需求侦察兵专用模板
- templates/quality_report_template.md: 质量门禁专用模板
- docs/CONTEXT-MANAGEMENT.md: 上下文管理最佳实践
- SKILL.md: 渐进式采用指引（核心 Agent 子集 + 精简模式）

### Fixed
- 搜索关键词年份更新：2025 → 2026
- 修复 workflow_plan_template.md 编号重复（两个 1.2）
- 清理 PRODUCT_PLAN.md 虚引用（SKILL.md, WORKFLOW_DETAILS.md）

## [1.4.0] - 2026-05-03

### Added
- .claude/agents/: 正式 Subagent 定义（6 个核心 Agent：orchestrator, market-analyst, architect, developer, qa-manager, quality-gatekeeper）
- 动态上下文注入：每个 Subagent 自动检测项目结构、技术栈、Git 状态

## [1.3.0] - 2026-05-03

### Changed
- SKILL.md: 445 → 233 行，详细内容移到 docs/WORKFLOW_DETAILS.md
- 保持 SKILL.md 精简，支撑文件承载详细信息

### Fixed
- 修复 "8 个 Agent" 残留引用 → "12 个 Agent"
- 修复 workflow_plan_template.md "N 个专业 Agent" → "12 个专业 Agent"

## [1.2.0] - 2026-05-03

### Fixed
- 修复一致性问题（迭代1）

## [1.1.0] - 2026-05-03

### Added
- 文档健康检查机制：每个 Agent 启动时先检查输入文档是否齐全
- 编排总监：检查 docs/ 目录，缺失则创建
- 架构师：检查 PRD，缺失则从代码反推
- 开发工程师：检查 PRD + 架构设计，缺失则先补再开发
- 测试经理：检查 PRD + 架构设计，缺失则先补再测试
- 运维工程师：检查架构设计，缺失则从代码反推
- 技术文档师：检查 PRD，缺失则从代码反推
- 迭代规划师：检查 PRD + 反馈分析，缺失则先收集

## [1.0.0] - 2026-05-03

### Added
- README：多工具使用说明（Claude Code / Cursor / OpenCode / Codex）
- SKILL.md：非线性工作流（含反馈循环）

### Changed
- README：从 Claude Code 专属改为工具无关
- 工作流：从单向改为含反馈循环（测试→开发→测试、部署→运维→部署）

## [0.9.0] - 2026-05-03

### Changed
- 增强 6 个核心 Agent prompt（编排总监、开发工程师、测试经理、架构师、运维工程师、技术文档师）
- 所有 Agent prompt 从 26-31 行增强到 52-139 行

## [0.8.0] - 2026-05-03

### Changed
- SKILL.md：修复"8 个 Agent"→"12 个 Agent"一致性问题
- SKILL.md：Agent 角色表扩展到 12 个，增加"模式"列区分 A/B
- SKILL.md：编号规则表补全所有 12 个 Agent
- SKILL.md：快速启动示例改为通用占位符
- README.md：重写为 12 Agent 结构，区分自驱动层和执行层

## [0.7.0] - 2026-05-03

### Added
- `agents/proactive-scout.md`：需求侦察兵（自驱动，持续监控市场 + 产品体检）
- SKILL.md：自驱动能力说明

### Changed
- 市场分析师：从被动分析改为主动发现（主动搜索竞品动态、用户痛点、市场趋势）
- 产品经理：从翻译需求改为主动创新（主动提出功能建议、产品路线图）
- Agent 角色从 11 个扩展到 12 个

## [0.6.0] - 2026-05-03

### Added
- `agents/feedback-analyst.md`：反馈分析师（收集用户反馈、bug 报告、竞品动态）
- `agents/iteration-planner.md`：迭代规划师（影响分析、迭代计划、版本策略）
- `templates/feedback_template.md`：反馈分析报告模板
- `templates/iteration_template.md`：迭代计划模板
- SKILL.md：两种模式（0-to-1 / 持续迭代）流程说明

### Changed
- Agent 角色从 9 个扩展到 11 个（新增反馈分析师、迭代规划师）
- SKILL.md：支撑文件索引更新

## [0.5.0] - 2026-05-03

### Added
- `agents/quality-gatekeeper.md`：质量门禁 Agent（代码审查 + lint 配置 + pre-commit hook + MCP 集成）
- `examples/cloudflow.md`：虚构项目 CloudFlow 的完整 worked example（替代真实项目）
- workflow_plan_template：新增质量门禁 Agent 定义和编号

### Changed
- 移除 `disable-model-invocation: true`，允许 Claude 自动触发 skill
- Example 从真实项目改为虚构项目 CloudFlow
- README 示例改为通用占位符

### Removed
- `examples/patchbay.md`（替换为虚构项目）

## [0.4.0] - 2026-05-03

### Added
- `agents/` 目录：8 个 Agent 的可直接使用 prompt 文件（含 `{{PROJECT_NAME}}` 占位符）
- `scripts/detect.sh`：项目自动检测脚本（技术栈、已有文档、测试覆盖、Git 状态）
- `examples/patchbay.md`：完整的 patchbay 项目 worked example（时间线、产出物、关键决策）
- SKILL.md 支撑文件索引（agents、scripts、examples）

### Changed
- SKILL.md：移除内联的"实际效果"段落，改为引用 `examples/patchbay.md`
- SKILL.md：支撑文件部分扩展为完整的文件索引

## [0.3.0] - 2026-05-03

### Added
- Frontmatter: `disable-model-invocation`, `allowed-tools`, `when_to_use`, `argument-hint`
- `$ARGUMENTS` 参数化支持：`/product-lifecycle [项目名] [描述]`
- `${CLAUDE_SKILL_DIR}/templates/` 模板引用
- 快速启动示例
- 模板目录索引表
- CHANGELOG.md

### Changed
- Agent 启动模板使用 `${CLAUDE_SKILL_DIR}` 引用模板文件

## [0.2.0] - 2026-05-03

### Added
- 市场分析师模板：在线调研方法清单（竞品、定价、用户痛点）
- 产品经理模板：网络调研清单（竞品功能、feature request、行业 idea）
- SKILL.md：WebSearch/WebFetch 在线调研指引
- README.md

### Changed
- QA 模板：移除 patchbay 特定内容，改为通用核心功能用例
- workflow_plan_template：补充编排总监、开发工程师、运维工程师、技术文档师 4 个 Agent
- 质量门禁：从 Go 特定（go test/go vet）改为语言无关

## [0.1.0] - 2026-05-03

### Added
- 初始版本：8 Agent 角色定义
- 7 个文档模板（market, product, architecture, developer, qa, devops, docwriter）
- workflow_plan_template
- SKILL.md 主文档
