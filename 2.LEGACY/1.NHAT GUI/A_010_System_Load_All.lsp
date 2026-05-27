;;; ====================================================================================================
;;; ----------------------------------- A_010_SYSTEM_LOAD_ALL ------------------------------------------
;;; ====================================================================================================
;;; * FILE    :  A_010_SYSTEM_LOAD_ALL.lsp
;;; * PURPOSE :
;;;   - Quản lý ROOT, SEARCH.DIRS
;;;   - Các hàm hệ thống: 
;;;     SAFE-SETVAR / GETVAR
;;;     PUSH / POP / RUN-SAFE
;;;     SAFE-PUT / CALL
;;;     ASSURE-TRUST-DIRS
;;;     ASSURE-SUPPORT-DIRS
;;;     SAFE-LOAD, 
;;;     LOG...
;;;   - Dùng chung cho toàn bộ các PACKAGE_...
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  010:A:...
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *010.A.B...*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*...
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*...
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:010_A_...
;;; * LƯU Ý:
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; [1] LOGGING / GHI LOG RA DÒNG LỆNH
;;; ====================================================================================================
;; IN RA THÔNG BÁO THEO MẪU: \[010] <NỘI DUNG>.
;; CHỈ IN KHI PTXT LÀ CHUỖI (TYPE 'STR').
;; DÙNG XUYÊN SUỐT ĐỂ BÁO TIẾN TRÌNH: TRUSTED/SUPORT PATH ĐÃ TỒN TẠI/CHƯA, FILE ĐÃ NẠP/CHƯA, LỖI NẠP…
(defun 010:SYS:LOG (PTXT /) 
  (if (= (type PTXT) 'STR) 
    (princ (strcat "\n[010] " PTXT))
  ) 
  (princ)
)
;;; ====================================================================================================
;;; [2] SAFE SETVAR / ĐẶT/LẤY BIẾN HỆ THỐNG AN TOÀN
;;; ====================================================================================================
(defun 010:SYS:SAFE-SETVAR (PVARNAME PVALUE / LNAME LVAL LSTR)
  (cond ((and (listp PVARNAME) (= (length PVARNAME) 2)) (setq LNAME (car PVARNAME) LVAL (cadr PVARNAME)))
        (T (setq LNAME PVARNAME LVAL PVALUE)))
  (setq LSTR (cond ((= (type LNAME) 'STR) LNAME) ((= (type LNAME) 'SYM) (vl-symbol-name LNAME)) (T nil)))
  (if LSTR (setvar LSTR LVAL) (010:SYS:LOG (strcat "SAFE-SETVAR invalid: " (vl-princ-to-string PVARNAME))))
  (princ)
)
;;; ====================================================================================================
;;; [3] GETVAR / ĐẶT/LẤY BIẾN HỆ THỐNG AN TOÀN
;;; ====================================================================================================
(defun 010:SYS:SAFE-GETVAR (PVARNAME / LNAME LSTR)
  (setq LNAME (if (and (listp PVARNAME) (>= (length PVARNAME) 1)) (car PVARNAME) PVARNAME))
  (setq LSTR (cond ((= (type LNAME) 'STR) LNAME) ((= (type LNAME) 'SYM) (vl-symbol-name LNAME)) (T nil)))
  (if LSTR (getvar LSTR) (progn (010:SYS:LOG (strcat "SAFE-GETVAR invalid: " (vl-princ-to-string PVARNAME))) nil))
)
;;; ====================================================================================================
;;; [4] PUSH / BAO LỒNG MÔI TRƯỜNG & CHỐNG VỠ PHIÊN
;;; ====================================================================================================
(defun 010:SYS:PUSH ( / LVARLIST LITEM )
  (setq LVARLIST
    '(
      ("CMDECHO" 0)
      ("EXPERT" 0)
      ("FILEDIA" 1)
      ("ATTDIA" 1)
      ("ATTREQ" 1)
      ("CMDDIA" 1)      
      ("PICKFIRST" 1)
      ("PICKADD" 2)
      ("DRAGMODE" 2)
      ("POLARMODE" 0)
      ("UCSFOLLOW" 0)
      ("HPASSOC" 1)
      ("DIMASSOC" 2)
      ("LTSCALE" 1)
      ("PEDITACCEPT" 1)      
      ("MIRRTEXT" 0)
    )
  )
  (setq 010.SYSTEM.SAVED '())
  (foreach LITEM LVARLIST (setq 010.SYSTEM.SAVED (cons (list (car LITEM) (010:SYS:SAFE-GETVAR (car LITEM))) 010.SYSTEM.SAVED)))
  (foreach LITEM LVARLIST (010:SYS:SAFE-SETVAR (car LITEM) (cadr LITEM)))
  (princ)
)
;;; ====================================================================================================
;;; [4] POP
;;; ====================================================================================================
(defun 010:SYS:POP ( / LITEM )
  (if (and (boundp '010.SYSTEM.SAVED) 010.SYSTEM.SAVED)
    (foreach LITEM 010.SYSTEM.SAVED (010:SYS:SAFE-SETVAR (car LITEM) (cadr LITEM))))
  (setq 010.SYSTEM.SAVED nil) (princ)
)
;;; ====================================================================================================
;;; [6] RUN-SAFE
;;; ====================================================================================================
(defun 010:SYS:RUN-SAFE (PFUNC / LERR LOLD)
  (setq LOLD (getvar 'CMDECHO)) (setvar 'CMDECHO 0)
  (010:SYS:PUSH) (setq LERR (vl-catch-all-apply PFUNC)) (010:SYS:POP)
  (setvar 'CMDECHO LOLD)
  (if (vl-catch-all-error-p LERR) (010:SYS:LOG (strcat "ERROR: " (vl-catch-all-error-message LERR))))
  (princ)
)
;; MỤC ĐÍCH: 
;; - ĐẢM BẢO LUÔN TRẢ MÔI TRƯỜNG VỀ NHƯ CŨ KỂ CẢ KHI CÓ LỖI.
;; - NGĂN TÌNH TRẠNG “VỠ” DO BIẾN HỆ THỐNG BẤT THƯỜNG.
;;; ====================================================================================================
;;; ----------------------------------- [6] FS – SAFE CALLS (VLA/PUT) ----------------------------------
;;; ====================================================================================================
(defun 010:PACKAGE:FS:SAFE-PUT (PFUN PARGS /)  
  (vl-catch-all-apply (function (lambda () (apply PFUN PARGS))))
)
(defun 010:PACKAGE:FS:SAFE-CALL (PFUN PARGS /)
  (vl-catch-all-apply (function (lambda () (apply PFUN PARGS))))
) 
;;; ====================================================================================================
;;; [7] PATH HELPERS / TIỆN ÍCH ĐƯỜNG DẪN & KIỂM TRA FILE/THƯ MỤC
;;; ====================================================================================================
;; 010:FS:STR?: KIỂM TRA KIỂU CHUỖI.
(defun 010:FS:STR? (x) 
  (= (type x) 'STR)
)
;; 010:FS:JOIN (BASE REL): GHÉP BASE\REL (NẾU REL ĐÃ LÀ ĐƯỜNG DẪN TUYỆT ĐỐI KIỂU C:\… THÌ GIỮ NGUYÊN).
(defun 010:FS:JOIN (PBASE PREL /)
  (if (and (010:FS:STR? PBASE) (010:FS:STR? PREL))
    (cond ((wcmatch PREL "*:\\*") PREL)
          (T (vl-string-right-trim "\\" (strcat (vl-string-right-trim "\\" PBASE) "\\" PREL))))
    nil)
)
;; 010:FS:DIR?, 010:FS:FILE?: KIỂM TRA TỒN TẠI THƯ MỤC/FILE.
(defun 010:FS:DIR?  (p) 
  (and (010:FS:STR? p) (vl-file-directory-p p))
)
(defun 010:FS:FILE? (p)
  (and (010:FS:STR? p) (findfile p))
)
;; 010:FS:LIST-DIRS (BASE): LIỆT KÊ THƯ MỤC CON (BỎ ".", "..").
(defun 010:FS:LIST-DIRS (base /)
  (if (010:FS:DIR? base)
    (vl-remove-if '(lambda (x) (or (equal x ".") (equal x ".."))) (vl-directory-files base nil -1))
    nil)
)
;;; MỤC ĐÍCH: CHUẨN HOÁ THAO TÁC ĐƯỜNG DẪN, TRÁNH GHÉP SAI DẤU \, VÀ CHỈ LÀM VIỆC KHI THỰC SỰ TỒN TẠI.
;;; ====================================================================================================
;;; [8] ROOT & FULL DIRS LIST
;;; ====================================================================================================
;; ROOT MẶC ĐỊNH *010.PACKAGE.ROOT* VÀ *010.CFG.ROOT* MẶC ĐỊNH:
;; C:\010.A_PACKAGE_STANDARD_AUTOCAD
(if (not (and (boundp '*010.PACKAGE.ROOT*) (010:FS:STR? *010.PACKAGE.ROOT*)))
  (setq *010.PACKAGE.ROOT* "C:\\.010.A_PACKAGE_STANDARD_AUTOCAD"))
(if (not (and (boundp '*010.CFG.ROOT*) (010:FS:STR? *010.CFG.ROOT*)))
  (setq *010.CFG.ROOT* *010.PACKAGE.ROOT*))
;; 010:CFG:ASSURE-ROOT
;; TRẢ VỀ ROOT TIN CẬY NHẤT THEO THỨ TỰ ƯU TIÊN:
;; *010.CFG.ROOT* → *010.PACKAGE.ROOT* → PHẦN TỬ ĐẦU CỦA *010.SEARCH.DIRS* (NẾU CÓ) → MẶC ĐỊNH.
(defun 010:CFG:ASSURE-ROOT ( / cand)
  (cond
    ((and (boundp '*010.CFG.ROOT*) (010:FS:STR? *010.CFG.ROOT*)) *010.CFG.ROOT*)
    ((and (boundp '*010.PACKAGE.ROOT*) (010:FS:STR? *010.PACKAGE.ROOT*)) (setq *010.CFG.ROOT* *010.PACKAGE.ROOT*))
    ((and (boundp '*010.SEARCH.DIRS*) (= (type *010.SEARCH.DIRS*) 'LIST)
          (010:FS:STR? (setq cand (car *010.SEARCH.DIRS*)))) (setq *010.CFG.ROOT* cand))
    (T (setq *010.CFG.ROOT* "C:\\.010.A_PACKAGE_STANDARD_AUTOCAD"))
  )
  *010.CFG.ROOT*
)
;; 010:CFG:BUILD-SEARCH-DIRS
;; GÁN *010.SEARCH.DIRS* = DANH SÁCH 6 MỤC Ở TRÊN.
(defun 010:CFG:DIRS-FULL ( / R )
  (setq R (010:CFG:ASSURE-ROOT))
  (if (010:FS:STR? R)
    (list
      R
      (strcat R "\\01_RESOURCES")
      (strcat R "\\02_SETTINGS")
      (strcat R "\\03_TEMPLATES")
      (strcat R "\\04_PACKAGE_01_CREATE")
      (strcat R "\\05_PACKAGE_02_GENERAL")
      (strcat R "\\06_PACKAGE_03_MANAGE")
      (strcat R "\\07_PACKAGE_04_DRAW")
      (strcat R "\\08_PACKAGE_05_LAYER")
      (strcat R "\\09_PACKAGE_06_TEXT")
      (strcat R "\\10_PACKAGE_07_LEADER")
      (strcat R "\\11_PACKAGE_08_DIMENSION")
      (strcat R "\\12_PACKAGE_09_HATCH")
      (strcat R "\\13_PACKAGE_10_BLOCK")
    )
    '()
  )
)
;; 010:CFG:BUILD-SEARCH-DIRS / GÁN *010.SEARCH.DIRS* = DANH SÁCH 6 MỤC Ở TRÊN.
(defun 010:CFG:BUILD-SEARCH-DIRS ( / )
  (setq *010.SEARCH.DIRS* (010:CFG:DIRS-FULL))
  (princ)
)
;; 010:CFG:SET-ROOT
;; NHẬP ROOT TỪ NGƯỜI DÙNG (CÓ GỢI Ý ROOT HIỆN TẠI), CẬP NHẬT CẢ *010.CFG.ROOT* & *010.PACKAGE.ROOT*.
;; SAU ĐÓ BUILD SEARCH DIRS, ĐẢM BẢO TRUSTEDPATHS, ĐẢM BẢO SUPPORTPATH, VÀ LOG ROOT = ….
(defun 010:CFG:SET-ROOT ( / PROOT)
  (setq PROOT (getstring T (strcat "\n[010] Nhap duong dan ROOT <" (010:CFG:ASSURE-ROOT) ">: ")))
  (if (and (010:FS:STR? PROOT) (/= PROOT "")) (setq *010.CFG.ROOT* PROOT *010.PACKAGE.ROOT* PROOT))
  (010:CFG:BUILD-SEARCH-DIRS)
  (010:SYS:ASSURE-TRUST-DIRS)
  (010:SYS:ASSURE-SUPPORT-DIRS)
  (010:SYS:LOG (strcat "ROOT = " *010.CFG.ROOT*))
  (princ)
)
;; KHỞI TẠO: GỌI 010:CFG:BUILD-SEARCH-DIRS NGAY KHI NẠP FILE.
(010:CFG:BUILD-SEARCH-DIRS)
;; MỤC ĐÍCH: LUÔN CÓ MỘT ROOT HỢP LỆ VÀ DANH SÁCH THƯ MỤC CON TIÊU CHUẨN ĐỂ QUÉT & NẠP PACKAGE.
;;; ====================================================================================================
;;; [9] TRUSTED & SUPPORT PATHS / ĐẢM BẢO QUYỀN CHẠY & ĐƯỜNG DẪN HỖ TRỢ
;;; ====================================================================================================
;; ĐỌC TRUSTEDPATHS, THÊM ĐỦ 6 ĐƯỜNG DẪN NẾU THIẾU, KHÔNG THÊM TRÙNG (SO KHỚP KHÔNG PHÂN BIỆT HOA/THƯỜNG).
;; ÉP SECURELOAD=1.
;; LOG THEO TỪNG MỤC: TRUSTED + … (ĐÃ THÊM) HOẶC TRUSTED = … (EXISTS) (ĐÃ CÓ).
(defun 010:SYS:ASSURE-TRUST-DIRS ( / LTP DIR S has)
  (setq LTP (getvar "TRUSTEDPATHS")) (if (null LTP) (setq LTP ""))
  (foreach DIR (010:CFG:DIRS-FULL)
    (if (010:FS:STR? DIR)
      (progn
        (setq S (strcase DIR)
              has (wcmatch (strcase (strcat ";" LTP ";")) (strcat "*;" S ";*")))
        (if (not has)
          (progn (setq LTP (if (> (strlen (vl-string-trim ";" LTP)) 0) (strcat LTP ";" DIR) DIR))
                 (010:SYS:LOG (strcat "TRUSTED + " DIR)))
          (010:SYS:LOG (strcat "TRUSTED = " DIR " (EXISTS)"))
        ))))
  (setvar "TRUSTEDPATHS" LTP) (if (/= (getvar "SECURELOAD") 1) (setvar "SECURELOAD" 1)) (princ)
)
;; LẤY PREFERENCES.FILES.SUPPORTPATH QUA VLA; THÊM 6 THƯ MỤC NẾU THIẾU (KHÔNG TRÙNG).
;; LOG SUPPORTPATH + … HOẶC SUPPORTPATH = … (EXISTS).
(defun 010:SYS:ASSURE-SUPPORT-DIRS ( / ACAD PREFS FILES CUR DIR S has)
  (setq ACAD (vlax-get-acad-object) PREFS (vla-get-Preferences ACAD) FILES (vla-get-Files PREFS) CUR (vla-get-SupportPath FILES))
  (if (null CUR) (setq CUR ""))
  (foreach DIR (010:CFG:DIRS-FULL)
    (if (010:FS:STR? DIR)
      (progn
        (setq S (strcase DIR)
              has (wcmatch (strcase (strcat ";" (vl-string-trim ";" CUR) ";")) (strcat "*;" S ";*")))
        (if (not has)
          (progn (setq CUR (if (> (strlen (vl-string-trim ";" CUR)) 0) (strcat CUR ";" DIR) DIR))
                 (010:SYS:LOG (strcat "SUPPORTPATH + " DIR)))
          (010:SYS:LOG (strcat "SUPPORTPATH = " DIR " (EXISTS)"))
        ))))
  (vla-put-SupportPath FILES CUR) (princ)
)
;; MỤC ĐÍCH: ĐẢM BẢO AUTOCAD TIN CẬY VÀ CÓ THỂ TÌM THẤY TÀI NGUYÊN LISP/DCL/… TRONG CÁC THƯ MỤC CHUẨN.
;;; ====================================================================================================
;;; [10] SAFE LOAD / NẠP FILE AN TOÀN & BÁO LỖI RÕ RÀNG
;;; ====================================================================================================
;; 010:LSP:SAFE-LOAD (PF)
;; NẾU FINDFILE PF CÓ ⇒ LOAD TRONG CATCH; LỖI ⇒ LOG "LOAD ERROR: PF", THÀNH CÔNG ⇒ "LOADED: PF".
;; NẾU KHÔNG CÓ FILE ⇒ "MISSING: PF".
(defun 010:LSP:SAFE-LOAD (PF / LERR)
  (if (010:FS:FILE? PF)
    (progn (setq LERR (vl-catch-all-apply 'load (list PF)))
           (if (vl-catch-all-error-p LERR) (010:SYS:LOG (strcat "LOAD ERROR: " PF))
               (010:SYS:LOG (strcat "LOADED: " PF))))
    (010:SYS:LOG (strcat "MISSING: " (if (010:FS:STR? PF) PF "<nil>"))))
  (princ)
)
;; MỤC ĐÍCH: NẠP TỪNG FILE KHÔNG LÀM GÃY TIẾN TRÌNH TỔNG, VÀ LUÔN BIẾT FILE NÀO THIẾU/LỖI.
;;; ====================================================================================================
;;; [11] LOAD-PKG-WITH-CONTEXT / NẠP KÈM “NGỮ CẢNH THƯ MỤC”
;;; ====================================================================================================
;; 010:SYS:LOAD-PKG-WITH-CONTEXT (PF)
;; NẾU FILE TỒN TẠI:
;; - LẤY THƯ MỤC CHỨA FILE → GÁN TẠM *010.CURRENT.PACKAGE.DIR* = THƯ_MỤC_ĐÓ.
;; - LOAD PF BÊN TRONG MỘT CATCH, RỒI XÓA BIẾN CONTEXT (ĐẢM BẢO KHÔNG RÒ RỈ).
;; - THÀNH CÔNG ⇒ LOADED: PF; LỖI ⇒ LOAD ERROR: PF → <THÔNG ĐIỆP LỖI>.
;; NẾU KHÔNG CÓ FILE ⇒ MISSING:...
(defun 010:SYS:LOAD-PKG-WITH-CONTEXT (PF / LERR PDIR)
  (if (and (= (type PF) 'STR) (findfile PF))
    (progn
      (setq PDIR (vl-filename-directory PF))
      (setq LERR
        (vl-catch-all-apply
          (function
            (lambda ( / )
              (setq *010.CURRENT.PACKAGE.DIR* PDIR)
              (load PF)
            )
          ); '()
        )
      )
      (setq *010.CURRENT.PACKAGE.DIR* nil)
      (if (vl-catch-all-error-p LERR)
        (010:SYS:LOG (strcat "LOAD ERROR: " PF " → " (vl-catch-all-error-message LERR)))
        (010:SYS:LOG (strcat "LOADED: " PF))
      )
    )
    (010:SYS:LOG (strcat "MISSING: " (if PF PF "<nil>")))
  )
  (princ)
)
;; MỤC ĐÍCH: 
;; - CHO PHÉP CÁC PACKAGE CON (LOADER) BIẾT MÌNH ĐANG Ở ĐÂU ĐỂ NẠP FILE LIÊN QUAN THEO ĐƯỜNG DẪN TƯƠNG ĐỐI MỘT CÁCH AN TOÀN.
;;; ====================================================================================================
;;; [12] PACKAGE LOADER SCAN / QUÉT & NẠP LOADER TRONG ROOT VÀ CÁC THƯ MỤC CON
;;; ====================================================================================================
;; [NEW] Trả về LIST rỗng nếu x là nil, ngược lại trả về x (giúp append/foreach an toàn)
(defun 010:SYS:AS-LIST (x) (if (= (type x) 'LIST) x '()))

;; [REPLACE] Tìm & nạp package loader (hỗ trợ cả *_1.lsp, *_2.lsp…, an toàn kiểu tuyệt đối)
(defun 010:SYS:TRY-LOAD-PACKAGE (P_DIR / picked exacts wilds found files pat err)
  (if (and (= (type P_DIR) 'STR) (vl-file-directory-p P_DIR))
    (progn
      ;; 1) Tên chuẩn
      (setq exacts (list "A_010_System_Package.lsp" "A_010_SYSTEM_PACKAGE.lsp"))
      (setq picked
        (vl-some
          '(lambda (nm / fp)
             (setq fp (strcat (vl-string-right-trim "\\" P_DIR) "\\" nm))
             (if (findfile fp) fp nil))
          exacts
        )
      )

      ;; 2) Nếu chưa có, thử wildcard (lọc & sắp xếp an toàn)
      (if (not picked)
        (progn
          (setq wilds (list "A_010_System_Package_*.lsp" "A_010_SYSTEM_PACKAGE_*.lsp"))
          (setq files '())
          (foreach pat (010:SYS:AS-LIST wilds)
            (setq found (010:SYS:AS-LIST (vl-directory-files P_DIR pat 1)))
            (if found (setq files (append files found)))
          )
          (if (> (length files) 0)
            (progn
              (setq files (acad_strlsort files))
              (setq picked (strcat (vl-string-right-trim "\\" P_DIR) "\\" (car files)))
            )
          )
        )
      )

      ;; 3) Nạp có context
      (if (and (= (type picked) 'STR) (findfile picked))
        (progn
          (setq err (vl-catch-all-apply '(lambda () (010:SYS:LOAD-PKG-WITH-CONTEXT picked)) '()))
          (if (vl-catch-all-error-p err)
            (010:SYS:LOG (strcat "ERROR: " (vl-catch-all-error-message err))))
        )
        (010:SYS:LOG (strcat "No package loader in: " P_DIR))
      )
    )
    (010:SYS:LOG (strcat "Skip (not a dir): " (vl-princ-to-string P_DIR)))
  )
  (princ)
)


(defun 010:SYS:LOAD-ALL-IMPL (/ LROOT LDIRS)
  (010:CFG:BUILD-SEARCH-DIRS) ; đảm bảo danh sách đầy đủ
  (setq LROOT (010:CFG:ASSURE-ROOT))
  (if (not (010:FS:DIR? LROOT))
    (progn
      (010:SYS:LOG (strcat "ROOT khong ton tai: " (vl-princ-to-string LROOT)))
      (010:SYS:LOG "Dung 010_SYS_SET_ROOT de dat lai duong dan.")
    )
    (progn
      (010:SYS:ASSURE-TRUST-DIRS)
      (010:SYS:ASSURE-SUPPORT-DIRS)
      (010:SYS:TRY-LOAD-PACKAGE LROOT)
      (setq LDIRS (010:FS:LIST-DIRS LROOT))
      (if LDIRS
        (foreach d (acad_strlsort LDIRS) (010:SYS:TRY-LOAD-PACKAGE (010:FS:JOIN LROOT d)))
        (010:SYS:LOG (strcat "Khong co thu muc con trong: " LROOT))
      )
    )
  )
  (010:SYS:LOG "DONE: LOAD ALL PACKAGES.")
  (princ)
)
;;; ====================================================================================================
;;; [13] DEBUG & COMMANDS
;;; ====================================================================================================
(defun 010_SYS_DEBUG ( / r )
  (setq r (010:CFG:ASSURE-ROOT))
  (010:SYS:LOG (strcat "ROOT = " (if (010:FS:STR? r) r "<nil>")))
  (010:SYS:LOG (strcat "SEARCH.DIRS = " (vl-princ-to-string (010:CFG:DIRS-FULL))))
  (if (010:FS:DIR? r) (010:SYS:LOG "ROOT is a valid directory.") (010:SYS:LOG "ROOT is NOT a valid directory!"))
  (princ)
)
(defun c:010_SYS_SET_ROOT ( / ) (010:SYS:RUN-SAFE '010:CFG:SET-ROOT) (princ))
(defun c:010_SYS_LOAD_ALL ( / ) (010:SYS:RUN-SAFE '010:SYS:LOAD-ALL-IMPL) (princ))

(princ "\n[010] COMMAND: 10_SYS_DEBUG | 010_SYS_SET_ROOT | 010_SYS_LOAD_ALL")
(princ)