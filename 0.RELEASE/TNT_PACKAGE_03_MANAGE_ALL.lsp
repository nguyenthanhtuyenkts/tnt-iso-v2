;;; ====================================================================================================
;;; TNT_PACKAGE_03_MANAGE_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: 77_ROTATE VIEWPORT_VR1-VR2-VR3-VRR.lsp
;;; ====================================================================================================
(defun c:VR2 ()
  (command "_UCS" "_Z" "90")
  (command "_PLAN" "_Current")
)

(defun c:VR3 ()
  (command "_UCS" "_Z" "-90")
  (command "_PLAN" "_Current")
)


(defun c:VRR ()
  (command "_UCS" "_World")
  (command "_PLAN" "_World")
)

(defun c:VR1(/ p1 p2 p3 goc vs)
(setq p1 (getpoint "\nChon Tam")
p2 (getpoint p1 "\nChon Phuong hien tai")
p3 (getpoint p1 "\nChon Phuong moi")
goc (-(angle p3 p1)(angle p2 p1))
vs (getvar "viewsize")
p1 (trans p1 1 0))
(command "ucs" "z" (/(* 180 goc)pi) "")
(command "plan" "")
(command "zoom" "c" (trans p1 0 1) vs)
(princ)
)
;;; ====================================================================================================
;;; END SOURCE: 77_ROTATE VIEWPORT_R1-R2-R3-RR.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: 88_AUTO RESET OSNAP.LSP
;;; ====================================================================================================
;;;***[AUTOLISP - AUTO RESET OSNAP]***
(setq *TNT.MANAGE.OSMODE.DEFAULT* 15871)
(Defun resetosmode (v1 v2 /)
  (if (/= (getvar "osmode") *TNT.MANAGE.OSMODE.DEFAULT*) 
    (setvar "osmode" *TNT.MANAGE.OSMODE.DEFAULT*))
  (if (/= (getvar "MODEMACRO") "TNT Architecture") 
    (setvar "MODEMACRO" "TNT Architecture")
  )
  (Princ)
)
(vlr-editor-reactor  nil
  '(
    (:vlr-lispEnded . ResetOsmode)
    (:vlr-lispCancelled . ResetOsmode)
  )
)
(resetosmode nil nil)
;;; ====================================================================================================
;;; END SOURCE: 88_AUTO RESET OSNAP.LSP
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Manage_MoveToCenter.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; A_TNT_SYSTEM_PACKAGE_3
;;; ====================================================================================================
(defun c:VC (/ ss ssleng lst n center center1)
  (setvar "MODEMACRO" "TNT Architecture")
  (setvar "CMDECHO" 0)
  (setq osm (getvar "osmode"))  
  (setq ss (ssget))
  (setq ssleng (sslength ss))
  (setq lst (list))
  (setq n 0)
  (repeat ssleng
    (setq
      lst (append (list (vlax-ename->vla-object (ssname ss n))) lst)
    )
    (setq n (+ n 1))
  )
  (setq lst (TT:ListBoundingBox lst))
  (setq	center 
    (polar
      (car lst)
      (angle (car lst) (cadr lst))
      (* (distance (car lst) (cadr lst)) 0.5)
    )
  )
  (setq p1 (getpoint "Pick A Point"))
  (setq p2 (getcorner p1 "Pick corner"))
  (setq center1 (polar p1 (angle p1 p2) (/ (distance p1 p2) 2)))
  (command "osnap" "off")
  (command "move" ss "" center center1)
  (setvar "osmode" osm)
  (princ)
)
;;; ====================================================================================================
;;; TT:LISTBOUNDINGBOX
;;; ====================================================================================================
(defun TT:ListBoundingBox (lst / ll ur bb)
  (foreach obj lst
    (vla-getBoundingBox obj 'll 'ur)
    (setq bb (cons (vlax-safearray->list ur)
      (cons (vlax-safearray->list ll) bb)
      )
    )
  )
  (mapcar
    (function
      (lambda (operation)
      (apply (function mapcar) (cons operation bb))
      )
    )
    '(min max)
  )
)
;;; ====================================================================================================
;;; A_TNT_SYSTEM_PACKAGE_3
;;; ====================================================================================================
(defun c:VC1 (/)
	(vl-load-com)
	(defun sleep_osnap ()(setvar "OSMODE" (logior (getvar "OSMODE") 16384)))
	(defun wake_osnap ()(setvar "OSMODE" (logand (getvar "OSMODE") -16385)))
	(sleep_osnap)
	(princ "\nChọn đối tượng thứ nhất: ")
	(setq ent1 (ssget))
	(if ent1
		(progn
			(princ "\nChọn đối tượng thứ hai: ")
			(setq pt (getpoint "\nChọn tâm vùng kín cần chèn: "))
			(if pt
				(progn
					(setq pt1 (GetGeometricCenter ent1))
					(setq pt2 (getCentroid pt))
					(command "_.MOVE" ent1 "" pt1 pt2)
					(princ "\nĐã hoán đổi vị trí hai đối tượng!")
				)
				(princ "\nKhông chọn được đối tượng thứ hai!")
			)
		)
		(princ "\nKhông chọn được đối tượng thứ nhất!")
	)
	(wake_osnap)
	(princ)
)
;;; ====================================================================================================
;;; GETGEOMETRICCENTER
;;; ====================================================================================================
(defun GetGeometricCenter (ss / i ent minpt maxpt xsum ysum zsum pt cnt)
  (setq xsum 0.0 ysum 0.0 zsum 0.0 cnt 0)
  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (command "._UCS" "_World")
        (vla-getboundingbox (vlax-ename->vla-object ent) 'minpt 'maxpt)
        (setq minpt (vlax-safearray->list minpt)
              maxpt (vlax-safearray->list maxpt))
        (setq xsum (+ xsum (/ (+ (car minpt) (car maxpt)) 2.0))
              ysum (+ ysum (/ (+ (cadr minpt) (cadr maxpt)) 2.0))
              cnt (1+ cnt))
        (setq i (1+ i))
      )
      (if (> cnt 0)
        (progn
          (setq pt (list (/ xsum cnt) (/ ysum cnt) 0))
          pt
        )
        nil
      )
    )
    nil
  )
)
;;; ====================================================================================================
;;; GETCENTROID
;;; ====================================================================================================
(defun getCentroid (pt / area pt1)
	(setq ent (entlast))
	(Command ".Bpoly" "a" "o" "r" "" pt "")
	(if (setq ss (ssnewer ent))
		(progn
			(Command "Union" ss "")
			(setq pt1 (get-reference-point (vlax-ename->vla-object (entlast))))
		)
	)
	(if (setq ss (ssnewer ent)) (Command ".Erase" ss ""))
	pt1
)
;;; ====================================================================================================
;;; SSNEWER
;;; ====================================================================================================
(defun ssnewer (ent / ss ent1)
	(if ent
		(progn
			(setq ent1 ent)
			(while (setq ent1 (entnext ent1))
				(if ent1
					(progn
						(if (NULL ss) (setq ss (ssadd)))
						(setq ss (ssadd ent1 ss))
					)
				)
			)
			ss
		)
		nil
	)	
)
;;; ====================================================================================================
;;; GET-REFERENCE-POINT
;;; ====================================================================================================
(defun get-reference-point (obj / minpt maxpt midpt)
	(cond
		((vlax-property-available-p obj 'Centroid)
		(vlax-get obj 'Centroid))
		((vlax-property-available-p obj 'InsertionPoint)
		(vlax-get obj 'InsertionPoint))
		((vlax-property-available-p obj 'StartPoint)
		(setq midpt (mapcar '(lambda (x y) (/ (+ x y) 2.0))
		(vlax-get obj 'StartPoint)
		(vlax-get obj 'EndPoint)))
		midpt)
		(t
		(vla-getboundingbox obj 'minpt 'maxpt)
		(mapcar '(lambda (x y) (/ (+ x y) 2.0))
		(vlax-safearray->list minpt)
		(vlax-safearray->list maxpt)))
	)
)


(defun c:VC2 (/ ss ssleng lst n center center1 ASCALE)
  (setvar "MODEMACRO" "TNT Architecture")
  (setvar "CMDECHO" 0)
  (setq osm (getvar "osmode"))  
  (setq ss (ssget))
  (setq ssleng (sslength ss))
  (setq lst (list))
  (setq n 0)
  (repeat ssleng
    (setq
      lst (append (list (vlax-ename->vla-object (ssname ss n))) lst)
    )
    (setq n (+ n 1))
  )
  (setq lst (TT:ListBoundingBox lst))
  (setq	center 
    (polar
      (car lst)
      (angle (car lst) (cadr lst))
      (* (distance (car lst) (cadr lst)) 0.5)
    )
  )
  (setq ASCALE (getreal "\n TL SCALE :" ))  
  (command "scale" ss "" center ASCALE)
  (setvar "osmode" osm)
  (princ)
)
;;; ====================================================================================================
;;; END SOURCE: B_TNT_Manage_MoveToCenter.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: E_STT.lsp
;;; ====================================================================================================
(setq 3DUY-ALERT
       (strcat
         "Lisp danh so thu tu Text, Att, Dim v1.04"
         "\nLenh: STT - danh so thu tu (Text, Att, Dim)"
       )
)

(princ "\n[TNT] Loaded STT numbering tool.")
(vl-load-com)
;Danh STT
(defun C:stt ( / DCH DCL DIALOG ELST ELST_INS ENT FIL FLAG FUNC_GET FUNC_PUT FUZZ I I1 LST LST_ATT LST_SORT LST_TAG O1 O2 OBJ ORDER PREFIX STR SUFFIX SYM TITLE TYP ZERO)
  (setvar "CMDECHO" 0)
  (setvar "DIMZIN" 0)
  (vla-startundomark (vla-get-activedocument (vlax-get-acad-object)))
  (setq title "\\U+0110�nh s\\U+1ED1 th\\U+1EE9 t\\U+1EF1 Text, Att, Dim")
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
	     "					label = \"T�c gi\\U+1EA3\";"
	     "					: text { key = \"3DUY-TACGIA\"; value = \"3Duy | 0922.161.194\"; }"
	     "					}"
	     "				}"
	     "			: column"
	     "				{"
	     "				width = 27 ;"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Ph\\U+01B0\\U+01A1ng th\\U+1EE9c nh\\U+1EADp\";"
	     "					: radio_button { key = \"3DUY-STT-OVR\"; label = \"Ghi \\U+0111�\"; }"
	     "					: radio_button { key = \"3DUY-STT-ADD-L\"; label = \"Th�m v�o \\U+0111\\U+1EA7u\"; }"
	     "					: radio_button { key = \"3DUY-STT-ADD-R\"; label = \"Th�m v�o cu\\U+1ED1i\"; }"
	     "					}"
	     "				: boxed_column"
	     "					{"
	     "					label = \"Quy t\\U+1EAFc \\U+0111�nh s\\U+1ED1\";"
	     "					: edit_box { key = \"3DUY-STT-PRE\"; label = \"Ti\\U+1EC1n t\\U+1ED1\"; edit_width = 7; }"
	     "					: edit_box { key = \"3DUY-STT-SUF\"; label = \"H\\U+1EADu t\\U+1ED1\"; edit_width = 7; }"
	     "					: edit_box { key = \"3DUY-STT-START\"; label = \"STT b\\U+1EAFt \\U+0111\\U+1EA7u\"; edit_width = 7; }"
	     "					: text { key = \"3DUY-STT-NOTE1\"; value = \"(STT b\\U+1EAFt \\U+0111\\U+1EA7u c� th\\U+1EC3 nh\\U+1EADp ch\\U+1EEF\"; }"
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
;;; ====================================================================================================
;;; END SOURCE: E_STT.lsp
;;; ====================================================================================================

(princ "`n[TNT] Loaded TNT_PACKAGE_03_MANAGE_ALL.lsp")
(princ)
