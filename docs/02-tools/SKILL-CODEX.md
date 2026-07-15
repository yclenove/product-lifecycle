# Codex 中的用法

本文件是 product-lifecycle 的 Codex 适配说明。通用执行协议以仓库根 `SKILL.md` 为准；本文只说明发现、路径和 Codex 工具边界。

## 双根目录契约

开始前区分两个目录：

| 根目录 | 用途 | 写入规则 |
|---|---|---|
| `PACKAGE_ROOT` | product-lifecycle 的 `agents/`、`templates/`、`skills/`、`docs/` | 默认只读 |
| `WORKSPACE_ROOT` | 当前业务代码仓库 | 写代码与 `docs/iterations/` 产出 |

全局安装时两者通常不同。只有维护 product-lifecycle 本身时，才把当前仓库同时视为两个根。

## 安装与发现

### 用户级安装

将完整仓库放进 Codex 用户 Skill 目录，保留根 `SKILL.md` 与所有资源的相对位置：

```bash
git clone https://github.com/yclenove/product-lifecycle.git "${CODEX_HOME:-$HOME/.codex}/skills/product-lifecycle"
```

Windows PowerShell：

```powershell
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$env:USERPROFILE\.codex" }
git clone https://github.com/yclenove/product-lifecycle.git (Join-Path $codexHome "skills\product-lifecycle")
```

安装或更新后新建 Codex 任务，让技能目录重新扫描。

### 在本仓库中维护

仓库内提供两个显式项目入口：

- `.agents/skills/product-lifecycle/SKILL.md`
- `.agents/skills/pl/SKILL.md`

它们都是薄适配器，只负责解析双根目录并加载根 `SKILL.md`。不要在适配器中复制角色、模板或工作流正文。

## 调用

优先显式调用：

```text
$product-lifecycle 为现有系统规划一个支付功能，使用精简模式
```

在支持 slash 展示的 Codex 界面中，也可使用 `/product-lifecycle`；仓库项目入口被扫描后可使用 `/pl`。若界面没有展示别名，直接点名 `product-lifecycle` 并提供目标即可。

## 执行规则

1. 完整读取 `PACKAGE_ROOT/SKILL.md`。
2. 从 `PACKAGE_ROOT` 按需读取角色、模板、方法 Skill 和参考文档。
3. 从 `WORKSPACE_ROOT` 读取代码、Git 状态和现有迭代产物。
4. 将业务产出写到 `WORKSPACE_ROOT/docs/iterations/current/<type>/`。
5. 当前会话提供的工具说明优先于静态工具名映射。

读取 Markdown、代码或配置时不要传 `pages` 参数；页码范围只用于 PDF。

## 多角色执行

Codex 的并行或子任务能力是可选增强，不是运行前提：

- 工具可用、当前策略允许、任务彼此独立时，可以并行运行角色。
- 工具不可用或任务有依赖时，在当前任务中顺序执行并清楚标注角色。
- 不要输出 Claude Code 专用的 `Agent(...)` 调用语法。
- 旧方法 Skill 中的工具名需要转换时，读取 `skills/using-superpowers/references/codex-tools.md`；若它与当前工具说明冲突，以当前工具说明为准。

## 内置方法 Skill

20 个 superpowers-zh 方法 Skill 已位于 `PACKAGE_ROOT/skills/`。product-lifecycle 按路径读取它们，不要求这些方法在 Codex 技能列表中逐个出现。

需要在 product-lifecycle 之外独立调用这些方法时，再参考 `docs/04-reference/SKILL-INTEGRATION.md` 做可选安装。

## 验证

维护技能包后运行：

```bash
python scripts/check-product-lifecycle-skill.py --root .
```

普通产品生命周期任务不需要运行包维护检查。
