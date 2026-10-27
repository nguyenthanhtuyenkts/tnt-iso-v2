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

(defun TNT:AEC:DELETE-SOLID-17 (/ doc block obj data objects layer locked result deleted failed)
  ;; Match explicit ACI 17 only, before normalization overwrites entity colors.
  ;; TrueColor and ByLayer/ByBlock are not explicit ACI 17.
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)) deleted 0 failed 0)
  (vlax-for block (vla-get-Blocks doc)
    (if (TNT:AEC:EDITABLE-BLOCK-P block)
      (vlax-for obj block
        (if (= (vla-get-ObjectName obj) "AcDbHatch")
          (progn
            (setq data (entget (vlax-vla-object->ename obj)))
            (if (and (= (strcase (vla-get-PatternName obj)) "SOLID")
                     (= (cdr (assoc 62 data)) 17)
                     (not (assoc 420 data)))
              (setq objects (cons obj objects))))))))
  ;; Collect first: deleting during collection enumeration can skip entities.
  (foreach obj objects
    (setq layer (vla-Item (vla-get-Layers doc) (vla-get-Layer obj))
          locked (vla-get-Lock layer))
    (if (= locked :vlax-true) (vla-put-Lock layer :vlax-false))
    (setq result (vl-catch-all-apply 'vla-Delete (list obj)))
    (if (= locked :vlax-true) (vla-put-Lock layer :vlax-true))
    (if (vl-catch-all-error-p result)
      (progn
        (setq failed (1+ failed))
        (prompt (strcat "\n[TNT] Khong xoa duoc SOLID mau 17, Handle "
                        (vla-get-Handle obj) ": " (vl-catch-all-error-message result))))
      (setq deleted (1+ deleted))))
  (list deleted failed))

(defun TNT:AEC:SOLID-HATCH-EXCEPTION-P (obj)
  ;; Every remaining SOLID has the same target color, regardless of input ACI.
  (and (= (vla-get-ObjectName obj) "AcDbHatch")
       (= (strcase (vla-get-PatternName obj)) "SOLID")))

(defun TNT:AEC:FORCE-ACI (obj index / color)
  ;; Explicit ByACI also replaces TrueColor / color-book overrides.
  (setq color (vla-get-TrueColor obj))
  (vla-put-ColorIndex color index)
  (vla-put-TrueColor obj color)
  (vlax-release-object color))
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
        colorResult  (vl-catch-all-apply 'TNT:AEC:FORCE-ACI (list obj (if solidException 251 250)))
        weightResult (vl-catch-all-apply 'vla-put-Lineweight (list obj -1)))
  (and (not (vl-catch-all-error-p layerResult))
       (not (vl-catch-all-error-p colorResult))
       (not (vl-catch-all-error-p weightResult)))
)

(defun TNT:AEC:STRIP-TEXT-COLORS (value / index size char next end result)
  ;; Remove only MTEXT color overrides; retain font, height and other formatting.
  (setq index 1 size (strlen value) result "")
  (while (<= index size)
    (setq char (substr value index 1)
          next (if (< index size) (substr value (1+ index) 1) ""))
    (cond
      ((and (= char "\\") (member next '("C" "c"))
            (setq end (vl-string-search ";" value (1+ index)))
            (not (wcmatch (substr value (+ index 2) (- end index 1)) "*~[0-9]*")))
        (setq index (+ end 2)))
      ;; Copy escaped backslashes/braces together so literal text stays intact.
      ((and (= char "\\") (member next '("\\" "{" "}")))
        (setq result (strcat result char next) index (+ index 2)))
      (T (setq result (strcat result char) index (1+ index)))
    )
  )
  result
)

(defun TNT:AEC:TEXT-COLOR-251 (obj dimension / value cleaned)
  (if dimension
    (progn
      (vla-put-TextColor obj 251)
      (setq value (vla-get-TextOverride obj)
            cleaned (TNT:AEC:STRIP-TEXT-COLORS value))
      (if (/= value cleaned) (vla-put-TextOverride obj cleaned)))
    (progn
      (vla-put-Color obj 251)
      (if (= (vla-get-ObjectName obj) "AcDbMText")
        (progn
          (setq value (vla-get-TextString obj)
                cleaned (TNT:AEC:STRIP-TEXT-COLORS value))
          (if (/= value cleaned) (vla-put-TextString obj cleaned))))
      ;; Multiline attributes have a separate formatted text representation.
      (if (and (vlax-property-available-p obj 'MTextAttribute)
               (= (vla-get-MTextAttribute obj) :vlax-true))
        (progn
          (setq value (vla-get-MTextAttributeContent obj)
                cleaned (TNT:AEC:STRIP-TEXT-COLORS value))
          (if (/= value cleaned)
            (progn
              (vla-put-MTextAttributeContent obj cleaned)
              (vla-UpdateMTextAttribute obj)))))))
  T
)

(defun TNT:AEC:COLOR-ALL-TEXT (/ doc block obj attribute method attributes result changed failed)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)) changed 0 failed 0)
  ;; Every local definition is visited, regardless of block nesting depth.
  (vlax-for block (vla-get-Blocks doc)
    (if (TNT:AEC:EDITABLE-BLOCK-P block)
      (vlax-for obj block
        (cond
          ((or (TNT:AEC:DIMENSION-P obj) (TNT:AEC:TEXT-P obj))
            (setq result (vl-catch-all-apply 'TNT:AEC:TEXT-COLOR-251
                           (list obj (TNT:AEC:DIMENSION-P obj))))
            (if (vl-catch-all-error-p result)
              (setq failed (1+ failed)) (setq changed (1+ changed))))
          ((and (= (vla-get-ObjectName obj) "AcDbBlockReference")
                (= (vla-get-HasAttributes obj) :vlax-true)
                (TNT:AEC:EDITABLE-BLOCK-P
                  (vla-Item (vla-get-Blocks doc) (vla-get-Name obj))))
            ;; Attribute references are not enumerated as block contents.
            (foreach method '(GetAttributes GetConstantAttributes)
              (setq attributes (vl-catch-all-apply 'vlax-invoke (list obj method)))
              (if (vl-catch-all-error-p attributes)
                (setq failed (1+ failed))
                (foreach attribute attributes
                  (setq result (vl-catch-all-apply 'TNT:AEC:TEXT-COLOR-251
                                 (list attribute nil)))
                  (if (vl-catch-all-error-p result)
                    (setq failed (1+ failed)) (setq changed (1+ changed)))))))
        )
      )
    )
  )
  (vla-Regen doc 1)
  (list changed failed)
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

(defun TNT:AEC:MMUL (a b / columns)
  (setq columns (apply 'mapcar (cons 'list b)))
  (mapcar '(lambda (row)
             (mapcar '(lambda (col) (apply '+ (mapcar '* row col))) columns)) a))

(defun TNT:AEC:INSERT-MATRIX (ref block / p o n a sx sy sz x y z offset)
  ;; Definition coordinates -> owning space, including block base point and OCS.
  (setq p (vlax-get ref 'InsertionPoint) o (vlax-get block 'Origin)
        n (vlax-get ref 'Normal) a (vla-get-Rotation ref)
        sx (vla-get-XScaleFactor ref) sy (vla-get-YScaleFactor ref)
        sz (vla-get-ZScaleFactor ref)
        x (trans (list (* sx (cos a)) (* sx (sin a)) 0.0) n 0 T)
        y (trans (list (* (- sy) (sin a)) (* sy (cos a)) 0.0) n 0 T)
        z (trans (list 0.0 0.0 sz) n 0 T)
        offset (mapcar '- p
                 (mapcar '+ (mapcar '(lambda (v) (* (car o) v)) x)
                            (mapcar '(lambda (v) (* (cadr o) v)) y)
                            (mapcar '(lambda (v) (* (caddr o) v)) z))))
  (list (list (car x) (car y) (car z) (car offset))
        (list (cadr x) (cadr y) (cadr z) (cadr offset))
        (list (caddr x) (caddr y) (caddr z) (caddr offset))
        '(0.0 0.0 0.0 1.0)))

(defun TNT:AEC:CLIPPED-REFERENCE-P (ref / filters)
  (and (= (vla-get-HasExtensionDictionary ref) :vlax-true)
       (setq filters (dictsearch (vlax-vla-object->ename (vla-GetExtensionDictionary ref)) "ACAD_FILTER"))
       (dictsearch (cdr (assoc -1 filters)) "SPATIAL")))

(defun TNT:AEC:COLLECT-SOLID-INSTANCES (doc owner space matrix path visible / obj block name countBefore)
  (if (> (length path) 64)
    (setq TNT:AEC:EXTRACT-PROBLEM "Block long qua 64 cap."))
  (if (not TNT:AEC:EXTRACT-PROBLEM)
    (vlax-for obj owner
      (cond
        ((and (= (vla-get-IsLayout owner) :vlax-false)
              (TNT:AEC:SOLID-HATCH-EXCEPTION-P obj))
          (setq TNT:AEC:EXTRACT-JOBS (cons (list obj space matrix visible) TNT:AEC:EXTRACT-JOBS)))
        ((member (vla-get-ObjectName obj) '("AcDbBlockReference" "AcDbMInsertBlock"))
          (setq name (vla-get-Name obj) block (vla-Item (vla-get-Blocks doc) name))
          (if (and (TNT:AEC:EDITABLE-BLOCK-P block) (not (member name path)))
            (progn
              (setq countBefore (length TNT:AEC:EXTRACT-JOBS))
              (TNT:AEC:COLLECT-SOLID-INSTANCES doc block space
                (TNT:AEC:MMUL matrix (TNT:AEC:INSERT-MATRIX obj block))
                (cons name path) (and visible (= (vla-get-Visible obj) :vlax-true)))
              (if (and (= (vla-get-ObjectName obj) "AcDbMInsertBlock")
                       (> (length TNT:AEC:EXTRACT-JOBS) countBefore))
                (setq TNT:AEC:EXTRACT-PROBLEM "MINSERT co SOLID: can tach mang thanh block thuong truoc."))
              (if (and (> (length TNT:AEC:EXTRACT-JOBS) countBefore)
                       (TNT:AEC:CLIPPED-REFERENCE-P obj))
                (setq TNT:AEC:EXTRACT-PROBLEM "Block XCLIP co SOLID: chua ho tro tach dung bien cat; giu SOLID goc.")))))))))

(defun TNT:AEC:DETACH-HATCH (obj / en data output pair skip reactors)
  ;; A detached temporary copy can be cloned across owners without dependencies.
  ;; Only boundary-reference group 97 followed by 330 is changed; spline fit
  ;; point group 97 inside an edge is preserved.
  (setq en (vlax-vla-object->ename obj) data (entget en))
  (while data
    (setq pair (car data) data (cdr data))
    (cond
      ((and (= (car pair) 102) (= (cdr pair) "{ACAD_REACTORS")) (setq reactors T))
      (reactors (if (and (= (car pair) 102) (= (cdr pair) "}")) (setq reactors nil)))
      ((= (car pair) 71) (setq output (cons '(71 . 0) output)))
      ((and (= (car pair) 97) (> (cdr pair) 0) (eq (caar data) 330))
        (setq skip (cdr pair) output (cons '(97 . 0) output))
        (repeat skip
          (if (eq (caar data) 330) (setq data (cdr data)))))
      (T (setq output (cons pair output)))))
  (if (null (entmod (reverse output))) (exit)))

(defun TNT:AEC:EXTRACT-ONE-SOLID (doc job / source temp arr clone)
  (setq source (car job) temp (vla-Copy source)
        TNT:AEC:EXTRACT-STAGED (cons temp TNT:AEC:EXTRACT-STAGED))
  (TNT:AEC:DETACH-HATCH temp)
  (setq arr (vlax-make-safearray vlax-vbObject '(0 . 0)))
  (vlax-safearray-put-element arr 0 temp)
  (setq clone (car (vlax-safearray->list (vlax-variant-value (vla-CopyObjects doc arr (cadr job)))))
        TNT:AEC:EXTRACT-STAGED (cons clone TNT:AEC:EXTRACT-STAGED))
  (vla-TransformBy clone (vlax-tmatrix (caddr job)))
  (vla-put-Layer clone TNT:AEC:TARGET-LAYER)
  (TNT:AEC:FORCE-ACI clone 251)
  (vla-put-Lineweight clone -1)
  (if (not (cadddr job)) (vla-put-Visible clone :vlax-false))
  (vla-Delete temp)
  clone)

(defun TNT:AEC:EXTRACT-SOLIDS (/ doc block identity job result failed sources item en rollback
                              TNT:AEC:EXTRACT-JOBS TNT:AEC:EXTRACT-PROBLEM TNT:AEC:EXTRACT-STAGED)
  ;; Stage ALL instances first. Delete shared source hatches only after every
  ;; instance has a transformed copy in its Model/Layout space.
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))
        identity '((1.0 0.0 0.0 0.0) (0.0 1.0 0.0 0.0) (0.0 0.0 1.0 0.0) (0.0 0.0 0.0 1.0)))
  (vlax-for block (vla-get-Blocks doc)
    (if (= (vla-get-IsLayout block) :vlax-true)
      (TNT:AEC:COLLECT-SOLID-INSTANCES doc block block identity nil T)))
  (if TNT:AEC:EXTRACT-PROBLEM
    (progn (setq failed T) (prompt (strcat "\n[TNT] Chua tach SOLID: " TNT:AEC:EXTRACT-PROBLEM))))
  (foreach job TNT:AEC:EXTRACT-JOBS
    (if (not failed)
      (progn
        (setq result (vl-catch-all-apply 'TNT:AEC:EXTRACT-ONE-SOLID (list doc job)))
        (if (vl-catch-all-error-p result)
          (progn (setq failed T)
            (prompt (strcat "\n[TNT] Loi tach SOLID, giu ban goc: " (vl-catch-all-error-message result))))
          (progn
            (setq en (vlax-vla-object->ename (car job)))
            (if (not (member en sources)) (setq sources (cons en sources))))))))
  (if (not failed)
    (foreach en sources
      (if (not failed)
        (progn
          (setq result (vl-catch-all-apply 'vla-Delete (list (vlax-ename->vla-object en))))
          (if (vl-catch-all-error-p result)
            (progn (setq failed T)
              (prompt (strcat "\n[TNT] Loi xoa SOLID trong block: " (vl-catch-all-error-message result)))))))))
  (if failed
    (progn
      (foreach en sources
        (if (null (entget en))
          (if (null (entdel en)) (prompt "\n[TNT] Loi khoi phuc SOLID goc; hay UNDO."))))
      (foreach item TNT:AEC:EXTRACT-STAGED
        (if (not (vlax-erased-p item))
          (progn
            (setq rollback (vl-catch-all-apply 'vla-Delete (list item)))
            (if (vl-catch-all-error-p rollback)
              (prompt (strcat "\n[TNT] Loi don ban sao; hay UNDO: " (vl-catch-all-error-message rollback)))))))
      (list 0 (length TNT:AEC:EXTRACT-JOBS)))
    (list (length TNT:AEC:EXTRACT-JOBS) 0)))

(defun TNT:AEC:SOLIDS-TO-TOP-IN-BLOCK (block objects / dictionary sortents array)
  (setq dictionary (vla-GetExtensionDictionary block))
  (if (dictsearch (vlax-vla-object->ename dictionary) "ACAD_SORTENTS")
    (setq sortents (vla-GetObject dictionary "ACAD_SORTENTS"))
    (setq sortents (vla-AddObject dictionary "ACAD_SORTENTS" "AcDbSortentsTable")))
  (setq array (vlax-make-safearray vlax-vbObject (cons 0 (1- (length objects)))))
  (vlax-safearray-fill array objects)
  (vla-MoveToTop sortents array))

(defun TNT:AEC:SOLIDS-TO-TOP (/ doc block obj objects result moved failed)
  ;; Sort only surviving SOLID hatches, within each owning space/definition.
  ;; External references are not edited; nested definitions are visited once.
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)) moved 0 failed 0)
  (vlax-for block (vla-get-Blocks doc)
    (if (TNT:AEC:EDITABLE-BLOCK-P block)
      (progn
        (setq objects nil)
        (vlax-for obj block
          (if (and (= (vla-get-ObjectName obj) "AcDbHatch")
                   (= (strcase (vla-get-PatternName obj)) "SOLID"))
            (setq objects (cons obj objects))))
        (if objects
          (progn
            (setq result (vl-catch-all-apply 'TNT:AEC:SOLIDS-TO-TOP-IN-BLOCK
                           (list block (reverse objects))))
            (if (vl-catch-all-error-p result)
              (progn
                (setq failed (+ failed (length objects)))
                (prompt (strcat "\n[TNT] Loi dua SOLID len tren trong "
                                (vla-get-Name block) ": " (vl-catch-all-error-message result))))
              (setq moved (+ moved (length objects)))))))))
  (vla-Regen doc 1)
  (list moved failed))

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

(defun C:TNT_ACAD (/ *error* olderror wallcount normalized textColors solid17 solidOrder
                    extracted doc layer lockedLayers undoStarted)
  (setq olderror *error*)
  (defun *error* (msg)
    (foreach layer lockedLayers (vla-put-Lock layer :vlax-true))
    (if undoStarted (vla-EndUndoMark doc))
    (setq *error* olderror)
    (if (and msg
             (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*BREAK*")))
      (prompt (strcat "\n[TNT] Loi khi goi -AECOBJEXPLODE: " msg))
    )
    (princ)
  )

  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-StartUndoMark doc)
  (setq undoStarted T)
  (TNT:AEC:RUN-SETTING-0)
  ;; Source layers may be locked. Restore their lock states on completion/error.
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vlax-for layer (vla-get-Layers doc)
    (if (and (= (vla-get-Lock layer) :vlax-true)
             (not (wcmatch (vla-get-Name layer) "*|*")))
      (progn
        (setq lockedLayers (cons layer lockedLayers))
        (vla-put-Lock layer :vlax-false))))
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
      (command "_.-AECOBJEXPLODE")
      (TNT:AEC:ACCEPT-DEFAULTS)
    )
  )
  ;; Include native hatches produced by the AEC conversion, before recoloring.
  (setq solid17 (TNT:AEC:DELETE-SOLID-17))
  (prompt (strcat "\n[TNT] Da xoa SOLID hatch mau ACI 17: " (itoa (car solid17))
                 "; khong xoa duoc: " (itoa (cadr solid17)) "."))
  (setq normalized (TNT:AEC:NORMALIZE-DRAWING))
  (prompt
    (strcat
      "\n[TNT] Da chuyen " (itoa (car normalized)) " doi tuong ve layer "
      TNT:AEC:TARGET-LAYER
      ". Layer va doi tuong mau 250, Continuous, net manh 0.15 mm"
      " (tat ca SOLID hatch doi thanh 251); giu nguyen Linetype va LinetypeScale. Khong doi duoc: "
      (itoa (cadr normalized)) "."
      " Layer khac da doi mau 250: " (itoa (car (caddr normalized)))
      "; khong doi duoc: " (itoa (cadr (caddr normalized))) "."
      " Dimension bo qua chuan hoa layer: " (itoa (cadddr normalized)) "."
      " Text/Attribute bo qua chuan hoa layer: " (itoa (car (cddddr normalized))) "."
    )
  )
  (setq textColors (TNT:AEC:COLOR-ALL-TEXT))
  (prompt (strcat "\n[TNT] Text/Attribute va chu Dimension doi mau 251: "
                 (itoa (car textColors)) "; loi: " (itoa (cadr textColors))
                 ". Chi doi mau chu, giu nguyen cac thuoc tinh khac."))
  (setq extracted (TNT:AEC:EXTRACT-SOLIDS))
  (prompt (strcat "\n[TNT] SOLID tach ra Model/Layout: " (itoa (car extracted))
                 "; chua tach duoc: " (itoa (cadr extracted)) "."))
  (setq solidOrder (TNT:AEC:SOLIDS-TO-TOP))
  (prompt (strcat "\n[TNT] SOLID hatch con lai dua len tren cung: " (itoa (car solidOrder))
                 "; khong dua len duoc: " (itoa (cadr solidOrder)) "."))
  (foreach layer lockedLayers (vla-put-Lock layer :vlax-true))
  (setq lockedLayers nil)
  (vla-EndUndoMark doc)
  (setq undoStarted nil)
  (setq *error* olderror)
  (princ)
)

(princ "\n[TNT] Loaded TNT_AEC_TO_ACAD.lsp - Command: TNT_ACAD")
(princ)
