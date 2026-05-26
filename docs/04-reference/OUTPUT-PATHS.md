# 产出路径规范（v3.1+）

## 原则

| 类型 | 路径 | 示例 |
|------|------|------|
| **指南 / 参考** | `docs/01-*` ~ `docs/07-*` | `docs/01-getting-started/QUICK-START.md` |
| **进行中迭代产物** | `docs/iterations/current/<类型>/` | `docs/iterations/current/product/PRD-001-产品需求.md` |
| **已结束迭代** | `docs/iterations/<迭代ID>/` | `docs/iterations/v1.9/product/PRD-001-...` |
| **长程状态** | `docs/07-long-running/` | `STATE.md`、`HANDOFF.md` |
| **工作流总览** | `docs/03-workflow/WORKFLOW_PLAN.md` | 框架级，不按迭代分 |

**不要**再写到 `docs/` 根目录或 `docs/iterations/current/product/PRD-*.md` 扁平路径。

## 子目录与前缀

| 子目录 | 文件前缀 | 典型 Agent |
|--------|----------|------------|
| `current/market/` | `MKT-` | market-analyst |
| `current/product/` | `PRD-` | product-manager |
| `current/architecture/` | `ARCH-` | architect |
| `current/dev/` | `DEV-` | developer / frontend / backend |
| `current/qa/` | `QA-` | qa-manager |
| `current/scout/` | `SCOUT-` | proactive-scout |
| `current/feedback/` | `FEEDBACK-` | feedback-analyst |
| `current/iteration/` | `ITER-` | iteration-planner |
| `current/quality-gate/` | `QG-` | quality-gatekeeper |
| `current/misc/` | 其它 | orchestrator 副本、运行日志 |

## 生命周期

```
init-iteration.sh v1.9
    → Agent 写入 current/
archive-iteration.sh v1.9
    → current/ 变为 iterations/v1.9/
init-iteration.sh v2.0
    → 新的 current/
```

## 读取上一轮产物

- 同迭代续做：读 `docs/iterations/current/` 下已有文件
- 跨迭代参考：读 `docs/iterations/<旧ID>/` 或 `_legacy-by-role/`（历史）