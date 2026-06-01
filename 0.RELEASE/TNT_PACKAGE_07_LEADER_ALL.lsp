;;; ====================================================================================================
;;; TNT_PACKAGE_07_LEADER_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Leader_.lsp
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
(defun c:A3 (/ occho lstss lstle lsttext p1 o1 dt lst1 lst botoadox toadox1 toadodiem1 lst2 
			lts3 pt1 xdau pt pdat textObj cle alignmentPoint)
(setvar "MODEMACRO" "TNT Architecture")
(setvar "CMDECHO" 0)
(setq occho (getvar "osmode"))  
(setq lstss (CV:ss-to-list (ssget (list (cons 0 "LEADER,*TEXT"))) nil))
(setq lstle (vl-remove-if-not '(lambda (x) (= (cdr (assoc 0 (entget x))) "LEADER")) lstss))
(setq lsttext (vl-remove-if-not '(lambda (x) (/= (cdr (assoc 0 (entget x))) "LEADER")) lstss))
(setq p1 (getpoint "\nChon diem cuoi leader."))
(setvar "osmode" 0)
(setq cle "T")
(foreach ent lstle
  (setq o1 (entget ent))
  (setq dt (cdr(assoc 0 o1)))
	(setq xdau (car (cdr (assoc 10 o1))))
    (setq lst1 (reverse o1))
    (setq lst (assoc 10 lst1))
    (setq botoadox (cdr(cdr lst)))
    (setq toadox1 (car p1))
    (setq toadodiem1 (append (list toadox1) botoadox))
    (setq lst2 (subst (cons 10 toadodiem1) lst lst1))
    (setq lts3 (reverse lst2))
    (entmod lts3)
	(if (> xdau toadox1)
	(setq cle "T")
	(setq cle "P")
	)
)
(foreach ent lsttext
  (setq o1 (entget ent))
  (setq dt (cdr(assoc 0 o1)))
(cond
    ((= dt "TEXT")
	(setq pt1 (cdr (assoc 10 o1)))
	(setq textObj (vlax-ename->vla-object ent))
	(setq pdat (append (list (car p1)) (cdr pt1)))
	(setq alignmentPoint (vlax-3d-point pdat))
    (if (= cle "T")
	(progn
	(vla-put-Alignment textObj acAlignmentLeft)
	(setq pt (vlax-variant-value (vla-get-InsertionPoint textObj)))
	(vla-move textObj pt alignmentPoint)
	)
	(progn
	(vla-put-Alignment textObj acAlignmentRight)
	(vla-put-TextAlignmentPoint textObj alignmentPoint)
	)
	)
    )
    ((= dt "MTEXT")   
    (setq pt1 (cdr (assoc 10 o1)))
	(setq textObj (vlax-ename->vla-object ent))
	(setq pdat (append (list (car p1)) (cdr pt1)))
	(setq alignmentPoint (vlax-3d-point pdat))
	(if (= cle "T")
	(progn
	(vla-put-AttachmentPoint textObj 7)
	(setq pt (vlax-variant-value (vla-get-InsertionPoint textObj)))
	(vla-move textObj pt alignmentPoint)
	)
	(progn 
	(vla-put-AttachmentPoint textObj 9)
	(setq pt (vlax-variant-value (vla-get-InsertionPoint textObj)))
	(vla-move textObj pt alignmentPoint)
	)
	)
    ) 
)
)
(setvar "osmode" occho)
(princ)
)
(defun CV:ss-to-list (ss vla / n e l)
(if ss
(progn
(setq n (sslength ss))
(while (setq e (ssname ss (setq n (1- n))))
(setq l (cons (if vla (vlax-ename->vla-object e) e) l))
)
)
)
)

;;------------------------------------------------------------------------------------------------------------------------
;;------------------------------------------------------------------------------------------------------------------------
;; --------------------------------------- [1] Align Text, Mtext to Leader  ----------------------------------------------
(vl-load-com)
(defun c:A1 (/ 
	d
	sstext
	dtype
	ent0
	tmp
	ans
	ent
	i
	n
	lst
	lst1
	lst2
	txt
	txtht
	inpt
	type
	obj
	forprinc )
	
	(defun *error* ( msg )
		(if OldOsmode (setvar 'osmode OldOsmode))
		(if (not (member msg '("Function cancelled" "quit / exit abort")))
			(princ (strcat "\nError: " msg))
		)
		(princ)
	)
	
	(checkUCS)
	(if (= 0 (getvar 'cmdecho)) (command "undo" "be") (progn (setvar 'cmdecho 0) (command "undo" "be") (setvar 'cmdecho 1)))
	(setq OldOsmode (getvar 'osmode))
	(prompt "\nCommand: First, Select a Leader (or Polyline, Line for Align Text) \n")
	(while (not (setq d (ssget "_:L+.:E:S" '((0 . "LEADER,LWPOLYLINE,LINE")))))
		(princ "\nCommand: No Leader, Polyline or Line selected, select again or <ESC> to cancel \n")
	)
	(prompt "\nCommand: Then, Select Texts to Align or <Enter> to adjust Leader only \n")
	(if (setq sstext (ssget "_:L" '((0 . "*TEXT"))))
		(princ (strcat "\nCommand: " (itoa (sslength sstext)) " Text, Mtext selected \n"))
	)
	(if (and d sstext )
		(progn 
			(setvar 'osmode 16384)
			(setq dtype (cdr (assoc 0 (entget (setq ent0 (ssname d 0))))))
			(cond
				(	(eq "LEADER" dtype)
					(entmodleader ent0)
				)
				(	(eq "LWPOLYLINE" dtype)
					(entmodpolyline ent0)
					(initget 1 "Y N")
					(if (setq tmp (getkword (strcat "\nChange to Leader ? [Yes/No] <Yes>: ")))
						(setq ans tmp)
					)
					(if (= ans "Y")
						(polylinetoleader ent0)
					)
				)
				(	(eq "LINE" dtype)
					(entmodline ent0)
					(initget 1 "Y N")
					(if (setq tmp (getkword (strcat "\nChange to Leader ? [Yes/No] <Yes>: ")))
						(setq ans tmp)
					)
					(if (= ans "Y")
						(linetoleader ent0)
					)
				)
			)
			(setq lst (LM:ss->ent sstext))
			(setq lst (mapcar '(lambda (e) (cons (cdr (assoc 10 (entget e))) (cdr (assoc -1 (entget e))))) lst))
			(setq lst1 '())
			(setq lst2 '())
			(foreach txt lst
				(if (>=  (cadr (car txt)) (cadr endpoint) )
					(setq lst1 (cons txt lst1))
					(setq lst2 (cons txt lst2))
				)
			)
			(if (< 0 (length lst1))
				(progn
					(setq lst1 (vl-sort lst1 '(lambda (p q)  (< (cadr (car p)) (cadr (car q))))))
					(setq txtht (vla-get-height (vlax-ename->vla-object (cdr (nth 0 lst1 )))))
					(setq n (length lst1) i 0)
					(while (< i n)
						(setq inpt (list (car endpoint) (+ (cadr endpoint) (* txtht (+ 0.25 (* i 1.5)) )) (caddr endpoint)))
						(setq type (cdr (assoc 0 (entget (setq ent (cdr (nth i lst1)))))))
						(setq obj (vlax-ename->vla-object ent ))
						(cond 
							(	(equal type "TEXT")
								(if (equal dir "R") (vla-put-alignment obj acalignmentbottomright) (vla-put-alignment obj acalignmentbottomleft))
								(vla-put-textalignmentpoint obj (vlax-3d-point inpt))
							)									
							(	(equal type "MTEXT")
								(if (equal dir "R") (vla-put-attachmentpoint obj acbottomright) (vla-put-attachmentpoint obj acbottomleft))
								(vla-put-insertionpoint obj (vlax-3d-point inpt))
							)
						)
						(setq i (1+ i))
					)
				)
			)
			(if (< 0 (length lst2))
				(progn
					(setq lst2 (vl-sort lst2 '(lambda (p q)  (> (cadr (car p)) (cadr (car q))))))
					(setq txtht (vla-get-height (vlax-ename->vla-object (cdr (nth 0 lst2 )))))
					(setq n (length lst2) i 0)
					(while (< i n)
						(setq inpt (list (car endpoint) (- (cadr endpoint) (* (+ 0.25 i) 1.5 txtht )) (caddr endpoint)))
						(setq type (cdr (assoc 0 (entget (setq ent (cdr (nth i lst2)))))))
						(setq obj (vlax-ename->vla-object ent ))
						(cond 
							(	(equal type "TEXT")
								(if (equal dir "R") (vla-put-alignment obj acAlignmentTopRight) (vla-put-alignment obj acAlignmentTopLeft))
								(vla-put-textalignmentpoint obj (vlax-3d-point inpt))
							)									
							(	(equal type "MTEXT")
								(if (equal dir "R") (vla-put-attachmentpoint obj acTopRight) (vla-put-attachmentpoint obj acTopLeft))
								(vla-put-insertionpoint obj (vlax-3d-point inpt))
							)
						)
						(setq i (1+ i))
					)
				)
			)
			(setvar 'osmode OldOsmode)
			(princ (strcat "\nCommand: " (itoa (sslength sstext)) " Text, Mtext aligned successfully \n"))
		)
		(progn
			(if d
				(progn
					(setq dtype (cdr (assoc 0 (entget (setq ent0 (ssname d 0))))))
					(cond
						(	(eq "LEADER" dtype)
							(entmodleader ent0)
							(setq forprinc "Leader")
						)
						(	(eq "LWPOLYLINE" dtype)
							(entmodpolyline ent0)
							(setq forprinc "Polyline")
							(initget 1 "Y N")
							(if (setq tmp (getkword (strcat "\nChange to Leader ? [Yes/No] <Yes>: ")))
								(setq ans tmp)
							) 
							(if (= ans "Y")
								(polylinetoleader ent0)
							) 
						)
						(	(eq "LINE" dtype)
							(entmodline ent0)
							(setq forprinc "Line")
							(initget 1 "Y N")
							(if (setq tmp (getkword (strcat "\nChange to Leader ? [Yes/No] <Yes>: ")))
								(setq ans tmp)
							)
							(if (= ans "Y")
								(linetoleader ent0)
							)
						)
					)
					(princ (strcat "\nCommand: No Text or Mtext selected, only perform for " forprinc " \n"))
				)
				(princ "\nCommand: No Leader selected, please select again \n")
			)
		)
	)
	(if (= 0 (getvar 'cmdecho)) (command "undo" "end") (progn (setvar 'cmdecho 0) (command "undo" "end") (setvar 'cmdecho 1)))
	(princ)
)
;; ------------------------------------ [End of 1 : Align Text, Mtext to Leader ]-------------------------------------------
;;--------------------------------------------------------------------------------------------------------------------------
;;--------------------------------------------------------------------------------------------------------------------------
;; -------------------------------------- [2] ALP - Adjust Angle of Multiple Leaders ---------------------------------------
(defun c:A2 ( /
	d
	OldOsmode
	entlst
	ent
	ed
	edrv
	endpoint
	midpt
	startpoint
	stapt
	newstapt
	newmidpt
	newm
	dir )
		
	(defun *error* ( msg )
		(if OldOsmode (setvar 'osmode OldOsmode))
		(if (not (member msg '("Function cancelled" "quit / exit abort")))
			(princ (strcat "\nError: " msg))
		)
		(princ)
	)
	
	(checkUCS)
	(if (= 0 (getvar 'cmdecho)) (command "undo" "be") (progn (setvar 'cmdecho 0) (command "undo" "be") (setvar 'cmdecho 1)))
	(setq OldOsmode (getvar 'osmode))
	(if (not lst-alv) (setting-angle))
	(prompt (strcat "\nCommand: Current angle is " alp-angle ", Select Leaders or < Enter > to change Angle \n"))
	(cond  
		(	(setq d (ssget "_:L" '((0 . "LEADER"))))
			(progn
				(setvar 'osmode 16384)
				(setq entlst (LM:ss->ent d))
				(foreach ent entlst
					(setq ed (entget ent))
					(setq edrv (reverse ed))
					(setq endpoint (cdr (assoc 10 edrv)))
					(setq midpoint (cdr (NTHASSOC 1 10 edrv)))
					(setq dir (if (minusp (- (car endpoint) (car midpoint )) ) "L" "R"))
					(if (NTHASSOC 2 10 edrv)
						(progn
							(if (not (equal (cadr endpoint) (cadr (cdr (NTHASSOC 2 10 edrv))) (if (= "Model" (getvar 'ctab)) 100.00 5.00)))
								(progn
									(setq midpt (NTHASSOC 1 10 edrv))
									(setq startpoint (cdr (NTHASSOC 2 10 edrv)))
									(cond 
										(	(and  (= dir "R") (< (cadr startpoint) (cadr endpoint)))
											(setq newmidpt  (list (findpoint (* 1 (nth 0 lst-alv)) (* 1 (nth 1 lst-alv)) startpoint endpoint ) (cadr endpoint) (caddr endpoint)))
										)
										(	(and  (= dir "R") (< (cadr endpoint) (cadr startpoint)))
											(setq newmidpt  (list (findpoint (* 1 (nth 0 lst-alv)) (* -1 (nth 1 lst-alv)) startpoint endpoint ) (cadr endpoint) (caddr endpoint)))
										)
										(	(and  (= dir "L") (< (cadr startpoint) (cadr endpoint)))
											(setq newmidpt  (list (findpoint (* -1 (nth 0 lst-alv)) (* 1 (nth 1 lst-alv)) startpoint endpoint ) (cadr endpoint) (caddr endpoint)))
										)
										(	(and  (= dir "L") (< (cadr endpoint) (cadr startpoint)))
											(setq newmidpt  (list (findpoint (* -1 (nth 0 lst-alv)) (* -1 (nth 1 lst-alv)) startpoint endpoint ) (cadr endpoint) (caddr endpoint)))
										)
									)
									(setq newm (cons 10 newmidpt))
									(setq edrv (subst newm midpt edrv))
									(setq ed (reverse edrv))
									(entmod ed)
								)
							)
						)
						(progn
							(setq startpoint (cdr (setq stapt (NTHASSOC 1 10 edrv))))
							(setq newstapt (list (car startpoint) (cadr endpoint) (caddr startpoint)))
							(setq newm (cons 10 newstapt))
							(setq edrv (subst newm stapt edrv))
							(setq ed (reverse edrv))
							(entmod ed)
						)
					)
				)
				(setvar 'osmode OldOsmode)
				(princ (strcat "\nCommand: Finished Adjustment for " (itoa (sslength d)) " Leader" (if (< 1 (sslength d)) "s" "") " \n"))
			)
		)
		(	(setting-angle) (c:ALP)
		)
	)
	(if (= 0 (getvar 'cmdecho)) (command "undo" "end") (progn (setvar 'cmdecho 0) (command "undo" "end") (setvar 'cmdecho 1)))
	(princ)
)

;; ------------------------------- [End of 2: ALP - Adjust Angle of Multiple Leaders ] -----------------------------------
;;------------------------------------------------------------------------------------------------------------------------
;;------------------------------------------------------------------------------------------------------------------------
;; ---------------------------------------- [2.1] Adjust Leader to horizontal --------------------------------------------
(defun c:A4 ( / 
	ssld
	OldOsmode
	ed
	entld
	stapt
	startpoint
	midpt
	midpoint
	newstapt )
	
	(defun *error* ( msg )
		(if OldOsmode (setvar 'osmode OldOsmode))
		(if (not (member msg '("Function cancelled" "quit / exit abort")))
			(princ (strcat "\nError: " msg))
		)
		(princ)
	)
	
	(checkUCS)
	(if (= 0 (getvar 'cmdecho)) (command "undo" "be") (progn (setvar 'cmdecho 0) (command "undo" "be") (setvar 'cmdecho 1)))
	(setq OldOsmode (getvar 'osmode))
	(princ "\nCommand: Select Leaders to Adjust \n")
	(if (setq ssld (ssget "_:L" '((0 . "LEADER"))))
		(progn
			(setvar 'osmode 16384)
			(setq entld (LM:ss->ent ssld))
			(foreach ent entld
				(setq ed (entget ent))
				(setq startpoint (cdr (setq stapt (NTHASSOC 0 10 ed))))
				(setq midpoint (cdr (setq midpt (NTHASSOC 1 10 ed))))
				(if (not (equal (car startpoint) (car midpoint) (if (= "Model" (getvar 'ctab)) 50.00 5.00)))
					(progn
						(setq newstapt (cons 10 (list (car startpoint) (cadr midpoint) (caddr midpoint) )))
						(setq ed (subst newstapt stapt ed))
						(entmod ed)
					)
				)
			)
			(setvar 'osmode OldOsmode)
			(princ "\nCommand: Finished Adjustment for Leaders \n")
		)
		(princ "\nCommand: No Leader selected ! \n")
	)
	(if (= 0 (getvar 'cmdecho)) (command "undo" "end") (progn (setvar 'cmdecho 0) (command "undo" "end") (setvar 'cmdecho 1)))
	(princ)
)
;; ------------------------------------ [End of 2.1: Adjust Leader to horizontal ] ---------------------------------------
;;------------------------------------------------------------------------------------------------------------------------
;;------------------------------------------------------------------------------------------------------------------------
;; -------------------------------------- [ List of Sub functions - do not delete ]---------------------------------------
;; ------------------------------
;; make leader landing horizontal
;; [ ld ] - leader entity name
(defun entmodleader ( ld / ed edrv endpt midpt newmidpt newm )
	(setq ed (entget ld))
	(setq edrv (reverse ed))
	(setq endpoint (cdr (setq endpt (assoc 10 edrv))))
	(setq midpoint (cdr (setq midpt (NTHASSOC 1 10 edrv))))
	(setq dir (if (minusp (- (car endpoint) (car midpoint )) ) "L" "R"))
	(setq newmidpt  (list (car midpoint) (cadr endpoint) (caddr midpoint)))
	(setq newm (cons 10 newmidpt))
	(setq edrv (subst newm midpt edrv))
	(setq ed (reverse edrv))
	(entmod ed)
)
;; --------------------------------
;; make Polyline landing horizontal
;; [ pl ] - polyline entity name
(defun entmodpolyline ( pl / ed edrv endpt midpt newmidpt newm )
	(setq ed (entget pl))
	(setq edrv (reverse ed))
	(setq endpoint (cdr (setq endpt (assoc 10 edrv))))
	(setq midpoint (cdr (setq midpt (NTHASSOC 1 10 edrv))))
	(setq dir (if (minusp (- (car endpoint) (car midpoint )) ) "L" "R"))
	(setq newmidpt  (list (car midpoint) (cadr endpoint)))
	(setq newm (cons 10 newmidpt))
	(setq edrv (subst newm midpt edrv))
	(setq ed (reverse edrv))
	(entmod ed)
	(setq endpoint (append endpoint '( 0.0 )))
)
;; -----------------------------
;; make leader from polyline
;; ByKent1Cooper
;; [ pl ] - polyline entity name
(defun polylinetoleader ( pl /)
	(setq i -1)
	(command "_.leader")
	(repeat (+ (fix (vlax-curve-getEndParam pl)) (if (vlax-curve-isClosed pl) 0 1))
		(command (vlax-curve-getPointAtParam pl (setq i (1+ i))))
	)
	(command "" "" "_none" "_.matchprop" pl (entlast) "" )
	(entdel pl)
)
;; ----------------------------
;; make line landing horizontal
;; [ li ] - line entity name
(defun entmodline ( li / ed ed endpt midpt newmidpt newm )
	(setq ed (entget li))
	(setq endpoint (cdr (setq endpt (assoc 11 ed))))
	(setq midpoint (cdr (setq midpt (assoc 10 ed))))
	(setq dir (if (minusp (- (car endpoint) (car midpoint )) ) "L" "R"))
	(setq newmidpt  (list (car midpoint) (cadr endpoint) (caddr midpoint)))
	(setq newm (cons 10 newmidpt))
	(setq ed (subst newm midpt ed))
	(entmod ed)
)
;; -------------------------
;; make leader from line
;; [ li ] - line entity name
(defun linetoleader ( li / p1 p2)
	(setq p1 (cdr(assoc 10 (entget li))))
	(setq p2 (cdr(assoc 11 (entget li))))
	(command "_.LEADER" p1 p2 "" "" "N")
	(entdel li)
)
;; -------------------------------------
;; Assoc n-th ( DCBroad 2008 )
;; [ N ] - n-th order for Assoc to a key
;; [ KEY ] - key for Assoc
;; [ LST ] - list for Assoc
(defun NTHASSOC (N KEY LST / ITEM) 
	(setq ITEM (assoc KEY LST))
	(if (<= N 0)
		ITEM
		(NTHASSOC (1- N) KEY (cdr (member ITEM LST)))
	)
)
;; ---------------------------------------------------
;; SelectionSet -> Entities
;; Author: Lee Mac, Copyright © 2011 - www.lee-mac.com
;; [ ss ] - selection set
(defun LM:ss->ent ( ss / i l )
    (if ss
        (repeat (setq i (sslength ss))
            (setq l (cons (ssname ss (setq i (1- i))) l))
        )
    )
)
;; ---------------------------------------------------
;; Popup  -  Lee Mac
(defun LM:popup ( ttl msg bit / wsh rtn )
    (if (setq wsh (vlax-create-object "wscript.shell"))
        (progn
            (setq rtn (vl-catch-all-apply 'vlax-invoke-method (list wsh 'popup msg 0 ttl bit)))
            (vlax-release-object wsh)
            (if (not (vl-catch-all-error-p rtn)) rtn)
        )
    )
)
;; ---------------------------------------------------
;; Check current coordinate
(defun checkUCS ( / strg )
	(if (zerop (getvar 'worlducs))
		(progn
			(setq strg 
				(strcat 
						"\n The current coordinate system is not WCS.    \n"
						"\n This may cause errors when using this lisp ! \n"
				)
			)
			(LM:popup "Leader & Text Suite Warning" strg (+ 0 48 4096))
		)
	)
)
;; -------------------------------------
;; find point
(defun findpoint ( m n startpt endpt / x )
	(setq a (car startpt) b (cadr startpt) y (cadr endpt))
	(setq x (+ a (/ (* m (- y b)) n)))
	x
)
;; -------------------------------------
;; find point
(defun setting-angle ( / ans )
	(if (= but nil) (setq but 1))
	(setq ans  (ah:butts but "V"  '( "Select Angle for Leader" "90" "60" "45" "30" )))
	(if ans
		(progn
			(setq ans (substr ans 1) alp-angle ans)
			(cond
				((equal ans "30") (setq lst-alv (list (sqrt 3) 1 )))
				((equal ans "45") (setq lst-alv (list 1 1 )))
				((equal ans "60") (setq lst-alv (list 1 (sqrt 3) )))
				((equal ans "90") (setq lst-alv (list 0 1 )))
				(T (exit))
			)
			
		)
	)
	(princ)
)
;;; ------------------------------------------
;;; Multi button Dialog box for a single choice repalcment of initget
;;; By Alan H Feb 2019
(defun AH:Butts (AHdef verhor butlst / fo fname x  k )

	(defun butval ( / l)
		(setq x 1)
		(repeat (length butlst)
			(setq l (strcat "Rb" (rtos x 2 0)))
			(if  (= (get_tile l) "1" )
				(setq but x)
			)
			(setq x (+ x 1))
		)
	;(princ but)
	)
	(setq fo (open (setq fname (vl-filename-mktemp "" "" ".dcl")) "w"))
	(write-line  "AHbutts : dialog 	{" fo)
	(write-line  (strcat "	label =" (chr 34) (nth 0 butlst) (chr 34) " ;" )fo)
	(write-line "	: row	{" fo)
	(if (=  (strcase verhor) "V")
		(progn
			(write-line "	: boxed_radio_column 	{" fo)
			(write-line  (strcat " width = " (rtos (+ (strlen (nth 0 butlst)) 10) 2 0) " ;")  fo)   ; increase 10 if label does not appear
		)
		(write-line "	: boxed_radio_row	{" fo)
	)
	(setq x 1)
	(repeat (- (length butlst) 1) 
		(write-line "	: radio_button	{" fo)
		(write-line  (strcat "key = "  (chr 34) "Rb" (rtos x 2 0)  (chr 34) ";") fo)
		(write-line  (strcat "label = " (chr 34) (nth x  butlst) (chr 34) ";") fo)
		(write-line "	}" fo)
		(write-line "spacer_1 ;" fo)
		(setq x (+ x 1))
	)
	(write-line "	}" fo)
	(write-line "	}" fo)
	(write-line "spacer_1 ;" fo)
	(write-line "	ok_cancel;" fo)
	(write-line "	}" fo)
	(close fo)
	(setq dcl_id (load_dialog fname))
	(if (not (new_dialog "AHbutts" dcl_id "" (cond ( *screenpoint* ) ( '(-1 -1) ))) )
		(exit)
	)
	(setq x 1)
	(repeat (- (length butlst) 1)
		(setq k (strcat "Rb" (rtos x 2 0)))
		(if (= ahdef x) (set_tile k "1"))
		(setq x (+ x 1))
	)
	(action_tile "accept" "(butval) (setq *screenpoint* (done_dialog))")
	(action_tile "cancel" "(done_dialog) (exit)")
	(start_dialog)
	(unload_dialog dcl_id)
	(vl-file-delete fname)
	(if (= but nil) (setq but 2))
	(nth but butlst)
)
;; ----------------------------------------------------- [End of List of Sub functions] ----------------------------------------------
;; ---------------------------- [ Text lines printed in Command Line when LISP loaded successfully ] ---------------------------------
;(princ 
;	(strcat 
;		"\n | \"ATL\": Align Texts, Mtexts to Leader      | \"ALP\": Adjust Angle of Multiple Leaders  | \"AHH\": Quick mirror Leaders        |\n"
;		"\n | \"ALR\": Align Leaders, Texts to Right side | \"ALL\": Align Leaders, Texts to Left side | \"AVV\": Adjust Leader to horizontal |\n"
;	)
;)
(princ)
;;; ====================================================================================================
;;; END SOURCE: B_TNT_Leader_.lsp
;;; ====================================================================================================

(defun TNT:LEADER:QLEADER (/ *error* LTARGET LOLDLAYER LOLDCMDECHO)
  (setq LTARGET "....21_TNT_N_LEADER"
        LOLDLAYER (getvar "CLAYER")
        LOLDCMDECHO (getvar "CMDECHO"))
  (defun *error* (LMSG)
    (if LOLDLAYER (setvar "CLAYER" LOLDLAYER))
    (setvar "CMDECHO" LOLDCMDECHO)
    (if (and LMSG
             (/= LMSG "Function cancelled")
             (/= LMSG "quit / exit abort"))
      (princ (strcat "\n[TNT] ERROR: QLEADER: " LMSG))
    )
    (princ)
  )
  (if (and (not (tblsearch "LAYER" LTARGET))
           (member "TNT:LAY:CREATE" (atoms-family 1)))
    (TNT:SYS:RUN-SAFE (function TNT:LAY:CREATE))
  )
  (cond
    ((not (tblsearch "LAYER" LTARGET))
      (princ (strcat "\n[TNT] CANCEL: LEADER LAYER NOT FOUND: " LTARGET))
    )
    (T
      (setvar "CMDECHO" 0)
      (setvar "CLAYER" LTARGET)
      (command "_.QLEADER")
      (while (> (getvar "CMDACTIVE") 0)
        (command pause)
      )
    )
  )
  (if LOLDLAYER (setvar "CLAYER" LOLDLAYER))
  (setvar "CMDECHO" LOLDCMDECHO)
  (princ)
)

(defun c:QLEADER (/)
  (TNT:LEADER:QLEADER)
  (princ)
)

(defun c:LE (/)
  (TNT:LEADER:QLEADER)
  (princ)
)

(defun TNT:LEADER:INSTALL-QLEADER-WRAPPER (/ LERR)
  (setq LERR
    (vl-catch-all-apply
      '(lambda ()
         (vl-cmdf "_.UNDEFINE" "QLEADER")
       )
    )
  )
  (if (vl-catch-all-error-p LERR)
    (princ (strcat "\n[TNT] SKIP: QLEADER WRAPPER INSTALL: " (vl-catch-all-error-message LERR)))
    (princ "\n[TNT] DONE: QLEADER WRAPPER INSTALLED.")
  )
  (princ)
)

(TNT:LEADER:INSTALL-QLEADER-WRAPPER)

(princ "\n[TNT] Loaded TNT_PACKAGE_07_LEADER_ALL.lsp")
(princ)
