# 安装 product-lifecycle 推荐的 MCP server（Windows）
# 用法：powershell -ExecutionPolicy Bypass -File scripts/install-mcp.ps1 [-List] [-Uninstall] [-DryRun]

param(
    [switch]$List,
    [switch]$Uninstall,
    [switch]$DryRun
)

$mcpList = @(
    @{ Name='drawio'; Package='@next-ai-drawio/mcp-server@latest'; Desc='画 draw.io 图（流程图/架构图/ER/时序图等）' }
)

if ($List) {
    Write-Host "推荐的 MCP servers："
    foreach ($m in $mcpList) {
        Write-Host ("  - {0,-10} {1}`n              {2}" -f $m.Name, $m.Package, $m.Desc)
    }
    return
}

$hasClaude = $null -ne (Get-Command claude -ErrorAction SilentlyContinue)

if (-not $hasClaude) {
    Write-Host "[WARN] 未检测到 claude CLI" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请改用以下方式（任选其一）："
    Write-Host "  1) 项目级（已配置）：直接在本仓库使用 .mcp.json 自动生效"
    Write-Host "  2) Cursor：把 .cursor/mcp.json 内容合并到 %USERPROFILE%\.cursor\mcp.json"
    Write-Host "  3) 手动：claude mcp add drawio -- npx -y @next-ai-drawio/mcp-server@latest"
    return
}

foreach ($m in $mcpList) {
    if ($Uninstall) {
        if ($DryRun) {
            Write-Host "[dry-run] claude mcp remove $($m.Name)"
        } else {
            & claude mcp remove $m.Name 2>$null
            Write-Host "[ OK ] 卸载 $($m.Name)" -ForegroundColor Green
        }
        continue
    }

    if ($DryRun) {
        Write-Host "[dry-run] claude mcp add $($m.Name) -- npx -y $($m.Package)"
    } else {
        $existing = & claude mcp list 2>$null | Select-String "^$($m.Name)"
        if ($existing) {
            Write-Host "[ OK ] $($m.Name) 已注册（跳过）" -ForegroundColor Green
        } else {
            & claude mcp add $m.Name -- npx -y $m.Package
            Write-Host "[ OK ] 已注册 $($m.Name) → $($m.Package)" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "完成。在 Claude Code 中可让 AI 调用 drawio 工具绘图。" -ForegroundColor Green
Write-Host "详见 docs/05-advanced/DIAGRAMMING.md"
