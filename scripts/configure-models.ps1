#requires -Version 5.0
<#
.SYNOPSIS
  探测 API 模型并为 20 个 Agent 自动分级配置。

.DESCRIPTION
  与 configure-models.sh 等价的 PowerShell 实现，适配 Windows。
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$SkillDir = $env:CLAUDE_SKILL_DIR
if (-not $SkillDir -or -not (Test-Path (Join-Path $SkillDir '.claude\agents'))) {
    $SkillDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}
$AgentsDir = Join-Path $SkillDir '.claude\agents'

if (-not (Test-Path $AgentsDir)) {
    Write-Error "找不到 .claude/agents/，SkillDir=$SkillDir"
    exit 1
}

# 复杂推理角色（3 个）
$StrongRoles = @('orchestrator', 'project-manager', 'architect')

# 常规任务角色（17 个）
$BalancedRoles = @(
    'proactive-scout', 'market-analyst', 'product-manager', 'ui-designer',
    'dba', 'developer', 'frontend-developer', 'backend-developer',
    'qa-manager', 'devops', 'security-engineer', 'docwriter',
    'data-analyst', 'feedback-analyst', 'iteration-planner',
    'reviewer', 'quality-gatekeeper'
)

# ===== Step 1: 探测可用模型 =====
Write-Host '=== 探测可用模型 ===' -ForegroundColor Cyan
$Models = @()

$baseUrl = $env:ANTHROPIC_BASE_URL
$token = if ($env:ANTHROPIC_AUTH_TOKEN) { $env:ANTHROPIC_AUTH_TOKEN } else { $env:ANTHROPIC_API_KEY }

if ($baseUrl) {
    $apiUrl = ($baseUrl -replace '/anthropic$', '') + '/v1/models'
    try {
        $resp = Invoke-RestMethod -Uri $apiUrl -Headers @{ Authorization = "Bearer $token" } -TimeoutSec 5
        $Models = @($resp.data |
            Where-Object { $_.id -notmatch 'tts|omni' } |
            Select-Object -ExpandProperty id |
            Select-Object -First 20)
        if ($Models.Count -gt 0) {
            $Models | ForEach-Object { Write-Host "  - $_" }
        } else {
            Write-Host '  （API 探测无结果）'
        }
    } catch {
        Write-Host '  （API 探测失败：' $_.Exception.Message '）'
    }
} else {
    Write-Host '  （未设置 ANTHROPIC_BASE_URL，跳过探测）'
}

# ===== Step 2: 显示当前配置 =====
Write-Host ''
Write-Host '=== 当前 20 个 Agent 模型配置 ===' -ForegroundColor Cyan
foreach ($file in Get-ChildItem $AgentsDir -Filter *.md) {
    $name = $file.BaseName
    $model = Get-Content $file.FullName | Select-String '^model:' | Select-Object -First 1
    if ($model) {
        $modelVal = ($model.Line -replace '^model:\s*', '' -replace '"', '').Trim()
        Write-Host "  $name : $modelVal"
    } else {
        Write-Host "  $name : (继承当前模型)"
    }
}

# ===== Step 3: 推荐方案 =====
Write-Host ''
Write-Host '=== 推荐方案 ===' -ForegroundColor Cyan
$Strong = $null
$Balanced = $null

if ($Models.Count -eq 0) {
    Write-Host '  无法探测 -> 推荐：保持全部继承当前模型'
} elseif ($Models.Count -eq 1) {
    $Strong = $Models[0]
    $Balanced = $Strong
    Write-Host "  只有 1 个模型 -> 全部用 $Strong"
} else {
    $Strong = $Models[0]
    $Balanced = $Models[1]
    Write-Host '  分级配置：'
    Write-Host "    复杂推理（3 个：$($StrongRoles -join ', ')）-> $Strong"
    Write-Host "    常规任务（17 个：其余）-> $Balanced"
    Write-Host '  预计省钱：~30-40%'
}

# ===== Step 4: 询问 =====
Write-Host ''
Write-Host '选项：'
Write-Host '  1) 采用推荐方案'
Write-Host '  2) 继承当前模型（移除所有 model 字段）'
Write-Host '  3) 自定义'
Write-Host '  q) 退出，不做改动'
Write-Host ''
$choice = Read-Host '请选择 [1/2/3/q]'

function Set-Model {
    param([string]$Model, [string[]]$Roles)

    foreach ($name in $Roles) {
        $file = Join-Path $AgentsDir "$name.md"
        if (-not (Test-Path $file)) { continue }

        $content = Get-Content $file -Raw
        if ($content -match '(?m)^model:') {
            $content = $content -replace '(?m)^model:.*$', "model: `"$Model`""
        } else {
            $content = $content -replace '(?m)^(description:.*?)$', "`$1`r`nmodel: `"$Model`""
        }
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "  + $name -> $Model"
    }
}

function Remove-AllModelLines {
    foreach ($file in Get-ChildItem $AgentsDir -Filter *.md) {
        $content = Get-Content $file.FullName -Raw
        $content = $content -replace '(?m)^model:.*\r?\n', ''
        Set-Content -Path $file.FullName -Value $content -NoNewline
    }
    Write-Host '  + 已移除所有 model 字段'
}

switch ($choice) {
    '1' {
        if ($Models.Count -eq 0) {
            Write-Host '无法探测模型，请使用选项 2 或 3' -ForegroundColor Yellow
            exit 1
        }
        Write-Host ''
        Write-Host '应用推荐方案...' -ForegroundColor Cyan
        Set-Model -Model $Strong -Roles $StrongRoles
        Set-Model -Model $Balanced -Roles $BalancedRoles
    }
    '2' {
        Write-Host ''
        Write-Host '移除所有 model 字段...' -ForegroundColor Cyan
        Remove-AllModelLines
    }
    '3' {
        Write-Host ''
        $modelStrong = Read-Host '复杂推理用什么模型？'
        $modelBalanced = Read-Host '常规任务用什么模型？'
        Set-Model -Model $modelStrong -Roles $StrongRoles
        Set-Model -Model $modelBalanced -Roles $BalancedRoles
    }
    default {
        Write-Host '已退出，未做改动'
        exit 0
    }
}

Write-Host ''
Write-Host '完成。重启 Claude Code / Cursor 生效。' -ForegroundColor Green
