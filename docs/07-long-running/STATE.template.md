# 项目状态快照（STATE）

> 这是长程迭代模式的"心跳"文件。每个 Agent 启动时必读，完成阶段任务后必更新。

## 元数据

| 字段 | 值 |
|------|-----|
| 项目名称 | {{PROJECT_NAME}} |
| 当前迭代号 | v0.1 |
| 当前阶段 | brainstorming / market / product / arch / dev / qa / release |
| 启动日期 | YYYY-MM-DD |
| 最近更新 | YYYY-MM-DD HH:MM by <agent-name> |
| 总轮次 | 1 |

## 当前进行中

- **Agent**：`<agent-name>`（例：product-manager）
- **任务**：<一句话描述本轮要干什么>
- **预计完成**：YYYY-MM-DD
- **依赖**：<是否依赖前一个 Agent 的产出>

## 已完成 Agent 清单

按完成时间倒序排列。每项必须有：完成时间、Agent、关键产出（≤3 个 bullet）、关键决策（≤3 个）。

### 1. <example> market-analyst — 2026-05-27

- **产出**：`docs/iterations/_legacy-by-role/market/MKT-20260527-市场分析.md`
- **关键决策**：
  - 目标用户锁定中型 SaaS 公司技术团队
  - 竞品对标 Linear / Notion AI
  - 北极星指标：周活 Agent 调用次数

### 2. <agent-name> — YYYY-MM-DD

- **产出**：<path>
- **关键决策**：
  - ...

## 未完成 / 阻塞项

| 优先级 | 来源 Agent | 项 | 状态 | 阻塞原因 |
|--------|-----------|---|------|---------|
| P0 | product-manager | 退款规则待法务确认 | 阻塞 | 等用户提供合规要求 |
| P1 | architect | 缓存策略未定 | 待决策 | 需要 dba 评估 |
| P2 | — | — | — | — |

## 下一步建议

- **下一个 Agent**：`<agent-name>`
- **理由**：<为啥是它，依赖了谁的产出>
- **建议命令**：

  ```bash
  # 在 Claude Code 里
  > 调用 <agent-name> 接着上次的 STATE 继续做
  
  # 或在 Cursor 里
  > /agent <agent-name>
  ```

## 关键产出索引

汇总所有 Agent 的关键文档路径，方便 AI 一次性定位上下文。

| 类别 | 文件 |
|------|------|
| 市场分析 | docs/iterations/_legacy-by-role/market/MKT-YYYYMMDD-市场分析.md |
| PRD | docs/iterations/_legacy-by-role/product/PRD-YYYYMMDD-需求.md |
| 架构 | docs/iterations/_legacy-by-role/architecture/ARCH-YYYYMMDD-设计.md |
| 开发 | docs/iterations/_legacy-by-role/dev/DEV-YYYYMMDD-开发记录.md |
| QA | docs/iterations/_legacy-by-role/qa/QA-YYYYMMDD-验证报告.md |

## Token / 时间预算（可选）

| 阶段 | 累计 tokens | 累计耗时 |
|------|-----------|---------|
| market | 8k | 15 min |
| product | 25k | 1 h |
| arch | 40k | 2 h |
| dev | — | — |

## 风险登记（来自 PMO）

| 编号 | 风险 | 概率 | 影响 | 缓解措施 | 负责 |
|------|-----|------|------|---------|------|
| R-001 | 第三方支付 API 限流 | 中 | 高 | 接入沙箱压测 | architect |

---

**更新规则**：
1. 每个 Agent 任务结束前**必须**更新本文件
2. 决策项要言简意赅，超过 3 行的请写到对应阶段产出文档里
3. 「已完成清单」按时间倒序，最新的放最上面
4. 「阻塞项」要明确等谁解锁