# product-lifecycle 工作流计划（本轮迭代）

> 编排总监产出 · 日期：**2026-05-04** · **第三轮：v1.8 执行中** · 运行索引：`docs/ROLE-RUN-LOG-2026-05-04.md`

---

## 1. 模式与理由

| 项 | 内容 |
|----|------|
| **选定模式** | **B（持续迭代）** |
| **理由** | 在 ITER-004 规划基础上进入**执行切片**（ITER-005）：先落地 F002 模板能力，并同步分角色过程稿与门禁。 |

---

## 2. 项目状态摘要

| 检查项 | 状态 |
|--------|------|
| CHANGELOG | `[1.7.0]` 已存在；`[Unreleased]` 持续累积 |
| F002 | **已推进**：`templates/workflow_plan_template.md` 新增 **§6 错误处理与检查点** |
| F001 | **已修复**：`.claude/agents` model 字段已移除，自动继承用户全局配置；见 `docs/04-reference/SKILL-ASSETS.md` |
| `git tag v1.7.0` | 需在 **commit** 后由维护者执行（若尚未） |

---

## 3. 本轮目标

1. 落盘 **SCOUT-006 → QG-004** 与 **ITER-005**（执行切片）。  
2. 更新 **WORKFLOW_PLAN**、**ROLE-RUN-LOG** 第三轮索引。  
3. 提醒：大目录未跟踪变更宜**分批 commit**。  

---

## 4. Agent 链（第三轮）

编排 → SCOUT-006 → FEEDBACK-006 → MKT-005 → PRD-005 → **ITER-005** → ARCH-004 → DEV-004 → QA-005 → QG-004

（第二轮 v1.8 冲刺前链：SCOUT-005 … ITER-004，见同目录历史文件。）

---

## 5. 产出物

- [x] `WORKFLOW_PLAN.md`（本节）  
- [x] `ROLE-RUN-LOG-2026-05-04.md`（第三轮表）  
- [x] SCOUT-006 … QG-004、ITER-005  
- [x] `templates/workflow_plan_template.md` §6  
- [ ] F001 实改（可选，下一 commit）  
- [ ] `git tag v1.7.0`（commit 后由维护者执行）  

---

*编排总监 · `agents/orchestrator.md`*