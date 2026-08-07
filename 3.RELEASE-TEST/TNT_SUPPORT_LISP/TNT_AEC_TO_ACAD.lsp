;;; ====================================================================================================
;;; TNT_AEC_TO_ACAD.lsp
;;; Find AEC Wall objects (including Walls in block definitions), then run
;;; AutoCAD Architecture's native in-place AEC explode engine.
;;;
;;; Command: TNT_ACAD
;;; WARNING: AEC intelligence is permanently lost after the drawing is saved.
;;; ====================================================================================================

(vl-load-com)

(defun TNT:AEC:WALL-P (obj / objectname ename dxfname)
  (setq objectname (vl-catch-all-apply 'vla-get-ObjectName (list obj))
        ename      (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
  (if (not (vl-catch-all-error-p ename))
    (setq dxfname (cdr (assoc 0 (entget ename))))
  )
  (or
    (and (not (vl-catch-all-error-p objectname))
         (wcmatch (strcase objectname) "AECDBWALL,WALL"))
    (and dxfname (= (strcase dxfname) "AEC_WALL"))
  )
)

(defun TNT:AEC:COUNT-WALLS (/ doc blocks block obj name isxref count)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object))
        blocks (vla-get-Blocks doc)
        count  0)
  ;; Blocks includes ModelSpace, PaperSpace and every nested block definition.
  (vlax-for block blocks
    (setq name   (vla-get-Name block)
          isxref (vl-catch-all-apply 'vla-get-IsXRef (list block)))
    (if (and (not (wcmatch name "*|*"))
             (or (vl-catch-all-error-p isxref) (= isxref :vlax-false)))
      (vlax-for obj block
        (if (TNT:AEC:WALL-P obj)
          (setq count (1+ count))
        )
      )
    )
  )
  count
)

(defun TNT:AEC:EDITABLE-BLOCK-P (block / name isxref)
  (setq name   (vla-get-Name block)
        isxref (vl-catch-all-apply 'vla-get-IsXRef (list block)))
  (and (not (wcmatch name "*|*"))
       (or (vl-catch-all-error-p isxref) (= isxref :vlax-false)))
)

(defun TNT:AEC:SNAPSHOT (/ doc blocks block obj ids result)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object))
        blocks (vla-get-Blocks doc))
  (vlax-for block blocks
    (if (TNT:AEC:EDITABLE-BLOCK-P block)
      (progn
        (setq ids nil)
        (vlax-for obj block
          (setq ids (cons (vla-get-ObjectID obj) ids))
        )
        (setq result (cons (list block ids) result))
      )
    )
  )
  result
)

(defun TNT:AEC:MOVE-OBJECTS-TO-BOTTOM (block objects / dictionary sortents array index result)
  (if objects
    (progn
      (setq dictionary (vla-GetExtensionDictionary block)
            sortents
              (vl-catch-all-apply
                'vla-GetObject
                (list dictionary "ACAD_SORTENTS")))
      (if (vl-catch-all-error-p sortents)
        (setq sortents
          (vla-AddObject dictionary "ACAD_SORTENTS" "AcDbSortentsTable"))
      )
      (setq array (vlax-make-safearray vlax-vbObject
                    (cons 0 (1- (length objects))))
            index 0)
      (foreach obj objects
        (vlax-safearray-put-element array index obj)
        (setq index (1+ index))
      )
      (setq result
        (vl-catch-all-apply 'vla-MoveToBottom (list sortents array)))
      (not (vl-catch-all-error-p result))
    )
  )
)

(defun TNT:AEC:SEND-NEW-OBJECTS-TO-BACK (snapshot / item block oldids obj newobjects moved)
  (setq moved 0)
  (foreach item snapshot
    (setq block      (car item)
          oldids     (cadr item)
          newobjects nil)
    (vlax-for obj block
      (if (not (member (vla-get-ObjectID obj) oldids))
        (setq newobjects (cons obj newobjects))
      )
    )
    (if (TNT:AEC:MOVE-OBJECTS-TO-BOTTOM block newobjects)
      (setq moved (+ moved (length newobjects)))
    )
  )
  (vla-Regen (vla-get-ActiveDocument (vlax-get-acad-object)) 1)
  moved
)

(defun TNT:AEC:ACCEPT-DEFAULTS (/ steps lastprompt answer)
  (setq steps 0)
  ;; Keep the source Wall layer: explode to primitives and resolve the parent
  ;; object's layer/color/linetype onto every resulting AutoCAD entity.
  ;; Accept the current default for all unrelated prompts.
  ;; The limit prevents an unexpected version-specific prompt from looping forever.
  (while (and (> (getvar "CMDACTIVE") 0) (< steps 50))
    (setq lastprompt (strcase (getvar "LASTPROMPT"))
          answer
            (cond
              ((wcmatch lastprompt "*EXPLODE*ANONYMOUS*BLOCK*") "_No")
              ((wcmatch lastprompt "*MAINTAIN*RESOLVED*LAYER*") "_Yes")
              (T "")
            )
    )
    (command answer)
    (setq steps (1+ steps))
  )
  (if (> (getvar "CMDACTIVE") 0)
    (progn
      (command)
      (prompt
        "\n[TNT] Da dung -AECOBJEXPLODE: vuot qua 50 prompt, khong the tu dong an toan."
      )
      nil
    )
    T
  )
)

(defun C:TNT_ACAD (/ *error* olderror wallcount snapshot moved)
  (setq olderror *error*)
  (defun *error* (msg)
    (setq *error* olderror)
    (if (and msg
             (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*BREAK*")))
      (prompt (strcat "\n[TNT] Loi khi goi -AECOBJEXPLODE: " msg))
    )
    (princ)
  )

  (setq wallcount (TNT:AEC:COUNT-WALLS))
  (cond
    ((= wallcount 0)
      (prompt
        (strcat
          "\n[TNT] Khong tim thay Wall (AecDbWall/AEC_WALL) trong file hoac block."
          "\n      Neu Properties hien Wall nhung ket qua van bang 0, doi tuong dang la proxy"
          " va can mo file bang AutoCAD Architecture co dung Object Enabler."
        )
      )
    )
    (T
      (prompt
        (strcat
          "\n[TNT] Tim thay " (itoa wallcount) " Wall trong file va block definition."
          "\n      Dang chay -AECOBJEXPLODE cua AutoCAD Architecture."
          "\n      Giu layer cua Wall goc; cac tuy chon khac dung gia tri mac dinh."
          "\n      File hien tai se bi thay doi.\n"
        )
      )
      ;; Call directly so Architecture can demand-load the AEC module.
      ;; GETCNAME can incorrectly return NIL before that demand-load occurs.
      (setq snapshot (TNT:AEC:SNAPSHOT))
      (command "_.-AECOBJEXPLODE")
      (if (TNT:AEC:ACCEPT-DEFAULTS)
        (progn
          (setq moved (TNT:AEC:SEND-NEW-OBJECTS-TO-BACK snapshot))
          (prompt
            (strcat
              "\n[TNT] Da dua " (itoa moved)
              " doi tuong moi sau convert xuong draw order thap nhat."
            )
          )
        )
      )
    )
  )
  (setq *error* olderror)
  (princ)
)

(princ "\n[TNT] Loaded TNT_AEC_TO_ACAD.lsp - Command: TNT_ACAD")
(princ)
