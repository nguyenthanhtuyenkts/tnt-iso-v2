param(
  [string]$CtbPath = "..\..\0.RELEASE\TNT_PLOT_STYLE_2026.ctb",
  [string]$LayerLispPath = "..\..\0.RELEASE\TNT_PACKAGE_00_SYSTEM_ALL.lsp",
  [string]$OutDir = ".\OUT_REVIEW",
  [switch]$SkipExcel
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-HerePath {
  param([string]$Path)
  if ([IO.Path]::IsPathRooted($Path)) { return $Path }
  return (Join-Path $PSScriptRoot $Path)
}

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
  if ($offset -lt 0) { throw "Could not find zlib payload in CTB file: $Path" }

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
  $valid = @(0, 5, 9, 13, 15, 18, 20, 25, 30, 35, 40, 50, 53, 60, 70, 80, 90, 100, 106, 120, 140, 158, 200, 211)
  if ($null -eq $Code -or $Code -eq "") { return $null }
  $idx = [int]$Code
  if ($idx -ge 0 -and $idx -lt $valid.Count) { return ("{0:N2}" -f ($valid[$idx] / 100.0)) }
  return $null
}

function Parse-CtbStyles {
  param([string]$Text)

  $styles = New-Object System.Collections.Generic.List[object]
  $lines = $Text -split "`r?`n"
  $inPlotStyle = $false
  $current = $null

  foreach ($line in $lines) {
    if ($line -match '^\s*plot_style\{') { $inPlotStyle = $true; continue }
    if (-not $inPlotStyle) { continue }

    if ($line -match '^\s*(\d+)\{') {
      $current = [ordered]@{ PlotStyleIndex = [int]$Matches[1]; ACI = [int]$Matches[1] + 1 }
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
  foreach ($style in $CtbStyles) { $byAci[[string]$style.ACI] = $style }

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

function New-ExcelWorkbook {
  param(
    [string]$WorkbookPath,
    [hashtable]$Sheets
  )

  $excel = $null
  try {
    $excel = New-Object -ComObject Excel.Application
  } catch {
    Write-Warning "Excel COM is not available. CSV files were created, but XLSX was skipped."
    return $false
  }

  $workbook = $null
  try {
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $workbook = $excel.Workbooks.Add()

    while ($workbook.Worksheets.Count -lt $Sheets.Count) {
      [void]$workbook.Worksheets.Add()
    }
    while ($workbook.Worksheets.Count -gt $Sheets.Count) {
      $workbook.Worksheets.Item($workbook.Worksheets.Count).Delete()
    }

    $sheetIndex = 1
    foreach ($name in $Sheets.Keys) {
      $sheet = $workbook.Worksheets.Item($sheetIndex)
      $sheet.Name = $name
      $rows = @($Sheets[$name])
      if ($rows.Count -gt 0) {
        $props = @($rows[0].PSObject.Properties.Name)
        for ($c = 0; $c -lt $props.Count; $c++) {
          $sheet.Cells.Item(1, $c + 1).Value2 = $props[$c]
        }
        for ($r = 0; $r -lt $rows.Count; $r++) {
          for ($c = 0; $c -lt $props.Count; $c++) {
            $value = $rows[$r].PSObject.Properties[$props[$c]].Value
            $sheet.Cells.Item($r + 2, $c + 1).Value2 = [string]$value
          }
        }
        [void]$sheet.Columns.AutoFit()
        $sheet.Rows.Item(1).Font.Bold = $true
      }
      $sheetIndex++
    }

    $workbook.SaveAs($WorkbookPath, 51)
    return $true
  } catch {
    Write-Warning ("Excel workbook was skipped: " + $_.Exception.Message)
    return $false
  } finally {
    if ($null -ne $workbook) { $workbook.Close($false) | Out-Null }
    if ($null -ne $excel) { $excel.Quit() | Out-Null }
  }
}

$ctb = Resolve-HerePath $CtbPath
$layerLisp = Resolve-HerePath $LayerLispPath
$out = Resolve-HerePath $OutDir
New-Item -ItemType Directory -Force -Path $out | Out-Null

$ctbText = Convert-CtbToText -Path $ctb
$ctbStyles = Parse-CtbStyles -Text $ctbText
$layers = Parse-TntLayers -Path $layerLisp
$syncRows = @(New-SyncRows -Layers $layers -CtbStyles $ctbStyles)

$rawPath = Join-Path $out "TNT_PLOT_STYLE_2026.raw.txt"
$ctbCsvPath = Join-Path $out "CTB_255_Colors.csv"
$layerCsvPath = Join-Path $out "Layer_Standard.csv"
$syncCsvPath = Join-Path $out "Layer_CTB_Sync.csv"
$notesCsvPath = Join-Path $out "Notes.csv"
$xlsxPath = Join-Path $out "TNT_CTB_REVIEW.xlsx"

[IO.File]::WriteAllText($rawPath, $ctbText, [Text.Encoding]::UTF8)
$ctbStyles | Export-Csv -LiteralPath $ctbCsvPath -NoTypeInformation -Encoding UTF8
$layers | Export-Csv -LiteralPath $layerCsvPath -NoTypeInformation -Encoding UTF8
$syncRows | Export-Csv -LiteralPath $syncCsvPath -NoTypeInformation -Encoding UTF8

$notes = @(
  [pscustomobject]@{ Topic = "Edit source"; Detail = "Edit CTB_255_Colors, not Layer_CTB_Sync, when generating a new CTB." }
  [pscustomobject]@{ Topic = "CTB scope"; Detail = "CTB is color-dependent. One ACI color change affects every layer using that ACI." }
  [pscustomobject]@{ Topic = "Do not overwrite"; Detail = "Build scripts write a new CTB file. Keep the original CTB untouched." }
  [pscustomobject]@{ Topic = "Lineweight"; Detail = "Use lineweight code from CTB_255_Colors. LineweightMm is a readable helper." }
)
$notes | Export-Csv -LiteralPath $notesCsvPath -NoTypeInformation -Encoding UTF8

$excelCreated = $false
if (-not $SkipExcel) {
  $orderedSheets = [ordered]@{
    "Layer_CTB_Sync" = $syncRows
    "CTB_255_Colors" = $ctbStyles
    "Layer_Standard" = $layers
    "Notes" = $notes
  }
  $excelCreated = New-ExcelWorkbook -WorkbookPath $xlsxPath -Sheets $orderedSheets
}

Write-Host "[TNT] Raw CTB text: $rawPath"
Write-Host "[TNT] CTB edit CSV: $ctbCsvPath"
Write-Host "[TNT] Layer sync CSV: $syncCsvPath"
if ($excelCreated) {
  Write-Host "[TNT] Excel workbook: $xlsxPath"
} else {
  Write-Host "[TNT] Excel workbook: skipped; use CSV files or rerun on a machine where Excel COM can create workbooks."
}
