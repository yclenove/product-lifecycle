# Worked Example: Patchbay 项目

> 使用 product-lifecycle skill 驱动 patchbay（企业级消息中继平台）从 0 到 1 的完整过程。

## 项目背景

- **项目名：** patchbay
- **描述：** 企业级消息中继平台，支持多目标广播、路由规则、控制台管理
- **技术栈：** Go + PostgreSQL + React + Docker

## 执行过程

### Phase 1: 调研与规划（30 分钟）

**编排总监：** 确认项目从 0 开始，需要完整生命周期。启动 4 个 Agent。

**市场分析师（在线调研）：**
- WebSearch: "message relay platform open source", "enterprise message routing"
- WebSearch: "messagequeue vs rabbitmq vs nats comparison"
- WebFetch: 访问竞品官网获取定价
- 产出：332 行市场分析报告，4 竞品（RabbitMQ、NATS、Apache Kafka、Redis Streams），3 用户画像

**产品经理（在线调研）：**
- WebSearch: "message relay pain points", "enterprise messaging problems"
- WebSearch: "message routing feature requests github"
- 产出：PRD，15 功能项，每个 P0 功能有 Given/When/Then 验收标准

### Phase 2: 设计（30 分钟）

**架构师：** 读取 PRD，产出技术设计文档：
- 10 张数据表（rules, destinations, messages, rule_destinations 等）
- 27 个 API 端点（RESTful）
- Docker Compose 部署方案（Go app + PostgreSQL + React frontend）
- 核心流程时序图（消息接收 → 规则匹配 → 多目标广播）

### Phase 3: 实现（60 分钟）

**开发工程师：** 并行实现 3 个核心功能：
- rule_destinations 关联表（多对多关系）
- 多目标广播逻辑（一条消息 → N 个目标）
- 前端多选目标组件

**测试经理：** 42 个测试用例，P0 用例 100% 通过

### Phase 4: 部署（30 分钟）

**运维工程师：**
- WSL 环境搭建（Go 1.26、Node.js 22、PostgreSQL 17）
- Docker Compose 一键启动
- 健康检查通过

**技术文档师：**
- README.md（快速开始）
- API 文档（27 个端点 + curl 示例）

## 产出物清单

| 文档 | 行数 | Agent |
|------|------|-------|
| MKT-001-市场分析报告.md | 332 | 市场分析师 |
| PRD-001-产品需求文档.md | 280 | 产品经理 |
| ARCH-001-系统架构设计.md | 450 | 架构师 |
| QA-001-测试计划.md | 200 | 测试经理 |
| README.md | 80 | 技术文档师 |
| **总计** | **3582 行设计文档** | + 完整可运行产品 |

## 关键决策

| 决策 | 选择 | 理由 |
|------|------|------|
| 消息存储 | PostgreSQL | 事务支持好，适合规则匹配 |
| 多目标关联 | rule_destinations 表 | 灵活的多对多关系 |
| 前端框架 | React | 生态成熟，组件丰富 |
| 部署方式 | Docker Compose | 开发环境一致性 |

## 时间线

```
00:00  编排总监启动
00:05  市场分析师 + 产品经理并行启动
00:35  架构师启动（PRD 初稿就绪）
01:05  开发 + 测试 + 运维 + 文档并行启动
02:05  质量门禁检查
02:35  部署完成，健康检查通过
```

**总耗时：约 2.5 小时**，从零到完整可运行产品 + 3582 行设计文档。
