# 模型配置指南

本文档说明如何为 20 个 Agent 配置合适的模型（自动探测 + 推荐方案）。

## 默认策略

**Subagent 定义中不指定 `model` 字段，自动继承用户当前模型** — 这是最稳定的选择，对所有 API 提供商都适用。

如果你希望根据角色复杂度分级配置以节省成本，运行下面的配置脚本。

## 一键探测与配置

### macOS / Linux

```bash
bash scripts/configure-models.sh
```

### Windows PowerShell

```powershell
.\scripts\configure-models.ps1
```

脚本会：

1. 探测你的 API 端点支持哪些模型
2. 显示当前 20 个 Agent 的模型配置
3. 给出推荐方案
4. 询问采用哪种方案
5. 自动写入 `.claude/agents/*.md` 的 frontmatter

## 推荐方案

| 模型可用数 | 推荐策略 | 复杂推理 | 常规任务 |
|-----------|----------|----------|----------|
| 0（探测失败） | 全部继承当前模型 | — | — |
| 1 | 全部用同一个 | 该模型 | 该模型 |
| 2+ | 分级配置 | 最强模型 | 平衡模型 |

**复杂推理（3 个角色，建议用最强）：**
- orchestrator（编排总监）
- project-manager（项目经理）
- architect（架构师）

**常规任务（其余 17 个 Agent，建议用平衡型）：**
- proactive-scout、market-analyst、product-manager、ui-designer、dba、developer、frontend-developer、backend-developer、qa-manager、devops、security-engineer、docwriter、data-analyst、feedback-analyst、iteration-planner、reviewer、quality-gatekeeper

**预计节省：** 与「全部用最强」相比节省 ~30-40% 成本。

## 手动配置

如果你不想跑脚本，可以手动编辑 `.claude/agents/*.md` 的 frontmatter：

```yaml
---
description: "..."
tools: [...]
model: "你的模型名"     # 可选，不写则继承
---
```

## 常见问题

**Q: 配置后没生效？**

A: 检查模型名是否正确（要与 API 提供商一致），重启 Claude Code / Cursor。

**Q: 想恢复到「全部继承当前模型」？**

A: 跑脚本选「继承当前模型」，或手动删除所有 frontmatter 中的 `model:` 行。

**Q: 模型名不知道？**

A: 调用你的 API 端点的 `/v1/models` 看可用列表。或在 Claude Code 中跑 `/model` 命令。
