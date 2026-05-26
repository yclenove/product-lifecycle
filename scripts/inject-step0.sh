#!/usr/bin/env bash
# 给 agents/*.md 批量插入「## Step 0：恢复上下文（长程迭代模式）」段落
# 插入位置：在「## 推荐方法论 skills」段落结束之后、下一个 `## ` 之前
# 幂等：如果文件已经有 Step 0 段落，跳过

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STEP0_BLOCK=$(cat <<'STEP0_EOF'

## Step 0：恢复上下文（长程迭代模式）

> 如果存在 `docs/07-long-running/STATE.md`，本节生效；否则跳过。

**必做：**

1. 读 `docs/07-long-running/STATE.md`，关注「已完成 Agent 清单」「未完成 / 阻塞项」「关键产出索引」
2. 在开始干活前先向用户复述：「我看到上一轮 X 已完成 / 你卡在 Y / 我准备接着做 Z」
3. **不要重复**上一轮已经做过的探索（除非用户明确要求重做）

**结束前必做：**

1. 在 `docs/07-long-running/STATE.md`「已完成 Agent 清单」追加本轮记录（含产出文档路径 + ≤3 个关键决策）
2. 更新「下一步建议」指向下一个 Agent
3. 阶段里程碑（PRD 定稿 / 架构封闭 / 主线开发完成 / QA 通过）必须调用：
   ```bash
   bash scripts/checkpoint.sh <agent-name> "<简短描述>"
   ```
4. Session 结束前（用户要下线）调用 `bash scripts/handoff.sh` 生成移交单

**单轮加深（充分利用 token 预算）：**

本项目鼓励 **深度产出 > 表面交付**。遇到关键决策点：

- 列出 2-3 个候选方案，逐一权衡利弊（时间 / 成本 / 风险 / 团队熟悉度）
- 给出明确推荐 + 选择该方案的理由（不要"看情况"敷衍）
- 标记不确定项 → 写入 `STATE.md` 阻塞项，等待用户或下一轮解决
- 重要数据 / 接口 / 流程，配上完整示例或代码片段，**不要只写一行抽象描述**

STEP0_EOF
)

count_updated=0
count_skipped=0

for file in "$ROOT_DIR"/agents/*.md; do
    name=$(basename "$file")
    
    # 已有 Step 0 则跳过
    if grep -q "^## Step 0：" "$file"; then
        echo "[SKIP] $name (已有 Step 0)"
        count_skipped=$((count_skipped + 1))
        continue
    fi
    
    # 没有 ## 推荐方法论 skills 则跳过
    if ! grep -q "^## 推荐方法论 skills" "$file"; then
        echo "[WARN] $name (无 '推荐方法论 skills' 章节，跳过)"
        count_skipped=$((count_skipped + 1))
        continue
    fi
    
    # 找到「## 推荐方法论 skills」段落的结束位置（下一个 ^## 出现的行号）
    # 用 awk 一次性完成插入
    tmpfile=$(mktemp)
    awk -v step0="$STEP0_BLOCK" '
    BEGIN { in_skills=0; inserted=0 }
    /^## 推荐方法论 skills/ { in_skills=1; print; next }
    in_skills && /^## / && !inserted {
        # 遇到下一个 ## 标题，先插入 Step 0
        print step0
        inserted=1
        in_skills=0
        print
        next
    }
    { print }
    END {
        if (in_skills && !inserted) {
            # 文件末尾就是 skills 段落，直接追加
            print step0
        }
    }
    ' "$file" > "$tmpfile"
    
    mv "$tmpfile" "$file"
    echo "[OK]   $name"
    count_updated=$((count_updated + 1))
done

echo ""
echo "========================================="
echo "  完成：更新 $count_updated 个，跳过 $count_skipped 个"
echo "========================================="