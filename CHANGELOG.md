# Changelog

All notable changes to this skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/).

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
