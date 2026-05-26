#requires -Version 5.0
<#
.SYNOPSIS
  一键安装 product-lifecycle 推荐的通用方法论 skill。

.DESCRIPTION
  从 Anthropic 官方仓库和 superpowers-zh 拉取推荐 skill 到本机。

.PARAMETER Target
  目标平台：Claude / Cursor / All（默认 All）

.PARAMETER DryRun
  仅显示会做什么，不实际克隆。

.EXAMPLE
  .\scripts\install-skills.ps1
  .\scripts\install-skills.ps1 -Target Claude
  .\scripts\install-skills.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [ValidateSet('Claude', 'Cursor', 'All')]
    [string]$Target = 'All',

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# 推荐 skill 仓库清单
$Repos = @{
    'superpowers-zh'     = 'https://github.com/obra/superpowers.git'
    'anthropics-skills'  = 'https://github.com/anthropics/skills.git'
}

function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok   { param($msg) Write-Host "[ OK ] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err  { param($msg) Write-Host "[FAIL] $msg" -ForegroundColor Red }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Err 'git 未安装，请先安装 git'
    exit 1
}

function Install-To {
    param(
        [string]$TargetRoot,
        [string]$Platform
    )

    Write-Info "目标平台：$Platform"
    Write-Info "安装目录：$TargetRoot"

    if (-not $DryRun) {
        if (-not (Test-Path $TargetRoot)) {
            New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null
        }
    }

    foreach ($name in $Repos.Keys) {
        $url = $Repos[$name]
        $dest = Join-Path $TargetRoot $name

        if (Test-Path (Join-Path $dest '.git')) {
            Write-Ok "$name 已存在，跳过（更新可在该目录运行 git pull）"
            continue
        }

        Write-Info "安装 $name <- $url"
        if ($DryRun) {
            Write-Host "  [dry-run] git clone --depth 1 $url $dest"
        } else {
            try {
                git clone --depth 1 $url $dest 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Ok "$name 安装完成"
                } else {
                    Write-Err "$name 克隆失败"
                }
            } catch {
                Write-Err "$name 克隆异常：$_"
            }
        }
    }

    Write-Host ''
}

$installClaude = $Target -in @('Claude', 'All')
$installCursor = $Target -in @('Cursor', 'All')

if ($installClaude) {
    Install-To -TargetRoot (Join-Path $HOME '.claude\skills') -Platform 'Claude Code'
}

if ($installCursor) {
    Install-To -TargetRoot (Join-Path $HOME '.cursor\skills') -Platform 'Cursor'
}

function Test-Install {
    param([string]$TargetRoot)
    if (-not (Test-Path $TargetRoot)) { return }
    Write-Info "校验 $TargetRoot ..."
    $count = (Get-ChildItem -Path $TargetRoot -Filter SKILL.md -Recurse -ErrorAction SilentlyContinue).Count
    Write-Ok "  发现 $count 个 SKILL.md"
}

if (-not $DryRun) {
    if ($installClaude) { Test-Install (Join-Path $HOME '.claude\skills') }
    if ($installCursor) { Test-Install (Join-Path $HOME '.cursor\skills') }
}

Write-Ok '完成。详见 docs/04-reference/SKILL-INTEGRATION.md'