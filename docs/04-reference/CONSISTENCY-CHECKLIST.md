# 一致性检查清单

## 核心不变量

1. 根 `SKILL.md` 是唯一执行协议。
2. `agents/`、`templates/`、`skills/` 是运行资产真源。
3. `.agents/`、`.claude/`、`.cursor/` 是宿主适配层，只做发现、路径解析和工具差异说明。
4. `PACKAGE_ROOT` 只读技能资产，`WORKSPACE_ROOT` 承载业务代码和迭代产出。
5. README 只做用户导航，详细矩阵放在 `docs/04-reference/SKILL-ASSETS.md`。
6. `docs-site/` 是展示层，不反向成为 Agent 运行真源。

## 目录职责

| 目录 | 内容 | 可直接编辑 |
|---|---|---|
| `agents/*.md` | 20 个通用角色 prompt | 是 |
| `templates/*.md` | 核心产出模板 | 是 |
| `skills/<name>/` | 内置方法 Skill | 是，注意上游来源 |
| `.claude/agents/*.md` | Claude Code 派生角色 | 否，运行同步脚本 |
| `.cursor/agents/*.md` | Cursor 薄角色包装 | 仅修改适配逻辑 |
| `.agents/skills/*/SKILL.md` | Codex 显式入口 | 仅修改适配逻辑 |
| `.claude/skills/pl/SKILL.md` | Claude Code 短别名 | 仅修改适配逻辑 |
| `.cursor/skills/product-lifecycle/SKILL.md` | Cursor Skill 入口 | 仅修改适配逻辑 |
| `docs/` | 权威参考文档 | 是 |
| `docs-site/` | HTML 展示与生成资源 | 通过生成流程维护 |

## 双根目录检查

每个根 Skill 与宿主入口都应满足：

- 能解析包含 `SKILL.md`、`agents/`、`templates/`、`skills/`、`docs/` 的 `PACKAGE_ROOT`。
- 把当前业务仓库识别为 `WORKSPACE_ROOT`。
- 从 `PACKAGE_ROOT` 读取资产。
- 向 `WORKSPACE_ROOT/docs/iterations/` 写业务文档。
- 不硬编码用户 home 下的安装路径。
- 不默认把业务产出写入全局 Skill 安装目录。

## 角色修改流程

```text
编辑 agents/*.md
  -> bash scripts/iterate.sh --check
  -> 必要时调整 scripts/sync-agents.sh
  -> bash scripts/iterate.sh
  -> 验证 .claude/agents 与 .cursor/agents
```

常用命令：

| 命令 | 用途 |
|---|---|
| `bash scripts/iterate.sh --check` | 只检查本轮是否需要同步 |
| `bash scripts/iterate.sh` | 检查、同步并收尾 |
| `bash scripts/sync-agents.sh` | 同步全部 Claude Code 角色 |
| `bash scripts/sync-agents.sh orchestrator` | 同步指定角色 |
| `python scripts/check-product-lifecycle-skill.py --root .` | Skill、适配器、README 与结构门禁 |

## 文档修改规则

| 内容 | 权威位置 |
|---|---|
| 用户快速选择 | `README.md` |
| 首次运行步骤 | `docs/01-getting-started/QUICK-START.md` |
| 宿主差异 | `docs/02-tools/SKILL-*.md` |
| 工作流依赖 | `docs/03-workflow/WORKFLOW_DETAILS.md` |
| 包结构、角色和模板矩阵 | `docs/04-reference/SKILL-ASSETS.md` |
| 产出目录 | `docs/04-reference/OUTPUT-PATHS.md` |
| 全量文档导航 | `docs/README.md` |

不要在 README、宿主适配器和 docs-site 中分别维护完整角色表。

## 角色数量口径

当前值为 20。新增或移除角色时至少检查：

- `SKILL.md` frontmatter description
- `README.md` 顶部说明
- `docs/01-getting-started/QUICK-START.md`
- `docs/01-getting-started/DECISION-TREE.md`
- `docs/01-getting-started/FAQ.md`
- `docs/04-reference/SKILL-ASSETS.md`
- `docs/04-reference/DOC-MAP.md`
- `templates/workflow_plan_template.md`
- `scripts/check-product-lifecycle-skill.py`
- `scripts/check-docs-health.sh`

不要再要求 README 维护第二份 20 角色职责表；完整列表由 SKILL-ASSETS 负责。

## 自动验证

```bash
python scripts/check-product-lifecycle-skill.py --root .
bash scripts/check-docs-health.sh
bash scripts/validate.sh
```

另外对根 Skill、四个宿主入口和 20 个内置方法 Skill 运行 Codex `quick_validate.py`。

## 提交前检查

- [ ] 根 `SKILL.md` 保持简短并使用按需路由。
- [ ] README 在行数预算内，所有本地链接有效。
- [ ] 四个宿主入口仍是薄适配器。
- [ ] `PACKAGE_ROOT` 与 `WORKSPACE_ROOT` 没有混用。
- [ ] 20 个角色文件存在且非空。
- [ ] 20 个核心模板存在且非空。
- [ ] 20 个方法 Skill frontmatter 可被 Codex 解析。
- [ ] 迭代产出路径相对 `WORKSPACE_ROOT`。
- [ ] 三条自动验证命令通过。
