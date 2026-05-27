;;;;;;;;;;;;;;
  (defun TT:ListBoundingBox (lst / ll ur bb) ;LST danh sach VLA object
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
;;;;;;;;;;;;;;;
    (defun c:VC (/ ss ssleng lst n center center1)
      (setvar "MODEMACRO" "010 Architec")
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
      
      (setq	center (polar
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
;;;;;;;;;;;;;;;;;;;;;;  
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
;;;;;;;;;;;;;;;;;;;
  (defun find-closed-entity (point / ent)
    (setq ent (car (nentsel point)))
    (if (and ent (vlax-curve-isClosed (vlax-ename->vla-object ent)))
      ent
      nil
    )
  )
;;;;;;;;;;;;;;;
  (defun c:VC1 (/ obj e pt LST p1 p2 dt pt1) 
    (setq osm (getvar "osmode"))
    (while (/= nil)    
    (progn
    (setq obj (ssget))
    (setq LST (ACET-GEOM-SS-EXTENTS-FAST obj))
    (setq p1 (car LST))
    (setq p2 (cadr LST))
    (setq dt (distance p1 p2))
    (setq pt1 (polar p1 (+ (angle p1 p2)) (/ dt 2)))
    (setq p (getpoint "pick diem trong vung dich chuyen :"))
    (command "hpislanddetectionmode" 0 "")
    (command "._boundary" "A" "O" "R" "" p "")
    (setq e (entlast))
    (setq pt (car (boundingbox e)))
    (command "_.erase" e "")
    (setvar "osmode" 16384)
    (command ".MOVE" obj "" pt1 pt)
    (setvar "osmode" osm)
    (princ))
    )
  )
;;;;;;;;;;;;;;;;;
  (defun boundingbox (ent / a b lst lst1)
  (if
  (and
  (vlax-method-applicable-p (vlax-ename->vla-object ent) 'getboundingbox)
  (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-getboundingbox (list (vlax-ename->vla-object ent) 'a 'b))))
  (setq lst (mapcar 'vlax-safearray->list (list a b)))
  )
  (setq lst1 (mapcar '(lambda ( a ) (mapcar '(lambda ( b ) ((eval b) lst)) a))
  '((caar cadar) (caadr cadar) (caadr cadadr) (caar cadadr))
  )
  lst1 (append (list (list (/ (+ (car (car lst1)) (car (caddr lst1))) 2.) (/ (+ (cadr (car lst1)) (cadr (caddr lst1))) 2.))) lst1)
  )
  )
  )