# 排障指南

## 常见问题

### 1. Agent 输出过长，上下文窗口溢出

**症状：** Agent 中途截断，输出不完整

**解决：**
- 检查 CONTEXT-MANAGEMENT.md 中的输出预算
- 在 agent prompt 中添加"控制在 XXX 字以内"
- 使用摘要传递而非全文传递

### 2. .claude/agents/ 与 agents/ 不同步

**症状：** 改了 agents/ 但 .claude/agents/ 没更新

**解决：**
```bash
bash scripts/sync-agents.sh
```

### 3. Cursor 中无法调用 Subagent

**症状：** `/orchestrator` 无响应

**解决：**
- 确认 .cursor/agents/ 目录存在
- 运行 `bash scripts/install-cursor-subagents.sh`
- 检查 .cursor/agents/orchestrator.md 的 Read 路径

### 4. 本机 skill 不是最新版本

**症状：** /product-lifecycle 用的是旧版

**解决：**
```bash
bash scripts/iterate.sh
```

### 5. CHANGELOG 版本号混乱

**症状：** Unreleased 中有过程稿条目

**解决：**
- 只在 [Unreleased] 中放注释占位符
- 正式条目放在具体版本号下
- 过程稿（ITER-xxx、SCOUT-xxx）不进 CHANGELOG

### 6. 模板中的 PRODUCT_PLAN.md 引用

**症状：** 模板引用不存在的文件

**解决：** 替换为 `docs/PRD-*.md`

### 7. 搜索关键词年份过时

**症状：** Agent 搜索用 "trends 2025"

**解决：** 批量替换为当前年份

### 8. workflow_plan_template 编号不完整

**症状：** 缺少 SCOUT/FB/ITER 编号

**解决：** 检查并补全所有 11 个 Agent 的编号

### 9. model 字段未分级

**症状：** 所有 Agent 都用 继承用户当前模型

**解决：** 参考 SKILL-ASSETS.md 的模型选择策略

### 10. 文档交叉引用断链

**症状：** 链接指向不存在的文件

**解决：** `grep -rn` 搜索引用，修复或移除
