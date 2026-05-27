
; Cho ACAD R.14
; Nen dat mot LAYER moi co mau de nhan
;
(defun C:ae(/ N SS1 NUM EN )
  (if (not "acadapp.exp") (xload "acadapp.exp"))
  (setq N 0)
  (setq SS1 (ssadd))
  (command "layer" "s" DiTi "")
  (while (setq PT1 (getpoint "\n Chon diem trong vung can tinh dien tich:"))
  (setq inra pt1)
  (command "BPOLY" PT1 "")
     (setq SS1 (ssadd (entlast) SS1))
  );while

  (setq NUM (sslength SS1))
  (command ".area" "a" "e")
  (while (/= NUM N)
     (setq EN (ssname SS1 N))
     (command EN)
     (setq N (1+ N))
  );while
  (command "" "")
 ; (command "erase" SS1 "")
  (command "redraw")
  (setq SS nil)
 ; (command "textscr")
  (prin1)
  (setq val (* 1 (getvar "area")))
  (princ "Gia tri la : ")
  (princ val)
  (prin1)
  (command "TEXT" inra  "" "" (rtos val 2))

);end autoarea.lsp