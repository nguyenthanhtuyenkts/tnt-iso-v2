# HÆ°á»›ng dáº«n lá»‡nh táº¯t TNT Architecture

TÃ i liá»‡u nÃ y tá»•ng há»£p cÃ¡c lá»‡nh cÃ³ trong bá»™ Lisp táº¡i thÆ° má»¥c `0.RELEASE`, Ä‘Æ°á»£c nhÃ³m theo chá»©c nÄƒng.

## CÃ¡ch sá»­ dá»¥ng chung

1. Náº¡p cÃ¡c file Lisp cá»§a bá»™ TNT vÃ o AutoCAD.
2. GÃµ lá»‡nh táº¡i command line rá»“i nháº¥n `Enter`.
3. LÃ m theo lá»i nháº¯c chá»n Ä‘á»‘i tÆ°á»£ng, chá»n Ä‘iá»ƒm hoáº·c nháº­p giÃ¡ trá»‹.
4. Nháº¥n `Esc` Ä‘á»ƒ há»§y lá»‡nh Ä‘ang cháº¡y.

> **LÆ°u Ã½:** Vá»›i nhÃ³m lá»‡nh chuyá»ƒn layer `N...`, cÃ³ thá»ƒ chá»n Ä‘á»‘i tÆ°á»£ng trÆ°á»›c rá»“i gá»i lá»‡nh. Náº¿u khÃ´ng chá»n Ä‘á»‘i tÆ°á»£ng, lá»‡nh chá»‰ Ä‘áº·t layer tÆ°Æ¡ng á»©ng thÃ nh layer hiá»‡n hÃ nh.

## 1. Khá»Ÿi táº¡o vÃ  há»‡ thá»‘ng

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `0` | Khá»Ÿi táº¡o toÃ n bá»™ mÃ´i trÆ°á»ng TNT | GÃµ `0` Ä‘á»ƒ Ã¡p dá»¥ng thiáº¿t láº­p há»‡ thá»‘ng, táº¡o dá»¯ liá»‡u chuáº©n vÃ  náº¡p láº¡i shortcut. NÃªn cháº¡y sau khi náº¡p bá»™ Lisp hoáº·c khi báº£n váº½ chÆ°a cÃ³ tiÃªu chuáº©n TNT. |
| `TNT_SETTING` | Ãp dá»¥ng thiáº¿t láº­p há»‡ thá»‘ng TNT | GÃµ lá»‡nh Ä‘á»ƒ thiáº¿t láº­p biáº¿n há»‡ thá»‘ng, giao diá»‡n, layer máº·c Ä‘á»‹nh cho Dim/Hatch vÃ  cÃ¡c cáº¥u hÃ¬nh chuáº©n. |
| `TNT_SHORTCUT` | Khá»Ÿi táº¡o láº¡i cÃ¡c lá»‡nh táº¯t | DÃ¹ng khi shortcut chÆ°a nháº­n hoáº·c sau khi náº¡p láº¡i `TNT_PACKAGE_11_SHORTCUT.lsp`. |
| `TNT_LAYER` | Chuáº©n hÃ³a layer toÃ n báº£n váº½ | Táº¡o/reset layer TNT, phÃ¢n loáº¡i Ä‘á»‘i tÆ°á»£ng vÃ  Ã©p thuá»™c tÃ­nh vá» `ByLayer` trÃªn cÃ¡c layer chuáº©n. NÃªn lÆ°u báº£n váº½ trÆ°á»›c khi cháº¡y. |
| `TNT` | Äá»“ng bá»™ Ä‘á»‘i tÆ°á»£ng theo tá»· lá»‡ khung | Chá»n khung Ä‘á»ƒ láº¥y tá»· lá»‡, sau Ä‘Ã³ chá»n block, line, polyline, circle, leader, text vÃ  dimension cáº§n Ä‘á»“ng bá»™. |

## 2. Shortcut AutoCAD cÆ¡ báº£n

| Lá»‡nh táº¯t | Lá»‡nh AutoCAD | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng |
|---|---|---|---|
| `C` | `COPY` | Sao chÃ©p Ä‘á»‘i tÆ°á»£ng | Chá»n Ä‘á»‘i tÆ°á»£ng, chá»n Ä‘iá»ƒm gá»‘c, chá»n Ä‘iá»ƒm Ä‘áº·t báº£n sao. |
| `M` | `MOVE` | Di chuyá»ƒn Ä‘á»‘i tÆ°á»£ng | Chá»n Ä‘á»‘i tÆ°á»£ng, chá»n Ä‘iá»ƒm gá»‘c, chá»n Ä‘iá»ƒm Ä‘Ã­ch. |
| `MM` | `MIRROR` | Äá»‘i xá»©ng Ä‘á»‘i tÆ°á»£ng | Chá»n Ä‘á»‘i tÆ°á»£ng, xÃ¡c Ä‘á»‹nh hai Ä‘iá»ƒm trá»¥c Ä‘á»‘i xá»©ng, chá»n cÃ³ xÃ³a báº£n gá»‘c hay khÃ´ng. |
| `R` | `ROTATE` | Xoay Ä‘á»‘i tÆ°á»£ng | Chá»n Ä‘á»‘i tÆ°á»£ng, chá»n tÃ¢m xoay, nháº­p gÃ³c hoáº·c dÃ¹ng tÃ¹y chá»n `Reference`. |
| `S` | `STRETCH` | KÃ©o giÃ£n Ä‘á»‘i tÆ°á»£ng | QuÃ©t chá»n crossing pháº§n cáº§n kÃ©o, chá»n Ä‘iá»ƒm gá»‘c vÃ  Ä‘iá»ƒm Ä‘Ã­ch. |
| `SC` | `SCALE` | Thay Ä‘á»•i tá»· lá»‡ | Chá»n Ä‘á»‘i tÆ°á»£ng, chá»n Ä‘iá»ƒm gá»‘c, nháº­p há»‡ sá»‘ hoáº·c dÃ¹ng `Reference`. |
| `CC` | `CIRCLE` | Váº½ Ä‘Æ°á»ng trÃ²n | Chá»n tÃ¢m rá»“i nháº­p bÃ¡n kÃ­nh/Ä‘Æ°á»ng kÃ­nh. |
| `ML` | `MLINE` | Váº½ Ä‘Æ°á»ng nhiá»u nÃ©t | GÃµ `ML`, chá»n cÃ¡c Ä‘iá»ƒm, nháº¥n `Enter` Ä‘á»ƒ káº¿t thÃºc. |
| `SPL` | `SPLINE` | Váº½ Ä‘Æ°á»ng cong spline | Chá»n láº§n lÆ°á»£t cÃ¡c Ä‘iá»ƒm Ä‘iá»u khiá»ƒn, nháº¥n `Enter` Ä‘á»ƒ káº¿t thÃºc. |
| `XX` | `XLINE` | Váº½ Ä‘Æ°á»ng dá»±ng vÃ´ háº¡n | Chá»n kiá»ƒu vÃ  cÃ¡c Ä‘iá»ƒm xÃ¡c Ä‘á»‹nh Ä‘Æ°á»ng dá»±ng. |
| `D` | `DIMLINEAR` | Ghi kÃ­ch thÆ°á»›c ngang/Ä‘á»©ng | Chá»n hai Ä‘iá»ƒm Ä‘o rá»“i Ä‘áº·t Ä‘Æ°á»ng kÃ­ch thÆ°á»›c. |
| `DD` | `DIMALIGNED` | Ghi kÃ­ch thÆ°á»›c xiÃªn | Chá»n hai Ä‘iá»ƒm Ä‘o rá»“i Ä‘áº·t Ä‘Æ°á»ng kÃ­ch thÆ°á»›c song song vá»›i phÆ°Æ¡ng Ä‘o. |
| `DC` | `DIMCONTINUE` | Ghi kÃ­ch thÆ°á»›c ná»‘i tiáº¿p | Chá»n kÃ­ch thÆ°á»›c gá»‘c náº¿u cáº§n, sau Ä‘Ã³ chá»n cÃ¡c Ä‘iá»ƒm tiáº¿p theo. |
| `DST` | `DIMSTYLE` | Má»Ÿ trÃ¬nh quáº£n lÃ½ Dimstyle | GÃµ `DST` Ä‘á»ƒ táº¡o, sá»­a hoáº·c Ä‘áº·t Dimstyle hiá»‡n hÃ nh. |
| `LL` | `DIMSTYLE` | Má»Ÿ trÃ¬nh quáº£n lÃ½ Dimstyle | Lá»‡nh Ä‘á»“ng nghÄ©a vá»›i `DST`. |

## 3. Quáº£n lÃ½ hiá»ƒn thá»‹ vÃ  layer

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `1` | CÃ´ láº­p layer (`LAYISO`) | Chá»n Ä‘á»‘i tÆ°á»£ng thuá»™c cÃ¡c layer cáº§n giá»¯ láº¡i; cÃ¡c layer khÃ¡c sáº½ bá»‹ áº©n/khÃ³a theo thiáº¿t láº­p AutoCAD. |
| `2` | Báº­t toÃ n bá»™ layer (`LAYON`) | GÃµ lá»‡nh Ä‘á»ƒ báº­t láº¡i táº¥t cáº£ layer Ä‘ang táº¯t. |
| `3` | Táº¯t layer (`LAYOFF`) | Chá»n Ä‘á»‘i tÆ°á»£ng thuá»™c layer cáº§n táº¯t. |
| `11` | Sá»­a block/Xref táº¡i chá»— (`REFEDIT`) | Chá»n block hoáº·c Xref cáº§n chá»‰nh sá»­a ngay trong báº£n váº½ hiá»‡n hÃ nh. |
| `22` | Káº¿t thÃºc sá»­a táº¡i chá»— (`REFCLOSE`) | GÃµ lá»‡nh rá»“i chá»n lÆ°u hoáº·c bá» thay Ä‘á»•i cá»§a phiÃªn `REFEDIT`. |
| `D1` | Chá»‰nh há»‡ sá»‘ Ä‘o kÃ­ch thÆ°á»›c `DIMLFAC` | GÃµ `D1`, nháº­p há»‡ sá»‘ Ä‘o má»›i; lá»‡nh Ä‘á»“ng thá»i Ä‘áº·t `DIMASZ = 1.1`. |
| `D2` | Chá»‰nh tá»· lá»‡ tá»•ng thá»ƒ `DIMSCALE` | GÃµ `D2`, nháº­p tá»· lá»‡ Dim má»›i; lá»‡nh Ä‘á»“ng thá»i Ä‘áº·t `DIMASZ = 1.1`. |

## 4. Chuyá»ƒn nhanh layer kiáº¿n trÃºc

| Lá»‡nh | Layer Ä‘Ã­ch | Chá»©c nÄƒng / CÃ¡ch dÃ¹ng |
|---|---|---|
| `NKH` | `....01_TNT_A_DRAWING` | Khung báº£n váº½. Chá»n trÆ°á»›c Ä‘á»‘i tÆ°á»£ng Ä‘á»ƒ chuyá»ƒn layer, hoáº·c gá»i lá»‡nh Ä‘á»ƒ Ä‘áº·t layer hiá»‡n hÃ nh. |
| `NT` | `....02_TNT_A_VIRTURAL` | NÃ©t tháº¥y. |
| `NM` | `....03_TNT_A_THIN` | NÃ©t máº£nh. |
| `NK` | `....04_TNT_A_HIDDEN` | NÃ©t khuáº¥t. |
| `NC` | `....05_TNT_A_SECTION` | NÃ©t cáº¯t. |
| `NSL` | `....06_TNT_A_SECTION-LINE` | Trá»¥c/Ä‘Æ°á»ng chá»‰ máº·t cáº¯t. |
| `NTR` | `....07_TNT_A_BASE` | NÃ©t trá»¥c hoáº·c Ä‘Æ°á»ng cÆ¡ sá»Ÿ. |
| `NDE` | `....08_TNT_A_DETAIL` | NÃ©t chi tiáº¿t. |
| `NCOM` | `....09_TNT_A_COMPLETE` | NÃ©t hoÃ n thiá»‡n. |
| `NCOT` | `....10_TNT_A_COTE` | Cao Ä‘á»™/cá»‘t. |
| `NPL` | `....11_TNT_A_PLOT` | NÃ©t phá»¥c vá»¥ in/khung plot. |

## 5. Chuyá»ƒn nhanh layer ná»™i tháº¥t vÃ  káº¿t cáº¥u

| Lá»‡nh | Layer Ä‘Ã­ch | Chá»©c nÄƒng / CÃ¡ch dÃ¹ng |
|---|---|---|
| `NNT` | `....12_TNT_F_FURNITURE` | Ná»™i tháº¥t. Chá»n trÆ°á»›c Ä‘á»‘i tÆ°á»£ng Ä‘á»ƒ chuyá»ƒn layer, hoáº·c gá»i lá»‡nh Ä‘á»ƒ Ä‘áº·t layer hiá»‡n hÃ nh. |
| `NCC` | `....13_TNT_F_TREE` | CÃ¢y xanh. |
| `NGL` | `....14_TNT_F_GLASS` | KÃ­nh. |
| `NDO` | `....15_TNT_F_DOOR` | Cá»­a. |
| `NCON` | `....16_TNT_S_CONCRETE` | BÃª tÃ´ng/BÃª tÃ´ng cá»‘t thÃ©p. |
| `NWA` | `....17_TNT_S_WALL` | TÆ°á»ng. |

## 6. Chuyá»ƒn nhanh layer ghi chÃº

| Lá»‡nh | Layer Ä‘Ã­ch | Chá»©c nÄƒng / CÃ¡ch dÃ¹ng |
|---|---|---|
| `NTE` | `....20_TNT_N_TEXT` | Text/chá»¯. Chá»n trÆ°á»›c Ä‘á»‘i tÆ°á»£ng Ä‘á»ƒ chuyá»ƒn layer, hoáº·c gá»i lá»‡nh Ä‘á»ƒ Ä‘áº·t layer hiá»‡n hÃ nh. |
| `NLE` | `....21_TNT_N_LEADER` | Leader/Ä‘Æ°á»ng dáº«n ghi chÃº. |
| `NDI` | `....22_TNT_N_DIMENSION` | Dimension/kÃ­ch thÆ°á»›c. |
| `NHA` | `....23_TNT_N_HATCH` | Hatch/váº­t liá»‡u. |
| `NAN` | `....24_TNT_N_ANNOTATE` | KÃ½ hiá»‡u vÃ  chÃº thÃ­ch khÃ¡c. |

## 7. Váº½ vÃ  hiá»‡u chá»‰nh hÃ¬nh há»c

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `VBB` | Táº¡o khung plot quanh block khung tÃªn | Chá»n cÃ¡c block khung tÃªn; lá»‡nh táº¡o rectangle bao ngoÃ i trÃªn layer `....11_TNT_A_PLOT`. |
| `NC1` | Váº½ kÃ½ hiá»‡u Ä‘Æ°á»ng cáº¯t dáº¡ng zÃ­c-záº¯c | Chá»n Ä‘iá»ƒm Ä‘áº§u vÃ  Ä‘iá»ƒm cuá»‘i; lá»‡nh tá»± táº¡o polyline kÃ½ hiá»‡u á»Ÿ giá»¯a Ä‘oáº¡n. |
| `CLD` | Táº¡o revision cloud hÃ¬nh chá»¯ nháº­t | Chá»n hai gÃ³c chá»¯ nháº­t, nháº­p bÃ¡n kÃ­nh cung; lá»‡nh chuyá»ƒn rectangle thÃ nh revision cloud. |
| `RV` | Táº¡o/chuyá»ƒn Ä‘á»•i revision cloud | Chá»n `New`, `Select` hoáº·c `Change`; cÃ³ thá»ƒ Ä‘áº·t bÃ¡n kÃ­nh cung vÃ  bá» rá»™ng nÃ©t. |
| `ZZ` | Táº¡o revision cloud kiá»ƒu Calligraphy | Chá»n hai gÃ³c chá»¯ nháº­t; lá»‡nh táº¡o cloud vá»›i bÃ¡n kÃ­nh cung máº·c Ä‘á»‹nh `500`. |
| `WQ1` | Táº¡o Wipeout theo biÃªn Ä‘á»‘i tÆ°á»£ng | Chá»n Circle, Ellipse hoáº·c Polyline; sau Ä‘Ã³ chá»n cÃ³ xÃ³a Ä‘Æ°á»ng biÃªn nguá»“n hay khÃ´ng. |
| `DTM` | TÃ­nh vÃ  ghi diá»‡n tÃ­ch mÂ² | Chá»n `Pick` Ä‘á»ƒ báº¥m trong vÃ¹ng kÃ­n, `Select` Ä‘á»ƒ cá»™ng diá»‡n tÃ­ch Ä‘á»‘i tÆ°á»£ng, hoáº·c `Settings` Ä‘á»ƒ chá»‰nh há»‡ sá»‘, sá»‘ láº» vÃ  chiá»u cao chá»¯. |

## 8. Quáº£n lÃ½ vÃ  sáº¯p xáº¿p Ä‘á»‘i tÆ°á»£ng

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `VC` | Di chuyá»ƒn tÃ¢m nhÃ³m Ä‘á»‘i tÆ°á»£ng Ä‘áº¿n má»™t Ä‘iá»ƒm | Chá»n nhÃ³m Ä‘á»‘i tÆ°á»£ng, sau Ä‘Ã³ chá»n Ä‘iá»ƒm Ä‘Ã­ch; lá»‡nh láº¥y tÃ¢m bounding box lÃ m Ä‘iá»ƒm gá»‘c di chuyá»ƒn. |
| `VC1` | ÄÆ°a Ä‘á»‘i tÆ°á»£ng vÃ o tÃ¢m má»™t vÃ¹ng kÃ­n | Chá»n Ä‘á»‘i tÆ°á»£ng cáº§n di chuyá»ƒn, sau Ä‘Ã³ báº¥m Ä‘iá»ƒm bÃªn trong vÃ¹ng kÃ­n Ä‘Ã­ch. |
| `VC2` | Biáº¿n thá»ƒ cÄƒn tÃ¢m nhÃ³m Ä‘á»‘i tÆ°á»£ng | Chá»n nhÃ³m Ä‘á»‘i tÆ°á»£ng vÃ  lÃ m theo lá»i nháº¯c chá»n vá»‹ trÃ­ Ä‘Ã­ch; dÃ¹ng tÃ¢m bounding box cá»§a nhÃ³m. |
| `VR1` | Xoay hÆ°á»›ng nhÃ¬n theo ba Ä‘iá»ƒm | Chá»n tÃ¢m, phÆ°Æ¡ng hiá»‡n táº¡i vÃ  phÆ°Æ¡ng má»›i; lá»‡nh xoay UCS/PLAN nhÆ°ng giá»¯ vÃ¹ng nhÃ¬n. |
| `VR2` | Xoay hÆ°á»›ng nhÃ¬n `+90Â°` | GÃµ lá»‡nh Ä‘á»ƒ xoay UCS quanh trá»¥c Z vÃ  cáº­p nháº­t PLAN. |
| `VR3` | Xoay hÆ°á»›ng nhÃ¬n `-90Â°` | GÃµ lá»‡nh Ä‘á»ƒ xoay UCS quanh trá»¥c Z vÃ  cáº­p nháº­t PLAN. |
| `VRR` | Tráº£ hÆ°á»›ng nhÃ¬n vá» World | Äáº·t UCS vÃ  PLAN vá» há»‡ tá»a Ä‘á»™ World. |
| `STT` | ÄÃ¡nh sá»‘ thá»© tá»± Text, Attribute, Dimension | Má»Ÿ há»™p thoáº¡i, Ä‘áº·t tiá»n tá»‘/háº­u tá»‘/sá»‘ báº¯t Ä‘áº§u vÃ  chá»n Ä‘á»‘i tÆ°á»£ng cáº§n Ä‘Ã¡nh sá»‘. |

## 9. Text vÃ  ghi chÃº

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `T1` | Sao chÃ©p ná»™i dung Text/Dimension | Chá»n má»™t Text/Dimension nguá»“n, sau Ä‘Ã³ chá»n cÃ¡c Text/Dimension Ä‘Ã­ch. |
| `TA` | CÄƒn chá»‰nh nhiá»u Text | Chá»n hÆ°á»›ng `TRÃI`, `PHáº¢I`, `LÃŠN`, `XUá»NG`, `GIá»®A-NGANG` hoáº·c `GIá»®A-Dá»ŒC`, rá»“i chá»n cÃ¡c text vÃ  vá»‹ trÃ­ chuáº©n. |
| `FT` | CÄƒn lá» text theo text máº«u | Chá»n cÃ¡c text cáº§n xá»­ lÃ½, chá»n text chuáº©n, sau Ä‘Ã³ chá»n kiá»ƒu `Left`, `Center`, `Right` hoáº·c `Fit`. |
| `DF` | DÃ n Ä‘á»u text theo phÆ°Æ¡ng Y | Chá»n text, nháº­p khoáº£ng cÃ¡ch, rá»“i chá»n text chuáº©n Ä‘á»ƒ giá»¯ má»‘c. |
| `DFX` | DÃ n Ä‘á»u text theo phÆ°Æ¡ng X | Chá»n text, nháº­p khoáº£ng cÃ¡ch, rá»“i chá»n text chuáº©n Ä‘á»ƒ giá»¯ má»‘c. |
| `DX` | CÄƒn cÃ¡c Text tháº³ng hÃ ng theo Y | Chá»n cÃ¡c Text, sau Ä‘Ã³ chá»n Text chuáº©n cÃ³ tung Ä‘á»™ cáº§n dÃ¹ng. |
| `MAT` | Sao chÃ©p ná»™i dung giá»¯a cÃ¡c Ä‘á»‘i tÆ°á»£ng chá»¯ | Chá»n Ä‘á»‘i tÆ°á»£ng nguá»“n, rá»“i chá»n cÃ¡c Ä‘á»‘i tÆ°á»£ng Ä‘Ã­ch cÃ³ há»— trá»£ ná»™i dung chá»¯. |
| `TS1` | Ãp dá»¥ng Textstyle chÃ­nh | Chá»n Text/MText cáº§n Ä‘á»•i sang `.TNT_A_TXT_1_MAIN`. |
| `TS2` | Ãp dá»¥ng Textstyle phá»¥ | Chá»n Text/MText cáº§n Ä‘á»•i sang `.TNT_A_TXT_2_SUB`. |
| `TS3` | Ãp dá»¥ng Textstyle ghi chÃº | Chá»n Text/MText cáº§n Ä‘á»•i sang `.TNT_A_TXT_3_NOTE`. |
| `BMASK` | Chá»‰nh background mask | Chá»n MText, MLeader hoáº·c Dimension; thiáº¿t láº­p tráº¡ng thÃ¡i, khoáº£ng há»Ÿ vÃ  mÃ u ná»n trong há»™p thoáº¡i. |
| `ED2` | Sá»­a nhanh ná»™i dung chá»¯/attribute | Chá»n `ATTRIB`, `TEXT`, `MTEXT` hoáº·c `DIMENSION`; sá»­a ná»™i dung trong há»™p thoáº¡i, tiáº¿p tá»¥c chá»n Ä‘á»‘i tÆ°á»£ng khÃ¡c hoáº·c nháº¥n `Esc`. |

## 10. Leader

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `A1` | CÄƒn Text/MText theo Leader | Chá»n Text/MText vÃ  Leader theo lá»i nháº¯c Ä‘á»ƒ Ä‘Æ°a chá»¯ vá» Ä‘Ãºng vá»‹ trÃ­ Ä‘áº§u Leader. |
| `A2` | Chá»‰nh Ä‘á»“ng loáº¡t gÃ³c Leader | Chá»n cÃ¡c Leader, sau Ä‘Ã³ xÃ¡c Ä‘á»‹nh hÆ°á»›ng/gÃ³c má»›i. |
| `A3` | Gom Ä‘áº§u Leader vÃ  Text theo má»™t vá»‹ trÃ­ | Chá»n Leader cÃ¹ng Text, sau Ä‘Ã³ chá»n Ä‘iá»ƒm cuá»‘i Leader má»›i. |
| `A4` | Chá»‰nh Ä‘oáº¡n cuá»‘i Leader náº±m ngang | Chá»n cÃ¡c Leader cáº§n hiá»‡u chá»‰nh; lá»‡nh Ä‘Æ°a Ä‘oáº¡n ná»‘i vá»›i chá»¯ vá» phÆ°Æ¡ng ngang. |

## 11. Dimension

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `SD1` | Ãp dá»¥ng Dimstyle `.TNT_A_DIM_1` | Chá»n Dimension/Leader Ä‘á»ƒ Ä‘á»•i style; nháº¥n `Enter` khi khÃ´ng chá»n Ä‘á»ƒ Ä‘áº·t style nÃ y hiá»‡n hÃ nh. |
| `SD2` | Ãp dá»¥ng Dimstyle `.TNT_A_DIM_2` | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `SD1`. |
| `SD3` | Ãp dá»¥ng Dimstyle `.TNT_A_DIM_3` | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `SD1`. |
| `D3` | Äá»“ng bá»™ tá»· lá»‡ theo Ä‘á»‘i tÆ°á»£ng máº«u | Chá»n Block, Dimension, Text hoáº·c Leader máº«u Ä‘á»ƒ láº¥y vÃ  Ã¡p dá»¥ng thÃ´ng sá»‘ tá»· lá»‡ liÃªn quan. |
| `D4` | Chá»‰nh khoáº£ng cÃ¡ch cÃ¡c Ä‘Æ°á»ng Dimension | Chá»n cÃ¡c Dimension vÃ  lÃ m theo lá»i nháº¯c Ä‘á»ƒ sáº¯p xáº¿p khoáº£ng cÃ¡ch. |
| `D5` | Äáº·t tá»· lá»‡/giÃ¡ trá»‹ scale cho Dimension | Nháº­p tá»· lá»‡, chá»n cÃ¡c Dimension; lá»‡nh cáº­p nháº­t há»‡ sá»‘ vÃ  xÃ³a text override cÅ©. |
| `CD` | Cáº¯t hoáº·c kÃ©o dÃ i Ä‘Æ°á»ng giÃ³ng Dimension | Chá»n cÃ¡c Dimension rá»“i chá»n Ä‘iá»ƒm chuáº©n cáº¯t/kÃ©o. |
| `BD` | DÃ³ng/cÄƒn cÃ¡c Dimension theo Ä‘iá»ƒm chá»n | Chá»n cÃ¡c Dimension rá»“i chá»n Ä‘iá»ƒm chuáº©n Ä‘á»ƒ Ä‘Æ°a Ä‘Æ°á»ng kÃ­ch thÆ°á»›c vá» cÃ¹ng vá»‹ trÃ­. |
| `AD` | CÄƒn chá»‰nh Dimension tá»± Ä‘á»™ng | Chá»n nhÃ³m Dimension theo lá»i nháº¯c; lá»‡nh gá»i bá»™ cÄƒn chá»‰nh `ADIM` vÃ  khÃ´i phá»¥c `DIMSCALE`. |
| `ADIM` | CÃ´ng cá»¥ cÄƒn Dimension nÃ¢ng cao | Chá»n cÃ¡c Dimension cáº§n phÃ¢n loáº¡i vÃ  sáº¯p xáº¿p; dÃ¹ng trá»±c tiáº¿p khi cáº§n Ä‘áº§y Ä‘á»§ tÃ¹y chá»n cá»§a bá»™ cÄƒn Dim. |
| `LB1` | Kiá»ƒm tra kÃ­ch thÆ°á»›c theo thÆ°á»›c Lá»— Ban 52.2 cm | Chá»n Dimension; lá»‡nh thÃªm káº¿t quáº£ `(tá»‘t)` hoáº·c `(xáº¥u)` vÃ o ná»™i dung kÃ­ch thÆ°á»›c. |
| `LB2` | Kiá»ƒm tra kÃ­ch thÆ°á»›c theo thÆ°á»›c Lá»— Ban 42.9 cm | Chá»n Dimension; lá»‡nh thÃªm káº¿t quáº£ `(tá»‘t)` hoáº·c `(xáº¥u)`. |
| `LB3` | Kiá»ƒm tra kÃ­ch thÆ°á»›c theo thÆ°á»›c Lá»— Ban 38.8 cm | Chá»n Dimension; lá»‡nh thÃªm káº¿t quáº£ `(tá»‘t)` hoáº·c `(xáº¥u)`. |

## 12. Hatch

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `H25` | Táº¡o Hatch mÃ u 250 | GÃµ lá»‡nh rá»“i chá»n Ä‘iá»ƒm/Ä‘á»‘i tÆ°á»£ng theo quy trÃ¬nh `-HATCH`. |
| `H251` | Táº¡o Hatch mÃ u 251 | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `H25`. |
| `H252` | Táº¡o Hatch mÃ u 252 | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `H25`. |
| `H253` | Táº¡o Hatch mÃ u 253 | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `H25`. |
| `H254` | Táº¡o Hatch mÃ u 254 | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `H25`. |
| `H255` | Táº¡o Hatch mÃ u 255 | CÃ¡ch dÃ¹ng tÆ°Æ¡ng tá»± `H25`. |
| `HB` | ÄÆ°a Hatch xuá»‘ng dÆ°á»›i biÃªn | Chá»n Hatch cáº§n Ä‘á»•i draw order. |
| `HF` | ÄÆ°a Hatch lÃªn trÆ°á»›c biÃªn | Chá»n Hatch cáº§n Ä‘á»•i draw order. |
| `HC` | Sao chÃ©p máº«u Hatch sang vÃ¹ng khÃ¡c | Chá»n Hatch máº«u, sau Ä‘Ã³ báº¥m Ä‘iá»ƒm trong vÃ¹ng cáº§n hatch. |
| `HV` | Di chuyá»ƒn/táº¡o láº¡i Hatch theo vÃ¹ng má»›i | Chá»n Hatch máº«u rá»“i báº¥m vÃ¹ng Ä‘Ã­ch; lá»‡nh giá»¯ máº«u, gÃ³c, tá»· lá»‡ vÃ  layer. |
| `HS` | Äá»•i tá»· lá»‡ Hatch | Chá»n Hatch, nháº­p tá»· lá»‡ má»›i. |
| `HA` | Äá»•i gÃ³c Hatch | Chá»n Hatch, nháº­p hoáº·c chá»‰ gÃ³c má»›i. |
| `HT` | Chia Hatch báº±ng Ä‘Æ°á»ng cáº¯t | Chá»n Line/Polyline cáº¯t, sau Ä‘Ã³ chá»n Hatch táº¡i phÃ­a cáº§n xá»­ lÃ½. |
| `HG` | Äá»•i origin cá»§a Hatch | Chá»n má»™t hoáº·c nhiá»u Hatch, sau Ä‘Ã³ chá»n Ä‘iá»ƒm origin má»›i. |
| `HSE` | Báº­t/táº¯t báº¯t Ä‘iá»ƒm trÃªn Hatch | Chuyá»ƒn Ä‘á»•i biáº¿n `OSNAPHATCH` giá»¯a `0` vÃ  `1`. |
| `HSA` | Táº¯t liÃªn káº¿t Associative cá»§a Hatch | Chá»n cÃ¡c Hatch cáº§n tÃ¡ch khá»i Ä‘Æ°á»ng biÃªn. |
| `RHB` | Táº¡o láº¡i Ä‘Æ°á»ng biÃªn Hatch | Chá»n Hatch; lá»‡nh táº¡o boundary dáº¡ng Polyline vÃ  giá»¯ liÃªn káº¿t náº¿u AutoCAD há»— trá»£. |

## 13. Block vÃ  Attribute

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `B0` | ÄÆ°a hÃ¬nh há»c trong block vá» layer `0` | Chá»n block cáº§n chuáº©n hÃ³a; lá»‡nh xá»­ lÃ½ cáº£ block lá»“ng. NÃªn lÆ°u báº£n váº½ trÆ°á»›c khi cháº¡y. |
| `CBP` | Äá»•i base point, giá»¯ nguyÃªn tá»a Ä‘á»™ insertion | Chá»n block rá»“i chá»n base point má»›i; vá»‹ trÃ­ tham chiáº¿u block cÃ³ thá»ƒ thay Ä‘á»•i theo base point. |
| `B3` | Äá»•i base point, giá»¯ nguyÃªn vá»‹ trÃ­ block trÃªn báº£n váº½ | Chá»n block rá»“i chá»n base point má»›i; cÃ¡c block reference Ä‘Æ°á»£c bÃ¹ vá»‹ trÃ­ Ä‘á»ƒ khÃ´ng dá»‹ch chuyá»ƒn hÃ¬nh há»c. |
| `MAB` | Thay nhiá»u block báº±ng block máº«u | Chá»n block thay tháº¿, sau Ä‘Ã³ chá»n cÃ¡c block cáº§n thay; giá»¯ vá»‹ trÃ­ Ä‘Ã­ch nhÆ°ng dÃ¹ng rotation vÃ  scale cá»§a block máº«u. |
| `MABT` | Sao chÃ©p Attribute theo Tag | Chá»n block nguá»“n cÃ³ Attribute, sau Ä‘Ã³ chá»n cÃ¡c block Ä‘Ã­ch; chá»‰ cÃ¡c Tag trÃ¹ng nhau Ä‘Æ°á»£c cáº­p nháº­t. |
| `RB` | Äá»•i tÃªn block | Chá»n block reference, nháº­p tÃªn má»›i; Ä‘á»•i tÃªn definition hiá»‡n cÃ³. |
| `CB` | Sao chÃ©p block thÃ nh tÃªn má»›i | Chá»n block reference, nháº­p tÃªn má»›i; táº¡o definition má»›i vÃ  giá»¯ definition cÅ©. |
| `AT1` | ChÃ©p toÃ n bá»™ Attribute giá»¯a hai block | Chá»n block nguá»“n rá»“i block Ä‘Ã­ch; giÃ¡ trá»‹ Ä‘Æ°á»£c chÃ©p theo thá»© tá»± Attribute. |
| `AT2` | ChÃ©p Text vÃ o Attribute cÃ¹ng Tag | Chá»n Attribute máº«u Ä‘á»ƒ láº¥y Tag, chá»n Text nguá»“n, sau Ä‘Ã³ chá»n block Ä‘Ã­ch táº¡i Ä‘iá»ƒm chá»‰. |
| `B1` | Äá»•i Visibility State cá»§a Dynamic Block | Chá»n Dynamic Block rá»“i chá»n tráº¡ng thÃ¡i hiá»ƒn thá»‹ trong danh sÃ¡ch. |
| `CA` | Cáº­p nháº­t cao Ä‘á»™ Attribute hÃ ng loáº¡t | Chá»n Attribute cao Ä‘á»™ máº«u trong block, sau Ä‘Ã³ chá»n cÃ¡c block cáº§n tÃ­nh/cáº­p nháº­t theo tá»a Ä‘á»™. |
| `MATB` | Sao chÃ©p style/thuá»™c tÃ­nh trÃ¬nh bÃ y block | Chá»n block nguá»“n rá»“i cÃ¡c block Ä‘Ã­ch Ä‘á»ƒ Ã¡p dá»¥ng báº£n Ä‘á»“ thuá»™c tÃ­nh/style tÆ°Æ¡ng á»©ng. |
| `SSC` | Ghi/khÃ´i phá»¥c bá»™ style hiá»‡n hÃ nh | Cháº¡y lá»‡nh Ä‘á»ƒ láº¥y vÃ  Ã¡p dá»¥ng tráº¡ng thÃ¡i style hiá»‡n hÃ nh Ä‘Ã£ lÆ°u trong Registry. |
| `ASC` | Äá»“ng bá»™ thuá»™c tÃ­nh/style theo Ä‘á»‘i tÆ°á»£ng | Chá»n Ä‘á»‘i tÆ°á»£ng theo lá»i nháº¯c Ä‘á»ƒ Ã¡p dá»¥ng cÃ¡c thuá»™c tÃ­nh nhÆ° layer, mÃ u, linetype, lineweight vÃ  style liÃªn quan. |

## 14. Chuyá»ƒn Ä‘á»•i báº£n váº½ cÅ©

CÃ¡c lá»‡nh nÃ y náº±m trong `TNT_SUPPORT_LISP` vÃ  chá»‰ dÃ¹ng khi Ä‘Ã£ náº¡p file há»— trá»£ tÆ°Æ¡ng á»©ng.

| Lá»‡nh | Chá»©c nÄƒng | CÃ¡ch dÃ¹ng / Ghi chÃº |
|---|---|---|
| `TNT_LAYER_SYNC_ALL` | Chuyá»ƒn toÃ n bá»™ layer V16 cÅ© sang layer TNT ISO | Cháº¡y trÃªn báº£n sao hoáº·c sau khi lÆ°u file; lá»‡nh chuyá»ƒn Ä‘á»‘i tÆ°á»£ng, block definition vÃ  cá»‘ gáº¯ng xÃ³a layer cÅ©. |
| `TNT_LAYER_SYNC_SELECTION` | Chuyá»ƒn layer V16 cho vÃ¹ng chá»n | Chá»n cÃ¡c Ä‘á»‘i tÆ°á»£ng cáº¥p cao nháº¥t cáº§n chuyá»ƒn; phÃ¹ há»£p khi khÃ´ng muá»‘n xá»­ lÃ½ toÃ n báº£n váº½. |
| `TNT_MIGRATE_DIMSTYLE` | Chuyá»ƒn Dimstyle cÅ© sang chuáº©n má»›i | Chuyá»ƒn `TNT_DIM`, `TNT_DIM1`, `TNT_DIM2` sang `.TNT_A_DIM_1`, `.TNT_A_DIM_2`, `.TNT_A_DIM_3` vÃ  cá»‘ gáº¯ng xÃ³a style cÅ©. |

## Ghi chÃº an toÃ n

| TÃ¬nh huá»‘ng | Khuyáº¿n nghá»‹ |
|---|---|
| Lá»‡nh khÃ´ng nháº­n | Cháº¡y `0` hoáº·c `TNT_SHORTCUT`, kiá»ƒm tra file Lisp tÆ°Æ¡ng á»©ng Ä‘Ã£ Ä‘Æ°á»£c náº¡p. |
| Layer/style chuáº©n chÆ°a tá»“n táº¡i | Cháº¡y `0`, `TNT_SETTING` hoáº·c `TNT_LAYER` trÆ°á»›c. |
| Xá»­ lÃ½ hÃ ng loáº¡t block/layer | LÆ°u báº£n váº½ hoáº·c táº¡o báº£n sao trÆ°á»›c khi dÃ¹ng `B0`, `MAB`, `TNT_LAYER` vÃ  cÃ¡c lá»‡nh `TNT_MIGRATE_*`. |
| Káº¿t quáº£ khÃ´ng Ä‘Ãºng mong muá»‘n | DÃ¹ng `UNDO` ngay sau lá»‡nh; pháº§n lá»›n lá»‡nh TNT Ä‘Ã£ gom thao tÃ¡c vÃ o má»™t nhÃ³m Undo. |
