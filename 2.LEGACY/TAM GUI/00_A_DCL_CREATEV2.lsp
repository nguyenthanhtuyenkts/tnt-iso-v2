-------------------------------------------------------------------------------------------------------------------
;== HÀM CHINH ==
-------------------------------------------------------------------------------------------------------------------
(defun c:TNT_DCL_CREATE ( / )
  (vl-load-com)
  (setvar "MODEMACRO" "010 A")
  (010_SHOW_CREATE_DIALOG)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
;== HÀM GOI HOP THOAI ==
-------------------------------------------------------------------------------------------------------------------
(defun 010_SHOW_CREATE_DIALOG ( / DCLCREATE CREATEDCLID ACTION )
  (setq DCLCREATE (010_MAKE_FILE_DCL))
  (setq CREATEDCLID (load_dialog DCLCREATE))  
  (if (new_dialog "Create" CREATEDCLID)
    (progn
      (010_SET_TILE_OF_SEP "sep0")
      (action_tile "Tile_Ok"      "(done_dialog 0)")
      (action_tile "Tile_Help"    "(done_dialog 1)")
      (action_tile "Tile_About"   "(done_dialog 2)")
      (action_tile "System"       "(done_dialog 3)")
      (action_tile "Layer"        "(done_dialog 4)")
      (action_tile "Dimension"    "(done_dialog 5)")      
      (setq ACTION (start_dialog))
      (unload_dialog CREATEDCLID)
      (cond
      ((= ACTION 1)  (010_SHOW_HELP_DIALOG))
	    ((= ACTION 2)  (010_SHOW_ABOUT_DIALOG))
      ((= ACTION 3)  (010_CREATE_SYSTEM)      (010_SHOW_CREATE_DIALOG)	(prompt "\n[DONE] Đã thiết lập hệ thống."))
      ((= ACTION 4)  (010_CREATE_LAYER)       (010_SHOW_CREATE_DIALOG)	(prompt "\n[DONE] Đã tạo TNT_LAYER."))
      ((= ACTION 5)  (010_CREATE_DIM)         (010_SHOW_CREATE_DIALOG)	(prompt "\n[DONE] Đã tạo TNT_DIM1 và TNT_DIM2."))      
      )
    )
  )
  (vl-file-delete DCLCREATE)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_SHOW_ABOUT_DIALOG ( / DCLABOUT ABOUTDCLID ACTION_1 )
  (setq DCLABOUT (010_MAKE_FILE_DCL))
  (setq ABOUTDCLID (load_dialog DCLABOUT))  
  (if (new_dialog "ABOUT" ABOUTDCLID)
    (progn
      (010_SET_TILE_OF_SEP "sep1")
      (010_SET_TILE_OF_SEP "sep2")
      (action_tile	"Tile_OK"	"(done_dialog 0)")
      (setq ACTION_1 (start_dialog))
      (cond
      ((= ACTION_1 0)	(010_SHOW_CREATE_DIALOG))      
      )
      (start_dialog)
      (unload_dialog ABOUTDCLID)
    )
  )
  (vl-file-delete DCLABOUT)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_SHOW_HELP_DIALOG ( / DCLHELP HELPDCLID ACTION_2 )
  (setq DCLHELP (010_MAKE_FILE_DCL))
  (setq HELPDCLID (load_dialog DCLHELP))  
  (if (new_dialog "Help" HELPDCLID)
    (progn
      (010_SET_TILE_OF_SEP "sep0")      
      (action_tile	"Tile_OK"	"(done_dialog 1)")
      (setq ACTION_2 (start_dialog))
      (cond
      ((= ACTION_2 1)	(010_SHOW_CREATE_DIALOG))      
      )
      (start_dialog)
      (unload_dialog HELPDCLID)
    )
  )
  (vl-file-delete DCLHELP)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
;== HÀM VIET HOP THOAI ==
-------------------------------------------------------------------------------------------------------------------
(defun 010_MAKE_FILE_DCL ( / F DclFile )
  (setq DclFile (vl-filename-mktemp "TNT.dcl"))
  (setq F (open DclFile "w"))
  (foreach line
    '(
      "/// Create Dialog Box ----------------------------------------------"
      "Create : dialog {"
      " label = \"TNT ARCHITECTURE V1.0\";"
      
      " spacer;"
      
      " :boxed_column{"
      " label = \"TNT_ISO\";"
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
      "              label = \"Create System\";"
      "              width = 30;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Layer\";"
      "              label = \"Create Layer\";"
      "              width = 30;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Dimension\";"
      "              label = \"Create Dimension\";"
      "              width = 30;"
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
      "              key = \"Tile_Ok\";"
      "              label = \"&OK\";"
      "              is_default = true;"
      "              width = 20;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Tile_Help\";"
      "              label = \"&Help\";"      
      "              width = 20;"
      "              fixed_width = true;"
      "      }"
      "     : button {"
      "               key = \"Tile_About\";"
      "               label = \"&About...\";"
      "               width = 20;"
      "               fixed_width = true;"
      "     }"
      "   spacer;"
      "   }"
      "}"
      
      "/// About Dialog Box ----------------------------------------------"
      "ABOUT: dialog{"
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
      "Help : dialog {"
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
    (write-line line F)
  )
  (close F)
  DclFile
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_SET_TILE_OF_SEP ( Tile / )
	(set_tile Tile "────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────")
	(mode_tile Tile 1)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_SET_TILE_DECORATION ( NumTotal / Num Tile)
	(setq Num 0)
	(repeat NumTotal
		(setq Tile (strcat "sep" (itoa Num)))
		(set_tile Tile "──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────")
		(setq Num (+ Num 1))
	)
)
-------------------------------------------------------------------------------------------------------------------
;== HÀM KHỞI TẠO ==
-------------------------------------------------------------------------------------------------------------------
(defun 010_CREATE_SYSTEM ()
  (setvar "MODEMACRO" "010 Architect")
  (TNT_SYSTEM)    
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_CREATE_LAYER ()
  (setvar "MODEMACRO" "010 Architect")
  (TNT_LAYER)    
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_CREATE_DIM ()
  (setvar "MODEMACRO" "010 Architect")
  (TNT_DIM1)
  (TNT_DIM2)  
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
;== HÀM CON SYSTEM ==
-------------------------------------------------------------------------------------------------------------------
(defun TNT_SYSTEM ( / )
    (ensure-navvcube-off)
    (set-if-needed "MODEMACRO" "010 Architect")    
    (set-if-needed "UCSICON" 0)
    (set-if-needed "MENUBAR" 1)                        	    ;HIEN THI MENUBAR
    (set-if-needed "cursorsize" 100)                        ;CHINH SIZE CON TRO CHUOT
    (set-if-needed "cursortype" 0)                          ;HIEN THI CHUOT HINH CHU THAP
    (set-if-needed "ISAVEBAK" 1)                            ;TAO FILE BACKUP KHI SAVE
    (set-if-needed "SAVETIME" 30)                           ;TU DONG SAVE FILE 30 PHUT
    (set-if-needed "INSUNITSDEFSOURCE" 4)                   ;SET MILIMETERS KHI CHEN KHOI
    (set-if-needed "INSUNITSDEFTARGET" 4)                   ;SET MILIMETERS KHI XUAT BAN VE
    ;(set-if-needed "OSOPTIONS" 6)                          ;CHO PHEP BAT DIEM VAO HATCH
    ;(set-if-needed "APERTURE" 15)                          ;DO RONG O VUONG BAT DIEM
    ;(set-if-needed "PICKBOX" 15)                           ;DO RONG O VUONG CHON DIEM
    ;(set-if-needed "GRIPSIZE" 15)                          ;DO RONG O VUONG CHUC NANG
    (set-if-needed "MIRRTEXT" 0)                            ;CHU KHONG BI LAT NGUOC KHI MIRROR
    (set-if-needed "MIRRHATCH" 0)                           ;HATCH KHONG BI LAT NGUOC KHI MIRROR
    (set-if-needed "OSMODE" 16383)                          ;BAT TAT CA BAT DIEM
    (set-if-needed "APERTURE" 10)                           ;KHOẢNG CÁCH HIỆN THỊ BẮT ĐIỂM
    ;(set-if-needed "DIMMASOC" 2)                           ;TẠO DIM KHÔNG BỊ RỜI RẠC
    (set-if-needed "PEDITACCEPT" 1)                         ;TẠO NHANH PLINE TỪ LINE KHÔNG HIỂN THỊ HỘP THOẠI COMMAND 
    (set-if-needed "CANNOSCALE" "1:1")                      ;TY LE 1:1
    (set-if-needed "LTSCALE" 1)                             ;LTS = 1
    (set-if-needed "SELECTIONANNODISPLAY" 0)                ;TẮT HIỆN THỊ Annotative
    (set-if-needed "ANNOALLVISIBLE" 0)
    (set-if-needed "ANNOAUTOSCALE" 0)
    (set-if-needed "SELECTIONEFFECT" 1)                     ;CHỌN ĐỐI TƯỢNG KHÔNG BỊ DẠNG LƯỚI  
    (set-if-needed "TRANSPARENCYDISPLAY" 0)                 ;LAYER KHÔNG BỊ MỜ
    (set-if-needed "SELECTIONPREVIEW" 0)                    ;TẮT HIGHT KHI DI CHUỘT VÀO ĐỐI TƯỢNG
    (set-if-needed "HIGHLIGHT" 1)                           ;BẬT HIGHT KHI CHỌN ĐỐI TƯỢNG
    (set-if-needed "COLORTHEME" 0)                          ;GIAO DIỆN TỐI
    (set-if-needed "FILEDIA" 1)                             ;HIỆN THỊ HỘP THOẠI TRÊN FILE MENU SAVE OPEN
    (set-if-needed "STATUSBAR" 1)                           ;HIỆN THỊ THANH CÔNG CỤ BÊN DƯỚI GÓC PHẢI 
    (set-if-needed "LAYOUTTAB" 1)                           ;HIỆN THỊ THANH TAB LAYOUT   
    (set-if-needed "STARTMODE" 0)                           ;TẮT HIỆN THỊ THANH START BAN ĐẦU
    (set-if-needed "SNAPMODE" 0)                            ;TẮT BẮT ĐIỂM GRID
    (set-if-needed "GRIDMODE" 0)                            ;TẮT BẮT ĐIỂM GRID  
    (set-if-needed "DIMLAYER" "...11_TNT_LINE_DIMENSION")   ;LAYER "DIMENTION"
    (set-if-needed "HPLAYER" "...10_TNT_LINE_HATCH")        ;LAYER "HATCH"
    (set-if-needed "TEXTLAYER" "...9_TNT_LINE_TEXT")        ;LAYER "TEXT"    
    (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun set-if-needed (var val / oldval)
  (setq oldval (getvar var))
  (if (not (equal oldval val))
    (progn
      (setvar var val)
      (princ (strcat "\n[INFO] Đã đổi biến " var " từ " (vl-princ-to-string oldval) " → " (vl-princ-to-string val)))
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun ensure-navvcube-off ( / space old)
  (setq space (getvar "TILEMODE"))
  (if (= space 1)
    (progn
      (setq old (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.NAVVCUBE" "_Off")
      (setvar "CMDECHO" old)
    )
    (princ "\n[INFO] Bỏ qua NAVVCUBE vì đang ở Layout.")
  )
)
-------------------------------------------------------------------------------------------------------------------
;== HÀM CON LAYER ==
-------------------------------------------------------------------------------------------------------------------
(defun TNT_MAKE_LAYER (NAME PLOT COLOR LTYPE LW TR DESC / EXIST LAYOBJ)
  (setq EXIST (tblsearch "LAYER" NAME))
  (if (not EXIST)
    (progn
      (command "-LAYER"
               "N"				  NAME
               "P"  	PLOT	NAME
               "C"  	COLOR	NAME
               "L"  	LTYPE	NAME
               "LW" 	LW		NAME
               "TR" 	TR		NAME
               ""
      )
      (setq LAYOBJ (vla-item (vla-get-Layers (vla-get-ActiveDocument (vlax-get-Acad-Object))) NAME))
      (vla-put-Description LAYOBJ DESC)
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT_LAYER ()
  (setvar "CMDECHO" 0)
  (mapcar
    '(lambda (x)
       (apply 'TNT_MAKE_LAYER x)
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
  (setvar "CMDECHO" 1)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
;== HÀM CON DIMENSION ==
-------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------
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
    (command "DIMSOXD"          "Off")       ;Suppress outside dimension lines
    (command "DIMTAD"           "1")        ;Place text above the dimension line
    (command "DIMTDEC"          "0")        ;Tolerance decimal places
    (command "DIMTFAC"          "1")        ;Tolerance text height scaling factor
    (command "DIMTFILL"         "0")        ;Text background enabled
    (command "DIMTFILLCLR"      "256")      ;Text background color
    (command "DIMTIH"           "Off")      ;Text inside extensions is horizontal
    (command "DIMTIX"           "On")      ;Place text inside extensions
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
-------------------------------------------------------------------------------------------------------------------
