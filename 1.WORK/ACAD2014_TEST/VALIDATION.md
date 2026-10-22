# Validation 2026-10-22

- Source and generated edition both contain 20 LSP files.
- All generated LSP files passed a string/comment-aware parenthesis balance check.
- Sync rerun with `-Check`: 0 pending files; generation is repeatable.
- Original `0.RELEASE` files were not modified.
- Runtime attempt: installed AutoCAD 2014 Core Console failed to initialize the current profile in the sandbox (`FATAL ERROR: Problem with setting up current profile.`). A subsequent elevated attempt remained running without producing result.txt and was stopped. No successful runtime load or interactive command test is claimed.
- `load.scr` and `load.lsp` are retained to rerun the 20-file load test after the local AutoCAD profile/startup is working. The test does not validate every interactive command or AEC conversion.

Reference: https://help.autodesk.com/cloudhelp/2023/ENU/AutoCAD-Customization/files/GUID-31FD1A96-C002-434E-8684-63D50BE0CF94.htm

Reference for DIMLAYER/new dimension behavior: https://www.autodesk.com/blogs/autocad/faster-dimensioning-in-autocad-2016-2/
