# 快速入门指南

## 30 秒理解

product-lifecycle 是一个 12 Agent 产品开发全流程框架。它不是一个代码生成器——它是一套方法论，通过专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代。

**核心价值：** 不再手动协调调研、设计、开发、测试、部署——Agent 自动编排。

## 5 分钟体验

### Claude Code 用户

```bash
# 1. 安装（一次性）
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle

# 2. 使用
/product-lifecycle myapp "一个简单的待办事项应用"
```

编排总监会自动检测项目状态，制定工作流，启动必要的 Agent。

### Cursor 用户

```bash
# 1. 安装（一次性）
git clone https://github.com/yclenove/product-lifecycle.git ~/.cursor/skills/product-lifecycle

# 2. 使用 — 方式 A：完整流程
# 在对话中说：读取 ~/.cursor/skills/product-lifecycle/SKILL.md，按照指引执行

# 3. 使用 — 方式 B：单独角色
# 在对话中说：/orchestrator
```

### 其他工具用户

```bash
# 1. 克隆仓库
git clone https://github.com/yclenove/product-lifecycle.git

# 2. 在对话中说：
# 读取 agents/orchestrator.md，按照指引执行编排总监角色。
# 项目描述：[你的项目描述]
```

## 最小可用集（4 个核心 Agent）

不需要一次用全部 13 个 Agent。从这 4 个开始：

| Agent | 职责 | 何时用 |
|-------|------|--------|
| 编排总监 | 制定框架 | **必选** — 每次都从这里开始 |
| 开发工程师 | 代码实现 | **必选** — 有代码要写 |
| 测试经理 | 测试验证 | **必选** — 验证实现 |
| 质量门禁 | 代码审查 | **必选** — 发布前审查 |

**进阶：** 熟练后逐步加入市场分析师、产品经理、架构师等。

## 常见问题

**Q: 我的小项目也需要 13 个 Agent 吗？**
A: 不需要。用 4 个核心 Agent 就够了。详见上面的「最小可用集」。

**Q: 我用的是 Windsurf / OpenCode / 其他工具，能用吗？**
A: 能。核心价值在 `agents/` 目录的 prompt 文件，任何 AI 工具都能读取使用。

**Q: Agent 执行太慢怎么办？**
A: 使用渐进式采用——只启动必要的 Agent。编排总监会自动判断。

**Q: 上下文窗口不够用怎么办？**
A: 参见 `docs/CONTEXT-MANAGEMENT.md`，包含摘要传递和上下文预算机制。

**Q: 如何只用核心 Agent 跳过调研？**
A: 直接启动编排总监，它会检测项目状态。如果有代码，自动进入模式 B（持续迭代），跳过市场分析。

## 进阶用法

### 自定义 Agent

1. 复制 `agents/developer.md` 为 `agents/security-auditor.md`
2. 修改内容为安全审计角色
3. 在 `scripts/sync-agents.sh` 中添加配置
4. 运行 `bash scripts/sync-agents.sh`

### 集成到 CI/CD

在 CI 流程中使用质量门禁：

```yaml
# .github/workflows/quality.yml
- name: Quality Gate
  run: bash scripts/validate.sh
```

### 多项目管理

每个项目独立的 docs/ 目录，共享同一套 agents/ 和 templates/。

### Agent 组合选择

根据项目规模选择合适的 Agent 组合：

| 场景 | Agent 组合 | 预计耗时 |
|------|-----------|----------|
| 快速原型 | 编排 + 开发 | 30 分钟 |
| MVP | 编排 + 开发 + 测试 | 1 小时 |
| 正式发布 | 核心 4 个 | 2 小时 |
| 完整项目 | 全部 13 个 | 4-8 小时 |
| 持续迭代 | 侦察 + 反馈 + 规划 + 核心 4 个 | 每轮 1-2 小时 |

详细的决策树请参考 `docs/DECISION-TREE.md`。

### 上下文管理优化

当 Agent 输出过多或过少时，可以调整上下文预算：

1. 在 agent prompt 中修改"控制在 XXX 字以内"
2. 使用摘要传递机制减少上下文消耗
3. 参考 `docs/CONTEXT-MANAGEMENT.md` 了解详细策略
