# TNT_EXPORT2014 validation - 2026-10-27

Release source: `0.RELEASE/TNT_SUPPORT_LISP/TNT_EXPORT_ACAD2014.lsp`.
Command: `TNT_EXPORT2014`. Load with APPLOAD. Choose Chon (default) or Tatca,
then choose the destination in the save dialog. Suggested name:
`<current-drawing>_ACAD2014.dwg`. Existing files are refused and the dialog
reopens. Esc/cancel before writing produces no export.

The selected branch uses ActiveX WBlock, which copies selected entities without
erasing them. The whole-drawing branch uses `-WBLOCK` with `*`, preserving Model
and PaperSpace contents. WBLOCK can omit unreferenced symbols in the output.
No SAVE/SAVEAS, explode, layer/color/style/UCS/INSBASE changes are made to the
source. Current unsaved entities are included. SaveAsType is temporarily set to
ac2013_dwg (60), then restored along with FILEDIA and CMDECHO. A unique staged
file is checked for the AC1027 signature before being renamed to the destination.

## Runtime evidence

The generated ASCII edition ran in installed AutoCAD 2014, ACADVER 19.1s.
See `export2014_test.lsp`, `export2014_test.scr`, and `export2014_result.txt`.
All 16 assertions passed, covering:

- Selected export and whole-drawing export with AC1027 headers.
- Exact source entity DXF snapshots and DBMOD unchanged after each export.
- Original document name, SaveAsType, FILEDIA and CMDECHO preserved/restored.
- Suggested filename suffix.
- Reopening both output files through AutoCAD 2014 ObjectDBX.
- Selected entity count, coordinates, color and block reference name.
- Whole-drawing model count, unsaved text and PaperSpace text.

The isolated GUI test process completed its assertions and log. It did not exit
within the 45-second launcher limit and was terminated by that launcher. No
claim is made that the GUI exit sequence was successful. File dialog behavior
and interactive Esc were reviewed in code, not automated through the GUI.

Static Lisp parentheses/string checks passed. Release14 synchronization and
`-Check` passed with zero pending files. All added Lisp is ASCII, and the new
ActiveX APIs/commands were exercised directly on AutoCAD 2014; no additional
compatibility rewrite in the synchronization script was required.

## Scope limits

This exports the DWG container format. It does not decode or explode newer
AEC/Civil/proxy objects. Their display/editability still depends on compatible
object support. Xrefs, images and fonts remain external dependencies, not a
packaged or bound delivery. The command prints these limits after export.

References:

- [Autodesk WBlock ActiveX](https://help.autodesk.com/cloudhelp/2026/ENU/AutoCAD-ActiveX-Reference/files/GUID-4EEC4025-ACFC-41DA-899A-8264394D7691.htm)
- [Autodesk -WBLOCK](https://help.autodesk.com/cloudhelp/2018/ENU/AutoCAD-Core/files/GUID-F26FC1CE-45C9-4C85-9DB9-19B6A597D87B.htm)
- [Autodesk SaveAsType](https://help.autodesk.com/cloudhelp/2020/CHT/AutoCAD-ActiveX-Reference/files/GUID-5A1DCAF1-A066-4D04-9557-1F45B68A8031.htm)
