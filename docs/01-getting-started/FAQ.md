# 常见问题

## 使用相关

### Q: 我只想用 1 个 Agent，可以吗？
A: 可以。直接读取 `agents/xxx.md` 并按指引执行。例如，只需要开发代码时，直接使用 `agents/developer.md`。

### Q: Agent 输出太多/太少怎么办？
A: 调整上下文管理中的输出预算。在 agent prompt 中修改"控制在 XXX 字以内"。详见 `docs/CONTEXT-MANAGEMENT.md`。

### Q: 如何跳过市场分析直接写代码？
A: 直接启动编排总监，它会检测项目状态。如果有代码，自动跳过调研阶段，进入模式 B（持续迭代）。

### Q: 多人协作时怎么用？
A: 每人一个 Agent 角色，通过 WORKFLOW_PLAN.md 协调。编排总监负责分配任务，各 Agent 独立执行自己的部分。

### Q: 小项目也需要 20 个 Agent 吗？
A: 不需要。用 4 个核心 Agent 就够了（编排总监、开发工程师、测试经理、质量门禁）。详见 `docs/01-getting-started/DECISION-TREE.md`。

### Q: Agent 执行太慢怎么办？
A: 使用渐进式采用——只启动必要的 Agent。编排总监会自动判断需要哪些 Agent，跳过不必要的步骤。

## 技术相关

### Q: 如何添加新的 Agent？
A: 
1. 在 `agents/` 目录创建新的 prompt 文件（如 `agents/security-auditor.md`）
2. 在 `scripts/sync-agents.sh` 中添加配置
3. 运行 `bash scripts/sync-agents.sh` 同步到各工具目录

### Q: 如何修改 Agent 的模型？
A: 编辑 `scripts/sync-agents.sh` 中的 MODELS 关联数组，为每个 Agent 指定不同的模型。

### Q: 如何在 Cursor 中使用？
A: 参见 `docs/02-tools/SKILL-CURSOR.md`，或运行 `scripts/install-cursor-subagents.sh` 自动安装。

### Q: 脚本执行报错怎么办？
A: 参见 `docs/06-troubleshooting/TROUBLESHOOTING.md`，或检查：
- 脚本是否有执行权限（`chmod +x scripts/*.sh`）
- 是否在项目根目录执行
- Node.js 和 npm 是否正确安装

### Q: 如何只用核心 Agent 跳过调研？
A: 直接启动编排总监，它会检测项目状态。如果有代码，自动进入模式 B（持续迭代），跳过市场分析。

### Q: 上下文窗口不够用怎么办？
A: 参见 `docs/CONTEXT-MANAGEMENT.md`，包含摘要传递和上下文预算机制。关键策略：
- 优先读取摘要，按需读取原文
- 使用 grep 定位关键词，避免读取整个文件
- 控制输出长度，关键信息前置

## 工作流相关

### Q: 模式 A 和模式 B 有什么区别？
A: 
- **模式 A（从 0 到 1）：** 无现有代码或新 Phase，需要完整的市场调研、产品定义、架构设计
- **模式 B（持续迭代）：** 有现有代码和文档，主要关注需求侦察、反馈分析、增量开发

### Q: 如何判断应该用哪个模式？
A: 编排总监会自动判断。一般来说：
- 无代码 → 模式 A
- 有代码有文档 → 模式 B
- 有代码无文档 → 模式 B，但先补充文档

### Q: Agent 之间如何传递信息？
A: 通过 `docs/` 目录下的文档传递。每个 Agent 完成后会生成结构化摘要，下游 Agent 优先读取摘要，按需读取原文。

### Q: 质量门禁不通过怎么办？
A: 质量门禁会指出具体问题，开发工程师需要修复后重新提交。如果多次不通过，编排总监会介入协调。

## 集成相关

### Q: 如何集成到 CI/CD 流程？
A: 在 CI 流程中使用质量门禁脚本：
```yaml
# .github/workflows/quality.yml
- name: Quality Gate
  run: bash scripts/validate.sh
```

### Q: 如何在多个项目间共享 Agent 定义？
A: 每个项目独立的 `docs/` 目录，共享同一套 `agents/` 和 `templates/`。可以通过 git submodule 或符号链接实现。

### Q: 支持哪些 AI 工具？
A: 支持所有能读取 markdown 文件的 AI 工具，包括：
- Claude Code（原生支持）
- Cursor（通过 Skill 或 Subagent）
- Windsurf、OpenCode 等（直接读取 agents/ 目录）

## 故障排除

### Q: Agent 生成的文档格式不对？
A: 检查是否使用了正确的模板。每个 Agent 都有对应的模板在 `templates/` 目录。确保 Agent prompt 中引用了正确的模板。

### Q: 编排总监没有自动检测到项目状态？
A: 确保项目根目录有以下文件：
- `docs/` 目录（即使为空）
- `CHANGELOG.md`（即使为空）
- 代码文件（如果有的话）

### Q: 如何回退到上一个版本？
A: 使用 git 管理版本。每个迭代完成后会自动创建 tag，可以通过 `git checkout v1.x.x` 回退。

## 更多帮助

- **详细文档：** 查看 `docs/` 目录下的各文档
- **示例项目：** 参考 `examples/` 目录下的完整示例
- **问题反馈：** 在 GitHub 仓库提交 issue