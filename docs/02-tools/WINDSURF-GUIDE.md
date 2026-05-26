# Windsurf 集成指南

## 安装

```bash
git clone https://github.com/yclenove/product-lifecycle.git ~/.windsurf/skills/product-lifecycle
```

## 使用方式

### 方式 1：读取 Agent prompt

在 Windsurf 对话中：
```
读取 agents/orchestrator.md，按照指引执行编排总监角色。
项目描述：[你的项目]
```

### 方式 2：使用模板

```
读取 templates/market_template.md，按照格式输出市场分析报告。
```

## 注意事项

- Windsurf 不支持 Subagent，直接读取 agents/*.md
- 模板需要手动复制到项目 docs/ 目录
- 上下文管理参见 docs/CONTEXT-MANAGEMENT.md
