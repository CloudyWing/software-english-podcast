<#
.SYNOPSIS
    Batch converts all XML transcripts to MP3 in the assets folder.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$TranscriptsDir = Join-Path $ProjectRoot "transcripts"
$AssetsDir = Join-Path $ProjectRoot "assets"

# Ensure Assets Directory Exists
if (-not (Test-Path $AssetsDir)) {
    New-Item -ItemType Directory -Path $AssetsDir | Out-Null
    Write-Host "Created assets directory: $AssetsDir"
}

# Check Environment Variables
if (-not $env:TTS_KEY -or -not $env:TTS_REGION) {
    Write-Error "Please set TTS_KEY and TTS_REGION environment variables."
    Write-Host "Example:"
    Write-Host '$env:TTS_KEY = "your_key"'
    Write-Host '$env:TTS_REGION = "eastus"'
    exit 1
}

$XmlFiles = Get-ChildItem "$TranscriptsDir\*.xml"

foreach ($File in $XmlFiles) {
    if ($File.Name -like "*.debug.xml") { continue } # Skip debug files

    $BaseName = $File.BaseName
    $OutputMp3 = Join-Path $AssetsDir "$BaseName.mp3"

    if (Test-Path $OutputMp3) {
        Write-Host "Skipping $BaseName (Already exists)" -ForegroundColor Gray
        continue
    }

    Write-Host "Converting: $($File.Name)" -ForegroundColor Cyan

    try {
        & "$ScriptDir\Convert-Podcast.ps1" `
            -InputFile $File.FullName `
            -OutputFile $OutputMp3 `
            -ApiKey $env:TTS_KEY `
            -Region $env:TTS_REGION

        Write-Host "  -> Generated: $OutputMp3" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to convert $($File.Name): $_"
    }
}
