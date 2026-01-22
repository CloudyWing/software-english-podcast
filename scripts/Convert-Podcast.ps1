
<#
.SYNOPSIS
    Converts SSML XML to Audio (MP3) - Robust Flat Structure Version
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,

    [Parameter(Mandatory=$true)]
    [string]$ApiKey,

    [Parameter(Mandatory=$true)]
    [string]$Region,

    [string]$OutputFile,

    [int]$CharLimit = 2500
)

$ErrorActionPreference = "Stop"

function Merge-AudioFiles {
    param($Files, $Output)
    Write-Host "Merging $( $Files.Count ) chunks into $Output..."
    $stream = [System.IO.File]::Create($Output)
    try {
        foreach ($file in $Files) {
            $bytes = [System.IO.File]::ReadAllBytes($file)
            $stream.Write($bytes, 0, $bytes.Length)
        }
    } finally {
        $stream.Close()
    }
}

function Invoke-TTS {
    param($SSML, $Path)
    $Uri = "https://$Region.tts.speech.microsoft.com/cognitiveservices/v1"

    # Ensure UTF-8
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($SSML)

    $Headers = @{
        "Ocp-Apim-Subscription-Key" = $ApiKey
        "Content-Type" = "application/ssml+xml"
        "X-Microsoft-OutputFormat" = "audio-16khz-128kbitrate-mono-mp3"
        "User-Agent" = "PodcastGen"
    }

    Write-Host "  - Sending Request ($( $SSML.Length ) chars)..."

    # DEBUG: Validating SSML before sending
    # $DebugFile = "$Path.debug.xml"
    # Set-Content -Path $DebugFile -Value $SSML -Encoding UTF8

    try {
        Invoke-RestMethod -Uri $Uri -Method Post -Body $Bytes -Headers $Headers -OutFile $Path
    }
    catch {
        Write-Error "API Call Failed: $_"
        if ($_.Exception.Response) {
             # Rewind stream if possible, or just read
             $Stream = $_.Exception.Response.GetResponseStream()
             if ($Stream.CanRead) {
                $Reader = New-Object System.IO.StreamReader($Stream)
                $ErrDetail = $Reader.ReadToEnd()
                Write-Error "API Error Detail: $ErrDetail"
             }
        }
        $DebugFile = "$Path.debug.xml"
        Set-Content -Path $DebugFile -Value $SSML -Encoding UTF8
        Write-Warning "Failed SSML saved to: $DebugFile"
        throw
    }
}

# --- Main ---

$Content = Get-Content -Path $InputFile -Raw -Encoding UTF8
$TotalLength = $Content.Length

if (-not $OutputFile) { $OutputFile = $InputFile -replace "\.xml$", ".mp3" }

Write-Host "Processing: $InputFile ($TotalLength chars)"

# 1. Parse Outer Wrappers
if ($Content -match "(?s)(<speak.*?>)(.*)(</speak>)") {
    $Header = $matches[1]
    $Body = $matches[2]
    $Footer = $matches[3]

    # Remove redundant namespaces from body to prevent 400 Bad Request
    # Use regex to match with or without leading space
    $Body = $Body -replace '\s*xmlns="http://www.w3.org/2001/10/synthesis"', ''
    $Body = $Body -replace '\s*xmlns:mstts="http://www.w3.org/2001/mstts"', ''

    # Trim body to remove potential weird whitespace at ends
    $Body = $Body.Trim()

    # Remove XML declaration if it exists in body segments (it shouldn't, but safety first)
    $Body = $Body -replace '<\?xml.*?\?>', ''

    # Clean empty lines that might break SSML (optional but good practice)
    # $Body = $Body -replace '^\s*$', ''
} else {
    Write-Error "Invalid SSML Structure. Missing <speak> tags."
    exit
}

# 2. Split into Voice Blocks
# We split by the CLOSING tag </voice>. The split keeps the delimiter if wrapped in parens.
# Logic: Split string.
# Result: [VoiceBlockWithoutEndTag, </voice>, VoiceBlock2WithoutEndTag, </voice>, ...]
$SplitParts = $Body -split "(</voice>)"

# Group into clean segments: "Content" + "</voice>"
$Segments = @()
for ($i = 0; $i -lt $SplitParts.Count; $i+=2) {
    if ($i+1 -lt $SplitParts.Count) {
        $Seg = $SplitParts[$i] + $SplitParts[$i+1] # Content + Closed Tag
        if (-not [string]::IsNullOrWhiteSpace($Seg)) {
             $Segments += $Seg
        }
    } else {
        # Trailing part (whitespace?)
        if (-not [string]::IsNullOrWhiteSpace($SplitParts[$i])) {
            Write-Warning "Found orphaned content at end: $($SplitParts[$i])"
        }
    }
}

Write-Host "  Found $( $Segments.Count ) voice blocks."

# 3. Batch Segments
$Chunks = @()
$CurrentChunkSSML = ""
$ChunkCounter = 1
$TempFiles = @()

foreach ($Segment in $Segments) {
    $PredictedLen = $Header.Length + $CurrentChunkSSML.Length + $Segment.Length + $Footer.Length

    if ($PredictedLen -gt $CharLimit -and $CurrentChunkSSML.Length -gt 0) {
        # Flush current
        $FullSSML = "$Header$CurrentChunkSSML$Footer"
        $TempFile = "$OutputFile.part$ChunkCounter.mp3"
        Invoke-TTS -SSML $FullSSML -Path $TempFile
        $TempFiles += $TempFile

        $CurrentChunkSSML = $Segment
        $ChunkCounter++
    } else {
        $CurrentChunkSSML += $Segment
    }
}

# Final Flush
if ($CurrentChunkSSML.Length -gt 0) {
    $FullSSML = "$Header$CurrentChunkSSML$Footer"
    $TempFile = "$OutputFile.part$ChunkCounter.mp3"
    Invoke-TTS -SSML $FullSSML -Path $TempFile
    $TempFiles += $TempFile
}

# 4. Merge
Merge-AudioFiles -Files $TempFiles -Output $OutputFile
if ($TempFiles.Count -gt 0) {
    Remove-Item -Path $TempFiles -ErrorAction SilentlyContinue
}

Write-Host "Success: $OutputFile"
