# TNT ISO 2026 - Work History

- Created: 2026-05-27 16:40:21 +07:00
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
- Kiem tra loi copy block bang Ctrl+C/Ctrl+V bi nhay font ve Standard. Nguyen nhan kha nghi trong release la dimension create reset `STYLE Standard`; da bo cac lenh ghi de `Standard`, thay tao `.TNT_A_TXT_3_NOTE` bang `TNT:TS:ENSURE`, va sua `TNT_TS_SET` ve dung ten style `.TNT_A_TXT_*`.
- Tao `1.WORK/TNT_PC_AUTOCOPY.cmd` de copy toan bo `0.RELEASE` sang `Z:\0000.TNT_ISO_2026` bang robocopy, co log tai `1.WORK/TNT_PC_AUTOCOPY.log`.
- Doi `TNT_PC_AUTOCOPY.cmd` sang che do `/MIR` de NAS la ban release cuoi giong het `0.RELEASE`; co canh bao va yeu cau go `RELEASE` truoc khi xoa file thua o dich.
