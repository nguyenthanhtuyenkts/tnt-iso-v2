@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0TNT_SYSTEM_LAYERS.ps1" %*
if errorlevel 1 (
  echo [TNT] UPDATE FAILED. Read the error above.
  pause
  exit /b 1
)
echo [TNT] DONE. Reload package SYSTEM in AutoCAD to use the updated table.
pause
