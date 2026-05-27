-------------------------------------------------------------------------------------------------------------------
(defun c:TNT_DCL_CREATE ( / )
  (vl-load-com)
  (setvar "MODEMACRO" "010 A")
  (010_SHOW_CREATE_DIALOG)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_SHOW_CREATE_DIALOG ( / DCLCREATE CREATEDCLID )
  (setq DCLCREATE (010_MAKE_FILE_DCL))
  (setq CREATEDCLID (load_dialog DCLCREATE))  
  (if (new_dialog "Create" CREATEDCLID)
    (progn
      (010_SET_TILE_OF_SEP "sep0")
      (action_tile "Tile_Ok"      	"(done_dialog 0)")
      ;(action_tile "Tile_Help"		"(done_dialog 1)")
      (action_tile "Tile_About"		"(done_dialog 2)")
      (action_tile "System"       	"(done_dialog 3)")
      (action_tile "Layer"       	"(done_dialog 4)")
      (action_tile "Dimension"    	"(done_dialog 5)")      
      (setq ret (start_dialog))
      (unload_dialog CREATEDCLID)
      (cond
      ;((= ret 1)  (010_SHOW_HELP_DIALOG)  (010_SHOW_HELP_DIALOG))
	  ((= ret 2)  (010_SHOW_ABOUT_DIALOG))
      ((= ret 3)  (010_CREATE_SYSTEM)     (010_SHOW_CREATE_DIALOG)	(prompt "\n[INFO] Đã thiết lập hệ thống."))
      ((= ret 4)  (010_CREATE_LAYER)      (010_SHOW_CREATE_DIALOG)	(prompt "\n[INFO] Đã tạo TNT_LAYER."))
      ((= ret 5)  (010_CREATE_DIM)        (010_SHOW_CREATE_DIALOG)	(prompt "\n[INFO] Đã tạo TNT_DIM1 và TNT_DIM2."))      
      )
    )
  )
  (vl-file-delete DCLCREATE)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_SHOW_ABOUT_DIALOG ( / DCLABOUT ABOUTDCLID A1 )
  (setq DCLABOUT (010_MAKE_FILE_DCL))
  (setq ABOUTDCLID (load_dialog DCLABOUT))  
  (if (new_dialog "ABOUT" ABOUTDCLID)
    (progn
      (010_SET_TILE_OF_SEP "sep1")
      (010_SET_TILE_OF_SEP "sep2")
      (action_tile	"Tile_OK"	"(done_dialog 0)")
      (setq A1 (start_dialog))
      (cond
      ((= A1 0)	(010_SHOW_CREATE_DIALOG))      
      )
      (start_dialog)
      (unload_dialog ABOUTDCLID)
    )
  )
  (vl-file-delete DCLABOUT)
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun 010_MAKE_FILE_DCL ( / F DclFile )
  (setq DclFile (vl-filename-mktemp "TNT.dcl"))
  (setq F (open DclFile "w"))
  (foreach line
    '(
      "/// Create Dialog Box ----------------------------------------------"
      "Create : dialog {"
      " label = \"TNT ARCHITECTURE v1.00\";"
      
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
      "              width = 20;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Layer\";"
      "              label = \"Create Layer\";"
      "              width = 20;"
      "              fixed_width = true;"
      "     }"
      "     : button {"
      "              key = \"Dimension\";"
      "              label = \"Create Dimension\";"
      "              width = 20;"
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
      "               label = \"About...\";"
      "               width = 20;"
      "              fixed_width = true;"
      "     }"
      "   spacer;"
      "   }"
      "}"
      
      "/// About Dialog Box ----------------------------------------------"
      "ABOUT: dialog{"
      " label = \"Infomations\";"
      
      "	:boxed_column {"
      "   :text {"
    	"         label = \"TNT_ISO\";"
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
      ;"			is_cancel = true;" 
      "			width = 15;" 
      "	}"
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
;== HÀM CON ==
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
  (setq space (getvar "TILEMODE")) ; 1 = Model Space
  (if (= space 1)
    (progn
      (setq old (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.NAVVCUBE" "_Off")
      (setvar "CMDECHO" old)
      ;(princ "\n[INFO] Đã gọi lệnh NAVVCUBE OFF.")
    )
    (princ "\n[INFO] Bỏ qua NAVVCUBE vì đang ở Layout.")
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT_LAYER ()      
      (setvar "CMDECHO" 0)
            (if (not (tblsearch "LAYER" "...0_TNT_LINE_NAME" ))
            (command "-LAYER" "N" "...0_TNT_LINE_NAME"
                              "C" "7" "...0_TNT_LINE_NAME" 
                              "L" "CONTINUOUS" "...0_TNT_LINE_NAME" 
                              "LW" "0" "...0_TNT_LINE_NAME"
                              "TR" "0" "...0_TNT_LINE_NAME"
                              "P" "P" "...0_TNT_LINE_NAME"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...1_TNT_LINE_CONCRETE" ))
            (command "-LAYER" "N" "...1_TNT_LINE_CONCRETE"
                              "C" "7" "...1_TNT_LINE_CONCRETE" 
                              "L" "CONTINUOUS" "...1_TNT_LINE_CONCRETE" 
                              "LW" "0" "...1_TNT_LINE_CONCRETE"
                              "TR" "50" "...1_TNT_LINE_CONCRETE"
                              "P" "P" "...1_TNT_LINE_CONCRETE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...2_TNT_LINE_WALL" ))
            (command "-LAYER" "N" "...2_TNT_LINE_WALL" 
                              "C" "41" "...2_TNT_LINE_WALL" 
                              "L" "CONTINUOUS" "...2_TNT_LINE_WALL" 
                              "LW" "0" "...2_TNT_LINE_WALL"
                              "TR" "50" "...2_TNT_LINE_WALL"
                              "P" "P" "...2_TNT_LINE_WALL"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...3_TNT_LINE_SECTION" ))
            (command "-LAYER" "N" "...3_TNT_LINE_SECTION" 
                              "C" "30" "...3_TNT_LINE_SECTION" 
                              "L" "CONTINUOUS" "...3_TNT_LINE_SECTION" 
                              "LW" "0" "...3_TNT_LINE_SECTION"
                              "TR" "50" "...3_TNT_LINE_SECTION"
                              "P" "P" "...3_TNT_LINE_SECTION"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...4_TNT_LINE_VIRTURAL" ))
            (command "-LAYER" "N" "...4_TNT_LINE_VIRTURAL" 
                              "C" "9" "...4_TNT_LINE_VIRTURAL" 
                              "L" "CONTINUOUS" "...4_TNT_LINE_VIRTURAL" 
                              "LW" "0" "...4_TNT_LINE_VIRTURAL"
                              "TR" "50" "...4_TNT_LINE_VIRTURAL"
                              "P" "P" "...4_TNT_LINE_VIRTURAL"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...5_TNT_LINE_THIN" ))
            (command "-LAYER" "n" "...5_TNT_LINE_THIN" 
                              "c" "251" "...5_TNT_LINE_THIN" 
                              "L" "CONTINUOUS" "...5_TNT_LINE_THIN" 
                              "LW" "0" "...5_TNT_LINE_THIN"
                              "TR" "50" "...5_TNT_LINE_THIN"
                              "P" "P" "...5_TNT_LINE_THIN"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...6_TNT_LINE_HIDDEN" ))
            (command "-LAYER" "n" "...6_TNT_LINE_HIDDEN" 
                              "c" "251" "...6_TNT_LINE_HIDDEN" 
                              "L" "HIDDEN" "...6_TNT_LINE_HIDDEN" 
                              "LW" "0" "...6_TNT_LINE_HIDDEN"
                              "TR" "50" "...6_TNT_LINE_HIDDEN"
                              "P" "P" "...6_TNT_LINE_HIDDEN"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...7_TNT_LINE_BASE" ))
            (command "-LAYER" "n" "...7_TNT_LINE_BASE" 
                              "c" "177" "...7_TNT_LINE_BASE" 
                              "L" "CENTER" "...7_TNT_LINE_BASE" 
                              "LW" "0" "...7_TNT_LINE_BASE"
                              "TR" "0" "...7_TNT_LINE_BASE"
                              "P" "P" "...7_TNT_LINE_BASE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...8_TNT_LINE_FUNITURE" ))
            (command "-LAYER" "n" "...8_TNT_LINE_FUNITURE" 
                              "c" "27" "...8_TNT_LINE_FUNITURE" 
                              "L" "CONTINUOUS" "...8_TNT_LINE_FUNITURE" 
                              "LW" "0" "...8_TNT_LINE_FUNITURE"
                              "TR" "50" "...8_TNT_LINE_FUNITURE"
                              "P" "P" "...8_TNT_LINE_FUNITURE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...9_TNT_LINE_TEXT" ))
            (command "-LAYER" "n" "...9_TNT_LINE_TEXT" 
                              "c" "9" "...9_TNT_LINE_TEXT" 
                              "L" "CONTINUOUS" "...9_TNT_LINE_TEXT" 
                              "LW" "0" "...9_TNT_LINE_TEXT"
                              "TR" "0" "...9_TNT_LINE_TEXT"
                              "P" "P" "...9_TNT_LINE_TEXT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...10_TNT_LINE_HATCH" ))
            (command "-LAYER" "n" "...10_TNT_LINE_HATCH" 
                              "c" "250" "...10_TNT_LINE_HATCH" 
                              "L" "CONTINUOUS" "...10_TNT_LINE_HATCH" 
                              "LW" "0" "...10_TNT_LINE_HATCH"
                              "TR" "50" "...10_TNT_LINE_HATCH"
                              "P" "P" "...10_TNT_LINE_HATCH"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...11_TNT_LINE_DIMENSION" ))
            (command "-LAYER" "n" "...11_TNT_LINE_DIMENSION" 
                              "c" "251" "...11_TNT_LINE_DIMENSION" 
                              "L" "CONTINUOUS" "...11_TNT_LINE_DIMENSION" 
                              "LW" "0" "...11_TNT_LINE_DIMENSION"
                              "TR" "0" "...11_TNT_LINE_DIMENSION"
                              "P" "P" "...11_TNT_LINE_DIMENSION"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...12_TNT_LINE_ANNOTATE" ))
            (command "-LAYER" "n" "...12_TNT_LINE_ANNOTATE" 
                              "c" "14" "...12_TNT_LINE_ANNOTATE" 
                              "L" "CONTINUOUS" "...12_TNT_LINE_ANNOTATE" 
                              "LW" "0" "...12_TNT_LINE_ANNOTATE"
                              "TR" "0" "...12_TNT_LINE_ANNOTATE"
                              "P" "P" "...12_TNT_LINE_ANNOTATE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...13_TNT_LINE_TREE" ))
            (command "-LAYER" "n" "...13_TNT_LINE_TREE" 
                              "c" "76" "...13_TNT_LINE_TREE" 
                              "L" "CONTINUOUS" "...13_TNT_LINE_TREE" 
                              "LW" "0" "...13_TNT_LINE_TREE"
                              "TR" "50" "...13_TNT_LINE_TREE"
                              "P" "P" "...13_TNT_LINE_TREE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...14_TNT_LINE_GLASSE" ))
            (command "-LAYER" "n" "...14_TNT_LINE_GLASSE" 
                              "c" "147" "...14_TNT_LINE_GLASSE" 
                              "L" "CONTINUOUS" "...14_TNT_LINE_GLASSE" 
                              "LW" "0" "...14_TNT_LINE_GLASSE"
                              "TR" "50" "...14_TNT_LINE_GLASSE"
                              "P" "P" "...14_TNT_LINE_GLASSE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...15_TNT_LINE_DOOR" ))
            (command "-LAYER" "n" "...15_TNT_LINE_DOOR" 
                              "c" "33" "...15_TNT_LINE_DOOR" 
                              "L" "CONTINUOUS" "...15_TNT_LINE_DOOR" 
                              "LW" "0" "...15_TNT_LINE_DOOR"
                              "TR" "50" "...15_TNT_LINE_DOOR"
                              "P" "P" "...15_TNT_LINE_DOOR"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...16_TNT_LINE_DETAIL" ))
            (command "-LAYER" "n" "...16_TNT_LINE_DETAIL" 
                              "c" "156" "...16_TNT_LINE_DETAIL" 
                              "L" "HIDDEN" "...16_TNT_LINE_DETAIL" 
                              "LW" "0" "...16_TNT_LINE_DETAIL"
                              "TR" "0" "...16_TNT_LINE_DETAIL"
                              "P" "P" "...16_TNT_LINE_DETAIL"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...17_TNT_SECTION_LINE" ))
            (command "-LAYER" "n" "...17_TNT_SECTION_LINE" 
                              "c" "6" "...17_TNT_SECTION_LINE" 
                              "L" "ACAD_ISO07W100" "...17_TNT_SECTION_LINE" 
                              "LW" "0" "...17_TNT_SECTION_LINE"
                              "TR" "0" "...17_TNT_SECTION_LINE"
                              "P" "P" "...17_TNT_SECTION_LINE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...18_TNT_LINE_TITLE" ))
            (command "-LAYER" "n" "...18_TNT_LINE_TITLE" 
                              "c" "9" "...18_TNT_LINE_TITLE" 
                              "L" "CONTINUOUS" "...18_TNT_LINE_TITLE" 
                              "LW" "0" "...18_TNT_LINE_TITLE"
                              "TR" "0" "...18_TNT_LINE_TITLE"
                              "P" "P" "...18_TNT_LINE_TITLE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...19_TNT_LINE_LAYOUT" ))
            (command "-LAYER" "n" "...19_TNT_LINE_LAYOUT" 
                              "c" "250" "...19_TNT_LINE_LAYOUT" 
                              "L" "CONTINUOUS" "...19_TNT_LINE_LAYOUT" 
                              "LW" "0" "...19_TNT_LINE_LAYOUT"
                              "TR" "0" "...19_TNT_LINE_LAYOUT"
                              "P" "N" "...19_TNT_LINE_LAYOUT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...20_TNT_LINE_COMPLETE" ))
            (command "-LAYER" "n" "...20_TNT_LINE_COMPLETE"
                              "c" "8" "...20_TNT_LINE_COMPLETE" 
                              "L" "CONTINUOUS" "...20_TNT_LINE_COMPLETE" 
                              "LW" "0" "...20_TNT_LINE_COMPLETE"
                              "TR" "50" "...20_TNT_LINE_COMPLETE"
                              "P" "P" "...20_TNT_LINE_COMPLETE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...21_TNT_LINE_COTE" ))
            (command "-LAYER" "n" "...21_TNT_LINE_COTE"
                              "c" "14" "...21_TNT_LINE_COTE" 
                              "L" "CONTINUOUS" "...21_TNT_LINE_COTE" 
                              "LW" "0" "...21_TNT_LINE_COTE"
                              "TR" "0" "...21_TNT_LINE_COTE"
                              "P" "P" "...21_TNT_LINE_COTE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...22_TNT_WATER-NOTE" ))
            (command "-LAYER" "n" "...22_TNT_WATER-NOTE"
                              "c" "11" "...22_TNT_WATER-NOTE" 
                              "L" "CONTINUOUS" "...22_TNT_WATER-NOTE" 
                              "LW" "0" "...22_TNT_WATER-NOTE"
                              "TR" "0" "...22_TNT_WATER-NOTE"
                              "P" "P" "...22_TNT_WATER-NOTE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...23_TNT_WATER-TEXT" ))
            (command "-LAYER" "n" "...23_TNT_WATER-TEXT"
                              "c" "3" "...23_TNT_WATER-TEXT" 
                              "L" "CONTINUOUS" "...23_TNT_WATER-TEXT" 
                              "LW" "0" "...23_TNT_WATER-TEXT"
                              "TR" "0" "...23_TNT_WATER-TEXT"
                              "P" "P" "...23_TNT_WATER-TEXT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...24_TNT_WATER-SUPPLY" ))
            (command "-LAYER" "n" "...24_TNT_WATER-SUPPLY"
                              "c" "130" "...24_TNT_WATER-SUPPLY" 
                              "L" "CONTINUOUS" "...24_TNT_WATER-SUPPLY" 
                              "LW" "0" "...24_TNT_WATER-SUPPLY"
                              "TR" "0" "...24_TNT_WATER-SUPPLY"
                              "P" "P" "...24_TNT_WATER-SUPPLY"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...25_TNT_WATER-SUPPLY-HOT" ))
            (command "-LAYER" "n" "...25_TNT_WATER-SUPPLY-HOT"
                              "c" "240" "...25_TNT_WATER-SUPPLY-HOT" 
                              "L" "HIDDEN" "...25_TNT_WATER-SUPPLY-HOT" 
                              "LW" "0" "...25_TNT_WATER-SUPPLY-HOT"
                              "TR" "0" "...25_TNT_WATER-SUPPLY-HOT"
                              "P" "P" "...25_TNT_WATER-SUPPLY-HOT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...26_TNT_WATER-DRAIN-TOILET" ))
            (command "-LAYER" "n" "...26_TNT_WATER-DRAIN-TOILET"
                              "c" "4" "...26_TNT_WATER-DRAIN-TOILET" 
                              "L" "HIDDEN" "...26_TNT_WATER-DRAIN-TOILET" 
                              "LW" "0" "...26_TNT_WATER-DRAIN-TOILET"
                              "TR" "0" "...26_TNT_WATER-DRAIN-TOILET"
                              "P" "P" "...26_TNT_WATER-DRAIN-TOILET"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...27_TNT_WATER-DRAIN-RAIN" ))
            (command "-LAYER" "n" "...27_TNT_WATER-DRAIN-RAIN"
                              "c" "5" "...27_TNT_WATER-DRAIN-RAIN" 
                              "L" "HIDDEN" "...27_TNT_WATER-DRAIN-RAIN" 
                              "LW" "0" "...27_TNT_WATER-DRAIN-RAIN"
                              "TR" "0" "...27_TNT_WATER-DRAIN-RAIN"
                              "P" "P" "...27_TNT_WATER-DRAIN-RAIN"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...28_TNT_WATER-DRAIN-WASH" ))
            (command "-LAYER" "n" "...28_TNT_WATER-DRAIN-WASH"
                              "c" "6" "...28_TNT_WATER-DRAIN-WASH" 
                              "L" "HIDDEN" "...28_TNT_WATER-DRAIN-WASH" 
                              "LW" "0" "...28_TNT_WATER-DRAIN-WASH"
                              "TR" "0" "...28_TNT_WATER-DRAIN-WASH"
                              "P" "P" "...28_TNT_WATER-DRAIN-WASH"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...29_TNT_WATER-DRAIN-VENT" ))
            (command "-LAYER" "n" "...29_TNT_WATER-DRAIN-VENT"
                              "c" "50" "...29_TNT_WATER-DRAIN-VENT" 
                              "L" "HIDDEN" "...29_TNT_WATER-DRAIN-VENT" 
                              "LW" "0" "...29_TNT_WATER-DRAIN-VENT"
                              "TR" "0" "...29_TNT_WATER-DRAIN-VENT"
                              "P" "P" "...29_TNT_WATER-DRAIN-VENT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...30_TNT_ELECTRIC_NOTE" ))
            (command "-LAYER" "n" "...30_TNT_ELECTRIC_NOTE"
                              "c" "1" "...30_TNT_ELECTRIC_NOTE" 
                              "L" "CONTINUOUS" "...30_TNT_ELECTRIC_NOTE" 
                              "LW" "0" "...30_TNT_ELECTRIC_NOTE"
                              "TR" "0" "...30_TNT_ELECTRIC_NOTE"
                              "P" "P" "...30_TNT_ELECTRIC_NOTE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...31_TNT_ELECTRIC_TEXT" ))
            (command "-LAYER" "n" "...31_TNT_ELECTRIC_TEXT"
                              "c" "2" "...31_TNT_ELECTRIC_TEXT" 
                              "L" "CONTINUOUS" "...31_TNT_ELECTRIC_TEXT" 
                              "LW" "0" "...31_TNT_ELECTRIC_TEXT"
                              "TR" "0" "...31_TNT_ELECTRIC_TEXT"
                              "P" "P" "...31_TNT_ELECTRIC_TEXT"
                              ""
            ))
      (setvar "CMDECHO" 1)
      (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT_DIM1 ()     
  (setvar "cmdecho" 0)
  (if (not (tblsearch "dimstyle" "TNT_DIM1"))
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