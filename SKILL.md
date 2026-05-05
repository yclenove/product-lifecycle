---
name: product-lifecycle
description: Use when starting a new product/project and need to orchestrate a full development lifecycle from market analysis through architecture, implementation, testing, deployment, and continuous iteration. 中文触发：产品迭代、全流程开发、产品生命周期、市场分析+开发+测试、13个Agent协作。
when_to_use: "new product launch, full lifecycle management, Phase kickoff, product iteration, market analysis needed, PRD creation, architecture design, product upgrade, new feature lifecycle, 产品迭代, 全流程开发, 产品生命周期, 市场分析, 需求分析, 产品规划, PRD编写, 架构设计, 版本迭代, 持续迭代, 多Agent协作, 编排总监, 需求侦察, 反馈分析, 迭代计划, 使用product-lifecycle, 跑一轮迭代, 帮我迭代"
argument-hint: "[项目名] [一句话描述]"
allowed-tools: Agent WebSearch WebFetch Read Write Edit Glob Grep Bash TodoWrite
---

# 多 Agent 产品开发全流程

## 概述

通过 13 个专业 Agent 协作，驱动产品从市场分析到代码实现再到持续迭代的完整闭环。不是只生成文档——是从需求到可运行产品的端到端流程。

## ⚠️ 启动前配置（禁止跳过，必须等用户回复）

**你必须执行以下步骤，然后等用户回复后才能继续。绝对不能自动跳过、不能自己判断"配置没问题就继续"。**

步骤：
1. 运行 bash 读取当前配置
2. 尝试探测 API 可用模型
3. **把结果展示给用户，然后停下来等用户选择**
4. 用户回复后，按用户选择处理
5. 处理完才能进入工作流

### 1. 读取当前子代理配置

```bash
echo "=== 当前子代理模型配置 ==="
for f in ~/.claude/skills/product-lifecycle/.claude/agents/*.md; do
  name=$(basename "$f" .md)
  model=$(grep "^model:" "$f" 2>/dev/null | sed 's/model: *//' | tr -d '"')
  echo "$name: ${model:-继承当前模型}"
done
```

### 2. 尝试探测 API 可用模型（可选）

```bash
# 尝试 OpenAI 兼容的 /v1/models 端点
if [ -n "$ANTHROPIC_BASE_URL" ]; then
  API_URL="${ANTHROPIC_BASE_URL%/anthropic}/v1/models"
  TOKEN="${ANTHROPIC_AUTH_TOKEN:-$ANTHROPIC_API_KEY}"
  echo "=== API 可用模型 ==="
  curl -s --connect-timeout 5 "$API_URL" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null \
    | tr ',' '\n' | grep '"id"' | sed 's/.*"id":"\([^"]*\)".*/  - \1/' \
    | grep -vi tts | grep -vi omni || echo "  （无法探测，请手动输入模型名）"
else
  echo "=== API 可用模型 ==="
  echo "  （无法自动探测，请告诉我你的 API 支持哪些模型）"
fi
```

### 3. 向用户展示并询问（必须停下来等回复）

**⚠️ 执行到这里必须停下来，等用户回复后才能继续下一步。不能自己决定跳过。**

向用户展示以下内容（用 AskUserQuestion 工具或直接输出）：

```
当前子代理配置：全部继承你当前选定的模型。
"继承" = 子代理用的就是你现在跑的这个模型，最稳定，不会报错。

如果你的 API 支持多个模型，可以分级配置省钱：
  复杂任务（编排/架构）→ 用最强模型
  常规任务（其余 11 个）→ 用平衡模型

要怎么配？
  ① 不改（推荐，最稳定）
  ② 分级配置（告诉我模型名，我自动分配）
  ③ 全部指定为某个模型
```

### 4. 根据用户回复处理

- **用户选 ① 或"不用改"** → 直接进入工作流，不需要任何修改
- **用户选 ② 或"分级"** → 问用户两个模型名（强/弱），自动更新：
  - orchestrator + architect → 强模型
  - 其余 11 个 → 弱模型
- **用户选 ③ 或"全部用 xxx"** → 批量更新所有 .claude/agents/*.md
- **用户说"去掉 model"** → 移除所有 model 字段（回到纯继承）

更新配置脚本：
```bash
# 设置指定 Agent 的模型
set_model() {
  local model="$1"
  shift
  for name in "$@"; do
    f="$HOME/.claude/skills/product-lifecycle/.claude/agents/$name.md"
    if grep -q "^model:" "$f" 2>/dev/null; then
      sed -i "s/^model:.*/model: \"$model\"/" "$f"
    else
      sed -i "/^description:/a model: \"$model\"" "$f"
    fi
  done
}

# 示例：分级配置
# set_model "最强模型名" orchestrator architect
# set_model "平衡模型名" developer devops docwriter feedback-analyst iteration-planner market-analyst proactive-scout product-manager qa-manager quality-gatekeeper reviewer
```

**重要：不管用户选什么，都要确保模型名是用户的 API 确实支持的。如果不确定，选 ① 最安全。**

---

## ⛔ 配置检查到此为止。上面的步骤必须全部执行并等用户回复后，才能继续下面的 Agent 调用。

---

## Agent 调用示例（配置完成后执行）

**你是编排总监。你必须使用 Agent 工具派发子代理，不能自己一个人干所有事。**

配置完成后，这样调用第一个子代理：

```
Agent(
  subagent_type: "",
  description: "需求侦察兵：产品体检",
  prompt: "读取 ~/.claude/skills/product-lifecycle/agents/proactive-scout.md，按照里面的指引对当前项目执行产品体检和市场扫描。产出到 docs/SCOUT-xxx-侦察报告.md。"
)
```

然后按模式 B 的顺序依次派发：反馈分析师 → 市场分析师 → 产品经理 → 迭代规划师 → 架构师 → 开发工程师 → 测试经理 → 质量门禁。

**子代理模型继承用户当前配置，无需指定。**

## 各工具用法（分文档）

工具相关安装、命令与执行细节已拆出，便于单独维护；**需要时再 Read 对应文件**。


| 工具                        | 文档                                                                                                                   | 何时读取                                                                                          |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Cursor**                | `[docs/SKILL-CURSOR.md](docs/SKILL-CURSOR.md)` — PACKAGE_ROOT、`**/create-subagent` 与 CC 对齐的多角色编排**、全局安装、与业务工作区并用、Skill vs Subagent 辨析、Hooks 集成     | 在 Cursor 中首次使用本技能包时；需要理解 Skill/Subagent 关系或配置 Hooks 时                                     |
| **Claude Code**           | `[docs/SKILL-CLAUDE-CODE.md](docs/SKILL-CLAUDE-CODE.md)` — `/product-lifecycle`、Subagent、Agent 工具原则、启动模板、`detect.sh` | 在 Claude Code 中首次使用时；需要了解 slash 命令或 Agent 工具策略时                                            |
| **OpenCode / Codex / 其他** | `[docs/SKILL-OTHER-TOOLS.md](docs/SKILL-OTHER-TOOLS.md)` — 读 `agents/` 与 `templates/`                                | 使用 Cursor/Claude Code 以外的工具时；只需读取 `agents/` 与 `templates/` 即可                                  |


**角色文件与模板清单、12 角色产出表、质量门禁速查**：`[docs/SKILL-ASSETS.md](docs/SKILL-ASSETS.md)`

## 何时使用

- 新产品/项目启动，需要完整生命周期管理
- 进入新 Phase，需要从需求到部署的全流程
- 产品需要持续迭代改进
- 团队需要标准化的开发流程

**不适用：**

- 小功能迭代（直接用 writing-plans）
- Bug 修复（用 systematic-debugging）
- 纯文档生成（无代码产出）

**国际化与可访问性：**

- 支持中文和英文项目，Agent prompt 自动适配语言（详见 `docs/INTERNATIONALIZATION.md`）
- 文档输出遵循可访问性最佳实践：正确标题层级、描述性链接、颜色无关的状态标识（详见 `docs/ACCESSIBILITY.md`）

## 两种模式

### 模式 A：从 0 到 1（新产品）

```
编排总监 → 市场分析师 + 产品经理 → 架构师
    → 开发 + 测试 + 运维 + 文档 + 质量门禁 → 发布
```

适用：新项目启动、新 Phase、从零构建。

### 模式 B：持续迭代（已有产品）

```
需求侦察兵 + 反馈分析师 → 市场分析师 + 产品经理 → 迭代规划师
    → 架构师（影响分析）→ 开发 + 测试 + 质量门禁 → 发布
```

适用：已有产品、用户反馈驱动、版本升级。

**迭代流程：**

1. 需求侦察兵主动扫描市场 + 产品体检
2. 反馈分析师收集用户反馈、bug 报告
3. 市场分析师分析竞品动态、市场趋势（主动搜索）
4. 产品经理综合反馈 + 市场分析，定义迭代需求
5. 迭代规划师制定迭代计划（功能清单 + 影响分析 + 回滚方案）
6. 架构师评估变更影响
7. 开发工程师增量实现（向后兼容）
8. 测试经理回归测试
9. 质量门禁审查
10. 发布 + 更新 CHANGELOG

### 自驱动能力

市场分析师、产品经理、需求侦察兵不需要等待输入，它们会：

- **主动搜索** 竞品动态、用户痛点、市场趋势
- **主动发现** 机会和威胁
- **主动提出** 功能建议和行动方案
- **主动输出** 侦察报告和机会清单

你可以直接说"帮我看看市场上有什么新动态"，它们就会自主工作。

### 文档健康检查

每个 Agent 启动时会先检查输入文档是否齐全。如果缺失，会自动从代码和反馈中反推补充：


| Agent | 必需文档       | 缺失时行动        | 质量不达标时         |
| ----- | ---------- | ------------ | -------------- |
| 编排总监  | docs/ 目录   | 创建目录结构       | 重新制定框架        |
| 架构师   | PRD        | 从代码反推 PRD 初稿 | 重新评审设计方案      |
| 开发工程师 | PRD + 架构设计 | 先补文档再开发      | 代码审查+重构       |
| 测试经理  | PRD + 架构设计 | 先补文档再测试      | 补充测试用例        |
| 运维工程师 | 架构设计       | 从代码反推架构      | 重新验证部署        |
| 技术文档师 | PRD        | 从代码反推 PRD    | 重写不达标部分       |
| 迭代规划师 | PRD + 反馈分析 | 先收集反馈再规划     | 重新评估优先级       |


这样即使项目文档不全，Agent 也能工作——先补全文档，再执行本职任务。

## 渐进式采用

不需要一次使用全部 13 个 Agent。根据项目规模选择合适的子集：

### 核心 Agent（最小可用集）


| Agent | 职责             | 何时使用              |
| ----- | -------------- | ----------------- |
| 编排总监  | 制定框架、协调各 Agent | **必选** — 每次都从这里开始 |
| 开发工程师 | 代码实现           | **必选** — 有代码要写时   |
| 测试经理  | 测试策略和执行        | **必选** — 验证实现时    |
| 质量门禁  | 代码审查           | **必选** — 发布前审查    |
| 代码审查员 | 代码质量、安全性、可维护性审查 | 按需 — 深度代码审查时    |


### 扩展 Agent（按需添加）


| Agent | 职责       | 何时使用        |
| ----- | -------- | ----------- |
| 市场分析师 | 竞品、用户画像  | 需要市场调研时     |
| 产品经理  | PRD、用户故事 | 需要定义需求时     |
| 架构师   | 技术设计     | 复杂系统需要架构设计时 |
| 运维工程师 | 部署、监控    | 需要容器化或部署时   |
| 技术文档师 | 用户文档     | 需要正式文档时     |


### 自驱动 Agent（持续迭代时使用）


| Agent | 职责   | 何时使用      |
| ----- | ---- | --------- |
| 需求侦察兵 | 市场监控 | 产品上线后持续监控 |
| 反馈分析师 | 用户反馈 | 有用户反馈渠道时  |
| 迭代规划师 | 迭代计划 | 规划下个版本时   |


### 决策树

根据项目规模选择 Agent 子集：

- **原型/MVP**（1-2 天）→ 编排总监 + 开发 + 测试（3 个）
- **小型项目**（1-2 周）→ 核心 4 个 + 架构师（5 个）
- **中型项目**（1-2 月）→ 核心 4 个 + 市场 + 产品 + 架构师（7 个）
- **大型项目**（3 月+）→ 全部 13 个 Agent

**启动命令与精简模式**（Claude Code）：见 `[docs/SKILL-CLAUDE-CODE.md](docs/SKILL-CLAUDE-CODE.md)`。

## 核心模式与闭环

工作流不是单向的，包含反馈循环：

- 测试不通过 → 开发修复 → 重新测试（可能多轮）
- 部署失败 → 运维修复 → 重新部署（可能多轮）
- 质量门禁不通过 → 开发修复 → 重新测试 + 重新部署

**各角色文件、模板、12 角色产出表、质量门禁表**：`[docs/SKILL-ASSETS.md](docs/SKILL-ASSETS.md)`

**流程图、依赖与编号规则**：`[docs/WORKFLOW_DETAILS.md](docs/WORKFLOW_DETAILS.md)`

**安全指南**：`[docs/SECURITY.md](docs/SECURITY.md)` — 安全检查工具集成、Agent 输出安全审查、最佳实践

**上下文管理：** 多 Agent 协作时的上下文预算、摘要传递、信息交接规范见 `docs/CONTEXT-MANAGEMENT.md`。

## 实际效果

- `[examples/cloudflow.md](examples/cloudflow.md)` — CloudFlow 完整生命周期演示（模式 A，从 0 到 1）
- `[examples/saas-iteration.md](examples/saas-iteration.md)` — SaaS 产品持续迭代演示（模式 B）
- `[examples/cli-tool.md](examples/cli-tool.md)` — CLI 工具渐进式采用演示（4 核心 Agent）
- `[examples/microservice.md](examples/microservice.md)` — 微服务项目演示（模式 A，含代码审查）

## 进阶资源

- `[docs/DECISION-TREE.md](docs/DECISION-TREE.md)` — Agent 选择决策树，帮你快速选择合适的 Agent 组合
- `[docs/FAQ.md](docs/FAQ.md)` — 常见问题解答，覆盖使用、技术、工作流、集成等场景
- `[docs/QUICK-START.md](docs/QUICK-START.md)` — 快速入门指南，包含进阶用法（自定义 Agent、CI/CD 集成、多项目管理）
- `[docs/CONTEXT-MANAGEMENT.md](docs/CONTEXT-MANAGEMENT.md)` — 上下文管理策略，解决 Agent 输出过多/过少问题
- `[docs/DOC-MAP.md](docs/DOC-MAP.md)` — 文档导航地图，帮你快速找到需要的文档

## 快速入门

首次使用？请阅读 `docs/QUICK-START.md` — 30 秒理解框架，5 分钟完成首次体验。