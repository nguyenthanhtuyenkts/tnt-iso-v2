(defun C:M2C (/)
	(princ "\nMove doi tuong vao giua vung kin - from lisp.vn")
	(vl-load-com) ; Tải các hàm ActiveX để sử dụng
	(defun sleep_osnap ()(setvar "OSMODE" (logior (getvar "OSMODE") 16384)))
	(defun wake_osnap ()(setvar "OSMODE" (logand (getvar "OSMODE") -16385)))
	(sleep_osnap)
	
	(princ "\nChọn đối tượng thứ nhất: ")
	(setq ent1 (ssget)) ; Chọn một đối tượng duy nhất
	(if ent1
		(progn
			(princ "\nChọn đối tượng thứ hai: ")
			(setq pt (getpoint "\nChọn tâm vùng kín cần chèn: ")) ; Chọn đối tượng thứ hai
			(if pt
				(progn
					; Lấy thực thể từ tập hợp lựa chọn
					;(setq ent1 (ssname ent1 0))
					;(setq obj1 (vlax-ename->vla-object ent1))

					; Lấy điểm tham chiếu của hai đối tượng
					(setq pt1 (GetGeometricCenter ent1))
					(setq pt2 (getCentroid pt))

					; Di chuyển đối tượng thứ nhất đến vị trí của đối tượng thứ hai
					(command "_.MOVE" ent1 "" pt1 pt2)
					; Di chuyển đối tượng thứ hai đến vị trí của đối tượng thứ nhất
					;(command "_.MOVE" ent2 "" pt2 pt1)
					(princ "\nĐã hoán đổi vị trí hai đối tượng!")
				)
				(princ "\nKhông chọn được đối tượng thứ hai!")
			)
		)
		(princ "\nKhông chọn được đối tượng thứ nhất!")
	)
	(wake_osnap)
	(princ "\nBy AJS at www.lisp.vn")
	(princ)
)
(defun GetGeometricCenter (ss / i ent minpt maxpt xsum ysum zsum pt cnt)
  ;; Initialize variables
  (setq xsum 0.0 ysum 0.0 zsum 0.0 cnt 0)
  
  ;; Loop through all objects in the selection set
  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        ;; Get the bounding box of the entity
        (command "._UCS" "_World")
        (vla-getboundingbox (vlax-ename->vla-object ent) 'minpt 'maxpt)
        (setq minpt (vlax-safearray->list minpt)
              maxpt (vlax-safearray->list maxpt))
        ;; Calculate the center of the bounding box
        (setq xsum (+ xsum (/ (+ (car minpt) (car maxpt)) 2.0))
              ysum (+ ysum (/ (+ (cadr minpt) (cadr maxpt)) 2.0))
              cnt (1+ cnt))
        (setq i (1+ i))
      )
      ;; Calculate the average to find the geometric center
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
; Hàm lấy điểm tham chiếu của đối tượng
(defun get-reference-point (obj / minpt maxpt midpt)
	(cond
		((vlax-property-available-p obj 'Centroid) ; Nếu có Centroid
		(vlax-get obj 'Centroid))
		((vlax-property-available-p obj 'InsertionPoint) ; Nếu có InsertionPoint
		(vlax-get obj 'InsertionPoint))
		((vlax-property-available-p obj 'StartPoint) ; Nếu là đường thẳng/cung
		(setq midpt (mapcar '(lambda (x y) (/ (+ x y) 2.0))
		(vlax-get obj 'StartPoint)
		(vlax-get obj 'EndPoint)))
		midpt)
		(t ; Nếu không có điểm đặc trưng, lấy tâm của bounding box
		(vla-getboundingbox obj 'minpt 'maxpt)
		(mapcar '(lambda (x y) (/ (+ x y) 2.0))
		(vlax-safearray->list minpt)
		(vlax-safearray->list maxpt)))
	)
)
(defun C:M2C1 (/)
	(princ "\nMove doi tuong vao giua doi tuong thu 2 - from lisp.vn")
	(vl-load-com) ; Tải các hàm ActiveX để sử dụng
	(defun sleep_osnap ()(setvar "OSMODE" (logior (getvar "OSMODE") 16384)))
	(defun wake_osnap ()(setvar "OSMODE" (logand (getvar "OSMODE") -16385)))
	(sleep_osnap)
	
	(princ "\nChọn đối tượng thứ nhất: ")
	(setq ent1 (ssget ":S")) ; Chọn một đối tượng duy nhất
	(if ent1
		(progn
			(princ "\nChọn đối tượng thứ hai: ")
			(setq ent2 (ssget ":S")) ; Chọn đối tượng thứ hai
			(if ent2
				(progn
					
					; Lấy thực thể từ tập hợp lựa chọn
					(setq ent1 (ssname ent1 0))
					(setq ent2 (ssname ent2 0))
					(setq obj1 (vlax-ename->vla-object ent1))
					(setq obj2 (vlax-ename->vla-object ent2))

					; Hàm lấy điểm tham chiếu của đối tượng
					(defun get-reference-point (obj / minpt maxpt midpt)
						(cond
							((vlax-property-available-p obj 'Centroid) ; Nếu có Centroid
							(vlax-get obj 'Centroid))
							((vlax-property-available-p obj 'InsertionPoint) ; Nếu có InsertionPoint
							(vlax-get obj 'InsertionPoint))
							((vlax-property-available-p obj 'StartPoint) ; Nếu là đường thẳng/cung
							(setq midpt (mapcar '(lambda (x y) (/ (+ x y) 2.0))
							(vlax-get obj 'StartPoint)
							(vlax-get obj 'EndPoint)))
							midpt)
							(t ; Nếu không có điểm đặc trưng, lấy tâm của bounding box
							(vla-getboundingbox obj 'minpt 'maxpt)
							(mapcar '(lambda (x y) (/ (+ x y) 2.0))
							(vlax-safearray->list minpt)
							(vlax-safearray->list maxpt)))
						)
					)

					; Lấy điểm tham chiếu của hai đối tượng
					(setq pt1 (get-reference-point obj1))
					(setq pt2 (get-reference-point obj2))

					; Di chuyển đối tượng thứ nhất đến vị trí của đối tượng thứ hai
					(command "_.MOVE" ent1 "" pt1 pt2)
					; Di chuyển đối tượng thứ hai đến vị trí của đối tượng thứ nhất
					;(command "_.MOVE" ent2 "" pt2 pt1)
					(princ "\nĐã hoán đổi vị trí hai đối tượng!")
				)
				(princ "\nKhông chọn được đối tượng thứ hai!")
			)
		)
		(princ "\nKhông chọn được đối tượng thứ nhất!")
	)
	(wake_osnap)
	(princ "\nBy AJS at www.lisp.vn")
	(princ)
)