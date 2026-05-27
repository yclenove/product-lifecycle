---
name: pl
description: product-lifecycle 20-Agent 产品开发全流程。仅在用户明确说「/pl」「/product-lifecycle」「帮我跑产品生命周期」「启动迭代流程」时触发；不要为普通编码任务自动激活。
when_to_use: "/pl, /product-lifecycle, 启动产品生命周期, 帮我跑全流程迭代, run product lifecycle, start full product workflow"
argument-hint: "[项目名] [一句话描述]"
allowed-tools: Agent WebSearch WebFetch Read Write Edit Glob Grep Bash TodoWrite
---

# product-lifecycle 短别名

**这是 `/product-lifecycle` 的快捷入口。**

## 启动前先确认范围

在读取任何文件之前，先问用户：

> 我可以启动 product-lifecycle 工作流。请确认：
>
> **A. 完整流程**（20 Agent，约 80-140 个工具调用）  
> **B. 精简模式**（编排 + 1-3 个指定角色，约 15-30 个工具调用）  
> **C. 单角色**（只运行某一个 Agent，如：架构师/产品经理/开发工程师）
>
> 你想要哪种模式？如果不确定，推荐先用 **B 精简模式**。

收到用户回复后，再读取 `~/.claude/skills/product-lifecycle/SKILL.md` 并按用户选择的范围执行。
