;;; TNT_BRICSCAD_LOAD.lsp
;;; BricsCAD source loader. Use this file instead of TNT_TOOL_IN HANG LOAT.VLX.

(vl-load-com)

(defun TNT:BCAD:ROOT (/ source)
  (setq source
    (cond
      ((findfile "TNT_BRICSCAD_LOAD.lsp"))
      ((and (boundp '*load-truename*) (= (type *load-truename*) 'STR))
       *load-truename*)
      ((findfile "D:/0.TNT ISO 2026/3.RELEASE-TEST/TNT_PACKAGE_00_SYSTEM_ALL.lsp")
       "D:/0.TNT ISO 2026/3.RELEASE-TEST/TNT_BRICSCAD_LOAD.lsp")
      (T nil)))
  (if source (vl-filename-directory source) nil)
)

(defun TNT:BCAD:LOAD-ONE (root relative / path result)
  (setq path (strcat (vl-string-right-trim "\\/" root) "\\" relative))
  (if (findfile path)
    (progn
      (setq result (vl-catch-all-apply 'load (list path)))
      (if (vl-catch-all-error-p result)
        (progn
          (princ (strcat "\n[TNT] ERROR loading " relative ": "
                         (vl-catch-all-error-message result)))
          nil)
        (progn (princ (strcat "\n[TNT] OK: " relative)) T)))
    (progn (princ (strcat "\n[TNT] MISSING: " path)) nil))
)

(defun C:TNT_BRICSCAD_LOAD (/ root files loaded failed item)
  (setq root (TNT:BCAD:ROOT)
        files
        '("TNT_PACKAGE_00_SYSTEM_ALL.lsp"
          "TNT_PACKAGE_01_CREATE_ALL.lsp"
          "TNT_PACKAGE_02_GENERAL_ALL.lsp"
          "TNT_PACKAGE_03_MANAGE_ALL.lsp"
          "TNT_PACKAGE_04_DRAW_ALL.lsp"
          "TNT_PACKAGE_05_LAYER_ALL.lsp"
          "TNT_PACKAGE_06_TEXT_ALL.lsp"
          "TNT_PACKAGE_07_LEADER_ALL.lsp"
          "TNT_PACKAGE_08_DIMENSION_ALL.lsp"
          "TNT_PACKAGE_09_HATCH_ALL.lsp"
          "TNT_PACKAGE_10_BLOCK_ALL.lsp"
          "TNT_PACKAGE_11_SHORTCUT.lsp"
          "TNT_SUPPORT_LISP\\TNT_BACKUP.lsp"
          "TNT_SUPPORT_LISP\\TNT_LAYER_LISTING.lsp"
          "TNT_SUPPORT_LISP\\TNT_LAYER_SYNC_ALL.lsp"
          "TNT_SUPPORT_LISP\\TNT_MEP_BASE.lsp"
          "TNT_SUPPORT_LISP\\TNT_MIGRATE_DIMSTYLE.lsp"
          "TNT_SUPPORT_LISP\\TNT_STT.lsp")
        loaded 0
        failed 0)
  (setq *TNT.BCAD.ROOT* root)
  (if (not root)
    (princ "\n[TNT] Cannot determine the release-test folder.")
    (foreach item files
      (if (TNT:BCAD:LOAD-ONE root item)
        (setq loaded (1+ loaded))
        (setq failed (1+ failed)))))
  (princ (strcat "\n[TNT] BricsCAD load complete: " (itoa loaded)
                 " loaded, " (itoa failed) " failed."))
  (setq *TNT.BCAD.LOADED* loaded
        *TNT.BCAD.FAILED* failed)
  (princ)
)

(C:TNT_BRICSCAD_LOAD)
(princ)
