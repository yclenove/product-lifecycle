# Cursor Rules 集成指南

## 与 .cursorrules 的关系

product-lifecycle 的 Agent prompt 可以集成到 .cursorrules 中：

### 方法 1：引用式
在 `.cursorrules` 中引用：
```markdown
## 产品开发流程
遵循 product-lifecycle 的 Agent prompt 和模板。
详细指引见 agents/orchestrator.md。
```

### 方法 2：内联式
将关键 Agent prompt 直接写入 `.cursorrules`：
```markdown
## 编排总监规则
[从 agents/orchestrator.md 复制核心内容]

## 开发工程师规则
[从 agents/developer.md 复制核心内容]
```

### 方法 3：混合式
核心规则内联，详细指引引用：
```markdown
## 开发规范
- 代码风格：[内联关键规则]
- 安全规范：[内联关键规则]
- 完整指引：见 agents/developer.md
```

## 推荐

- 小型项目：方法 2（内联式，减少文件读取）
- 中型项目：方法 3（混合式，平衡）
- 大型项目：方法 1（引用式，保持同步）
