# CHANGELOG 维护指南

## 格式规范

遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)。

## 版本类型

| 类型 | 何时使用 | 示例 |
|------|----------|------|
| major (X.0.0) | 破坏性变更 | 删除 Agent、改变工作流 |
| minor (x.X.0) | 新功能 | 新增 Agent、新模板 |
| patch (x.x.X) | Bug 修复 | 修复引用、修正格式 |

## 条目规范

### Added — 新增功能
- 使用完整句子
- 包含文件路径
- 示例：`docs/01-getting-started/FAQ.md：常见问题（22 个问答）`

### Changed — 变更
- 说明变更内容和原因
- 示例：`agents/orchestrator.md：添加错误处理章节`

### Fixed — 修复
- 说明修复了什么问题
- 示例：`修复 PRODUCT_PLAN.md 虚引用`

## 自动化

```bash
# 生成 CHANGELOG 条目草稿
bash scripts/gen-changelog.sh 2.2.0

# 自动递增版本号
bash scripts/bump-version.sh minor
```

## 常见错误

| 错误 | 正确做法 |
|------|----------|
| 过程稿进 CHANGELOG | 只记录用户可见的变更 |
| 版本号不符合语义化 | 遵循 major.minor.patch |
| 条目过于笼统 | 具体到文件和变更内容 |
| 缺少日期 | 每个版本必须有日期 |