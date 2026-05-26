# [FE-编号] 前端开发任务标题

> 💡 推荐先读 skill：`test-driven-development`、`systematic-debugging`、`chinese-commit-conventions`

| 字段 | 值 |
|------|-----|
| 版本 | v0.1（初稿） |
| 作者 | 前端工程师 |
| 日期 | YYYY-MM-DD |
| 状态 | 草稿 |
| 关联文档 | PRD-xxx、ARCH-xxx、UI-xxx、API-xxx |

---

## 1. 任务概述 [必填]

### 1.1 需求来源
> 引用 PRD 验收标准和 UI 交互稿。

### 1.2 实现范围
> 包含 / 不包含。

### 1.3 技术决策
> 框架、状态管理、路由、样式方案。

## 2. 实现细节 [必填]

### 2.1 组件树
```
<Page>
  <Header />
  <Main>
    <Feature />
  </Main>
  <Footer />
</Page>
```

### 2.2 关键组件
| 组件 | 路径 | 职责 | props |
|------|------|------|-------|

### 2.3 状态管理
| 状态 | 类型 | 存储位置 | 说明 |
|------|------|----------|------|

### 2.4 API 调用
| API | 方法 | 端点 | hook/service |
|-----|------|------|--------------|

### 2.5 设计令牌消费
> 列出新增/修改的 CSS variables 或 Tailwind 配置。

## 3. 测试 [必填]

### 3.1 组件单元测试
> Vitest + Testing Library。

### 3.2 集成测试
> 关键流程测试。

### 3.3 E2E（如有）
> Playwright 脚本。

### 3.4 视觉回归（如有）
> Chromatic / snapshot。

## 4. 性能 [必填]

| 指标 | 目标 | 实际 |
|------|------|------|
| LCP | < 2.5s | |
| INP | < 200ms | |
| CLS | < 0.1 | |
| Bundle (gzip, 首屏) | < 200KB | |

## 5. 可访问性 [必填]

- [ ] axe-core 无 critical
- [ ] 键盘操作完整
- [ ] 对比度达标
- [ ] 屏幕阅读器测试通过

## 6. 兼容性 [必填]

| 浏览器 | 版本 | 测试结果 |
|--------|------|----------|
| Chrome | 最新 | ✓ |
| Safari | 最新 | ✓ |
| Firefox | 最新 | ✓ |
| Edge | 最新 | ✓ |
| 移动端 | iOS Safari / Android Chrome | ✓ |

## 7. 文件清单 [必填]

> 本次变更涉及的所有文件列表。

## 8. 验证步骤 [必填]

```bash
npm run dev
# 打开 http://localhost:5173/[路由]
# 验收：[具体场景]
```

## 9. 修订记录 [必填]

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v0.1 | YYYY-MM-DD | 前端工程师 | 初稿 |

## 图示要求 [必填]

> 完整规范见 `docs/05-advanced/DIAGRAMMING.md`。优先用 **drawio MCP** 生成 SVG，放到同级 `assets/` 下。

**本类文档至少包含：**

组件层级图（必）、关键状态机（必）；路由图（建议）

**嵌入语法：**

```markdown
![<图标题>](assets/<文档ID>-<图类型>.svg)
> 源文件：`assets/<文档ID>-<图类型>.drawio`
```

**离线 / 简图可降级 Mermaid**（```mermaid 代码块）。
