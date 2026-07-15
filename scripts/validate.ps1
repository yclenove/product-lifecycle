# validate.ps1 - Automated validation (PowerShell)
# Usage: powershell -File scripts/validate.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Continue"
$Root = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
$ExpectedAgents = 20
$errors = 0

Write-Host "=== Validation Checks ==="

Write-Host -NoNewline "SKILL.md frontmatter: "
$firstLine = (Get-Content "$Root\SKILL.md" -TotalCount 1 -Encoding UTF8).Trim()
if ($firstLine -eq "---") { Write-Host "PASS" } else { Write-Host "FAIL"; $errors++ }

Write-Host -NoNewline ".claude/agents/ count: "
$agentCount = (Get-ChildItem "$Root\.claude\agents\*.md" -ErrorAction SilentlyContinue).Count
if ($agentCount -eq $ExpectedAgents) { Write-Host "PASS ($agentCount)" } else { Write-Host "FAIL ($agentCount/$ExpectedAgents)"; $errors++ }

Write-Host -NoNewline "PRODUCT_PLAN refs: "
$stale = Get-ChildItem "$Root\agents\*.md","$Root\templates\*.md","$Root\.claude\agents\*.md","$Root\SKILL.md" -ErrorAction SilentlyContinue | Select-String -Pattern "PRODUCT_PLAN" -Encoding UTF8 | Where-Object { $_.Filename -notmatch "CHANGELOG|quality-gatekeeper" }
if ($stale) { Write-Host "FAIL"; $errors++ } else { Write-Host "PASS" }

Write-Host -NoNewline "trends 2025 refs: "
$old = Get-ChildItem "$Root\agents\*.md","$Root\.claude\agents\*.md","$Root\templates\*.md" -ErrorAction SilentlyContinue | Select-String -Pattern "trends 2025" -Encoding UTF8 | Where-Object { $_.Filename -notmatch "quality-gatekeeper" }
if ($old) { Write-Host "FAIL"; $errors++ } else { Write-Host "PASS" }

Write-Host -NoNewline "Step0/method coverage: "
$ctxCount = 0
foreach ($f in Get-ChildItem "$Root\agents\*.md") {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match "Step 0" -and $content -match "\u63a8\u8350\u65b9\u6cd5\u8bba skills") { $ctxCount++ }
}
if ($ctxCount -eq $ExpectedAgents) { Write-Host "PASS ($ctxCount/$ExpectedAgents)" } else { Write-Host "FAIL ($ctxCount/$ExpectedAgents)"; $errors++ }

Write-Host -NoNewline "Agent required sections: "
$miss = 0
$patterns = @(
    "\u4f60\u7684(\u804c\u8d23|\u6838\u5fc3\u80fd\u529b|\u76ee\u6807|\u5de5\u4f5c)",
    "## (\u4ea7\u51fa|\u8f93\u51fa)",
    "Step 0",
    "\u63a8\u8350\u65b9\u6cd5\u8bba skills",
    "\u8d28\u91cf\u95e8\u7981"
)
foreach ($f in Get-ChildItem "$Root\agents\*.md") {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    foreach ($pattern in $patterns) {
        if ($content -notmatch $pattern) { Write-Host -NoNewline "$($f.BaseName)/section "; $miss++ }
    }
}
if ($miss -eq 0) { Write-Host "PASS" } else { Write-Host "FAIL ($miss)"; $errors++ }

Write-Host -NoNewline "Template metadata: "
$metaMiss = 0
foreach ($f in Get-ChildItem "$Root\templates\*_template.md") {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($content -notmatch "\| \u5b57\u6bb5") { Write-Host -NoNewline "$($f.Name) "; $metaMiss++ }
}
if ($metaMiss -eq 0) { Write-Host "PASS" } else { Write-Host "FAIL ($metaMiss)"; $errors++ }

Write-Host -NoNewline "Agent line count: "
$lineIssues = 0
foreach ($f in Get-ChildItem "$Root\agents\*.md") {
    $lines = (Get-Content $f.FullName -Encoding UTF8).Count
    if ($lines -lt 80) { Write-Host -NoNewline "$($f.BaseName)($lines) "; $lineIssues++ }
    elseif ($lines -gt 400) { Write-Host -NoNewline "$($f.BaseName)($lines) "; $lineIssues++ }
}
if ($lineIssues -eq 0) { Write-Host "PASS (80-400)" } else { Write-Host "WARN ($lineIssues)" }

Write-Host -NoNewline ".claude/agents/ sync: "
$syncMiss = 0
foreach ($f in Get-ChildItem "$Root\agents\*.md") {
    $targetPath = Join-Path $Root (Join-Path '.claude' (Join-Path 'agents' $f.Name))
    if (-not (Test-Path $targetPath)) { Write-Host -NoNewline "$($f.BaseName)(missing) "; $syncMiss++ }
}
if ($syncMiss -eq 0) { Write-Host "PASS ($ExpectedAgents/$ExpectedAgents)" } else { Write-Host "FAIL ($syncMiss)"; $errors++ }

Write-Host ""
if ($errors -eq 0) { Write-Host "All checks passed"; exit 0 }
else { Write-Host "$errors check(s) failed"; exit 1 }

