;;; ============================================================================
;;; TNT_AEC_DOWN2014.lsp
;;; Export AEC objects to plain AutoCAD entities in a NEW AutoCAD 2013 DWG.
;;; AutoCAD 2014 can open the resulting file directly.
;;;
;;; Command: TNT_AEC2014
;;; Requires: AutoCAD Architecture (or an Autodesk product/Object Enabler which
;;;           provides the -EXPORTTOAUTOCAD command for the source AEC objects).
;;; The source DWG on disk is never overwritten by this routine.
;;; ============================================================================

(vl-load-com)

(defun TNT:AEC14:ENSURE-DWG-EXT (path)
  (if (= (strcase (vl-filename-extension path)) ".DWG")
    path
    (strcat path ".dwg")
  )
)

(defun TNT:AEC14:DEFAULT-PATH (/ prefix base)
  (setq prefix (getvar "DWGPREFIX")
        base   (vl-filename-base (getvar "DWGNAME")))
  (strcat prefix base "_ACAD2014.dwg")
)

(defun TNT:AEC14:SAME-FILE-P (a b)
  (= (strcase (vl-string-translate "/" "\\" a))
     (strcase (vl-string-translate "/" "\\" b)))
)

(defun TNT:AEC14:EDITABLE-BLOCK-P (block / name isxref)
  (setq name   (vla-get-Name block)
        isxref (vl-catch-all-apply 'vla-get-IsXRef (list block)))
  (and (not (wcmatch name "*|*"))
       (or (vl-catch-all-error-p isxref) (= isxref :vlax-false)))
)

(defun TNT:AEC14:AEC-OBJECT-P (obj / objectname ename dxfname upper)
  (setq objectname (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
  (if (not (vl-catch-all-error-p objectname))
    (setq upper (strcase objectname))
  )
  (setq ename (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
  (if (not (vl-catch-all-error-p ename))
    (setq dxfname (cdr (assoc 0 (entget ename))))
  )
  (or
    (and upper
         (or (wcmatch upper "AECDB*,AECCDB*")
             (wcmatch upper "*AEC*OBJECT*")))
    (and dxfname
         (or (wcmatch (strcase dxfname) "AEC_*,AECC_*")
             (= (strcase dxfname) "ACAD_PROXY_ENTITY")))
  )
)

(defun TNT:AEC14:COUNT-AEC (/ doc blocks block obj count)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object))
        blocks (vla-get-Blocks doc)
        count  0)
  (vlax-for block blocks
    (if (TNT:AEC14:EDITABLE-BLOCK-P block)
      (vlax-for obj block
        (if (TNT:AEC14:AEC-OBJECT-P obj)
          (setq count (1+ count))
        )
      )
    )
  )
  count
)

(defun TNT:AEC14:RUN-EXPORT (target)
  ;; Autodesk's AEC export engine converts display representations as well as
  ;; the parent AEC objects.  This is intentionally used instead of SaveAs +
  ;; AECOBJEXPLODE, which can leave version-specific proxy graphics behind.
  ;;
  ;; Settings: AutoCAD 2013 format, bind xrefs and retain xref namespaces.
  ;; Maintain=No deliberately keeps block instances generated from custom AEC
  ;; objects instead of exploding all their contents into loose primitives.
  ;; COMMAND is a special form in AutoLISP and must not be invoked through
  ;; vl-catch-all-apply (that produces "bad order function: COMMAND").
  (command
    "_.-EXPORTTOAUTOCAD"
    "_Format" "2013"
    "_Bind" "_Yes"
    "_Type" "_Bind"
    "_Maintain" "_No"
    "" target)
  (and (= (getvar "CMDACTIVE") 0)
       (findfile target))
)

(defun TNT:AEC14:CANCEL-ACTIVE-COMMANDS (/ guard)
  (setq guard 0)
  (while (and (> (getvar "CMDACTIVE") 0) (< guard 10))
    (command)
    (setq guard (1+ guard))
  )
  (= (getvar "CMDACTIVE") 0)
)

(defun C:TNT_AEC2014 (/ *error* olderror oldcmdecho oldfiledia doc source target
                        before exportOk)
  (setq olderror  *error*
        oldcmdecho (getvar "CMDECHO")
        oldfiledia (getvar "FILEDIA")
        doc        (vla-get-ActiveDocument (vlax-get-acad-object))
        source     (vla-get-FullName doc))

  (defun *error* (msg)
    (setvar "CMDECHO" oldcmdecho)
    (setvar "FILEDIA" oldfiledia)
    (setq *error* olderror)
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*BREAK*")))
      (prompt (strcat "\n[TNT] Loi TNT_AEC2014: " msg))
    )
    (princ)
  )

  (setq target (getfiled "Luu ban AutoCAD 2014 moi" (TNT:AEC14:DEFAULT-PATH) "dwg" 1))
  (if target
    (progn
      (setq target (TNT:AEC14:ENSURE-DWG-EXT target))
      (cond
        ((TNT:AEC14:SAME-FILE-P source target)
          (prompt "\n[TNT] Khong duoc ghi de file nguon. Hay chon ten file moi."))
        ((findfile target)
          (prompt "\n[TNT] File dich da ton tai. Hay chay lai va chon mot ten moi de tranh prompt ghi de lam sai chuoi export."))
        (T
          (setvar "CMDECHO" 0)
          (setvar "FILEDIA" 0)
          (setq before (TNT:AEC14:COUNT-AEC))
          (prompt
            (strcat "\n[TNT] Phat hien " (itoa before)
                    " doi tuong AEC/proxy. Dang export va giu nguyen cau truc block..."))
          (setq exportOk (TNT:AEC14:RUN-EXPORT target))
          (TNT:AEC14:CANCEL-ACTIVE-COMMANDS)
          (if exportOk
            (prompt
              (strcat
                "\n[TNT] Xong: " target
                "\n      AEC da duoc export thanh doi tuong AutoCAD nam trong block."
                "\n      Dinh dang: AutoCAD 2013 DWG (AutoCAD 2014 mo duoc)."
                "\n      Block thuong va block long duoc giu; hinh hoc AEC duoc giu trong block."))
            (prompt
              (strcat
                "\n[TNT] EXPORTTOAUTOCAD khong tao duoc file dich. File nguon van an toan."
                "\n      Phai chay trong AutoCAD Architecture 2022 (hoac AutoCAD co dung AEC Object Enabler)."))
          )
        )
      )
    )
  )
  (setvar "CMDECHO" oldcmdecho)
  (setvar "FILEDIA" oldfiledia)
  (setq *error* olderror)
  (princ)
)

(princ "\n[TNT] Loaded TNT_AEC_DOWN2014.lsp - Command: TNT_AEC2014")
(princ)
