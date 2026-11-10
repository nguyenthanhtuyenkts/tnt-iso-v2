param(
  [switch]$Export,
  [switch]$Check,
  [string]$Workbook = (Join-Path $PSScriptRoot 'TNT_SYSTEM_LAYERS.xlsx'),
  [string]$LispFile = (Join-Path (Split-Path $PSScriptRoot -Parent) 'TNT_PACKAGE_00_SYSTEM_ALL.lsp')
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
$utf8 = New-Object Text.UTF8Encoding($false, $true)
$source = [IO.File]::ReadAllText($LispFile, $utf8)
$stdPattern = '(?is)\(DEFUN TNT:LAYER:STD-TABLE \(/\).*?(?=\(DEFUN TNT:LAYER:STD-NAMES)'
$excludePattern = '(?is)\(DEFUN TNT:LAYER:STD-EXCLUDE-TABLE \(/\).*?(?=\(DEFUN TNT:LAYER:STD-EXCLUDE-NAMES)'
$std = [regex]::Match($source, $stdPattern)
$exclude = [regex]::Match($source, $excludePattern)
if (-not $std.Success -or -not $exclude.Success) { throw 'Cannot locate system layer tables.' }
function Decode-Lisp([string]$s) {
  return [regex]::Replace($s, '\\([\\"])', {param($m) $m.Groups[1].Value})
}
function Quote-Lisp([string]$s) {
  return '"' + $s.Replace('\','\\').Replace('"','\"') + '"'
}
function Xml-Text([string]$s) { return [Security.SecurityElement]::Escape($s) }
function Put-Zip($zip, [string]$name, [string]$value) {
  $entry = $zip.CreateEntry($name)
  $writer = New-Object IO.StreamWriter($entry.Open(), $utf8)
  try { $writer.Write($value) } finally { $writer.Dispose() }
}
function Sheet-Xml($rows, [string]$widths, [switch]$Filter) {
  $b = New-Object Text.StringBuilder
  [void]$b.Append('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews><cols>')
  $col = 0
  foreach ($width in $widths.Split(',')) { $col++; [void]$b.Append('<col min="'+$col+'" max="'+$col+'" width="'+$width+'" customWidth="1"/>') }
  [void]$b.Append('</cols><sheetData>')
  $r = 0
  foreach ($row in $rows) {
    $r++; [void]$b.Append('<row r="'+$r+'">'); $c = 0
    foreach ($value in $row) {
      $c++; $letter = [char](64+$c); $style = if ($r -eq 1) {1} else {0}
      [void]$b.Append('<c r="'+$letter+$r+'" t="inlineStr" s="'+$style+'"><is><t xml:space="preserve">'+(Xml-Text ([string]$value))+'</t></is></c>')
    }
    [void]$b.Append('</row>')
  }
  [void]$b.Append('</sheetData>')
  if ($Filter) { [void]$b.Append('<autoFilter ref="A1:'+([char](64+$rows[0].Count))+$r+'"/>') }
  [void]$b.Append('</worksheet>')
  return $b.ToString()
}
function Read-ZipXml($zip, [string]$name) {
  $entry = $zip.GetEntry($name)
  if (-not $entry) { throw "Workbook is missing $name" }
  $reader = New-Object IO.StreamReader($entry.Open())
  try { return [xml]$reader.ReadToEnd() } finally { $reader.Dispose() }
}
function Read-Sheet($zip, [string]$sheetName) {
  $book = Read-ZipXml $zip 'xl/workbook.xml'
  $rels = Read-ZipXml $zip 'xl/_rels/workbook.xml.rels'
  $sheet = @($book.workbook.sheets.sheet | Where-Object { $_.name -ceq $sheetName })
  if ($sheet.Count -ne 1) { throw "Missing sheet: $sheetName" }
  $id = $sheet[0].GetAttribute('id','http://schemas.openxmlformats.org/officeDocument/2006/relationships')
  $rel = $rels.Relationships.Relationship | Where-Object { $_.Id -eq $id }
  $target = [string]$rel.Target
  if ($target.StartsWith('/')) { $path = $target.TrimStart('/') } else { $path = 'xl/' + $target }
  $xml = Read-ZipXml $zip $path
  $shared = @()
  if ($zip.GetEntry('xl/sharedStrings.xml')) {
    $sx = Read-ZipXml $zip 'xl/sharedStrings.xml'
    foreach ($si in $sx.sst.si) { $shared += $si.InnerText }
  }
  $rows = New-Object 'Collections.Generic.List[object]'
  foreach ($row in $xml.worksheet.sheetData.row) {
    $values = @('','','','','','','','','','','')
    foreach ($cell in $row.c) {
      $letters = ([string]$cell.r) -replace '\d',''; $index = 0
      foreach ($ch in $letters.ToCharArray()) { $index = $index*26 + [int]$ch - 64 }
      if ($index -gt 11) { throw "Unexpected column $letters in $sheetName" }
      if ($cell.f) { throw "Formulas are not supported: $sheetName!$($cell.r). Paste values instead." }
      $value = if ($cell.t -eq 's') { $shared[[int]$cell.v] } elseif ($cell.t -eq 'inlineStr') { $cell.is.InnerText } else { [string]$cell.v }
      $values[$index-1] = [string]$value
    }
    if (($values -join '').Trim()) { $rows.Add([pscustomobject]@{ Number=[int]$row.r; Values=$values }) }
  }
  return ,$rows
}
$defaultsPattern = '\(TNT:SYSTEM_SETTING\s+"(DIMLAYER|HPLAYER|TEXTLAYER|MLEADERLAYER)"\s+"([^"\r\n]*)"\)'
$defaults = @([regex]::Matches($source, $defaultsPattern))
. (Join-Path $PSScriptRoot 'TNT_SYSTEM_LAYERS_HISTORY.ps1')
$history = Get-LayerHistory
if ($Export) {
  if (Test-Path -LiteralPath $Workbook) { throw 'Workbook already exists. Rename it before exporting to avoid losing edits.' }
  $excluded = @{}
  foreach ($line in ($exclude.Value -split '\r?\n')) {
    if ($line -match '^\s*\("((?:\\.|[^"\\])*)"') { $excluded[(Decode-Lisp $Matches[1])] = $true }
  }
  $rows = New-Object 'Collections.Generic.List[object]'
  $rows.Add(@('Layer','Plot','ColorACI','Linetype','LineweightMM','Transparency','Description','ExcludeByLayer'))
  foreach ($line in ($std.Value -split '\r?\n')) {
    if ($line -notmatch '^\s*\("') { continue }
    $fields = @([regex]::Matches($line,'"((?:\\.|[^"\\])*)"') | ForEach-Object { Decode-Lisp $_.Groups[1].Value })
    if ($fields.Count -ne 7) { throw "Unexpected layer row: $line" }
    $fields += $(if ($excluded.ContainsKey($fields[0])) {'Y'} else {'N'})
    $rows.Add($fields)
  }
  $dr = New-Object 'Collections.Generic.List[object]'
  $dr.Add(@('Variable','Layer'))
  foreach ($m in $defaults) { $dr.Add(@($m.Groups[1].Value,(Decode-Lisp $m.Groups[2].Value))) }
  $guide = New-Object 'Collections.Generic.List[object]'
  $guide.Add(@('Muc','Huong dan'))
  $guide.Add(@('Nguon','TNT_PACKAGE_00_SYSTEM_ALL.lsp: STD-TABLE, STD-EXCLUDE-TABLE va cac layer mac dinh.'))
  $guide.Add(@('Cap nhat','Luu va dong Excel, chay TNT_UPDATE_SYSTEM_LAYERS.cmd. Lisp duoc sao luu truoc khi ghi.'))
  $guide.Add(@('Layers','Sua/them/xoa dong du lieu; giu nguyen ten sheet va hang tieu de. Thu tu dong la thu tu trong Lisp.'))
  $guide.Add(@('Plot','P = duoc in; N = khong in.'))
  $guide.Add(@('ColorACI','So nguyen 1..255; khong dung TrueColor/RGB.'))
  $guide.Add(@('Linetype','Ten kieu net; phai co trong ban ve hoac tep LIN ma package CREATE nap duoc.'))
  $guide.Add(@('LineweightMM','So mm, dung dau cham. Rong/0 = ByLayer theo code hien tai; CREATE lam tron ve muc ho tro (0..1 mm).'))
  $guide.Add(@('Transparency','So nguyen 0..90; rong = 0.'))
  $guide.Add(@('Description','Mo ta ho tro tieng Viet. Ban AutoCAD 2014 tu dong bo dau mo ta.'))
  $guide.Add(@('ExcludeByLayer','Y = mien ep ByLayer trong package LAYER; N = ap dung binh thuong.'))
  $guide.Add(@('Defaults','Sua layer mac dinh cua DIMLAYER/HPLAYER/TEXTLAYER/MLEADERLAYER; phai co trong sheet Layers.'))
  $guide.Add(@('Doi ten layer','Chi cap nhat package SYSTEM. Cac tham chieu trong SHORTCUT, mapping va package khac can doi rieng. Khong tu doi ten layer trong DWG.'))
  $guide.Add(@('Sau cap nhat','APPLOAD lai package SYSTEM, nap package CREATE, go (TNT_LAYER_CREATE) kem dau ngoac. Go TNT_SETTING de ap dung layer mac dinh. Khong tu sua ban ve dang mo.'))
  $guide.Add(@('AutoCAD 2014','Chay cong cu tu 0.RELEASE. Ban 2014 duoc sinh bang script sync; bien khong ho tro duoc xu ly tai script nay.'))
  $zip = [IO.Compression.ZipFile]::Open($Workbook,[IO.Compression.ZipArchiveMode]::Create)
  try {
    Put-Zip $zip '[Content_Types].xml' '<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/><Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/><Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/><Override PartName="/xl/worksheets/sheet3.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/></Types>'
    Put-Zip $zip '_rels/.rels' '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>'
    Put-Zip $zip 'xl/workbook.xml' '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Layers" sheetId="1" r:id="rId1"/><sheet name="Defaults" sheetId="2" r:id="rId2"/><sheet name="Guide" sheetId="3" r:id="rId3"/></sheets></workbook>'
    Put-Zip $zip 'xl/_rels/workbook.xml.rels' '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/><Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet3.xml"/><Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>'
    Put-Zip $zip 'xl/styles.xml' '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font></fonts><fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF17365D"/><bgColor indexed="64"/></patternFill></fill></fills><borders count="1"><border/></borders><cellStyleXfs count="1"><xf/></cellStyleXfs><cellXfs count="2"><xf numFmtId="49" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/><xf fontId="1" fillId="2" borderId="0" xfId="0" applyFill="1" applyFont="1"/></cellXfs><cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles></styleSheet>'
    Put-Zip $zip 'xl/worksheets/sheet1.xml' (Sheet-Xml $rows '43,10,12,23,18,16,42,19' -Filter)
    Put-Zip $zip 'xl/worksheets/sheet2.xml' (Sheet-Xml $dr '24,44' -Filter)
    Put-Zip $zip 'xl/worksheets/sheet3.xml' (Sheet-Xml $guide '24,125')
  } finally { $zip.Dispose() }
  [IO.File]::WriteAllBytes($Workbook,(New-HistoryWorkbook ([IO.File]::ReadAllBytes($Workbook)) $history))
  Write-Output "Exported $($rows.Count-1) layers: $Workbook"
  exit 0
}
$zip = [IO.Compression.ZipFile]::OpenRead($Workbook)
try { $layers = Read-Sheet $zip 'Layers'; $defaultRows = Read-Sheet $zip 'Defaults' } finally { $zip.Dispose() }
$header = 'Layer|Plot|ColorACI|Linetype|LineweightMM|Transparency|Description|ExcludeByLayer'
if (($layers[0].Values[0..7] -join '|') -cne $header) { throw 'Invalid Layers header.' }
if (($layers[0].Values[8..10] -join '|') -notin @('||','LayerID|Status|ReplacementID')) { throw 'Invalid history columns.' }
$records = New-Object 'Collections.Generic.List[object]'
if (($defaultRows[0].Values[0..1] -join '|') -cne 'Variable|Layer') { throw 'Invalid Defaults header.' }
$names = @{}; $lines = New-Object 'Collections.Generic.List[string]'; $exlines = New-Object 'Collections.Generic.List[string]'
foreach ($row in @($layers | Select-Object -Skip 1)) {
  $v = $row.Values; $where = "Layers row $($row.Number)"
  for ($i=0;$i -lt 8;$i++) { if ($i -ne 6) { $v[$i] = $v[$i].Trim() } }
  if (-not $v[0] -or $v[0].Length -gt 255 -or $v[0] -match '[<>/\\":;?*|=\x00-\x1F]' -or $v[0] -match '[^\x20-\x7E]') { throw "$where : invalid/non-ASCII layer name (review legacy drawing identifiers)." }
  if ($v[0] -in @('0','Defpoints')) { throw "$where : reserved AutoCAD layer cannot be managed by history." }
  if ($names.ContainsKey($v[0])) { throw "$where : duplicate layer $($v[0])" }; $names[$v[0]]=$true
  $v[1]=$v[1].ToUpperInvariant(); $v[7]=$v[7].ToUpperInvariant()
  if ($v[1] -notin @('P','N') -or $v[7] -notin @('Y','N')) { throw "$where : Plot requires P/N; ExcludeByLayer requires Y/N." }
  if ($v[2] -notmatch '^\d+$' -or [int]$v[2] -lt 1 -or [int]$v[2] -gt 255) { throw "$where : ColorACI must be 1..255." }
  if (-not $v[3] -or $v[3] -match '[<>/\\":;?*|=\x00-\x1F]' -or $v[3] -match '[^\x20-\x7E]') { throw "$where : invalid linetype." }
  if ($v[4] -and ($v[4] -notmatch '^\d+(\.\d+)?$' -or [double]::Parse($v[4],[Globalization.CultureInfo]::InvariantCulture) -gt 1)) { throw "$where : LineweightMM requires 0..1 with decimal point." }
  if ($v[5] -and ($v[5] -notmatch '^\d+$' -or [int]$v[5] -gt 90)) { throw "$where : Transparency requires integer 0..90." }
  if ($v[6] -match '[\x00-\x1F]') { throw "$where : Description must be a single line." }
  $record = New-LayerRecord $v $history $records
  $records.Add($record)
  if ($record.Status -eq 'ACTIVE') {
    $lines.Add('    (' + (($v[0..6] | ForEach-Object { Quote-Lisp $_ }) -join ' ') + ')')
    if ($v[7] -eq 'Y') { $exlines.Add('    ('+(Quote-Lisp $v[0])+')') }
  }
}
if ($names.Count -eq 0) { throw 'Layer table is empty.' }
Test-LayerHistory $records $history
$updates = @{}
foreach ($row in @($defaultRows | Select-Object -Skip 1)) {
  $key=$row.Values[0].Trim().ToUpperInvariant(); $name=$row.Values[1].Trim()
  if ($key -notin @('DIMLAYER','HPLAYER','TEXTLAYER','MLEADERLAYER') -or $updates.ContainsKey($key)) { throw "Invalid/duplicate default variable: $key" }
  $name = Resolve-DefaultLayer $name $records $history
  $updates[$key]=$name
}
if ($updates.Count -ne 4 -or $defaults.Count -ne 4) { throw 'Exactly four default layer settings are required.' }
$newStd = "(DEFUN TNT:LAYER:STD-TABLE (/)`r`n  '(`r`n" + ($lines -join "`r`n") + "`r`n  ))`r`n"
$newEx = "(DEFUN TNT:LAYER:STD-EXCLUDE-TABLE (/)`r`n  '(`r`n" + ($exlines -join "`r`n") + "`r`n  ))`r`n"
$updated = Update-LayerReferences $source $records $history
$updated = [regex]::Replace($updated,$stdPattern,[Text.RegularExpressions.MatchEvaluator]{param($m) $newStd},1)
$updated = [regex]::Replace($updated,$excludePattern,[Text.RegularExpressions.MatchEvaluator]{param($m) $newEx},1)
$updated = [regex]::Replace($updated,$defaultsPattern,[Text.RegularExpressions.MatchEvaluator]{param($m) '(TNT:SYSTEM_SETTING '+(Quote-Lisp $m.Groups[1].Value)+' '+(Quote-Lisp $updates[$m.Groups[1].Value])+')'})
Write-Output "Validated $($names.Count) layers, $($exlines.Count) exclusions and 4 defaults."
if ($Check) {
  $null=Get-LayerReferenceUpdates $records $history (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)
  Write-Output 'Check only: no files changed.'; exit 0
}
$root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$sync = Join-Path $root '1.WORK/TNT_Sync_Release14.ps1'
$canonical = Join-Path $root '0.RELEASE/TNT_PACKAGE_00_SYSTEM_ALL.lsp'
if ([IO.Path]::GetFullPath($LispFile) -ine [IO.Path]::GetFullPath($canonical) -or -not (Test-Path -LiteralPath $sync)) {
  throw 'Update must run from 0.RELEASE with canonical Lisp and the Release14 sync script present. Use -Check for other copies.'
}
$backupDir = Join-Path $root '1.WORK/SYSTEM_LAYER_BACKUPS'
[void][IO.Directory]::CreateDirectory($backupDir)
Publish-LayerHistory $records $history $updates $updated $root $sync $backupDir
