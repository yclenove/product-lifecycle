# 性能基准

## Token 消耗基准（12 Agent 全流程）

| 阶段 | Agent | 预估 Input | 预估 Output | 模型 |
|------|-------|-----------|-------------|------|
| 编排 | orchestrator | 2000 | 3000 | opus |
| 调研 | market-analyst | 3000 | 2000 | sonnet |
| 调研 | product-manager | 3000 | 2500 | sonnet |
| 设计 | architect | 4000 | 3000 | opus |
| 实现 | developer | 5000 | 1500 | sonnet |
| 测试 | qa-manager | 3000 | 1500 | sonnet |
| 部署 | devops | 3000 | 1500 | sonnet |
| 文档 | docwriter | 3000 | 2000 | haiku |
| 审查 | quality-gatekeeper | 3000 | 1500 | haiku |
| **总计** | | **~32,000** | **~18,500** | |

## 迭代场景 Token 消耗（模式 B 单轮）

| 阶段 | Agent | 预估 Input | 预估 Output |
|------|-------|-----------|-------------|
| 侦察 | proactive-scout | 2000 | 2000 |
| 反馈 | feedback-analyst | 2000 | 2000 |
| 规划 | iteration-planner | 3000 | 2500 |
| 实现 | developer | 4000 | 1500 |
| 审查 | quality-gatekeeper | 2000 | 1500 |
| **总计** | | **~13,000** | **~9,500** |

## 优化目标

- 全流程 Token 消耗 < 50,000
- 单轮迭代 Token 消耗 < 25,000
- 摘要传递减少 40% 上下文
