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

(princ "\n[TNT] Loaded TNT_PACKAGE_04_DRAW_ALL.lsp")
(princ)
