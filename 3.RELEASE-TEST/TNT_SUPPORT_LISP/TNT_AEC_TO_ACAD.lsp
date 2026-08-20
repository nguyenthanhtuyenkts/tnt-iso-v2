;;; ====================================================================================================
;;; TNT_AEC_TO_ACAD.lsp
;;; Find AEC Wall objects (including Walls in block definitions), then run
;;; AutoCAD Architecture's native in-place AEC explode engine.
;;;
;;; Command: TNT_ACAD
;;; WARNING: AEC intelligence is permanently lost after the drawing is saved.
;;; ====================================================================================================

(vl-load-com)

(setq TNT:AEC:TARGET-LAYER "....46_TNT_BASE_MEP")
(setq TNT:AEC:TARGET-COLOR 250)
(setq TNT:AEC:TARGET-LINEWEIGHT 15) ; 0.15 mm - net manh

(defun TNT:AEC:RUN-SETTING-0 (/ result oldSkip)
  ;; Command 0 is defined by TNT_PACKAGE_00_SYSTEM_ALL as C:0.
  (if (member "C:0" (atoms-family 1))
    (progn
      (setq oldSkip (if (boundp 'TNT:AEC:SKIP-DIMENSIONS) TNT:AEC:SKIP-DIMENSIONS nil))
      (setq TNT:AEC:SKIP-DIMENSIONS T)
      (setq result (vl-catch-all-apply 'C:0 nil))
      (setq TNT:AEC:SKIP-DIMENSIONS oldSkip)
      (if (vl-catch-all-error-p result)
        (progn
          (prompt (strcat "\n[TNT] Loi khi chay lenh 0: " (vl-catch-all-error-message result)))
          nil
        )
        T
      )
    )
    (progn
      (prompt "\n[TNT] Khong tim thay lenh 0. Hay nap TNT_PACKAGE_00_SYSTEM_ALL.lsp truoc.")
      nil
    )
  )
)

(defun TNT:AEC:ENSURE-TARGET-LAYER (/ doc layers layer result)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object))
        layers (vla-get-Layers doc)
        layer  (vl-catch-all-apply 'vla-Item (list layers TNT:AEC:TARGET-LAYER)))
  (if (vl-catch-all-error-p layer)
    (setq layer (vl-catch-all-apply 'vla-Add (list layers TNT:AEC:TARGET-LAYER)))
  )
  (if (vl-catch-all-error-p layer)
    nil
    (progn
      (vl-catch-all-apply 'vla-put-LayerOn (list layer :vlax-true))
      (vl-catch-all-apply 'vla-put-Freeze (list layer :vlax-false))
      (vl-catch-all-apply 'vla-put-Lock (list layer :vlax-false))
      (vl-catch-all-apply 'vla-put-Color (list layer TNT:AEC:TARGET-COLOR))
      (vl-catch-all-apply 'vla-put-Linetype (list layer "Continuous"))
      (setq result (vl-catch-all-apply 'vla-put-Lineweight (list layer TNT:AEC:TARGET-LINEWEIGHT)))
      (not (vl-catch-all-error-p result))
    )
  )
)

(defun TNT:AEC:SET-OTHER-LAYERS-COLOR-250 (/ doc layers layer name result changed failed)
  (setq doc     (vla-get-ActiveDocument (vlax-get-acad-object))
        layers  (vla-get-Layers doc)
        changed 0
        failed  0)
  (vlax-for layer layers
    (setq name (vla-get-Name layer))
    (if (/= (strcase name) (strcase TNT:AEC:TARGET-LAYER))
      (progn
        (setq result (vl-catch-all-apply 'vla-put-Color (list layer 250)))
        (if (vl-catch-all-error-p result)
          (setq failed (1+ failed))
          (setq changed (1+ changed))
        )
      )
    )
  )
  (list changed failed)
)

(defun TNT:AEC:SOLID-HATCH-EXCEPTION-P (obj / objectName patternName color)
  (setq objectName (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
  (if (and (not (vl-catch-all-error-p objectName))
           (= (strcase objectName) "ACDBHATCH"))
    (progn
      (setq patternName (vl-catch-all-apply 'vla-get-PatternName (list obj))
            color       (vl-catch-all-apply 'vla-get-Color (list obj)))
      (and (not (vl-catch-all-error-p patternName))
           (not (vl-catch-all-error-p color))
           (= (strcase patternName) "SOLID")
           (member color '(251 252 254 255)))
    )
    nil
  )
)

(defun TNT:AEC:DIMENSION-P (obj / objectName ename data dxfType)
  (setq objectName (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
  (if (and (not (vl-catch-all-error-p objectName))
           (vl-string-search "DIMENSION" (strcase objectName)))
    T
    (progn
      (setq ename (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (vl-catch-all-error-p ename)
        nil
        (progn
          (setq data    (entget ename)
                dxfType (cdr (assoc 0 data)))
          (and dxfType (= (strcase dxfType) "DIMENSION"))
        )
      )
    )
  )
)

(defun TNT:AEC:TEXT-P (obj / objectName ename data dxfType)
  (setq objectName (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
  (if (and (not (vl-catch-all-error-p objectName))
           (member (strcase objectName)
             '("ACDBTEXT" "ACDBMTEXT" "ACDBATTRIBUTE" "ACDBATTRIBUTEDEFINITION")))
    T
    (progn
      (setq ename (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (vl-catch-all-error-p ename)
        nil
        (progn
          (setq data    (entget ename)
                dxfType (cdr (assoc 0 data)))
          (and dxfType
               (member (strcase dxfType) '("TEXT" "MTEXT" "ATTRIB" "ATTDEF")))
        )
      )
    )
  )
)

(defun TNT:AEC:NORMALIZE-OBJECT (obj / solidException layerResult colorResult weightResult)
  ;; Keep each object's existing Linetype and LinetypeScale unchanged.
  ;; Preserve the special SOLID hatch display rule before changing any properties.
  (setq solidException (TNT:AEC:SOLID-HATCH-EXCEPTION-P obj))
  (setq layerResult  (vl-catch-all-apply 'vla-put-Layer (list obj TNT:AEC:TARGET-LAYER))
        colorResult  (vl-catch-all-apply 'vla-put-Color (list obj (if solidException 251 250)))
        weightResult (vl-catch-all-apply 'vla-put-Lineweight (list obj -1)))
  (and (not (vl-catch-all-error-p layerResult))
       (not (vl-catch-all-error-p colorResult))
       (not (vl-catch-all-error-p weightResult)))
)

(defun TNT:AEC:NORMALIZE-DRAWING (/ doc blocks block obj changed failed skipped textSkipped layerColors)
  (setq changed 0 failed 0 skipped 0 textSkipped 0 layerColors '(0 0))
  (if (TNT:AEC:ENSURE-TARGET-LAYER)
    (progn
      (setq layerColors (TNT:AEC:SET-OTHER-LAYERS-COLOR-250))
      (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object))
            blocks (vla-get-Blocks doc))
      (vlax-for block blocks
        (if (TNT:AEC:EDITABLE-BLOCK-P block)
          (vlax-for obj block
            (if (TNT:AEC:DIMENSION-P obj)
              (setq skipped (1+ skipped))
              (if (TNT:AEC:TEXT-P obj)
                (setq textSkipped (1+ textSkipped))
                (if (TNT:AEC:NORMALIZE-OBJECT obj)
                  (setq changed (1+ changed))
                  (setq failed (1+ failed))
                )
              )
            )
          )
        )
      )
      (vla-Regen doc 1)
    )
    (setq failed 1)
  )
  (list changed failed layerColors skipped textSkipped)
)

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

(defun C:TNT_ACAD (/ *error* olderror wallcount snapshot moved normalized)
  (setq olderror *error*)
  (defun *error* (msg)
    (setq *error* olderror)
    (if (and msg
             (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*BREAK*")))
      (prompt (strcat "\n[TNT] Loi khi goi -AECOBJEXPLODE: " msg))
    )
    (princ)
  )

  (TNT:AEC:RUN-SETTING-0)
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
  (setq normalized (TNT:AEC:NORMALIZE-DRAWING))
  (prompt
    (strcat
      "\n[TNT] Da chuyen " (itoa (car normalized)) " doi tuong ve layer "
      TNT:AEC:TARGET-LAYER
      ". Layer va doi tuong mau 250, Continuous, net manh 0.15 mm"
      " (SOLID hatch ngoai le doi thanh 251); giu nguyen Linetype va LinetypeScale. Khong doi duoc: "
      (itoa (cadr normalized)) "."
      " Layer khac da doi mau 250: " (itoa (car (caddr normalized)))
      "; khong doi duoc: " (itoa (cadr (caddr normalized))) "."
      " Dimension giu nguyen: " (itoa (cadddr normalized)) "."
      " Text/Attribute giu nguyen: " (itoa (car (cddddr normalized))) "."
    )
  )
  (setq *error* olderror)
  (princ)
)

(princ "\n[TNT] Loaded TNT_AEC_TO_ACAD.lsp - Command: TNT_ACAD")
(princ)
