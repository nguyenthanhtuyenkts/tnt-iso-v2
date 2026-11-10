@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0TNT_SYSTEM_LAYERS.ps1" %*
if errorlevel 1 (
  echo [TNT] UPDATE FAILED. Read the error above.
  pause
  exit /b 1
)
echo [TNT] DONE. Reload SYSTEM and CREATE, then run (TNT_LAYER_CREATE) or 0.
pause
