# 快速入门

## 30 秒理解

product-lifecycle 是一个显式触发、精简模式优先的 20 Agent 产品开发工作流。它负责选择角色、组织依赖、约束产出路径并完成质量闭环，不是一次性把 20 个 prompt 全塞进上下文。

你不需要一次用全部 20 个 Agent。大多数任务使用编排总监加 2-6 个相关角色即可。

## 先分清两个目录

- `PACKAGE_ROOT`：product-lifecycle 的安装目录，包含 `SKILL.md`、`agents/`、`templates/`、`skills/` 和 `docs/`。
- `WORKSPACE_ROOT`：你的业务项目，代码和 `docs/iterations/` 产出写在这里。

全局安装时二者通常不同。不要把业务 PRD、架构文档或代码写进 Skill 安装目录。

## 安装

### Codex

```bash
git clone https://github.com/yclenove/product-lifecycle.git "${CODEX_HOME:-$HOME/.codex}/skills/product-lifecycle"
```

新建任务后输入：

```text
$product-lifecycle 为现有项目增加登录风控，使用精简模式
```

仓库内维护时还可使用 `/product-lifecycle` 或 `/pl`。详见 [Codex 指南](../02-tools/SKILL-CODEX.md)。

### Claude Code

```bash
git clone https://github.com/yclenove/product-lifecycle.git ~/.claude/skills/product-lifecycle
```

```text
/product-lifecycle myapp "一个简单的待办事项应用"
```

### Cursor

安装、路径解析和角色 Subagent 配置见 [Cursor 指南](../02-tools/SKILL-CURSOR.md)。

### 其他工具

克隆仓库后，让工具读取根 `SKILL.md`。若宿主没有 Skill 发现机制，先读取 `agents/orchestrator.md`，再按编排结果读取其他角色和模板。

## 第一次运行

推荐从精简模式开始：

```text
请运行 product-lifecycle 精简模式。

目标：为现有 SaaS 增加团队邀请功能。
约束：沿用当前技术栈，不做大规模迁移。
期望：给出必要的产品、架构、实现、QA 和质量门禁产出。
```

工作流会：

1. 确认 `WORKSPACE_ROOT` 和已有项目状态。
2. 选择 2-6 个必要角色。
3. 读取对应 prompt、模板和方法 Skill。
4. 执行实现、验证与反馈循环。
5. 把文档写到 `WORKSPACE_ROOT/docs/iterations/current/<type>/`。

## 三种范围

| 模式 | 何时使用 | 示例 |
|---|---|---|
| A. 完整生命周期 | 新产品或重大版本 | “全量规划一个新 SaaS” |
| B. 精简迭代 | 现有产品功能或产品级重构 | “给支付模块增加退款流程” |
| C. 单角色 | 只需要一个专业视角 | “只让 architect 做影响分析” |

普通 bug、单文件修改和简单问答直接处理，不必启动完整工作流。

## 常用入口

| 目标 | 文档 |
|---|---|
| 不知道选哪些角色 | [DECISION-TREE](DECISION-TREE.md) |
| 查角色和模板 | [SKILL-ASSETS](../04-reference/SKILL-ASSETS.md) |
| 查产出路径 | [OUTPUT-PATHS](../04-reference/OUTPUT-PATHS.md) |
| 跨天续做 | [长程迭代](../07-long-running/README.md) |
| 出现路径或宿主问题 | [TROUBLESHOOTING](../06-troubleshooting/TROUBLESHOOTING.md) |

## 验证安装

维护本 Skill 仓库时运行：

```bash
python scripts/check-product-lifecycle-skill.py --root .
```

普通业务项目不需要复制或运行包维护脚本。
