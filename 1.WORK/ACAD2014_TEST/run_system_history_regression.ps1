param([string]$ProgId = 'AutoCAD.Application.24.1', [switch]$StartApplication)
$ErrorActionPreference = 'Stop'
function Invoke-CadReady([scriptblock]$Action) {
  for ($attempt = 0; $attempt -lt 60; $attempt++) {
    try { return (& $Action) }
    catch {
      if ($_.Exception.HResult -ne -2147418111) { throw }
      Start-Sleep -Milliseconds 250
    }
  }
  throw 'AutoCAD remained busy for 15 seconds.'
}
$app = if ($StartApplication) { New-Object -ComObject $ProgId } else { [Runtime.InteropServices.Marshal]::GetActiveObject($ProgId) }
$previous = $null
if ($StartApplication) { Invoke-CadReady { $app.Visible=$false } } else { $previous = Invoke-CadReady { $app.ActiveDocument } }
$scratch = $null
$secure = $null
try {
  $drawing = Join-Path $PSScriptRoot 'layer_sync_scratch.dwg'
  $scratch = Invoke-CadReady { $app.Documents.Open($drawing, $false) }
  $secure = Invoke-CadReady { $scratch.GetVariable('SECURELOAD') }
  Invoke-CadReady { $scratch.SetVariable('SECURELOAD', [int16]0) }
  $result = Join-Path $PSScriptRoot 'system_history_result.txt'
  [IO.File]::WriteAllText($result, 'PENDING')
  $path = (Join-Path $PSScriptRoot 'system_history_regression.lsp').Replace('\','/')
  Invoke-CadReady { $scratch.SendCommand('(load "' + $path + '")' + "`n") }
  for ($attempt = 0; $attempt -lt 60; $attempt++) {
    $text = [IO.File]::ReadAllText($result)
    if ($text -match 'ALL_SYSTEM_HISTORY_COMPLETE|ERROR:') { break }
    Start-Sleep -Milliseconds 250
  }
  Write-Output $text
  if ($text -match 'FAIL|ERROR:|PENDING' -or $text -notmatch 'ALL_SYSTEM_HISTORY_COMPLETE') {
    throw 'Layer sync regression did not pass.'
  }
}
finally {
  if ($scratch) {
    if ($null -ne $secure) { Invoke-CadReady { $scratch.SetVariable('SECURELOAD', $secure) } }
    Invoke-CadReady { $scratch.Close($false) }
  }
  if ($previous) { Invoke-CadReady { $previous.Activate() } }
  if ($StartApplication) { Invoke-CadReady { $app.Quit() } }
}
