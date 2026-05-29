param(
  [string]$TemplateCtbPath = "..\..\0.RELEASE\TNT_PLOT_STYLE_2026.ctb",
  [string]$EditedCtbCsvPath = ".\OUT_REVIEW\CTB_255_Colors.csv",
  [string]$OutCtbPath = ".\OUT_BUILD\TNT_PLOT_STYLE_2026_EDITED.ctb",
  [string]$OutRawTextPath = ".\OUT_BUILD\TNT_PLOT_STYLE_2026_EDITED.raw.txt"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-HerePath {
  param([string]$Path)
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return (Join-Path $PSScriptRoot $Path)
}

function Convert-CtbToTextAndHeader {
  param([string]$Path)

  $bytes = [IO.File]::ReadAllBytes($Path)
  $offset = -1
  for ($i = 0; $i -lt ($bytes.Length - 1); $i++) {
    if ($bytes[$i] -eq 0x78 -and ($bytes[$i + 1] -in 0x01, 0x9C, 0xDA)) {
      $offset = $i
      break
    }
  }
  if ($offset -lt 0) { throw "Could not find zlib payload in CTB file: $Path" }
  if ($offset -lt 12) { throw "Unexpected CTB header before zlib payload." }

  $payload = $bytes[$offset..($bytes.Length - 1)]
  $ms = New-Object IO.MemoryStream(,$payload)
  [void]$ms.ReadByte()
  [void]$ms.ReadByte()
  $ds = New-Object IO.Compression.DeflateStream($ms, [IO.Compression.CompressionMode]::Decompress)
  $out = New-Object IO.MemoryStream
  $ds.CopyTo($out)
  $ds.Close()

  [pscustomobject]@{
    Text = [Text.Encoding]::ASCII.GetString($out.ToArray())
    PrefixBeforeLengths = $bytes[0..($offset - 9)]
    UnknownHeaderBytes = $bytes[($offset - 8)..($offset - 5)]
  }
}

function Get-Adler32 {
  param([byte[]]$Bytes)

  $mod = 65521
  $a = 1
  $b = 0
  foreach ($byte in $Bytes) {
    $a = ($a + $byte) % $mod
    $b = ($b + $a) % $mod
  }
  return (($b -shl 16) -bor $a)
}

function New-ZlibPayload {
  param([byte[]]$RawBytes)

  $deflated = New-Object IO.MemoryStream
  $ds = New-Object IO.Compression.DeflateStream($deflated, [IO.Compression.CompressionLevel]::Optimal, $true)
  $ds.Write($RawBytes, 0, $RawBytes.Length)
  $ds.Close()

  $adler = Get-Adler32 -Bytes $RawBytes
  $payload = New-Object System.Collections.Generic.List[byte]
  $payload.Add(0x78)
  $payload.Add(0xDA)
  $payload.AddRange($deflated.ToArray())
  $payload.Add([byte](($adler -shr 24) -band 0xFF))
  $payload.Add([byte](($adler -shr 16) -band 0xFF))
  $payload.Add([byte](($adler -shr 8) -band 0xFF))
  $payload.Add([byte]($adler -band 0xFF))
  $payload.ToArray()
}

function Get-LittleEndianUInt32Bytes {
  param([int]$Value)
  [BitConverter]::GetBytes([UInt32]$Value)
}

function Validate-CtbRows {
  param($Rows)

  if ($Rows.Count -ne 255) { throw "CTB CSV must contain exactly 255 rows. Found: $($Rows.Count)" }
  $seen = @{}
  foreach ($row in $Rows) {
    if ([string]::IsNullOrWhiteSpace($row.PlotStyleIndex)) { throw "Missing PlotStyleIndex." }
    if ([string]::IsNullOrWhiteSpace($row.ACI)) { throw "Missing ACI." }
    $idx = [int]$row.PlotStyleIndex
    $aci = [int]$row.ACI
    if ($idx -lt 0 -or $idx -gt 254) { throw "PlotStyleIndex out of range: $idx" }
    if ($aci -ne ($idx + 1)) { throw "ACI must equal PlotStyleIndex + 1. Index=$idx ACI=$aci" }
    if ($seen.ContainsKey($idx)) { throw "Duplicate PlotStyleIndex: $idx" }
    $seen[$idx] = $true
    if ([string]::IsNullOrWhiteSpace($row.lineweight)) { throw "Missing lineweight for ACI $aci" }
    $lw = [int]$row.lineweight
    if ($lw -lt 0 -or $lw -gt 23) { throw "Lineweight code out of known range 0..23 for ACI $aci`: $lw" }
  }
}

function Format-CtbValue {
  param($Value, [bool]$Quoted)
  if ($null -eq $Value) { $Value = "" }
  $s = [string]$Value
  if ($Quoted) { return '"' + $s }
  return $s
}

function Update-CtbText {
  param(
    [string]$TemplateText,
    $Rows
  )

  $byIndex = @{}
  foreach ($row in $Rows) { $byIndex[[int]$row.PlotStyleIndex] = $row }

  $editableKeys = @(
    "name", "localized_name", "description",
    "color", "mode_color", "color_policy",
    "physical_pen_number", "virtual_pen_number",
    "screen", "linepattern_size", "linetype",
    "adaptive_linetype", "lineweight",
    "fill_style", "end_style", "join_style"
  )
  $quotedKeys = @("name", "localized_name", "description")

  $lines = $TemplateText -split "`r?`n"
  $currentIndex = $null
  $outLines = New-Object System.Collections.Generic.List[string]

  foreach ($line in $lines) {
    if ($line -match '^\s*(\d+)\{') {
      $currentIndex = [int]$Matches[1]
      $outLines.Add($line)
      continue
    }
    if ($null -ne $currentIndex -and $line -match '^\s*\}') {
      $currentIndex = $null
      $outLines.Add($line)
      continue
    }
    if ($null -ne $currentIndex -and $line -match '^(\s*)([A-Za-z_]+)=(.*)$') {
      $indent = $Matches[1]
      $key = $Matches[2]
      if ($editableKeys -contains $key) {
        $row = $byIndex[$currentIndex]
        if ($row.PSObject.Properties.Name -contains $key) {
          $quoted = $quotedKeys -contains $key
          $outLines.Add($indent + $key + "=" + (Format-CtbValue $row.$key $quoted))
          continue
        }
      }
    }
    $outLines.Add($line)
  }

  ($outLines -join "`r`n")
}

$templateCtb = Resolve-HerePath $TemplateCtbPath
$editedCsv = Resolve-HerePath $EditedCtbCsvPath
$outCtb = Resolve-HerePath $OutCtbPath
$outRaw = Resolve-HerePath $OutRawTextPath

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $outCtb) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $outRaw) | Out-Null

$rows = @(Import-Csv -LiteralPath $editedCsv -Encoding UTF8)
Validate-CtbRows -Rows $rows

$template = Convert-CtbToTextAndHeader -Path $templateCtb
$newText = Update-CtbText -TemplateText $template.Text -Rows $rows
$rawBytes = [Text.Encoding]::ASCII.GetBytes($newText)
$zlib = New-ZlibPayload -RawBytes $rawBytes

$final = New-Object System.Collections.Generic.List[byte]
$final.AddRange([byte[]]$template.PrefixBeforeLengths)
$final.AddRange([byte[]]$template.UnknownHeaderBytes)
$final.AddRange([byte[]](Get-LittleEndianUInt32Bytes $rawBytes.Length))
$final.AddRange([byte[]](Get-LittleEndianUInt32Bytes $zlib.Length))
$final.AddRange([byte[]]$zlib)

[IO.File]::WriteAllText($outRaw, $newText, [Text.Encoding]::UTF8)
[IO.File]::WriteAllBytes($outCtb, $final.ToArray())

Write-Host "[TNT] Built CTB: $outCtb"
Write-Host "[TNT] Built raw text: $outRaw"
Write-Host "[TNT] Original CTB was not modified: $templateCtb"
