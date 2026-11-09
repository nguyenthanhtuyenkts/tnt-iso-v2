# TNT_MEP_BASE validation - 2026-11-09

- Added AEC/proxy detection and per-object EXPLODE of a staged copy in the active drawing space. Output is copied into a private block and recursively normalized to ....46_TNT_BASE_MEP / ByLayer. The source is deleted only after a replacement reference has been created and normalized. Unsupported conversions retain their source and print a failure message.
- AEC conversion requires AutoCAD Architecture/MEP or an appropriate Object Enabler. No drawing-wide -AECOBJEXPLODE or export command is invoked.
- Private-block recursion uses a snapshot to avoid deleting/adding objects inside a live COM enumerator. Recursive copy/name failures now contribute to failure counts.
- Localized obj in COPY-BLOCK-CONTENTS and OBJECTS->SS to preserve caller references. Added staged-entity cleanup and CMDECHO/Undo restoration on errors.
- Compatibility: EXPLODE and the used CopyObjects, ObjectIDToObject, OwnerID, InsertBlock, StartUndoMark and EndUndoMark APIs are legacy AutoCAD APIs; no new system variables were introduced. Source additions are ASCII. No edition-specific adaptation was required.
- String/comment-aware parenthesis checks passed for canonical and generated Lisp. Release sync and -Check passed (0 pending).
- Installed AutoCAD 2014 Core Console was invoked with mep_base_test.scr. It produced empty stdout/stderr and no mep_base_result.txt. No runtime pass is claimed. The fixture covers caller obj preservation and native layer/color assignment if the console can initialize.
- Actual AEC conversion, visual display representation, and placement for nested/model/paper-space objects still require interactive validation with a suitable AEC drawing and Object Enabler. Locked source layers can prevent replacement. Conversion uses the active display representation, not a guaranteed full 3D export.
- Existing special TNT_COT_1 explode/reblock behavior is retained; its pre-existing early source deletion is outside this AEC-specific staging change.

Autodesk 2014 Object Enabler reference: https://images.autodesk.com/adsk/files/autocad_architecture_mep_2014_oe_readme.html
