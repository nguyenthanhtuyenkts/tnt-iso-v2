;;; ====================================================================================================
;;; ---------------------------------- N_010_FUNCTION_CREATE_SHORTCUT ----------------------------------
;;; ====================================================================================================
;;; * FILE    : J_010_FUNCTION_CREATE_SHORTCUT.LSP
;;; * PURPOSE : TẠO / CẬP NHẬT PHÍM TẮT (ALIAS) CHO AUTOCAD
;;;   - TẠO THEO TỪNG FILE CAD
;;;   - 
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; * LƯU Ý:
;;;   - GỌI LỆNH TRONG COMMAND:
;;;     + "-LENH"   : GỌI LỆNH KHÔNG DÙNG HỘP THOẠI
;;;     + "_LENH"   : GỌI LỆNH TIENG ANH ENGLISH
;;;     + ".LENH"   : GỌI LỆNH GOC NGUYEN THUY
;;;     + "'LENH"   : GỌI LỆNH KHI DANG DUNG LENH KHAC
;;;     + "LENH"    : GỌI LỆNH BINH THUONG TUY CAD
;;;     + "C:"      : LÀ LỆNH TẮT, TRONG COMMAND
;;;   - PHÂN LOẠI LỆNH TẮT THEO NHÓM:
;;;     + GROUP 1 - SYSTEM/SETUP  - (010:SHORTCUT:CMD:SYS:*)
;;;     + GROUP 2 - MANAGEMENT    - (010:SHORTCUT:CMD:MGT:*)
;;;     + GROUP 3 - DRAW GEOMETRY - (010:SHORTCUT:CMD:DRAW*)
;;;     + GROUP 4 - MODIFY        - (010:SHORTCUT:CMD:MOD:*)
;;;     + GROUP 5 - ANNOTATION    - (010:SHORTCUT:CMD:ANNO:*)
;;;     + GROUP 6 - CUSTOM TOOLS  - (010:SHORTCUT:CMD:TOOLS:*)
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; [1] HÀM TẠO SHORTCUT
;;; ====================================================================================================
(defun 010_SHORTCUT_CREATE ()
  (010:SYS:RUN-SAFE (function 010:SHORTCUT:MAKE:RUNTIME))
  (princ)
)
;;; ====================================================================================================
;;; [2] ACTION FUNCTION
;;; ====================================================================================================
;; * GROUP 1 - SYSTEM/SETUP - (010:SHORTCUT:CMD:SYS:*)
;; * GROUP 2 - MANAGEMENT - (010:SHORTCUT:CMD:MGT:*)
(defun 010:SHORTCUT:CMD:MGT:SE1 (/)     (command ".OSMODE" 16383)        (princ))
(defun 010:SHORTCUT:CMD:MGT:G1  (/)     (if (= (getvar "PICKSTYLE") 0)  (setvar "PICKSTYLE" 1)  (setvar "PICKSTYLE" 0)) (princ))
(defun 010:SHORTCUT:CMD:MGT:C1  (/ LT)  (setq LT (getvar "TILEMODE"))   (setvar "TILEMODE" (if (= LT 0) 1 0))           (princ))
(defun 010:SHORTCUT:CMD:MGT:C2  (/)     (command ".LAYOUT" "S" "")      (princ))
(defun 010:SHORTCUT:CMD:MGT:C3  (/)     (command ".MODEL")              (princ))
(defun 010:SHORTCUT:CMD:MGT:V1  (/)     (command ".-VPORTS" "2" "V")   (princ))
(defun 010:SHORTCUT:CMD:MGT:V2  (/)     (command ".-VPORTS" "2" "H")   (princ))
(defun 010:SHORTCUT:CMD:MGT:V3  (/)     (command ".-VPORTS" "SI")      (princ))
;; * GROUP 3 - DRAW GEOMETRY - (010:SHORTCUT:CMD:DRAW*)
(defun 010:SHORTCUT:CMD:DRAW:BB   (/) (command ".BOUNDARY")   (princ))
(defun 010:SHORTCUT:CMD:DRAW:CC   (/) (command ".CIRCLE")     (princ))
(defun 010:SHORTCUT:CMD:DRAW:R    (/) (command ".RECTANG")    (princ))
(defun 010:SHORTCUT:CMD:DRAW:XZ   (/) (command ".XLINE")      (princ))
(defun 010:SHORTCUT:CMD:DRAW:`    (/) (command ".LINE")       (princ))
(defun 010:SHORTCUT:CMD:DRAW:``   (/) (command ".PLINE")      (princ))
(defun 010:SHORTCUT:CMD:DRAW:```  (/) (command ".SPLINE")     (princ))
(defun 010:SHORTCUT:CMD:DRAW:1`   (/) (command ".XLINE" "V")  (princ))
(defun 010:SHORTCUT:CMD:DRAW:2`   (/) (command ".XLINE" "H")  (princ))
;; * GROUP 4 - MODIFY - (010:SHORTCUT:CMD:MOD:*)
(defun 010:SHORTCUT:CMD:MOD:C     (/ A B)   (setq A (ssget) B (getpoint "\n SELECT POINT:"))  (command "COPY" A "" "M" B)       (princ))
(defun 010:SHORTCUT:CMD:MOD:CV    (/ A B)   (setq A (ssget) B (getpoint "\n SELECT BASE POINT:")) (command ".COPYBASE" B A "")  (princ))
(defun 010:SHORTCUT:CMD:MOD:ATT   (/)       (command ".ATTIPEDIT")  (princ))
(defun 010:SHORTCUT:CMD:MOD:BR    (/ A B)   (setq A (ssget) B (getpoint "\n SELECT POINT:")) (command ".BREAK" A B B) (princ))
(defun 010:SHORTCUT:CMD:MOD:TT    (/)       (command ".TRIM")       (princ))
(defun 010:SHORTCUT:CMD:MOD:SF    (/)       (command ".OFFSET")     (princ))
(defun 010:SHORTCUT:CMD:MOD:FF    (/)       (command ".MIRROR")     (princ))
(defun 010:SHORTCUT:CMD:MOD:RT    (/)       (command ".ROTATE")     (princ))
(defun 010:SHORTCUT:CMD:MOD:E1    (/)       (command ".EXTEND")     (princ))
(defun 010:SHORTCUT:CMD:MOD:V     (/)       (command ".MOVE")       (princ))
(defun 010:SHORTCUT:CMD:MOD:Q     (/)       (command ".MATCHPROP")  (princ))
(defun 010:SHORTCUT:CMD:MOD:REF   (/)       (command ".-REFEDIT" "O" "A" "Y")  (princ))
(defun 010:SHORTCUT:CMD:MOD:REFC  (/)       (command ".REFCLOSE" "S" "")       (princ))
(defun 010:SHORTCUT:CMD:MOD:BE    (/)       (command ".-BEDIT")                (princ))
(defun 010:SHORTCUT:CMD:MOD:BC    (/)       (command ".BCLOSE" "")             (princ))
(defun 010:SHORTCUT:CMD:MOD:F     (/)       (command ".FILLET")                (princ))
(defun 010:SHORTCUT:CMD:MOD:F1    (/)       (command ".AECFILLET")             (princ))
(defun 010:SHORTCUT:CMD:MOD:DRF   (/ A)     (setq A (ssget)) (command ".DRAWORDER" A "" "F") (princ))
(defun 010:SHORTCUT:CMD:MOD:DRB   (/ A)     (setq A (ssget)) (command ".DRAWORDER" A "" "B") (princ))
(defun 010:SHORTCUT:CMD:MOD:XRE   (/)       (command ".-XREF" "R" "*") (princ))
(defun 010:SHORTCUT:CMD:MOD:SD    (/)       (sssetfirst nil (ssget (list (cons 0 "DIMENSION"))))    (princ))
(defun 010:SHORTCUT:CMD:MOD:SA    (/)       (sssetfirst nil (ssget (list (cons 0 "LEADER"))))       (princ))
(defun 010:SHORTCUT:CMD:MOD:SB    (/)       (sssetfirst nil (ssget (list (cons 0 "INSERT"))))       (princ))
(defun 010:SHORTCUT:CMD:MOD:ST    (/)       (sssetfirst nil (ssget (list (cons 0 "*TEXT,LEADER")))) (princ))
(defun 010:SHORTCUT:CMD:MOD:SHT   (/)       (sssetfirst nil (ssget (list (cons 0 "HATCH"))))        (princ))
;; * GROUP 5 - ANNOTATION - (010:SHORTCUT:CMD:ANNO:*)
(defun 010:SHORTCUT:CMD:ANNO:1 (/)
  (010:SYS:RUN-SAFE (function (lambda () (setvar "CMDECHO" 0) (setvar "DIMLAYER" ".") (command "._LAYISO") (setvar "CMDECHO" 1))))
  (princ))
(defun 010:SHORTCUT:CMD:ANNO:2 (/)        (command "._LAYOFF") (princ))
(defun 010:SHORTCUT:CMD:ANNO:3 (/)
  (010:SYS:RUN-SAFE (function (lambda () (setvar "CMDECHO" 0) (setvar "DIMLAYER" "...11_TNT_LINE_DIMENSION") (command "-LAYER" "ON" "*" "") (setvar "CMDECHO" 1))))
  (princ))
(defun 010:SHORTCUT:CMD:ANNO:QQ (/)       (command ".LAYMCUR") (princ))
(defun 010:SHORTCUT:CMD:ANNO:D  (/)       (command ".DIMLINEAR") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DA (/)       (command ".DIMALIGNED") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DN (/)       (command ".DIMANGULAR") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DG (/)       (command ".DIMRADIUS") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DC (/)       (command ".DIMCONTINUE") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DS (/)       (command "DIMSETINSERT") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DE (/)       (command "DIMSETDELETE") (princ))
(defun 010:SHORTCUT:CMD:ANNO:DX (/ A)     (setq A (ssget)) (command "DIMSETEXTEND" A "E") (princ))
(defun 010:SHORTCUT:CMD:ANNO:D1 (/ A B)   (setq A (getint "\n NHẬP TỶ LỆ: "))
  (if (/= A 0) (progn (setq B (/ 1.0 A))  (command ".DIMLFAC" B)) (princ "\nLỗi: TỶ LỆ không thể bằng 0.")) (princ))
(defun 010:SHORTCUT:CMD:ANNO:D2 (/)       (command ".DIMSCALE") (princ))
(defun 010:SHORTCUT:CMD:ANNO:WQ (/)       (command ".WIPEOUT") (princ))

;; * GROUP 6 - CUSTOM TOOLS - (010:SHORTCUT:CMD:TOOLS:*)
(defun 010:SHORTCUT:CMD:TOOLS:PU (/)
  (010:SYS:RUN-SAFE
    (function (lambda ()
      (setvar "CMDECHO" 0)
      (command ".-PURGE" "ALL" "" "N")
      (command ".-PURGE" "R" "" "N")
      (command ".AUDIT" "Y")
      (setvar "CMDECHO" 1))))
  (princ))
(defun 010:SHORTCUT:CMD:TOOLS:DXF (/ MA MA1)
  (setq MA (car (entsel)) MA1 (entget MA)) (princ MA1) (princ))
;;; ====================================================================================================
;;; [3] CONFIG MẶC ĐỊNH
;;; ====================================================================================================
(setq *010.CFG.SC*
  '(
    ;; GROUP 2 - MANAGEMENT
    ("SE1"  . 010:SHORTCUT:CMD:MGT:SE1)
    ("G1"   . 010:SHORTCUT:CMD:MGT:G1)
    ("C1"   . 010:SHORTCUT:CMD:MGT:C1)
    ("C2"   . 010:SHORTCUT:CMD:MGT:C2)
    ("C3"   . 010:SHORTCUT:CMD:MGT:C3)
    ("V1"   . 010:SHORTCUT:CMD:MGT:V1)
    ("V2"   . 010:SHORTCUT:CMD:MGT:V2)
    ("V3"   . 010:SHORTCUT:CMD:MGT:V3)
    ;; GROUP 3 - DRAW GEOMETRY
    ("BB"   . 010:SHORTCUT:CMD:DRAW:BB)
    ("CC"   . 010:SHORTCUT:CMD:DRAW:CC)
    ("R"    . 010:SHORTCUT:CMD:DRAW:R)
    ("XZ"   . 010:SHORTCUT:CMD:DRAW:XZ)
    ("`"    . 010:SHORTCUT:CMD:DRAW:`)
    ("``"   . 010:SHORTCUT:CMD:DRAW:``)
    ("```"  . 010:SHORTCUT:CMD:DRAW:```)
    ("1`"   . 010:SHORTCUT:CMD:DRAW:1`)
    ("2`"   . 010:SHORTCUT:CMD:DRAW:2`)
    ;; GROUP 4 - MODIFY
    ("C"    . 010:SHORTCUT:CMD:MOD:C)
    ("CV"   . 010:SHORTCUT:CMD:MOD:CV)
    ("ATT"  . 010:SHORTCUT:CMD:MOD:ATT)
    ("BR"   . 010:SHORTCUT:CMD:MOD:BR)
    ("TT"   . 010:SHORTCUT:CMD:MOD:TT)
    ("SF"   . 010:SHORTCUT:CMD:MOD:SF)
    ("FF"   . 010:SHORTCUT:CMD:MOD:FF)
    ("RT"   . 010:SHORTCUT:CMD:MOD:RT)
    ("E1"   . 010:SHORTCUT:CMD:MOD:E1)
    ("V"    . 010:SHORTCUT:CMD:MOD:V)
    ("Q"    . 010:SHORTCUT:CMD:MOD:Q)
    ("REF"  . 010:SHORTCUT:CMD:MOD:REF)
    ("REFC" . 010:SHORTCUT:CMD:MOD:REFC)
    ("BE"   . 010:SHORTCUT:CMD:MOD:BE)
    ("BC"   . 010:SHORTCUT:CMD:MOD:BC)
    ("F"    . 010:SHORTCUT:CMD:MOD:F)
    ("F1"   . 010:SHORTCUT:CMD:MOD:F1)
    ("DF"   . 010:SHORTCUT:CMD:MOD:DRF)
    ("DB"   . 010:SHORTCUT:CMD:MOD:DRB)
    ("XRE"  . 010:SHORTCUT:CMD:MOD:XRE)
    ;; SELECT
    ("SD"   . 010:SHORTCUT:CMD:MOD:SD)
    ("SA"   . 010:SHORTCUT:CMD:MOD:SA)
    ("SB"   . 010:SHORTCUT:CMD:MOD:SB)
    ("ST"   . 010:SHORTCUT:CMD:MOD:ST)
    ("SHT"  . 010:SHORTCUT:CMD:MOD:SHT)
    ;; GROUP 5 - ANNOTATION
    ("1"    . 010:SHORTCUT:CMD:ANNO:1)
    ("2"    . 010:SHORTCUT:CMD:ANNO:2)
    ("3"    . 010:SHORTCUT:CMD:ANNO:3)
    ("QQ"   . 010:SHORTCUT:CMD:ANNO:QQ)
    ("D"    . 010:SHORTCUT:CMD:ANNO:D)
    ("DA"   . 010:SHORTCUT:CMD:ANNO:DA)
    ("DN"   . 010:SHORTCUT:CMD:ANNO:DN)
    ("DG"   . 010:SHORTCUT:CMD:ANNO:DG)
    ("DC"   . 010:SHORTCUT:CMD:ANNO:DC)
    ("DS"   . 010:SHORTCUT:CMD:ANNO:DS)
    ("DE"   . 010:SHORTCUT:CMD:ANNO:DE)
    ("DX"   . 010:SHORTCUT:CMD:ANNO:DX)
    ("D1"   . 010:SHORTCUT:CMD:ANNO:D1)
    ("D2"   . 010:SHORTCUT:CMD:ANNO:D2)
    ;; GROUP 6 - CUSTOM TOOLS
    ("PU"   . 010:SHORTCUT:CMD:TOOLS:PU)
    ("DXF"  . 010:SHORTCUT:CMD:TOOLS:DXF)
  )
)
;;; ====================================================================================================
;;; [4] ĐỘNG BỘ LỆNH TẮT 
;;; ====================================================================================================
;; TẠO 1 COMMAND C:ALIAS GỌI VÀO HÀM HÀNH ĐỘNG FN
(defun 010:SHORTCUT:REGISTER (PALIAS PFN / LSYM)
  (if (and (= (type PALIAS) 'STR) PFN)
    (progn
      (setq LSYM (read (strcat "C:" PALIAS)))
      (eval (list 'defun LSYM '(/) (list '010:SYS:RUN-SAFE (list 'quote PFN)) '(princ)))))
  LSYM)
;; ĐĂNG KÝ TỪ DANH SÁCH CẤU HÌNH
(defun 010:SHORTCUT:REGISTER-LIST (PCFG / LIT)  
  (foreach LIT PCFG
    (010:SHORTCUT:REGISTER (car LIT) (cdr LIT)))
  (princ))
;;; ====================================================================================================
;;; [5] PUBLIC API / COMMANDS
;;; ====================================================================================================
(defun 010:SHORTCUT:MAKE:RUNTIME (/)  
  (010:SHORTCUT:REGISTER-LIST *010.CFG.SC*)
  (princ))
(defun 010_SHORTCUT_CREATE (/) 
  (010:SYS:RUN-SAFE (function 010:SHORTCUT:MAKE:RUNTIME))
  (princ))
;;; ====================================================================================================
;;; [6] AUTORUN (nạp là có lệnh C:ALIAS ngay) – KHÔNG gọi lệnh người dùng, chỉ đăng ký alias
;;; ====================================================================================================
(010:SHORTCUT:MAKE:RUNTIME)
(princ)