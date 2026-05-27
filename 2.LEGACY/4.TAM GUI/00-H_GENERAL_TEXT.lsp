(defun c:T1 (/ source target itarget str)
  (setvar "MODEMACRO" "010 Architec")
	(command "undo" "be") 
	(prompt "\nSelect *TEXT, DIMENSION source:")
	(setq source (ssget "+.:S:N" '((0 . "*TEXT,DIMENSION"))))
		(if (and
      source
      (setq source (ssname source 0))
      (setq str (cdr (assoc 1 (entget source))))     
      (progn (prompt "\nSelect *TEXT, DIMENSION Target:") T)     
      (setq target (ssget '((0 . "*TEXT,DIMENSION"))))
      )
			  (progn
			    (setq i 0)
			    (while (setq itarget (ssname target i))
			         (entmod (subst  (cons 1 str) (assoc 1 (entget itarget)) (entget itarget)))
		           (setq i (1+ i))      
		    )   
	    (command "undo" "end")
	    (redraw)
		)
	)
)
(defun c:T9 ( / ent enx )
   (if (and (setq ent (car (entsel)))
            (= "INSERT" (cdr (assoc 0 (setq enx (entget ent)))))
            (= 1 (cdr (assoc 66 enx)))
            (setq ent (entnext ent)
                  enx (entget  ent)
            )
       )
       (while (= "ATTRIB" (cdr (assoc 0 enx)))
           (entmod (subst (cons 1 (strcase (cdr (assoc 1 enx)))) (assoc 1 enx) enx))
           (setq ent (entnext ent)
                 enx (entget  ent)
           )
       )
       (princ "\nNo object selected or selected object is not a block.")
   )
   (princ)
)
; TCASE
(defun c:tcase ( / lst )
 (acet-error-init (list '("cmdecho" 0) T))
 (if (setq lst (acet-tcase-ui nil))
     (acet-tcase (car lst) (cadr lst))
 );if
 (acet-error-restore)
);defun c:tcase 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:T2 ( / lst )
 (acet-error-init (list '("cmdecho" 0) T))
 (if (setq lst (acet-tcase-ui T))
     (acet-tcase (car lst) (cadr lst))
 );if
 (acet-error-restore)
);defun c:-tcase 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;If the cmdline arg is true then command will be command line line driven.
;
(defun acet-tcase-ui ( cmdline / flt ss lst )
 (setq flt '((-4 . "<OR") 
              (0 . "TEXT")
              (0 . "ATTDEF")
              (0 . "MTEXT")
              (0 . "DIMENSION")
              (0 . "RTEXT")
              (0 . "ARCALIGNEDTEXT")
              (-4 . "<AND") (0 . "INSERT") (66 . 1) (-4 . "AND>")
             (-4 . "OR>")
            )
 );setq
 (if (setq ss (ssget "_:L" flt))
     (progn
      (if (or cmdline
              (= 4 (logand 4 (getvar "cmdactive")))
              (= 0 (getvar "cmddia"))
          );or
          (setq lst (acet-tcase-ui-cmd))
          (setq lst (acet-tcase-ui-dlg))
      );if
      (if lst
          (setq lst (cons ss lst))
      );if
     );progn then
 );if
 lst
);defun tcase-ui 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-tcase-ui-cmd ( / ans def lst )
 
 (setq def (acet-getvar '("ACET-TCASE-MODE")))
 (if (not def)
     (setq def "Upper")
 );if
 (initget "Sentence Lower Upper Title toGgle")
 (setq ans (getkword 
            (acet-str-format "\nSelect case [Sentence/Lower/Upper/Title/toGgle] <%1>: "
                             def
            )
           );getkword
 );setq
 (if (not ans)
     (setq ans def)
 );if
 (acet-setvar (list "ACET-TCASE-MODE" ans 3)) ;; store it in the drawing and in the profile 
 (list ans)
);defun acet-tcase-ui-cmd 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;acet-tcase-dlg
;returns one of the following strings if OK is pressed:
;"Sentence Lower Upper Title toGgle"
;Returns nil on cancel
;
(defun acet-tcase-ui-dlg ( / iv flag set_bit mode lst ) 
 (if (> (setq iv (load_dialog (getfileET "tcase.dcl")));setq
        0
     );test
     (progn
      (if (new_dialog "tcase" iv)
          (progn
           (setq mode (acet-getvar '("ACET-TCASE-MODE")))
           (if (not mode)
               (setq mode "UPPER")
               (setq mode (xstrcase mode))
           );if
 
           (cond
            ((= mode "UPPER")
             (set_tile "upper" "1")
            );cond #1
            ((= mode "LOWER")
             (set_tile "lower" "1")
            );cond #2
            ((= mode "SENTENCE")
             (set_tile "sentence" "1")
            );cond #3
            ((= mode "TITLE")
             (set_tile "title" "1")
            );cond #4
            ((= mode "TOGGLE")
             (set_tile "toggle" "1")
            );cond #5
           );cond close
         
           (action_tile "upper"    "(setq mode \"upper\")")
           (action_tile "lower"    "(setq mode \"lower\")")
           (action_tile "sentence" "(setq mode \"sentence\")")
           (action_tile "title"    "(setq mode \"title\")")
           (action_tile "toggle"   "(setq mode \"toggle\")")
   
           (action_tile "accept" "(done_dialog 1)")
           (action_tile "cancel" "(done_dialog 0)")
           (action_tile "help" "(acet-help \"TCASE\")")
 
           (setq flag (start_dialog));setq
           (if (equal flag 1)
               (progn
                (acet-setvar (list "ACET-TCASE-MODE" (xstrcase mode) 3))
                (setq lst (list mode));setq
               );progn
               (setq mode nil)
           );if
          );progn then initialize the tiles and activate the dialog box
          (alert "Unable to display dialog box")
      );if new dialog
      (unload_dialog iv);unload it when done
     );progn then
     (alert "Unable to load dialog box");else
 );if load
 lst
);defun acet-tcase-ui-dlg 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun acet-tcase ( ss mode / na e1 n x tp e2 flag frmt a )
 (setq n 0)
 (repeat (sslength ss)
  (setq na (ssname ss n)
        e1 (entget na)
  );setq
  (if (= 1 (cdr (assoc 66 e1)))
      (setq flag T)
      (setq flag nil)
  );if
  (while e1
   (setq tp (cdr (assoc 0 e1)))
   (cond
    ((or (= tp "TEXT")
         (= tp "ATTDEF")
         (= tp "ATTRIB")
         (= tp "ARCALIGNEDTEXT")
         (= tp "DIMENSION")
         (= tp "RTEXT")
     );or
        (setq e2 nil)
        (if (and (or (= tp "ATTDEF") (= tp "ATTRIB"))
                 (_matts_util na)
            )
           (progn
                ; Special case handling for multiline text attributes
                (setq x (_matts_util na 2))
                (if (= (type x) 'LIST)
                    (progn
                         (setq x (car x))
                         (setq a (cdr x))
                         (setq frmt (acet-mtext-format-extract a)
                               a (car frmt)
                               frmt (cadr frmt)
                         );setq
                         (setq a (acet-tcase-change-string a mode)
                              a (acet-mtext-format-apply a frmt)
                         );setq
                         (setq x (cons (car x) a))
                         (_matts_util na 3 x)
                    )
                )
           )
           (progn
              ; Process single line attributes using entmod
              (foreach x e1
                (if (or (= (car x) 1)
                        (= (car x) 3)
                    );or
                    (setq x (cons (car x) 
                                  (acet-tcase-change-string (cdr x) mode)
                            );cons
                     );setq then modify the case
                );if
                (setq e2 (cons x e2))
              );foreach
              (entmod (reverse e2))
           )
        );if ATTDEF/ATTRIB & multiline
    );cond #1
    ((= tp "MTEXT")
	;; first get the entire string 
        ;; then strip formatting and apply case changes
        ;; re-apply formating
        ;; place string back into elist and entmod
  
        (setq a "")
        (foreach x e1
         (if (or (= (car x) 1)
                 (= (car x) 3)
             );or
             (setq a (strcat a (cdr x)));setq then
         );if
        );foreach
        (setq frmt (acet-mtext-format-extract a)
                 a (car frmt)
              frmt (cadr frmt)
        );setq
        (setq a (acet-tcase-change-string a mode)
              a (acet-mtext-format-apply a frmt)
        );setq
        
        (setq e2 nil)
        (foreach x e1
         (if (or (= (car x) 1)
                 (= (car x) 3)
             );or
             (setq x (cons (car x) 
                           (substr a 1 (strlen (cdr x)))
                     );cons
                   a (substr a (+ (strlen (cdr x)) 1))
             );setq then 
         );if
         (setq e2 (cons x e2))
        );foreach
        (entmod (reverse e2))
    );cond #2
   );cond close
   (if flag
       (progn
        (if (= tp "SEQEND")
            (progn
             (entmod e1)
             (entmod (entget (ssname ss n)))
             (entupd (ssname ss n))
             (setq e1 nil)
            );progn then
            (progn
             (if (setq na (entnext na))
                 (setq e1 (entget na))
             );if 
            );progn
        );if
       );progn then
       (setq e1 nil)
   );if
  );while
  (setq n (+ n 1));setq
 );repeat
 
);defun tcase
(acet-autoload2	'("tcaseSup.lsp"	(acet-mtext-format-apply str flst)))
(acet-autoload2	'("tcaseSup.lsp"	(acet-mtext-format-extract str)))
(acet-autoload2	'("tcaseSup.lsp"	(acet-tcase-change-string a mode)))
(princ)
