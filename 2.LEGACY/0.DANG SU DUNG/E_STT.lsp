(setq 3DUY-ALERT
       (strcat
	 "Lisp \\U+0110ánh s\\U+1ED1 th\\U+1EE9 t\\U+1EF1, thêm b\\U+1EDBt n\\U+1ED9i dung Text, Att, Dim v1.04"
	 "\nTác gi\\U+1EA3: 3Duy | Phone: 0922161194 | Email: 3Duy3Duy@gmail.com"
	 "\nTên l\\U+1EC7nh:"
	 "\n     STT - \\U+0110ánh stt (Text, Att, Dim)"
	 "\n     C1 - Copy t\\U+0103ng d\\U+1EA7n (Text, Att)"
	 "\n     C2 - Copy gi\\U+1EA3m d\\U+1EA7n (Text, Att)"
	 "\n     1C - Copy t\\U+0103ng d\\U+1EA7n N \\U+0111\\U+01A1n v\\U+1ECB (Text, Att)"
	 "\n     FT - Thêm b\\U+1EDBt n\\U+1ED9i dung (Text, Att, Dim)"
	 "\n     ?? - B\\U+1EA3ng tên l\\U+1EC7nh"
	 )
      )

(princ (strcat "\n" 3DUY-ALERT))
(defun C:?? () (princ (strcat "\n" 3DUY-ALERT)) (alert 3DUY-ALERT) (princ))
(vl-load-com)

;Danh STT
(defun C:stt ( / DCH DCL DIALOG ELST ELST_INS ENT FIL FLAG FUNC_GET FUNC_PUT FUZZ I I1 LST LST_ATT LST_SORT LST_TAG O1 O2 OBJ ORDER PREFIX STR SUFFIX SYM TITLE TYP ZERO)
  (setvar "CMDECHO" 0)
  (setvar "DIMZIN" 0)
  (vla-startundomark (vla-get-activedocument (vlax-get-acad-object)))
  (setq title "\\U+0110ánh s\\U+1ED1 th\\U+1EE9 t\\U+1EF1 Text, Att, Dim")
  (setq dialog "STT")
  (setq dcl (vl-filename-mktemp nil nil ".dcl"))
  (cond
    ((not (ND:STT_dcl dcl dialog title))
     (princ "\nDCL file could not be written.")
     )
    ((<= (setq dch (load_dialog dcl)) 0)
     (princ "\nDCL file could not be loaded.")
     )
    ((not (new_dialog dialog dch))
     (princ "\nProgram dialog could not be loaded.")
     )
    (t
     (setq 3DUY-STT-VAR
	    '(
	      (3DUY-STT-OVR . "1")
	      (3DUY-STT-ADD-L . "0")
	      (3DUY-STT-ADD-R . "0")
	      (3DUY-STT-BLK . "1")
	      (3DUY-STT-TXT . "1")
	      (3DUY-STT-MTX . "1")
	      (3DUY-STT-DIM . "1")
	      (3DUY-STT-DIM-PRE . "1")
	      (3DUY-STT-DIM-SUF . "0")
	      (3DUY-STT-DIM-OVR . "0")
	      (3DUY-STT-PRE . "")
	      (3DUY-STT-SUF . "")
	      (3DUY-STT-START . "1")
	      ))
     (mapcar '(lambda (lst) (if (not (eval (car lst))) (set (car lst) (cdr lst)))) 3DUY-STT-VAR)
     (mapcar '(lambda (sym) (set_tile (vl-symbol-name sym) (eval sym))) (mapcar 'car 3DUY-STT-VAR))
     (defun ND:STT_modetile ()
       (mode_tile "3DUY-STT-DIM-PRE" (- 1 (atoi (get_tile "3DUY-STT-DIM"))))
       (mode_tile "3DUY-STT-DIM-SUF" (- 1 (atoi (get_tile "3DUY-STT-DIM"))))
       (mode_tile "3DUY-STT-DIM-OVR" (- 1 (atoi (get_tile "3DUY-STT-DIM"))))
       )
     (ND:STT_modetile)
     (action_tile "3DUY-STT-DIM" "(ND:STT_modetile)")
     (action_tile "accept"
       (vl-prin1-to-string
	 '(progn
	   (mapcar '(lambda (sym) (set sym (get_tile (vl-symbol-name sym)))) (mapcar 'car 3DUY-STT-VAR))
	   (done_dialog 1)
	   )))
     (action_tile "cancel" "(done_dialog)")
     (setq flag (start_dialog))
     (unload_dialog dch)
     )
    )

  (if
    (and
      (= flag 1)
      (setq fil (strcat (if (= 3DUY-STT-BLK "1") "INSERT," "") (if (= 3DUY-STT-TXT "1") "TEXT," "") (if (= 3DUY-STT-MTX "1") "MTEXT," "") (if (= 3DUY-STT-DIM "1") "*DIMENSION," "")))
      (setq elst (vl-remove-if 'listp (mapcar 'cadr (if (ssget (list (cons 0 fil))) (ssnamex (ssget "_P"))))))
      (setq elst (vl-remove-if '(lambda (ent) (and (wcmatch (cdr (assoc 0 (entget ent))) "INSERT") (not (ND:att_get ent)))) elst))
      (if (and
	    (setq elst_ins (vl-remove-if-not '(lambda (ent) (and (wcmatch (cdr (assoc 0 (entget ent))) "INSERT") (ND:att_get ent))) elst))
	    (setq lst (vl-sort (ND:unique (apply 'append (mapcar '(lambda (ent) (mapcar 'car (ND:att_get ent))) elst_ins))) '<))
	    )
	(setq lst_tag (ND:listbox lst "Ch\\U+1ECDn Tag" 10 16 1))
	t
	)
      (setq prefix 3DUY-STT-PRE)
      (setq suffix 3DUY-STT-SUF)
      )
    (progn
      (setq lst
	     (list
	       "U:tren->duoi"
	       "D:duoi->tren"
	       "L:trai->phai"
	       "R:phai->trai"
	       "X:theo-hai-chieu-XY"
	       "P:theo-huong-pline"
	       "C:theo-thu-tu-chon"
	       ))
      (setq order (substr (setq 3DUY-STT-ORDER (ND:get_key lst 3DUY-STT-ORDER "Thu tu sap xep")) 1 1))
      (if (= order "X")
	(progn
	  (setq 3DUY-STT-ORDER1 (ND:get_key (list "L:trai->phai" "R:phai->trai" "U:tren->duoi" "D:duoi->tren") 3DUY-STT-ORDER1 "Thu tu trong 1 nhom"))
	  (setq o1 (substr 3DUY-STT-ORDER1 1 1))
	  (setq 3DUY-STT-ORDER2 (ND:get_key (if (wcmatch o1 "L,R") (list "U:tren->duoi" "D:duoi->tren") (list "L:trai->phai" "R:phai->trai")) 3DUY-STT-ORDER2 "Thu tu giua cac nhom"))
	  (setq o2 (substr 3DUY-STT-ORDER2 1 1))
	  (setq 3DUY-STT-FUZZ (setq fuzz (ND:get_real (if 3DUY-STT-FUZZ 3DUY-STT-FUZZ 0.5) "Sai so khoang cach")))
	  )
	(progn
	  (setq o1 (substr 3DUY-STT-ORDER 1 1))
	  (setq o2 nil)
	  )
	)
      (setq lst_sort (cond
		       ((wcmatch order "U,D,L,R,X") (ND:ATK_sortXY elst o1 o2 fuzz))
		       ((= order "P") (ND:ent_sort-pline elst))
		       (t elst)
		       ))
      (if (and (>= (ascii 3DUY-STT-START) 48) (<= (ascii 3DUY-STT-START) 57))
	(progn
	  (setq i (atoi 3DUY-STT-START))
	  (setq zero (strlen 3DUY-STT-START))
	  )
	(setq i (substr 3DUY-STT-START 1 1))
	)
      (setq func_get
	     (cond
	       ((= 3DUY-STT-DIM-PRE "1") vla-get-TextPrefix)
	       ((= 3DUY-STT-DIM-SUF "1") vla-get-TextSuffix)
	       ((= 3DUY-STT-DIM-OVR "1") vla-get-TextOverride)
	       ))
      (setq func_put
	     (cond
	       ((= 3DUY-STT-DIM-PRE "1") vla-put-TextPrefix)
	       ((= 3DUY-STT-DIM-SUF "1") vla-put-TextSuffix)
	       ((= 3DUY-STT-DIM-OVR "1") vla-put-TextOverride)
	       ))
      (foreach ent lst_sort
	(if (numberp i)
	  (progn
	    (setq str (itoa i))
	    (repeat (- zero (strlen str)) (setq str (strcat "0" str)))
	    )
	  (setq str i)
	  )
	(setq str (strcat prefix str suffix))
	(setq lst (entget ent))
	(setq typ (cdr (assoc 0 lst)))
	(setq i1 0)
	(cond
	  ((and (wcmatch typ "INSERT") (setq lst_att (ND:att_get ent)))
	   (foreach tag lst_tag
	     (if (assoc tag lst_att)
	       (progn
		 (setq i1 1)
		 (cond
		   ((= 3DUY-STT-OVR "1") (ND:att_set ent tag str))
		   ((= 3DUY-STT-ADD-L "1") (ND:att_set ent tag (strcat str (cdr (assoc tag lst_att)))))
		   ((= 3DUY-STT-ADD-R "1") (ND:att_set ent tag (strcat (cdr (assoc tag lst_att)) str)))
		   (t nil)
		   )
		 ))))
	  ((wcmatch typ "*TEXT")
	   (setq i1 1)
	   (cond
	     ((= 3DUY-STT-OVR "1") (entmod (subst (cons 1 str) (assoc 1 lst) lst)))
	     ((= 3DUY-STT-ADD-L "1") (entmod (subst (cons 1 (strcat str (ND:unformat (cdr (assoc 1 lst)) nil))) (assoc 1 lst) lst)))
	     ((= 3DUY-STT-ADD-R "1") (entmod (subst (cons 1 (strcat (ND:unformat (cdr (assoc 1 lst)) nil) str)) (assoc 1 lst) lst)))
	     (t nil)
	     ))
	  ((wcmatch typ "*DIMENSION")
	   (setq i1 1)
	   (setq obj (vlax-ename->vla-object ent))
	   (cond
	     ((= 3DUY-STT-OVR "1") (func_put obj str))
	     ((= 3DUY-STT-ADD-L "1") (func_put obj (strcat str (ND:unformat (func_get obj) nil))))
	     ((= 3DUY-STT-ADD-R "1") (func_put obj (strcat (ND:unformat (func_get obj) nil) str)))
	     (t nil)
	     ))
	  (t nil)
	  )
	(if (numberp i)
	  (setq i (+ i i1))
	  (progn
	    (setq i (+ (ascii i) i1))
	    (if (not (or (and (>= i 65) (<= i 90)) (and (>= i 97) (<= i 122))))
	      (if (> i 97) (setq i 97) (setq i 65))
	      )
	    (setq i (chr i))
	    )
	  )
	)
      )
    )
  
  (vla-endundomark (vla-get-activedocument (vlax-get-acad-object)))
  (princ)
  )

;Sap xep elst
;Subfunc: ND:ins_pt
; order1: trong 1 nhom
; order2: trong cac nhom
; U:U>D - D:D>U - L:L>R - R:R>L
; fuzz: sai so
(defun ND:ATK_sortXY (elst o1 o2 fuzz)
  (if o2
    (vl-sort elst
	     '(lambda (e1 e2 / p1 p2)
		(setq p1 (trans (ND:ins_pt e1) 0 1))
		(setq p2 (trans (ND:ins_pt e2) 0 1))
		(if (wcmatch o1 "L,R")
		  (cond
		    ((equal (cadr p1) (cadr p2) fuzz)
		     (if (= o1 "L") (< (car p1) (car p2)) (> (car p1) (car p2)))
		     )
		    (t
		     (if (= o2 "D") (< (cadr p1) (cadr p2)) (> (cadr p1) (cadr p2)))
		     )
		    )
		  (cond
		    ((equal (car p1) (car p2) fuzz)
		     (if (= o1 "D") (< (cadr p1) (cadr p2)) (> (cadr p1) (cadr p2)))
		     )
		    (t
		     (if (= o2 "L") (< (car p1) (car p2)) (> (car p1) (car p2)))
		     )
		    )
		  )
		)
	     )
    (cond
      ((= o1 "U") (vl-sort elst '(lambda (e1 e2) (> (cadr (trans (ND:ins_pt e1) 0 1)) (cadr (trans (ND:ins_pt e2) 0 1))))))
      ((= o1 "D") (vl-sort elst '(lambda (e1 e2) (< (cadr (trans (ND:ins_pt e1) 0 1)) (cadr (trans (ND:ins_pt e2) 0 1))))))
      ((= o1 "L") (vl-sort elst '(lambda (e1 e2) (< (car (trans (ND:ins_pt e1) 0 1)) (car (trans (ND:ins_pt e2) 0 1))))))
      ((= o1 "R") (vl-sort elst '(lambda (e1 e2) (> (car (trans (ND:ins_pt e1) 0 1)) (car (trans (ND:ins_pt e2) 0 1))))))
      (t elst)
      )
    )
  )

;Sap xep ent theo chieu pline
;Sub func: ND:ins_pt_dim, ND:ent_pick
(defun ND:ent_sort-pline (elst / DIS1 DIS2 E ENT ENT_FUZZ FUZZ LST_FUZZ LST_PT LST_SORT LST_SORT1 LST_SORT2 OBJ_FUZZ PT1 PT2 TYP_FUZZ)
  (setq ent_pl (ND:ent_pick "*LINE" "Chon Pline: "))
  (setq lst_pt (mapcar '(lambda (ent) (ND:ins_pt_dim ent)) elst))
  (setq pt1 (trans (getpoint "\nChon diem dau: ") 1 0))
  (setq pt1 (car (vl-sort lst_pt '(lambda (pta ptb) (< (distance pt1 pta) (distance pt1 ptb))))))
  (setq pt1 (vlax-curve-getClosestPointTo ent_pl pt1))
  (setq pt2 (trans (getpoint "\nChon huong: " (trans pt1 0 1)) 1 0))
  (setq pt2 (vlax-curve-getClosestPointTo ent_pl pt2))
  (setq dis1 (vlax-curve-getDistatPoint ent_pl pt1))
  (setq dis2 (vlax-curve-getDistatPoint ent_pl pt2))
  (setq ent_fuzz (car elst))
  (setq obj_fuzz (vlax-ename->vla-object ent_fuzz))
  (setq lst_fuzz (entget ent_fuzz))
  (setq typ_fuzz (cdr (assoc 0 lst_fuzz)))
  (setq fuzz (cond
	       ((wcmatch typ_fuzz "INSERT") (cdr (assoc 41 lst_fuzz)))
	       ((wcmatch typ_fuzz "*TEXT") (cdr (assoc 40 lst_fuzz)))
	       ((wcmatch typ_fuzz "*DIMENSION") (* (vla-get-TextHeight obj_fuzz) (vla-get-ScaleFactor obj_fuzz)))
	       (t 0.)
	       ))
  (setq fuzz (* fuzz 0.5))
  (setq elst (vl-remove-if '(lambda (ent) (> (distance (ND:ins_pt_dim ent) (vlax-curve-getClosestPointTo ent_pl (ND:ins_pt_dim ent))) fuzz)) elst))
  (setq lst_sort (vl-sort elst '(lambda (e1 e2)
				  (<
				    (vlax-curve-getDistatPoint ent_pl (vlax-curve-getClosestPointTo ent_pl (ND:ins_pt_dim e1)))
				    (vlax-curve-getDistatPoint ent_pl (vlax-curve-getClosestPointTo ent_pl (ND:ins_pt_dim e2)))
				    ))))
  (setq lst_sort (mapcar '(lambda (e) (cons (vlax-curve-getDistatPoint ent_pl (vlax-curve-getClosestPointTo ent_pl (ND:ins_pt_dim e))) e)) lst_sort))
  (if (or (> dis1 dis2) (and (/= dis1 (car (last lst_sort))) (>= dis2 (car (last lst_sort))))) (setq lst_sort (reverse lst_sort)))
  (setq lst_sort1 (member (assoc dis1 lst_sort) lst_sort))
  (setq lst_sort2 (reverse (cdr (member (assoc dis1 lst_sort) (reverse lst_sort)))))
  (setq lst_sort (mapcar 'cdr (append lst_sort1 lst_sort2)))
  lst_sort
  )

;Tao file DCL
(defun ND:STT_dcl (dcl dialog title / des)
  (setq des (open dcl "w"))
  (write-line
    (strcat dialog ":"
	    "\ndialog"
	    "\n\t{"
	    (strcat "\n\tlabel = \"" title "\";")
	    ) des)
  (foreach x
	   '(
	     "	: column"
	     "		{"
	     "		: row"
	     "			{"
	     "			: column"
	     "				{"
	     "				width = 22 ;"
	     "				: boxed_column"
	     "					{"
	     "					label = \"\\U+0110\\U+1ED1i t\\U+01B0\\U+1EE3ng\";"
	     "					: toggle { key = \"3DUY-STT-BLK\"; label = \"Block Attribute\"; }"
	     "					: toggle { key = \"3DUY-STT-TXT\"; label = \"Text\"; }"
	     "					: toggle { key = \"3DUY-STT-MTX\"; label = \"Mtext\"; }"
	     "					: toggle { key = \"3DUY-STT-DIM\"; label = \"Dimension\"; }"
	     "					: radio_button { key = \"3DUY-STT-DIM-PRE\"; label = \"Dim prefix\"; }"
	     "					: radio_button { key = \"3DUY-STT-DIM-SUF\"; label = \"Dim suffix\"; }"
	     "					: radio_button { key = \"3DUY-STT-DIM-OVR\"; label = \"Textoverride\"; }"
	     "					}"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Tác gi\\U+1EA3\";"
	     "					: text { key = \"3DUY-TACGIA\"; value = \"3Duy | 0922.161.194\"; }"
	     "					}"
	     "				}"
	     "			: column"
	     "				{"
	     "				width = 27 ;"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Ph\\U+01B0\\U+01A1ng th\\U+1EE9c nh\\U+1EADp\";"
	     "					: radio_button { key = \"3DUY-STT-OVR\"; label = \"Ghi \\U+0111è\"; }"
	     "					: radio_button { key = \"3DUY-STT-ADD-L\"; label = \"Thêm vào \\U+0111\\U+1EA7u\"; }"
	     "					: radio_button { key = \"3DUY-STT-ADD-R\"; label = \"Thêm vào cu\\U+1ED1i\"; }"
	     "					}"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Quy t\\U+1EAFc \\U+0111ánh s\\U+1ED1\";"
	     "					: edit_box { key = \"3DUY-STT-PRE\"; label = \"Ti\\U+1EC1n t\\U+1ED1\"; edit_width = 7; }"
	     "					: edit_box { key = \"3DUY-STT-SUF\"; label = \"H\\U+1EADu t\\U+1ED1\"; edit_width = 7; }"
	     "					: edit_box { key = \"3DUY-STT-START\"; label = \"STT b\\U+1EAFt \\U+0111\\U+1EA7u\"; edit_width = 7; }"
	     "					: text { key = \"3DUY-STT-NOTE1\"; value = \"(STT b\\U+1EAFt \\U+0111\\U+1EA7u có th\\U+1EC3 nh\\U+1EADp ch\\U+1EEF\"; }"
	     "					: text { key = \"3DUY-STT-NOTE2\"; value = \"ho\\U+1EB7c s\\U+1ED1: 1, 02, 003, A, B, C,...)\"; }"
	     "					}"
	     "				}"
	     "			}"
	     "		ok_cancel;"
	     "		}"
	     )
    (write-line x des)
    )
  (write-line "\t}" des)
  (setq des (close des))
  (while (not (findfile dcl)))
  dcl
  )

;Them bot noi dung Text, Att, Dim
(defun C:ft ( / DCH DCL DIALOG FLAG TITLE)
  (setvar "CMDECHO" 0)
  (setvar "DIMZIN" 0)
  (vla-startundomark (vla-get-activedocument (vlax-get-acad-object)))
  
  (setq title "Thêm b\\U+1EDBt n\\U+1ED9i dung Text, Att, Dim")
  (setq dialog "FIND")
  (setq dcl (vl-filename-mktemp nil nil ".dcl"))
  (cond
    ((not (ND:FT_write dcl dialog title))
     (princ "\nDCL file could not be written.")
     )
    ((<= (setq dch (load_dialog dcl)) 0)
     (princ "\nDCL file could not be loaded.")
     )
    ((not (new_dialog dialog dch))
     (princ "\nProgram dialog could not be loaded.")
     )
    (t
     (setq 3DUY-FT-VAR-DEFAULT
	    '(
	      (3DUY-FT-ADD-PREFIX . "")
	      (3DUY-FT-ADD-SUFFIX . "")
	      (3DUY-FT-DEL-LEFT . "")
	      (3DUY-FT-DEL-RIGHT . "")
	      (3DUY-FT-OBJ-ATT . "1")
	      (3DUY-FT-OBJ-TXT . "1")
	      (3DUY-FT-OBJ-MTX . "1")
	      (3DUY-FT-OBJ-DIM-PRE . "0")
	      (3DUY-FT-OBJ-DIM-SUF . "0")
	      (3DUY-FT-OBJ-DIM-OVR . "1")
	      )
	   )
     (mapcar '(lambda (lst) (if (not (eval (car lst))) (set (car lst) (cdr lst)))) 3DUY-FT-VAR-DEFAULT)
     (mapcar '(lambda (sym) (set_tile (vl-symbol-name sym) (eval sym))) (mapcar 'car 3DUY-FT-VAR-DEFAULT))
     (action_tile "3DUY-FT-ADD-BUT" "(ND:FT_savevar 1)")
     (action_tile "3DUY-FT-DEL-BUT" "(ND:FT_savevar 2)")
     (action_tile "accept" "(ND:FT_savevar 0)")
     (action_tile "cancel" "(ND:FT_savevar 0)")
     (setq flag (start_dialog))
     (unload_dialog dch)
     )
    )

  (cond
    ((= flag 1) (ND:FT_but_ADD))
    ((= flag 2) (ND:FT_but_DEL))
    (t nil)
    )

  (vla-endundomark (vla-get-activedocument (vlax-get-acad-object)))
  (princ)
  )

;Luu gia tri dien vao bien
(defun ND:FT_savevar (flag)
  (mapcar '(lambda (sym) (set sym (get_tile (vl-symbol-name sym)))) (mapcar 'car 3DUY-FT-VAR-DEFAULT))
  (done_dialog flag)
  )

;Button - Add
(defun ND:FT_but_ADD ( / ELST ELST_INS ENT FIL LST LST_ATT LST_TAG OBJ PREFIX STR SUFFIX TYP)
  (if
    (and
      (setq fil (strcat
		  (if (= 3DUY-FT-OBJ-ATT "1") "INSERT," "")
		  (if (= 3DUY-FT-OBJ-TXT "1") "TEXT," "")
		  (if (= 3DUY-FT-OBJ-MTX "1") "MTEXT," "")
		  (if (or (= 3DUY-FT-OBJ-DIM-PRE "1") (= 3DUY-FT-OBJ-DIM-SUF "1") (= 3DUY-FT-OBJ-DIM-OVR "1")) "*DIMENSION," "")
		  ))
      (setq elst (vl-remove-if 'listp (mapcar 'cadr (if (ssget (list (cons 0 fil))) (ssnamex (ssget "_P"))))))
      (setq prefix 3DUY-FT-ADD-PREFIX)
      (setq suffix 3DUY-FT-ADD-SUFFIX)
      )
    (progn
      (if (and
	    (setq elst_ins (vl-remove-if-not '(lambda (ent) (and (wcmatch (cdr (assoc 0 (entget ent))) "INSERT") (ND:att_get ent))) elst))
	    (setq lst (vl-sort (ND:unique (apply 'append (mapcar '(lambda (ent) (mapcar 'car (ND:att_get ent))) elst_ins))) '<))
	    )
	(setq lst_tag (ND:listbox lst "Ch\\U+1ECDn Tag" 10 16 1))
	)
      (foreach ent elst
	(setq lst (entget ent))
	(setq typ (cdr (assoc 0 (entget ent))))
	(cond
	  ((wcmatch typ "INSERT")
	   (foreach tag (mapcar 'car (setq lst_att (ND:att_get ent)))
	     (if (member tag lst_tag)
	       (ND:att_set ent tag (strcat prefix (cdr (assoc tag lst_att)) suffix))
	       )
	     )
	   )
	  ((wcmatch typ "*TEXT")
	   (setq str (strcat prefix (ND:unformat (cdr (assoc 1 lst)) nil) suffix))
	   (entmod (subst (cons 1 str) (assoc 1 lst) lst))
	   )
	  ((wcmatch typ "*DIMENSION")
	   (setq obj (vlax-ename->vla-object ent))
	   (if (= 3DUY-FT-OBJ-DIM-PRE "1")
	     (progn
	       (setq str (strcat prefix (ND:unformat (vla-get-TextPrefix obj) nil) suffix))
	       (vla-put-TextPrefix obj str)
	       )
	     )
	   (if (= 3DUY-FT-OBJ-DIM-SUF "1")
	     (progn
	       (setq str (strcat prefix (ND:unformat (vla-get-TextSuffix obj) nil) suffix))
	       (vla-put-TextSuffix obj str)
	       )
	     )
	   (if (= 3DUY-FT-OBJ-DIM-OVR "1")
	     (progn
	       (setq str (strcat prefix (ND:unformat (vla-get-TextOverride obj) nil) suffix))
	       (vla-put-TextOverride obj str)
	       )
	     )
	   )
	  (t nil)
	  )
	)
      )
    )
  )

;Button - Del
(defun ND:FT_but_DEL ( / ELST ELST_INS ENT FIL LEFT LST LST_ATT LST_TAG OBJ RIGHT STR TYP)
  (if
    (and
      (setq fil (strcat
		  (if (= 3DUY-FT-OBJ-ATT "1") "INSERT," "")
		  (if (= 3DUY-FT-OBJ-TXT "1") "TEXT," "")
		  (if (= 3DUY-FT-OBJ-MTX "1") "MTEXT," "")
		  (if (or (= 3DUY-FT-OBJ-DIM-PRE "1") (= 3DUY-FT-OBJ-DIM-SUF "1") (= 3DUY-FT-OBJ-DIM-OVR "1")) "*DIMENSION," "")
		  ))
      (setq elst (vl-remove-if 'listp (mapcar 'cadr (if (ssget (list (cons 0 fil))) (ssnamex (ssget "_P"))))))
      (setq left (abs (atoi 3DUY-FT-DEL-LEFT)))
      (setq right (abs (atoi 3DUY-FT-DEL-RIGHT)))
      )
    (progn
      (if (and
	    (setq elst_ins (vl-remove-if-not '(lambda (ent) (and (wcmatch (cdr (assoc 0 (entget ent))) "INSERT") (ND:att_get ent))) elst))
	    (setq lst (vl-sort (ND:unique (apply 'append (mapcar '(lambda (ent) (mapcar 'car (ND:att_get ent))) elst_ins))) '<))
	    )
	(setq lst_tag (ND:listbox lst "Ch\\U+1ECDn Tag" 10 16 1))
	)
      (foreach ent elst
	(setq lst (entget ent))
	(setq typ (cdr (assoc 0 (entget ent))))
	(cond
	  ((wcmatch typ "INSERT")
	   (foreach tag (mapcar 'car (setq lst_att (ND:att_get ent)))
	     (if (member tag lst_tag)
	       (ND:att_set ent tag (ND:str_trim (cdr (assoc tag lst_att)) left right))
	       )
	     )
	   )
	  ((wcmatch typ "*TEXT")
	   (setq str (ND:str_trim (ND:unformat (cdr (assoc 1 lst)) nil) left right))
	   (entmod (subst (cons 1 str) (assoc 1 lst) lst))
	   )
	  ((wcmatch typ "*DIMENSION")
	   (setq obj (vlax-ename->vla-object ent))
	   (if (= 3DUY-FT-OBJ-DIM-PRE "1")
	     (progn
	       (setq str (ND:str_trim (ND:unformat (vla-get-TextPrefix obj) nil) left right))
	       (vla-put-TextPrefix obj str)
	       )
	     )
	   (if (= 3DUY-FT-OBJ-DIM-SUF "1")
	     (progn
	       (setq str (ND:str_trim (ND:unformat (vla-get-TextSuffix obj) nil) left right))
	       (vla-put-TextSuffix obj str)
	       )
	     )
	   (if (= 3DUY-FT-OBJ-DIM-OVR "1")
	     (progn
	       (setq str (ND:str_trim (ND:unformat (vla-get-TextOverride obj) nil) left right))
	       (vla-put-TextOverride obj str)
	       )
	     )
	   )
	  (t nil)
	  )
	)
      )
    )
  )

;String trim left and right
(defun ND:str_trim (str left right)
  (if (>= (strlen str) left) (setq str (substr str (1+ left))))
  (if (>= (strlen str) right) (setq str (substr str 1 (- (strlen str) right))))
  str
  )

;Tao file DCL
(defun ND:FT_write (dcl dialog title / des)
  (setq des (open dcl "w"))
  (write-line
    (strcat dialog ":"
	    "\ndialog"
	    "\n\t{"
	    (strcat "\n\tlabel = \"" title "\";")
	    ) des)
  (foreach x
	   '(
	     "	: column"
	     "		{"
	     "		: row"
	     "			{"
	     "			: column"
	     "				{"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Thêm ti\\U+1EC1n t\\U+1ED1, h\\U+1EADu t\\U+1ED1\";"
	     "					: row"
	     "						{"
	     "						: column"
	     "							{"
	     "							: edit_box { key = \"3DUY-FT-ADD-PREFIX\"; label = \"Thêm ti\\U+1EC1n t\\U+1ED1\"; fixed_width = true; width = 48; edit_width = 30; }"
	     "							: edit_box { key = \"3DUY-FT-ADD-SUFFIX\"; label = \"Thêm h\\U+1EADu t\\U+1ED1\"; fixed_width = true; width = 48; edit_width = 30; }"
	     "							}"
	     "						: button { key = \"3DUY-FT-ADD-BUT\"; label = \"Thêm\"; fixed_width = true; width = 12 ; }"
	     "						}"
	     "					}"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Xóa 1 \\U+0111o\\U+1EA1n ký t\\U+1EF1\";"
	     "					: row"
	     "						{"
	     "						: column"
	     "							{"
	     "							: edit_box { key = \"3DUY-FT-DEL-LEFT\"; label = \"Xóa N ký t\\U+1EF1 \\U+0111\\U+1EA7u\"; fixed_width = true; width = 48; edit_width = 30; }"
	     "							: edit_box { key = \"3DUY-FT-DEL-RIGHT\"; label = \"Xóa N ký t\\U+1EF1 cu\\U+1ED1i\"; fixed_width = true; width = 48; edit_width = 30; }"
	     "							}"
	     "						: button { key = \"3DUY-FT-DEL-BUT\"; label = \"Xóa\"; fixed_width = true; width = 12 ; }"
	     "						}"
	     "					}"
	     "				}"
	     "			: boxed_column"
	     "				{"
	     "				label = \"\\U+0110\\U+1ED1i t\\U+01B0\\U+1EE3ng áp d\\U+1EE5ng\";"
	     "				: toggle { key = \"3DUY-FT-OBJ-ATT\"; label = \"Attribute\"; }"
	     "				: toggle { key = \"3DUY-FT-OBJ-TXT\"; label = \"Text\"; }"
	     "				: toggle { key = \"3DUY-FT-OBJ-MTX\"; label = \"Mtext\"; }"
	     "				: toggle { key = \"3DUY-FT-OBJ-DIM-PRE\"; label = \"Dim Prefix\"; }"
	     "				: toggle { key = \"3DUY-FT-OBJ-DIM-SUF\"; label = \"Dim Suffix\"; }"
	     "				: toggle { key = \"3DUY-FT-OBJ-DIM-OVR\"; label = \"Dim Textoverride\"; }"
	     "				}"
	     "			}"
	     "		: boxed_column"
	     "			{"
	     "			label = \"Tác gi\\U+1EA3\";"
	     "			: text { key = \"3DUY-TACGIA\"; value = \"3Duy  |  Phone: 0922161194  |  Email: 3Duy3Duy@gmail.com\" ; }"
	     "			}"
	     "		: row"
	     "			{"
	     "			spacer_0;"
	     "			: button { key = \"accept\"; label = \"Thoát\"; is_default = true; is_cancel = true; fixed_width = true; width = 12 ; }"
	     "			spacer_0;"
	     "			}"
	     "		}"
	     )
    (write-line x des)
    )
  (write-line "\t}" des)
  (setq des (close des))
  (while (not (findfile dcl)))
  dcl
  )

;Copy tang, giam dan
(defun C:c1 () (ND:copy+ 1 t) (princ))
(defun C:c2 () (ND:copy+ -1 t) (princ))
(defun C:1c () (ND:copy+ (setq 3Duy-C+DT (ND:get_real (if 3Duy-C+DT 3Duy-C+DT 1) "Nh\\U+1EADp s\\U+1ED1 c\\U+1ED9ng thêm")) nil) (princ))

;Ham con Copy tang, giam dan
(defun ND:copy+ (INT OPT / CONDS ELST ELST1 ELST_INS ENT1 I LST LST0 LST1 LST_TAG OBJ PT0 PT1 STR0 STR1 TAG X)
  (setvar "CMDECHO" 0)
  (setvar "DIMZIN" 0)
  (vla-startundomark (vla-get-activedocument (vlax-get-acad-object)))
  (setq elst (vl-remove-if 'listp (mapcar 'cadr (if (ssget) (ssnamex (ssget "_P"))))))
  (setq elst1 elst)
  (while elst1
    (setq lst (entget (car elst1)))
    (if (wcmatch (cdr (assoc 0 lst)) "*TEXT") (setq elst1 nil))
    (if (wcmatch (cdr (assoc 0 lst)) "INSERT")
      (progn
	(setq elst_ins (apply 'append (mapcar '(lambda (x) (if (wcmatch (cdr (assoc 0 (entget x))) "INSERT") (list x))) elst)))
	(if (setq lst_tag (ND:unique (mapcar 'car (apply 'append (mapcar 'ND:att_get elst_ins)))))
	  (if (> (length lst_tag) 1)
	    (setq tag (ND:get_key lst_tag nil "Ch\\U+1ECDn Tag"))
	    (setq tag (car lst_tag))
	    )
	  )
	(setq elst1 nil)
	)
      )
    (setq elst1 (cdr elst1))
    )
  (if (not (setq pt0 (getpoint "\nCh\\U+1ECDn \\U+0111i\\U+1EC3m g\\U+1ED1c: "))) (setq pt0 (car (cdr (grread t)))))
  
  (setq i 1)
  (while (setq pt1 (getpoint pt0 "\nCh\\U+1ECDn \\U+0111i\\U+1EC3m \\U+0111\\U+1EB7t: "))
    (setq conds t)
    (foreach ent0 elst
      (setq obj (vla-Copy (vlax-ename->vla-object ent0)))
      (vla-Move obj (vlax-3d-point (trans pt0 1 0)) (vlax-3d-point (trans pt1 1 0)))
      (setq ent1 (vlax-vla-object->ename obj))
      (setq lst0 (entget ent0))
      (setq lst1 (entget ent1))
      (if (and conds (wcmatch (cdr (assoc 0 lst1)) "*TEXT"))
	(progn
	  (setq str0 (cdr (assoc 1 lst0)))
	  (if opt
	    (progn
	      (setq str1 (ND:str++ str0 (fix (* i int))))
	      (entmod (subst (cons 1 str1) (assoc 1 lst1) lst1))
	      )
	    (if (wcmatch str0 "~*[~0-9]*,~*[~0-9`.0-9]*")
	      (progn
		(setq str1 (rtos (+ (atof str0) (* i int)) 2 (getvar "LUPREC")))
		(entmod (subst (cons 1 str1) (assoc 1 lst1) lst1))
		)
	      )
	    )
	  )
	)
      (if (and conds (wcmatch (cdr (assoc 0 lst1)) "INSERT"))
	(if (ND:att_get ent1)
	  (progn
	    (setq str0 (cdr (assoc tag (ND:att_get ent0))))
	    (if opt
	      (progn
		(setq str1 (ND:str++ str0 (fix (* i int))))
		(ND:att_set ent1 tag str1)
		)
	      (if (wcmatch str0 "~*[~0-9]*,~*[~0-9`.0-9]*")
		(progn
		  (setq str1 (rtos (+ (atof str0) (* i int)) 2 (getvar "LUPREC")))
		  (ND:att_set ent1 tag str1)
		  )
		)
	      )
	    )
	  )
	)
      )
    (setq conds nil)
    (setq i (1+ i))
    )
  (vla-endundomark (vla-get-activedocument (vlax-get-acad-object)))
  )

;STRING++
(defun ND:str++ (str int+ / CHA I LCHAR NUM+ NUM0 PREFIX STR+ STR_NUM+)
  (if (wcmatch
	(setq lchar (substr str (strlen str)))
	"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	)
    (progn
      (if (and (>= (ascii lchar) 65) (<= (ascii lchar) 90))
	(if (> int+ 0)
	  (setq cha (chr (min (+ (ascii lchar) int+) 90)))
	  (setq cha (chr (max (+ (ascii lchar) int+) 65)))
	  )
	(if (> int+ 0)
	  (setq cha (chr (min (+ (ascii lchar) int+) 122)))
	  (setq cha (chr (max (+ (ascii lchar) int+) 97)))
	  )
	)
	(setq str+ (strcat (substr str 1 (1- (strlen str))) cha))
      )
    (progn
      (setq num0 "")
      (setq i (strlen str))
      (while (> i 0)
	(setq cha (substr str i 1))
	(if (or (/= (atof cha) 0) (= cha "0"))
	  (setq num0 (strcat cha num0))
	  (setq i 0)
	  )
	(setq i (1- i))
	)
      (setq num+ (+ (atoi num0) int+))
      (setq str_num+ (itoa num+))
      (repeat (- (strlen num0) (strlen (itoa num+)))
	(setq str_num+ (strcat "0" str_num+))
	)
      (setq prefix (substr str 1 (- (strlen str) (strlen num0))))
      (setq str+ (strcat prefix str_num+))
      )
    )
  )

;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;------------------SUB FUNCTION--------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------
;--------------------------------------------------


;--------------------------------
;---------- ATTRIBUTTE ----------
;--------------------------------

;Thong ke Att.Val theo Insert
(defun ND:att_get (ent / enx)
  (if (and (setq ent (entnext ent)) (= "ATTRIB" (cdr (assoc 0 (setq enx (entget ent))))))
    (cons (cons (cdr (assoc 2 enx)) (cdr (assoc 1 (reverse enx)))) (ND:att_get ent))
    )
  )

;Set Att (1 Tag) theo Insert
(defun ND:att_set (ent tag val)
  (setq tag (strcase tag))
  (vl-some
    '(lambda (att)
       (if (= tag (strcase (vla-get-tagstring att)))
	 (progn (vla-put-textstring att val) val)
	 )
       )
    (vlax-invoke (vlax-ename->vla-object ent) 'getattributes)
    )
  )

;-------------------------------------
;---------- XU LY DOI TUONG ----------
;-------------------------------------

;Xoa phan tu trung trong list
(defun ND:unique (lst)
  (if lst (cons (car lst) (ND:unique (vl-remove (car lst) (cdr lst)))))
  )

;Lay diem chen (diem can le text) doi tuong
(defun ND:ins_pt (ent / lst pt)
  (if (= (type ent) 'ename)
    (progn
      (setq lst (entget ent))
      (setq pt (cdr (assoc 11 lst)))
      (if (or (equal (list (car pt) (cadr pt)) '(0 0)) (equal (list (car pt) (cadr pt)) '(1 0)) (not pt))
	(cdr (assoc 10 lst))
	pt
	)
      )
    )
  )

;Lay diem chen (diem can le text) doi tuong - Lay chan dim
(defun ND:ins_pt_dim (ent / lst pt pt13 pt14)
  (if (= (type ent) 'ename)
    (progn
      (setq lst (entget ent))
      (if (wcmatch (cdr (assoc 0 lst)) "*DIMENSION")
	(progn
	  (setq pt13 (cdr (assoc 13 lst)))
	  (setq pt14 (cdr (assoc 14 lst)))
	  (setq pt (list (* (+ (car pt13) (car pt14)) 0.5) (* (+ (cadr pt13) (cadr pt14)) 0.5) 0.))
	  )
	(progn
	  (setq pt (cdr (assoc 11 lst)))
	  (if (or (equal (list (car pt) (cadr pt)) '(0 0)) (equal (list (car pt) (cadr pt)) '(1 0)) (not pt))
	    (cdr (assoc 10 lst))
	    pt
	    )
	  )
	)
      )
    )
  )

;Unformat string
(defun ND:unformat (str mtx / _replace rx)
  (defun _replace (new old str)
    (vlax-put-property rx 'pattern old)
    (vlax-invoke rx 'replace str new)
    )
  (if (setq rx (vlax-get-or-create-object "VBScript.RegExp"))
    (progn
      (setq str
	     (vl-catch-all-apply
	       (function
		 (lambda ()
		   (vlax-put-property rx 'global     actrue)
		   (vlax-put-property rx 'multiline  actrue)
		   (vlax-put-property rx 'ignorecase acfalse)
		   (foreach pair
			    '(
			      ("\032"    . "\\\\\\\\")
			      (" "       . "\\\\P|\\n|\\t")
			      ("$1"      . "\\\\(\\\\[ACcFfHLlOopQTW])|\\\\[ACcFfHLlOopQTW][^\\\\;]*;|\\\\[ACcFfHLlOopQTW]")
			      ("$1$2/$3" . "([^\\\\])\\\\S([^;]*)[/#\\^]([^;]*);")
			      ("$1$2"    . "\\\\(\\\\S)|[\\\\](})|}")
			      ("$1"      . "[\\\\]({)|{")
			      )
		     (setq str (_replace (car pair) (cdr pair) str))
		     )
		   (if mtx
		     (_replace "\\\\" "\032" (_replace "\\$1$2$3" "(\\\\[ACcFfHLlOoPpQSTW])|({)|(})" str))
		     (_replace "\\"   "\032" str)
		     )
		   )
		 )
	       )
	    )
      (vlax-release-object rx)
      (if (null (vl-catch-all-error-p str))
	str
	)
      )
    )
  )

;-------------------------------
;---------- NHAP LIEU ----------
;-------------------------------

;Nhap so thuc
(defun ND:get_real (default promp / str)
  (while (not str)
    (setq str (getstring (strcat "\n" promp " <" (rtos (float default) 2 (getvar "LUPREC")) ">: ")))
    (if (= (substr str 1 1) ".") (setq str (strcat "0" str)))
    (setq str (cond
		((= str "") (float default))
		((numberp (read str)) (atof str))
		(t nil)
		))
    )
  )

;Chon doi tuong
(defun ND:ent_pick (typ promp / ent)
  (while (not ent)
    (while (not (setq ent (car (entsel (strcat "\n" promp))))))
    (if (not (wcmatch (cdr (assoc 0 (entget ent))) typ)) (setq ent nil))
    )
  ent
  )

;Nhap Keyword
(defun ND:get_key (key default promp / del init key_init key_select result select str)
  (setq key_init key)
  (foreach del (list " " "_")
    (setq key_init (mapcar '(lambda (str) (while (vl-string-search del str) (setq str (vl-string-subst "" del str))) str) key_init))
    )
  (setq key_select (mapcar '(lambda (str) (while (vl-string-search "_" str) (setq str (vl-string-subst "" "_" str))) str) key))
  (setq init (strcat (car key_init) (apply 'strcat (mapcar (function (lambda (x) (strcat " " x))) (cdr key_init)))))
  (setq select (strcat (car key_select) (apply 'strcat (mapcar (function (lambda (x) (strcat "/" x))) (cdr key_select)))))
  (if (member default key) (setq default (nth (vl-position default key) key_select)) (setq default (car key_select)))
  (initget init)
  (setq promp (strcat "\n" promp " [" select "] <" default ">: "))
  (if (setq result (getkword promp))
    (nth (vl-position result key_init) key)
    (nth (vl-position default key_select) key)
    )
  )

;Chon trong hop thoai
(defun ND:listbox (lst msg wid hei bit / dch des tmp rtn)
  (if (> (length lst) 1)
    (progn
      (cond
	((not
	   (and
	     (setq tmp (vl-filename-mktemp nil nil ".dcl"))
	     (setq des (open tmp "w"))
	     (write-line
	       (strcat
		 "listbox:dialog{label=\""
		 msg
		 "\";spacer;:list_box{key=\"list\";multiple_select="
		 (if (= 1 (logand 1 bit))
		   "true"
		   "false"
		 )
		 (strcat ";width="
			 (rtos wid 2 0)
			 ";height="
			 (rtos hei 2 0)
			 ";}spacer;ok_cancel;}"
		 )
	       )
	       des
	     )
	     (not (close des))
	     (< 0 (setq dch (load_dialog tmp)))
	     (new_dialog "listbox" dch)
	   )
	 )
	 (prompt "\nError Loading List Box Dialog.")
	)
	(t
	 (start_list "list")
	 (foreach itm lst (add_list itm))
	 (end_list)
	 (setq rtn (set_tile "list" "0"))
	 (action_tile "list" "(setq rtn $value)")
	 (setq rtn
		(if (= 1 (start_dialog))
		  (if (= 2 (logand 2 bit))
		    (read (strcat "(" rtn ")"))
		    (mapcar '(lambda (x) (nth x lst))
			    (read (strcat "(" rtn ")"))
		    )
		  )
		)
	 )
	)
      )
      (if (< 0 dch)
	(unload_dialog dch)
      )
      (if (and tmp (setq tmp (findfile tmp)))
	(vl-file-delete tmp)
      )
      rtn
    )
    lst
    )
  )