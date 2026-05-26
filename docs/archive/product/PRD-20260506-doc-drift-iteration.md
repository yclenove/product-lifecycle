# PRD：文档漂移治理与 Windows 验证体验迭代

| 字段 | 内容 |
|------|------|
| 文档编号 | PRD-20260506-doc-drift-iteration |
| 日期 | 2026-05-06 |
| 角色 | 产品经理 |
| 状态 | 草案 |
| 迭代类型 | 文档一致性 + 验证门禁 + 入门体验 |

## 1. 背景

product-lifecycle 已演进为面向 AI 编码工具的 **14 Agent 产品开发流程技能包**。本轮侦察与反馈显示，当前主要问题不是功能缺失，而是**文档与验证漂移**：

- README 已更新为 14 Agent，但 `SKILL.md`、`docs/QUICK-START.md`、`docs/DECISION-TREE.md`、`docs/SKILL-ASSETS.md`、`docs/DOC-MAP.md`、Cursor 相关 README 等仍残留 12/13 Agent 表述。
- `docs/SKILL-ASSETS.md` 是关键入口，标题仍写「13 Agent」，但角色表已包含 14 行；模型策略仍写「其余 11 个 Agent」。
- Windows 用户体验有明显机会点：PowerShell 验证脚本已补齐，但 `scripts/validate.ps1` 仍按 13 个 Agent 校验，`docs/QUICK-START.md` 未突出 Windows 一键验证路径。
- 现有验证脚本可检查结构，但无法捕获文档漂移，导致 README 与入口文档可能再次不同步。
- 多工具接入说明丰富，但 Cursor 用户容易混淆 Skill、Subagent、`PACKAGE_ROOT`、业务工作区和 `.cursor/agents/` 的边界。

因此，本迭代应优先交付一个小而可验证的「文档漂移治理」切片：先统一 14 Agent 叙事，再把漂移检测纳入脚本门禁，最后补强 Windows 与 Cursor 的首次使用路径。

## 2. 目标

| ID | 目标 | 成功指标 |
|----|------|----------|
| G1 | 统一核心入口的 14 Agent 表述 | 指定入口文档不再出现误导性的「12 Agent」「13 Agent」当前态描述 |
| G2 | 增加文档漂移门禁 | `scripts/validate.ps1` 与对应 Unix 验证路径能识别关键文档中的过期 Agent 数量表述 |
| G3 | 降低 Windows 新用户验证成本 | `docs/QUICK-START.md` 明确提供 PowerShell 一键验证命令与预期结果 |
| G4 | 降低 Cursor 用户认知负担 | Cursor 入口文档用同一组术语解释 Skill、Subagent、`PACKAGE_ROOT`、业务工作区和 `.cursor/agents/` |

## 3. 非目标

- 不新增第 15 个 Agent，不调整角色职责边界。
- 不修改业务代码或 Agent prompt 的业务逻辑能力。
- 不重写全部文档体系，不做大规模信息架构重构。
- 不引入新的外部依赖或 CI 平台绑定。
- 不解决所有历史 Changelog、旧版 PRD、旧版示例中的版本叙事；历史记录可保留，但当前入口不得误导。

## 4. 用户故事

| ID | 用户故事 | 价值 | 优先级 |
|----|----------|------|--------|
| US-01 | 作为首次了解 product-lifecycle 的用户，我希望所有入口文档都一致说明当前是 14 Agent，以便判断产品能力时不被旧数字误导。 | 建立信任，减少困惑 | P0 |
| US-02 | 作为 Windows 用户，我希望能在快速入门中直接看到 PowerShell 验证命令，以便安装后立即确认技能包结构正确。 | 降低上手门槛 | P0 |
| US-03 | 作为维护者，我希望验证脚本能检查文档漂移，以便 README 更新后不会遗漏 SKILL、QUICK-START、DOC-MAP 等入口文档。 | 降低回归风险 | P0 |
| US-04 | 作为 Cursor 用户，我希望文档清楚区分 Skill 与 Subagent，并说明 `.cursor/agents/` 属于哪个工作区，以便知道为什么 `/orchestrator` 有时不可见。 | 降低工具接入认知负担 | P1 |
| US-05 | 作为贡献者，我希望知道哪些旧文档允许保留历史数字，以便修复漂移时不会误改历史归档。 | 提高维护效率 | P1 |

## 5. 范围

### 5.1 MVP 范围（本迭代必须交付）

1. **核心入口文档一致性修正**
   - 更新 `SKILL.md`、`docs/QUICK-START.md`、`docs/DECISION-TREE.md`、`docs/SKILL-ASSETS.md`、`docs/DOC-MAP.md` 中的当前态 Agent 数量表述。
   - 修正 `docs/SKILL-ASSETS.md` 的「13 Agent 角色与产出」标题、模型策略「其余 11 个 Agent」等已确认漂移点。

2. **PowerShell 验证脚本更新**
   - 将 `scripts/validate.ps1` 中当前 Agent 数量校验从 13 更新为 14。
   - 保持 PowerShell 脚本与 Unix 验证路径的校验意图一致。

3. **文档漂移门禁**
   - 在验证脚本中新增文档漂移检查，覆盖至少以下文件：`README.md`、`SKILL.md`、`docs/QUICK-START.md`、`docs/DECISION-TREE.md`、`docs/SKILL-ASSETS.md`、`docs/DOC-MAP.md`、`.cursor/agents/README.md`。
   - 检查目标：当前入口文档不得用「12 Agent」「13 Agent」「其余 11 个 Agent」描述当前版本能力。
   - 允许历史归档文件保留旧数字，例如 Changelog、旧版 PRD、旧版迭代报告、历史示例，但需在规则中显式排除。

4. **Windows 快速验证路径**
   - 在 `docs/QUICK-START.md` 增加 Windows PowerShell 验证命令与预期输出说明。
   - 明确 Unix 用户继续使用 `bash scripts/validate.sh` 或现有等价脚本。

### 5.2 P1 范围（若 MVP 完成后仍有余量）

1. **Cursor 术语降噪**
   - 在 Cursor 相关入口中增加「一句话辨析」：
     - Skill：方法论入口，负责流程说明。
     - Subagent：`.cursor/agents/*.md` 中的角色定义，可通过 `/orchestrator` 等调用。
     - `PACKAGE_ROOT`：product-lifecycle 技能包根目录。
     - 业务工作区：实际产出 `docs/` 的项目目录。
   - 说明 `.cursor/agents/` 必须存在于当前 Cursor 打开的工作区，或通过安装脚本写入业务项目。

2. **维护者说明补强**
   - 在一致性清单或相关维护文档中补充「当前态入口」与「历史归档」的区别，避免后续误报或误改。

## 6. 验收标准

### AC-01：核心入口统一为 14 Agent

- Given 用户打开当前版本入口文档，
- When 阅读 `SKILL.md`、`docs/QUICK-START.md`、`docs/DECISION-TREE.md`、`docs/SKILL-ASSETS.md`、`docs/DOC-MAP.md`，
- Then 当前态说明均应使用 14 Agent 表述，且不得出现误导性的 12/13 Agent 当前态描述。

### AC-02：`docs/SKILL-ASSETS.md` 关键漂移点修复

- Given 维护者查看 `docs/SKILL-ASSETS.md`，
- When 检查角色速览与模型策略，
- Then 标题、角色数量、模型策略均与 14 Agent 一致；表格行数与叙事不冲突。

### AC-03：PowerShell 验证脚本按 14 Agent 校验

- Given 在 Windows 环境运行 `powershell -File scripts/validate.ps1`，
- When `.claude/agents/` 与 `agents/` 均包含当前 14 个 Agent，
- Then Agent 数量、上下文管理覆盖、同步检查等数量型校验通过，并显示 14/14 或等价结果。

### AC-04：文档漂移可被验证脚本捕获

- Given 任一核心入口文档重新引入「12 Agent」「13 Agent」等当前态旧表述，
- When 运行验证脚本，
- Then 脚本失败并指出命中的文件或检查项。

### AC-05：历史归档不被误判

- Given 旧版 Changelog、历史 PRD、历史迭代报告中存在 12/13 Agent 记录，
- When 运行验证脚本，
- Then 不因历史记录失败，除非该文件被列入当前入口文档检查范围。

### AC-06：Windows 快速入门可执行

- Given Windows 用户完成仓库克隆，
- When 阅读 `docs/QUICK-START.md`，
- Then 能看到 PowerShell 验证命令、运行位置、预期成功信号，并能据此完成一次本地验证。

### AC-07：Cursor 用户路径更清晰

- Given Cursor 用户打开技能包或业务项目，
- When 阅读 Cursor 相关入口，
- Then 能理解 Skill、Subagent、`PACKAGE_ROOT`、业务工作区、`.cursor/agents/` 的区别，并知道 `/orchestrator` 不可见时应检查当前工作区与安装脚本。

## 7. 风险与依赖

| 风险/依赖 | 影响 | 缓解方式 |
|-----------|------|----------|
| 历史文档中存在大量 12/13 Agent 表述 | 漂移检查可能误报 | 仅检查当前入口文档；历史归档显式排除 |
| PowerShell 与 Unix 脚本规则不一致 | Windows 与非 Windows 用户得到不同结论 | 先定义统一检查项，再分别落到脚本实现 |
| Cursor 文档继续追加说明导致更复杂 | 用户认知负担增加 | 使用「一句话辨析 + 典型路径」替代长篇展开 |
| Agent 数量未来继续变化 | 再次产生硬编码漂移 | 验证脚本优先从文件列表或统一常量推导数量，减少散落数字 |
| 本轮只做文档与验证 | 不直接提升 Agent 能力 | 明确本迭代目标是可信度与可维护性，为后续功能迭代降风险 |

## 8. 建议优先级

### 8.1 RICE 排序

| 工作项 | Reach | Impact | Confidence | Effort | RICE | 优先级 |
|--------|-------|--------|------------|--------|------|--------|
| 核心入口统一为 14 Agent | 100 | 2 | 90% | 1.0d | 180 | P0 |
| 文档漂移门禁 | 80 | 2 | 80% | 1.0d | 128 | P0 |
| PowerShell 验证路径补强 | 60 | 1.5 | 90% | 0.5d | 162 | P0 |
| Cursor 术语降噪 | 50 | 1.5 | 70% | 0.75d | 70 | P1 |
| 维护者历史归档说明 | 30 | 1 | 80% | 0.5d | 48 | P1 |

### 8.2 推荐交付顺序

1. **P0-1：统一入口文档 14 Agent 当前态。** 先修正用户可见的不一致。
2. **P0-2：更新 `scripts/validate.ps1` 与文档漂移门禁。** 让问题可持续被捕获。
3. **P0-3：补强 `docs/QUICK-START.md` 的 Windows 验证路径。** 让 Windows 用户能立即验证。
4. **P1-1：Cursor 术语降噪。** 在不扩写大量正文的前提下减少误解。
5. **P1-2：维护者说明。** 固化当前态入口与历史归档的边界。

## 9. 本迭代完成定义

- MVP 范围全部完成。
- Windows 与 Unix 验证脚本均能通过当前仓库结构验证。
- 至少一次人为注入旧 Agent 数量表述时，文档漂移门禁能失败。
- PR 或变更说明中明确列出已检查的入口文档与排除的历史归档范围。
