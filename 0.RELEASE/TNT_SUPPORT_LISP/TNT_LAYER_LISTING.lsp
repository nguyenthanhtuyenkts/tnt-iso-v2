;;; ====================================================================================================
;;; TNT_LAYER_LISTING.lsp
;;; List all layer names in the current DWG to a text file.
;;; Output folder: the folder containing the current DWG.
;;; Command: TNT_LAYER_LISTING
;;; ====================================================================================================

(vl-load-com)

(defun TNT:LAYER-LISTING:DWG-DIR (/ dir)
  (setq dir (getvar "DWGPREFIX"))
  (if (and dir (/= dir ""))
    (vl-string-right-trim "\\/" dir)
    nil
  )
)

(defun TNT:LAYER-LISTING:DWG-BASE (/ base)
  (setq base (vl-filename-base (getvar "DWGNAME")))
  (if (and base (/= base ""))
    base
    "UNTITLED"
  )
)

(defun TNT:LAYER-LISTING:SAFE-NAME (name)
  (vl-string-translate "\r\n" "  " name)
)

(defun TNT:LAYER-LISTING:PATH (/ dir base)
  (setq dir  (TNT:LAYER-LISTING:DWG-DIR)
        base (TNT:LAYER-LISTING:DWG-BASE))
  (if dir
    (strcat dir "\\" base "_LAYER_LIST.txt")
    nil
  )
)

(defun TNT:LAYER-LISTING:RUN (/ acad doc layers path fh count)
  (setq path (TNT:LAYER-LISTING:PATH))
  (if path
    (progn
      (setq acad   (vlax-get-acad-object)
            doc    (vla-get-ActiveDocument acad)
            layers (vla-get-Layers doc)
            fh     (open path "w"))
      (if fh
        (progn
          (setq count 0)
          (vlax-for lay layers
            (write-line
              (TNT:LAYER-LISTING:SAFE-NAME (vla-get-Name lay))
              fh
            )
            (setq count (1+ count))
          )
          (close fh)
          (princ
            (strcat
              "\n[TNT] Da xuat "
              (itoa count)
              " layer ra file: "
              path
            )
          )
        )
        (princ (strcat "\n[TNT] Khong the ghi file: " path))
      )
    )
    (princ "\n[TNT] Hay save file CAD truoc khi xuat danh sach layer.")
  )
  (princ)
)

(defun c:TNT_LAYER_LISTING (/)
  (TNT:LAYER-LISTING:RUN)
  (princ)
)

(princ "\n[TNT] Loaded TNT_LAYER_LISTING.lsp. Lenh: TNT_LAYER_LISTING")
(princ)
