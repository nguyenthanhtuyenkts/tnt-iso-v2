;;; ====================================================================================================
;;; TNT_PACKAGE_00_SYSTEM_ALL.lsp
;;; System helpers + global TNT settings only.
;;; This file intentionally does not load any other Lisp package.
;;; ====================================================================================================

(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")

;;; ----------------------------------------------------------------------------------------------------
;;; Core system helpers
;;; ----------------------------------------------------------------------------------------------------
(defun TNT:SYS:LOG (msg /)
  (if (= (type msg) 'STR)
    (princ (strcat "\n[TNT] " msg))
  )
  (princ)
)

(defun TNT:SYS:STR? (x)
  (= (type x) 'STR)
)

(defun TNT:SYS:FILE? (p)
  (and (TNT:SYS:STR? p) (findfile p))
)

(defun TNT:SYS:DIR? (p)
  (and (TNT:SYS:STR? p) (vl-file-directory-p p))
)

(defun TNT:SYS:TRIM-SLASH (p)
  (if (TNT:SYS:STR? p)
    (vl-string-right-trim "\\/" p)
    ""
  )
)

(defun TNT:SYS:JOIN (base rel / b r)
  (setq b (TNT:SYS:TRIM-SLASH base)
        r rel)
  (cond
    ((not (and (TNT:SYS:STR? b) (TNT:SYS:STR? r))) nil)
    ((wcmatch r "*:\\*") r)
    (T (strcat b "\\" r))
  )
)

(setq *TNT.SYSTEM.FILE*
  (cond
    ((and (boundp '*load-truename*) (TNT:SYS:STR? *load-truename*)) *load-truename*)
    ((findfile "TNT_PACKAGE_00_SYSTEM_ALL.lsp"))
    (T nil)
  )
)

(setq *TNT.SYSTEM.ROOT*
  (if (TNT:SYS:STR? *TNT.SYSTEM.FILE*)
    (vl-filename-directory *TNT.SYSTEM.FILE*)
    "E:\\TNT\\0.TNT ISO\\00.TNT ISO 2026\\00_LISP"
  )
)

(setq *TNT.SYSTEM.OSMODE.NEAREST-BIT* 512)
(setq *TNT.SYSTEM.OSMODE.DEFAULT* 15871)
(setq *TNT.SYSTEM.ENABLE.COMMAND.REACTORS* nil)

(defun TNT:SYS:SAFE-SETVAR (var value / name val str)
  (cond
    ((and (listp var) (= (length var) 2)) (setq name (car var) val (cadr var)))
    (T (setq name var val value))
  )
  (setq str
    (cond
      ((= (type name) 'STR) name)
      ((= (type name) 'SYM) (vl-symbol-name name))
      (T nil)
    )
  )
  (if str
    (setvar str val)
    (TNT:SYS:LOG (strcat "SAFE-SETVAR invalid: " (vl-princ-to-string var)))
  )
  (princ)
)

(defun TNT:SYS:SAFE-GETVAR (var / name str)
  (setq name (if (and (listp var) (>= (length var) 1)) (car var) var))
  (setq str
    (cond
      ((= (type name) 'STR) name)
      ((= (type name) 'SYM) (vl-symbol-name name))
      (T nil)
    )
  )
  (if str
    (getvar str)
    (progn
      (TNT:SYS:LOG (strcat "SAFE-GETVAR invalid: " (vl-princ-to-string var)))
      nil
    )
  )
)

(defun TNT:SYS:PUSH (/ item)
  (setq *TNT.SYSTEM.SAVED*
    (mapcar
      '(lambda (item) (list item (TNT:SYS:SAFE-GETVAR item)))
      '("CMDECHO" "EXPERT" "FILEDIA" "ATTDIA" "ATTREQ" "CMDDIA" "PICKFIRST" "PICKADD" "DRAGMODE" "UCSFOLLOW" "MIRRTEXT")
    )
  )
  (foreach item
    '(("CMDECHO" 0) ("EXPERT" 0) ("FILEDIA" 1) ("ATTDIA" 1) ("ATTREQ" 1) ("CMDDIA" 1) ("PICKFIRST" 1) ("PICKADD" 2) ("DRAGMODE" 2) ("UCSFOLLOW" 0) ("MIRRTEXT" 0))
    (TNT:SYS:SAFE-SETVAR item nil)
  )
  (princ)
)

(defun TNT:SYS:POP (/ item)
  (if (and (boundp '*TNT.SYSTEM.SAVED*) *TNT.SYSTEM.SAVED*)
    (foreach item *TNT.SYSTEM.SAVED*
      (TNT:SYS:SAFE-SETVAR (car item) (cadr item))
    )
  )
  (setq *TNT.SYSTEM.SAVED* nil)
  (princ)
)

(defun TNT:SYS:RUN-SAFE (func / err oldcmdecho)
  (setq oldcmdecho (getvar "CMDECHO"))
  (TNT:SYS:PUSH)
  (setq err (vl-catch-all-apply func '()))
  (TNT:SYS:POP)
  (if oldcmdecho (setvar "CMDECHO" oldcmdecho))
  (if (vl-catch-all-error-p err)
    (TNT:SYS:LOG (strcat "ERROR: " (vl-catch-all-error-message err)))
  )
  (princ)
)

(defun TNT:SYSTEM:OSMODE-WITHOUT-NEAREST (value / v)
  (setq v (if (= (type value) 'INT) value (getvar "OSMODE")))
  v
)

(defun TNT:SYSTEM:ENSURE-OSMODE-NO-NEAREST (/)
  (princ)
)

(defun TNT:SYSTEM:CLEAN-OSMODE-RESET-REACTORS (/ grp obj reactions pair cb name hit)
  (foreach grp (vlr-reactors :vlr-editor-reactor)
    (foreach obj (cdr grp)
      (setq hit nil)
      (setq reactions (vl-catch-all-apply 'vlr-reactions (list obj)))
      (if (not (vl-catch-all-error-p reactions))
        (foreach pair reactions
          (setq cb (cdr pair))
          (setq name (strcase (vl-princ-to-string cb)))
          (if (member name '("RESETOSMODE" "TNT:MANAGE:RESET-OSMODE"))
            (setq hit T)
          )
        )
      )
      (if hit
        (vl-catch-all-apply 'vlr-remove (list obj))
      )
    )
  )
  (setq *TNT.MANAGE.OSMODE.REACTOR* nil)
  (princ)
)

(defun TNT:PACKAGE:FS:SAFE-PUT (fun args /)
  (vl-catch-all-apply (function (lambda () (apply fun args))))
)

(defun TNT:PACKAGE:FS:SAFE-CALL (fun args /)
  (vl-catch-all-apply (function (lambda () (apply fun args))))
)

(defun TNT:FS:SAFE-PUT (obj prop value / err)
  (if (and obj prop)
    (progn
      (setq err
        (vl-catch-all-apply
          (function (lambda () (vlax-put-property obj prop value)))
          '()
        )
      )
      (if (vl-catch-all-error-p err) nil obj)
    )
  )
)

(defun TNT:FS:SAFE-CALL (obj method args / err)
  (if (and obj method)
    (progn
      (setq err
        (vl-catch-all-apply
          (function (lambda () (apply method (cons obj args))))
          '()
        )
      )
      (if (vl-catch-all-error-p err) nil T)
    )
  )
)

(defun TNT:FS:STR-LOWER (s)
  (vl-string-translate "ABCDEFGHIJKLMNOPQRSTUVWXYZ" "abcdefghijklmnopqrstuvwxyz"
                       (vl-princ-to-string s))
)

(defun TNT:FS:EXT (s / p l)
  (setq l (TNT:FS:STR-LOWER (vl-princ-to-string s)))
  (if (and l (setq p (vl-string-search "." l (- (strlen l) 1))))
    (substr l (1+ p))
    ""
  )
)

(defun TNT:FS:WINFONTS-PATH (/ w)
  (setq w (getenv "WINDIR"))
  (if (and w (/= w "")) (strcat w "\\Fonts\\") "C:\\Windows\\Fonts\\")
)

(defun TNT:FS:FIND-FONTFILE (pfont / cand)
  (setq cand
    (vl-remove nil
      (list
        (findfile pfont)
        (findfile (strcat (getvar "ACADPREFIX") pfont))
        (findfile (strcat (TNT:FS:WINFONTS-PATH) pfont))
      )
    )
  )
  (if cand (car cand) pfont)
)

;;; ----------------------------------------------------------------------------------------------------
;;; Global TNT settings
;;; ----------------------------------------------------------------------------------------------------


;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Settings_Create_Layer.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; *** B_TNT_SETTINGS_CREATE_LAYER.LSP ***
;;; ====================================================================================================
;;; * FILE    : B_TNT_SETTINGS_CREATE_LAYER.LSP
;;; * PURPOSE : 
;;;   - DATA LAYER HỆ THỐNG
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(VL-LOAD-COM)
(SETVAR "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [1] BẢNG DATE CHUẨN (DÙNG CHUNG)
;;; ====================================================================================================
;;; MEPF: MECHANICAL _ ELECTRICAL _ PLUMBING _ FIREFIGHTING 
;;; MECHANICAL (CƠ KHÍ)
;;; - HỆ THỐNG LIÊN QUAN ĐẾN HVAC LÀ HỆ THỐNG SƯỞI, THÔNG GIÓ VÀ ĐIỀU HÒA KHÔNG KHÍ
;;; - HỆ THỐNG THANG MÁY, BƠM NƯỚC, QUẠT GIÓ, V.V.
;;; ELECTRICAL (ĐIỆN)                 
;;; - HỆ THỐNG ĐIỆN TRONG TÒA NHÀ, TỪ CUNG CẤP NGUỒN ĐIỆN, PHÂN PHỐI ĐIỆN, HỆ THỐNG CHIẾU SÁNG
;;; - Ổ CẮM, ĐẾN CÁC HỆ THỐNG ĐIỀU KHIỂN VÀ TỰ ĐỘNG HÓA, HỆ THỐNG NĂNG LƯỢNG TÁI TẠO, V.V
;;; PLUMBING (CẤP THOÁT NƯỚC)
;;; - HỆ THỐNG CUNG CẤP NƯỚC SẠCH, THOÁT NƯỚC THẢI, XỬ LÝ NƯỚC, HỆ THỐNG CẤP NƯỚC NÓNG LẠNH, VÀ CÁC HỆ THỐNG CẤP THOÁT NƯỚC KHÁC
;;; FIREFIGHTING (PHÒNG CHÁY CHỮA CHÁY)
;;; - HỆ THỐNG PHÁT HIỆN VÀ CHỮA CHÁY NHƯ BÁO CHÁY TỰ ĐỘNG, HỆ THỐNG SPRINKLER
;;; - HỆ THỐNG CHỮA CHÁY BẰNG BỌT, KHÍ HOẶC NƯỚC, CÁC THIẾT BỊ CHỮA CHÁY CẦM TAY, VÀ CÁC BIỆN PHÁP PHÒNG CHỐNG CHÁY NỔ
(DEFUN TNT:LAYER:STD-TABLE (/)
  '(
    ;; ARCHITECT
    ("....00________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ("....01_TNT_A_DRAWING"                   "P"   "7"     "CONTINUOUS"      "0"       "0"   "NÉT KHUNG BẢN VẼ"                )
    ("....02_TNT_A_VIRTURAL"                  "P"   "9"     "CONTINUOUS"      "0.3"     "50"  "NÉT THẤY"                        )
    ("....03_TNT_A_THIN"                      "P"   "251"   "CONTINUOUS"      "0.15"    "50"  "NÉT MẢNH"                        )    
    ("....04_TNT_A_HIDDEN"                    "P"   "251"   "HIDDEN"          "0"       "50"  "NÉT KHUẤT"                       )
    ("....05_TNT_A_SECTION"                   "P"   "30"    "CONTINUOUS"      "0"       "50"  "NÉT CẮT"                         )
    ("....06_TNT_A_SECTION-LINE"              "P"   "6"     "ACAD_ISO07W100"  "0"       "0"   "NÉT TRỤC CẮT"                    )    
    ("....07_TNT_A_BASE"                      "P"   "177"   "CENTER"          "0"       "0"   "NÉT TRỤC"                        )
    ("....08_TNT_A_DETAIL"                    "P"   "156"   "HIDDEN"          "0"       "50"  "NÉT CHI TIẾT"                    )
    ("....09_TNT_A_COMPLETE"                  "P"   "8"     "CONTINUOUS"      "0"       "50"  "NÉT HOÀN THIỆN"                  )
    ("....10_TNT_A_COTE"                      "P"   "14"    "CONTINUOUS"      "0"       "0"   "NÉT CAO ĐỘ"                      )
    ("....11_TNT_A_PLOT"                      "N"   "250"   "CONTINUOUS"      "0"       "0"   "NÉT IN"                          )
    ;; FURNITURE
    ("....12________________________________" "N"   "250"   "CONTINUOUS"      "0"       "50"  "________________________________")
    ("....12_TNT_F_FURNITURE"                 "P"   "27"    "CONTINUOUS"      "0"       "50"  "NÉT NỘI THẤT"                    )
    ("....13_TNT_F_TREE"                      "P"   "76"    "CONTINUOUS"      "0"       "50"  "NÉT CÂY"                         )
    ("....14_TNT_F_GLASS"                     "P"   "147"   "CONTINUOUS"      "0"       "50"  "NÉT KÍNH"                        )    
    ("....15_TNT_F_DOOR"                      "P"   "33"    "CONTINUOUS"      "0"       "50"  "NÉT CỬA"                         )    
    ;; STRUCTURE
    ("....16________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ("....16_TNT_S_CONCRETE"                  "P"   "7"     "CONTINUOUS"      "0"       "50"  "NÉT BTCT"                        )
    ("....17_TNT_S_WALL"                      "P"   "41"    "CONTINUOUS"      "0"       "50"  "NÉT TƯỜNG"                       )
    ("....18_TNT_S_COLUMN"                    "P"   "9"     "CONTINUOUS"      "0"       "50"  "NÉT CỘT"                         )
    ;; ANNOTATE
    ("....19________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ("....20_TNT_N_TEXT"                      "P"   "9"     "CONTINUOUS"      "0"       "0"   "NÉT CHỮ"                         )
    ("....21_TNT_N_LEADER"                    "P"   "9"     "CONTINUOUS"      "0"       "0"   "NÉT GHI CHÚ"                     )
    ("....22_TNT_N_DIMENSION"                 "P"   "251"   "CONTINUOUS"      "0"       "0"   "NÉT KÍCH THƯỚC"                  )
    ("....23_TNT_N_HATCH"                     "P"   "250"   "CONTINUOUS"      "0"       "50"  "NÉT VẬT LIỆU"                    )
    ("....24_TNT_N_ANNOTATE"                  "P"   "14"    "CONTINUOUS"      "0"       "0"   "NÉT CHÚ THÍCH"                   )
    ;; MECHANICAL
    ("....25________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ("....25_TNT_M_NOTE"                      "P"   "1"     "CONTINUOUS"      "0"       "0"   "NÉT THIẾT BỊ ĐHKK"               )
    ("....26_TNT_M_TEXT"                      "P"   "4"     "CONTINUOUS"      "0"       "0"   "NÉT CHỮ ĐHKK"                    )
    ("....27_TNT_M_CONTROL"                   "P"   "5"     "HIDDEN"          "0"       "0"   "NÉT ĐIỀU KHIỂN ĐHKK"             )
    ("....28_TNT_M_COPPER-PIPE"               "P"   "3"     "CONTINUOUS"      "0"       "0"   "NÉT ỐNG ĐỒNG"                    )
    ("....29_TNT_M_CONDENSED-W"               "P"   "6"     "CONTINUOUS"      "0"       "0"   "NÉT NƯỚC NGƯNG"                  )
    ("....30_TNT_M_RETURN-DUCT"               "P"   "6"     "CONTINUOUS"      "0"       "0"   "NÉT HỒI ĐHKK"                    )
    ("....31_TNT_M_SUPPLY-DUCT"               "P"   "4"     "CONTINUOUS"      "0"       "0"   "NÉT CẤP ĐHKK"                    )
    ;; ELECTRICAL
    ("....32________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ("....32_TNT_E_NOTE"                      "P"   "1"     "CONTINUOUS"      "0"       "0"   "NÉT THIẾT BỊ ĐIỆN"               )
    ("....33_TNT_E_TEXT"                      "P"   "2"     "CONTINUOUS"      "0"       "0"   "NÉT CHỮ PHẦN ĐIỆN"               )
    ("....34_TNT_E_LINE"                      "P"   "4"     "CONTINUOUS"      "0"       "0"   "NÉT SĐNL ĐIỆN"                   )
    ("....35_TNT_E_WIRE"                      "P"   "6"     "DASHDOT"         "0"       "0"   "NÉT DÂY ĐIỆN"                    )
    ;; PLUMBING
    ("....36________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ("....36_TNT_P_NOTE"                      "P"   "11"    "CONTINUOUS"      "0"       "0"   "NÉT THIẾT BỊ NƯỚC"               )
    ("....37_TNT_P_TEXT"                      "P"   "3"     "CONTINUOUS"      "0"       "0"   "NÉT CHỮ NƯỚC"                    )
    ("....38_TNT_P_SUPPLY-TANK"               "P"   "4"     "HIDDEN"          "0"       "0"   "NÉT CẤP TÉT"                     )
    ("....39_TNT_P_SUPPLY-COOL"               "P"   "4"     "CONTINUOUS"      "0"       "0"   "NÉT CẤP LẠNH"                    )
    ("....40_TNT_P_SUPPLY-HOT"                "P"   "1"     "HIDDEN"          "0"       "0"   "NÉT CẤP NÓNG"                    )
    ("....41_TNT_P_DRAIN-TOILET"              "P"   "4"     "HIDDEN"          "0"       "0"   "NÉT THOÁT XÍ"                    )
    ("....42_TNT_P_DRAIN-RAIN"                "P"   "5"     "HIDDEN"          "0"       "0"   "NÉT THOÁT MƯA"                   )
    ("....43_TNT_P_DRAIN-WASH"                "P"   "6"     "HIDDEN"          "0"       "0"   "NÉT THOÁT RỬA"                   )
    ("....44_TNT_P_DRAIN-VENT"                "P"   "2"     "HIDDEN"          "0"       "0"   "NÉT THÔNG HƠI"                   )
    ("....45________________________________" "N"   "250"   "CONTINUOUS"      "0"       "0"   "________________________________")
    ;; FIREFIGHTING
  ))
(DEFUN TNT:LAYER:STD-NAMES (/)
  (MAPCAR 'CAR (TNT:LAYER:STD-TABLE)))
;;; ====================================================================================================
;;; [2] DANH SÁCH LAYER BỊ LOẠI TRỪ KHỎI CƠ CHẾ ÉP BYLAYER - TOOL 2
;;; ====================================================================================================
(DEFUN TNT:LAYER:STD-EXCLUDE-TABLE (/)
  '(
    ;("....20_TNT_N_TEXT"       )
    ;("....21_TNT_N_LEADER"     )
    ;("....22_TNT_N_DIMENSION"  )
    ("....23_TNT_N_HATCH"      )
    ;("....24_TNT_N_ANNOTATE"   ) 
  ))
(DEFUN TNT:LAYER:STD-EXCLUDE-NAMES (/)
  (MAPCAR 'CAR (TNT:LAYER:STD-EXCLUDE-TABLE)))
;;; ====================================================================================================
;;; [3] LOẠI BỎ KHOẢNG TRẮNG ĐẦU/CUỐI
;;; ====================================================================================================
(DEFUN TNT:STR:TRIM (s / a b)
  (if (and s (/= s ""))
    (progn
      (setq a (vl-string-right-trim " " s))
      (setq b (vl-string-left-trim " " a))
      b)
    s))
;;; ====================================================================================================
;;; END SOURCE: B_TNT_Settings_Create_Layer.lsp
;;; ====================================================================================================


;;; ====================================================================================================
;;; BEGIN SOURCE: L_TNT_Function_Create_System.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; ----------------------------------- L_TNT_FUNCTION_CREATE_SYSTEM -----------------------------------
;;; ====================================================================================================
;;; * FILE      : L_TNT_FUNCTION_CREATE_SYSTEM
;;; * PURPOSE : 
;;;   - 
;;;   - 
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; * LƯU Ý:
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [2] HÀM TẠO SYSTEM
;;; ====================================================================================================
(defun TNT_SYSTEM_CREATE ()
  (TNT:SYS:RUN-SAFE (function TNT:SYSTEM:CREATE_VARIABLES))
  (princ)
)

(defun TNT_SETTING (/)
  (TNT_SYSTEM_CREATE)
  (TNT:SYS:LOG "DONE: TNT_SETTING.")
  (princ)
)

(defun c:TNT_SETTING (/)
  (TNT_SETTING)
  (princ)
)

(defun TNT_INIT_ALL (/)
  (TNT_SETTING)
  (cond
    ((member "TNT:LAY:CREATE" (atoms-family 1))
      (TNT:SYS:RUN-SAFE (function TNT:LAY:CREATE)))
    (T
      (TNT:SYS:LOG "SKIP: TNT layer create is not loaded."))
  )
  (cond
    ((member "TNT:SHORTCUT:LAYER:INIT" (atoms-family 1))
      (TNT:SHORTCUT:LAYER:INIT))
    ((member "TNT_SHORTCUT" (atoms-family 1))
      (TNT_SHORTCUT))
    (T
      (TNT:SYS:LOG "SKIP: TNT_SHORTCUT is not loaded."))
  )
  (TNT:SYS:LOG "DONE: TNT_INIT_ALL.")
  (princ)
)

(defun c:0 (/)
  (TNT_INIT_ALL)
  (princ)
)
;;; ====================================================================================================
;;; [3] SETTING SYSTEM VARIABLES
;;; ====================================================================================================
(defun TNT:SYSTEM:CREATE_VARIABLES (/)
  ;1 GROUP INTERFACE
    (TNT:SYSTEM_SETTING "MODEMACRO" "TNT Architecture")
    (TNT:SYSTEM_SETTING "MENUBAR" 1)                        	   ;HIEN THI MENUBAR
    (TNT:SYSTEM_SETTING "COLORTHEME" 0)                          ;GIAO DIỆN TỐI
    (TNT:SYSTEM_SETTING "STATUSBAR" 1)                           ;HIỆN THỊ THANH CÔNG CỤ BÊN DƯỚI GÓC PHẢI
    (TNT:SYSTEM_SETTING "LAYOUTTAB" 1)                           ;HIỆN THỊ THANH TAB LAYOUT
    (TNT:SYSTEM_SETTING "STARTMODE" 0)                           ;TẮT HIỆN THỊ THANH START BAN ĐẦU
    (TNT:SYSTEM_SETTING "CURSORSIZE" 100)                        ;TĂNG KÍCH THƯỚC CROSSHAIR CON TRO CHUOT
    (TNT:SYSTEM_SETTING "CURSORTYPE" 0)                          ;HIEN THI CHUOT HINH CHU THAP
    ;(TNT:SYSTEM_SETTING "APERTURE" 15)                          ;DO RONG O VUONG BAT DIEM
    ;(TNT:SYSTEM_SETTING "PICKBOX" 15)                           ;DO RONG O VUONG CHON DIEM
    ;(TNT:SYSTEM_SETTING "GRIPSIZE" 15)                          ;DO RONG O VUONG CHUC NANG
  ;2 GROUP LAYER & LINETYPE
    (TNT:SYSTEM_SETTING "DIMLAYER" "....22_TNT_N_DIMENSION")   ;LAYER "DIMENTION"
    (TNT:SYSTEM_SETTING "DIMASSOC" 1)                           ;NON-ASSOCIATIVE DIMENSION OBJECTS
    (TNT:SYSTEM:DISASSOCIATE_DIMENSIONS)
    (TNT:SYSTEM_SETTING "HPLAYER" "....23_TNT_N_HATCH")        ;LAYER "HATCH"
    (TNT:SYSTEM_SETTING "TEXTLAYER" "....20_TNT_N_TEXT")        ;LAYER "TEXT"
    (TNT:SYSTEM_SETTING "MLEADERLAYER" "....21_TNT_N_LEADER")   ;LAYER "MLEADER"
    (TNT:SYSTEM_SETTING "LTSCALE" 1)                             ;TỶ LỆ NÉT VẼ THỐNG NHẤT
    (TNT:SYSTEM_SETTING "CELTYPE" "CONTINUOUS")                  ;KIỂU NÉT MẶC ĐỊNH KHI VẼ MỚI  
  ;3 GROUP TEXT & DIMSTYLE
    (TNT:SYSTEM_SETTING "TEXTALLCAPS" 1)                         ;TEXT LUON LUON CAPSLOCK  
  ;4 GROUP LEADER & HATCH    
  ;5 GROUP ANNOTATION % PROPORTION
    (TNT:SYSTEM_SETTING "CANNOSCALE" "1:1")                      ;TỶ LỆ HIỆN HÀNH CỦA ANNOTATIVE SCALE
    (TNT:SYSTEM_SETTING "SELECTIONANNODISPLAY" 0)                ;TẮT HIỆN THỊ ANNOTATIVE
    (TNT:SYSTEM_SETTING "ANNOALLVISIBLE" 0)                      ;CHỈ HIỆN THỊ ANNOTATIVE PHÙ HỢP
    (TNT:SYSTEM_SETTING "ANNOAUTOSCALE" 0)                       ;KHÔNG TỰ THÊM SCALE KHI CHỈNH VIEWPORT
  ;6 GROUP VIEWPORT & SPACE
    (TNT:SYSTEM_SETTING "MIRRTEXT" 0)                            ;CHU KHONG BI LAT NGUOC KHI MIRROR
    (TNT:SYSTEM_SETTING "MIRRHATCH" 0)                           ;HATCH KHONG BI LAT NGUOC KHI MIRROR
    (TNT:SYSTEM_SETTING "UCSICON" 0)                             ;TẮT BIỂU TƯỢNG TRỤC TOẠ ĐỘ
  ;7 GROUP BLOCK & XREF
    (TNT:SYSTEM_SETTING "INSUNITS" 4)                            ;SET MILIMETERS KHI CHEN KHOI
    (TNT:SYSTEM_SETTING "INSUNITSDEFSOURCE" 4)                   ;SET MILIMETERS KHI CHEN KHOI
    (TNT:SYSTEM_SETTING "INSUNITSDEFTARGET" 4)                   ;SET MILIMETERS KHI XUAT BAN VE
    (TNT:SYSTEM_SETTING "ATTDIA" 1)                              ;INSERT CÓ HỘP THOẠI NHẬP THUỘC TÍNH
    (TNT:SYSTEM_SETTING "ATTREQ" 1)                              ;BẬT LỜI NHẮC HOẶC HỘP THOẠI CHO CÁC GIÁ TRỊ THUỘC TÍNH, THEO CHỈ ĐỊNH CỦA ATTDIA
  ;8 GROUP PRINTING
    (TNT:SYSTEM_SETTING "FILEDIA" 1)                             ;HIỆN THỊ HỘP THOẠI TRÊN FILE MENU SAVE OPEN
  ;9 GROUP SAVE & SYSTEM
    (TNT:SYSTEM_SETTING "ISAVEBAK" 1)                            ;TAO FILE BACKUP KHI SAVE
    (TNT:SYSTEM_SETTING "SAVETIME" 30)                           ;TU DONG SAVE FILE 30 PHUT
  ;10 SELECT & DISPLAY
    (TNT:SYSTEM:ENSURE_NAVVCUBE_OFF)
    (TNT:SYSTEM_SETTING "SELECTIONEFFECT" 1)                     ;CHỌN ĐỐI TƯỢNG KHÔNG BỊ DẠNG LƯỚI
    (TNT:SYSTEM_SETTING "TRANSPARENCYDISPLAY" 0)                 ;LAYER KHÔNG BỊ MỜ
    (TNT:SYSTEM_SETTING "SELECTIONPREVIEW" 0)                    ;TẮT HIGHT KHI DI CHUỘT VÀO ĐỐI TƯỢNG
    (TNT:SYSTEM_SETTING "HIGHLIGHT" 1)                           ;BẬT HIGHT KHI CHỌN ĐỐI TƯỢNG
    (TNT:SYSTEM_SETTING "SELECTIONOFFSCREEN" 1)                  ;GIU DOI TUONG DUOC CHON KHI NAM NGOAI MAN HINH
    (TNT:SYS:LOG
      (strcat
        "SELECTIONOFFSCREEN = "
        (vl-princ-to-string (getvar "SELECTIONOFFSCREEN"))))
  ;11 DRAW
    (TNT:SYSTEM_SETTING "SNAPMODE" 0)                            ;TẮT BẮT ĐIỂM GRID
    (TNT:SYSTEM_SETTING "GRIDMODE" 0)                            ;TẮT BẮT ĐIỂM GRID 
    (TNT:SYSTEM_SETTING "OSMODE" *TNT.SYSTEM.OSMODE.DEFAULT*)     ;BAT BAT DIEM, TRU NEAREST
    (TNT:SYSTEM_SETTING "APERTURE" 20)                           ;KHOẢNG CÁCH HIỆN THỊ BẮT ĐIỂM
    (TNT:SYSTEM_SETTING "PEDITACCEPT" 1)                         ;TẠO NHANH PLINE TỪ LINE KHÔNG HIỂN THỊ HỘP THOẠI COMMAND
    (princ)
)
;;; ====================================================================================================
;;; [4] FUNCTION SYSTEM VARIABLES
;;; ====================================================================================================
(defun TNT:SYSTEM_SETTING ( PVAR PVAL / LOLDVAL)
  (setq LOLDVAL (getvar PVAR))
  (if (not (equal LOLDVAL PVAL))
    (progn
      (setvar PVAR PVAL)
      (princ (strcat "\n[TNT] DONE: CHANGE SYSTEM VARIABLE " PVAR " FROM " (vl-princ-to-string LOLDVAL) " → " (vl-princ-to-string PVAL)))
    )
  )
)

(defun TNT:SYSTEM:DISASSOCIATE_DIMENSIONS (/ LSS LOLD LERR)
  (setq LSS (ssget "_X" '((0 . "DIMENSION"))))
  (if LSS
    (progn
      (setq LOLD (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (setq LERR
        (vl-catch-all-apply
          '(lambda ()
             (vl-cmdf "_.DIMDISASSOCIATE" LSS "")
           )
        )
      )
      (setvar "CMDECHO" LOLD)
      (if (vl-catch-all-error-p LERR)
        (princ (strcat "\n[TNT] ERROR: DIMDISASSOCIATE FAILED: " (vl-catch-all-error-message LERR)))
        (princ (strcat "\n[TNT] DONE: DISASSOCIATE " (itoa (sslength LSS)) " DIMENSIONS."))
      )
    )
  )
  (princ)
)

(defun TNT:SYSTEM:ENSURE_NAVVCUBE_OFF ( / LSPACE LOLD)
  (setq LSPACE (getvar "TILEMODE"))
  (if (= LSPACE 1)
    (progn
      (setq LOLD (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.NAVVCUBE" "_Off")
      (setvar "CMDECHO" LOLD)
      (princ "\n[TNT] DONE: CHANGE SYSTEM NAVVCUBE OFF.")
    )
    (princ "\n[TNT] DONE: CANCEL CHANGE SYSTEM NAVVCUBE LAYOUT.")
  )
)

(defun TNT:SYSTEM:NORMALIZE-COMMAND (CMD / NAME)
  (setq NAME (strcase (vl-princ-to-string CMD)))
  (while
    (and
      (> (strlen NAME) 0)
      (member (substr NAME 1 1) '("." "_" "-"))
    )
    (setq NAME (substr NAME 2))
  )
  NAME
)

(defun TNT:SYSTEM:COMMAND-NAME-FROM-DATA (DATA / RAW)
  (setq RAW
    (cond
      ((and (listp DATA) DATA) (car DATA))
      ((= (type DATA) 'STR) DATA)
      (T "")
    )
  )
  (TNT:SYSTEM:NORMALIZE-COMMAND RAW)
)

;;; ----------------------------------------------------------------------------------------------------
;;; STARTUP PALETTE SUPPRESS
;;; ----------------------------------------------------------------------------------------------------
(defun TNT:SYSTEM:STARTUP-PALETTE-COMMAND? (CMD / NAME)
  (setq NAME (TNT:SYSTEM:NORMALIZE-COMMAND CMD))
  (if
    (member
      NAME
      '(
        "TOOLPALETTES"
        "AECPROJECTPALETTESTARTUP"
        "PROJECTPALETTESTARTUP"
        "AECPROJECTNAVIGATORSTARTUP"
        "PROJECTNAVIGATORSTARTUP"
      )
    )
    T
    nil
  )
)

(defun TNT:SYSTEM:CLOSE-STARTUP-PALETTES (/ OLDCE)
  (setq OLDCE (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (vl-catch-all-apply 'vl-cmdf (list "_.TOOLPALETTESCLOSE"))
  (vl-catch-all-apply 'vl-cmdf (list "_.AECCLOSEPROJECTNAVIGATOR"))
  (vl-catch-all-apply 'vl-cmdf (list "_.CLOSEPROJECTNAVIGATOR"))
  (setvar "CMDECHO" OLDCE)
  (princ)
)

(defun TNT:SYSTEM:STARTUP-PALETTE-COMMAND-END (REACTOR DATA / CMD)
  (setq CMD (TNT:SYSTEM:COMMAND-NAME-FROM-DATA DATA))
  (if (TNT:SYSTEM:STARTUP-PALETTE-COMMAND? CMD)
    (vl-catch-all-apply 'TNT:SYSTEM:CLOSE-STARTUP-PALETTES nil)
  )
  (princ)
)

(defun TNT:SYSTEM:STARTUP-PALETTE-REACTOR-INIT (/)
  (if (and (boundp '*TNT.SYSTEM.STARTUP.PALETTE.REACTOR*) *TNT.SYSTEM.STARTUP.PALETTE.REACTOR*)
    (vl-catch-all-apply 'vlr-remove (list *TNT.SYSTEM.STARTUP.PALETTE.REACTOR*))
  )
  (setq *TNT.SYSTEM.STARTUP.PALETTE.REACTOR*
    (vlr-command-reactor
      nil
      '((:vlr-commandEnded . TNT:SYSTEM:STARTUP-PALETTE-COMMAND-END))
    )
  )
  (TNT:SYSTEM:CLOSE-STARTUP-PALETTES)
  (princ)
)

(defun TNT:SYSTEM:STARTUP-PALETTE-REACTOR-OFF (/)
  (if (and (boundp '*TNT.SYSTEM.STARTUP.PALETTE.REACTOR*) *TNT.SYSTEM.STARTUP.PALETTE.REACTOR*)
    (vl-catch-all-apply 'vlr-remove (list *TNT.SYSTEM.STARTUP.PALETTE.REACTOR*))
  )
  (setq *TNT.SYSTEM.STARTUP.PALETTE.REACTOR* nil)
  (princ)
)

(defun TNT:SYSTEM:COMMAND-REACTORS-INIT (/)
  (if *TNT.SYSTEM.ENABLE.COMMAND.REACTORS*
    (progn
      (vl-catch-all-apply 'TNT:SYSTEM:STARTUP-PALETTE-REACTOR-INIT nil)
    )
    (progn
      (TNT:SYSTEM:STARTUP-PALETTE-REACTOR-OFF)
    )
  )
  (princ)
)
;;; ====================================================================================================
;;; END SOURCE: L_TNT_Function_Create_System.lsp
;;; ====================================================================================================

;;; ----------------------------------------------------------------------------------------------------
;;; End
;;; ----------------------------------------------------------------------------------------------------
(TNT:SYSTEM:COMMAND-REACTORS-INIT)
(TNT:SYSTEM:CLEAN-OSMODE-RESET-REACTORS)
(TNT:SYS:LOG "TNT system settings loaded. No package autoload was executed.")
(princ)
