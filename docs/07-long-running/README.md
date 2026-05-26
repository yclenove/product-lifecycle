# 长程迭代模式（Long-Running Iteration）

> 适用场景：项目周期跨多天甚至多周，单个 Agent 任务跨多个 session，需要持久化上下文。

## 这是什么？

普通模式（默认）：

```
你开个对话 → 跑 orchestrator → 4 轮一口气做完 → 提交 → 结束
```

长程模式：

```
Day 1: 跑到 product-manager 输出 PRD，停
Day 3: 续做 architect，但 AI 已经"忘了"PRD 的细节
Day 5: 续做 developer……
```

**痛点**：每次续做都要重新读全部历史 doc，token 浪费严重；Agent 容易忘记上一轮的决策。

**长程模式**：把"已完成 / 进行中 / 阻塞 / 下一步"持久化到 `STATE.md`，每个 Agent 启动时只读这一份即可恢复上下文。

## 目录结构

```
docs/07-long-running/
├── README.md            （本文件）
├── STATE.md             当前迭代状态快照（每个 Agent 完成后必须更新）
├── HANDOFF.md           跨 session 移交说明（这一轮做了啥、下一轮接什么）
└── CHECKPOINTS/         每个阶段完成后的 snapshot
    ├── CKP-20260527-prd-done.md
    ├── CKP-20260528-arch-done.md
    └── ...
```

## 三件套

### 1. `STATE.md` — 项目"心跳"

每个 Agent 启动时必读，结束时必更新。包含：

- 当前迭代号 / 阶段
- 已完成 Agent 列表（含产出物路径、关键决策）
- 当前进行中 Agent
- 未完成 / 阻塞项
- 下一步建议

### 2. `HANDOFF.md` — 跨 session 移交单

类似工作交接单。AI 在 session 结束前生成、下次 session 启动时读取。包含：

- 本轮投入时间 / token 估算
- 本轮主要产出
- 遗留问题 / 未决策项
- 下次启动建议的命令

### 3. `CHECKPOINTS/` — 阶段快照

每个 Agent 完成关键阶段（PRD、架构、开发、测试）时生成一个 `CKP-<date>-<phase>-done.md`，保存：

- 该阶段的核心结论
- 产出文档清单
- 验证状态

回滚或对比时用。

## 操作流程

### 启动一轮新会话

```bash
bash scripts/resume.sh
```

会做：

1. 读 `docs/07-long-running/STATE.md` 输出当前阶段
2. 读 `docs/07-long-running/HANDOFF.md` 输出上轮遗留
3. 输出建议命令（比如「下一步建议跑 architect agent」）

### Agent 内部恢复（自动）

每个 agent prompt 顶部都有 `## Step 0：恢复上下文（长程迭代模式）`：

1. 检测 `docs/07-long-running/STATE.md` 存在则读取
2. 输出"我看到上次到 X 阶段，本轮接着做 Y"
3. 任务结束前自动更新 STATE.md

### 阶段完成时保存 checkpoint

```bash
bash scripts/checkpoint.sh <agent-name> [描述]
# 示例
bash scripts/checkpoint.sh product-manager "PRD v1 完成，待架构师评估"
```

会做：

1. 把当前 `STATE.md` 复制为 `CHECKPOINTS/CKP-<date>-<phase>-done.md`
2. 追加文件清单 / git diff summary

### 会话结束前移交

```bash
bash scripts/handoff.sh
```

会做：

1. 读 `STATE.md` 当前状态
2. 提示 AI 填 `HANDOFF.md`（本轮做了啥、下次接啥）

## 与普通模式的关系

- 普通模式：4 轮顺序执行，跑完即弃
- 长程模式：开启后，每个 Agent 自动维护 STATE.md，可任意暂停 / 续做

**切换办法**：长程模式不需要任何配置，只要 `docs/07-long-running/STATE.md` 存在，所有 agent 都会启用 Step 0。

启用：

```bash
cp docs/07-long-running/STATE.template.md docs/07-long-running/STATE.md
```

关闭：

```bash
rm docs/07-long-running/STATE.md
```

## 与 docs/iterations/_legacy-by-role/ 的区别

| 目录 | 用途 | 生命周期 |
|------|------|----------|
| `docs/07-long-running/` | **进行中**的迭代状态 | 跨 session 持续更新 |
| `docs/iterations/_legacy-by-role/` | **已结束**迭代的历史产物 | 只读、归档 |

迭代完全结束时，把 `long-running/` 的最终产出 + checkpoints 移动到 `archive/iteration-N/`。

## FAQ

**Q：会不会污染 git 历史？**
A：建议把 `STATE.md` 加进 `.gitignore`（个人快照），但 `CHECKPOINTS/` 进 git（团队共享里程碑）。

**Q：多人协作怎么办？**
A：`STATE.md` 加锁，一次只能一人写；冲突时手工 merge。或者每人维护自己的 `STATE.<name>.md`。

**Q：单 session 短任务也要建 STATE.md 吗？**
A：不用。短任务（半天内做完）走普通模式即可，不要为了用而用。

**Q：怎么判断该用长程模式？**
A：判断条件（满足一个即可）：
- 项目超过 3 天
- 单轮 token 接近 Claude 上限
- 频繁切 session（笔记本/远程切换）
- 多人协作交接