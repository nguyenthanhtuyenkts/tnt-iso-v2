function Get-LayerHistory {
  $path = Join-Path $PSScriptRoot 'TNT_SYSTEM_LAYERS_HISTORY.json'
  if (Test-Path -LiteralPath $path) {
    $h = [IO.File]::ReadAllText($path,$utf8) | ConvertFrom-Json
    if ($h.Schema -ne 1) { throw 'Unsupported history schema.' }
    return $h
  }
  $excluded = @{}
  foreach ($line in ($exclude.Value -split '\r?\n')) {
    if ($line -match '^\s*\("((?:\\.|[^"\\])*)"') { $excluded[(Decode-Lisp $Matches[1])]=$true }
  }
  $items = @(); $n = 0
  foreach ($line in ($std.Value -split '\r?\n')) {
    if ($line -notmatch '^\s*\("') { continue }
    $v = @([regex]::Matches($line,'"((?:\\.|[^"\\])*)"') | ForEach-Object { Decode-Lisp $_.Groups[1].Value })
    if ($v.Count -ne 7) { throw 'Invalid baseline table.' }
    $v += $(if ($excluded.ContainsKey($v[0])) {'Y'} else {'N'}); $n++
    $items += [pscustomobject]@{ ID=('TNT-L{0:D4}' -f $n); Name=$v[0]; Values=$v; Status='ACTIVE'; ReplacementID=''; Aliases=@($v[0]) }
  }
  $d = [ordered]@{}
  foreach ($m in $defaults) { $d[$m.Groups[1].Value]=Decode-Lisp $m.Groups[2].Value }
  return [pscustomobject]@{ Schema=1; Revision=0; Current=$items; Defaults=[pscustomobject]$d; Events=@([pscustomobject]@{ Revision=0; UTC=[DateTime]::UtcNow.ToString('o'); Action='BASELINE'; Before=@(); After=$items; BeforeDefaults=$null; AfterDefaults=[pscustomobject]$d }) }
}
function New-LayerRecord($v,$history,$records) {
  $id=$v[8].Trim().ToUpperInvariant(); $status=$v[9].Trim().ToUpperInvariant(); $target=$v[10].Trim().ToUpperInvariant()
  if (-not $status) { $status='ACTIVE' }
  $byName=@($history.Current | Where-Object { $_.Name -ieq $v[0] })
  if (-not $id -and $byName.Count) { $id=$byName[0].ID }
  if (-not $id) {
    $numbers=@(@($history.Current)+@($records.ToArray()) | ForEach-Object { [int]($_.ID -replace '^TNT-L','') })
    $max=0; foreach ($number in $numbers) { if ($number -gt $max) { $max=$number } }
    $id='TNT-L{0:D4}' -f ($max+1)
  }
  if ($id -notmatch '^TNT-L\d{4,8}$') { throw "Invalid LayerID: $id" }
  if ($status -notin @('ACTIVE','RETIRED')) { throw "Invalid Status for $id; use ACTIVE or RETIRED." }
  if ($status -eq 'ACTIVE' -and $target) { throw "Active layer $id cannot have ReplacementID." }
  $previous=@($history.Current | Where-Object { $_.ID -eq $id })
  if ($previous.Count) { $aliases=@($previous[0].Aliases)+@($v[0]) } else { $aliases=@($v[0]) }
  return [pscustomobject]@{ ID=$id; Name=$v[0]; Values=@($v[0..7]); Status=$status; ReplacementID=$target; Aliases=@($aliases | Select-Object -Unique) }
}
function Resolve-LayerRecord([string]$id,$records) {
  $seen=@{}
  while ($id) {
    if ($seen.ContainsKey($id)) { throw "Replacement cycle at $id" }; $seen[$id]=$true
    $found=@($records | Where-Object { $_.ID -eq $id })
    if ($found.Count -ne 1) { throw "Missing/duplicate replacement LayerID: $id" }
    $row=$found[0]
    if ($row.Status -eq 'ACTIVE') { return $row }
    $id=$row.ReplacementID
  }
  return $null
}
function Test-LayerHistory($records,$history) {
  $ids=@{}; $owners=@{}
  foreach ($row in $records) {
    if ($ids.ContainsKey($row.ID)) { throw "Duplicate LayerID: $($row.ID)" }; $ids[$row.ID]=$true
    foreach ($alias in $row.Aliases) {
      if ($owners.ContainsKey($alias) -and $owners[$alias] -ne $row.ID) { throw "Historical name '$alias' belongs to $($owners[$alias]); do not reuse it for $($row.ID)." }
      $owners[$alias]=$row.ID
    }
  }
  foreach ($old in $history.Current) {
    if (-not $ids.ContainsKey($old.ID)) { throw "LayerID $($old.ID) was deleted. Restore its row and use Status=RETIRED, optionally with ReplacementID." }
  }
  foreach ($row in $records) { $null=Resolve-LayerRecord $row.ID $records }
  if (@($records | Where-Object { $_.Status -eq 'ACTIVE' }).Count -eq 0) { throw 'At least one ACTIVE layer is required.' }
}
function Resolve-DefaultLayer([string]$name,$records,$history) {
  $found=@($records | Where-Object { $_.Name -ieq $name -or $_.Aliases -icontains $name })
  if ($found.Count -ne 1) { throw "Unknown/ambiguous default layer: $name" }
  $target=Resolve-LayerRecord $found[0].ID $records
  if (-not $target) { throw "Default layer $name was retired without replacement." }
  return $target.Name
}
function Get-LayerRenames($records,$history) {
  $renames=@{}
  foreach ($row in $records) {
    $target=Resolve-LayerRecord $row.ID $records
    if (-not $target) { continue }
    foreach ($name in $row.Aliases) { if ($name -cne $target.Name) { $renames[$name]=$target.Name } }
  }
  return $renames
}
function Update-LayerReferences([string]$text,$records,$history,[switch]$Mapping) {
  $renames=Get-LayerRenames $records $history
  # Literal string tokens only; never substring-replace layer names or Lisp identifiers.
  $pattern='"((?:\\.|[^"\\])*)"'
  if ($Mapping) { $pattern='(?m)^(    \()"((?:\\.|[^"\\])*)"(?=\s*$)' }
  return [regex]::Replace($text,$pattern,[Text.RegularExpressions.MatchEvaluator]{param($m)
    $g=1; $prefix=''; if ($Mapping) { $g=2; $prefix=$m.Groups[1].Value }
    $name=Decode-Lisp $m.Groups[$g].Value
    if ($renames.ContainsKey($name)) { return $prefix+(Quote-Lisp $renames[$name]) }
    return $m.Value
  })
}
function New-MigrationData($h) {
  $map=Get-LayerRenames $h.Current $h
  $lines=@(';;; BEGIN TNT LAYER HISTORY DATA',('(defun TNT:LAYER:HISTORY:REVISION (/) '+$h.Revision+')'),"(defun TNT:LAYER:HISTORY:MAP (/)`r`n  '(")
  foreach ($key in @($map.Keys | Sort-Object)) { $lines+='    ('+(Quote-Lisp $key)+' '+(Quote-Lisp $map[$key])+')' }
  $lines+=@('  ))',"(defun TNT:LAYER:HISTORY:RETIRED (/)`r`n  '(")
  foreach ($row in $h.Current) { if ($row.Status -eq 'RETIRED' -and -not (Resolve-LayerRecord $row.ID $h.Current)) { foreach ($alias in $row.Aliases) { $lines+='    '+(Quote-Lisp $alias) } } }
  $lines+=@('  ))',';;; END TNT LAYER HISTORY DATA')
  return $lines -join "`r`n"
}
function New-HistoryWorkbook([byte[]]$bytes,$h) {
  $input=New-Object IO.MemoryStream(,$bytes)
  $iz=New-Object IO.Compression.ZipArchive($input,[IO.Compression.ZipArchiveMode]::Read)
  $output=New-Object IO.MemoryStream
  $oz=New-Object IO.Compression.ZipArchive($output,[IO.Compression.ZipArchiveMode]::Create,$true)
  try {
    $book=Read-ZipXml $iz 'xl/workbook.xml'; $rels=Read-ZipXml $iz 'xl/_rels/workbook.xml.rels'; $types=Read-ZipXml $iz '[Content_Types].xml'
    $overlay=@{}
    $lr=New-Object 'Collections.Generic.List[object]'
    $lr.Add(@('Layer','Plot','ColorACI','Linetype','LineweightMM','Transparency','Description','ExcludeByLayer','LayerID','Status','ReplacementID'))
    foreach ($r in $h.Current) { $lr.Add(@($r.Values)+@($r.ID,$r.Status,$r.ReplacementID)) }
    $dr=New-Object 'Collections.Generic.List[object]'; $dr.Add(@('Variable','Layer'))
    foreach ($p in $h.Defaults.PSObject.Properties) { $dr.Add(@($p.Name,$p.Value)) }
    $gr=New-Object 'Collections.Generic.List[object]'; $gr.Add(@('Muc','Huong dan'))
    foreach ($pair in @(
      @('Layers','Sua ten/thuoc tinh; giu nguyen LayerID khi doi ten. Layer moi de trong LayerID, cong cu tu cap ma.'),
      @('Plot / ColorACI','P/N; mau ACI 1..255. Linetype phai nap duoc tu tep LIN cua AutoCAD.'),
      @('LineweightMM','0..1 mm, dau cham thap phan; rong/0 = ByLayer. CREATE lam tron ve muc ho tro.'),
      @('Transparency','So nguyen 0..90; rong = 0.'),
      @('ExcludeByLayer','Y = mien ep ByLayer; N = binh thuong. Description ho tro tieng Viet; ban 2014 bo dau mo ta.'),
      @('Status','ACTIVE = dang dung; RETIRED = ngung dung. Khong xoa dong co LayerID.'),
      @('ReplacementID','Chi cho RETIRED: dien LayerID dich de gop; de trong de giu layer cu trong DWG va ngung tao moi.'),
      @('Defaults','Layer mac dinh DIM/HATCH/TEXT/MLEADER; ten cu duoc tu doi theo LayerID.'),
      @('History','Chi de xem. Lich su chinh nam trong TNT_SYSTEM_LAYERS_HISTORY.json; khong sua/xoa file nay.'),
      @('Cap nhat','Luu va dong Excel, chay TNT_UPDATE_SYSTEM_LAYERS.cmd tu 0.RELEASE. Tu sao luu va dong bo ban 2014.'),
      @('Ap dung CAD','APPLOAD lai SYSTEM va CREATE. Chay (TNT_LAYER_CREATE) hoac lenh 0: tu doi ten/gop, sau do ap dung chuan.'),
      @('Phan vi','Quet lai moi lan chay, ke ca sau khi copy doi tuong cu vao. APPLOAD khong tu sua DWG. Khong tu luu DWG.'),
      @('Gop layer','Giu thuoc tinh layer dich theo Excel. Override viewport cua layer cu khong tu chep sang dich.'),
      @('Ngoai le','Xref can cap nhat DWG nguon. Tach layer thanh nhieu dich can quy tac rieng; khong tu suy doan.'),
      @('Khoi phuc','UNDO trong CAD cho mot lan cap nhat. Ban sao truoc khi doi Lisp/Excel/lich su o 1.WORK/SYSTEM_LAYER_BACKUPS.')
    )) { $gr.Add($pair) }
    $hr=New-Object 'Collections.Generic.List[object]'; $hr.Add(@('Revision','UTC','Action','LayerID','OldName','NewName','Status','Details'))
    foreach ($event in $h.Events) {
      foreach ($r in $event.After) {
        $old=@($event.Before | Where-Object { $_.ID -eq $r.ID })
        $oldName=''; $oldJson=''; if ($old.Count) { $oldName=$old[0].Name; $oldJson=ConvertTo-Json -InputObject $old[0] -Compress -Depth 20 }
        $json=ConvertTo-Json -InputObject $r -Compress -Depth 20
        if ($oldJson -cne $json) { $hr.Add(@([string]$event.Revision,$event.UTC,$event.Action,$r.ID,$oldName,$r.Name,$r.Status,$json)) }
      }
      if ((ConvertTo-Json $event.BeforeDefaults -Compress) -cne (ConvertTo-Json $event.AfterDefaults -Compress)) { $hr.Add(@([string]$event.Revision,$event.UTC,'DEFAULTS','','','','',(ConvertTo-Json $event.AfterDefaults -Compress))) }
    }
    $data=@{Layers=$lr; Defaults=$dr; Guide=$gr; History=$hr}
    $widths=@{Layers='43,10,12,23,18,16,42,19,17,15,20'; Defaults='24,44'; Guide='25,125'; History='12,29,14,17,43,43,15,90'}
    foreach ($name in @('Layers','Defaults','Guide','History')) {
      $sheet=@($book.workbook.sheets.sheet | Where-Object { $_.name -eq $name })
      if (-not $sheet.Count) {
        $id='tntHistory'; $path='xl/worksheets/tntHistory.xml'
        $node=$book.CreateElement('sheet',$book.DocumentElement.NamespaceURI); $node.SetAttribute('name',$name); $node.SetAttribute('sheetId','100'); $null=$node.SetAttribute('id','http://schemas.openxmlformats.org/officeDocument/2006/relationships',$id); $null=$book.workbook.sheets.AppendChild($node)
        $rel=$rels.CreateElement('Relationship',$rels.DocumentElement.NamespaceURI); $rel.SetAttribute('Id',$id); $rel.SetAttribute('Type','http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet'); $rel.SetAttribute('Target','worksheets/tntHistory.xml'); $null=$rels.DocumentElement.AppendChild($rel)
        $type=$types.CreateElement('Override',$types.DocumentElement.NamespaceURI); $type.SetAttribute('PartName','/'+$path); $type.SetAttribute('ContentType','application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml'); $null=$types.DocumentElement.AppendChild($type)
      } else {
        $id=$sheet[0].GetAttribute('id','http://schemas.openxmlformats.org/officeDocument/2006/relationships'); $target=($rels.Relationships.Relationship | Where-Object {$_.Id -eq $id}).Target
        $path=if ($target.StartsWith('/')) {$target.TrimStart('/')} else {'xl/'+$target}
      }
      $overlay[$path]=Sheet-Xml $data[$name] $widths[$name] -Filter:($name -ne 'Guide')
    }
    $overlay['xl/workbook.xml']=$book.OuterXml; $overlay['xl/_rels/workbook.xml.rels']=$rels.OuterXml; $overlay['[Content_Types].xml']=$types.OuterXml
    foreach ($entry in $iz.Entries) {
      if ($overlay.ContainsKey($entry.FullName)) { continue }
      $outEntry=$oz.CreateEntry($entry.FullName); $ins=$entry.Open(); $outs=$outEntry.Open()
      try { $ins.CopyTo($outs) } finally { $ins.Dispose(); $outs.Dispose() }
    }
    foreach ($key in $overlay.Keys) { Put-Zip $oz $key $overlay[$key] }
  } finally { $oz.Dispose(); $iz.Dispose(); $input.Dispose() }
  try { return ,$output.ToArray() } finally { $output.Dispose() }
}
function Publish-LayerHistory($records,$history,$updates,[string]$updated,[string]$root,[string]$sync,[string]$backupDir) {
  $nextDefaults=[ordered]@{}; foreach ($key in @('DIMLAYER','HPLAYER','TEXTLAYER','MLEADERLAYER')) { $nextDefaults[$key]=$updates[$key] }
  $candidate=[pscustomobject]$nextDefaults
  $changed=(ConvertTo-Json -InputObject @($history.Current) -Compress -Depth 30) -cne (ConvertTo-Json -InputObject @($records.ToArray()) -Compress -Depth 30)
  foreach ($key in $nextDefaults.Keys) { if ($history.Defaults.$key -cne $nextDefaults[$key]) { $changed=$true } }
  $h=[pscustomobject]@{ Schema=1; Revision=$history.Revision; Current=@($records.ToArray()); Defaults=$candidate; Events=@($history.Events) }
  if ($changed) {
    $h.Revision++
    $h.Events+= [pscustomobject]@{Revision=$h.Revision; UTC=[DateTime]::UtcNow.ToString('o'); Action='UPDATE'; Before=@($history.Current); After=@($records.ToArray()); BeforeDefaults=$history.Defaults; AfterDefaults=$candidate}
  }
  $data=New-MigrationData $h
  $pattern='(?s);;; BEGIN TNT LAYER HISTORY DATA.*?;;; END TNT LAYER HISTORY DATA'
  if (-not [regex]::IsMatch($updated,$pattern)) { throw 'System package is missing the layer history runtime. Reload the complete release.' }
  $updated=[regex]::Replace($updated,$pattern,[Text.RegularExpressions.MatchEvaluator]{param($m) $data})
  $pending=@{}; $pending[$LispFile]=$utf8.GetBytes($updated)
  foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root '0.RELEASE') -Filter '*.lsp' -Recurse -File) {
    if ($file.FullName -ieq [IO.Path]::GetFullPath($LispFile)) { continue }
    $text=[IO.File]::ReadAllText($file.FullName,$utf8)
    $new=Update-LayerReferences $text $records $history -Mapping:($file.Name -eq 'TNT_LAYER_SYNC_ALL.lsp')
    # A retired layer without a replacement may not remain a live package reference.
    foreach ($row in $records) {
      if ($row.Status -eq 'RETIRED' -and -not (Resolve-LayerRecord $row.ID $records)) {
        foreach ($alias in $row.Aliases) {
          if ($file.Name -ne 'TNT_LAYER_SYNC_ALL.lsp' -and $new.Contains((Quote-Lisp $alias))) { throw "Retired layer '$alias' is referenced by $($file.Name). Set ReplacementID before retiring it." }
        }
      }
    }
    if ($new -cne $text) { $pending[$file.FullName]=$utf8.GetBytes($new) }
  }
  $historyPath=Join-Path $PSScriptRoot 'TNT_SYSTEM_LAYERS_HISTORY.json'
  $pending[$historyPath]=$utf8.GetBytes((ConvertTo-Json $h -Depth 40))
  $pending[$Workbook]=New-HistoryWorkbook ([IO.File]::ReadAllBytes($Workbook)) $h
  $backup=Join-Path $backupDir ((Get-Date -Format 'yyyyMMdd_HHmmss_fff')+'_revision_'+$h.Revision)
  [void][IO.Directory]::CreateDirectory($backup)
  $restore=@{}; $manifest=@(); $n=0
  foreach ($path in $pending.Keys) {
    $n++; $exists=Test-Path -LiteralPath $path; $copy=Join-Path $backup ($n.ToString('D3')+'_'+[IO.Path]::GetFileName($path))
    $restore[$path]=$null; if ($exists) { $restore[$path]=[IO.File]::ReadAllBytes($path); [IO.File]::WriteAllBytes($copy,$restore[$path]) }
    $manifest+=[pscustomobject]@{Path=$path; Existed=$exists; Backup=$copy}
  }
  [IO.File]::WriteAllText((Join-Path $backup 'manifest.json'),(ConvertTo-Json $manifest),$utf8)
  try {
    foreach ($path in $pending.Keys) { [IO.File]::WriteAllBytes($path,$pending[$path]) }
    & powershell -NoProfile -ExecutionPolicy Bypass -File $sync
    if ($LASTEXITCODE -ne 0) { throw 'Release14 synchronization failed.' }
    & powershell -NoProfile -ExecutionPolicy Bypass -File $sync -Check
    if ($LASTEXITCODE -ne 0) { throw 'Release14 check failed.' }
  } catch {
    foreach ($path in $restore.Keys) { if ($null -eq $restore[$path]) { if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path } } else { [IO.File]::WriteAllBytes($path,$restore[$path]) } }
    & powershell -NoProfile -ExecutionPolicy Bypass -File $sync
    throw
  }
  Write-Output "Published history revision $($h.Revision). Backup: $backup"
}
