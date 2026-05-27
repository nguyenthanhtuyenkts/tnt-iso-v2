;;; ====================================================================================================
;;; ------------------------------------ I_010_FUNCTION_CREATE_LAYER -----------------------------------
;;; ====================================================================================================
;;; * FILE    : I_010_FUNCTION_CREATE_LAYER
;;; * PURPOSE : 
;;;   - GỌI LỆNH LUÔN TẠO MỚI NẾU CHƯA CÓ, VÀ GHI ĐÈ THUỘC TÍNH NẾU LAYER ĐÃ TỒN TẠI.
;;;   - NẾU NGƯỜI DÙNG ĐÃ TỰ ĐỔI THUỘC TÍNH → LẦN GỌI LỆNH TIẾP THEO RESET VỀ CHUẨN ISO TRONG DANH SÁCH.
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; ====================================================================================================
;;; ----------------------------------- [0] APPLICATION / SIGNATURE ------------------------------------
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; ----------------------------------------- [1] HÀM TẠO LAYER ----------------------------------------
;;; ====================================================================================================
(defun 010_LAYER_CREATE (/)
  (010:SYS:RUN-SAFE (function 010_LAYER))    
  (princ)
)
;;; ====================================================================================================
;;; ---------------------------------------- [2] HÀM VIẾT LAYER ----------------------------------------
;;; ====================================================================================================
(defun 010_MAKE_LAYER (NAME PLOT COLOR LTYPE LW TR DESC / EXIST DOC LAYS LAY LLTYPES PLOTBOOL LWVAL)
  (010:SYS:RUN-SAFE
    (function
      (lambda (/)
        (setvar "CMDECHO" 0)
        ;; 1) Đảm bảo linetype tồn tại (không bật command, không prompt)
        (010:LAY:ENSURE-LTYPE LTYPE)
        ;; 2) Tạo nếu chưa có (chỉ 1 lệnh, còn lại dùng VLA để tránh Invalid option keyword)
        (setq EXIST (tblsearch "LAYER" NAME))
        (if (not EXIST) (vl-cmdf "._-LAYER" "_NEW" NAME ""))
        ;; 3) Lấy đối tượng layer & GHI ĐÈ THUỘC TÍNH
        (setq DOC     (vla-get-ActiveDocument (vlax-get-acad-object)))
        (setq LAYS    (vla-get-Layers DOC))
        (setq LLTYPES (vla-get-Linetypes DOC))
        (setq LAY     (vla-Item LAYS NAME))
        ;; Bật/Thaw/Unlock để đảm bảo set được thuộc tính
        (vl-catch-all-apply '(lambda () (vl-cmdf "._-LAYER" "_ON"     NAME "")))
        (vl-catch-all-apply '(lambda () (vl-cmdf "._-LAYER" "_THAW"   NAME "")))
        (vl-catch-all-apply '(lambda () (vl-cmdf "._-LAYER" "_UNLOCK" NAME "")))
        ;; Plot (Plottable): P,Y,YES,TRUE,PLOT -> TRUE ; còn lại FALSE
        (setq PLOTBOOL (if (member (strcase (vl-princ-to-string PLOT)) '("P" "Y" "YES" "TRUE" "PLOT"))
                         :vlax-true :vlax-false))
        (010:PACKAGE:FS:SAFE-PUT 'vla-put-Plottable (list LAY PLOTBOOL))
        ;; Color
        (if COLOR
          (010:PACKAGE:FS:SAFE-PUT 'vla-put-Color (list LAY (atoi (vl-princ-to-string COLOR)))))
        ;; Linetype (đã ensure có trong bảng)
        (if (and LTYPE (/= (strcase (vl-princ-to-string LTYPE)) ""))
          (010:PACKAGE:FS:SAFE-PUT 'vla-put-Linetype (list LAY (vl-princ-to-string LTYPE))))
        ;; Lineweight: "0"/rỗng -> ByLayer (hoặc đổi sang acLnWt000 nếu bạn muốn 0.00mm)
        (setq LWVAL
          (cond ((or (null LW) (= (vl-princ-to-string LW) "") (= (strcase (vl-princ-to-string LW)) "0"))
                 acLnWtByLayer)
                (T (atoi (vl-princ-to-string LW)))))
        (010:PACKAGE:FS:SAFE-PUT 'vla-put-Lineweight (list LAY LWVAL))
        ;; Transparency (tuỳ chọn): chỉ set khi có giá trị hợp lệ
        ;; Nếu bạn muốn tuyệt đối tránh command, có thể bỏ 3 dòng dưới.
        (if (and TR (/= (vl-princ-to-string TR) ""))
          (vl-catch-all-apply
            '(lambda () (vl-cmdf "._-LAYER" "_TRANSPARENCY" (vl-princ-to-string TR) NAME ""))))
        ;; Mô tả
        (010:LAY:DESCRIPTION NAME DESC)
        (setvar "CMDECHO" 1)
      )
    )
  )
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_LAYER ()
  (010:SYS:RUN-SAFE
    (function
      (lambda (/)        
        (mapcar
          '(lambda (x)
            (apply '010_MAKE_LAYER x)
          )
          '(
            ;ARCHITEC      
            ("...0_TNT_LINE_NAME"				    "P"		"7"		"CONTINUOUS"	  	"0"	"0"		"NÉT TÊN BẢN VẼ")
            ("...1_TNT_LINE_CONCRETE"		  	"P"		"7"		"CONTINUOUS"		  "0"	"50"	"NÉT BTCT")
            ("...2_TNT_LINE_WALL"				    "P"		"41"	"CONTINUOUS"		  "0"	"50"	"NÉT TƯỜNG")
            ("...3_TNT_LINE_SECTION"		  	"P"		"30"	"CONTINUOUS"		  "0"	"50"	"NÉT CẮT")
            ("...4_TNT_LINE_VIRTURAL"			  "P"		"9"		"CONTINUOUS"		  "0"	"50"	"NÉT THẤY")
            ("...5_TNT_LINE_THIN"				    "P"		"251"	"CONTINUOUS"		  "0"	"50"	"NÉT THẤY MỜ")
            ("...6_TNT_LINE_HIDDEN"		    	"P"		"251"	"HIDDEN"			    "0"	"50"	"NÉT KHUẤT")
            ("...7_TNT_LINE_BASE"			    	"P"		"177"	"CENTER"			    "0"	"0"		"NÉT TRỤC")
            ("...8_TNT_LINE_FUNITURE"		  	"P"		"27"	"CONTINUOUS"	  	"0"	"50"	"NÉT NỘI THẤT")
            ("...9_TNT_LINE_TEXT"				    "P"		"9"		"CONTINUOUS"	  	"0"	"0"		"NÉT CHỮ GHI CHÚ")
            ("...10_TNT_LINE_HATCH"			    "P"		"250"	"CONTINUOUS"	  	"0"	"50"	"NÉT VẬT LIỆU")
            ("...11_TNT_LINE_DIMENSION"		  "P"		"251"	"CONTINUOUS"	  	"0"	"0"		"NÉT KÍCH THƯỚC")
            ("...12_TNT_LINE_ANNOTATE"	  	"P"		"14"	"CONTINUOUS"	  	"0"	"0"		"NÉT CHÚ THÍCH")
            ("...13_TNT_LINE_TREE"			    "P"		"76"	"CONTINUOUS"	  	"0"	"50"	"NÉT CÂY")
            ("...14_TNT_LINE_GLASSE"		  	"P"		"147"	"CONTINUOUS"		  "0"	"50"	"NÉT KÍNH")
            ("...15_TNT_LINE_DOOR"			    "P"		"33"	"CONTINUOUS"	  	"0"	"50"	"NÉT CỬA")
            ("...16_TNT_LINE_DETAIL" 		  	"P"		"156"	"HIDDEN"			    "0"	"0"		"NÉT CHI TIẾT KỸ THUẬT")
            ("...17_TNT_SECTION_LINE"			  "P"		"6"		"ACAD_ISO07W100"  "0"	"0"		"NÉT TRỤC CẮT")
            ("...18_TNT_LINE_TITLE"			    "P"		"9"		"CONTINUOUS"		  "0"	"0"		"NÉT TIÊU ĐỀ")
            ("...19_TNT_LINE_LAYOUT"			  "N"		"250"	"CONTINUOUS"		  "0"	"0"		"NÉT LAYOUT")
            ("...20_TNT_LINE_COMPLETE"		  "P"		"8"		"CONTINUOUS"	  	"0"	"50"	"NÉT HOÀN THIỆN")
            ("...21_TNT_LINE_COTE" 			    "P"		"14"	"CONTINUOUS"		  "0"	"0"		"NÉT COTE CAO ĐỘ")
            ;PLUMBING
            ("...22_TNT_WATER-NOTE"			    "P"		"11"	"CONTINUOUS"		  "0"	"0"		"NÉT GHI CHÚ TB NƯỚC")
            ("...23_TNT_WATER-TEXT"			    "P"		"3"		"CONTINUOUS"		  "0"	"0"		"NÉT CHỨ PHẦN NƯỚC")
            ("...24_TNT_WATER-SUPPLY"			  "P"		"130"	"CONTINUOUS"		  "0"	"0"		"NÉT CẤP LẠNH")
            ("...25_TNT_WATER-SUPPLY-HOT" 	"P"		"240"	"HIDDEN"			    "0"	"0"		"NÉT CẤP NÓNG")
            ("...26_TNT_WATER-DRAIN-TOILET" "P"		"4"		"HIDDEN"			    "0"	"0"		"NÉT THOÁT XÍ")
            ("...27_TNT_WATER-DRAIN-RAIN"		"P"		"5"		"HIDDEN"		    	"0"	"0"		"NÉT THOÁT MƯA")
            ("...28_TNT_WATER-DRAIN-WASH"		"P"		"6"		"HIDDEN"		    	"0"	"0"		"NÉT THOÁT RỬA")
            ("...29_TNT_WATER-DRAIN-VENT"		"P"		"50"	"HIDDEN"		    	"0"	"0"		"NÉT THÔNG HƠI")
            ;ELECTRICAL
            ("...30_TNT_ELECTRIC_NOTE"		  "P"		"1"		"CONTINUOUS"		"0"	"0"	  	"NÉT GHI CHÚ TB ĐIỆN")
            ("...31_TNT_ELECTRIC_TEXT"		  "P"		"2"		"CONTINUOUS"		"0"	"0"		  "NÉT CHỮ PHẦN ĐIỆN")
          )
        )        
      )
    )
  )  
  (princ)
)
;;; ====================================================================================================
;;; ----------------------------------- [4] LAY – HÀM CON DESCRIPTION ----------------------------------
;;; ====================================================================================================
(defun 010:LAY:DESCRIPTION (NAME DESC / DOC LAY)
  (if (and NAME DESC (/= DESC ""))
    (progn
      (setq DOC (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq LAY (vla-item (vla-get-Layers DOC) NAME))
      (010:PACKAGE:FS:SAFE-PUT 'vla-put-Description (list LAY DESC))))
  (princ)
)
;;; ====================================================================================================
;;; -------------------------------------- [3] LAY – HÀM CON LTYPE -------------------------------------
;;; ====================================================================================================
(defun 010:LAY:ENSURE-LTYPE (LTYPE / fname fpath)
  ;; Bỏ qua nếu không cần nạp
  (if (or (null LTYPE)
          (not (eq (type LTYPE) 'STR))
          (= (strlen LTYPE) 0)
          (member (strcase LTYPE) '("BYLAYER" "BYBLOCK" "CONTINUOUS")))
    (princ)
    (if (not (tblsearch "LTYPE" LTYPE))
      (progn
        (setq fname (if (= (getvar "MEASUREMENT") 1) "acadiso.lin" "acad.lin"))
        (setq fpath (findfile fname))
        (if fpath
          ;; NẠP BẰNG ActiveX -> không hiện prompt Create/Load/Set
          (vl-catch-all-apply
            '(lambda ()
               (vla-Load (vla-get-Linetypes
                           (vla-get-ActiveDocument (vlax-get-acad-object)))
                         LTYPE
                         fpath)))
          ;; Không tìm thấy file .LIN -> bỏ qua để tránh lỗi
          (princ)
        )
      )
    )
  )
  (princ)
)