# iterate.ps1 — 迭代收尾脚本（PowerShell 版）
# 用法: pwsh -File scripts/iterate.ps1 [--check] [--sync-only]

param(
    [switch]$Check,
    [switch]$SyncOnly
)

$ErrorActionPreference = "Continue"
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
$RootDir = Split-Path $ScriptDir
$AgentsDir = "$RootDir\agents"
$ClaudeDir = "$RootDir\.claude\agents"
$SkillDir = "$HOME\.claude\skills\product-lifecycle"

Write-Host "=========================================="
Write-Host " iterate.ps1 — 迭代收尾"
Write-Host "=========================================="
Write-Host ""

# Step 1: 检查是否需要同步
Write-Host "Step 1: 检查 agents/ 与 .claude/agents/ 一致性"
Write-Host ""

$needSync = $false
foreach ($f in Get-ChildItem "$AgentsDir\*.md") {
    $dst = "$ClaudeDir\$($f.Name)"
    if (-not (Test-Path $dst)) {
        Write-Host "  ✗ $($f.BaseName).md — .claude/agents/ 中不存在"
        $needSync = $true
        continue
    }
    $srcTime = (Get-Item $f.FullName).LastWriteTime
    $dstTime = (Get-Item $dst).LastWriteTime
    if ($srcTime -gt $dstTime) {
        Write-Host "  ! $($f.BaseName).md — agents/ 更新，需要同步"
        $needSync = $true
    }
}

if (-not $needSync) { Write-Host "  ✓ 所有 Agent 已同步" }
Write-Host ""

if ($Check) {
    Write-Host "（--check 模式，不执行操作）"
    exit 0
}

# Step 2: 同步
if ($needSync) {
    Write-Host "Step 2: 同步 .claude/agents/"
    Write-Host ""
    & pwsh -File "$ScriptDir\sync-agents.ps1"
    Write-Host ""
} else {
    Write-Host "Step 2: 跳过（无需同步）"
    Write-Host ""
}

if ($SyncOnly) {
    Write-Host "（--sync-only 模式，不更新 skill）"
    Write-Host ""
    Write-Host "=========================================="
    Write-Host " 收尾完成"
    Write-Host "=========================================="
    exit 0
}

# Step 3: 更新本机 skill
Write-Host "Step 3: 更新本机 skill"
Write-Host ""

if (-not (Test-Path $SkillDir)) {
    Write-Host "  ! 本机 skill 目录不存在: $SkillDir"
    Write-Host "  跳过。如需安装：git clone <repo> $SkillDir"
} else {
    Write-Host "  同步文件到 $SkillDir ..."

    # 核心文件
    foreach ($f in @("SKILL.md","README.md","CHANGELOG.md")) {
        if (Test-Path "$RootDir\$f") { Copy-Item "$RootDir\$f" "$SkillDir\$f" -Force }
    }

    # 目录同步
    $dirs = @("agents",".claude\agents","templates","docs","examples","scripts")
    foreach ($d in $dirs) {
        $srcDir = "$RootDir\$d"
        $dstDir = "$SkillDir\$d"
        if (Test-Path $srcDir) {
            if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
            Get-ChildItem "$srcDir\*" -ErrorAction SilentlyContinue | ForEach-Object {
                Copy-Item $_.FullName $dstDir -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host "  ✓ 本机 skill 已更新"
}

Write-Host ""
Write-Host "=========================================="
Write-Host " 收尾完成"
Write-Host "=========================================="
Write-Host ""
Write-Host "下一步："
Write-Host "  - 如需提交: git add -A && git commit"
Write-Host "  - 如需检查: pwsh -File scripts/iterate.ps1 --check"
