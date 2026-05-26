# 长程迭代模式：恢复上下文（Windows）
# 用法：powershell -ExecutionPolicy Bypass -File scripts/resume.ps1

$ErrorActionPreference = 'Stop'
$ROOT = (Resolve-Path "$PSScriptRoot\..").Path
$STATE = Join-Path $ROOT "docs\long-running\STATE.md"
$HANDOFF = Join-Path $ROOT "docs\long-running\HANDOFF.md"

Write-Host "========================================"
Write-Host "  长程迭代恢复"
Write-Host "========================================"
Write-Host ""

if (-not (Test-Path $STATE)) {
    Write-Host "[!] 未检测到 STATE.md，看起来这是新项目或未启用长程模式。"
    Write-Host ""
    Write-Host "启用长程模式："
    Write-Host "  Copy-Item docs\long-running\STATE.template.md docs\long-running\STATE.md"
    Write-Host ""
    Write-Host "然后正常走 orchestrator 流程即可。"
    exit 0
}

Write-Host "[OK] 检测到 STATE.md，正在恢复上下文…"
Write-Host ""

function Extract-Section {
    param([string]$Path, [string]$StartHeader, [string]$EndHeader)
    $content = Get-Content -Path $Path -Raw
    if ($content -match "(?ms)$([regex]::Escape($StartHeader)).*?(?=$([regex]::Escape($EndHeader)))") {
        return $matches[0]
    }
    return ""
}

Write-Host "----------------------------------------"
Write-Host "  当前状态摘要"
Write-Host "----------------------------------------"
(Extract-Section $STATE "## 元数据" "## 当前进行中") -split "`n" | Select-Object -First 20 | ForEach-Object { Write-Host $_ }
Write-Host ""

Write-Host "----------------------------------------"
Write-Host "  当前进行中"
Write-Host "----------------------------------------"
Write-Host (Extract-Section $STATE "## 当前进行中" "## 已完成 Agent 清单")
Write-Host ""

Write-Host "----------------------------------------"
Write-Host "  最近 3 个已完成 Agent"
Write-Host "----------------------------------------"
$done = Extract-Section $STATE "## 已完成 Agent 清单" "## 未完成"
$doneItems = ($done -split "`n") | Where-Object { $_ -match "^### " } | Select-Object -First 3
if ($doneItems) {
    $doneItems | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "(暂无)"
}
Write-Host ""

Write-Host "----------------------------------------"
Write-Host "  阻塞项"
Write-Host "----------------------------------------"
Write-Host (Extract-Section $STATE "## 未完成 / 阻塞项" "## 下一步建议")
Write-Host ""

Write-Host "----------------------------------------"
Write-Host "  下一步建议"
Write-Host "----------------------------------------"
Write-Host (Extract-Section $STATE "## 下一步建议" "## 关键产出索引")

if (Test-Path $HANDOFF) {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "  上次 Session 移交单"
    Write-Host "========================================"
    Write-Host ""
    $msg = Extract-Section $HANDOFF "## 给下一个 AI 的话" "## 风险预警"
    if ($msg) { Write-Host $msg } else { Write-Host "(HANDOFF 中无该段)" }
}

Write-Host ""
Write-Host "========================================"
Write-Host "  建议下一步操作"
Write-Host "========================================"
Write-Host ""
Write-Host "1. 在 AI 工具里粘贴："
Write-Host ""
Write-Host "   > 我正在长程迭代中，请先读 docs/07-long-running/STATE.md 和"
Write-Host "   > docs/07-long-running/HANDOFF.md 恢复上下文，然后接着上次进度继续。"
Write-Host ""
Write-Host "2. 关键文档清单已在 STATE.md 的「关键产出索引」表里"
Write-Host ""