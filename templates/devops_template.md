# [OPS-编号] 运维任务标题

> 💡 推荐先读 skill：`verification-before-completion`、`systematic-debugging`、`writing-plans`

| 字段 | 值 |
|------|-----|
| 版本 | v0.1（初稿） |
| 作者 | 运维工程师 |
| 日期 | YYYY-MM-DD |
| 状态 | 草稿 |
| 关联文档 | ARCH-xxx, DEV-xxx |

---

## 1. 任务概述 [必填]

### 1.1 目标环境 [必填]

> 操作系统、Docker 版本、网络环境。

### 1.2 部署范围 [必填]

> 本次部署包含的服务和组件。

### 1.3 前置条件 [必填]

> 部署前需要满足的条件。

## 2. 环境搭建 [必填]

### 2.1 软件安装 [必填]

> 安装的软件及版本。

### 2.2 环境变量配置 [必填]

> .env 文件内容和说明。

### 2.3 网络配置 [条件：涉及网络变更]

> 端口映射、防火墙规则。

## 3. 部署步骤 [必填]

### 3.1 数据库部署 [必填]

> PostgreSQL 容器启动、初始化。

### 3.2 应用部署 [必填]

> Docker Compose 启动、配置说明。

### 3.3 前端部署 [条件：涉及前端]

> 静态资源托管、nginx 配置。

## 4. 验证 [必填]

### 4.1 健康检查 [必填]

> 健康检查命令和预期结果。

### 4.2 功能验证 [必填]

> 基本功能的验证步骤。

### 4.3 性能基线 [可选]

> 基本性能指标。

## 5. 监控与告警 [必填]

### 5.1 日志查看 [必填]

> 日志位置和查看命令。

### 5.2 指标监控 [可选]

> Prometheus 指标和 Grafana 面板。

### 5.3 告警规则 [可选]

> 关键告警规则。

## 6. 已知问题 [必填]

> 部署过程中遇到的问题和解决方案。

## 7. 环境报告 [必填]

> 各组件版本、端口占用、容器状态。

## 8. 后续优化 [必填]

> 环境优化建议。

## 9. 修订记录 [必填]

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v0.1 | YYYY-MM-DD | 运维工程师 | 初稿 |

---

<details>
<summary>使用示例（点击展开）</summary>

### 示例：Docker Compose 部署

**环境变量配置（.env）：**
```
POSTGRES_DB=appdb
POSTGRES_USER=app
POSTGRES_PASSWORD=secret123
JWT_SECRET=your-secret-key
APP_PORT=3000
```

**部署步骤：**
```bash
# 1. 启动数据库
docker compose up -d postgres
# 2. 等待健康检查通过
docker compose exec postgres pg_isready
# 3. 启动应用
docker compose up -d app
# 4. 查看日志
docker compose logs -f app
```

**健康检查：**
```bash
curl http://localhost:3000/health
# 预期输出: {"status":"ok","db":"connected"}
```

**环境报告：**
| 组件 | 版本 | 端口 | 状态 |
|------|------|------|------|
| PostgreSQL | 16.2 | 5432 | running |
| App | v1.0.0 | 3000 | running |

</details>

## 图示要求 [必填]

> 完整规范见 `docs/05-advanced/DIAGRAMMING.md`。优先用 **drawio MCP** 生成 SVG，放到同级 `assets/` 下。

**本类文档至少包含：**

部署架构图（必）、CI/CD 流水线图（必）；网络拓扑（建议）

**嵌入语法：**

```markdown
![<图标题>](assets/<文档ID>-<图类型>.svg)
> 源文件：`assets/<文档ID>-<图类型>.drawio`
```

**离线 / 简图可降级 Mermaid**（```mermaid 代码块）。
