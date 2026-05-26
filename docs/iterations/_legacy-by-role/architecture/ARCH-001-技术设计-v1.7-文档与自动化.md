# ARCH-001 技术设计：v1.7（文档信息架构与自动化落点）


| 字段 | 值 |
|------|-----|
| 版本 | v0.1 |
| 作者 | 架构师 |
| 日期 | 2026-05-04 |
| 状态 | 草稿 |
| 关联文档 | PRD-002, ITER-002 |


---

## Step 0 文档健康检查

| 文档 | 状态 | 说明 |
|------|------|------|
| PRD-002 | 已接收 | v1.7 增量 |
| docs/PRD-001 | 无 | 本仓库以技能流程为主；不阻塞 |
| 既有 ARCH | 无 | 本文件为首个 ARCH-* |

---

## 1. 设计目标

1. **信息架构：** 角色产出物命名稳定：`SCOUT-*`、`FEEDBACK-*`、`MKT-*`、`PRD-*`、`ARCH-*`、`DEV-*`、`QA-*`、`QG-*`、`ITER-*`，索引由 `ROLE-RUN-LOG` 与 `WORKFLOW_PLAN` 承担。
2. **自动化（v1.7）：** Hooks 与脚本**仅作示例**，默认放在 `examples/claude-code/` 或 `docs/` 片段，避免绑定用户全局 `settings.json`。
3. **失败与检查点：** 与 `templates/workflow_plan_template.md` 增补章节一致（见 ITER-002 F002）。

---

## 2. 组件视图

```
SKILL.md / docs/SKILL-*.md          # 入口与工具映射
agents/ + .claude/agents/           # 角色行为定义（双轨）
templates/                          # 产出形状
docs/
  WORKFLOW_PLAN.md                  # 编排计划
  ITER-*.md                         # 迭代范围
  ROLE-RUN-LOG-*.md                 # 分角色执行索引
  SCOUT|FEEDBACK|MKT|PRD|ARCH|DEV|QA|QG-*  # 各角色产出
examples/（v1.7 新增可选）           # Hooks / 校验脚本示例
```

---

## 3. 关键技术决策

| 决策 | 选项 | 选择 | 理由 |
|------|------|------|------|
| ROLE-RUN-LOG 粒度 | 每迭代一个 / 每会话一个 | **每迭代或每次显式「分角色跑」一个** | 可审计、可链接 |
| model 分级 | 仅文档说明 / 改 subagent | **改 `.claude/agents` + 文档表** | 与 FEEDBACK-002 FB008 一致 |
| MVD 检查 | 脚本 / 纯文档 | **先纯文档 checklist** | 仓库无统一测试框架 |

---

## 4. 风险

- 文件增多导致 `docs/` 噪音：用 ROLE-RUN-LOG 做**唯一导航入口**之一。

---

*架构师*
