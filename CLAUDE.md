# Claude Code（本仓库）

调用 **Read** 读取非 PDF（含 `.md`、代码、配置）时：**不要传 `pages` 参数**——从 JSON 里删掉整个键；禁止 `"pages": ""`。否则客户端校验会报错。

<!-- product-lifecycle:begin -->

## product-lifecycle 技能包

本仓库为 **20 Agent 产品生命周期** 框架。使用 `/product-lifecycle` 或阅读 `SKILL.md` 启动编排。

| 场景 | 文档 |
|------|------|
| 入门 | `docs/01-getting-started/QUICK-START.md` |
| 选角色 | `docs/01-getting-started/DECISION-TREE.md` |
| 迭代产出路径 | `docs/04-reference/OUTPUT-PATHS.md` |
| 长程续做 | `docs/07-long-running/README.md` · `bash scripts/resume.sh` |
| 方法论 skill | `npx superpowers-zh` 或 `docs/04-reference/SKILL-INTEGRATION.md` |

Agent 产出默认写到 `docs/iterations/current/<类型>/`，勿写 `docs/` 根目录。

<!-- product-lifecycle:end -->
