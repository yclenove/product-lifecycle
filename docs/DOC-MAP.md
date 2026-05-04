# 文档导航地图

## 入口文档

| 文档 | 用途 | 何时读取 |
|------|------|----------|
| `SKILL.md` | Claude Code 入口 | 每次使用 skill 时 |
| `README.md` | 项目概览 | 首次了解项目时 |
| `docs/QUICK-START.md` | 快速入门 | 首次使用时 |

## 按工具分类

### Claude Code 用户
```
SKILL.md → docs/SKILL-CLAUDE-CODE.md → agents/*.md
```

### Cursor 用户
```
SKILL.md → docs/SKILL-CURSOR.md → .cursor/agents/*.md → agents/*.md
```

### 其他工具
```
SKILL.md → docs/SKILL-OTHER-TOOLS.md → agents/*.md
```

## 按角色分类

### 新用户
1. `README.md` — 了解项目
2. `docs/QUICK-START.md` — 5 分钟上手
3. `docs/FAQ.md` — 解决疑问
4. `docs/DECISION-TREE.md` — 选择 Agent 组合

### 日常使用
1. `SKILL.md` — 启动入口
2. `agents/*.md` — Agent prompt
3. `templates/*.md` — 文档模板
4. `docs/CONSISTENCY-CHECKLIST.md` — 迭代工作流

### 维护者
1. `docs/CONSISTENCY-CHECKLIST.md` — 一致性规则
2. `docs/WORKFLOW_DETAILS.md` — 工作流详情
3. `docs/CONTEXT-MANAGEMENT.md` — 上下文管理
4. `docs/SECURITY.md` — 安全指南
5. `docs/TOKEN-EFFICIENCY.md` — Token 优化

## 文档依赖关系
```
SKILL.md
├── docs/SKILL-CURSOR.md
├── docs/SKILL-CLAUDE-CODE.md
├── docs/SKILL-OTHER-TOOLS.md
├── docs/SKILL-ASSETS.md
│   ├── agents/*.md（12 个）
│   └── templates/*.md（13 个）
├── docs/WORKFLOW_DETAILS.md
├── docs/CONTEXT-MANAGEMENT.md
├── docs/SECURITY.md
├── docs/QUICK-START.md
├── docs/DECISION-TREE.md
├── docs/FAQ.md
├── examples/*.md（3 个）
└── scripts/*.sh（6+ 个）
```
