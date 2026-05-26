# [PRD-编号] 产品需求文档标题

> 💡 推荐先读 skill：`brainstorming`、`writing-plans`、`chinese-documentation`

| 字段 | 值 |
|------|-----|
| 版本 | v0.1（初稿） |
| 作者 | 产品经理 |
| 日期 | YYYY-MM-DD |
| 状态 | 草稿 |
| 关联文档 | docs/iterations/current/product/PRD-*.md §5-§7, MKT-xxx |

---

## 1. 概述 [必填]

### 1.1 文档目的 [必填]

> 说明本文档覆盖的范围和目标读者。

### 1.2 产品愿景 [必填]

> 一句话描述产品定位。

### 1.3 范围界定 [必填]

> 明确本期（Phase）包含和不包含的功能。

### 1.4 网络调研 [必填]

> **必须使用 WebSearch/WebFetch 工具进行在线调研**，补充市场分析师的发现。
>
> 调研清单：
> - [ ] 搜索竞品功能列表和 roadmap（"[竞品名] features"、"[竞品名] roadmap"）
> - [ ] 搜索用户痛点（"[领域] pain points"、"[领域] problems"、"I wish [产品] had"）
> - [ ] 搜索同类产品的 feature request（GitHub Issues、Product Hunt 评论）
> - [ ] 搜索行业 idea 和趋势（"[领域] trends 2026"、"[领域] innovations"）
> - [ ] 搜索类似产品的差异化卖点（"[竞品] alternative"、"best [领域] tools"）

## 2. 用户故事 [必填]

### 2.1 核心用户故事 [必填]

> 以 "作为[角色]，我希望[功能]，以便[价值]" 格式列出。
>
> **调研要求：** 使用 WebSearch 搜索 "[领域] user stories"、"[竞品] use cases"，参考同类产品的真实用例。搜索 "[领域] feature requests" 获取用户真正想要的功能。

### 2.2 用户旅程 [可选]

> 关键场景的用户操作流程。

## 3. 功能需求 [必填]

### 3.1 功能清单 [必填]

> 表格形式，每项包含：ID、功能名称、优先级（P0/P1/P2）、实现状态、验收标准。
>
> **调研要求：** 使用 WebSearch 搜索 "[竞品] features comparison"、"[领域] must have features"，确保功能清单覆盖用户核心需求。搜索 Product Hunt 上同类产品的功能亮点获取灵感。

### 3.2 功能详细说明 [必填]

> 每个 P0 功能独立小节，包含：描述、输入/输出、业务规则、边界条件。

## 4. 非功能需求 [必填]

> 与 docs/iterations/current/product/PRD-*.md NFR 章节对齐，表格形式列出：类别、要求、验收标准。

## 5. 数据模型 [条件：涉及数据变更]

> 新增或变更的数据实体、字段、关系。

## 6. API 契约 [条件：涉及 API 变更]

> 新增或变更的 API 端点、请求/响应格式。

## 7. 验收标准 [必填]

> 每个 P0 功能的验收标准，使用 Given/When/Then 格式。

## 8. 优先级与排期 [必填]

> 功能优先级矩阵和建议的实现顺序。

## 9. 风险与依赖 [必填]

> 技术风险、外部依赖、已知限制。

## 10. 开放问题 [必填]

> 待决策的问题列表。

## 11. 修订记录 [必填]

| 版本 | 日期 | 作者 | 变更说明 |
|------|------|------|----------|
| v0.1 | YYYY-MM-DD | 产品经理 | 初稿 |

---

<details>
<summary>使用示例（点击展开）</summary>

### 示例：用户注册功能 PRD

**用户故事：** 作为新用户，我希望通过邮箱注册账号，以便使用平台功能。

**验收标准：**
- Given 用户输入有效邮箱和密码，When 点击注册，Then 账号创建成功
- Given 邮箱已注册，When 点击注册，Then 提示"邮箱已注册"
- Given 密码少于 8 位，When 点击注册，Then 提示"密码过短"

</details>

## 图示要求 [必填]

> 完整规范见 `docs/05-advanced/DIAGRAMMING.md`。优先用 **drawio MCP** 生成 SVG，放到同级 `assets/` 下。

**本类文档至少包含：**

用户旅程图（必）、主要业务流程图（必）；用例图、信息架构（建议）

**嵌入语法：**

```markdown
![<图标题>](assets/<文档ID>-<图类型>.svg)
> 源文件：`assets/<文档ID>-<图类型>.drawio`
```

**离线 / 简图可降级 Mermaid**（```mermaid 代码块）。
