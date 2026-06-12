@echo off
setlocal

set "SRC=D:\0.TNT ISO 2026\0.RELEASE"
set "DST=Z:\0000.TNT_ISO_2026"
set "LOGDIR=D:\0.TNT ISO 2026\1.WORK"
set "LOG=%LOGDIR%\TNT_PC_AUTOCOPY.log"
set "PRESERVE_FILES=MarkText.exe"

echo ============================================================
echo TNT PC AUTOCOPY
echo Source:      %SRC%
echo Destination: %DST%
echo Log:         %LOG%
echo Mode:        MIRROR - extra files in destination will be deleted
echo Preserved:   %PRESERVE_FILES%
echo ============================================================
echo.

if not exist "%SRC%\" (
  echo ERROR: Source folder not found.
  echo %SRC%
  exit /b 10
)

if not exist "Z:\" (
  echo ERROR: Drive Z: is not available. Check NAS mapping.
  exit /b 11
)

if not exist "%DST%\" (
  mkdir "%DST%"
  if errorlevel 1 (
    echo ERROR: Cannot create destination folder.
    echo %DST%
    exit /b 12
  )
)

echo WARNING: This will make the NAS folder exactly match 0.RELEASE.
echo Extra files and folders in "%DST%" will be deleted,
echo except preserved files: %PRESERVE_FILES%
echo.
set /p "CONFIRM=Type OK to continue: "
if /I not "%CONFIRM%"=="OK" (
  echo CANCELLED.
  exit /b 20
)

robocopy "%SRC%" "%DST%" /MIR /COPY:DAT /DCOPY:DAT /R:2 /W:2 /TEE /LOG+:"%LOG%" /XD ".git" "__pycache__" /XF "*.bak" "*.tmp" "~$*" "%PRESERVE_FILES%"
set "RC=%ERRORLEVEL%"

echo.
if %RC% LEQ 7 (
  echo DONE: Release copied successfully. Robocopy code: %RC%
  exit /b 0
) else (
  echo ERROR: Copy failed. Robocopy code: %RC%
  exit /b %RC%
)
