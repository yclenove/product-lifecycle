# 长程迭代模式：会话结束前生成移交单（Windows）
# 用法：powershell -ExecutionPolicy Bypass -File scripts/handoff.ps1

$ErrorActionPreference = 'Stop'
$ROOT = (Resolve-Path "$PSScriptRoot\..").Path
$TEMPLATE = Join-Path $ROOT "docs\long-running\HANDOFF.template.md"
$HANDOFF = Join-Path $ROOT "docs\long-running\HANDOFF.md"

if (-not (Test-Path $TEMPLATE)) {
    Write-Host "[!] HANDOFF.template.md 不存在，请先 git pull 同步"
    exit 1
}

if (Test-Path $HANDOFF) {
    Write-Host "[!] HANDOFF.md 已存在。"
    $ans = Read-Host "覆盖？(y/N)"
    if ($ans -ne 'y' -and $ans -ne 'Y') {
        Write-Host "已取消。"
        exit 0
    }
}

Copy-Item $TEMPLATE $HANDOFF -Force
Write-Host "[OK] 已生成 $HANDOFF"
Write-Host ""
Write-Host "请填写以下重点字段："
Write-Host "  - 本轮主要产出"
Write-Host "  - 本轮关键决策"
Write-Host "  - 遗留 / 未决策项（特别是 P0）"
Write-Host "  - 给下一个 AI 的话（口语 ok）"
Write-Host ""
Write-Host "可以让 AI 自动填："
Write-Host "  > 帮我填 docs/07-long-running/HANDOFF.md，"
Write-Host "  > 基于本次 session 的产出和未完成项"