;;; ====================================================================================================
;;; ---------------------------------- J_010_FUNCTION_CREATE_TEXTSTYLE ---------------------------------
;;; ====================================================================================================
;;; * FILE    : J_010_FUNCTION_CREATE_TEXTSTYLE
;;; * PURPOSE : Tạo/cập nhật TEXTSTYLE an toàn cho
;;;   - SHX: uromans.shx
;;;   - TTF: UNI HelvetIns (H),
;;;   - TTF: UNI Alter Gothic (H)
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; * LƯU Ý:
;;;   - TTF: dùng vla-SetFont với Family Name; KHÔNG gán BigFont.
;;;   - SHX: gán FontFile (đường dẫn hoặc tên file); BigFont nếu cần.
;;; ====================================================================================================
;;; ------------------------------------ [0] APPLICATION / SIGNATURE -----------------------------------
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; -------------------------------------- [2] HÀM TẠO TEXT STYLE --------------------------------------
;;; ====================================================================================================
(defun 010_TEXTSTYLE_CREATE (/)
  (010:SYS:RUN-SAFE (function 010:TS:MAKE-ALL))
  (princ)
)
;;; ====================================================================================================
;;; ---------------------- [3] FS — SAFE HELPERS (NHÓM HÀM AN TOÀN “FILE/SYSTEM”) ----------------------
;;; ====================================================================================================
;; 010:FS:SAFE-PUT (POBJ PPROP PVAL)
;; GÁN THUỘC TÍNH COM VỚI VLAX-PUT-PROPERTY NHƯNG BỌC LỖI BẰNG VL-CATCH-ALL-APPLY.
;; NẾU LỖI → IN CẢNH BÁO [010] WARN: PUT ... FAILED.; LUÔN TRẢ LẠI POBJ.
(defun 010:FS:SAFE-PUT (POBJ PPROP PVAL / LERR)
  (if (and POBJ PPROP)
    (progn
      (setq LERR (vl-catch-all-apply
                    (function (lambda () (vlax-put-property POBJ PPROP PVAL))) '()))
      (if (vl-catch-all-error-p LERR)
        (princ (strcat "\n[010] WARN: put " (vl-princ-to-string PPROP) " failed.")))))
  POBJ
)
;; 010:FS:SAFE-CALL (POBJ PMETHOD ARGS)
;; GỌI PHƯƠNG THỨC COM (VÍ DỤ VLA-SETFONT) AN TOÀN.
;; LỖI → IN TOÀN VĂN THÔNG BÁO; TRẢ VỀ T NẾU THÀNH CÔNG, NIL NẾU LỖI.
(defun 010:FS:SAFE-CALL (POBJ PMETHOD ARGS / LERR)
  (setq LERR (vl-catch-all-apply
              (function (lambda () (apply PMETHOD (cons POBJ ARGS)))) '()))
  (if (vl-catch-all-error-p LERR)
    (progn (princ (strcat "\n[010] WARN: call failed → " (vl-catch-all-error-message LERR))) nil)
    T)
)
;; 010:FS:STR-LOWER (S)
;; ĐƯA CHUỖI VỀ CHỮ THƯỜNG (DÙNG CHO SO SÁNH/MATCH).
(defun 010:FS:STR-LOWER (S)
  (vl-string-translate "ABCDEFGHIJKLMNOPQRSTUVWXYZ" "abcdefghijklmnopqrstuvwxyz"
                       (vl-princ-to-string S))
)
;; 010:FS:EXT (S)
;; LẤY PHẦN ĐUÔI MỞ RỘNG SAU DẤU CHẤM CUỐI (TRẢ VỀ CHUỖI CHỮ THƯỜNG; NẾU KHÔNG CÓ CHẤM → "").
(defun 010:FS:EXT (S / P L)
  (setq L (010:FS:STR-LOWER (vl-princ-to-string S)))
  (if (and L (setq P (vl-string-search "." L (- (strlen L) 1))))
    (substr L (1+ P))
    ""
  )
)
;; 010:FS:WINFONTS-PATH ()
;; TRẢ VỀ THƯ MỤC WINDOWS FONTS, ƯU TIÊN TỪ BIẾN MÔI TRƯỜNG WINDIR.
(defun 010:FS:WINFONTS-PATH (/ W)
  (setq W (getenv "WINDIR"))
  (if (and W (/= W "")) (strcat W "\\Fonts\\") "C:\\Windows\\Fonts\\")
)
;; 010:FS:IS-TTF (PFONT_OR_FACE)
;; TRẢ VỀ T NẾU ĐUÔI LÀ "TTF". (TRONG MÃ BÊN DƯỚI THỰC TẾ DÙNG WCMATCH "*.TTF" THAY VÌ HÀM NÀY.)
(defun 010:FS:IS-TTF (PFONT_OR_FACE)
  (= (010:FS:EXT PFONT_OR_FACE) "ttf")
)
;; 010:FS:FIND-FONTFILE (PFONT)
;; THỬ TÌM ĐƯỜNG DẪN THẬT CỦA FILE FONT (ƯU TIÊN FINDFILE Ở SUPPORT PATH, ACADPREFIX, RỒI WINDOWS\FONTS). 
;; NẾU KHÔNG TÌM THẤY, TRẢ VỀ NGUYÊN TÊN ĐƯỢC TRUYỀN VÀO.
(defun 010:FS:FIND-FONTFILE (PFONT / CAND)
  ;; TÌM FILE FONT NẾU PFONT LÀ TÊN FILE (CHỦ YẾU CHO SHX)
  (setq CAND
    (vl-remove nil
      (list
        (findfile PFONT)
        (findfile (strcat (getvar "ACADPREFIX") PFONT))
        (findfile (strcat (010:FS:WINFONTS-PATH) PFONT))
      )))
  (if CAND (car CAND) PFONT)
)
;;; ====================================================================================================
;;; ---------------------------------- [4] TS — TẠO/ĐẢM BẢO TEXTSTYLE ----------------------------------
;;; ====================================================================================================
;; 010:TS:GET-COLL ()
;; LẤY TEXTSTYLES COLLECTION TỪ TÀI LIỆU HIỆN HÀNH:
;; VLA-GET-TEXTSTYLES (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)).
(defun 010:TS:GET-COLL (/)
  (vla-get-TextStyles (vla-get-ActiveDocument (vlax-get-acad-object)))
)
;; 010:TS:ENSURE (PNAME PFONT_OR_FACE PH PW POBL PBIG / ...)
;; MỤC TIÊU: “TỒN TẠI-HÓA” 1 TEXTSTYLE TÊN PNAME. NẾU CHƯA CÓ → VLA-ADD, CÓ RỒI → LẤY OBJECT HIỆN HỮU.
;; GÁN THUỘC TÍNH CHUNG:
;; - HEIGHT       = PH    (MẶC ĐỊNH 0.0)
;; - WIDTH        = PW    (MẶC ĐỊNH 1.0)
;; - OBLIQUEANGLE = POBL  (ĐỘ → RAD)
(defun 010:TS:ENSURE (PNAME PFONT_OR_FACE PH PW POBL PBIG / LCOLL LSTY LLOW LFONTPATH)
;; PFONT_OR_FACE:
;;   - NẾU KẾT THÚC .SHX/.TTF -> COI NHƯ TÊN FILE.
;;   - NẾU KHÔNG CÓ ĐUÔI -> COI NHƯ TTF FAMILY NAME (DÙNG VLA-SETFONT).
  (setq LCOLL (010:TS:GET-COLL))
  (setq LSTY  (if (tblsearch "style" PNAME)
                (vlax-ename->vla-object (tblobjname "style" PNAME))
                (vla-Add LCOLL PNAME)))

  (010:FS:SAFE-PUT LSTY 'Height (abs (if PH PH 0.0)))
  (010:FS:SAFE-PUT LSTY 'Width  (if PW PW 1.0))
  (010:FS:SAFE-PUT LSTY 'ObliqueAngle (* pi (/ (abs (if POBL POBL 0.0)) 180.0)))

  (setq LLOW (010:FS:STR-LOWER PFONT_OR_FACE))
;; NHẬN DẠNG LOẠI FONT BẰNG LLOW = LOWER (PFONT_OR_FACE) VÀ COND:
;; 1. SHX (WCMATCH "*.SHX")
;; - TÌM ĐƯỜNG DẪN THẬT LFONTPATH BẰNG 010:FS:FIND-FONTFILE.
;; - GÁN: FONTFILE=LFONTPATH.
;; - BIGFONTFILE=(PBIG HOẶC ""). (CHỈ CÓ Ý NGHĨA VỚI SHX.)
;; 2. TTF TRUYỀN VÀO DƯỚI DẠNG “FILE .TTF”
;; - XÓA RÀNG BUỘC FILE: FONTFILE="", BIGFONTFILE="".
;; - GỌI VLA-SETFONT VỚI TÊN FACE LẤY BẰNG CÁCH BỎ .TTF:
;;    (SUBSTR PFONT_OR_FACE 1 (- (STRLEN PFONT_OR_FACE) 4)),
;;    BOLD/ITALIC/CHARSET/PITCH ĐỀU ĐỂ MẶC ĐỊNH FALSE, FALSE, 0, 0.
;; - MỤC ĐÍCH: ĐỂ HỘP THOẠI TEXT STYLE HIỂN THỊ ĐÚNG FONT FAMILY NAME THAY VÌ PATH FILE.
;; 3. TTF TRUYỀN VÀO DƯỚI DẠNG “FAMILY NAME” (KHUYẾN NGHỊ)
;; - TƯƠNG TỰ: FONTFILE="", BIGFONTFILE="", RỒI VLA-SETFONT TRỰC TIẾP VỚI PFONT_OR_FACE (CHÍNH LÀ FAMILY NAME).
;; TRẢ VỀ OBJECT STYLE LSTY.
  (cond
;; SHX: GÁN THEO FILE
    ((wcmatch LLOW "*.shx")
     (setq LFONTPATH (010:FS:FIND-FONTFILE PFONT_OR_FACE))
     (010:FS:SAFE-PUT LSTY 'FontFile LFONTPATH)
     (010:FS:SAFE-PUT LSTY 'BigFontFile (if PBIG PBIG "")))
;; TTF FILE: LẤY TÊN FILE -> AUTOCAD VẪN HIỂN THỊ FAMILY, NHƯNG ƯU TIÊN DÙNG SETFONT
    ((wcmatch LLOW "*.ttf")
     ;; CHO PHÉP TRUYỀN ".TTF" NHƯNG SẼ CHUYỂN SANG DÙNG SETFONT BẰNG FAMILY NẾU ĐÃ CÀI VÀO WINDOWS
     ;; Ở ĐÂY VẪN THỬ SET FONTFILE RỖNG + SETFONT THEO CHUỖI BỎ ĐUÔI .TTF
     (010:FS:SAFE-PUT LSTY 'FontFile "")
     (010:FS:SAFE-PUT LSTY 'BigFontFile "")
     (010:FS:SAFE-CALL LSTY 'vla-SetFont
                       (list (substr PFONT_OR_FACE 1 (- (strlen PFONT_OR_FACE) 4))
                             :vlax-false :vlax-false 0 0)))
;; TF FAMILY NAME (KHUYẾN NGHỊ)
    (T
     (010:FS:SAFE-PUT LSTY 'FontFile "")
     (010:FS:SAFE-PUT LSTY 'BigFontFile "")
     (010:FS:SAFE-CALL LSTY 'vla-SetFont (list PFONT_OR_FACE :vlax-false :vlax-false 0 0)))
  )
  LSTY
)
;;; ====================================================================================================
;;; [5] ĐẶT TEXTSTYLE HIỆN HÀNH
;;; ====================================================================================================
(defun 010:TS:SET-CURRENT (PNAME /)
  ;; ĐẶT TEXTSTYLE HIỆN HÀNH
  (if (tblsearch "style" PNAME) (setvar "TEXTSTYLE" PNAME))
  (princ))
;;; ====================================================================================================
;;; [6] MAKE-ALL — TẠO 3 STYLE THEO YÊU CẦU
;;; ====================================================================================================
;; SHX: TRUYỀN TÊN FILE.
;; TTF: TRUYỀN FAMILY NAME (KHÔNG KÈM .TTF) ĐỂ UI HIỂN THỊ ĐÚNG “FONT NAME”.
;; PNAME PFONT_OR_FACE PH PW POBL PBIG 
(defun 010:TS:MAKE-ALL (/)
  (010:TS:ENSURE ".010-A-TXT-1-MAINTITLE-01"  "UNI HelvetIns (H)"     0.0   1.0   0.0   nil)
  (010:TS:ENSURE ".010-A-TXT-2-SUBTITLE-01"   "UNI Alter Gothic (H)"  0.0   1.0   0.0   nil)
  (010:TS:ENSURE ".010-A-TXT-3-NOTE-01"       "uromans.shx"           0.0   0.8   0.0   nil)
  (setq PNAME ".010-A-TXT-3-NOTE-01")
  (010:TS:SET-CURRENT PNAME)
)
;;; ====================================================================================================
;;; [7] COMMANDS - LỆNH
;;; ====================================================================================================
(defun 010_TS_SET ( / K)
  (initget "1 2 3")
  (setq K (getkword
    "\nChọn STYLE [1=TNT_ROMANS_SHX / 2=TNT_HELVETINS_TTF / 3=TNT_ALTER_GOTHIC_TTF] <1>: "))
  (cond
    ((= K "2") (setvar "TEXTSTYLE" "TNT_HELVETINS_TTF"))
    ((= K "3") (setvar "TEXTSTYLE" "TNT_ALTER_GOTHIC_TTF"))
    (T        (setvar "TEXTSTYLE" "TNT_ROMANS_SHX"))
  )
  (princ (strcat "\n[010] Current TEXTSTYLE = " (getvar "TEXTSTYLE")))
  (princ)
)