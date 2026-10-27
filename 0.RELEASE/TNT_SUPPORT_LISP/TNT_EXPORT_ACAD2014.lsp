;;; ============================================================================
;;; TNT_EXPORT_ACAD2014.lsp - Windows AutoCAD 2014 or newer (ActiveX).
;;; Command: TNT_EXPORT2014
;;; Export selected objects, or the whole current drawing including layouts.
;;; Does not SAVE/SAVEAS, erase, explode, recolor or edit the source drawing.
;;; DWG 2013 / AC1027 is the native format shared by AutoCAD 2013-2017.
;;; This is a DWG format export, NOT an AEC/Civil/proxy conversion engine.
;;; Xrefs/images/fonts remain external dependencies; they are not bound/packed.
;;; ============================================================================

(vl-load-com)

(defun TNT:EXP14:DEFAULT-PATH (/ folder base)
  (setq folder (getvar "DWGPREFIX")
        base (vl-filename-base (getvar "DWGNAME")))
  (if (= folder "") (setq folder (getvar "TEMPPREFIX")))
  (strcat folder base "_ACAD2014.dwg")
)

(defun TNT:EXP14:DWG-PATH (path / ext)
  (setq ext (vl-filename-extension path))
  (cond
    ((null ext) (strcat path ".dwg"))
    ((= (strcase ext) ".DWG") path)
    (T nil))
)

(defun TNT:EXP14:CHOOSE-PATH (/ path done)
  ;; Never overwrite an existing file, including the source or an open DWG.
  ;; Reopen the dialog so the user can choose another name without restarting.
  (while (not done)
    (setq path (getfiled "Export AutoCAD 2014 - Luu file moi"
                        (TNT:EXP14:DEFAULT-PATH) "dwg" 1))
    (cond
      ((null path) (setq done T))
      ((null (setq path (TNT:EXP14:DWG-PATH path)))
        (alert "Chi chap nhan file .dwg. Hay chon lai ten file."))
      ((findfile path)
        (alert "File da ton tai. Hay chon ten moi; khong ghi de file goc/file cu."))
      (T (setq done T))))
  path
)

(defun TNT:EXP14:HEADER (path / stream code result index)
  (if (setq stream (open path "r"))
    (progn
      (setq result "" index 0)
      (while (and (< index 6) (setq code (read-char stream)))
        (setq result (strcat result (chr code)) index (1+ index)))
      (close stream)
      result))
)

(defun TNT:EXP14:CLEANUP (pref oldtype oldvars selection stage / result ok item)
  (setq ok T)
  (if selection
    (progn
      (setq result (vl-catch-all-apply 'vla-Delete (list selection)))
      (if (vl-catch-all-error-p result)
        (progn
          (setq ok nil)
          (prompt (strcat "\n[TNT] Khong xoa duoc selection set tam: "
                          (vl-catch-all-error-message result)))))))
  (if (and pref oldtype)
    (progn
      (setq result (vl-catch-all-apply 'vla-put-SaveAsType (list pref oldtype)))
      (if (vl-catch-all-error-p result)
        (progn
          (setq ok nil)
          (prompt (strcat "\n[TNT] Khong khoi phuc duoc SaveAsType: "
                          (vl-catch-all-error-message result)))))))
  (foreach item oldvars
    (setq result (vl-catch-all-apply 'setvar item))
    (if (vl-catch-all-error-p result)
      (progn
        (setq ok nil)
        (prompt (strcat "\n[TNT] Khong khoi phuc duoc " (car item) ": "
                        (vl-catch-all-error-message result))))))
  ;; Only remove the unique staging file allocated by this invocation.
  (if (and stage (findfile stage) (not (vl-file-delete stage)))
    (progn (setq ok nil) (prompt (strcat "\n[TNT] File tam con lai: " stage))))
  ok
)

(defun TNT:EXP14:WRITE (target ss / *error* doc pref oldtype oldvars stage
                                  selection objects index result)
  (defun *error* (msg)
    (TNT:EXP14:CLEANUP pref oldtype oldvars selection stage)
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*BREAK*")))
      (prompt (strcat "\n[TNT] Export khong hoan tat: " msg)))
    (princ))

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (if (findfile target)
    (progn (prompt "\n[TNT] File dich da ton tai; khong ghi de.") (exit)))
  (if (or (= (getvar "BLOCKEDITOR") 1) (/= (getvar "REFEDITNAME") ""))
    (progn (prompt "\n[TNT] Hay thoat Block Editor/REFEDIT truoc khi export.") (exit)))
  (setq pref (vla-get-OpenSave (vla-get-Preferences (vlax-get-acad-object)))
        oldtype (vla-get-SaveAsType pref)
        oldvars (mapcar '(lambda (name) (list name (getvar name)))
                       '("CMDECHO" "FILEDIA")))
  ;; SaveAsType and both variables are restored on success, error and Esc.
  ;; No drawing variable such as INSBASE/UCS/layer/color is changed.
  (vla-put-SaveAsType pref 60) ; ac2013_dwg, available since AutoCAD 2013.
  (setvar "CMDECHO" 0)
  (setvar "FILEDIA" 0)
  (setq stage (vl-filename-mktemp "TNT_EXPORT2014_" (vl-filename-directory target) ".dwg"))
  (if (findfile stage) (vl-file-delete stage))
  (if ss
    (progn
      ;; ActiveX WBlock copies the set; it does not delete source objects.
      (setq selection (vla-Add (vla-get-SelectionSets doc) (vl-filename-base stage))
            objects (vlax-make-safearray vlax-vbObject (cons 0 (1- (sslength ss))))
            index 0)
      (repeat (sslength ss)
        (vlax-safearray-put-element objects index (vlax-ename->vla-object (ssname ss index)))
        (setq index (1+ index)))
      (vla-AddItems selection objects)
      (vla-WBlock doc stage selection))
    ;; '*' writes all ModelSpace/PaperSpace contents, without removing them.
    ;; Do not use the selected-objects branch of -WBLOCK: it can erase objects.
    (command-s "_.-WBLOCK" stage "*"))
  (cond
    ((/= (TNT:EXP14:HEADER stage) "AC1027")
      (prompt "\n[TNT] Khong tao duoc DWG 2013/2014 (AC1027). Khong cong bo file dich.")
      (setq result nil))
    ((not (vl-file-rename stage target))
      (prompt "\n[TNT] Khong doi ten duoc file export; kiem tra quyen ghi/ten file dich.")
      (setq result nil))
    (T (setq stage nil result T)))
  (if (not (TNT:EXP14:CLEANUP pref oldtype oldvars selection stage))
    (prompt "\n[TNT] Can kiem tra cac canh bao khoi phuc o tren."))
  result
)

(defun C:TNT_EXPORT2014 (/ mode ss target)
  (initget "Chon Tatca")
  (setq mode (getkword "\nExport [Chon doi tuong/Tatca ban ve] <Chon>: "))
  (if (/= mode "Tatca")
    (progn
      (prompt "\nChon doi tuong can export (co the chon block): ")
      (setq ss (ssget "_I"))
      (if (null ss) (setq ss (ssget)))))
  (if (or (= mode "Tatca") ss)
    (if (setq target (TNT:EXP14:CHOOSE-PATH))
      (progn
        (prompt "\n[TNT] Dang export DWG 2013/2014 sang file rieng...")
        (if (TNT:EXP14:WRITE target ss)
          (prompt (strcat
            "\n[TNT] Da export: " target
            "\n      Dinh dang AC1027 - AutoCAD 2014. Ban ve goc van dang mo."
            "\n      AEC/Civil/proxy doi moi khong tu chuyen thanh doi tuong thuong."
            "\n      Xref/anh/font van can file tham chieu goc.")))))
    (prompt "\n[TNT] Khong chon doi tuong; da huy export."))
  (princ)
)

(princ "\n[TNT] Loaded TNT_EXPORT_ACAD2014.lsp - Command: TNT_EXPORT2014")
(princ)
