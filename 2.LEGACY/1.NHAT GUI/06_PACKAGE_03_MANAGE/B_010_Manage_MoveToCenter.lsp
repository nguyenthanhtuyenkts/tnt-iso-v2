;;; ====================================================================================================
;;; A_010_SYSTEM_PACKAGE_3
;;; ====================================================================================================
(defun c:VC (/ ss ssleng lst n center center1)
  (setvar "MODEMACRO" "010.α")
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
;;; A_010_SYSTEM_PACKAGE_3
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