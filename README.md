# product-lifecycle

[![Quality Gate](https://github.com/yclenove/product-lifecycle/actions/workflows/quality-gate.yml/badge.svg)](https://github.com/yclenove/product-lifecycle/actions/workflows/quality-gate.yml)

通过 12 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。

**工具无关** — 核心价值（Agent prompt + 文档模板 + 方法论）可在任何 AI 编码工具中使用。

## 多工具使用

### Claude Code

```bash
# 安装
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle

# 使用
/product-lifecycle [项目名] [一句话描述]
```

SKILL.md 作为入口，自动加载 Agent prompt 和模板。

### Cursor

本仓库**整个就是技能包**：根目录 `SKILL.md` 为总入口（含各工具文档索引）。**Cursor 与 PACKAGE_ROOT**、**Subagents（`.cursor/agents/`、与 CC 对齐）** 的完整说明见 `docs/SKILL-CURSOR.md`（已与 [Cursor 官方：Subagents](https://cursor.com/docs/subagents) 校对）；在**任意业务工作区**也可通过环境变量、嵌套 clone 或询问路径解析技能包根目录，产出仍写在业务项目的 `docs/`。

**两种用法：**

1. **全局（推荐，任意项目）**  
   把整个仓库克隆到 Cursor 个人技能目录（与目录名一致，便于识别）：

   ```bash
   # Windows PowerShell
   git clone https://github.com/yclenove/product-lifecycle.git "$env:USERPROFILE\.cursor\skills\product-lifecycle"

   # macOS / Linux
   git clone https://github.com/yclenove/product-lifecycle.git ~/.cursor/skills/product-lifecycle
   ```

   建议设置环境变量 **`PRODUCT_LIFECYCLE_ROOT`** 为上述路径，避免解析歧义。之后在别的项目里打开工作区，技能仍可按描述加载，并按 `SKILL.md` / `docs/SKILL-*.md` 从该路径 **Read** prompt 与分文档说明。

2. **仅随本仓库**  
   以本仓库为工作区时，另有 `.cursor/skills/product-lifecycle/SKILL.md`（与 `docs/SKILL-CURSOR.md` 的 PACKAGE_ROOT 规则一致，自动加载）。适合在本仓库内开发技能本身。

3. **与 Claude Code 对齐（推荐）**  
   本仓库已含 **`.cursor/agents/`**（12 角色薄封装）。**以本仓库为工作区**时可直接用 **`/orchestrator`** 等。  
   **在新业务项目里**：Cursor 不会自动写入 Subagent；请设置 `PRODUCT_LIFECYCLE_ROOT` 后运行 **`scripts/install-cursor-subagents.ps1`**（Windows）或 **`scripts/install-cursor-subagents.sh`**（Unix），一键生成该项目下的 `.cursor/agents/` 并嵌入技能包绝对路径（详见 `docs/SKILL-CURSOR.md`「新业务项目」节）。亦可使用 **`/create-subagent`** 手动创建并按 `docs/SKILL-CURSOR.md` 自行配置。

若作为子目录嵌入其他项目：

```bash
# 安装
git clone https://github.com/yclenove/product-lifecycle.git .product-lifecycle
```

在 `.cursorrules` 中引用：

```markdown
## 产品开发流程

遵循 .product-lifecycle/ 下的 Agent prompt 和模板：
1. 先读 .product-lifecycle/agents/orchestrator.md 启动编排总监
2. 按编排总监的指示启动其他 Agent
3. 使用 .product-lifecycle/templates/ 下的模板
```

或直接在对话中告诉 Cursor：

```
读取 .product-lifecycle/agents/market-analyst.md，按照里面的指引做市场分析。
输出到 docs/MKT-001-市场分析报告.md，格式参考 .product-lifecycle/templates/market_template.md。
```

### OpenCode / Codex / 其他 AI 工具

```bash
# 安装
git clone https://github.com/yclenove/product-lifecycle.git
```

直接使用 prompt 文件：

1. 读取 `agents/orchestrator.md`，让 AI 按照指引执行编排总监角色
2. 按编排总监的指示，依次读取其他 Agent prompt 执行
3. 使用 `templates/` 下的模板作为输出格式

示例对话：

```
你是本项目的编排总监。请读取 agents/orchestrator.md 并按照指引执行。
项目描述：[你的项目描述]
```

### 通用方法

不管用什么工具，核心流程一样：

1. **启动编排总监** — 读取 `agents/orchestrator.md`，制定工作流
2. **并行启动调研 Agent** — 读取 `agents/market-analyst.md` + `agents/product-manager.md`
3. **启动架构师** — 读取 `agents/architect.md`，产出技术设计
4. **并行启动执行 Agent** — 开发、测试、运维、文档、质量门禁
5. **测试循环** — 测试不通过 → 开发修复 → 重新测试
6. **部署循环** — 部署失败 → 运维修复 → 重新部署
7. **发布** — 质量门禁通过后发布

## 12 个 Agent 角色

### 自驱动层（不需要输入）

| Agent | 职责 | 产出物 | 模型 |
| ----- | ---- | ------ | ---- |
| 需求侦察兵 | 持续监控市场 + 产品体检 | 侦察报告 | sonnet |
| 市场分析师 | 竞品、用户画像、定价 | 市场分析报告 | sonnet |
| 产品经理 | PRD、用户故事、验收标准 | PRD | sonnet |

### 执行层（需要输入）

| Agent | 职责 | 产出物 | 模型 |
| ----- | ---- | ------ | ---- |
| 编排总监 | 制定框架、协调各 Agent | WORKFLOW_PLAN.md | opus |
| 架构师 | 技术设计、API、数据模型 | 技术设计文档 | opus |
| 开发工程师 | 代码实现、单元测试 | 代码 + 测试 | sonnet |
| 测试经理 | 测试策略、用例、质量门禁 | 测试计划 | sonnet |
| 运维工程师 | 环境搭建、部署、监控 | 可运行环境 | sonnet |
| 技术文档师 | 用户文档、API 文档 | 用户文档 | haiku |
| 质量门禁 | 代码审查、lint、MCP | 质量报告 | haiku |
| 反馈分析师 | 收集用户反馈、bug 报告 | 反馈分析报告 | sonnet |
| 迭代规划师 | 影响分析、迭代计划 | 迭代计划 | sonnet |


## 工作流（含反馈循环）

```
模式 A（0-to-1）：
编排总监 → 市场分析师 + 产品经理 → 架构师
  → 开发 → 测试 ⇄ 开发修复（循环）→ 部署 ⇄ 运维修复（循环）→ 质量门禁 → 发布

模式 B（持续迭代）：
需求侦察兵 + 反馈分析师 → 市场分析师 + 产品经理 → 迭代规划师
  → 架构师 → 开发 → 测试 ⇄ 开发修复（循环）→ 质量门禁 → 发布
```

**关键：工作流不是单向的**

- 测试不通过 → 开发修复 → 重新测试（可能多轮）
- 部署失败 → 运维修复 → 重新部署（可能多轮）
- 质量门禁不通过 → 开发修复 → 回到测试

## 目录结构

```
product-lifecycle/
├── SKILL.md              # Claude Code 入口（其他工具可忽略）
├── .cursor/skills/product-lifecycle/SKILL.md  # Cursor Agent Skill 入口
├── .cursor/agents/       # Cursor Subagent 薄封装（/orchestrator、/market-analyst …）
├── .claude/agents/       # Claude Code Subagent 定义（12 角色，含动态上下文注入）
├── CHANGELOG.md          # 版本记录
├── README.md             # 本文件
├── agents/               # 12 个 Agent 的通用 prompt（真源）
│   ├── orchestrator.md   # 编排总监
│   ├── market-analyst.md # 市场分析师
│   ├── product-manager.md # 产品经理
│   ├── architect.md      # 架构师
│   ├── developer.md      # 开发工程师
│   ├── qa-manager.md     # 测试经理
│   ├── devops.md         # 运维工程师
│   ├── docwriter.md      # 技术文档师
│   ├── quality-gatekeeper.md # 质量门禁
│   ├── proactive-scout.md # 需求侦察兵
│   ├── feedback-analyst.md # 反馈分析师
│   └── iteration-planner.md # 迭代规划师
├── templates/            # 文档模板
│   ├── workflow_plan_template.md
│   ├── market_template.md
│   ├── product_template.md
│   ├── architecture_template.md
│   ├── developer_template.md
│   ├── qa_template.md
│   ├── devops_template.md
│   ├── docwriter_template.md
│   ├── feedback_template.md
│   ├── iteration_template.md
│   ├── scout_template.md          # 侦察报告模板
│   └── quality_report_template.md # 质量报告模板
├── docs/                 # 项目文档
│   ├── QUICK-START.md    # 快速入门指南
│   ├── SKILL-CURSOR.md   # Cursor 用法与 PACKAGE_ROOT
│   ├── SKILL-CLAUDE-CODE.md # Claude Code 用法
│   ├── SKILL-OTHER-TOOLS.md # OpenCode / Codex 等
│   ├── SKILL-ASSETS.md   # 角色/模板/门禁索引
│   ├── WORKFLOW_DETAILS.md
│   ├── CONTEXT-MANAGEMENT.md # 上下文管理最佳实践
│   └── CONSISTENCY-CHECKLIST.md # 三目录一致性检查清单
├── scripts/              # 工具脚本
│   ├── detect.sh         # 项目自动检测
│   ├── install-cursor-subagents.ps1  # Cursor Subagent 安装（Windows）
│   └── install-cursor-subagents.sh   # Cursor Subagent 安装（Unix）
└── examples/             # 完整示例
    ├── cloudflow.md      # CloudFlow 完整生命周期（模式 A）
    ├── saas-iteration.md # SaaS 持续迭代（模式 B）
    └── cli-tool.md       # CLI 工具渐进式采用（4 核心 Agent）
```

## 适用场景

- 新产品/项目启动，需要完整生命周期管理
- 已有产品需要持续迭代改进
- 需要主动发现市场机会和用户需求
- **支持中文项目** — Agent prompt 原生支持中文项目名、描述和文档输出
- **支持英文项目** — 搜索关键词自动适配英文，模板占位符支持双语（详见 `docs/INTERNATIONALIZATION.md`）
- **可访问性考虑** — 文档输出遵循 Markdown 可访问性最佳实践（详见 `docs/ACCESSIBILITY.md`）

## 不适用

- 小功能迭代（直接写代码）
- Bug 修复（直接修）

## 快速入门

首次使用？请阅读 [docs/QUICK-START.md](docs/QUICK-START.md) — 30 秒理解框架，5 分钟完成首次体验。

## 贡献指南

欢迎贡献！请遵循以下流程：

1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/your-feature`
3. 在 `agents/*.md`（真源）上编辑
4. 运行同步：`bash scripts/iterate.sh`
5. 运行验证：`bash scripts/validate.sh`
6. 更新 CHANGELOG.md
7. 提交 PR（使用 [PR 模板](.github/PULL_REQUEST_TEMPLATE.md)）

### 报告问题

- [Bug 报告](https://github.com/yclenove/product-lifecycle/issues/new?template=bug_report.md)
- [功能请求](https://github.com/yclenove/product-lifecycle/issues/new?template=feature_request.md)

## License

MIT