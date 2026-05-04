<#
.SYNOPSIS
  Install product-lifecycle Cursor Subagents into a new business project (rewrites Read paths to skill absolute path).

.DESCRIPTION
  Cursor cannot auto-inject .cursor/agents into other repos. Run this once per project.

.PARAMETER Target
  Business project root (creates Target\.cursor\agents\). Default: current directory.

.PARAMETER SkillRoot
  Skill package root. Default: $env:PRODUCT_LIFECYCLE_ROOT

.EXAMPLE
  $env:PRODUCT_LIFECYCLE_ROOT = "$env:USERPROFILE\.cursor\skills\product-lifecycle"
  cd H:\my-new-app
  pwsh -File "$env:PRODUCT_LIFECYCLE_ROOT\scripts\install-cursor-subagents.ps1"

.EXAMPLE
  .\install-cursor-subagents.ps1 -Target "H:\my-new-app" -SkillRoot "H:\aicoding\product-lifecycle"
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Target = (Get-Location).Path,

    [string] $SkillRoot = $env:PRODUCT_LIFECYCLE_ROOT
)

$ErrorActionPreference = 'Stop'
$bt = [char]0x60

if (-not $SkillRoot) {
    Write-Error 'Set PRODUCT_LIFECYCLE_ROOT or pass -SkillRoot to the product-lifecycle repo root.'
    exit 1
}

$skillResolved = (Resolve-Path -LiteralPath $SkillRoot).ProviderPath
if (-not (Test-Path (Join-Path $skillResolved 'agents\orchestrator.md'))) {
    Write-Error "Invalid SkillRoot (missing agents\orchestrator.md): $skillResolved"
    exit 1
}

$srcAgents = Join-Path $skillResolved '.cursor\agents'
if (-not (Test-Path $srcAgents)) {
    Write-Error "SkillRoot missing .cursor\agents: $srcAgents"
    exit 1
}

$targetResolved = (Resolve-Path -LiteralPath $Target).ProviderPath
$destAgents = Join-Path $targetResolved '.cursor\agents'
New-Item -ItemType Directory -Force -Path $destAgents | Out-Null

$skillUnix = $skillResolved -replace '\\', '/'

$orchOld = '1. From the workspace root (the repo that contains ' + $bt + '.cursor/agents/' + $bt + '), **Read** ' + $bt + 'agents/orchestrator.md' + $bt + ' and execute it completely.'
$orchNew = '1. **Read** ' + $bt + $skillUnix + '/agents/orchestrator.md' + $bt + ' and execute it completely.'

Get-ChildItem -LiteralPath $srcAgents -Filter '*.md' | Where-Object { $_.Name -ne 'README.md' } | ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))

    if ($_.Name -eq 'orchestrator.md') {
        $text = $text.Replace($orchOld, $orchNew)
    }
    else {
        $text = $text.Replace($bt + 'agents/', $bt + $skillUnix + '/agents/')
    }
    $text = $text.Replace($bt + 'templates/', $bt + $skillUnix + '/templates/')

    $outPath = Join-Path $destAgents $_.Name
    [System.IO.File]::WriteAllText($outPath, $text, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Wrote $outPath"
}

$readmeSrc = Join-Path $srcAgents 'README.md'
if (Test-Path $readmeSrc) {
    Copy-Item -LiteralPath $readmeSrc -Destination (Join-Path $destAgents 'README.md') -Force
    Write-Host ('Wrote ' + (Join-Path $destAgents 'README.md') + ' (copy)')
}

Write-Host ''
Write-Host 'Done. Reload Cursor in the business project; use /orchestrator etc.'
Write-Host "Skill path embedded: $skillUnix"
