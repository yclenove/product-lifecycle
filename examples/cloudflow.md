# Worked Example: CloudFlow 项目

> 使用 product-lifecycle skill 驱动 CloudFlow（云原生工作流自动化平台）从 0 到 1 的完整过程。
> 注：本例为虚构项目，用于演示完整流程。

## 项目背景

- **项目名：** CloudFlow
- **描述：** 云原生工作流自动化平台，支持可视化编排、多云部署、实时监控
- **技术栈：** Go + PostgreSQL + Vue 3 + Docker + Kubernetes

## 执行过程

### Phase 1: 调研与规划（30 分钟）

**编排总监：** 确认项目从 0 开始，需要完整生命周期。启动 4 个 Agent。

**市场分析师（在线调研）：**
- WebSearch: "workflow automation platform open source", "low-code workflow engine"
- WebSearch: "n8n vs Zapier vs Temporal comparison"
- WebFetch: 访问竞品官网获取定价
- 产出：市场分析报告，4 竞品（n8n、Temporal、Apache Airflow、Zapier），3 用户画像

**产品经理（在线调研）：**
- WebSearch: "workflow automation pain points", "business process automation problems"
- WebSearch: "workflow engine feature requests github"
- 产出：PRD，12 功能项，每个 P0 功能有 Given/When/Then 验收标准

### Phase 2: 设计（30 分钟）

**架构师：** 读取 PRD，产出技术设计文档：
- 8 张数据表（workflows, steps, executions, logs 等）
- 22 个 API 端点（RESTful）
- Docker Compose + K8s 部署方案
- 核心流程时序图（用户编排 → 触发执行 → 步骤调度 → 日志收集）

### Phase 3: 实现（60 分钟）

**开发工程师：** 并行实现核心功能：
- 可视化工作流编排引擎
- 步骤调度器（支持顺序/并行/条件分支）
- 执行日志实时收集

**测试经理：** 38 个测试用例，P0 用例 100% 通过

**质量门禁 Agent：** 代码质量检查：
- 发现 3 处缺少错误处理，自动添加
- 添加 golangci-lint 配置和 pre-commit hook
- 安装 MCP 工具用于后续质量监控

### Phase 4: 部署（30 分钟）

**运维工程师：**
- Docker Compose 本地开发环境
- K8s Helm Chart 生产部署
- 健康检查通过

**技术文档师：**
- README.md（快速开始）
- API 文档（22 个端点 + curl 示例）

## 产出物清单

| 文档 | Agent |
|------|-------|
| MKT-001-市场分析报告.md | 市场分析师 |
| PRD-001-产品需求文档.md | 产品经理 |
| ARCH-001-系统架构设计.md | 架构师 |
| QA-001-测试计划.md | 测试经理 |
| README.md | 技术文档师 |
| **总计** | 完整可运行产品 |

## 关键决策

| 决策 | 选择 | 理由 |
|------|------|------|
| 工作流引擎 | 自研 DAG 调度器 | 灵活性高，无外部依赖 |
| 数据库 | PostgreSQL | JSONB 支持灵活的 workflow 定义 |
| 前端框架 | Vue 3 | 轻量、组合式 API 适合编排 UI |
| 部署方式 | Docker + K8s | 本地开发 + 生产部署统一 |

## 时间线

```
00:00  编排总监启动
00:05  市场分析师 + 产品经理并行启动
00:35  架构师启动（PRD 初稿就绪）
01:05  开发 + 测试 + 运维 + 文档 + 质量门禁并行启动
02:05  质量门禁检查
02:35  部署完成，健康检查通过
```
