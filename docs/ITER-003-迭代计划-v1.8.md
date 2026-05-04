# ITER-003 迭代计划：product-lifecycle v1.7.0 发版 + v1.8.0 工程化


| 字段 | 值 |
|------|-----|
| 版本 | v1.0 |
| 作者 | 迭代规划师 |
| 日期 | 2026-05-05 |
| 状态 | 已定稿 |
| 关联文档 | ITER-002, PRD-003, SCOUT-004, FEEDBACK-004, `docs/WORKFLOW_PLAN.md` |


---

## 1. 迭代概述

### 1.1 目标

1. **立即收口 v1.7.0**：把 `CHANGELOG [Unreleased]` 中已完成的 Cursor 文档与交叉引用工作，**固化为 `[1.7.0]` 并打 tag**，恢复版本叙事与用户预期。  
2. **规划 v1.8.0**：承接 **ITER-002** 中尚未在模板 / `.claude/agents` / `examples` / 脚本层落地的条目。

### 1.2 版本号

- **v1.7.0**：以**文档与 Cursor 对齐**为主的 minor（与 ITER-002 原定「v1.7 含工程项」做**范围切割**：工程项顺延 v1.8，避免版本名与事实长期错位）。  
- **v1.8.0**：ITER-002 工程化闭环（下一冲刺）。

### 1.3 时间建议

- v1.7.0：**2026-05-04 ~ 2026-05-05**（提交 + CHANGELOG + tag）  
- v1.8.0：**2026-05-05 ~ 2026-05-20**（按资源并行）

---

## 2. v1.7.0 发布检查清单（文档发版）

- [ ] `git add` 纳入本轮及历史未提交的 `docs/`、`.cursor/`、`CHANGELOG`、`README`、`SKILL.md` 等（按团队策略分批或单次）  
- [ ] `CHANGELOG`：将 `[Unreleased]` 内容移至 **`## [1.7.0] - YYYY-MM-DD`**（日期用实际发布日）  
- [ ] `[Unreleased]` 仅保留真正未发布项（可为空）  
- [ ] `git tag v1.7.0`  
- [ ] README 中「当前版本」若有硬编码则更新（可选）

---

## 3. v1.8.0 功能清单（承接 ITER-002）

| ID | 功能 | 来源 | P | 工作量 | 验收标准（继承 ITER-002，略） |
|----|------|------|---|--------|-------------------------------|
| F001 | `.claude/agents` model 分级 | FB008 | P0 | M | 与 `SKILL-CLAUDE-CODE` 策略表一致 |
| F002 | workflow 错误处理 / 检查点 | FB009 | P0 | M | `workflow_plan_template.md` 含专节 |
| F003 | MVD 文档表 | FB010 | P1 | M | `SKILL.md` 或 `WORKFLOW_DETAILS.md` |
| F004 | Skill vs Subagent（CC 侧） | FB012 | P1 | S | `SKILL-CLAUDE-CODE` 或 `SKILL.md` |
| F005 | CLAUDE 分层 | FB011 | P2 | S | 新文档或专节 |
| F006 | Hooks 示例 | FB013 | P2 | M | `examples/` 或 `docs` 可复制片段 |
| F007 | Cursor rules FAQ 扩充 | FB007 | P2 | M | `SKILL-CURSOR` / README |
| F008 | QUICKSTART + scout 示例行 | SCOUT-002 | P2 | S | 文件存在 |
| F009 | 双轨同步检查 | SCOUT-002 | P2 | M | 脚本或 checklist |
| T001–T002 | 门禁格式统一、CONTEXT 引用 | SCOUT-002 | P1/P2 | M | agents 与 .claude 同步更新 |

---

## 4. 风险

| 风险 | 缓解 |
|------|------|
| v1.7 名与 ITER-002 标题不一致 | 在 CHANGELOG **1.7.0** 条目中一句说明「工程项见 v1.8 / ITER-003」 |
| 一次提交过大 | 先发版文档最小集，其余文档 commit 可跟 v1.8 |

---

## 5. 修订记录

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 | 2026-05-05 | 初稿：v1.7.0 文档发版 + v1.8.0 承接 ITER-002 |

---

*迭代规划师*
