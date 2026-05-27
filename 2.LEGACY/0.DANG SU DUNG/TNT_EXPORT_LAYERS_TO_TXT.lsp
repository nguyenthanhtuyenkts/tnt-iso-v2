;;; ====================================================================================================
;;; TNT_EXPORT_LAYERS_TO_TXT.lsp
;;; Export all layers in the current DWG to a tab-delimited text file.
;;; Output folder: the folder containing this Lisp file; fallback to DWGPREFIX.
;;; Command: TNT_EXPORT_LAYERS
;;; ====================================================================================================

(vl-load-com)

(defun TNT:EXPORT-LAYERS:STR (value / result)
  (setq result
    (cond
      ((null value) "")
      ((= (type value) 'STR) value)
      ((= (type value) 'INT) (itoa value))
      ((= (type value) 'REAL) (rtos value 2 6))
      ((= (type value) 'SYM) (vl-symbol-name value))
      (T (vl-princ-to-string value))
    )
  )
  (vl-string-translate "\t\r\n" "   " result)
)

(defun TNT:EXPORT-LAYERS:YESNO (value)
  (if value "YES" "NO")
)

(defun TNT:EXPORT-LAYERS:SAFE-GET (obj prop / result)
  (setq result (vl-catch-all-apply 'vlax-get-property (list obj prop)))
  (if (vl-catch-all-error-p result) nil result)
)

(defun TNT:EXPORT-LAYERS:BOOL-PROP (obj prop / value)
  (setq value (TNT:EXPORT-LAYERS:SAFE-GET obj prop))
  (TNT:EXPORT-LAYERS:YESNO
    (and value
         (not (= value :vlax-false))
         (not (= value 0))
    )
  )
)

(defun TNT:EXPORT-LAYERS:BASE-DIR (/ p)
  (setq p
    (cond
      ((and (boundp '*load-truename*) (= (type *load-truename*) 'STR))
       (vl-filename-directory *load-truename*))
      ((and (getvar "DWGPREFIX") (/= (getvar "DWGPREFIX") ""))
       (vl-string-right-trim "\\/" (getvar "DWGPREFIX")))
      (T (getvar "TEMPPREFIX"))
    )
  )
  p
)

(defun TNT:EXPORT-LAYERS:DWG-BASE (/ name base)
  (setq name (getvar "DWGNAME"))
  (setq base (vl-filename-base name))
  (if (and base (/= base ""))
    base
    "UNTITLED"
  )
)

(defun TNT:EXPORT-LAYERS:PATH (/ dir base)
  (setq dir  (TNT:EXPORT-LAYERS:BASE-DIR))
  (setq base (TNT:EXPORT-LAYERS:DWG-BASE))
  (strcat dir "\\TNT_LAYER_EXPORT_" base ".txt")
)

(defun TNT:EXPORT-LAYERS:WRITE-ONE (fh lay / fields)
  (setq fields
    (list
      (TNT:EXPORT-LAYERS:SAFE-GET lay 'Name)
      (TNT:EXPORT-LAYERS:SAFE-GET lay 'Color)
      (TNT:EXPORT-LAYERS:SAFE-GET lay 'Linetype)
      (TNT:EXPORT-LAYERS:SAFE-GET lay 'Lineweight)
      (TNT:EXPORT-LAYERS:BOOL-PROP lay 'LayerOn)
      (TNT:EXPORT-LAYERS:BOOL-PROP lay 'Freeze)
      (TNT:EXPORT-LAYERS:BOOL-PROP lay 'Lock)
      (TNT:EXPORT-LAYERS:BOOL-PROP lay 'Plottable)
      (TNT:EXPORT-LAYERS:SAFE-GET lay 'PlotStyleName)
      (TNT:EXPORT-LAYERS:SAFE-GET lay 'Description)
    )
  )
  (write-line
    (apply 'strcat
      (cons
        (TNT:EXPORT-LAYERS:STR (car fields))
        (mapcar
          '(lambda (x) (strcat "\t" (TNT:EXPORT-LAYERS:STR x)))
          (cdr fields)
        )
      )
    )
    fh
  )
)

(defun TNT:EXPORT-LAYERS:RUN (/ acad doc layers path fh count)
  (setq acad   (vlax-get-acad-object))
  (setq doc    (vla-get-ActiveDocument acad))
  (setq layers (vla-get-Layers doc))
  (setq path   (TNT:EXPORT-LAYERS:PATH))
  (setq fh     (open path "w"))

  (if fh
    (progn
      (write-line "Layer\tColor\tLinetype\tLineweight\tOn\tFrozen\tLocked\tPlottable\tPlotStyle\tDescription" fh)
      (setq count 0)
      (vlax-for lay layers
        (TNT:EXPORT-LAYERS:WRITE-ONE fh lay)
        (setq count (1+ count))
      )
      (close fh)
      (princ (strcat "\n[TNT] Exported " (itoa count) " layers to: " path))
    )
    (princ (strcat "\n[TNT] Cannot write layer export file: " path))
  )
  (princ)
)

(defun c:TNT_EXPORT_LAYERS (/)
  (TNT:EXPORT-LAYERS:RUN)
  (princ)
)

(princ "\n[TNT] Loaded TNT_EXPORT_LAYERS_TO_TXT.lsp. Command: TNT_EXPORT_LAYERS")
(princ)
