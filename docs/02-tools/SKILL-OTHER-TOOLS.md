# OpenCode / Codex / 其他 AI 工具中的用法

本文件供根目录 `SKILL.md` 引用；无专属运行时，按「读文件 + 扮演角色」即可。

**在 Cursor 中安装与 Subagent / PACKAGE_ROOT：** 见 **`docs/02-tools/SKILL-CURSOR.md`**（与 [Cursor 官方 Subagents](https://cursor.com/docs/subagents) 对齐）；本文件不重复 Cursor 专有条目。

## 推荐步骤

1. 读取 `agents/orchestrator.md`，按其中指引扮演编排总监（替换 `{{PROJECT_NAME}}`、`{{PROJECT_DESCRIPTION}}`）。
2. 按编排产出依次读取其他 `agents/*.md`。
3. 输出格式参考 `templates/` 下对应模板（清单见 `docs/04-reference/SKILL-ASSETS.md`）。

## 路径说明

- 若技能包克隆为子目录（如 `.product-lifecycle/`），上述路径均相对于该子目录根。
- 工作流细节与依赖关系见 `docs/03-workflow/WORKFLOW_DETAILS.md`。

## 示例对话

```
你是本项目的编排总监。请读取 agents/orchestrator.md 并按照指引执行。
项目描述：[你的项目描述]
```
