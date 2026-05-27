;;; ====================================================================================================
;;; ---------------------------------- K_010_FUNCTION_CREATE_DIMENSION ---------------------------------
;;; ====================================================================================================
;;; * FILE    : K_010_FUNCTION_CREATE_DIMENSION
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
;;; ------------------------------------ [0] APPLICATION / SIGNATURE -----------------------------------
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; --------------------------------------- [3] HÀM TẠO DIMENSION --------------------------------------
;;; ====================================================================================================
(defun 010_DIMENSION_CREATE (/)
  (010:SYS:RUN-SAFE
    (function
      (lambda (/)
        (TNT_DIM1)
        (TNT_DIM2)
      )
     )
   )
  (princ)
)
;;; ====================================================================================================
;;; --------------------------------------- [4] HÀM CON DIMENSION --------------------------------------
;;; ====================================================================================================
(defun TNT_DIM1 ()     
  (setvar "cmdecho" 0)
  (if (not (tblsearch "dimstyle" "TNT_DIM1"))
  (progn    
    (command "STYLE"            "Standard"  "" "" "" "" "" "" "" "" "")  
    (command "DIMSTYLE"         "R"         "Standard")
    (if (not (tblsearch "STYLE" "TNT_DIM"))
    (command "STYLE"            "TNT_DIM"   "uromans.shx" "" "0.8" "" "" "" "" "" ""))
    (command "DIMASO"           "ON")       ;Create dimension objects    
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
    (command "DIMTXSTY"         "TNT_DIM")  ;Text style
    (command "DIMTXT"           "2.00")     ;Text height
    (command "DIMTXTDIRECTION"  "Off")      ;Dimension text direction
    (command "DIMTZIN"          "0")        ;Tolerance zero suppression
    (command "DIMUPT"           "Off")      ;User positioned text
    (command "DIMZIN"           "0")        ;Zero suppression
    (command "DIMSTYLE"         "S" "TNT_DIM1")
    )    
  )
  (Setvar "cmdecho" 1)  
  (princ)
)
(defun TNT_DIM2 ()  
  (setvar "cmdecho" 0)
  (if (not (tblsearch "dimstyle" "TNT_DIM2"))
  (progn    
    (command "STYLE"            "Standard"  "" "" "" "" "" "" "" "" "")  
    (command "DIMSTYLE"         "R"         "Standard")
    (if (not (tblsearch "STYLE" "TNT_DIM"))
    (command "STYLE"            "TNT_DIM"   "uromans.shx" "" "0.8" "" "" "" "" "" ""))
    (command "DIMASO"           "ON")      ;Create dimension objects    
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
    (command "DIMTXSTY"         "TNT_DIM")  ;Text style
    (command "DIMTXT"           "2.00")     ;Text height
    (command "DIMTXTDIRECTION"  "Off")      ;Dimension text direction
    (command "DIMTZIN"          "0")        ;Tolerance zero suppression
    (command "DIMUPT"           "Off")      ;User positioned text
    (command "DIMZIN"           "0")        ;Zero suppression
    (command "DIMSTYLE"         "S" "TNT_DIM2")
    )    
  )
  (Setvar "cmdecho" 1)  
  (princ)
)