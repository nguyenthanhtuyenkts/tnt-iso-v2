param(
  [string]$MappingFile = "",
  [string]$LispFile = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($MappingFile)) {
  $MappingFile = Join-Path $scriptDir "TNT_LAYER_SYNC_ALL_MAPPING.xls"
}
if ([string]::IsNullOrWhiteSpace($LispFile)) {
  $LispFile = Join-Path $scriptDir "TNT_LAYER_SYNC_ALL.lsp"
}

function Get-CellText {
  param([xml]$Xml, $Cell)

  $ns = New-Object System.Xml.XmlNamespaceManager($Xml.NameTable)
  $ns.AddNamespace("ss", "urn:schemas-microsoft-com:office:spreadsheet")

  $data = $Cell.SelectSingleNode("ss:Data", $ns)
  if ($null -eq $data) {
    return ""
  }
  return ([string]$data.InnerText).Trim()
}

function Read-XmlSpreadsheetRows {
  param([string]$Path)

  [xml]$xml = Get-Content -Raw -LiteralPath $Path
  $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
  $ns.AddNamespace("ss", "urn:schemas-microsoft-com:office:spreadsheet")

  $rows = @()
  foreach ($row in $xml.SelectNodes("//ss:Worksheet[1]/ss:Table/ss:Row", $ns)) {
    $values = New-Object System.Collections.Generic.List[string]
    $colIndex = 1
    foreach ($cell in $row.SelectNodes("ss:Cell", $ns)) {
      $indexAttr = $cell.Attributes.GetNamedItem("Index", "urn:schemas-microsoft-com:office:spreadsheet")
      if ($null -ne $indexAttr) {
        while ($colIndex -lt [int]$indexAttr.Value) {
          $values.Add("")
          $colIndex++
        }
      }
      $values.Add((Get-CellText -Xml $xml -Cell $cell))
      $colIndex++
    }
    if (($values | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
      $rows += ,@($values.ToArray())
    }
  }
  return $rows
}

function Read-ExcelComRows {
  param([string]$Path)

  $excel = $null
  $book = $null
  try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $book = $excel.Workbooks.Open((Resolve-Path -LiteralPath $Path).Path)
    $sheet = $book.Worksheets.Item(1)
    $range = $sheet.UsedRange
    $rows = @()
    for ($r = 1; $r -le $range.Rows.Count; $r++) {
      $values = @()
      for ($c = 1; $c -le $range.Columns.Count; $c++) {
        $value = $range.Cells.Item($r, $c).Text
        $values += ([string]$value).Trim()
      }
      if (($values | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
        $rows += ,@($values)
      }
    }
    return $rows
  }
  finally {
    if ($book) { $book.Close($false) | Out-Null }
    if ($excel) { $excel.Quit() | Out-Null }
    foreach ($obj in @($range, $sheet, $book, $excel)) {
      if ($obj) { [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($obj) }
    }
  }
}

function Read-MappingRows {
  param([string]$Path)

  $first = Get-Content -LiteralPath $Path -TotalCount 1
  if ($first -match '^\s*<\?xml') {
    return Read-XmlSpreadsheetRows -Path $Path
  }
  return Read-ExcelComRows -Path $Path
}

function Normalize-Header {
  param([string]$Text)

  $value = $Text.Trim().ToLowerInvariant()
  $value = $value -replace '\s+', ' '
  return $value
}

function Get-MappingPairs {
  param($Rows)

  if ($Rows.Count -eq 0) {
    throw "Mapping file has no rows."
  }

  $oldIndex = 1
  $newIndex = 0
  $startRow = 0
  $header = @($Rows[0] | ForEach-Object { Normalize-Header $_ })

  for ($i = 0; $i -lt $header.Count; $i++) {
    if ($header[$i] -match '^(layer cu|old layer|oldlayer|old)$') {
      $oldIndex = $i
      $startRow = 1
    }
    if ($header[$i] -match '^(layer moi|new layer|newlayer|new)$') {
      $newIndex = $i
      $startRow = 1
    }
  }

  $pairs = New-Object System.Collections.Generic.List[object]
  for ($r = $startRow; $r -lt $Rows.Count; $r++) {
    $row = $Rows[$r]
    $old = ""
    $new = ""
    if ($oldIndex -lt $row.Count) { $old = ([string]$row[$oldIndex]).Trim() }
    if ($newIndex -lt $row.Count) { $new = ([string]$row[$newIndex]).Trim() }

    if ([string]::IsNullOrWhiteSpace($old) -and [string]::IsNullOrWhiteSpace($new)) {
      continue
    }
    if ([string]::IsNullOrWhiteSpace($old) -or [string]::IsNullOrWhiteSpace($new)) {
      throw "Invalid mapping at Excel row $($r + 1): both old layer and new layer are required."
    }
    $pairs.Add([pscustomobject]@{ OldLayer = $old; NewLayer = $new })
  }

  if ($pairs.Count -eq 0) {
    throw "No mapping rows found."
  }
  return $pairs
}

function Escape-LispString {
  param([string]$Text)

  return ($Text -replace '\\', '\\' -replace '"', '\"')
}

function Build-MapGroupsLisp {
  param($Pairs)

  $newLayerOrder = New-Object System.Collections.Generic.List[string]
  $groups = [ordered]@{}

  foreach ($pair in $Pairs) {
    if (-not $groups.Contains($pair.NewLayer)) {
      $groups[$pair.NewLayer] = New-Object System.Collections.Generic.List[string]
      $newLayerOrder.Add($pair.NewLayer)
    }
    if (-not $groups[$pair.NewLayer].Contains($pair.OldLayer)) {
      $groups[$pair.NewLayer].Add($pair.OldLayer)
    }
  }

  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("(defun TNT:LAYER-SYNC:MAP-GROUPS (/)")
  $lines.Add("  '(")

  foreach ($newLayer in $newLayerOrder) {
    $oldLayers = $groups[$newLayer]
    $lines.Add(("    ;; {0}" -f (Escape-LispString $newLayer)))
    $lines.Add(('    ("{0}"' -f (Escape-LispString $newLayer)))
    for ($i = 0; $i -lt $oldLayers.Count; $i++) {
      $prefix = "      ("
      if ($i -gt 0) { $prefix = "       " }
      $suffix = ""
      if ($i -eq ($oldLayers.Count - 1)) { $suffix = ")" }
      $lines.Add(('{0}"{1}"{2}' -f $prefix, (Escape-LispString $oldLayers[$i]), $suffix))
    }
    $lines.Add("    )")
  }

  $lines.Add("  )")
  $lines.Add(")")
  return ($lines -join "`r`n")
}

if (-not (Test-Path -LiteralPath $MappingFile)) {
  throw "Mapping file not found: $MappingFile"
}
if (-not (Test-Path -LiteralPath $LispFile)) {
  throw "Lisp file not found: $LispFile"
}

Write-Host "[TNT] REAL UPDATE MODE"
Write-Host "[TNT] Mapping file:" $MappingFile
Write-Host "[TNT] Target Lisp:" $LispFile

$rows = Read-MappingRows -Path $MappingFile
$pairs = Get-MappingPairs -Rows $rows
$newBlock = Build-MapGroupsLisp -Pairs $pairs

$lispText = Get-Content -Raw -LiteralPath $LispFile
$pattern = '(?s)\(defun\s+TNT:LAYER-SYNC:MAP-GROUPS\s+\(/.*?\r?\n\)\r?\n\r?\n\(defun\s+TNT:LAYER-SYNC:MAP\s+\('
if ($lispText -notmatch $pattern) {
  throw "Cannot find TNT:LAYER-SYNC:MAP-GROUPS block in Lisp file."
}

$backup = "{0}.bak_{1}" -f $LispFile, (Get-Date -Format "yyyyMMdd_HHmmss")
Copy-Item -LiteralPath $LispFile -Destination $backup

$replacement = $newBlock + "`r`n`r`n(defun TNT:LAYER-SYNC:MAP ("
$updated = [regex]::Replace($lispText, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
[System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $LispFile).Path, $updated, [System.Text.Encoding]::ASCII)

Write-Host "[TNT] Updated mapping rows:" $pairs.Count
Write-Host "[TNT] Lisp file:" $LispFile
Write-Host "[TNT] Backup file:" $backup
