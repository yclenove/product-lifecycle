# Cursor Subagents（product-lifecycle）

本目录是 [Cursor Subagents](https://cursor.com/docs/subagents) 的 **Markdown 定义文件**（不是我在聊天里「口头创建」的对象）。每个 `.md` 对应一个可通过 `/文件名` 调用的 Subagent，正文要求 Read 仓库里的 `agents/<角色>.md`。

## 为什么说「已经创建了」但你看不到？

1. **Subagent = 磁盘上的 `.cursor/agents/*.md`**。本仓库路径应为：  
   **`{本仓库根}/.cursor/agents/orchestrator.md`** 等（共 20 个角色 + 本 README）。  
   若你当前 Cursor **打开的工作区根**不是本仓库（例如打开了别的项目），那个项目下**没有**这些文件，自然**不会出现** `/orchestrator`。

2. **必须重载 Cursor 窗口**（或重启）后，Agent 才会重新扫描 `.cursor/agents/`。

3. **在 Agent 模式**下，输入 **`/`** 看命令列表；子命令名与 **文件名去掉 `.md`** 一致，例如：`/orchestrator`、`/market-analyst`。

4. **在别的业务仓库**里要用同一套角色：请运行安装脚本（会把路径写成技能包绝对路径），见下节。

## 使用前提

- **开发本技能包**：用 Cursor 打开 **本仓库根**（能看到 `agents/` 与 `.cursor/agents/` 的那一层）。
- **在其它业务仓库（推荐）**：设置 `PRODUCT_LIFECYCLE_ROOT` 后执行：
  - Windows: `pwsh -File "$env:PRODUCT_LIFECYCLE_ROOT\scripts\install-cursor-subagents.ps1" -Target "H:\path\to\your-app"`
  - macOS/Linux: `bash "$PRODUCT_LIFECYCLE_ROOT/scripts/install-cursor-subagents.sh" /path/to/your-app`

## 调用方式

- 显式：`/orchestrator`、`/market-analyst`（与 `orchestrator.md`、`market-analyst.md` 对应）。
- 自然语言：「请用 orchestrator subagent …」

## 与 `/create-subagent` 的关系

在 UI 里用 **`/create-subagent`** 生成的是同一类文件；本仓库已把生成结果**落盘在 Git**里，便于你直接打开仓库即用，无需每次再点创建向导。
