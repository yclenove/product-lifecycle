# 迭代产物目录（按迭代归档）

> **指南类文档**（入门、工具、工作流）在 `docs/01-*` ~ `docs/07-*`，不按迭代分。  
> **本目录**只放各轮 Agent 跑出来的 PRD、架构、测试报告等**迭代产物**。

## 为什么按迭代放？

| 方式 | 优点 | 缺点 |
|------|------|------|
| 按角色类型分（旧 `archive/market/`） | 找同类文档快 | 一轮迭代的东西散落 10 个文件夹 |
| **按迭代分（推荐）** | 一轮版本的所有材料在一个目录，复盘/交接/发版一目了然 | 需要约定迭代 ID |

长程迭代 + 多 session 时，**按迭代归档**更符合「这一版发了什么」的心智模型。

## 目录约定

```
docs/iterations/
├── README.md              ← 本文件
├── _template/             ← 新开一轮时复制
├── current/               ← 【进行中】本轮所有产出写这里
│   ├── ITERATION.md       ← 迭代元数据（ID、目标、日期）
│   ├── market/
│   ├── product/
│   ├── architecture/
│   ├── dev/
│   ├── qa/
│   ├── scout/
│   ├── feedback/
│   ├── iteration/
│   ├── quality-gate/
│   └── misc/
├── v1.8/                  ← 【已结束】整轮移入，不再改
├── v1.7/
├── 20260506-doc-drift/
└── _legacy-by-role/       ← 历史数据（按角色分的旧 archive，只读）
```

## 新开一轮迭代

```bash
# 1. 若 current/ 里有上一轮残留，先归档
bash scripts/archive-iteration.sh v1.9   # 把 current/ → iterations/v1.9/

# 2. 从模板初始化 current/
bash scripts/init-iteration.sh v1.9 "v1.9 冲刺：批量导出"

# 3. Agent 产出一律写到 current/ 子目录
#    例：docs/iterations/current/product/PRD-001-产品需求.md
```

## 与长程迭代（07-long-running）的关系

| 机制 | 作用 |
|------|------|
| `docs/07-long-running/STATE.md` | 跨 session 的**进度心跳**（做到哪了、卡在哪） |
| `docs/iterations/current/` | 本轮的**具体产出文件** |
| `docs/iterations/<id>/` | 已结束迭代的**只读快照** |

迭代结束时：`checkpoint.sh` 记里程碑 → `archive-iteration.sh` 把 `current/` 整包移走 → 更新 `STATE.md`。

## 文件命名

与 `docs/03-workflow/WORKFLOW_DETAILS.md` 一致：

- `MKT-001-市场分析报告.md` → 放 `current/market/`
- `PRD-002-产品需求-v1.8.md` → 放 `current/product/`
- `ARCH-003-技术设计.md` → 放 `current/architecture/`
- `WORKFLOW_PLAN` 仍在 `docs/03-workflow/`（指南），**每轮副本**可另存 `current/misc/WORKFLOW_PLAN.md`

## 历史数据

`docs/iterations/_legacy-by-role/` 存放 v3.0 之前按角色分类的历史产物（原 `docs/iterations/_legacy-by-role/`）。新迭代请勿写入该目录。