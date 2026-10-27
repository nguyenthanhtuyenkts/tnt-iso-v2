# TNT_ACAD SOLID extraction validation - 2026-10-27

- All remaining SOLID hatches now use explicit ACI 251, regardless of their original color. AcCmColor.ColorIndex + TrueColor assignment replaces RGB/color-book overrides. Non-SOLID objects retain the prior normalization rules.
- Source layers are temporarily unlocked and restored, including error handling. The command is grouped for Undo.
- The user authorized extracting SOLID hatches out of blocks. Traversal collects each live insertion path in Model and every Layout. Matrices include definition base point, insertion, scale, rotation, OCS normal, and nested transforms.
- Independent nonassociative hatch copies are staged in the owning layout/model space before shared source hatches are removed. Hole/edge geometry is retained; only boundary associations/reactors of temporary copies are detached. Other block geometry remains inside the original definitions.
- Copy/transform/deletion failures report errors, restore deleted sources and remove staged copies. Xrefs are excluded. Extraction is skipped with an explicit warning if a SOLID path contains XCLIP or MINSERT, rather than losing clipped/array geometry. Such drawings need further handling before all SOLIDs can be globally sorted.
- Final MoveToTop applies to extracted native hatches alongside existing top-level SOLIDs. Unreferenced definitions are still normalized/sorted internally.
- Legacy ActiveX APIs used (Copy, CopyObjects, TrueColor.ColorIndex, TransformBy, MoveToTop) are available in AutoCAD 2014; no new system variables or version-specific commands were introduced. No edition-specific sync adaptation was necessary.
- Static string/comment-aware parenthesis checks passed for source, generated 2014 source, and the regression fixture. Sync and -Check passed.
- aec_solid_extract_test.lsp checks SOLID-17 deletion, TrueColor->ACI251, shared nested-block extraction, nonzero base point, rotation, mirrored/nonuniform scale, hole count/area, boundary preservation, and draw-order API errors.
- Runtime attempt: installed AutoCAD 2014 Core Console exited 1 without creating a result file. No runtime pass is claimed. AEC conversion, transform support for actual drawing geometry, and visual draw order still require validation in AutoCAD.

Primary API references:
- https://help.autodesk.com/cloudhelp/2022/KOR/AutoCAD-ActiveX-Reference/files/GUID-2FAE4C13-06F2-47A2-B213-8A9A6958B799.htm
- https://help.autodesk.com/cloudhelp/2024/ENU/AutoCAD-ActiveX-Reference/files/GUID-02D66CBD-C490-4AE1-B18E-531AE970AF3E.htm