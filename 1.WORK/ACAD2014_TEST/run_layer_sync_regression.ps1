param([string]$ProgId = 'AutoCAD.Application.24.1')
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
$app = [Runtime.InteropServices.Marshal]::GetActiveObject($ProgId)
$previous = Invoke-CadReady { $app.ActiveDocument }
$scratch = $null
$secure = $null
try {
  $drawing = Join-Path $PSScriptRoot 'layer_sync_scratch.dwg'
  $scratch = Invoke-CadReady { $app.Documents.Open($drawing, $false) }
  $secure = Invoke-CadReady { $scratch.GetVariable('SECURELOAD') }
  Invoke-CadReady { $scratch.SetVariable('SECURELOAD', [int16]0) }
  $result = Join-Path $PSScriptRoot 'layer_sync_regression_result.txt'
  [IO.File]::WriteAllText($result, 'PENDING')
  $path = (Join-Path $PSScriptRoot 'layer_sync_regression.lsp').Replace('\','/')
  Invoke-CadReady { $scratch.SendCommand('(load "' + $path + '")' + "`n") }
  for ($attempt = 0; $attempt -lt 60; $attempt++) {
    $text = [IO.File]::ReadAllText($result)
    if ($text -match 'ALL_RUN_COMPLETE|ERROR:') { break }
    Start-Sleep -Milliseconds 250
  }
  Write-Output $text
  if ($text -match 'FAIL|ERROR:|PENDING' -or $text -notmatch 'ALL_RUN_COMPLETE: PASS') {
    throw 'Layer sync regression did not pass.'
  }
}
finally {
  if ($scratch) {
    if ($null -ne $secure) { Invoke-CadReady { $scratch.SetVariable('SECURELOAD', $secure) } }
    Invoke-CadReady { $scratch.Close($false) }
  }
  if ($previous) { Invoke-CadReady { $previous.Activate() } }
}
