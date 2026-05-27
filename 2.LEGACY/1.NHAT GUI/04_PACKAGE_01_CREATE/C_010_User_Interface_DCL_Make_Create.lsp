;;; ====================================================================================================
;;; ------------------------------- C_010_USER_INTERFACE_DCL_MAKE_CREATE -------------------------------
;;; ====================================================================================================
;;; * FILE    : C_010_USER_INTERFACE_DCL_MAKE_CREATE
;;; * PURPOSE : Tạo/cập nhật hộp thoại
;;;   - CREATE  : dialog
;;;   - ABOUT   : dialog
;;;   - HELP    : dialog
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
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; [1] HÀM VIẾT HỘP THOẠI CREATE
;;; ====================================================================================================
(defun 010:DCL:MAKE:CREATE ( / LF LDCLFILE LLINE )
  (setq LDCLFILE (vl-filename-mktemp "010_DCL_CREATE.dcl"))
  (setq LF (open LDCLFILE "W"))
  (foreach LLINE
    '(
      "/// Create Dialog Box ----------------------------------------------"
      "CREATE : dialog {"
      " label = \"TNT CREATE\";"
      
      " spacer;"
      
      " :boxed_column{"
      " label = \"TNT_ISO\";"
      "   : row {"      
      "     : text {" 
      "              label = \"Layer\";"
      "              width = 20;" 
      "     }"
      "     : text {"
      "              label = \"Text Style\";" 
      "              width = 20;"
      "     }"
      "     : text {"
      "              label = \"Dimension\";" 
      "              width = 20;"
      "     }"
      "   }"      
      
      "   : row {"
      "     : button {"
      "              key = \"Layer\";"
      "              label = \"Create Layer\";"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Textstyle\";"
      "              label = \"Create T.Style\";"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Dimension\";"
      "              label = \"Create Dimension\";"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"
      "   }"        
      
      "   : row {"      
      "     : text {" 
      "              label = \"System\";"
      "              width = 20;" 
      "     }"
      "     : text {"
      "              label = \"Block ISO\";" 
      "              width = 20;"
      "     }"
      "     : text {"
      "              label = \"Shortcut\";" 
      "              width = 20;"
      "     }"
      "   }"
      
      "   : row {"
      "     : button {"
      "              key = \"System\";"
      "              label = \"Create System\";"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Block\";"
      "              label = \"Create B.ISO\";"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Shortcut\";"
      "              label = \"Create Shortcut\";"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"      
      "   }"
      
      "   : spacer {"
      "   height = 0.1;"
      "   }"      
      " }"
      
      " : text { key = \"sep0\"; }"      
      
      "   : row {"
      "   spacer;"      
      "     : button {"
      "              key = \"Tile_Apcept\";"
      "              label = \"&Apcept\";"
      "              is_default = true;"
      "              width = 25;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Tile_Help\";"
      "              label = \"&Help\";"      
      "              width = 25;"
      "              fixed_width = true;"
      "      }"
      "     : button {"
      "               key = \"Tile_Information\";"
      "               label = \"&Information...\";"
      "               width = 25;"
      "               fixed_width = true;"
      "     }"
      "   spacer;"
      "   }"
      "}"
      
      
      "/// About Dialog Box ----------------------------------------------"
      "ABOUT : dialog{"
      " label = \"INFOMATIONS\";"
      
      "	:boxed_column {"
      "   :text {"
    	"         label = \"TNT_ISO_ABOUT\";"
      "   }"
    
      "   :text {"
      "   label = \"Copyright © TNT \";"
      "   }"
      
      "   : text { key = \"sep1\"; }"
      
      "   :row{"
      "     :column{"
      "       :text{"
      "            label = \"     Author\";"
      "				}"
      "				:text{"
      "				     label = \"     From\";"
      "				}"
      "				:text{"
      "				     label = \"     Email\";"
      "				}"
      "				:text{"
      "				     label = \"     Telephone\";"
      "       }"
      "     }"
      "			:column{"
      "				:text{"
      "				     label = \"     : Tam Pham\";"
      "				}"
      "				:text{" 
      "				     label = \"     : HaNoi City - Vietnam\";" 
      "				}" 
      "				:text{" 
      "				     label = \"     : Nhutam104@gmail.com\";" 
      "				}" 
      "				:text{" 
      "				     label = \"     : +84 983.890.491\";" 
      "				}"
      "			}"
      "		}"
      
      "   : text { key = \"sep2\"; }" 
      
      "   :paragraph{"
      "   width = 80;"
      "     :text_part{" 
      "               value = \"Any comments please send email to Nhutam104@gmail.com\";" 
      "     }"
      "     :text_part{" 
      "				        value = \"Thank you for using and supporting.\";" 
      "     }"
      "   : spacer {"
      "   height = 0.1;"
      "   }"
      "   }"
      " }"
      
      "	:button{"
      "			label = \"&OK\";"
      "			key = \"Tile_OK\";"
      "			is_default = true;"      
      "			width = 15;"
      "	}"
      "}"
      
      
      "/// Help Dialog Box ----------------------------------------------"
      "HELP : dialog {"
      " label = \"HELP\";"
      
      " spacer;"
      
      " :boxed_column{"
      " label = \"TNT_ISO_HELP\";"
      "   : row {"      
      "     : text {" 
      "              label = \"System\";"
      "              width = 20;" 
      "     }"
      "     : text {"
      "              label = \"Layer\";" 
      "              width = 20;"
      "     }"
      "     : text {"
      "              label = \"Dimension\";" 
      "              width = 20;"
      "     }"
      "   }"      
      
      "   : row {"
      "     : button {"
      "              key = \"System\";"
      "              label = \"Help System\";"
      "              width = 20;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Layer\";"
      "              label = \"Help Layer\";"
      "              width = 20;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Dimension\";"
      "              label = \"Help Dimension\";"
      "              width = 20;"
      "              fixed_width = true;"
      "     }"
      "   }"
      "   : spacer {"
      "   height = 0.1;"
      "   }"
      " }"

      " : text { key = \"sep0\"; }"      

      " : button {"
      "           key = \"Tile_Ok\";"     
      "           label = \"&OK\";"
      "           is_default = true;"
      "           width = 20;"
      " }"
      "}"
    )
    (write-line LLINE LF)
  ) 
  (close LF)
  LDCLFILE
)