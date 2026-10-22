# Release maintenance

- `0.RELEASE` is the canonical release. Whenever any file in it is added or changed, update the corresponding AutoCAD 2014 edition in sibling `00.RELEASE 14` during the same task.
- Run `powershell -NoProfile -ExecutionPolicy Bypass -File 1.WORK/TNT_Sync_Release14.ps1`, then run it again with `-Check`.
- Maintain compatibility adaptations in the sync script, not only in generated Lisp files. Review newly introduced commands, system variables and ActiveX APIs for AutoCAD 2014 support. Do not suppress arbitrary errors to claim compatibility.
- The 2014 Lisp sources use ASCII with Vietnamese accents removed because the legacy engine does not support UTF-8 source. Preserve identifiers, layer names, block names and drawing data deliberately; review any new non-ASCII data before synchronization.
- On source deletion or rename, explicitly handle the corresponding generated file in the same task; the sync script deliberately does not delete destination files automatically.
- DWG/BAK/VLX are excluded from automatic copying: drawing conversion and compiled-code compatibility must be checked separately.
- Validate with installed AutoCAD 2014 when possible, and report any runtime validation limits honestly.
