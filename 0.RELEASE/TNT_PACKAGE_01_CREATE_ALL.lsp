;;; ====================================================================================================
;;; TNT_PACKAGE_01_CREATE_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: I_TNT_Function_Create_Layer.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; *** I_TNT_FUNCTION_CREATE_LAYER ***
;;; ====================================================================================================
;;; * FILE    : I_TNT_FUNCTION_CREATE_LAYER
;;; * PURPOSE : 
;;;   - GỌI LỆNH LUÔN TẠO MỚI NẾU CHƯA CÓ.
;;;   - GHI ĐÈ THUỘC TÍNH NẾU LAYER ĐÃ TỒN TẠI.
;;;   - NẾU NGƯỜI DÙNG ĐỔI THUỘC TÍNH → LẦN GỌI LỆNH TIẾP THEO RESET VỀ CHUẨN ISO TRONG DANH SÁCH.
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
;;; [1] HÀM TẠO LAYER
;;; ====================================================================================================
(DEFUN TNT:LAY:CREATE (/ DOC)
  (TNT:SYS:RUN-SAFE
    (FUNCTION
      (LAMBDA (/)
        (MAPCAR '(LAMBDA (X) (APPLY 'TNT:LAYER:MAKE X))
                (TNT:LAYER:STD-TABLE))
        ;; REGEN MỘT LẦN SAU CÙNG
        (SETQ DOC (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)))
        (VL-CATCH-ALL-APPLY '(LAMBDA () (VLA-REGEN DOC ACALLVIEWPORTS)))
      ))))

(DEFUN TNT_LAYER_CREATE (/)
  (TNT:SYS:RUN-SAFE (FUNCTION TNT:LAY:CREATE))
  (PRINC))
;;; ====================================================================================================
;;; [2] HÀM HỖ TRỢ
;;; ====================================================================================================
(DEFUN TNT:LAY:_YN->BOOL (PLOT / S)
  (SETQ S (STRCASE (VL-PRINC-TO-STRING PLOT)))
  (IF (MEMBER S '("P" "Y" "YES" "TRUE" "PLOT" "1")) :VLAX-TRUE :VLAX-FALSE))

(DEFUN TNT:LAY:_ACI (C)
  (COND ((NULL C) 7) ((= (TYPE C) 'INT) C) (T (ATOI (VL-PRINC-TO-STRING C)))))

(DEFUN TNT:LAY:_LW (LW)
  (COND ((OR (NULL LW) (= (VL-PRINC-TO-STRING LW) "") (= (STRCASE (VL-PRINC-TO-STRING LW)) "0"))
         ACLNWTBYLAYER)
        (T (ATOI (VL-PRINC-TO-STRING LW)))))

(DEFUN TNT:LAY:ENSURE-LTYPE (LTYPE / FNAME FPATH)
  (IF (AND (EQ (TYPE LTYPE) 'STR) (> (STRLEN LTYPE) 0)
           (NOT (MEMBER (STRCASE LTYPE) '("BYLAYER" "BYBLOCK" "CONTINUOUS"))))
    (IF (NOT (TBLSEARCH "LTYPE" LTYPE))
      (PROGN
        (SETQ FNAME (IF (= (GETVAR "MEASUREMENT") 1) "ACADISO.LIN" "ACAD.LIN"))
        (SETQ FPATH (FINDFILE FNAME))
        (IF FPATH
          (VL-CATCH-ALL-APPLY
            '(LAMBDA ()
               (VLA-LOAD (VLA-GET-LINETYPES
                           (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)))
                         LTYPE
                         FPATH)))))))
  (PRINC))

(DEFUN TNT:LAY:DESCRIPTION (NAME DESC / DOC LAY)
  (IF (AND NAME DESC (/= DESC ""))
    (PROGN
      (SETQ DOC (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)))
      (SETQ LAY (VLA-ITEM (VLA-GET-LAYERS DOC) NAME))
      (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-DESCRIPTION (LIST LAY DESC))))
  (PRINC))
;;; ====================================================================================================
;;; [3] TẠO/ĐỒNG BỘ 1 LAYER CHUẨN
;;; ====================================================================================================
(DEFUN TNT:LAYER:MAKE (NAME PLOT COLOR LTYPE LW TR DESC / 
                         DOC LAYS LAY PBOOL ACI LWVAL TRVAL TROBJ LWF LW100 VALID BEST DIFF CUR)
  (TNT:SYS:RUN-SAFE
    (FUNCTION
      (LAMBDA (/)
        ;; TÀI LIỆU & TẬP LAYERS
        (SETQ DOC  (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)))
        (SETQ LAYS (VLA-GET-LAYERS DOC))
        ;; TẠO LAYER NẾU THIẾU
        (SETQ LAY (VL-CATCH-ALL-APPLY '(LAMBDA () (VLA-ITEM LAYS NAME))))
        (IF (VL-CATCH-ALL-ERROR-P LAY) (SETQ LAY (VLA-ADD LAYS NAME)))
        ;; BẬT/THAW/UNLOCK
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-LAYERON (LIST LAY :VLAX-TRUE))
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-FREEZE  (LIST LAY :VLAX-FALSE))
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-LOCK    (LIST LAY :VLAX-FALSE))
        ;; ĐẢM BẢO LINETYPE CÓ TRONG BẢN VẼ
        (TNT:LAY:ENSURE-LTYPE LTYPE)
        ;; PLOTTABLE
        (SETQ PBOOL (TNT:LAY:_YN->BOOL PLOT))
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-PLOTTABLE (LIST LAY PBOOL))
        ;; COLOR
        (SETQ ACI (TNT:LAY:_ACI COLOR))
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-COLOR (LIST LAY ACI))
        ;; LINETYPE STRING
        (IF (AND LTYPE (EQ (TYPE LTYPE) 'STR) (> (STRLEN LTYPE) 0))
          (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-LINETYPE (LIST LAY (VL-PRINC-TO-STRING LTYPE))))
        ;; LINEWEIGHT
        (COND
          ((OR (NULL LW) (= (VL-PRINC-TO-STRING LW) "") (= (STRCASE (VL-PRINC-TO-STRING LW)) "0"))
           (SETQ LWVAL ACLNWTBYLAYER))
          ((= (TYPE LW) 'INT)
           (SETQ LWVAL LW))
          (T
           (PROGN
             (SETQ LWF (ATOF (VL-PRINC-TO-STRING LW)))
             (SETQ LW100 (FIX (+ (* LWF 100) 0.5)))
             (SETQ VALID '(0 13 18 20 25 30 35 40 50 53 60 70 80 90 100))
             (SETQ BEST (CAR VALID))
             (SETQ DIFF (ABS (- LW100 BEST)))
             (FOREACH CUR VALID
               (IF (< (ABS (- LW100 CUR)) DIFF)
                 (PROGN (SETQ BEST CUR) (SETQ DIFF (ABS (- LW100 CUR))))))
             (SETQ LWVAL BEST))))
        (IF (VLAX-PROPERTY-AVAILABLE-P LAY 'LINEWEIGHT)
          (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-LINEWEIGHT (LIST LAY LWVAL)))
        ;; TRANSPARENCY
        (COND
          ((OR (NULL TR) (= (VL-PRINC-TO-STRING TR) "") (= (STRCASE (VL-PRINC-TO-STRING TR)) "0"))
           (SETQ TRVAL 0))
          ((= (TYPE TR) 'INT)
           (SETQ TRVAL (MAX 0 (MIN 90 TR))) )
          (T
           (PROGN
             (SETQ TRS (VL-PRINC-TO-STRING TR))
             (IF (/= (VL-STRING-SEARCH "." TRS) NIL)
               (PROGN (SETQ TRF (ATOF TRS))
                      (SETQ TR100 (FIX (+ (* TRF 100) 0.5)))
                      (SETQ TRVAL (MAX 0 (MIN 90 TR100))))
               (PROGN (SETQ TRI (ATOI TRS))
                      (SETQ TRVAL (MAX 0 (MIN 90 TRI)))) ))))
        (IF (/= TRVAL 0)
          (PROGN
            (VL-CMDF "_.-LAYER" "_TR" (ITOA TRVAL) (VL-PRINC-TO-STRING NAME) "")))
  (TNT:LAY:DESCRIPTION NAME DESC)
      ))))
;;; ====================================================================================================
;;; END
;;; ====================================================================================================
;;; ====================================================================================================
;;; END SOURCE: I_TNT_Function_Create_Layer.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: J_TNT_Function_Create_Textstyle.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; ---------------------------------- J_TNT_FUNCTION_CREATE_TEXTSTYLE ---------------------------------
;;; ====================================================================================================
;;; * FILE    : J_TNT_FUNCTION_CREATE_TEXTSTYLE
;;; * PURPOSE : Tạo/cập nhật TEXTSTYLE an toàn cho
;;;   - SHX: uromans.shx
;;;   - TTF: UNI HelvetIns (H)
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
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [2] HÀM TẠO TEXT STYLE
;;; ====================================================================================================
(defun TNT_TEXTSTYLE_CREATE (/)
  (TNT:SYS:RUN-SAFE (function TNT:TS:MAKE-ALL))
  (princ))
;;; ====================================================================================================
;;; [3] FS — SAFE HELPERS (NHÓM HÀM AN TOÀN “FILE/SYSTEM”)
;;; ====================================================================================================
(defun TNT:TS:GET-COLL (/)
  (vla-get-TextStyles (vla-get-ActiveDocument (vlax-get-acad-object))))

(defun TNT:TS:ENSURE (PNAME PFONT_OR_FACE PH PW POBL PBIG / LCOLL LSTY LLOW LEXT LFONTPATH LFACE)
  (setq LCOLL (TNT:TS:GET-COLL))
  (setq LSTY  (if (tblsearch "style" PNAME)
                (vlax-ename->vla-object (tblobjname "style" PNAME))
                (vla-Add LCOLL PNAME)))
  (TNT:FS:SAFE-PUT LSTY 'Height (abs (if PH PH 0.0)))
  (TNT:FS:SAFE-PUT LSTY 'Width  (if PW PW 1.0))
  (TNT:FS:SAFE-PUT LSTY 'ObliqueAngle (* pi (/ (abs (if POBL POBL 0.0)) 180.0)))
  (setq LLOW (TNT:FS:STR-LOWER PFONT_OR_FACE))
  (setq LEXT (TNT:FS:EXT PFONT_OR_FACE))
  (cond
    ((wcmatch LLOW "*.shx")
     (setq LFONTPATH (TNT:FS:FIND-FONTFILE PFONT_OR_FACE))
     (TNT:FS:SAFE-PUT LSTY 'FontFile LFONTPATH)
     (TNT:FS:SAFE-PUT LSTY 'BigFontFile (if PBIG PBIG "")))
    ((= LEXT "ttf")
     (setq LFACE (substr PFONT_OR_FACE 1 (- (strlen PFONT_OR_FACE) 4)))
     (TNT:FS:SAFE-CALL LSTY 'vla-SetFont (list LFACE :vlax-false :vlax-false 0 0))
    )
    (T
     (TNT:FS:SAFE-CALL LSTY 'vla-SetFont (list PFONT_OR_FACE :vlax-false :vlax-false 0 0))
    )
  )
  LSTY)
;;; ====================================================================================================
;;; [5] ĐẶT TEXTSTYLE HIỆN HÀNH
;;; ====================================================================================================
(defun TNT:TS:SET-CURRENT (PNAME /)
  (if (tblsearch "style" PNAME) (setvar "TEXTSTYLE" PNAME))
  (princ))
;;; ====================================================================================================
;;; [6] MAKE-ALL — TẠO 3 STYLE THEO YÊU CẦU
;;; ====================================================================================================
(defun TNT:TS:MAKE-ALL (/ PNAME)
  (TNT:TS:ENSURE ".TNT_A_TXT_1_MAIN" "UNI HelvetIns (H)"     0.0 1.0 0.0 nil)
  (TNT:TS:ENSURE ".TNT_A_TXT_2_SUB"  "UNI Alter Gothic (H)"  0.0 1.0 0.0 nil)
  (TNT:TS:ENSURE ".TNT_A_TXT_3_NOTE" "uromans.shx"           0.0 0.8 0.0 nil)
  (setq PNAME ".TNT_A_TXT_3_NOTE")
  (TNT:TS:SET-CURRENT PNAME))
;;; ====================================================================================================
;;; [7] COMMANDS - LỆNH
;;; ====================================================================================================
(defun TNT_TS_SET (/ K)
  (TNT:TS:MAKE-ALL)
  (initget "1 2 3")
  (setq K (getkword
    "\nChon STYLE [1=.TNT_A_TXT_3_NOTE / 2=.TNT_A_TXT_1_MAIN / 3=.TNT_A_TXT_2_SUB] <1>: "))
  (cond
    ((= K "2") (setvar "TEXTSTYLE" ".TNT_A_TXT_1_MAIN"))
    ((= K "3") (setvar "TEXTSTYLE" ".TNT_A_TXT_2_SUB"))
    (T        (setvar "TEXTSTYLE" ".TNT_A_TXT_3_NOTE"))
  )
  (princ (strcat "\n[TNT] Current TEXTSTYLE = " (getvar "TEXTSTYLE")))
  (princ))
;;; ====================================================================================================
;;; END
;;; ====================================================================================================
;;; ====================================================================================================
;;; END SOURCE: J_TNT_Function_Create_Textstyle.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: K_TNT_Function_Create_Dimension.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; *** K_TNT_FUNCTION_CREATE_DIMENSION ***
;;; ====================================================================================================
;;; * FILE    : K_TNT_FUNCTION_CREATE_DIMENSION
;;; * PURPOSE : 
;;;   - GỌI LỆNH LUÔN TẠO MỚI NẾU CHƯA CÓ.
;;;   - GHI ĐÈ THUỘC TÍNH NẾU DIMENSION ĐÃ TỒN TẠI.
;;;   - NẾU NGƯỜI DÙNG ĐỔI THUỘC TÍNH → LẦN GỌI LỆNH TIẾP THEO RESET VỀ CHUẨN ISO.
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [1] HÀM TẠO DIMENSION --------------------------------------
;;; ====================================================================================================
(defun TNT_DIMENSION_CREATE (/)
  (TNT:SYS:RUN-SAFE
    (function
      (lambda (/)
        (TNT_A_DIM_1)
        (TNT_A_DIM_2)
        (TNT_A_DIM_3)
      )
     )
   )
  (princ)
)
;;; ====================================================================================================
;;; [2] HÀM CON DIMENSION
;;; ====================================================================================================
(defun TNT:DIM:SET-NONASSOC (/)
  (vl-catch-all-apply 'setvar (list "DIMASSOC" 1))
  (princ)
)

(defun TNT_A_DIM_1 ()  
  (setvar "cmdecho" 0)
  (TNT:DIM:SET-NONASSOC)
  (if (not (tblsearch "dimstyle" ".TNT_A_DIM_1"))
  (progn    
    (command "DIMSTYLE"         "R"         "Standard")
    (TNT:TS:ENSURE ".TNT_A_TXT_3_NOTE" "uromans.shx" 0.0 0.8 0.0 nil)
    (TNT:DIM:SET-NONASSOC)                  ;Dimension object, not attached to geometry
    (command "DIMADEC"          "0")        ;Angular decimal places
    (command "DIMALT"           "Off")      ;Alternate units selected
    (command "DIMALTD"          "2")        ;Alternate unit decimal places
    (command "DIMALTF"          "25.4")     ;Alternate unit scale factor   
    (command "DIMALTRND"        "0")        ;Alternate units rounding value
    (command "DIMALTTD"         "2")        ;Alternate tolerance decimal places
    (command "DIMALTTZ"         "0")        ;Alternate tolerance zero suppression
    (command "DIMALTU"          "2")        ;Alternate units
    (command "DIMALTZ"          "0")        ;Alternate unit zero suppression
    (command "DIMAPOST"         "")         ;Prefix and suffix for alternate text
    (command "DIMARCSYM"        "0")        ;Arc length symbol
    (command "DIMASZ"           "1.10")     ;Arrow size
    (command "DIMATFIT"         "3")        ;Arrow and text fit
    (command "DIMAUNIT"         "0")        ;Angular unit format
    (command "DIMAZIN"          "0")        ;Angular zero supression
    (command "DIMBLK"           "ArchTick") ;Arrow block name
    (command "DIMBLK1"          "")         ;First arrow block name
    (command "DIMBLK2"          "")         ;Second arrow block name
    (command "DIMCEN"           "0.09")     ;Center mark size
    (command "DIMCLRD"          "256")      ;Dimension line and leader color
    (command "DIMCLRE"          "256")      ;Extension line color
    (command "DIMCLRT"          "14")       ;Dimension text color
    (command "DIMDEC"           "0")        ;Decimal places
    (command "DIMDLE"           "1.1")      ;Dimension line extension
    (command "DIMDLI"           "5")        ;Dimension line spacing
    (command "DIMDSEP"          ".")        ;Decimal separator
    (command "DIMEXE"           "1.1")      ;Extension above dimension line
    (command "DIMEXO"           "0")        ;Extension line origin offset
    (command "DIMFRAC"          "0")        ;Fraction format
    (command "DIMFXL"           "0")        ;Fixed Extension Line
    (command "DIMFXLON"         "Off")      ;Enable Fixed Extension Line
    (command "DIMGAP"           "0.7")      ;Gap from dimension line to text
    (command "DIMJOGANG"        "90")       ;Radius dimension jog angle
    (command "DIMJUST"          "0")        ;Justification of text on dimension line
    (command "DIMLDRBLK"        "")         ;Leader block name
    (command "DIMLFAC"          "1")        ;Linear unit scale factor
    (command "DIMLIM"           "Off")      ;Generate dimension limits
    (command "DIMLTEX1"         "ByBlock")  ;Linetype extension line 1
    (command "DIMLTEX2"         "ByBlock")  ;Linetype extension line 2
    (command "DIMLTYPE"         "ByBlock")  ;Dimension linetype
    (command "DIMLUNIT"         "2")        ;Linear unit format
    (command "DIMLWD"           "-2")       ;Dimension line and leader lineweight
    (command "DIMLWE"           "-2")       ;Extension line lineweight   
    (command "DIMPOST"          "")         ;Prefix and suffix for dimension text
    (command "DIMRND"           "0")        ;Rounding value
    (command "DIMSAH"           "Off")      ;Separate arrow blocks
    (command "DIMSCALE"         "1")        ;Overall scale factor
    (command "DIMSD1"           "Off")      ;Suppress the first dimension line
    (command "DIMSD2"           "Off")      ;Suppress the second dimension line
    (command "DIMSE1"           "Off")      ;Suppress the first extension line
    (command "DIMSE2"           "Off")      ;Suppress the second extension line
    (command "DIMSOXD"          "Off")      ;Suppress outside dimension lines
    (command "DIMTAD"           "1")        ;Place text above the dimension line
    (command "DIMTDEC"          "0")        ;Tolerance decimal places
    (command "DIMTFAC"          "1")        ;Tolerance text height scaling factor
    (command "DIMTFILL"         "0")        ;Text background enabled
    (command "DIMTFILLCLR"      "256")      ;Text background color
    (command "DIMTIH"           "Off")      ;Text inside extensions is horizontal
    (command "DIMTIX"           "On")       ;Place text inside extensions
    (command "DIMTM"            "0")        ;Minus tolerance
    (command "DIMTMOVE"         "0")        ;Text movement
    (command "DIMTOFL"          "On")       ;Force line inside extension lines
    (command "DIMTOH"           "Off")      ;Text outside horizontal
    (command "DIMTOL"           "Off")      ;Tolerance dimensioning
    (command "DIMTOLJ"          "1")        ;Tolerance vertical justification
    (command "DIMTP"            "0")        ;Plus tolerance
    (command "DIMTSZ"           "0")        ;Tick size
    (command "DIMTVP"           "0")        ;Text vertical position
    (command "DIMTXSTY"         ".TNT_A_TXT_3_NOTE")  ;Text style
    (command "DIMTXT"           "2.00")     ;Text height
    (command "DIMTXTDIRECTION"  "Off")      ;Dimension text direction
    (command "DIMTZIN"          "0")        ;Tolerance zero suppression
    (command "DIMUPT"           "Off")      ;User positioned text
    (command "DIMZIN"           "0")        ;Zero suppression
    (command "DIMSTYLE"         "S" ".TNT_A_DIM_1")
  ))
  (Setvar "cmdecho" 1)
  (princ))

(defun TNT_A_DIM_2 ()     
  (setvar "cmdecho" 0)
  (TNT:DIM:SET-NONASSOC)
  (if (not (tblsearch "dimstyle" ".TNT_A_DIM_2"))
  (progn    
    (command "DIMSTYLE"         "R"         "Standard")
    (TNT:TS:ENSURE ".TNT_A_TXT_3_NOTE" "uromans.shx" 0.0 0.8 0.0 nil)
    (TNT:DIM:SET-NONASSOC)                  ;Dimension object, not attached to geometry
    (command "DIMADEC"          "0")        ;Angular decimal places
    (command "DIMALT"           "Off")      ;Alternate units selected
    (command "DIMALTD"          "2")        ;Alternate unit decimal places
    (command "DIMALTF"          "25.4")     ;Alternate unit scale factor   
    (command "DIMALTRND"        "0")        ;Alternate units rounding value
    (command "DIMALTTD"         "2")        ;Alternate tolerance decimal places
    (command "DIMALTTZ"         "0")        ;Alternate tolerance zero suppression
    (command "DIMALTU"          "2")        ;Alternate units
    (command "DIMALTZ"          "0")        ;Alternate unit zero suppression
    (command "DIMAPOST"         "")         ;Prefix and suffix for alternate text
    (command "DIMARCSYM"        "0")        ;Arc length symbol
    (command "DIMASZ"           "1.10")     ;Arrow size
    (command "DIMATFIT"         "3")        ;Arrow and text fit
    (command "DIMAUNIT"         "0")        ;Angular unit format
    (command "DIMAZIN"          "0")        ;Angular zero supression
    (command "DIMBLK"           "ArchTick") ;Arrow block name
    (command "DIMBLK1"          "")         ;First arrow block name
    (command "DIMBLK2"          "")         ;Second arrow block name
    (command "DIMCEN"           "0.09")     ;Center mark size
    (command "DIMCLRD"          "256")      ;Dimension line and leader color
    (command "DIMCLRE"          "256")      ;Extension line color
    (command "DIMCLRT"          "14")       ;Dimension text color
    (command "DIMDEC"           "0")        ;Decimal places
    (command "DIMDLE"           "1.1")      ;Dimension line extension
    (command "DIMDLI"           "5")        ;Dimension line spacing
    (command "DIMDSEP"          ".")        ;Decimal separator
    (command "DIMEXE"           "1.1")      ;Extension above dimension line
    (command "DIMEXO"           "0")        ;Extension line origin offset
    (command "DIMFRAC"          "0")        ;Fraction format
    (command "DIMFXL"           "0")        ;Fixed Extension Line
    (command "DIMFXLON"         "Off")      ;Enable Fixed Extension Line
    (command "DIMGAP"           "0.7")      ;Gap from dimension line to text
    (command "DIMJOGANG"        "90")       ;Radius dimension jog angle
    (command "DIMJUST"          "0")        ;Justification of text on dimension line
    (command "DIMLDRBLK"        "")         ;Leader block name
    (command "DIMLFAC"          "1")        ;Linear unit scale factor
    (command "DIMLIM"           "Off")      ;Generate dimension limits
    (command "DIMLTEX1"         "ByBlock")  ;Linetype extension line 1
    (command "DIMLTEX2"         "ByBlock")  ;Linetype extension line 2
    (command "DIMLTYPE"         "ByBlock")  ;Dimension linetype
    (command "DIMLUNIT"         "2")        ;Linear unit format
    (command "DIMLWD"           "-2")       ;Dimension line and leader lineweight
    (command "DIMLWE"           "-2")       ;Extension line lineweight   
    (command "DIMPOST"          "")         ;Prefix and suffix for dimension text
    (command "DIMRND"           "0")        ;Rounding value
    (command "DIMSAH"           "Off")      ;Separate arrow blocks
    (command "DIMSCALE"         "1")        ;Overall scale factor
    (command "DIMSD1"           "Off")      ;Suppress the first dimension line
    (command "DIMSD2"           "Off")      ;Suppress the second dimension line
    (command "DIMSE1"           "Off")      ;Suppress the first extension line
    (command "DIMSE2"           "Off")      ;Suppress the second extension line
    (command "DIMSOXD"          "On")       ;Suppress outside dimension lines
    (command "DIMTAD"           "1")        ;Place text above the dimension line
    (command "DIMTDEC"          "0")        ;Tolerance decimal places
    (command "DIMTFAC"          "1")        ;Tolerance text height scaling factor
    (command "DIMTFILL"         "0")        ;Text background enabled
    (command "DIMTFILLCLR"      "256")      ;Text background color
    (command "DIMTIH"           "Off")      ;Text inside extensions is horizontal
    (command "DIMTIX"           "Off")      ;Place text inside extensions
    (command "DIMTM"            "0")        ;Minus tolerance
    (command "DIMTMOVE"         "0")        ;Text movement
    (command "DIMTOFL"          "On")       ;Force line inside extension lines
    (command "DIMTOH"           "Off")      ;Text outside horizontal
    (command "DIMTOL"           "Off")      ;Tolerance dimensioning
    (command "DIMTOLJ"          "1")        ;Tolerance vertical justification
    (command "DIMTP"            "0")        ;Plus tolerance
    (command "DIMTSZ"           "0")        ;Tick size
    (command "DIMTVP"           "0")        ;Text vertical position
    (command "DIMTXSTY"         ".TNT_A_TXT_3_NOTE")  ;Text style
    (command "DIMTXT"           "2.00")     ;Text height
    (command "DIMTXTDIRECTION"  "Off")      ;Dimension text direction
    (command "DIMTZIN"          "0")        ;Tolerance zero suppression
    (command "DIMUPT"           "Off")      ;User positioned text
    (command "DIMZIN"           "0")        ;Zero suppression
    (command "DIMSTYLE"         "S" ".TNT_A_DIM_2")
    ))
  (Setvar "cmdecho" 1)
  (princ))

(defun TNT_A_DIM_3 ()     
  (setvar "cmdecho" 0)
  (TNT:DIM:SET-NONASSOC)
  (if (not (tblsearch "dimstyle" ".TNT_A_DIM_3"))
  (progn    
    (command "DIMSTYLE"         "R"         "Standard")
    (TNT:TS:ENSURE ".TNT_A_TXT_3_NOTE" "uromans.shx" 0.0 0.8 0.0 nil)
    (TNT:DIM:SET-NONASSOC)                  ;Dimension object, not attached to geometry
    (command "DIMADEC"          "0")        ;Angular decimal places
    (command "DIMALT"           "Off")      ;Alternate units selected
    (command "DIMALTD"          "2")        ;Alternate unit decimal places
    (command "DIMALTF"          "25.4")     ;Alternate unit scale factor   
    (command "DIMALTRND"        "0")        ;Alternate units rounding value
    (command "DIMALTTD"         "2")        ;Alternate tolerance decimal places
    (command "DIMALTTZ"         "0")        ;Alternate tolerance zero suppression
    (command "DIMALTU"          "2")        ;Alternate units
    (command "DIMALTZ"          "0")        ;Alternate unit zero suppression
    (command "DIMAPOST"         "")         ;Prefix and suffix for alternate text
    (command "DIMARCSYM"        "0")        ;Arc length symbol
    (command "DIMASZ"           "1.10")     ;Arrow size
    (command "DIMATFIT"         "3")        ;Arrow and text fit
    (command "DIMAUNIT"         "0")        ;Angular unit format
    (command "DIMAZIN"          "0")        ;Angular zero supression
    (command "DIMBLK"           "Dot")      ;Arrow block name
    (command "DIMBLK1"          "Dot")      ;First arrow block name
    (command "DIMBLK2"          "Dot")      ;Second arrow block name
    (command "DIMCEN"           "0.09")     ;Center mark size
    (command "DIMCLRD"          "256")      ;Dimension line and leader color
    (command "DIMCLRE"          "256")      ;Extension line color
    (command "DIMCLRT"          "14")       ;Dimension text color
    (command "DIMDEC"           "0")        ;Decimal places
    (command "DIMDLE"           "1.1")      ;Dimension line extension
    (command "DIMDLI"           "5")        ;Dimension line spacing
    (command "DIMDSEP"          ".")        ;Decimal separator
    (command "DIMEXE"           "1.1")      ;Extension above dimension line
    (command "DIMEXO"           "0")        ;Extension line origin offset
    (command "DIMFRAC"          "0")        ;Fraction format
    (command "DIMFXL"           "0")        ;Fixed Extension Line
    (command "DIMFXLON"         "Off")      ;Enable Fixed Extension Line
    (command "DIMGAP"           "0.7")      ;Gap from dimension line to text
    (command "DIMJOGANG"        "90")       ;Radius dimension jog angle
    (command "DIMJUST"          "0")        ;Justification of text on dimension line
    (command "DIMLDRBLK"        "")         ;Leader block name
    (command "DIMLFAC"          "1")        ;Linear unit scale factor
    (command "DIMLIM"           "Off")      ;Generate dimension limits
    (command "DIMLTEX1"         "ByBlock")  ;Linetype extension line 1
    (command "DIMLTEX2"         "ByBlock")  ;Linetype extension line 2
    (command "DIMLTYPE"         "ByBlock")  ;Dimension linetype
    (command "DIMLUNIT"         "2")        ;Linear unit format
    (command "DIMLWD"           "-2")       ;Dimension line and leader lineweight
    (command "DIMLWE"           "-2")       ;Extension line lineweight   
    (command "DIMPOST"          "")         ;Prefix and suffix for dimension text
    (command "DIMRND"           "0")        ;Rounding value
    (command "DIMSAH"           "Off")      ;Separate arrow blocks
    (command "DIMSCALE"         "1")        ;Overall scale factor
    (command "DIMSD1"           "Off")      ;Suppress the first dimension line
    (command "DIMSD2"           "Off")      ;Suppress the second dimension line
    (command "DIMSE1"           "ON")      ;Suppress the first extension line
    (command "DIMSE2"           "ON")      ;Suppress the second extension line
    (command "DIMSOXD"          "On")       ;Suppress outside dimension lines
    (command "DIMTAD"           "1")        ;Place text above the dimension line
    (command "DIMTDEC"          "0")        ;Tolerance decimal places
    (command "DIMTFAC"          "1")        ;Tolerance text height scaling factor
    (command "DIMTFILL"         "0")        ;Text background enabled
    (command "DIMTFILLCLR"      "256")      ;Text background color
    (command "DIMTIH"           "Off")      ;Text inside extensions is horizontal
    (command "DIMTIX"           "Off")      ;Place text inside extensions
    (command "DIMTM"            "0")        ;Minus tolerance
    (command "DIMTMOVE"         "0")        ;Text movement
    (command "DIMTOFL"          "On")       ;Force line inside extension lines
    (command "DIMTOH"           "Off")      ;Text outside horizontal
    (command "DIMTOL"           "Off")      ;Tolerance dimensioning
    (command "DIMTOLJ"          "1")        ;Tolerance vertical justification
    (command "DIMTP"            "0")        ;Plus tolerance
    (command "DIMTSZ"           "0")        ;Tick size
    (command "DIMTVP"           "0")        ;Text vertical position
    (command "DIMTXSTY"         ".TNT_A_TXT_3_NOTE")  ;Text style
    (command "DIMTXT"           "2.00")     ;Text height
    (command "DIMTXTDIRECTION"  "Off")      ;Dimension text direction
    (command "DIMTZIN"          "0")        ;Tolerance zero suppression
    (command "DIMUPT"           "Off")      ;User positioned text
    (command "DIMZIN"           "0")        ;Zero suppression
    (command "DIMSTYLE"         "S" ".TNT_A_DIM_3")
    ))
  (Setvar "cmdecho" 1)
  (princ))
;;; ====================================================================================================
;;; END SOURCE: K_TNT_Function_Create_Dimension.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: M_TNT_Function_Create_Block.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; ------------------------------------ M_TNT_FUNCTION_CREATE_BLOCK -----------------------------------
;;; ====================================================================================================
;;; * FILE    : M_TNT_FUNCTION_CREATE_BLOCK
;;; * PURPOSE : 
;;;   - 
;;;   - 
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [2] HÀM TẠO BLOCK
;;; ====================================================================================================
(defun TNT_BLOCK_CREATE (/)
  (TNT:SYS:RUN-SAFE (function TNT:BLOCK:MAKE))    
  (princ)
)
;;; ====================================================================================================
;;; [3] ISO-BASIC
;;; ====================================================================================================
  (defun TNT:BLOCK:MAKE (/ SCALE PT1 )    
    (setq SCALE 1
          PT1 '(0 0)
    )
    (command "-INSERT" "2025_ISO_TNT" PT1 SCALE SCALE 0
              "EXPLODE" "LAST"
    )
    (princ)
  )
;;; ====================================================================================================
;;; END SOURCE: M_TNT_Function_Create_Block.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: N_TNT_Function_Create_Shortcut.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; ---------------------------------- N_TNT_FUNCTION_CREATE_SHORTCUT ----------------------------------
;;; ====================================================================================================
;;; * FILE    : J_TNT_FUNCTION_CREATE_SHORTCUT.LSP
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
;;;     + GROUP 1 - SYSTEM/SETUP  - (TNT:SHORTCUT:CMD:SYS:*)
;;;     + GROUP 2 - MANAGEMENT    - (TNT:SHORTCUT:CMD:MGT:*)
;;;     + GROUP 3 - DRAW GEOMETRY - (TNT:SHORTCUT:CMD:DRAW*)
;;;     + GROUP 4 - MODIFY        - (TNT:SHORTCUT:CMD:MOD:*)
;;;     + GROUP 5 - ANNOTATION    - (TNT:SHORTCUT:CMD:ANNO:*)
;;;     + GROUP 6 - CUSTOM TOOLS  - (TNT:SHORTCUT:CMD:TOOLS:*)
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [1] HÀM TẠO SHORTCUT
;;; ====================================================================================================
;;; ====================================================================================================`n;;; [2] ACTION FUNCTION
;;; ====================================================================================================
;; * GROUP 1 - SYSTEM/SETUP - (TNT:SHORTCUT:CMD:SYS:*)
;; * GROUP 2 - MANAGEMENT - (TNT:SHORTCUT:CMD:MGT:*)
(defun TNT:SHORTCUT:CMD:MGT:SE1 (/)
  (if (member "TNT:MANAGE:RESET-OSMODE" (atoms-family 1))
    (TNT:MANAGE:RESET-OSMODE nil nil)
    (command ".OSMODE" 15871)
  )
  (princ))
(defun TNT:SHORTCUT:CMD:MGT:G1  (/)     (if (= (getvar "PICKSTYLE") 0)  (setvar "PICKSTYLE" 1)  (setvar "PICKSTYLE" 0)) (princ))
(defun TNT:SHORTCUT:CMD:MGT:C1  (/ LT)  (setq LT (getvar "TILEMODE"))   (setvar "TILEMODE" (if (= LT 0) 1 0))           (princ))
(defun TNT:SHORTCUT:CMD:MGT:C2  (/)     (command ".LAYOUT" "S" "")      (princ))
(defun TNT:SHORTCUT:CMD:MGT:C3  (/)     (command ".MODEL")              (princ))
(defun TNT:SHORTCUT:CMD:MGT:V1  (/)     (command ".-VPORTS" "2" "V")   (princ))
(defun TNT:SHORTCUT:CMD:MGT:V2  (/)     (command ".-VPORTS" "2" "H")   (princ))
(defun TNT:SHORTCUT:CMD:MGT:V3  (/)     (command ".-VPORTS" "SI")      (princ))
;; * GROUP 3 - DRAW GEOMETRY - (TNT:SHORTCUT:CMD:DRAW*)
(defun TNT:SHORTCUT:CMD:DRAW:BB   (/) (command ".BOUNDARY")   (princ))
(defun TNT:SHORTCUT:CMD:DRAW:CC   (/) (command ".CIRCLE")     (princ))
(defun TNT:SHORTCUT:CMD:DRAW:R    (/) (command ".RECTANG")    (princ))
(defun TNT:SHORTCUT:CMD:DRAW:XZ   (/) (command ".XLINE")      (princ))
(defun TNT:SHORTCUT:CMD:DRAW:`    (/) (command ".LINE")       (princ))
(defun TNT:SHORTCUT:CMD:DRAW:``   (/) (command ".PLINE")      (princ))
(defun TNT:SHORTCUT:CMD:DRAW:```  (/) (command ".SPLINE")     (princ))
(defun TNT:SHORTCUT:CMD:DRAW:1`   (/) (command ".XLINE" "V")  (princ))
(defun TNT:SHORTCUT:CMD:DRAW:2`   (/) (command ".XLINE" "H")  (princ))
;; * GROUP 4 - MODIFY - (TNT:SHORTCUT:CMD:MOD:*)
(defun TNT:SHORTCUT:CMD:MOD:C     (/ A B)   (setq A (ssget) B (getpoint "\n SELECT POINT:"))  (command "COPY" A "" "M" B)       (princ))
(defun TNT:SHORTCUT:CMD:MOD:CV    (/ A B)   (setq A (ssget) B (getpoint "\n SELECT BASE POINT:")) (command ".COPYBASE" B A "")  (princ))
(defun TNT:SHORTCUT:CMD:MOD:ATT   (/)       (command ".ATTIPEDIT")  (princ))
(defun TNT:SHORTCUT:CMD:MOD:BR    (/ A B)   (setq A (ssget) B (getpoint "\n SELECT POINT:")) (command ".BREAK" A B B) (princ))
(defun TNT:SHORTCUT:CMD:MOD:TT    (/)       (command ".TRIM")       (princ))
(defun TNT:SHORTCUT:CMD:MOD:SF    (/)       (command ".OFFSET")     (princ))
(defun TNT:SHORTCUT:CMD:MOD:FF    (/)       (command ".MIRROR")     (princ))
(defun TNT:SHORTCUT:CMD:MOD:RT    (/)       (command ".ROTATE")     (princ))
(defun TNT:SHORTCUT:CMD:MOD:E1    (/)       (command ".EXTEND")     (princ))
(defun TNT:SHORTCUT:CMD:MOD:V     (/)       (command ".MOVE")       (princ))
(defun TNT:SHORTCUT:CMD:MOD:Q     (/)       (command ".MATCHPROP")  (princ))
(defun TNT:SHORTCUT:CMD:MOD:REF   (/)       (command ".-REFEDIT" "O" "A" "Y")  (princ))
(defun TNT:SHORTCUT:CMD:MOD:REFC  (/)       (command ".REFCLOSE" "S" "")       (princ))
(defun TNT:SHORTCUT:CMD:MOD:BE    (/)       (command ".-BEDIT")                (princ))
(defun TNT:SHORTCUT:CMD:MOD:BC    (/)       (command ".BCLOSE" "")             (princ))
(defun TNT:SHORTCUT:CMD:MOD:F     (/)       (command ".FILLET")                (princ))
(defun TNT:SHORTCUT:CMD:MOD:F1    (/)       (command ".AECFILLET")             (princ))
(defun TNT:SHORTCUT:CMD:MOD:DRF   (/ A)     (setq A (ssget)) (command ".DRAWORDER" A "" "F") (princ))
(defun TNT:SHORTCUT:CMD:MOD:DRB   (/ A)     (setq A (ssget)) (command ".DRAWORDER" A "" "B") (princ))
(defun TNT:SHORTCUT:CMD:MOD:XRE   (/)       (command ".-XREF" "R" "*") (princ))
(defun TNT:SHORTCUT:CMD:MOD:SD    (/)       (sssetfirst nil (ssget (list (cons 0 "DIMENSION"))))    (princ))
(defun TNT:SHORTCUT:CMD:MOD:SA    (/)       (sssetfirst nil (ssget (list (cons 0 "LEADER"))))       (princ))
(defun TNT:SHORTCUT:CMD:MOD:SB    (/)       (sssetfirst nil (ssget (list (cons 0 "INSERT"))))       (princ))
(defun TNT:SHORTCUT:CMD:MOD:ST    (/)       (sssetfirst nil (ssget (list (cons 0 "*TEXT,LEADER")))) (princ))
(defun TNT:SHORTCUT:CMD:MOD:SHT   (/)       (sssetfirst nil (ssget (list (cons 0 "HATCH"))))        (princ))
;; * GROUP 5 - ANNOTATION - (TNT:SHORTCUT:CMD:ANNO:*)
(defun TNT:SHORTCUT:CMD:ANNO:1 (/)
  (TNT:SYS:RUN-SAFE (function (lambda () (setvar "CMDECHO" 0) (setvar "DIMLAYER" ".") (command "._LAYISO") (setvar "CMDECHO" 1))))
  (princ))
(defun TNT:SHORTCUT:CMD:ANNO:2 (/)        (command "._LAYOFF") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:3 (/)
  (TNT:SYS:RUN-SAFE (function (lambda () (setvar "CMDECHO" 0) (setvar "DIMLAYER" "....22_TNT_N_DIMENSION") (command "-LAYER" "ON" "*" "") (setvar "CMDECHO" 1))))
  (princ))
(defun TNT:SHORTCUT:CMD:ANNO:QQ (/)       (command ".LAYMCUR") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:D  (/)       (command ".DIMLINEAR") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DA (/)       (command ".DIMALIGNED") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DN (/)       (command ".DIMANGULAR") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DG (/)       (command ".DIMRADIUS") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DC (/)       (command ".DIMCONTINUE") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DS (/)       (command "DIMSETINSERT") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DE (/)       (command "DIMSETDELETE") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:DX (/ A)     (setq A (ssget)) (command "DIMSETEXTEND" A "E") (princ))
(defun TNT:SHORTCUT:CMD:ANNO:D1 (/ A B)   (setq A (getint "\n NHẬP TỶ LỆ: "))
  (if (/= A 0) (progn (setq B (/ 1.0 A))  (command ".DIMLFAC" B)) (princ "\nLỗi: TỶ LỆ không thể bằng 0.")) (princ))
(defun TNT:SHORTCUT:CMD:ANNO:D2 (/)       (command ".DIMSCALE") (setvar "DIMASZ" 2.0) (princ))
(defun TNT:SHORTCUT:CMD:ANNO:WQ (/)       (command ".WIPEOUT") (princ))

;; * GROUP 6 - CUSTOM TOOLS - (TNT:SHORTCUT:CMD:TOOLS:*)
(defun TNT:SHORTCUT:CMD:TOOLS:PU (/)
  (TNT:SYS:RUN-SAFE
    (function (lambda ()
      (setvar "CMDECHO" 0)
      (command ".-PURGE" "ALL" "" "N")
      (command ".-PURGE" "R" "" "N")
      (command ".AUDIT" "Y")
      (cond
        ((member "TNT:LAYER:ENSURE-STANDARD" (atoms-family 1))
         (TNT:LAYER:ENSURE-STANDARD))
        ((member "TNT:LAY:CREATE" (atoms-family 1))
         (TNT:LAY:CREATE)))
      (setvar "CMDECHO" 1))))
  (princ))
(defun TNT:SHORTCUT:CMD:TOOLS:DXF (/ MA MA1)
  (setq MA (car (entsel)) MA1 (entget MA)) (princ MA1) (princ))
;;; ====================================================================================================
;;; [3] CONFIG MẶC ĐỊNH
;;; ====================================================================================================
(setq *TNT.CFG.SC*
  '(
    ;; GROUP 2 - MANAGEMENT
    ("SE1"  . TNT:SHORTCUT:CMD:MGT:SE1)
    ("G1"   . TNT:SHORTCUT:CMD:MGT:G1)
    ("C1"   . TNT:SHORTCUT:CMD:MGT:C1)
    ("C2"   . TNT:SHORTCUT:CMD:MGT:C2)
    ("C3"   . TNT:SHORTCUT:CMD:MGT:C3)
    ("V1"   . TNT:SHORTCUT:CMD:MGT:V1)
    ("V2"   . TNT:SHORTCUT:CMD:MGT:V2)
    ("V3"   . TNT:SHORTCUT:CMD:MGT:V3)
    ;; GROUP 3 - DRAW GEOMETRY
    ("BB"   . TNT:SHORTCUT:CMD:DRAW:BB)
    ("CC"   . TNT:SHORTCUT:CMD:DRAW:CC)
    ("R"    . TNT:SHORTCUT:CMD:DRAW:R)
    ("XZ"   . TNT:SHORTCUT:CMD:DRAW:XZ)
    ("`"    . TNT:SHORTCUT:CMD:DRAW:`)
    ("``"   . TNT:SHORTCUT:CMD:DRAW:``)
    ("```"  . TNT:SHORTCUT:CMD:DRAW:```)
    ("1`"   . TNT:SHORTCUT:CMD:DRAW:1`)
    ("2`"   . TNT:SHORTCUT:CMD:DRAW:2`)
    ;; GROUP 4 - MODIFY
    ("C"    . TNT:SHORTCUT:CMD:MOD:C)
    ("CV"   . TNT:SHORTCUT:CMD:MOD:CV)
    ("ATT"  . TNT:SHORTCUT:CMD:MOD:ATT)
    ("BR"   . TNT:SHORTCUT:CMD:MOD:BR)
    ("TT"   . TNT:SHORTCUT:CMD:MOD:TT)
    ("SF"   . TNT:SHORTCUT:CMD:MOD:SF)
    ("FF"   . TNT:SHORTCUT:CMD:MOD:FF)
    ("RT"   . TNT:SHORTCUT:CMD:MOD:RT)
    ("E1"   . TNT:SHORTCUT:CMD:MOD:E1)
    ("V"    . TNT:SHORTCUT:CMD:MOD:V)
    ("Q"    . TNT:SHORTCUT:CMD:MOD:Q)
    ("REF"  . TNT:SHORTCUT:CMD:MOD:REF)
    ("REFC" . TNT:SHORTCUT:CMD:MOD:REFC)
    ("BE"   . TNT:SHORTCUT:CMD:MOD:BE)
    ("BC"   . TNT:SHORTCUT:CMD:MOD:BC)
    ("F"    . TNT:SHORTCUT:CMD:MOD:F)
    ("F1"   . TNT:SHORTCUT:CMD:MOD:F1)
    ("DRF"  . TNT:SHORTCUT:CMD:MOD:DRF)
    ("DRB"  . TNT:SHORTCUT:CMD:MOD:DRB)
    ("XRE"  . TNT:SHORTCUT:CMD:MOD:XRE)
    ;; SELECT
    ("SD"   . TNT:SHORTCUT:CMD:MOD:SD)
    ("SA"   . TNT:SHORTCUT:CMD:MOD:SA)
    ("SB"   . TNT:SHORTCUT:CMD:MOD:SB)
    ("ST"   . TNT:SHORTCUT:CMD:MOD:ST)
    ("SHT"  . TNT:SHORTCUT:CMD:MOD:SHT)
    ;; GROUP 5 - ANNOTATION
    ("1"    . TNT:SHORTCUT:CMD:ANNO:1)
    ("2"    . TNT:SHORTCUT:CMD:ANNO:2)
    ("3"    . TNT:SHORTCUT:CMD:ANNO:3)
    ("QQ"   . TNT:SHORTCUT:CMD:ANNO:QQ)
    ("D"    . TNT:SHORTCUT:CMD:ANNO:D)
    ("DA"   . TNT:SHORTCUT:CMD:ANNO:DA)
    ("DN"   . TNT:SHORTCUT:CMD:ANNO:DN)
    ("DG"   . TNT:SHORTCUT:CMD:ANNO:DG)
    ("DC"   . TNT:SHORTCUT:CMD:ANNO:DC)
    ("DS"   . TNT:SHORTCUT:CMD:ANNO:DS)
    ("DE"   . TNT:SHORTCUT:CMD:ANNO:DE)
    ("DX"   . TNT:SHORTCUT:CMD:ANNO:DX)
    ("D1"   . TNT:SHORTCUT:CMD:ANNO:D1)
    ("D2"   . TNT:SHORTCUT:CMD:ANNO:D2)
    ("WQ"   . TNT:SHORTCUT:CMD:ANNO:WQ)
    ;; GROUP 6 - CUSTOM TOOLS
    ("PU"   . TNT:SHORTCUT:CMD:TOOLS:PU)
    ("DXF"  . TNT:SHORTCUT:CMD:TOOLS:DXF)
  )
)
;;; ====================================================================================================
;;; [4] ĐỘNG BỘ LỆNH TẮT 
;;; ====================================================================================================
;; TẠO 1 COMMAND C:ALIAS GỌI VÀO HÀM HÀNH ĐỘNG FN
(defun TNT:SHORTCUT:REGISTER (PALIAS PFN / LSYM)
  (if (and (= (type PALIAS) 'STR) PFN)
    (progn
      (setq LSYM (read (strcat "C:" PALIAS)))
      (eval (list 'defun LSYM '(/) (list 'TNT:SYS:RUN-SAFE (list 'quote PFN)) '(princ)))))
  LSYM)
;; ĐĂNG KÝ TỪ DANH SÁCH CẤU HÌNH
(defun TNT:SHORTCUT:REGISTER-LIST (PCFG / LIT)  
  (foreach LIT PCFG
    (TNT:SHORTCUT:REGISTER (car LIT) (cdr LIT)))
  (princ))
;;; ====================================================================================================
;;; [5] PUBLIC API / COMMANDS
;;; ====================================================================================================
(defun TNT:SHORTCUT:MAKE:RUNTIME (/)  
  (TNT:SHORTCUT:REGISTER-LIST *TNT.CFG.SC*)
  (princ))
(defun TNT_SHORTCUT_CREATE (/) 
  (TNT:SYS:RUN-SAFE (function TNT:SHORTCUT:MAKE:RUNTIME))
  (princ))
;;; ====================================================================================================
;;; [6] AUTORUN (nạp là có lệnh C:ALIAS ngay) – KHÔNG gọi lệnh người dùng, chỉ đăng ký alias
;;; ====================================================================================================
(TNT:SHORTCUT:MAKE:RUNTIME)
(princ)
;;; ====================================================================================================
;;; END SOURCE: N_TNT_Function_Create_Shortcut.lsp
;;; ====================================================================================================

(princ "\n[TNT] Loaded TNT_PACKAGE_01_CREATE_ALL.lsp")
(princ)
