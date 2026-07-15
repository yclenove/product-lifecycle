# 文档导航地图

## 三个入口

| 入口 | 面向对象 | 职责 |
|---|---|---|
| `README.md` | 用户 | 选择宿主、模式和下一篇文档 |
| `SKILL.md` | Agent | 解析双根目录、选择范围、按需加载与验收 |
| `docs/README.md` | 用户与维护者 | 全量文档目录 |

角色、模板、方法 Skill 和宿主适配层的真源边界统一见 `docs/04-reference/SKILL-ASSETS.md`。

## 按宿主

| 宿主 | 路径 |
|---|---|
| Codex | `SKILL.md -> docs/02-tools/SKILL-CODEX.md -> agents/*.md` |
| Claude Code | `SKILL.md -> docs/02-tools/SKILL-CLAUDE-CODE.md -> .claude/agents/*.md` |
| Cursor | `SKILL.md -> docs/02-tools/SKILL-CURSOR.md -> .cursor/agents/*.md -> agents/*.md` |
| OpenCode / 其他 | `SKILL.md -> docs/02-tools/SKILL-OTHER-TOOLS.md -> agents/*.md` |

宿主适配器只负责发现和路径转换，不保存第二份角色或工作流正文。

## 按任务

### 新用户

1. `README.md`
2. `docs/01-getting-started/QUICK-START.md`
3. 对应的 `docs/02-tools/SKILL-*.md`
4. `docs/01-getting-started/DECISION-TREE.md`

### 运行工作流

1. 根 `SKILL.md`
2. `docs/04-reference/SKILL-ASSETS.md`
3. 选中的 `agents/*.md` 与 `templates/*.md`
4. `docs/04-reference/OUTPUT-PATHS.md`
5. 需要复杂依赖时再读 `docs/03-workflow/WORKFLOW_DETAILS.md`

### 维护技能包

1. `docs/04-reference/SKILL-ASSETS.md`：包结构与修改归属
2. `docs/04-reference/CONSISTENCY-CHECKLIST.md`：同步规则
3. `scripts/check-product-lifecycle-skill.py`：结构与兼容门禁
4. `scripts/check-docs-health.sh`：文档口径
5. `scripts/validate.sh`：角色与派生层验证

## 依赖关系

```text
README.md
  -> docs/README.md
  -> host guide / quick start / reference

SKILL.md
  -> SKILL-ASSETS.md
  -> selected agents/*.md + templates/*.md + skills/*/SKILL.md
  -> OUTPUT-PATHS.md
  -> WORKFLOW_DETAILS.md when needed

host adapters
  -> root SKILL.md
```

详细专题位于：

- 上下文：`docs/05-advanced/CONTEXT-MANAGEMENT.md`
- 安全：`docs/05-advanced/SECURITY.md`
- Token：`docs/05-advanced/TOKEN-EFFICIENCY.md`
- 排障：`docs/06-troubleshooting/TROUBLESHOOTING.md`
- 长程执行：`docs/07-long-running/README.md`
