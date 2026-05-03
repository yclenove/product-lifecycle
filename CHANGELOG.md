# Changelog

All notable changes to this skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/).

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
