# 长程迭代模式：保存阶段 checkpoint（Windows）
# 用法：powershell -ExecutionPolicy Bypass -File scripts/checkpoint.ps1 <agent-name> [描述]

param(
    [Parameter(Mandatory=$true)]
    [string]$AgentName,
    [string]$Description = ""
)

$ErrorActionPreference = 'Stop'
$ROOT = (Resolve-Path "$PSScriptRoot\..").Path
$STATE = Join-Path $ROOT "docs\long-running\STATE.md"
$CKP_DIR = Join-Path $ROOT "docs\long-running\CHECKPOINTS"
$DATE = Get-Date -Format "yyyyMMdd"
$CKP_FILE = Join-Path $CKP_DIR "CKP-${DATE}-${AgentName}-done.md"

if (-not (Test-Path $STATE)) {
    Write-Host "[!] STATE.md 不存在，请先启用长程模式："
    Write-Host "    Copy-Item docs\long-running\STATE.template.md docs\long-running\STATE.md"
    exit 1
}

if (-not (Test-Path $CKP_DIR)) {
    New-Item -ItemType Directory -Path $CKP_DIR -Force | Out-Null
}

$stateContent = Get-Content $STATE -Raw

$header = @"
# Checkpoint: $AgentName 完成

| 字段 | 值 |
|------|-----|
| Agent | $AgentName |
| 日期 | $(Get-Date -Format 'yyyy-MM-dd') |
| 时间 | $(Get-Date -Format 'HH:mm:ss') |
| 描述 | $Description |

## STATE 快照

``````markdown
$stateContent
``````

## 本次新增/修改文件

"@

$header | Out-File -FilePath $CKP_FILE -Encoding UTF8

try {
    Push-Location $ROOT
    $isGit = (git rev-parse --git-dir 2>$null) -ne $null
    if ($isGit) {
        "``````" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        git status --short 2>$null | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        "``````" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        "" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        "## 最近 5 个 commit" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        "" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        "``````" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        git log --oneline -5 2>$null | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
        "``````" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
    } else {
        "(非 git 仓库，跳过 diff 摘要)" | Out-File -FilePath $CKP_FILE -Encoding UTF8 -Append
    }
} finally {
    Pop-Location
}

Write-Host "[OK] Checkpoint 已保存：$CKP_FILE"
Write-Host ""
Write-Host "提示：建议把它加进 git 跟踪团队里程碑"
Write-Host "  git add $CKP_FILE"
