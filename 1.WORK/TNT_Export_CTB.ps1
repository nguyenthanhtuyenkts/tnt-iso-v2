param(
  [string]$CtbPath = "0.RELEASE\TNT_PLOT_STYLE_2026.ctb",
  [string]$LayerLispPath = "0.RELEASE\TNT_PACKAGE_00_SYSTEM_ALL.lsp",
  [string]$OutDir = "1.WORK\CTB_EXPORT"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Convert-CtbToText {
  param([string]$Path)

  $bytes = [IO.File]::ReadAllBytes($Path)
  $offset = -1
  for ($i = 0; $i -lt ($bytes.Length - 1); $i++) {
    if ($bytes[$i] -eq 0x78 -and ($bytes[$i + 1] -in 0x01, 0x9C, 0xDA)) {
      $offset = $i
      break
    }
  }
  if ($offset -lt 0) {
    throw "Could not find zlib payload in CTB file: $Path"
  }

  $payload = $bytes[$offset..($bytes.Length - 1)]
  $ms = New-Object IO.MemoryStream(,$payload)
  [void]$ms.ReadByte()
  [void]$ms.ReadByte()
  $ds = New-Object IO.Compression.DeflateStream($ms, [IO.Compression.CompressionMode]::Decompress)
  $out = New-Object IO.MemoryStream
  $ds.CopyTo($out)
  $ds.Close()

  [Text.Encoding]::ASCII.GetString($out.ToArray())
}

function Get-LineweightMm {
  param($Code)

  # CTB stores lineweight as an index into AutoCAD's valid lineweight table.
  # Values are hundredths of a millimeter.
  $valid = @(0, 5, 9, 13, 15, 18, 20, 25, 30, 35, 40, 50, 53, 60, 70, 80, 90, 100, 106, 120, 140, 158, 200, 211)
  if ($null -eq $Code -or $Code -eq "") { return $null }
  $idx = [int]$Code
  if ($idx -ge 0 -and $idx -lt $valid.Count) {
    return ("{0:N2}" -f ($valid[$idx] / 100.0))
  }
  return $null
}

function Parse-CtbStyles {
  param([string]$Text)

  $styles = New-Object System.Collections.Generic.List[object]
  $lines = $Text -split "`r?`n"
  $inPlotStyle = $false
  $current = $null

  foreach ($line in $lines) {
    if ($line -match '^\s*plot_style\{') {
      $inPlotStyle = $true
      continue
    }
    if (-not $inPlotStyle) { continue }

    if ($line -match '^\s*(\d+)\{') {
      $current = [ordered]@{
        PlotStyleIndex = [int]$Matches[1]
        ACI = [int]$Matches[1] + 1
      }
      continue
    }

    if ($null -ne $current -and $line -match '^\s*([A-Za-z_]+)=(.*)$') {
      $key = $Matches[1]
      $value = $Matches[2].Trim()
      if ($value.StartsWith('"')) { $value = $value.Substring(1) }
      $current[$key] = $value
      continue
    }

    if ($null -ne $current -and $line -match '^\s*\}') {
      $lwCode = if ($current.Contains("lineweight")) { $current["lineweight"] } else { $null }
      $current["LineweightMm"] = Get-LineweightMm $lwCode
      $styles.Add([pscustomobject]$current)
      $current = $null
    }
  }

  $styles
}

function Parse-TntLayers {
  param([string]$Path)

  $layers = New-Object System.Collections.Generic.List[object]
  $text = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
  $start = $text.IndexOf("(DEFUN TNT:LAYER:STD-TABLE")
  if ($start -lt 0) { $start = $text.IndexOf("(defun TNT:LAYER:STD-TABLE") }
  if ($start -lt 0) { throw "Could not find TNT:LAYER:STD-TABLE in $Path" }
  $end = $text.IndexOf("(DEFUN TNT:LAYER:STD-NAMES", $start)
  if ($end -lt 0) { $end = $text.IndexOf("(defun TNT:LAYER:STD-NAMES", $start) }
  if ($end -lt 0) { throw "Could not find TNT:LAYER:STD-NAMES after TNT:LAYER:STD-TABLE in $Path" }
  $text = $text.Substring($start, $end - $start)
  $pattern = '\("([^"]+)"\s+"([^"]*)"\s+"([^"]*)"\s+"([^"]*)"\s+"([^"]*)"\s+"([^"]*)"\s+"([^"]*)"'
  foreach ($m in [regex]::Matches($text, $pattern)) {
    $layers.Add([pscustomobject]@{
      Layer = $m.Groups[1].Value
      Plot = $m.Groups[2].Value
      ACI = $m.Groups[3].Value
      Linetype = $m.Groups[4].Value
      LayerLineweight = $m.Groups[5].Value
      Transparency = $m.Groups[6].Value
      Description = $m.Groups[7].Value
    })
  }
  $layers
}

function New-SyncRows {
  param($Layers, $CtbStyles)

  $byAci = @{}
  foreach ($style in $CtbStyles) {
    $byAci[[string]$style.ACI] = $style
  }

  foreach ($layer in $Layers) {
    $style = $byAci[[string]$layer.ACI]
    [pscustomobject]@{
      Layer = $layer.Layer
      Description = $layer.Description
      Plot = $layer.Plot
      ACI = $layer.ACI
      Linetype = $layer.Linetype
      LayerLineweight = $layer.LayerLineweight
      Transparency = $layer.Transparency
      CtbName = if ($style) { $style.name } else { "" }
      CtbLineweightCode = if ($style) { $style.lineweight } else { "" }
      CtbLineweightMm = if ($style) { $style.LineweightMm } else { "" }
      CtbScreen = if ($style) { $style.screen } else { "" }
      CtbLinetypeCode = if ($style) { $style.linetype } else { "" }
      CtbColorPolicy = if ($style) { $style.color_policy } else { "" }
    }
  }
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$ctbText = Convert-CtbToText -Path $CtbPath
$ctbStyles = Parse-CtbStyles -Text $ctbText
$layers = Parse-TntLayers -Path $LayerLispPath
$syncRows = New-SyncRows -Layers $layers -CtbStyles $ctbStyles

$rawPath = Join-Path $OutDir "TNT_PLOT_STYLE_2026.raw.txt"
$ctbCsvPath = Join-Path $OutDir "TNT_PLOT_STYLE_2026.ctb.csv"
$layerCsvPath = Join-Path $OutDir "TNT_LAYER_STANDARD.csv"
$syncCsvPath = Join-Path $OutDir "TNT_LAYER_CTB_SYNC.csv"
$summaryPath = Join-Path $OutDir "README_CTB_EXPORT.md"

[IO.File]::WriteAllText($rawPath, $ctbText, [Text.Encoding]::UTF8)
$ctbStyles | Export-Csv -LiteralPath $ctbCsvPath -NoTypeInformation -Encoding UTF8
$layers | Export-Csv -LiteralPath $layerCsvPath -NoTypeInformation -Encoding UTF8
$syncRows | Export-Csv -LiteralPath $syncCsvPath -NoTypeInformation -Encoding UTF8

$usedColorCount = ($layers | Select-Object -ExpandProperty ACI -Unique).Count
$md = @"
# TNT CTB Export

Source CTB: ``$CtbPath``

Generated files:

- `TNT_PLOT_STYLE_2026.raw.txt`: decompressed CTB text for full inspection.
- `TNT_PLOT_STYLE_2026.ctb.csv`: one row per CTB color style.
- `TNT_LAYER_STANDARD.csv`: layer standard parsed from ``$LayerLispPath``.
- `TNT_LAYER_CTB_SYNC.csv`: layer table joined with CTB by ACI color.

Counts:

- CTB styles: $($ctbStyles.Count)
- TNT layers: $($layers.Count)
- TNT layer colors used: $usedColorCount

Notes:

- CTB is color-dependent. Layer synchronization is checked through each layer's ACI color.
- `CtbLineweightCode` is the raw CTB lineweight index.
- `CtbLineweightMm` maps that index to AutoCAD valid lineweight values in mm.
- `CtbColorPolicy`, `CtbLinetypeCode`, and other code columns are kept raw so we do not hide CTB internals behind an uncertain label.
"@
[IO.File]::WriteAllText($summaryPath, $md, [Text.Encoding]::UTF8)

Write-Host "[TNT] CTB raw text: $rawPath"
Write-Host "[TNT] CTB CSV: $ctbCsvPath"
Write-Host "[TNT] Layer CSV: $layerCsvPath"
Write-Host "[TNT] Sync CSV: $syncCsvPath"
Write-Host "[TNT] Summary: $summaryPath"
