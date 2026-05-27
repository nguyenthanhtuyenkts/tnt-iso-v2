# TNT ISO 2026 - Work History

- Created: 2026-05-27 18:37:27 +07:00
- Workspace root: `D:\0.TNT ISO 2026`

## Folder Rules

- `0.RELEASE`: thu muc release sach, chi de goi phat hanh va file can giao.
- `1.WORK`: nhat ky, tool, script, log, file tam va file sinh ra trong qua trinh lam viec.
- `2.LEGACY`: kho lisp cu dung de tham chieu, khong sua truc tiep neu khong co yeu cau ro.

## Generated Reference Files

- `1.WORK/WORK_HISTORY.md`: file nay, ghi lich su va quy uoc lam viec.
- `1.WORK/TNT_Build_Indexes.ps1`: tool sinh lai index.
- `2.LEGACY/LEGACY_INDEX.md`: index nhanh kho legacy.
- `0.RELEASE/RELEASE_LISP_INDEX.md`: index nhanh cac goi lisp release.

## Log

### 2026-05-27

- Tao bo index Markdown cho `2.LEGACY` va `0.RELEASE`.
- Giu file sinh ra/tool trong `1.WORK`; chi tao index doi chieu tai chinh folder can tham chieu.
- Toi uu lenh `0`: chi goi `TNT_SETTING`, `TNT:LAY:CREATE`, va init shortcut; khong goi `TNT_LAYER`. Giu `TNT_LAYER` lam lenh quet/sua rieng, bo tao layer lan 2 va chi ep ByLayer trong ModelSpace. `TNT_SHORTCUT` khong in bang shortcut nua.
- Sua log load package: doi `` `n[TNT]`` thanh `\n[TNT]` trong package 01-10 va chuan hoa thong bao `RV`.
- Harden command reactor trong `TNT_PACKAGE_00_SYSTEM_ALL.lsp`: doc ten lenh qua helper an toan va boc callback bang `vl-catch-all-apply` de tranh loi `bad argument type: fixnump: #<VLR-Command-Reactor>`.
- Tam tat command reactor mac dinh khi load package 00 (`*TNT.SYSTEM.ENABLE.COMMAND.REACTORS* = nil`) vi log van bao loi `fixnump: #<VLR-Command-Reactor>` truoc package 01. Cac reactor phu van giu ham init/off de bat lai sau neu can.
