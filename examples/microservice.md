# Worked Example: TaskFlow 微服务项目

> 使用 product-lifecycle skill 驱动 TaskFlow（分布式任务调度平台）从 0 到 1 的完整过程。
> 注：本例为虚构项目，用于演示模式 A 完整流程。

## 项目背景

- **项目名：** TaskFlow
- **描述：** 分布式任务调度平台，支持定时任务、工作流编排、任务依赖管理
- **技术栈：** Go + gRPC + PostgreSQL + Redis + Docker + Kubernetes

## 执行过程

### Phase 1: 调研与规划（25 分钟）

**编排总监：** 确认项目从 0 开始，需要完整生命周期。启动 4 个 Agent。

**市场分析师（在线调研）：**
- WebSearch: "distributed task scheduler open source", "cron job orchestration platform"
- WebSearch: "Temporal vs Celery vs XXL-Job comparison"
- WebFetch: 访问竞品 GitHub 获取 star 数和 issue 分析
- 产出：市场分析报告，5 竞品对比，3 目标用户画像

**产品经理（在线调研）：**
- WebSearch: "task scheduling pain points", "distributed job orchestration problems"
- 产出：PRD，15 功能项，核心功能有 Given/When/Then 验收标准

### Phase 2: 设计（30 分钟）

**架构师：** 读取 PRD，产出技术设计文档：
- 微服务架构：scheduler-service、worker-service、api-gateway、metadata-service
- 6 张数据表（tasks, workflows, executions, workers, logs, schedules）
- gRPC 内部通信 + RESTful 外部 API（18 个端点）
- Docker Compose 本地开发 + K8s Helm Chart 生产部署

### Phase 3: 实现（60 分钟）

**开发工程师：** 并行实现 4 个微服务：
- scheduler-service：任务调度引擎（cron 解析、依赖检查、任务分发）
- worker-service：任务执行器（进程隔离、超时控制、重试机制）
- api-gateway：统一入口（认证、限流、路由）
- metadata-service：元数据管理（任务定义、工作流配置）

**测试经理：** 42 个测试用例，P0 用例 100% 通过

**代码审查员：** 深度代码审查：
- 发现 2 处 goroutine 泄漏（阻塞问题）
- 发现 3 处缺少 error 返回值检查（阻塞问题）
- 发现 5 处 N+1 查询（警告）
- 提出 8 条可维护性改进建议
- 产出：CR-001-代码审查报告.md，评级 B

**质量门禁 Agent：** 代码质量检查：
- golangci-lint 配置
- pre-commit hook 设置
- 安全扫描通过

### Phase 4: 部署（30 分钟）

**运维工程师：**
- Docker Compose 本地开发环境（5 个服务）
- K8s Helm Chart 生产部署
- 健康检查 + 服务发现配置

**技术文档师：**
- README.md（快速开始）
- API 文档（18 个端点 + curl 示例）
- 架构图（Mermaid）

## 产出物清单

| 文档 | Agent |
|------|-------|
| MKT-001-市场分析报告.md | 市场分析师 |
| PRD-001-产品需求文档.md | 产品经理 |
| ARCH-001-系统架构设计.md | 架构师 |
| CR-001-代码审查报告.md | 代码审查员 |
| QA-001-测试计划.md | 测试经理 |
| README.md | 技术文档师 |
| **总计** | 完整可运行微服务系统 |

## 关键决策

| 决策 | 选择 | 理由 |
|------|------|------|
| 服务间通信 | gRPC | 高性能、强类型、流式支持 |
| 任务队列 | Redis Streams | 持久化、消费者组、轻量 |
| 数据库 | PostgreSQL | JSONB 支持灵活的任务定义 |
| 部署方式 | Docker + K8s | 本地开发 + 生产部署统一 |

## 时间线

```
00:00  编排总监启动
00:05  市场分析师 + 产品经理并行启动
00:30  架构师启动（PRD 初稿就绪）
01:00  开发 + 测试 + 运维 + 文档 + 代码审查员并行启动
02:00  代码审查完成，发现 5 个阻塞问题
02:10  开发修复阻塞问题
02:20  质量门禁检查通过
02:30  部署完成，健康检查通过
```

## 后续迭代

TaskFlow v1.0 发布后，可进入模式 B（持续迭代）：

1. **需求侦察兵** 持续监控任务调度市场动态
2. **反馈分析师** 收集用户反馈（GitHub Issues、社区论坛）
3. **迭代规划师** 制定 v1.1 计划（如：增加 DAG 可视化、支持更多触发器）
4. 流程循环回到开发 → 测试 → 代码审查 → 质量门禁 → 发布

代码审查员在迭代中持续发挥作用，确保每次变更都经过质量审查。
