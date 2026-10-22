# Ban Lisp AutoCAD 2014

Nguon: `../0.RELEASE`. Tai tao va kiem tra:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "1.WORK/TNT_Sync_Release14.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "1.WORK/TNT_Sync_Release14.ps1" -Check
```

Lisp duoc chuyen sang ASCII, tieng Viet khong dau de phu hop bo doc AutoLISP cu. Khong doi ten layer/block ASCII. Cac bien moi DIMLAYER, TEXTLAYER, MLEADERLAYER, COLORTHEME, STARTMODE, SELECTIONEFFECT, TEXTALLCAPS duoc bo khoi thiet lap; AutoCAD 2014 khong co day du cac tuy chon nay. Layer mac dinh cho DIM/TEXT/MLEADER cua ban moi khong duoc tu dong ap dung tren 2014; chon layer hien hanh hoac dung lenh chuyen layer TNT. RR tao rectangle roi dung REVCLOUD Object.

Nap cac package theo thu tu 00 den 11 bang APPLOAD; nap support Lisp khi can. Them thu muc nay vao Support File Search Path va Trusted Locations. Tranh nap dong thoi ban goc va ban 2014 trong cung ban ve vi trung ten lenh.

Font, CTB, tai lieu va script ho tro duoc sao chep. Khong sao chep DWG/BAK/VLX: chung can kiem tra/chuyen doi rieng, khong the chuyen dinh dang bang sua Lisp. TNT_AEC2014 van can san pham AEC/Object Enabler phu hop; AutoCAD thuong khong the giai ma proxy AEC doi moi.

AGENTS.md tai thu muc goc quy dinh dong bo sau moi lan sua 0.RELEASE. Script chay theo yeu cau, khong phai dich vu theo doi thay doi nen; thay doi bang ung dung ngoai can chay lai script. File bi xoa/doi ten can xu ly ban tuong ung thu cong.
