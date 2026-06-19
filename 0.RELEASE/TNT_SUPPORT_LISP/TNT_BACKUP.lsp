;;; ====================================================================================================
;;; TNT_BACKUP.lsp
;;; Auto-create timestamped DWG backups in the current drawing folder after each save.
;;; Command: TNT_BACKUP
;;; ====================================================================================================

(vl-load-com)

(setq TNT:BACKUP:REGKEY "HKEY_CURRENT_USER\\Software\\TNT Architecture\\TNT_BACKUP")
(setq TNT:BACKUP:REG-MAX "MaxBackups")
(setq TNT:BACKUP:DEFAULT-MAX 5)
(setq TNT:BACKUP:MAX-LIMIT 10)
(setq TNT:BACKUP:REACTOR nil)
(setq TNT:BACKUP:BUSY nil)

(defun TNT:BACKUP:STR-TRIM (value /)
  (vl-string-trim " \t\r\n" (vl-princ-to-string value))
)

(defun TNT:BACKUP:CLAMP-MAX (value / n)
  (setq n
    (cond
      ((numberp value) (fix value))
      ((and value (/= "" (TNT:BACKUP:STR-TRIM value))) (atoi value))
      (T TNT:BACKUP:DEFAULT-MAX)
    )
  )
  (cond
    ((< n 1) 1)
    ((> n TNT:BACKUP:MAX-LIMIT) TNT:BACKUP:MAX-LIMIT)
    (T n)
  )
)

(defun TNT:BACKUP:GET-MAX (/ value)
  (setq value (vl-registry-read TNT:BACKUP:REGKEY TNT:BACKUP:REG-MAX))
  (TNT:BACKUP:CLAMP-MAX value)
)

(defun TNT:BACKUP:SET-MAX (value / n)
  (setq n (TNT:BACKUP:CLAMP-MAX value))
  (vl-registry-write TNT:BACKUP:REGKEY TNT:BACKUP:REG-MAX (itoa n))
  n
)

(defun TNT:BACKUP:TIMESTAMP (/ c s)
  (setq c (rtos (getvar "CDATE") 2 6))
  (while (< (strlen c) 15)
    (setq c (strcat c "0"))
  )
  (setq s
    (strcat
      (substr c 1 4)
      (substr c 5 2)
      (substr c 7 2)
      "_"
      (substr c 10 2)
      (substr c 12 2)
      (substr c 14 2)
    )
  )
  s
)

(defun TNT:BACKUP:DWG-PATH (/ prefix name)
  (setq prefix (getvar "DWGPREFIX")
        name   (getvar "DWGNAME"))
  (if (and prefix name (/= prefix "") (/= name ""))
    (strcat prefix name)
    nil
  )
)

(defun TNT:BACKUP:BACKUP-PATH (/ dir base path)
  (setq dir  (getvar "DWGPREFIX")
        base (vl-filename-base (getvar "DWGNAME"))
        path (strcat dir base "_" (TNT:BACKUP:TIMESTAMP) ".dwg"))
  path
)

(defun TNT:BACKUP:BACKUP-FILES (/ dir base files)
  (setq dir   (getvar "DWGPREFIX")
        base  (vl-filename-base (getvar "DWGNAME"))
        files (vl-directory-files dir (strcat base "_*.dwg") 1))
  (if files
    (mapcar '(lambda (file) (strcat dir file)) files)
    nil
  )
)

(defun TNT:BACKUP:DELETE-OLDEST (maxCount / files extra)
  (setq files (vl-sort (TNT:BACKUP:BACKUP-FILES) '<))
  (if (and files (> (length files) maxCount))
    (progn
      (setq extra (- (length files) maxCount))
      (repeat extra
        (if (findfile (car files))
          (vl-catch-all-apply 'vl-file-delete (list (car files)))
        )
        (setq files (cdr files))
      )
    )
  )
  (princ)
)

(defun TNT:BACKUP:CREATE (/ source backup maxCount result)
  (if (not TNT:BACKUP:BUSY)
    (progn
      (setq TNT:BACKUP:BUSY T)
      (setq source   (TNT:BACKUP:DWG-PATH)
            backup   (TNT:BACKUP:BACKUP-PATH)
            maxCount (TNT:BACKUP:GET-MAX))
      (cond
        ((not source)
          (princ "\n[TNT_BACKUP] Hay save file CAD truoc khi tao backup."))
        ((not (findfile source))
          (princ "\n[TNT_BACKUP] Khong tim thay file DWG hien hanh."))
        (T
          (setq result (vl-catch-all-apply 'vl-file-copy (list source backup)))
          (if (or (vl-catch-all-error-p result) (null result))
            (princ
              (strcat
                "\n[TNT_BACKUP] Loi tao backup: "
                (if (vl-catch-all-error-p result)
                  (vl-catch-all-error-message result)
                  "khong copy duoc file DWG."
                )
              )
            )
            (progn
              (TNT:BACKUP:DELETE-OLDEST maxCount)
              (princ (strcat "\n[TNT_BACKUP] Da tao backup: " backup))
            )
          )
        )
      )
      (setq TNT:BACKUP:BUSY nil)
    )
  )
  (princ)
)

(defun TNT:BACKUP:ON-SAVE-COMPLETE (reactor params)
  (TNT:BACKUP:CREATE)
  (princ)
)

(defun TNT:BACKUP:INSTALL (/)
  (if (and TNT:BACKUP:REACTOR
           (vlr-added-p TNT:BACKUP:REACTOR))
    TNT:BACKUP:REACTOR
    (progn
      (setq TNT:BACKUP:REACTOR
        (vlr-dwg-reactor
          nil
          '((:vlr-saveComplete . TNT:BACKUP:ON-SAVE-COMPLETE))
        )
      )
      TNT:BACKUP:REACTOR
    )
  )
)

(defun TNT:BACKUP:WRITE-DCL (file / fh)
  (setq fh (open file "w"))
  (foreach line
    '(
      "tnt_backup_settings : dialog {"
      "  label = \"TNT BACKUP\";"
      "  : column {"
      "    : text { label = \"So ban backup toi da muon luu (1-10):\"; }"
      "    : edit_box { key = \"max\"; edit_width = 8; allow_accept = true; }"
      "  }"
      "  ok_cancel;"
      "}"
    )
    (write-line line fh)
  )
  (close fh)
  file
)

(defun TNT:BACKUP:SETTINGS-DIALOG (/ dcl dch flag value maxCount)
  (setq dcl (vl-filename-mktemp "TNT_BACKUP_" nil ".dcl"))
  (TNT:BACKUP:WRITE-DCL dcl)
  (setq dch (load_dialog dcl))
  (if (and (> dch 0) (new_dialog "tnt_backup_settings" dch))
    (progn
      (set_tile "max" (itoa (TNT:BACKUP:GET-MAX)))
      (action_tile
        "accept"
        "(setq value (get_tile \"max\")) (done_dialog 1)"
      )
      (action_tile "cancel" "(done_dialog 0)")
      (setq flag (start_dialog))
    )
  )
  (if (and dch (> dch 0)) (unload_dialog dch))
  (if (findfile dcl) (vl-file-delete dcl))
  (if (= flag 1)
    (progn
      (setq maxCount (TNT:BACKUP:SET-MAX value))
      (TNT:BACKUP:INSTALL)
      (princ
        (strcat
          "\n[TNT_BACKUP] Da bat backup tu dong. So ban backup toi da: "
          (itoa maxCount)
          "."
        )
      )
    )
    (princ "\n[TNT_BACKUP] Huy cau hinh backup.")
  )
  (princ)
)

(defun c:TNT_BACKUP (/)
  (TNT:BACKUP:SETTINGS-DIALOG)
  (princ)
)

(if (vl-registry-read TNT:BACKUP:REGKEY TNT:BACKUP:REG-MAX)
  (TNT:BACKUP:INSTALL)
)

(princ "\n[TNT] Loaded TNT_BACKUP.lsp. Lenh: TNT_BACKUP")
(princ)
