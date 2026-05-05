# sync-agents.ps1 — 从 agents/（真源）自动派生 .claude/agents/（PowerShell 版）
# 用法: pwsh -File scripts/sync-agents.ps1 [agent-name]

param([string]$AgentName = "")

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
$RootDir = Split-Path $ScriptDir
$AgentsDir = "$RootDir\agents"
$ClaudeDir = "$RootDir\.claude\agents"

# Agent 配置
$Descriptions = @{
    "orchestrator"       = '编排总监：制定工作流框架、协调各 Agent、质量把关。当用户说"启动编排总监"或"制定工作流计划"时使用。'
    "market-analyst"     = '市场分析师：主动搜索竞品动态、用户痛点、市场趋势。当用户说"分析市场"、"看看竞品"、"市场调研"时使用。'
    "product-manager"    = '产品经理：主动发现需求、定义PRD、用户故事。当用户说"写PRD"、"定义需求"、"产品规划"时使用。'
    "architect"          = '架构师：技术设计、API设计、数据模型。当用户说"架构设计"、"技术方案"、"API设计"时使用。'
    "developer"          = '开发工程师：代码实现、单元测试、代码质量。当用户说"写代码"、"实现功能"、"开发"时使用。'
    "qa-manager"         = '测试经理：测试策略、测试用例、质量验证。当用户说"写测试"、"测试计划"、"验证"时使用。'
    "devops"             = '运维工程师：环境搭建、容器化、部署验证。当用户说"部署"、"搭建环境"、"Docker"时使用。'
    "docwriter"          = '技术文档师：编写README、API文档、CHANGELOG。当用户说"写文档"、"更新README"、"API文档"时使用。'
    "quality-gatekeeper" = '质量门禁：代码审查、lint配置、质量报告。当用户说"代码审查"、"质量检查"、"lint"时使用。'
    "proactive-scout"    = '需求侦察兵：持续监控市场+产品体检，主动发现机会和威胁。当用户说"侦察市场"、"产品体检"、"市场扫描"时使用。'
    "feedback-analyst"   = '反馈分析师：收集用户反馈、bug报告，分类量化分析。当用户说"分析反馈"、"用户反馈"、"bug分析"时使用。'
    "iteration-planner"  = '迭代规划师：影响分析、制定迭代计划、版本策略。当用户说"迭代计划"、"版本规划"、"下个迭代"时使用。'
    "reviewer"           = '代码审查员：审查代码质量、安全性、可维护性。当用户说"代码审查"、"review"、"检查代码"时使用。'
}

$Tools = @{
    "orchestrator"       = '["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
    "market-analyst"     = '["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
    "product-manager"    = '["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
    "architect"          = '["Read", "Glob", "Grep", "Write", "Edit"]'
    "developer"          = '["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
    "qa-manager"         = '["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
    "devops"             = '["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
    "docwriter"          = '["Read", "Glob", "Grep", "Write", "Edit"]'
    "quality-gatekeeper" = '["Read", "Glob", "Grep", "Write", "Edit", "Bash"]'
    "proactive-scout"    = '["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
    "feedback-analyst"   = '["Read", "Glob", "Grep", "WebSearch", "WebFetch", "Write"]'
    "iteration-planner"  = '["Read", "Glob", "Grep", "Write", "Edit"]'
    "reviewer"           = '["Read", "Glob", "Grep", "Bash", "Write"]'
}

$ContextInjection = @"
## 项目现状

```!
echo "=== 项目结构 ==="
ls -la 2>/dev/null || echo "空目录"
echo ""
echo "=== docs/ 目录 ==="
ls docs/ 2>/dev/null || echo "无 docs/ 目录"
echo ""
echo "=== Git 状态 ==="
git log --oneline -5 2>/dev/null || echo "非 Git 仓库"
echo ""
echo "=== 技术栈 ==="
[ -f "go.mod" ] && echo "Go: $(head -1 go.mod)"
[ -f "package.json" ] && echo "Node.js: 有 package.json"
[ -f "requirements.txt" ] && echo "Python: 有 requirements.txt"
[ -f "Cargo.toml" ] && echo "Rust: 有 Cargo.toml"
```
"@

function Derive-Agent {
    param([string]$Name)
    $src = "$AgentsDir\$Name.md"
    $dst = "$ClaudeDir\$Name.md"

    if (-not (Test-Path $src)) {
        Write-Host "  ✗ 源文件不存在: $src"
        return
    }

    # 读取源文件，去掉背景章节、上下文管理章节、PROJECT_ 占位符
    $lines = Get-Content $src
    $result = @()
    $skip = $false
    foreach ($line in $lines) {
        if ($line -match "^## 背景") { $skip = $true; continue }
        if ($line -match "^## 上下文管理") { $skip = $true; continue }
        if ($skip -and $line -match "^## ") { $skip = $false }
        if ($skip) { continue }
        if ($line -match "^\{\{PROJECT_") { continue }
        $result += $line
    }

    # 组装输出
    $output = @"
---
description: "$($Descriptions[$Name])"
tools: $($Tools[$Name])
---

$($result -join "`n")

$ContextInjection

**上下文管理：** 遵循 ``agents/$Name.md`` 中的上下文管理指令，控制输出长度。
"@

    $output | Out-File -FilePath $dst -Encoding utf8 -NoNewline
    $lineCount = (Get-Content $dst).Count
    Write-Host "  ✓ $Name.md ($lineCount 行)"
}

Write-Host "=== sync-agents.ps1 ==="
Write-Host "真源: $AgentsDir"
Write-Host "派生: $ClaudeDir"
Write-Host ""

if (-not (Test-Path $ClaudeDir)) { New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null }

if ($AgentName) {
    Derive-Agent -Name $AgentName
} else {
    foreach ($f in Get-ChildItem "$AgentsDir\*.md") {
        Derive-Agent -Name $f.BaseName
    }
}

Write-Host ""
Write-Host "完成。真源在 agents/，编辑那里，然后跑本脚本同步。"
