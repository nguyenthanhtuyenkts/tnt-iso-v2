param(
  [string]$Root = "D:\0.TNT ISO 2026"
)

$ErrorActionPreference = "Stop"

$ReleaseDir = Join-Path $Root "0.RELEASE"
$WorkDir = Join-Path $Root "1.WORK"
$LegacyDir = Join-Path $Root "2.LEGACY"

function Get-RelativePath {
  param([string]$BasePath, [string]$FullPath)
  $base = [System.IO.Path]::GetFullPath($BasePath).TrimEnd('\') + '\'
  $full = [System.IO.Path]::GetFullPath($FullPath)
  return $full.Substring($base.Length)
}

function Convert-ToMdText {
  param([AllowNull()][string]$Text)
  if ([string]::IsNullOrWhiteSpace($Text)) { return "" }
  return ($Text -replace '\|', '\|' -replace '\r?\n', ' ' -replace '`', '&#96;' ).Trim()
}

function Convert-ToMdCode {
  param([AllowNull()][string]$Text)
  $safe = Convert-ToMdText $Text
  if ([string]::IsNullOrWhiteSpace($safe)) { return "" }
  return "<code>$safe</code>"
}

function Get-FeatureHint {
  param([string]$RelativePath)
  $s = $RelativePath.ToUpperInvariant()
  $hints = New-Object System.Collections.Generic.List[string]
  foreach ($pair in @(
    @("SYSTEM", "system/setup"),
    @("CREATE", "tao chuan"),
    @("GENERAL", "dong bo ti le/doi tuong"),
    @("MANAGE", "quan ly/chinh sua"),
    @("DRAW", "ve/phu tro ve"),
    @("LAYER", "layer"),
    @("TEXT", "text"),
    @("LEADER", "leader"),
    @("DIM", "dimension"),
    @("HATCH", "hatch"),
    @("BLOCK", "block"),
    @("SHORTCUT", "shortcut"),
    @("MIGRATE", "migration"),
    @("PLOT", "plot/in"),
    @("WIPEOUT", "wipeout"),
    @("AREA", "dien tich"),
    @("DIEN TICH", "dien tich"),
    @("STT", "danh so thu tu"),
    @("COPY", "copy"),
    @("RENAME", "rename"),
    @("CAO DO", "cao do"),
    @("ALIGN", "can chinh"),
    @("CURRENT STYLE", "style hien hanh")
  )) {
    if ($s.Contains($pair[0])) { $hints.Add($pair[1]) }
  }
  if ($hints.Count -eq 0) { return "" }
  return (($hints | Select-Object -Unique) -join ", ")
}

function Read-TextFileLoose {
  param([string]$Path)
  try {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
  } catch {
    try {
      return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::Default)
    } catch {
      return ""
    }
  }
}

function Get-LispInfo {
  param([System.IO.FileInfo]$File, [string]$BaseDir)

  $rel = Get-RelativePath $BaseDir $File.FullName
  $text = Read-TextFileLoose $File.FullName

  $defMatches = [regex]::Matches($text, '(?im)^\s*\(\s*defun\s+([^\s\)]+)')
  $defs = @($defMatches | ForEach-Object { $_.Groups[1].Value.Trim() } | Where-Object { $_ } | Select-Object -Unique)
  $commands = @($defs | Where-Object { $_ -match '^(?i)c:' } | ForEach-Object { $_ -replace '^(?i)c:', '' } | Select-Object -Unique)
  $helpers = @($defs | Where-Object { $_ -notmatch '^(?i)c:' } | Select-Object -Unique)

  $sourceMatches = [regex]::Matches($text, '(?im)^\s*;+\s*BEGIN SOURCE:\s*(.+?)\s*$')
  $sources = @($sourceMatches | ForEach-Object { $_.Groups[1].Value.Trim() } | Select-Object -Unique)

  $purposeMatches = [regex]::Matches($text, '(?im)^\s*;+\s*\*?\s*(PURPOSE|FILE|Run command|Creates|Returns|Sets|Modifies)\s*:?\s*(.+?)\s*$')
  $notes = @($purposeMatches | Select-Object -First 4 | ForEach-Object {
    ($_.Groups[2].Value.Trim() -replace '\s+', ' ')
  } | Where-Object { $_ } | Select-Object -Unique)

  [pscustomobject]@{
    RelativePath = $rel
    Name = $File.Name
    Extension = $File.Extension.ToLowerInvariant()
    Length = $File.Length
    LastWriteTime = $File.LastWriteTime
    Hint = Get-FeatureHint $rel
    Commands = $commands
    Helpers = $helpers
    Sources = $sources
    Notes = $notes
  }
}

function Format-CommandList {
  param([string[]]$Commands)
  if ($Commands.Count -eq 0) { return "" }
  return (($Commands | Sort-Object) -join ", ")
}

function Format-LimitedList {
  param([string[]]$Items, [int]$Limit = 10)
  if ($Items.Count -eq 0) { return "" }
  $shown = @($Items | Sort-Object | Select-Object -First $Limit)
  $text = $shown -join ", "
  if ($Items.Count -gt $Limit) { $text += " ... +" + ($Items.Count - $Limit) }
  return $text
}

function New-LispIndex {
  param(
    [string]$BaseDir,
    [string]$OutFile,
    [string]$Title,
    [string]$ScopeNote
  )

  $files = @()
  if (Test-Path -LiteralPath $BaseDir) {
    $files = @(Get-ChildItem -LiteralPath $BaseDir -Recurse -File |
      Where-Object { $_.Extension -match '^\.(lsp|vlx|fas|arx|dll)$' } |
      Sort-Object FullName)
  }

  $infos = @($files | ForEach-Object {
    if ($_.Extension -match '^\.(lsp)$') { Get-LispInfo $_ $BaseDir }
    else {
      [pscustomobject]@{
        RelativePath = Get-RelativePath $BaseDir $_.FullName
        Name = $_.Name
        Extension = $_.Extension.ToLowerInvariant()
        Length = $_.Length
        LastWriteTime = $_.LastWriteTime
        Hint = Get-FeatureHint (Get-RelativePath $BaseDir $_.FullName)
        Commands = @()
        Helpers = @()
        Sources = @()
        Notes = @("Binary/compiled support file; cannot extract commands automatically.")
      }
    }
  })

  $allCommands = @($infos | ForEach-Object { $_.Commands } | Where-Object { $_ } | Sort-Object -Unique)
  $cmdRows = @()
  foreach ($info in $infos) {
    foreach ($cmd in ($info.Commands | Sort-Object)) {
      $cmdRows += [pscustomobject]@{ Command = $cmd; File = $info.RelativePath; Hint = $info.Hint }
    }
  }

  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("# $Title")
  $lines.Add("")
  $lines.Add("- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')")
  $lines.Add("- Scope: $ScopeNote")
  $lines.Add("- Files indexed: $($infos.Count)")
  $lines.Add("- Public commands found: $($allCommands.Count)")
  $lines.Add("")
  $lines.Add("## Quick Command Lookup")
  $lines.Add("")
  if ($cmdRows.Count -eq 0) {
    $lines.Add("_No public `c:` commands extracted._")
  } else {
    $lines.Add("| Command | File | Hint |")
    $lines.Add("|---|---|---|")
    foreach ($row in ($cmdRows | Sort-Object Command, File)) {
      $lines.Add(("| {0} | {1} | {2} |" -f (Convert-ToMdCode $row.Command), (Convert-ToMdCode $row.File), (Convert-ToMdText $row.Hint)))
    }
  }
  $lines.Add("")
  $lines.Add("## File Index")
  $lines.Add("")
  $lines.Add("| File | Hint | Commands | Helpers | Sources/Notes |")
  $lines.Add("|---|---|---:|---:|---|")
  foreach ($info in $infos) {
    $cmdText = Format-CommandList $info.Commands
    $srcText = Format-LimitedList (@($info.Sources + $info.Notes)) 8
    $lines.Add(("| {0} | {1} | {2} | {3} | {4} |" -f (Convert-ToMdCode $info.RelativePath), (Convert-ToMdText $info.Hint), $info.Commands.Count, $info.Helpers.Count, (Convert-ToMdText $srcText)))
  }
  $lines.Add("")
  $lines.Add("## Detail By File")
  foreach ($info in $infos) {
    $lines.Add("")
    $lines.Add("### $($info.RelativePath)")
    $lines.Add("")
    $lines.Add("- Size: $([Math]::Round($info.Length / 1KB, 1)) KB")
    $lines.Add("- Modified: $($info.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))")
    if ($info.Hint) { $lines.Add("- Hint: $($info.Hint)") }
    if ($info.Commands.Count -gt 0) { $lines.Add("- Commands: $(Convert-ToMdCode (Format-CommandList $info.Commands))") }
    if ($info.Helpers.Count -gt 0) { $lines.Add("- Helper/internal functions: $($info.Helpers.Count); sample: $(Convert-ToMdCode (Format-LimitedList $info.Helpers 20))") }
    if ($info.Sources.Count -gt 0) { $lines.Add("- Consolidated sources: $(Convert-ToMdCode (Format-LimitedList $info.Sources 20))") }
    if ($info.Notes.Count -gt 0) { $lines.Add("- Notes: $(Convert-ToMdText (($info.Notes | Select-Object -First 4) -join '; '))") }
  }

  [System.IO.File]::WriteAllLines($OutFile, $lines, [System.Text.UTF8Encoding]::new($false))
}

function New-WorkHistory {
  param([string]$OutFile)
  $lines = @(
    "# TNT ISO 2026 - Work History",
    "",
    "- Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')",
    "- Workspace root: ``$Root``",
    "",
    "## Folder Rules",
    "",
    "- ``0.RELEASE``: thu muc release sach, chi de goi phat hanh va file can giao.",
    "- ``1.WORK``: nhat ky, tool, script, log, file tam va file sinh ra trong qua trinh lam viec.",
    "- ``2.LEGACY``: kho lisp cu dung de tham chieu, khong sua truc tiep neu khong co yeu cau ro.",
    "",
    "## Generated Reference Files",
    "",
    "- ``1.WORK/WORK_HISTORY.md``: file nay, ghi lich su va quy uoc lam viec.",
    "- ``1.WORK/TNT_Build_Indexes.ps1``: tool sinh lai index.",
    "- ``2.LEGACY/LEGACY_INDEX.md``: index nhanh kho legacy.",
    "- ``0.RELEASE/RELEASE_LISP_INDEX.md``: index nhanh cac goi lisp release.",
    "",
    "## Log",
    "",
    "### $(Get-Date -Format 'yyyy-MM-dd')",
    "",
    "- Tao bo index Markdown cho ``2.LEGACY`` va ``0.RELEASE``.",
    "- Giu file sinh ra/tool trong ``1.WORK``; chi tao index doi chieu tai chinh folder can tham chieu."
  )
  [System.IO.File]::WriteAllLines($OutFile, $lines, [System.Text.UTF8Encoding]::new($false))
}

if (!(Test-Path -LiteralPath $WorkDir)) { New-Item -ItemType Directory -Path $WorkDir | Out-Null }

New-WorkHistory -OutFile (Join-Path $WorkDir "WORK_HISTORY.md")
New-LispIndex -BaseDir $LegacyDir -OutFile (Join-Path $LegacyDir "LEGACY_INDEX.md") -Title "TNT Legacy Lisp Index" -ScopeNote "2.LEGACY - kho lisp cu de tham chieu"
New-LispIndex -BaseDir $ReleaseDir -OutFile (Join-Path $ReleaseDir "RELEASE_LISP_INDEX.md") -Title "TNT Release Lisp Index" -ScopeNote "0.RELEASE - goi lisp va support dang release"

Write-Host "Generated:"
Write-Host " - $(Join-Path $WorkDir 'WORK_HISTORY.md')"
Write-Host " - $(Join-Path $LegacyDir 'LEGACY_INDEX.md')"
Write-Host " - $(Join-Path $ReleaseDir 'RELEASE_LISP_INDEX.md')"
