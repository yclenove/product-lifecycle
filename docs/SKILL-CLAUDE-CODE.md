# Claude Code 中的用法

本文件供根目录 `SKILL.md` 引用；内容变更时只需改此处。

## 安装与快速启动

```bash
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle
```

在 Claude Code 中使用 slash 命令：

```
/product-lifecycle [项目名] [一句话描述]
```

示例：`/product-lifecycle myapp "SaaS 协作平台"`

编排总监会自动检测项目状态，只启动必要的 Agent（精简模式）。

## Subagent 定义（推荐）

`.claude/agents/` 目录包含正式的 subagent 定义：


| 文件                                       | 角色          | 工具限制                                         |
| ---------------------------------------- | ----------- | -------------------------------------------- |
| `.claude/agents/orchestrator.md`         | 编排总监        | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/project-manager.md`      | 项目经理（PMO）   | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/proactive-scout.md`      | 需求侦察兵       | Read, Glob, Grep, WebSearch, WebFetch, Write |
| `.claude/agents/market-analyst.md`       | 市场分析师       | Read, Glob, Grep, WebSearch, WebFetch, Write |
| `.claude/agents/product-manager.md`      | 产品经理        | Read, Glob, Grep, WebSearch, WebFetch, Write |
| `.claude/agents/ui-designer.md`          | UI/UX 设计师   | Read, Glob, Grep, Write, Edit                |
| `.claude/agents/architect.md`            | 架构师         | Read, Glob, Grep, Write, Edit                |
| `.claude/agents/dba.md`                  | 数据库管理员      | Read, Glob, Grep, Write, Edit                |
| `.claude/agents/developer.md`            | 开发工程师（通用）   | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/frontend-developer.md`   | 前端工程师       | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/backend-developer.md`    | 后端工程师       | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/qa-manager.md`           | 测试经理        | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/devops.md`               | 运维工程师       | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/security-engineer.md`    | 安全工程师       | Read, Glob, Grep, Write, Edit, Bash          |
| `.claude/agents/docwriter.md`            | 技术文档师       | Read, Glob, Grep, Write, Edit                |
| `.claude/agents/data-analyst.md`         | 数据分析师       | Read, Glob, Grep, WebSearch, WebFetch, Write, Edit, Bash |
| `.claude/agents/feedback-analyst.md`     | 反馈分析师       | Read, Glob, Grep, WebSearch, WebFetch, Write |
| `.claude/agents/iteration-planner.md`    | 迭代规划师       | Read, Glob, Grep, Write, Edit                |
| `.claude/agents/reviewer.md`             | 代码审查员       | Read, Glob, Grep, Write, Edit                |
| `.claude/agents/quality-gatekeeper.md`   | 质量门禁        | Read, Glob, Grep, Write, Edit, Bash          |


用法：在 Claude Code 中说「使用编排总监 agent」或「启动市场分析师 agent」。

特性：

- **动态上下文注入**：自动注入项目结构、技术栈、Git 状态
- **工具限制**：每个 Agent 只能使用指定的工具
- **模型选择**：默认使用 继承用户当前模型（orchestrator、architect）和 继承用户当前模型（其余 Agent），可在 .claude/agents/*.md 的 frontmatter 中按需指定

## 用 Agent 工具执行时的原则

使用 `Agent` 工具启动每个角色。关键原则：

1. **编排总监先启动** — 制定 WORKFLOW_PLAN.md，确认模板和门禁
2. **市场分析师 + 产品经理可并行** — 用多个 Agent 工具调用
3. **架构师等 PRD 初稿** — 依赖就绪后再启动
4. **开发、测试、运维、文档可并行** — 都依赖架构设计
5. **质量门禁逐项检查** — 发布前必须全部通过

**在线调研能力：** 市场分析师和产品经理 Agent 必须使用 WebSearch/WebFetch 工具进行在线调研，不能仅依赖项目文档。

## Agent 启动模板

```
你是 [项目名] 的 [角色]。

## 背景
[项目简介]

## 你的任务
1. 读取以下文件获取上下文：
   - [PROJECT]/docs/PRD-*.md
   - Read templates/[角色]_template.md
   - [相关代码文件]

2. [具体任务描述]

3. 输出到指定位置

## 质量要求
[从 WORKFLOW_PLAN 复制对应 Agent 的质量门禁]

## 约束
- 只写入指定目录
- 遵循双仓规范
```

详细的工作规范、编号规则、常见错误见 `docs/WORKFLOW_DETAILS.md`。

## 项目检测脚本

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/detect.sh [项目路径]
```

自动识别：技术栈、已有文档、测试覆盖、Git 状态。

## 高级用法

### 自定义 Agent 组合

```bash
# 只用核心 4 个 Agent
# 在对话中说：只启动编排总监、开发、测试、质量门禁

# 只用调研 Agent
# 在对话中说：启动市场分析师和产品经理，做竞品分析
```

### 工作流自定义

在 WORKFLOW_PLAN.md 中可以自定义：
- Agent 执行顺序
- 并行/串行策略
- 质量门禁标准
- 输出格式要求

### 上下文优化技巧

1. **分层读取**：先读摘要，按需读全文
2. **增量传递**：只传递变更部分
3. **预算控制**：在 agent prompt 中设置输出长度限制
4. **模型可在 frontmatter 中按需配置**（默认：继承用户当前模型 用于复杂推理，继承用户当前模型 用于常规任务）

## 与通用 prompt 的关系

通用文本 prompt 仍位于 `agents/`（见 `docs/SKILL-ASSETS.md`）。在 Claude Code 中优先使用 `.claude/agents/` 的 subagent 定义；其他场景读取 `agents/*.md`，替换 `{{PROJECT_NAME}}` 与 `{{PROJECT_DESCRIPTION}}` 后使用。