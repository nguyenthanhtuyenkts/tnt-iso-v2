param([string]$Fixture)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
if (-not $Fixture) { $Fixture=(Get-Content (Join-Path $PSScriptRoot 'HISTORY_TEST_PATH.txt') -Raw).Trim() }
$support=Join-Path $Fixture '0.RELEASE/TNT_SUPPORT_LISP'
$workbook=Join-Path $support 'TNT_SYSTEM_LAYERS.xlsx'
$updater=Join-Path $support 'TNT_SYSTEM_LAYERS.ps1'
$historyPath=Join-Path $support 'TNT_SYSTEM_LAYERS_HISTORY.json'
function Read-TestHistory { return [IO.File]::ReadAllText($historyPath) | ConvertFrom-Json }
function Assert($flag,[string]$label) { if (-not $flag) { throw "FAIL: $label" }; Write-Output "PASS: $label" }
function Edit-Workbook($edits) {
  $ins=New-Object IO.MemoryStream(,[IO.File]::ReadAllBytes($workbook))
  $iz=New-Object IO.Compression.ZipArchive($ins,[IO.Compression.ZipArchiveMode]::Read)
  $outs=New-Object IO.MemoryStream
  $oz=New-Object IO.Compression.ZipArchive($outs,[IO.Compression.ZipArchiveMode]::Create,$true)
  try {
    foreach ($entry in $iz.Entries) {
      $r=New-Object IO.StreamReader($entry.Open()); try { $body=$r.ReadToEnd() } finally { $r.Dispose() }
      if ($entry.FullName -eq 'xl/worksheets/sheet1.xml') {
        [xml]$xml=$body; $ns=New-Object Xml.XmlNamespaceManager($xml.NameTable); $ns.AddNamespace('s','http://schemas.openxmlformats.org/spreadsheetml/2006/main')
        foreach ($key in $edits.Keys) {
          $cell=$xml.SelectSingleNode('//s:c[@r="'+$key+'"]',$ns)
          $cell.SetAttribute('t','inlineStr')
          $cell.InnerXml='<is xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><t>'+[Security.SecurityElement]::Escape($edits[$key])+'</t></is>'
        }
        $body=$xml.OuterXml
      }
      $e=$oz.CreateEntry($entry.FullName); $w=New-Object IO.StreamWriter($e.Open()); try {$w.Write($body)} finally {$w.Dispose()}
    }
  } finally { $oz.Dispose(); $iz.Dispose(); $ins.Dispose() }
  [IO.File]::WriteAllBytes($workbook,$outs.ToArray()); $outs.Dispose()
}
function Apply-Workbook([switch]$Reject) {
  $before=(Get-FileHash -LiteralPath $historyPath).Hash
  $ErrorActionPreference='Continue'
  $out=& powershell -NoProfile -ExecutionPolicy Bypass -File $updater 2>&1
  $status=$LASTEXITCODE
  $ErrorActionPreference='Stop'
  if ($Reject) {
    Assert ($status -ne 0) 'invalid change rejected'
    Assert ((Get-FileHash -LiteralPath $historyPath).Hash -eq $before) 'history unchanged after rejection'
  } elseif ($status -ne 0) { throw ($out -join "`n") }
}
$h=Read-TestHistory
Assert ($h.Revision -eq 0 -and $h.Current.Count -eq 52) '52 stable baseline IDs'
$toilet=@($h.Current | Where-Object {$_.Name -eq '....41_TNT_P_DRAIN-TOILET'})[0]
$rain=@($h.Current | Where-Object {$_.Name -eq '....42_TNT_P_DRAIN-RAIN'})[0]
$row=[array]::IndexOf(@($h.Current.ID),$toilet.ID)+2
$rainRow=[array]::IndexOf(@($h.Current.ID),$rain.ID)+2
$reference=Join-Path $Fixture '0.RELEASE/TNT_TEST_REFERENCE.lsp'
[IO.File]::WriteAllText($reference,'(setq test-layer "....41_TNT_P_DRAIN-TOILET" untouched "prefix....41_TNT_P_DRAIN-TOILET")')
Edit-Workbook @{('A'+$row)='TNT_TEST_TOILET_B'}
Apply-Workbook
$h=Read-TestHistory
Assert ($h.Revision -eq 1) 'rename increments revision'
Assert ((@($h.Current | Where-Object {$_.ID -eq $toilet.ID}))[0].Name -eq 'TNT_TEST_TOILET_B') 'rename keeps ID'
$ref=[IO.File]::ReadAllText($reference)
Assert ($ref.Contains('"TNT_TEST_TOILET_B"') -and $ref.Contains('"prefix....41_TNT_P_DRAIN-TOILET"')) 'exact package references updated'
Apply-Workbook
Assert ((Read-TestHistory).Revision -eq 1) 'no-op does not create another revision'
Edit-Workbook @{('A'+$row)='TNT_TEST_TOILET_C'; ('C'+$row)='3'}
Apply-Workbook
$h=Read-TestHistory; $record=@($h.Current | Where-Object {$_.ID -eq $toilet.ID})[0]
Assert ($h.Revision -eq 2 -and $record.Aliases.Count -eq 3) 'rename chain and property snapshots retained'
$system=[IO.File]::ReadAllText((Join-Path $Fixture '0.RELEASE/TNT_PACKAGE_00_SYSTEM_ALL.lsp'))
Assert ($system.Contains('("....41_TNT_P_DRAIN-TOILET" "TNT_TEST_TOILET_C")') -and $system.Contains('("TNT_TEST_TOILET_B" "TNT_TEST_TOILET_C")')) 'history flattened to latest destination'
$saved=[IO.File]::ReadAllBytes($workbook)
Edit-Workbook @{('A'+$rainRow)='....41_TNT_P_DRAIN-TOILET'}
Apply-Workbook -Reject
[IO.File]::WriteAllBytes($workbook,$saved)
Edit-Workbook @{('J'+$row)='RETIRED'; ('K'+$row)=$rain.ID; ('J'+$rainRow)='RETIRED'; ('K'+$rainRow)=$toilet.ID}
Apply-Workbook -Reject
[IO.File]::WriteAllBytes($workbook,$saved)
Edit-Workbook @{('J'+$row)='RETIRED'; ('K'+$row)=$rain.ID}
Apply-Workbook
$h=Read-TestHistory
Assert ($h.Revision -eq 3) 'explicit retirement with replacement accepted'
$system=[IO.File]::ReadAllText((Join-Path $Fixture '0.RELEASE/TNT_PACKAGE_00_SYSTEM_ALL.lsp'))
Assert ($system.Contains('("....41_TNT_P_DRAIN-TOILET" "....42_TNT_P_DRAIN-RAIN")')) 'retired aliases resolve to replacement'
$saved=[IO.File]::ReadAllBytes($workbook)
$blank=@{}; foreach ($column in 'ABCDEFGHIJK'.ToCharArray()) { $blank[([string]$column+$row)]='' }
Edit-Workbook $blank
Apply-Workbook -Reject
[IO.File]::WriteAllBytes($workbook,$saved)
Edit-Workbook @{'J2'='RETIRED'}
Apply-Workbook
Assert ((Read-TestHistory).Revision -eq 4) 'unreferenced layer may retire without replacement'
$mappingFile=Join-Path $Fixture 'legacy_mapping.xls'
[IO.File]::WriteAllText($mappingFile,'<?xml version="1.0"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"><Worksheet ss:Name="Mapping"><Table><Row><Cell><Data ss:Type="String">Layer moi</Data></Cell><Cell><Data ss:Type="String">Layer cu</Data></Cell></Row><Row><Cell><Data ss:Type="String">....41_TNT_P_DRAIN-TOILET</Data></Cell><Cell><Data ss:Type="String">EXTERNAL_TOILET_OLD</Data></Cell></Row></Table></Worksheet></Workbook>')
$output=& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $support 'TNT_UPDATE_LAYER_SYNC_ALL_MAPPING.ps1') -MappingFile $mappingFile 2>&1
if ($LASTEXITCODE -ne 0) { throw ($output -join "`n") }
$mapping=[IO.File]::ReadAllText((Join-Path $support 'TNT_LAYER_SYNC_ALL.lsp'))
Assert ($mapping.Contains('("....42_TNT_P_DRAIN-RAIN"') -and $mapping.Contains('"EXTERNAL_TOILET_OLD"')) 'legacy mapping updater resolves historical destinations'
Write-Output 'ALL HISTORY TESTS PASSED'
