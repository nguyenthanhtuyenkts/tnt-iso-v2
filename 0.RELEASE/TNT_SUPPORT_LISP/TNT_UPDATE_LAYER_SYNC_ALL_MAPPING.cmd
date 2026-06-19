@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%TNT_UPDATE_LAYER_SYNC_ALL_MAPPING.ps1"
echo.
pause
