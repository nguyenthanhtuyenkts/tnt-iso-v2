;; ------------------ Biến toàn cục phần mềm (khởi tạo 1 lần) -------------------
(setq NameSoftware "Edit Text "
      Version "1.00"
      Author "Tam Pham Nhu"
      Email "Nhutam104@gmail.com"
      City "HaNoi City - Vietnam"
      Phone "+84 983 890 491"
)

;; ------------------ Hàm khởi động chỉnh sửa thuộc tính -----------------------
(defun C:ED2 (/ *error* DCLEDITTEXT DCLABOUT CURCMD CANCEL-PRESSED ATT)
  (setq *error* MY-ERR)
  (vl-load-com)
  (setq DCLEDITTEXT (CREATE-EDIT-TEXT-DIALOG))
  (setq DCLABOUT (CREATE-ABOUT-DIALOG)) ; Khởi tạo DCLABOUT 1 lần dùng toàn phiên
  (setq CURCMD (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setq CANCEL-PRESSED nil)
  (while (and (not CANCEL-PRESSED)
              (/= (setq ATT (car (nentselp "\nSelect Attribute for edit: "))) nil))
    (if (member (GET-GC 0 ATT) '("ATTRIB" "TEXT" "MTEXT" "DIMENSION"))
        (EDIT-ATTRIBUTE ATT (GET-GC 1 ATT) DCLEDITTEXT DCLABOUT)
      (princ "\nSelect ATTRIB/TEXT/MTEXT/DIMENSION")))
  (setvar "CMDECHO" CURCMD)
  (setq *error* nil)
  (princ)
)

;; ------------------ Hàm xử lý lỗi ----------------------
(defun MY-ERR (MSG)
  (cond 
    ((= MSG "Function cancelled") (princ "\n\tUser abort"))
    (t (princ MSG)))
  (setq *error* nil)
  (princ)
)

;; ----------------- Hàm get/put thuộc tính ---------------------
(defun GET-GC (GROUP ENTITY)
  (cdr (assoc GROUP (entget ENTITY)))
)

(defun PUT-GC (VALUE GROUP ENTITY)
  (entmod (subst (cons GROUP VALUE) (assoc GROUP (entget ENTITY)) (entget ENTITY)))
)

;; ----------------- Hàm chỉnh sửa thuộc tính -------------------
(defun EDIT-ATTRIBUTE (ATT OLDVAL DCLEDITTEXT DCLABOUT)
  (setq TEXT OLDVAL)
  (SHOW-EDIT-DIALOG DCLEDITTEXT OLDVAL DCLABOUT)
  (PUT-GC TEXT 1 ATT)
)

;; ----------------- Hàm ghi file DCL tạm -----------------------
(defun MAKE-FILE-DCL (DCL-LINES NAME)
  (setq FNAME (vl-filename-mktemp (strcat NAME ".dcl"))
        FILE  (open FNAME "w"))
  (foreach LL DCL-LINES (write-line LL FILE))
  (close FILE)
  FNAME
)

;; ----------------- Hàm hiển thị hộp thoại chỉnh sửa -----------
(defun SHOW-EDIT-DIALOG (DCLEDITTEXT OLDVAL DCLABOUT / DCL_ID_EDIT)
  (setq DCL_ID_EDIT (load_dialog (MAKE-FILE-DCL DCLEDITTEXT "EditText")))
  (if (< DCL_ID_EDIT 1)
      (progn (alert "Không tìm thấy file EditText.DCL") (exit)))
  (if (not (new_dialog "EDIT" DCL_ID_EDIT))
      (progn (alert "Không tìm thấy hộp thoại EDIT") (exit)))
  (LIC_SET_TILE_DECORATION 4)
  (set_tile "text" OLDVAL)
  (action_tile "Tile_Ok"     "(setq TEXT (get_tile \"text\"))(done_dialog)")
  (action_tile "Tile_Cancel" "(setq CANCEL-PRESSED T)(done_dialog)")
  ;; Truyền DCLABOUT qua closure để luôn gọi đúng thông tin
  (action_tile "Tile_About"  "(SHOW-ABOUT-DIALOG DCLABOUT)")
  (start_dialog)
  (unload_dialog DCL_ID_EDIT)
)

;; --------------- Hàm hiển thị hộp thoại About -----------------
(defun SHOW-ABOUT-DIALOG (DCLABOUT / DCL_ID_ABOUT)
  (setq DCL_ID_ABOUT (load_dialog (MAKE-FILE-DCL DCLABOUT "About")))
  (if (< DCL_ID_ABOUT 1)
      (progn (alert "Không tìm thấy file About.DCL") (exit)))
  (if (not (new_dialog "ABOUT" DCL_ID_ABOUT))
      (progn (alert "Không tìm thấy hộp thoại ABOUT") (exit)))
  (CTESTY_SET_TILE_OF_SEP "sep1")
  (CTESTY_SET_TILE_OF_SEP "sep2")
  (start_dialog)
  (unload_dialog DCL_ID_ABOUT)
)

;; ------------- Hàm tạo DCL chỉnh sửa văn bản -------------------
(defun CREATE-EDIT-TEXT-DIALOG ()
  (list 
    "EDIT : dialog {"
    (strcat " label = \"" NameSoftware Version "\";")
    " initial_focus = \"text\";"
    " : column {"
    "   : text { key = \"txt1\"; value = \"- This is the main dialogue box.\"; }"
    "   : text { key = \"txt2\"; value = \"- To display the next, nested dialogue,\"; }"
    "   : text { key = \"txt3\"; value = \"- Press Next...\"; }"
    "   : spacer { width = 1; }"
    "   : text { key = \"sep0\"; }"
    "   : edit_box { label = \"TEXT CHANGE:\"; allow_accept = true; edit_width = 40; key = \"text\"; }"
    "   : text { key = \"sep1\"; }"
    "   : row {"
    "     : spacer { width = 1; }"
    "     : button { label = \"Accept\"; key = \"Tile_Ok\"; width = 12; fixed_width = true; mnemonic = A; is_default = true; }"
    "     : button { label = \"Cancel\"; key = \"Tile_Cancel\"; width = 12; fixed_width = true; mnemonic = C; is_cancel = true; }"
    "     : button { label = \"About...\"; key = \"Tile_About\"; width = 12; fixed_width = true; mnemonic = B; }"
    "     : spacer { width = 1; }"
    "   }"
    " }"
    "}"
  )
)

;; ------------- Hàm tạo DCL About -------------------------------
(defun CREATE-ABOUT-DIALOG ()
  (list
    "ABOUT : dialog {"
    " label = \"Information\";"
    " : boxed_column {"
    (strcat "   : text { label = \"" NameSoftware Version "\"; };")
    "   : text { label = \"Copyright © TNT\"; };"
    "   : text { key = \"sep1\"; };"
    "   : row {"
    "     : column {"
    "       : text { label = \"     Author\"; };"
    "       : text { label = \"     From\"; };"
    "       : text { label = \"     Email\"; };"
    "       : text { label = \"     Telephone\"; };"
    "     };"
    "     : column {"
    (strcat "       : text { label = \"     : " Author "\"; };")
    (strcat "       : text { label = \"     : " City "\"; };")
    (strcat "       : text { label = \"     : " Email "\"; };")
    (strcat "       : text { label = \"     : " Phone "\"; };")
    "     };"
    "   };"
    "   : text { key = \"sep2\"; };"
    "   : paragraph { width = 80;"
    (strcat "     : text_part { value = \"Any comments please send email to " Email "\"; };")
    "     : text_part { value = \"Thank you for using and supporting.\"; };"
    "   };"
    " };"
    " : button { label = \"&OK\"; key = \"OkAbout\"; is_default = true; is_cancel = true; width = 15; };"
    "}"
  )
)


;; ------------- Hàm trang trí separator DCL ---------------------
(defun LIC_SET_TILE_DECORATION (NumTotal / Num Tile)
  (setq Num 0)
  (repeat NumTotal
    (setq Tile (strcat "sep" (itoa Num)))
    (set_tile Tile
      "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    )
    (setq Num (+ Num 1))
  )
)

(defun CTESTY_SET_TILE_OF_SEP (Tile /)
  (set_tile Tile
    "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
  )
  (mode_tile Tile 1)
)
