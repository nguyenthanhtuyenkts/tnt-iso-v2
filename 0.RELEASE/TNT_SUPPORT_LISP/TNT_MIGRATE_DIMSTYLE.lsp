;;; ====================================================================================================
;;; TNT_MIGRATE_DIMSTYLE.lsp
;;; Move old TNT dimension styles to current TNT ISO dimension styles.
;;; Command: TNT_MIGRATE_DIMSTYLE
;;; Mapping:
;;;   TNT_DIM  -> .TNT_A_DIM_1
;;;   TNT_DIM1 -> .TNT_A_DIM_2
;;;   TNT_DIM2 -> .TNT_A_DIM_3
;;; Also tries to delete old dimstyles after migration when AutoCAD allows it.
;;; ====================================================================================================

(vl-load-com)

(defun TNT:DIMSTYLE:MIGRATE:MAP (/)
  '(
    ("TNT_DIM"  ".TNT_A_DIM_1")
    ("TNT_DIM1" ".TNT_A_DIM_2")
    ("TNT_DIM2" ".TNT_A_DIM_3")
  )
)

(defun TNT:DIMSTYLE:MIGRATE:DOC (/)
  (vla-get-ActiveDocument (vlax-get-acad-object))
)

(defun TNT:DIMSTYLE:MIGRATE:EXISTS-P (name /)
  (if (tblsearch "DIMSTYLE" name) T nil)
)

(defun TNT:DIMSTYLE:MIGRATE:ENSURE-TARGET (name / maker)
  (cond
    ((TNT:DIMSTYLE:MIGRATE:EXISTS-P name) T)
    ((= name ".TNT_A_DIM_1")
      (setq maker (member "TNT_A_DIM_1" (atoms-family 1)))
      (if maker (progn (TNT_A_DIM_1) (TNT:DIMSTYLE:MIGRATE:EXISTS-P name)) nil)
    )
    ((= name ".TNT_A_DIM_2")
      (setq maker (member "TNT_A_DIM_2" (atoms-family 1)))
      (if maker (progn (TNT_A_DIM_2) (TNT:DIMSTYLE:MIGRATE:EXISTS-P name)) nil)
    )
    ((= name ".TNT_A_DIM_3")
      (setq maker (member "TNT_A_DIM_3" (atoms-family 1)))
      (if maker (progn (TNT_A_DIM_3) (TNT:DIMSTYLE:MIGRATE:EXISTS-P name)) nil)
    )
    (T nil)
  )
)

(defun TNT:DIMSTYLE:MIGRATE:PUT (obj newStyle / err)
  (if (and obj newStyle (TNT:DIMSTYLE:MIGRATE:EXISTS-P newStyle)
           (vlax-property-available-p obj 'StyleName T))
    (progn
      (setq err (vl-catch-all-apply 'vla-put-StyleName (list obj newStyle)))
      (if (vl-catch-all-error-p err) nil T)
    )
    nil
  )
)

(defun TNT:DIMSTYLE:MIGRATE:OBJ (obj oldStyle newStyle / style)
  (if (and obj
           (vlax-property-available-p obj 'StyleName)
           (setq style (vl-catch-all-apply 'vla-get-StyleName (list obj)))
           (not (vl-catch-all-error-p style))
           (= (strcase style) (strcase oldStyle)))
    (TNT:DIMSTYLE:MIGRATE:PUT obj newStyle)
    nil
  )
)

(defun TNT:DIMSTYLE:MIGRATE:DIRECT (oldStyle newStyle / ss i ent obj changed failed)
  (setq changed 0 failed 0)
  (setq ss (ssget "_X" (list (cons 0 "DIMENSION"))))
  (if ss
    (progn
      (setq i 0)
      (while (setq ent (ssname ss i))
        (setq obj (vlax-ename->vla-object ent))
        (if (TNT:DIMSTYLE:MIGRATE:OBJ obj oldStyle newStyle)
          (setq changed (1+ changed))
          (if (and (vlax-property-available-p obj 'StyleName)
                   (= (strcase (vla-get-StyleName obj)) (strcase oldStyle)))
            (setq failed (1+ failed))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (list changed failed)
)

(defun TNT:DIMSTYLE:MIGRATE:BLOCK-DEFS (oldStyle newStyle / doc blocks block obj objName changed failed)
  (setq doc (TNT:DIMSTYLE:MIGRATE:DOC))
  (setq blocks (vla-get-Blocks doc))
  (setq changed 0 failed 0)
  (vlax-for block blocks
    (if (and (= :vlax-false (vla-get-IsLayout block))
             (= :vlax-false (vla-get-IsXRef block)))
      (vlax-for obj block
        (setq objName (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
        (if (and (not (vl-catch-all-error-p objName))
                 (wcmatch objName "AcDb*Dimension"))
          (if (TNT:DIMSTYLE:MIGRATE:OBJ obj oldStyle newStyle)
            (setq changed (1+ changed))
            (if (and (vlax-property-available-p obj 'StyleName)
                     (= (strcase (vla-get-StyleName obj)) (strcase oldStyle)))
              (setq failed (1+ failed))
            )
          )
        )
      )
    )
  )
  (list changed failed)
)

(defun TNT:DIMSTYLE:MIGRATE:DELETE-OLD (oldStyle / doc dimstyles dimstyle err)
  (if (and (TNT:DIMSTYLE:MIGRATE:EXISTS-P oldStyle)
           (/= (strcase (getvar "DIMSTYLE")) (strcase oldStyle)))
    (progn
      (setq doc (TNT:DIMSTYLE:MIGRATE:DOC))
      (setq dimstyles (vla-get-DimStyles doc))
      (setq dimstyle (vl-catch-all-apply 'vla-Item (list dimstyles oldStyle)))
      (if (vl-catch-all-error-p dimstyle)
        nil
        (progn
          (setq err (vl-catch-all-apply 'vla-Delete (list dimstyle)))
          (if (vl-catch-all-error-p err) nil T)
        )
      )
    )
    nil
  )
)

(defun TNT:DIMSTYLE:MIGRATE:RUN (/ oldcmdecho pair oldStyle newStyle direct block
                                   changed failed skipped deleted deleteCount oldCurrent)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setq oldCurrent (getvar "DIMSTYLE"))
  (setq changed 0 failed 0 skipped 0 deleted 0 deleteCount 0)
  (setvar "CMDECHO" 0)
  (command-s "_.UNDO" "_BE")
  (foreach pair (TNT:DIMSTYLE:MIGRATE:MAP)
    (setq oldStyle (car pair))
    (setq newStyle (cadr pair))
    (if (not (TNT:DIMSTYLE:MIGRATE:ENSURE-TARGET newStyle))
      (progn
        (setq skipped (1+ skipped))
        (princ (strcat "\n[TNT] Skip " oldStyle " -> " newStyle ": target dimstyle not found."))
      )
      (progn
        (if (= (strcase (getvar "DIMSTYLE")) (strcase oldStyle))
          (command "_.DIMSTYLE" "_Restore" newStyle)
        )
        (setq direct (TNT:DIMSTYLE:MIGRATE:DIRECT oldStyle newStyle))
        (setq block  (TNT:DIMSTYLE:MIGRATE:BLOCK-DEFS oldStyle newStyle))
        (setq changed (+ changed (car direct) (car block)))
        (setq failed  (+ failed  (cadr direct) (cadr block)))
        (setq deleted (TNT:DIMSTYLE:MIGRATE:DELETE-OLD oldStyle))
        (if deleted (setq deleteCount (1+ deleteCount)))
        (princ
          (strcat
            "\n[TNT] "
            oldStyle
            " -> "
            newStyle
            ": "
            (itoa (car direct))
            " direct, "
            (itoa (car block))
            " in blocks"
            (if deleted " | old dimstyle deleted" "")
          )
        )
      )
    )
  )
  (if (and oldCurrent
           (TNT:DIMSTYLE:MIGRATE:EXISTS-P oldCurrent)
           (/= (strcase oldCurrent) (strcase (getvar "DIMSTYLE"))))
    (command "_.DIMSTYLE" "_Restore" oldCurrent)
  )
  (command-s "_.UNDO" "_END")
  (setvar "CMDECHO" oldcmdecho)
  (princ
    (strcat
      "\n[TNT] DONE DIMSTYLE MIGRATE. Changed: "
      (itoa changed)
      ". Failed: "
      (itoa failed)
      ". Skipped mappings: "
      (itoa skipped)
      ". Old dimstyles deleted: "
      (itoa deleteCount)
      "."
    )
  )
  (princ)
)

(defun c:TNT_MIGRATE_DIMSTYLE (/)
  (TNT:DIMSTYLE:MIGRATE:RUN)
)

(princ "\n[TNT] Loaded TNT_MIGRATE_DIMSTYLE.lsp. Command: TNT_MIGRATE_DIMSTYLE")
(princ)
