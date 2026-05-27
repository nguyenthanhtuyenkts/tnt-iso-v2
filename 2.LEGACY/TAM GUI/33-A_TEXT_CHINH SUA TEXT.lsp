;;;
(defun C:ED2 ()
  (setq *ERROR* MY-ERR)
  (vl-load-com)
  (setq DCLEDITTEXT (CREATE-EDIT-TEXT-DIALOG))
  (setq DCLABOUT (CREATE-ABOUT-DIALOG))
  (setq CURCMD (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setq CANCEL-PRESSED nil) ; Khởi tạo biến cờ
  (while (and (not CANCEL-PRESSED) (/= (setq ATT (car (nentselp "\nSelect Attribute for edit: "))) nil))
    (if (member (GET-GC 0 ATT) '("ATTRIB" "TEXT" "MTEXT" "DIMENSION"))
        (EDIT-ATTRIBUTE ATT (GET-GC 1 ATT) DCLEDITTEXT)
      (princ "\nSelect ATTRIB/TEXT/MTEXT/DIMENSION")))
  (setvar "CMDECHO" CURCMD)
  (setq *ERROR* nil)
  (princ)
)

;;;;HÀM FIX LỖI
(defun MY-ERR (MSG)
  (cond 
    ((= MSG "Function cancelled") (princ "\t\tUser abort"))
    (t (princ MSG)))
  (setq *ERROR* nil)
  (princ)
)

;;;
(defun GET-GC (GROUP ENTITY)
  (cdr (assoc GROUP (entget ENTITY)))
)

;;;
(defun PUT-GC (VALUE GROUP ENTITY)
  (setq PROPERTIES (entget ENTITY))
  (setq PROPERTIES (subst (cons GROUP VALUE) (assoc GROUP PROPERTIES) PROPERTIES))
  (entmod PROPERTIES)
)

;;;
(defun EDIT-ATTRIBUTE (ATT OLDVAL DCLEDITTEXT)
  (setq TEXT OLDVAL)
  (SHOW-EDIT-DIALOG DCLEDITTEXT OLDVAL)
  (PUT-GC TEXT 1 ATT)
)

;;;HÀM TẠO HỘP THOẠI CHÍNH
(defun MAKE-FILE-DCL (DCLEDITTEXT)
  (setq EDITEXT.DCL (vl-filename-mktemp "EditText.dcl")
        FILE_DCL    (open EDITEXT.DCL "w"))
  (foreach LL DCLEDITTEXT (write-line LL FILE_DCL))
  (close FILE_DCL)
  EDITEXT.DCL)
;;;HÀM TẠO HỘP THOẠI THÔNG TIN
(defun MAKE-ABOUT-DCL (DCLABOUT)
  (setq ABOUT.DCL (vl-filename-mktemp "ABOUT.dcl")
        ABOUT_DCL    (open ABOUT.DCL "w"))
  (foreach LL DCLABOUT (write-line LL ABOUT_DCL))
  (close ABOUT_DCL)
  ABOUT.DCL)
;;;HÀM GỌI HỘP THOẠI CHÍNH
(defun SHOW-EDIT-DIALOG (DCLEDITTEXT OLDVAL)
  (setq DCL_ID_EDIT (load_dialog (MAKE-FILE-DCL DCLEDITTEXT)))
  (if (< DCL_ID_EDIT 1)
      (progn (alert "Not found file EditText.DCL") (exit)))
  (if (not (new_dialog "EDIT" DCL_ID_EDIT))
      (progn (alert "Not found EDIT dialog") (exit)))
  (LIC_SET_TILE_DECORATION 4)
  ;(set_tile "text" OLDVAL)  
  (mode_tile "text" 2)
  (action_tile "Tile_Ok"
    "(progn
       (setq TEXT
         (strcat (get_tile \"text\") \"\\n\" (get_tile \"text2\") \"\\n\" (get_tile \"text3\"))
       )
       (done_dialog)
     )"
  )
  (action_tile "Tile_Cancel" "(setq CANCEL-PRESSED T)(done_dialog)")
  (action_tile "Tile_About" "(SHOW-ABOUT-DIALOG DCLABOUT)")
  (start_dialog)
  (unload_dialog DCL_ID_EDIT)
)
;;;HÀM GỌI HỘP THOẠI THÔNG TIN
(defun SHOW-ABOUT-DIALOG (DCLABOUT)  
  (setq DCL_ID_ABOUT (load_dialog (MAKE-ABOUT-DCL DCLABOUT))) ; Load DCL
  (if (< DCL_ID_ABOUT 1)
      (progn (alert "Not found file About.DCL") (exit)))
  (if (not (new_dialog "ABOUT" DCL_ID_ABOUT))
      (progn (alert "Not found ABOUT dialog") (exit)))
  (CTESTY_SET_TILE_OF_SEP "sep1")
	(CTESTY_SET_TILE_OF_SEP "sep2")
  (start_dialog)
  (unload_dialog DCL_ID_ABOUT)
)


;;;
(defun CREATE-EDIT-TEXT-DIALOG () ;; Khởi tạo hộp thoại chỉnh sửa văn bản
  (setq NameSoftware "Edit Text "
        Version "1.00"
  )
  (list 
    " EDIT: dialog {" ; Bắt đầu hộp thoại
    (strcat " label = \"" NameSoftware Version "\";")    ; Nhãn của hộp thoại
    "  initial_focus = \"text\";" ; Ô nhập văn bản mặc định
    
    " : column {"
    
    "   : text {"
    "     key = \"txt1\";"
    "     value = \"- This is the main dialogue box.\";"
    "   }"
    
    "   : text {"
    "     key = \"txt2\";"
    "     value = \"- To display the next, nested dialogue,\";"
    "    }"
    
    "   : text {"
    "   key = \"txt3\";"
    "   value = \"- Press Next...\";"
    "   }"
    
    "   : spacer {"
    "		  width = 1;" 
    "		}"
    
    "   :text{"
    "	    key = \"sep0\";"
    "	   }"
    
    "  :edit_box {"               ; Hộp nhập văn bản "TEXT"
    "    label = \"TEXT LINE 1:\";"      ; Nhãn của hộp nhập văn bản
    "    allow_accept = true;"    ; Cho phép chấp nhận dữ liệu
    "    edit_width = 40;"        ; Độ rộng của ô nhập văn bản
    "    key = \"text\";"         ; Khóa của ô nhập văn bản
    "  }"

    "  :edit_box {"               ; Hộp nhập văn bản dòng 2
    "    label = \"TEXT LINE 2:\";"
    "    allow_accept = true;"
    "    edit_width = 40;"
    "    key = \"text2\";"
    "  }"

    "  :edit_box {"               ; Hộp nhập văn bản dòng 3
    "    label = \"TEXT LINE 3:\";"
    "    allow_accept = true;"
    "    edit_width = 40;"
    "    key = \"text3\";"
    "  }"

    " }"
    
    "	:text{"
    "	key = \"sep1\";"
    "	}"
    
    " :row{"
    
    "   : spacer {"
    "		  width = 1;" 
    "		}"
    
    "   :button {"
    "		    label = \"Accept\";"
    "       key = \"Tile_Ok\";"
    "		    width = 12;"
    "		    fixed_width = true;"
    "		    mnemonic = A;"
    "       is_default = true;"
    "   }"
    
    "   :button {"
    "		    label = \"Cancel\";"
    "		    key = \"Tile_Cancel\";"
    "		    width = 12;"   
    "		    fixed_width = true;"
    "		    mnemonic = C;"
    "		    is_cancel = true;"
    "   }"

    "   :button {"                                          
    "		label = \"About...\";"
    "		key = \"Tile_About\";"                          
    "		width = 12;"
    "		fixed_width = true;"
    "		mnemonic = B;"
    "   }"
    
    "   : spacer {"
    "		  width = 1;" 
    "		}"
    
    "  }"   
    " }"
   )
)

    
(defun CREATE-ABOUT-DIALOG ()  
  (list    
    "/// About Dialog Box ----------------------------------------------"
    " ABOUT: dialog{"
    " label = \"Infomations\";"
    "	:boxed_column {"
    
    "		:text {"
    		(strcat " label = \"" NameSoftware Version "\";")
    "		}"
    
    "		:text {"
    (strcat "		label = \"Copyright © TNT \";")
    "		}"
    "		:text{"
    "		key = \"sep1\";"
    "		}"
    "		:row{"
    "			:column{"
    "				:text{"
    "				label = \"     Author\";"
    "				}"
    "				:text{"
    "				label = \"     From\";"
    "				}"
    "				:text{"
    "				label = \"     Telephone\";"
    "				}"
    "			}"
    "			:column{"
    "				:text{"
    "				label = \"     : Tam Pham Nhu\";"
    "				}"
    "				:text{" 
	  "				label = \"     : HaNoi City - Vietnam\";" 
	  "				}" 
	  "				:text{" 
	  "				label = \"     : Nhutam104@gmail.com\";" 
	  "				}" 
	  "				:text{" 
	  "				label = \"     : +84 983 890 491\";" 
	  "				}" 
	  "			}" 
	  "		}" 
	  "		:text{" 
	  "		key = \"sep2\";" 
	  "		}" 
	  "		:paragraph{" 
	  "		width = 80;" 
	  "			:text_part{" 
	  "				value = \"Any comments please send email to Nhutam104@gmail.com\";" 
	  "			}" 
	  "			:text_part{" 
	  "				value = \"Thank you for using and supporting.\";" 
	  "			}" 
	  "		}" 
	  "	}" 
	  "	  :button{" 
	  "	  label = \"&OK\";" 
	  "	  key = \"OkAbout\";" 
	  "	  is_default = true;" 
	  "	  is_cancel = true;" 
	  "	  width = 15;" 
	  "	  }"
	  " }"
  )
)
;;;
(defun LIC_SET_TILE_DECORATION ( NumTotal / Num Tile)
			(setq Num 0)
			(repeat NumTotal
				(setq Tile (strcat "sep" (itoa Num)))
				(set_tile Tile "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
				(setq Num (+ Num 1))
			)
		)
(defun CTESTY_SET_TILE_OF_SEP ( Tile / )
	(set_tile Tile "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
	(mode_tile Tile 1)                                                    
)