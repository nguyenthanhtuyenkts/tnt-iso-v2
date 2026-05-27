
(defun c:MAB (/ *error* blk f ss temp sx sy sz rot)
  (vl-load-com)

  (defun *error* (msg)
    (and f *AcadDoc* (vla-endundomark *AcadDoc*))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*,")))
      (princ (strcat "\nError: " msg))
    )
  )

  (if
    (and
      (AT:GetSel
        entsel
        "\nSelect replacement block: "
        (lambda (x / e)
          (if
            (and
              (eq "INSERT" (cdr (assoc 0 (setq e (entget (car x))))))
              (/= 4 (logand (cdr (assoc 70 (tblsearch "BLOCK" (cdr (assoc 2 e))))) 4))
              (/= 4 (logand (cdr (assoc 70 (entget (tblobjname "LAYER" (cdr (assoc 8 e)))))) 4))
            )
            (progn
              (setq blk (vlax-ename->vla-object (car x)))
              ;; Lấy scale và rotation từ block mẫu
              (setq sx (vlax-get blk 'XEffectiveScaleFactor))
              (setq sy (vlax-get blk 'YEffectiveScaleFactor))
              (setq sz (vlax-get blk 'ZEffectiveScaleFactor))
              (setq rot (vlax-get blk 'Rotation))
            )
          )
        )
      )
      (princ "\nSelect blocks to be repalced: ")
      (setq ss (ssget "_:L" '((0 . "INSERT"))))
    )
    (progn
      (setq f (not (vla-startundomark
        (cond (*AcadDoc*)
              ((setq *AcadDoc* (vla-get-activedocument (vlax-get-acad-object))))
        )
      )))

      (vlax-for x (setq ss (vla-get-activeselectionset *AcadDoc*))
        (setq temp (vla-copy blk))
        (mapcar
          (function (lambda (p val)
            (vl-catch-all-apply
              (function vlax-put-property)
              (list temp p val)
            )
          ))
          '(InsertionPoint Rotation XEffectiveScaleFactor YEffectiveScaleFactor ZEffectiveScaleFactor)
          (list
            (vlax-get-property x 'InsertionPoint)
            rot ; <--- sử dụng rotation từ block mẫu
            sx sy sz ; <--- scale từ block mẫu
          )
        )
        (vla-delete x)
      )

      (vla-delete ss)
      (*error* nil)
    )
  )
  (princ)
)

(defun AT:GetSel (meth msg fnc / ent good)
  ;; meth - selection method (entsel, nentsel, nentselp)
  ;; msg - message to display (nil for default)
  ;; fnc - optional function to apply to selected object
  ;; Alan J. Thompson, 05.25.10
  (setvar 'errno 0)
  (while (not good)
    (setq ent (meth (cond (msg) ("\nSelect object: "))))
    (cond
      ((vl-consp ent)
        (setq good (cond ((or (not fnc) (fnc ent)) ent)
                         ((prompt "\nInvalid object!")))))
      ((eq (type ent) 'STR) (setq good ent))
      ((setq good (eq 52 (getvar 'errno))) nil)
      ((eq 7 (getvar 'errno)) (setq good (prompt "\nMissed, try again.")))
    )
  )
)
