;;; ====================================================================================================
;;; TNT_PACKAGE_04_DRAW_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Draw_Rectang_Plot_VBB.lsp
;;; ====================================================================================================
(defun c:vbb (/ osm layer1 ss i blkEnt blkObj scaleX scaleY scale minPt maxPt offset pt1 pt2 existing found)
  (vl-load-com)

  ;; Lưu trạng thái
  (setq osm (getvar "osmode"))
  (setq layer1 (getvar "clayer"))

  ;; Chọn nhiều block
  (prompt "\nChọn các block khung tên: ")
  (setq ss (ssget '((0 . "INSERT"))))

  (if ss
    (progn
      ;; Tạo layer nếu chưa có
      (if (not (tblsearch "LAYER" "....11_TNT_A_PLOT"))
        (command "-LAYER" "n" "....11_TNT_A_PLOT"
                         "c" "250" "....11_TNT_A_PLOT"
                         "L" "CONTINUOUS" "....11_TNT_A_PLOT"
                         "LW" "0" "....11_TNT_A_PLOT"
                         "TR" "0" "....11_TNT_A_PLOT"
                         "P" "N" "....11_TNT_A_PLOT"
                         "")
        (setvar "clayer" "....11_TNT_A_PLOT")
      )

      ;; Duyệt từng block
      (setq i 0)
      (while (< i (sslength ss))
        (setq blkEnt (ssname ss i))
        (setq blkObj (vlax-ename->vla-object blkEnt))

        ;; Lấy scale trung bình
        (setq scaleX (vlax-get blkObj 'XScaleFactor))
        (setq scaleY (vlax-get blkObj 'YScaleFactor))
        (setq scale (/ (+ scaleX scaleY) 2.0))

        ;; Lấy bounding box
        (vla-GetBoundingBox blkObj 'minPt 'maxPt)
        (setq minPt (vlax-safearray->list minPt))
        (setq maxPt (vlax-safearray->list maxPt))

        ;; Offset vào trong
        (setq offset (* 15.0 scale))
        (setq pt1 (list (+ (car minPt) offset) (+ (cadr minPt) offset)))
        (setq pt2 (list (- (car maxPt) offset) (- (cadr maxPt) offset)))

        ;; Kiểm tra đã có RECTANG (LWPOLYLINE) nào trong vùng này chưa
        (setq existing
          (ssget "C" pt1 pt2 '((0 . "LWPOLYLINE") (8 . "....11_TNT_A_PLOT")))
        )
        (setq found nil)
        (if existing
          (repeat (sslength existing)
            (setq ent (ssname existing 0))
            ;; Có thể kiểm tra thêm chiều dài polyline để chắc chắn là khung
            (setq found T)
            (setq existing nil)
          )
        )

        ;; Nếu chưa có -> vẽ mới
        (if (not found)
          (progn
            (setvar "osmode" 0)
            (command "_.rectang" pt1 pt2)
          )
        )

        (setq i (1+ i))
      )

      ;; Trả lại trạng thái
      (setvar "clayer" layer1)
      (setvar "osmode" osm)
    )
    (prompt "\nKhông chọn block nào.")
  )
  (princ)
)



;;; ====================================================================================================
;;; END SOURCE: B_TNT_Draw_Rectang_Plot_VBB.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: C_TNT_Draw_Line_SEC_NC1.lsp
;;; ====================================================================================================
(Defun c:nc1(/ p1 p2 p3 p4 p5 p6 p11 p12 l ang)
	(setq x (getvar "osmode"))
	(setq p1 (getpoint "First point : ")
	      p2 (getpoint p1 "Second point : "))
	(setq l (distance p1 p2))
	(setq p11 (polar p1 (angle p2 p1) (/ l 5))
	      p12 (polar p2 (angle p1 p2) (/ l 5)))
	(setq ang (angle p1 p2))
	(setq p3 (polar p1 ang (/ l 2.5))
	      p4 (polar p3 (+ (/ pi 2) ang) (/ l 5))
	      p5 (polar p3 ang (/ l 5))
		p6 (polar p5 (- ang (/ pi 2)) (/ l 5)))
	(setvar "osmode" 0)
 (command "pline" p11 p3 p4 p6 p5 p12 "")
 (setvar "osmode" x)
)
;;; ====================================================================================================
;;; END SOURCE: C_TNT_Draw_Line_SEC_NC1.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: cld.lsp
;;; ====================================================================================================
;; free lisp from cadviet.com
;;; this lisp was downloaded from https://www.cadviet.com/forum/topic/41998-gi%C3%BAp-em-v%E1%BB%81-l%E1%BB%87nh-revision-cloud/
(defun C:CLD (/ aleng p1 p2 )
(setq p1 (getpoint "\nCh\U+1ECDn \U+0111i\U+1EC3m \U+0111\U+1EA7u HCN :")
     p2 (getcorner p1 "\n\U+0110i\U+1EC3m cu\U+1ED1i :")
     aleng (getdist "\nB\U+00E1n k\U+00EDnh cong :"))
(command "_.rectangle" p1 p2)
(command "_.revcloud" "_A" aleng "" "_O" (entlast) "")
(princ)
)
;;; ====================================================================================================
;;; END SOURCE: cld.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: D_TNT_Draw_Wipeout_WQ1.lsp
;;; ====================================================================================================
;;; OB2WO (gile) -Gilles Chanteau- 10/03/07
;;; Creates a "Wipeout" from an object (circle, ellipse, or polyline with arcs)
;;; Works whatever the current ucs and object OCS

(defun c:wq1 (/ ent lst nor)
  (vl-load-com)
  (if (and (setq ent (car (entsel)))
	   (member (cdr (assoc 0 (entget ent)))
		   '("CIRCLE" "ELLIPSE" "LWPOLYLINE")
	   )
	   (setq lst (ent2ptlst ent))
	   (setq nor (cdr (assoc 210 (entget ent))))
      )
    (progn
      (vla-StartundoMark
	(vla-get-ActiveDocument (vlax-get-acad-object))
      )
      (makeWipeout lst nor)
      (initget "Yes No")
      (if
	(= (getkword "\nDelete source object? [Yes/No] <No>: ")
	   "Yes"
	)
	 (entdel ent)
      )
      (vla-EndundoMark
	(vla-get-ActiveDocument (vlax-get-acad-object))
      )
    )
  )
)


;;; ENT2PTLST
;;; Returns the vertices list of the polygon figuring the curve object
;;; Coordinates defined in OCS

(defun ent2ptlst (ent / obj dist n lst p_lst prec)
  (vl-load-com)
  (if (= (type ent) 'ENAME)
    (setq obj (vlax-ename->vla-object ent))
  )
  (cond
    ((member (cdr (assoc 0 (entget ent))) '("CIRCLE" "ELLIPSE"))
     (setq dist	(/ (vlax-curve-getDistAtParam
		     obj
		     (vlax-curve-getEndParam obj)
		   )
		   50
		)
	   n	0
     )
     (repeat 50
       (setq
	 lst
	  (cons
	    (trans
	      (vlax-curve-getPointAtDist obj (* dist (setq n (1+ n))))
	      0
	      (vlax-get obj 'Normal)
	    )
	    lst
	  )
       )
     )
    )
    (T
     (setq p_lst (vl-remove-if-not
		   '(lambda (x)
		      (or (= (car x) 10)
			  (= (car x) 42)
		      )
		    )
		   (entget ent)
		 )
     )
     (while p_lst
       (setq
	 lst
	  (cons
	    (append (cdr (assoc 10 p_lst))
		    (list (cdr (assoc 38 (entget ent))))
	    )
	    lst
	  )
       )
       (if (/= 0 (cdadr p_lst))
	 (progn
	   (setq prec (1+ (fix (* 25 (sqrt (abs (cdadr p_lst))))))
		 dist (/ (- (if	(cdaddr p_lst)
			      (vlax-curve-getDistAtPoint
				obj
				(trans (cdaddr p_lst) ent 0)
			      )
			      (vlax-curve-getDistAtParam
				obj
				(vlax-curve-getEndParam obj)
			      )
			    )
			    (vlax-curve-getDistAtPoint
			      obj
			      (trans (cdar p_lst) ent 0)
			    )
			 )
			 prec
		      )
		 n    0
	   )
	   (repeat (1- prec)
	     (setq
	       lst (cons
		     (trans
		       (vlax-curve-getPointAtDist
			 obj
			 (+ (vlax-curve-getDistAtPoint
			      obj
			      (trans (cdar p_lst) ent 0)
			    )
			    (* dist (setq n (1+ n)))
			 )
		       )
		       0
		       ent
		     )
		     lst
		   )
	     )
	   )
	 )
       )
       (setq p_lst (cddr p_lst))
     )
    )
  )
  lst
)


;;; MakeWipeout creates a "wipeout" from a points list and the normal vector of the object

(defun MakeWipeout (pt_lst nor / dxf10 max_dist cen dxf_14)

  (setq	dxf10 (list (apply 'min (mapcar 'car pt_lst))
		    (apply 'min (mapcar 'cadr pt_lst))
		    (caddar pt_lst)
	      )
  )
  (setq
    max_dist
     (float
       (apply 'max
	      (mapcar '- (apply 'mapcar (cons 'max pt_lst)) dxf10)
       )
     )
  )
  (setq cen (mapcar '+ dxf10 (list (/ max_dist 2) (/ max_dist 2) 0.0)))
  (setq
    dxf14 (mapcar
	    '(lambda (p)
	       (mapcar '/
		       (mapcar '- p cen)
		       (list max_dist (- max_dist) 1.0)
	       )
	     )
	    pt_lst
	  )
  )
  (setq dxf14 (reverse (cons (car dxf14) (reverse dxf14))))
  (entmake (append (list '(0 . "WIPEOUT")
			 '(100 . "AcDbEntity")
			 '(100 . "AcDbWipeout")
			 '(90 . 0)
			 (cons 10 (trans dxf10 nor 0))
			 (cons 11 (trans (list max_dist 0.0 0.0) nor 0))
			 (cons 12 (trans (list 0.0 max_dist 0.0) nor 0))
			 '(13 1.0 1.0 0.0)
			 '(70 . 7)
			 '(280 . 1)
			 '(71 . 2)
			 (cons 91 (length dxf14))
		   )
		   (mapcar '(lambda (p) (cons 14 p)) dxf14)
	   )
  )
)
;;; ====================================================================================================
;;; END SOURCE: D_TNT_Draw_Wipeout_WQ1.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: E_TNT_Draw_RevCloud_RV.lsp
;;; ====================================================================================================

(defun C:RV ( / cmd1 )
	(setq cmd1 (getvar 'cmdecho))
	(or savedglbwidth (setparameter))
	(or setmode (setq setmode "New"))
	(initget "New Select Change")
	(if (setq tmp (getkword (strcat "\nNew RevCloud or Select existing Polyline ? [New/Select/Change] <" setmode ">: "))) (setq setmode tmp))
	(cond
		((= setmode "New") (setvar "cmdecho" 0) (newrevcloud) (setvar "cmdecho" cmd1))
		((= setmode "Select") (setvar "cmdecho" 0) (selectpolyline) (setvar "cmdecho" cmd1))
		((= setmode "Change") (setparameter) (c:RV))
	)
	(princ)
)
;;Setting parameter
(defun setparameter ( / )
	(setq 
		savedRadius (cond ((getdist (strcat "\nEnter Arc Radius: <" (rtos (setq savedRadius (cond (savedRadius) (300)))) ">: "))) (savedRadius))
		savedglbwidth (cond ((getdist (strcat "\nEnter Global Width: <" (rtos (setq savedglbwidth (cond (savedglbwidth) (30)))) ">: "))) (savedglbwidth))
	)
)
;;Draw New RevCloud case
(defun newrevcloud (/ p1 p2)
	(setq p1 (getpoint "\nPick first point of Rectangle :")
		p2 (getcorner p1 "\nPick second point of Rectangle :")
	)
	(if (and p1 p2 savedRadius savedglbwidth)
		(progn
			(command "_.rectangle" p1 p2)
			(command "_.revcloud" "_A" savedRadius "" "_O" (entlast) "")
			(command "_.pedit" (entlast) "_W" savedglbwidth "")
		)
		(princ "\n:  Command failed, try again \n")
	)
)
;;Select Polyline case
(defun selectpolyline (/ ss)
	(setq ss (ssget "_:L+.:E:S" '((0 . "*POLYLINE"))))
	(if (and ss savedRadius savedglbwidth)
		(progn
			(command "_.revcloud" "_A" savedRadius "" "_O" ss "")
			(command "_.pedit" "_last" "W" savedglbwidth "")
		)
		(princ "\n:  No Polyline Selected, try again \n")
	)
)

(princ  "\n[TNT] Command RV loaded: Draw RevCloud." )
(princ)

;; Calligraphy Style
(defun c:zz (/)
	(setq p1 (getpoint "\nPick first point of Rectangle :")
		p2 (getcorner p1 "\nPick second point of Rectangle :")
	)
	(if (and p1 p2)
		(progn
			(command "_.rectangle" p1 p2)
			(command "_.revcloud" "_Style" "_Calligraphy" "_A" 500 "" "_O" (entlast) "")
		)
	)
(princ)
)
;;; ====================================================================================================
;;; END SOURCE: E_TNT_Draw_RevCloud_RV.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: F_TNT_Draw_Area_DTM.lsp
;;; ====================================================================================================
(defun TNT:AREA:INIT (/)
  (if (null *TNT-AREA-FACTOR*) (setq *TNT-AREA-FACTOR* 1000000.0))
  (if (null *TNT-AREA-PRECISION*) (setq *TNT-AREA-PRECISION* 2))
  (if (null *TNT-AREA-LAYER*) (setq *TNT-AREA-LAYER* "....20_TNT_N_TEXT"))
  (if (null *TNT-AREA-STYLE*) (setq *TNT-AREA-STYLE* ".TNT_A_TXT_3_NOTE"))
  (princ))

(defun TNT:AREA:ENSURE-STANDARD (/)
  (cond
    ((member "TNT:LAY:CREATE" (atoms-family 1)) (TNT:LAY:CREATE))
    ((not (tblsearch "LAYER" *TNT-AREA-LAYER*))
     (command-s "_.-LAYER" "_N" *TNT-AREA-LAYER*
                "_C" "9" *TNT-AREA-LAYER*
                "_L" "CONTINUOUS" *TNT-AREA-LAYER*
                ""))
  )
  (if (and (not (tblsearch "STYLE" *TNT-AREA-STYLE*))
           (member "TNT_TEXTSTYLE_CREATE" (atoms-family 1)))
    (TNT_TEXTSTYLE_CREATE))
  (if (not (tblsearch "STYLE" *TNT-AREA-STYLE*))
    (entmake
      (list
        '(0 . "STYLE")
        '(100 . "AcDbSymbolTableRecord")
        '(100 . "AcDbTextStyleTableRecord")
        (cons 2 *TNT-AREA-STYLE*)
        '(70 . 0)
        '(40 . 0.0)
        '(41 . 0.8)
        '(50 . 0.0)
        '(71 . 0)
        '(42 . 2.5)
        '(3 . "uromans.shx")
        '(4 . ""))))
  (princ))

(defun TNT:AREA:TEXT-HEIGHT (/ v)
  (cond
    (*TNT-AREA-HEIGHT* *TNT-AREA-HEIGHT*)
    ((and (setq v (getvar "CANNOSCALEVALUE")) (> v 0.0)) (* 2.5 v))
    ((and (setq v (getvar "DIMSCALE")) (> v 0.0)) (* 2.5 v))
    (T 250.0)))

(defun TNT:AREA:FORMAT (raw / val)
  (setq val (/ (abs raw) *TNT-AREA-FACTOR*))
  (strcat (rtos val 2 *TNT-AREA-PRECISION*) " m2"))

(defun TNT:AREA:CLOSED-POLYLINE-P (ent / data typ flag)
  (setq data (entget ent)
        typ  (cdr (assoc 0 data)))
  (if (wcmatch typ "*POLYLINE")
    (progn
      (setq flag (cdr (assoc 70 data)))
      (and flag (= 1 (logand 1 flag))))
    T))

(defun TNT:AREA:OBJECT-AREA (ent / obj ret)
  (if (and ent (TNT:AREA:CLOSED-POLYLINE-P ent))
    (progn
      (setq obj (vlax-ename->vla-object ent))
      (setq ret (vl-catch-all-apply 'vlax-get (list obj 'Area)))
      (if (vl-catch-all-error-p ret)
        (progn
          (setq ret
            (vl-catch-all-apply
              '(lambda (/)
                 (command-s "_.AREA" "_Object" ent)
                 (getvar "AREA"))))
          (if (vl-catch-all-error-p ret) nil (abs ret)))
        (abs ret)))))

(defun TNT:AREA:MAKE-BOUNDARY (pt / old last ent)
  (setq old (getvar "CMDECHO")
        last (entlast))
  (setvar "CMDECHO" 0)
  (setq ent
    (vl-catch-all-apply
      '(lambda (/)
         (command-s "_.BPOLY" pt "")
         (entlast))))
  (setvar "CMDECHO" old)
  (if (or (vl-catch-all-error-p ent) (eq ent last)) nil ent))

(defun TNT:AREA:WRITE-TEXT (pt raw / layer style h txt ent)
  (setq layer (if (tblsearch "LAYER" *TNT-AREA-LAYER*) *TNT-AREA-LAYER* (getvar "CLAYER"))
        style (if (tblsearch "STYLE" *TNT-AREA-STYLE*) *TNT-AREA-STYLE* (getvar "TEXTSTYLE"))
        h     (TNT:AREA:TEXT-HEIGHT)
        txt   (TNT:AREA:FORMAT raw))
  (setq ent
    (entmakex
      (list
        '(0 . "TEXT")
        '(100 . "AcDbEntity")
        (cons 8 layer)
        '(100 . "AcDbText")
        (cons 10 pt)
        (cons 11 pt)
        (cons 40 h)
        (cons 1 txt)
        (cons 7 style)
        '(50 . 0.0)
        '(72 . 1)
        '(73 . 2))))
  (if (null ent)
    (command-s "_.TEXT" "_J" "_MC" pt h 0.0 txt))
  txt)

(defun TNT:AREA:PICK-MODE (/ pt ent raw count)
  (setq count 0)
  (while (setq pt (getpoint "\nPick point inside closed area <Enter to finish>: "))
    (setq ent (TNT:AREA:MAKE-BOUNDARY pt))
    (cond
      ((null ent)
       (prompt "\n[DTM] Boundary not found. Check for open gaps."))
      ((setq raw (TNT:AREA:OBJECT-AREA ent))
       (TNT:AREA:WRITE-TEXT pt raw)
       (entdel ent)
       (setq count (1+ count))
       (prompt (strcat "\n[DTM] " (TNT:AREA:FORMAT raw))))
      (T
       (entdel ent)
       (prompt "\n[DTM] Cannot calculate boundary area."))))
  count)

(defun TNT:AREA:SELECT-MODE (/ ss i ent raw total skipped pt)
  (prompt "\nSelect CIRCLE, ELLIPSE, REGION, HATCH, closed POLYLINE: ")
  (setq ss (ssget '((-4 . "<OR")
                    (0 . "CIRCLE")
                    (0 . "ELLIPSE")
                    (0 . "REGION")
                    (0 . "HATCH")
                    (0 . "*POLYLINE")
                    (-4 . "OR>"))))
  (if ss
    (progn
      (setq i 0 total 0.0 skipped 0)
      (repeat (sslength ss)
        (setq ent (ssname ss i)
              i   (1+ i)
              raw (TNT:AREA:OBJECT-AREA ent))
        (if raw
          (setq total (+ total raw))
          (setq skipped (1+ skipped))))
      (if (and (> total 0.0) (setq pt (getpoint "\nPick text insertion point: ")))
        (prompt (strcat "\n[DTM] Total = " (TNT:AREA:WRITE-TEXT pt total))))
      (if (> skipped 0)
        (prompt (strcat "\n[DTM] Skipped " (itoa skipped) " open/invalid object(s).")))
      total)
    (prompt "\n[DTM] Nothing selected.")))

(defun TNT:AREA:SETTINGS (/ v)
  (prompt (strcat "\nCurrent factor: raw/" (rtos *TNT-AREA-FACTOR* 2 0)
                  ", precision: " (itoa *TNT-AREA-PRECISION*)
                  ", text height: "
                  (if *TNT-AREA-HEIGHT* (rtos *TNT-AREA-HEIGHT* 2 2) "auto")))
  (if (setq v (getreal "\nArea factor denominator <1000000 for mm2 to m2>: "))
    (if (> v 0.0) (setq *TNT-AREA-FACTOR* v)))
  (if (setq v (getint "\nDecimal precision <2>: "))
    (if (>= v 0) (setq *TNT-AREA-PRECISION* v)))
  (if (setq v (getreal "\nText height, 0 for auto: "))
    (setq *TNT-AREA-HEIGHT* (if (> v 0.0) v nil)))
  (princ))

(defun TNT:AREA:RUN (/ *error* oldcmdecho oldosmode oldclayer mode)
  (vl-load-com)
  (TNT:AREA:INIT)
  (setq oldcmdecho (getvar "CMDECHO")
        oldosmode  (getvar "OSMODE")
        oldclayer  (getvar "CLAYER"))
  (defun *error* (msg)
    (if oldcmdecho (setvar "CMDECHO" oldcmdecho))
    (if oldosmode (setvar "OSMODE" oldosmode))
    (if oldclayer (setvar "CLAYER" oldclayer))
    (command-s "_.UNDO" "_End")
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*")))
      (prompt (strcat "\n[DTM] Error: " msg)))
    (princ))
  (setvar "CMDECHO" 0)
  (command-s "_.UNDO" "_Begin")
  (TNT:AREA:ENSURE-STANDARD)
  (initget "Pick Select Settings")
  (setq mode (getkword "\nArea mode [Pick/Select/Settings] <Pick>: "))
  (cond
    ((= mode "Select") (TNT:AREA:SELECT-MODE))
    ((= mode "Settings") (TNT:AREA:SETTINGS))
    (T (TNT:AREA:PICK-MODE)))
  (setvar "CMDECHO" oldcmdecho)
  (setvar "OSMODE" oldosmode)
  (setvar "CLAYER" oldclayer)
  (command-s "_.UNDO" "_End")
  (princ))

(defun c:DTM () (TNT:AREA:RUN))

;;; ====================================================================================================
;;; END SOURCE: F_TNT_Draw_Area_DTM.lsp
;;; ====================================================================================================

(princ "\n[TNT] Loaded TNT_PACKAGE_04_DRAW_ALL.lsp")
(princ)
