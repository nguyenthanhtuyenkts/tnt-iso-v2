(defun c:dd (/ entdt diem sel temp tongdt)
  (defun ctext (diem gt / lst)
    (if	(null h_tylebv)
      (setq h_tylebv 100.0)
    )
    (if	(null h_donvimet)
      (setq h_donvimet "1")
    )
    (if	(= h_donvimet)
      (setq gt (strcat (rtos (/ gt 1000000.0) 2 2) " m2"))
    )
    (setq lst
	   (list
	     (cons 0 "TEXT")
	     (cons 1 gt)
	     (cons 10 diem)
	     (cons 40 (* h_tylebv 2.5))
	   )
    )
    (entmake lst)
  )
  (defun tinhdtHatch
	 (entdt / ttht s dt soduong theopl dau thongso thongtin)
    ;;---------------
    (defun tinhdtEl (thongtin / r tl)
      (setq r  (distance (cdr (assoc 11 thongtin)) (list 0.0 0.0 0.0))
	    tl (cdr (assoc 40 thongtin))
      )
      (* r r tl pi)
    )
    ;;---------------
    (defun tinhdtpline (thongtin / luudinh luubug s pt dinh ds)
      (defun tinhdtcung	(bug p1 p2 / R ap a s1)
	(cond
	  ((> 0.001 (abs bug)) 0.0)
	  (t
	   (progn (setq	a  (/ (distance p1 p2) 2.0)
			R  (/ (* a (+ (* bug bug) 1.0)) 2.0 bug)
			s1 (* a a (- 1.0 (* bug bug)) 0.5 (/ 1.0 bug))
		  )
		  (- (* R R 2.0 (atan bug)) s1)
	   )
	  )
	)
      )
      (setq
	luudinh	 nil
	luubug	 nil
	S	 0.0
	thongtin (append thongtin (list (assoc 10 thongtin)))
      )
      (foreach pt thongtin
	(if (= (car pt) 10)
	  (progn
	    (setq dinh (cdr pt))
	    (if	luudinh
	      (setq
		Ds (* 0.5
		      (- (car dinh) (car luudinh))
		      (+ (cadr dinh) (cadr luudinh))
		   )
		S  (+ S Ds)
	      )
	    )
	    (if	luubug
	      (progn
		(setq
		  Ds	 (TinhDTCung luubug dinh luudinh)
		  S	 (- S Ds)
		  luubug nil
		)
	      )
	    )
	    (setq luudinh dinh)
	  )
	)
	(if (= (car pt) 42)
	  (setq luubug (cdr pt))
	)
      )
      (abs S)
    )
    ;;---------------
    (defun catdoan (tt / kq index n pt)
      (setq index 0)
      (while (and (setq pt (nth index tt))
		  (/= (car pt) 92)
		  (setq index (1+ index))
	     )
	(setq kq (append kq (list pt)))
      )
      kq
    )
    ;;---------------
    (setq
      thongtin (entget entdt)
      ttht     thongtin
      soduong  (cdr (assoc 91 thongtin))
      ttht     (cdr (member (assoc 91 ttht) ttht))
      ttht     (reverse ttht)
      ttht     (cdr (member (assoc 75 ttht) ttht))
      ttht     (reverse ttht)
      dt       0.0
    )
    (repeat soduong
      (setq
	thongso	(cdr (assoc 92 ttht))
	theoPl	(cond
		  ((/= 0 (logand thongso 2)) t)
		  (t nil)
		)
	dau	(cond
		  ((/= 0 (logand thongso 16)) -1.0)
		  (t 1.0)
		)
	ttht	(cdr ttht)
	tttinh	(catdoan ttht)
	ds	(* dau
		   (cond
		     (theopl (tinhdtpline tttinh))
		     (t (tinhdtel tttinh))
		   )
		)
	dt	(+ dt ds)
	ttht	(member (assoc 92 ttht) ttht)
      )
      (princ "\n")
      (princ ds)
    )
    dt
  )
  (defun dtdoituong (entdt /)
    (if	(= "HATCH" (cdr (assoc 0 (entget entdt))))
      (tinhdtHatch entdt)
      (progn
	(command ".area" "o" entdt)
	(getvar "area")
      )
    )
  )
  (princ
    "\nChon doi tuong CIRCLE, ELLIPSE, REGION, HATCH, POLYLINE"
  )
  (setq	ssdt   (ssget '((-4 . "<OR")
			(0 . "CIRCLE")
			(0 . "ELLIPSE")
			(0 . "REGION")
			(0 . "HATCH")
			(0 . "*POLYLINE")
			(-4 . "OR>")
		       )
	       )
	sodt   (cond
		 (ssdt (sslength ssdt))
		 (t 0)
	       )
	index  0
	tongdt 0.0
  )
  (repeat sodt
    (setq
      entdt  (ssname ssdt index)
      index  (1+ index)
      tongdt (+ tongdt (dtdoituong entdt))
    )
  )
  (ctext (getpoint "\nVao diem chen") tongdt)
)