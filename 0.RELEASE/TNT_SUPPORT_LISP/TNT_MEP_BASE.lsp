;;; ====================================================================================================
;;; TNT_MEP_BASE.lsp
;;; Run command TNT_MEP_BASE, select block references and/or loose objects, then this tool:
;;; - For block references, creates an independent block definition named with prefix .TNT_MEP_BASE...
;;;   and points only the selected block reference to that new definition when possible.
;;; - Moves editable objects to layer ....46_TNT_BASE_MEP, including AEC objects that expose Layer.
;;; - Forces editable object color to ByLayer.
;;; - For AEC Wall objects, tries to change style to .TNT_A_WALL_COMPLETE-01.
;;;   After that, changes wall justification from Baseline to Center only; other justifications stay unchanged.
;;; - Blocks named ...TNT_COT_1 / ....TNT_COT_1 are exploded and processed even when nested inside other blocks.
;;;   All hatches inside those blocks are deleted.
;;; This file is standalone and uses only the TNT:MEPB namespace.
;;; ====================================================================================================

(vl-load-com)

(setq TNT:MEPB:TARGET-LAYER "....46_TNT_BASE_MEP")
(setq TNT:MEPB:PREFIX ".TNT_MEP_BASE")
(setq TNT:MEPB:COLOR-BYLAYER 256)
(setq TNT:MEPB:AEC-WALL-STYLE ".TNT_A_WALL_COMPLETE-01")
(setq TNT:MEPB:AEC-WALL-JUSTIFY-BASELINE "Baseline")
(setq TNT:MEPB:AEC-WALL-JUSTIFY-CENTER "Center")
(setq TNT:MEPB:EXPLODE-REBLOCK-NAMES '("...TNT_COT_1" "....TNT_COT_1"))

(defun TNT:MEPB:LAYER-OBJ (name / doc layers result)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq layers (vla-get-Layers doc))
  (setq result (vl-catch-all-apply 'vla-Item (list layers name)))
  (if (vl-catch-all-error-p result) nil result)
)

(defun TNT:MEPB:ENSURE-LAYER (name / doc layers layerObj)
  (setq layerObj (TNT:MEPB:LAYER-OBJ name))
  (if (null layerObj)
    (progn
      (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq layers (vla-get-Layers doc))
      (setq layerObj (vl-catch-all-apply 'vla-Add (list layers name)))
      (if (vl-catch-all-error-p layerObj)
        (setq layerObj nil)
      )
    )
  )
  layerObj
)

(defun TNT:MEPB:UNLOCK (name / layerObj)
  (setq layerObj (TNT:MEPB:ENSURE-LAYER name))
  (if layerObj
    (progn
      (vl-catch-all-apply 'vla-put-LayerOn (list layerObj :vlax-true))
      (vl-catch-all-apply 'vla-put-Freeze (list layerObj :vlax-false))
      (vl-catch-all-apply 'vla-put-Lock (list layerObj :vlax-false))
    )
  )
  layerObj
)

(defun TNT:MEPB:BLOCK-OBJ (name / doc blocks result)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq blocks (vla-get-Blocks doc))
  (setq result (vl-catch-all-apply 'vla-Item (list blocks name)))
  (if (vl-catch-all-error-p result) nil result)
)

(defun TNT:MEPB:OBJECT-NAME (obj / result)
  (setq result (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
  (if (vl-catch-all-error-p result) "" result)
)

(defun TNT:MEPB:BLOCK-REFERENCE-P (obj / objectName)
  (setq objectName (TNT:MEPB:OBJECT-NAME obj))
  (= objectName "AcDbBlockReference")
)

(defun TNT:MEPB:NORMALIZE-NAME (name /)
  (strcase (vl-string-trim " \t\r\n\"" (vl-princ-to-string name)))
)

(defun TNT:MEPB:EXPLODE-REBLOCK-P (name / target result)
  (setq result nil)
  (foreach target TNT:MEPB:EXPLODE-REBLOCK-NAMES
    (if (= (TNT:MEPB:NORMALIZE-NAME name) (TNT:MEPB:NORMALIZE-NAME target))
      (setq result T)
    )
  )
  result
)

(defun TNT:MEPB:EFFECTIVE-NAME (obj / result)
  (setq result (vl-catch-all-apply 'vla-get-EffectiveName (list obj)))
  (if (vl-catch-all-error-p result)
    (vla-get-Name obj)
    result
  )
)

(defun TNT:MEPB:SANITIZE-NAME (name / invalid i ch out)
  (setq invalid "\\/:*?\"<>|,;=")
  (setq i 1 out "")
  (while (<= i (strlen name))
    (setq ch (substr name i 1))
    (if (vl-string-search ch invalid)
      (setq out (strcat out "_"))
      (setq out (strcat out ch))
    )
    (setq i (1+ i))
  )
  out
)

(defun TNT:MEPB:UNIQUE-NAME (base / name n)
  (setq name base)
  (setq n 1)
  (while (tblsearch "BLOCK" name)
    (setq name (strcat base "_" (itoa n)))
    (setq n (1+ n))
  )
  name
)

(defun TNT:MEPB:VARIANT->LIST (value / data)
  (setq data (vlax-variant-value value))
  (cond
    ((= (type data) 'SAFEARRAY) (vlax-safearray->list data))
    ((listp data) data)
    (T nil)
  )
)

(defun TNT:MEPB:POINT->LIST (value / data)
  (setq data (vl-catch-all-apply 'vlax-variant-value (list value)))
  (if (vl-catch-all-error-p data)
    nil
    (if (= (type data) 'SAFEARRAY)
      (vlax-safearray->list data)
      data
    )
  )
)

(defun TNT:MEPB:INSERTION-POINT (obj / value point)
  (setq value (vl-catch-all-apply 'vla-get-InsertionPoint (list obj)))
  (if (vl-catch-all-error-p value)
    '(0.0 0.0 0.0)
    (progn
      (setq point (TNT:MEPB:POINT->LIST value))
      (if point point '(0.0 0.0 0.0))
    )
  )
)

(defun TNT:MEPB:OBJECTS->SS (objects / ss ent)
  (setq ss (ssadd))
  (foreach obj objects
    (setq ent (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
    (if (not (vl-catch-all-error-p ent))
      (ssadd ent ss)
    )
  )
  ss
)

(defun TNT:MEPB:EXPLODE-OBJECTS (obj / result objects)
  (setq result (vl-catch-all-apply 'vla-Explode (list obj)))
  (if (vl-catch-all-error-p result)
    nil
    (progn
      (setq objects (TNT:MEPB:VARIANT->LIST result))
      (if objects objects nil)
    )
  )
)

(defun TNT:MEPB:APPLY-ISO-TO-OBJECTS (objects / obj changed failed)
  (setq changed 0 failed 0)
  (foreach obj objects
    (if (TNT:MEPB:PUT-ISO-PROPS obj TNT:MEPB:TARGET-LAYER)
      (setq changed (1+ changed))
      (setq failed (1+ failed))
    )
  )
  (list changed failed)
)

(defun TNT:MEPB:HATCH-P (obj / objectName ent data dxfType)
  (setq objectName (strcase (TNT:MEPB:OBJECT-NAME obj)))
  (if (= objectName "ACDBHATCH")
    T
    (progn
      (setq ent (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (vl-catch-all-error-p ent)
        nil
        (progn
          (setq data (entget ent))
          (setq dxfType (cdr (assoc 0 data)))
          (and dxfType (= (strcase dxfType) "HATCH"))
        )
      )
    )
  )
)

(defun TNT:MEPB:DELETE-HATCHES (objects / obj kept deleted failed result)
  (setq kept nil deleted 0 failed 0)
  (foreach obj objects
    (if (TNT:MEPB:HATCH-P obj)
      (progn
        (setq result (vl-catch-all-apply 'vla-Delete (list obj)))
        (if (vl-catch-all-error-p result)
          (progn
            (setq kept (cons obj kept))
            (setq failed (1+ failed))
          )
          (setq deleted (1+ deleted))
        )
      )
      (setq kept (cons obj kept))
    )
  )
  (list (reverse kept) deleted failed)
)

(defun TNT:MEPB:COPY-BLOCK-CONTENTS (sourceBlock targetBlock / doc items arr idx result copied)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq items nil)
  (vlax-for obj sourceBlock
    (setq items (cons obj items))
  )
  (if items
    (progn
      (setq arr (vlax-make-safearray vlax-vbObject (cons 0 (1- (length items)))))
      (setq idx 0)
      (foreach obj (reverse items)
        (vlax-safearray-put-element arr idx obj)
        (setq idx (1+ idx))
      )
      (setq result
        (vl-catch-all-apply
          'vla-CopyObjects
          (list doc arr targetBlock)
        )
      )
      (if (vl-catch-all-error-p result)
        nil
        (progn
          (setq copied (TNT:MEPB:VARIANT->LIST result))
          (if copied copied T)
        )
      )
    )
    T
  )
)

(defun TNT:MEPB:MAKE-PRIVATE-BLOCK (sourceName / doc blocks sourceBlock targetName targetBlock)
  (setq sourceBlock (TNT:MEPB:BLOCK-OBJ sourceName))
  (if (and sourceBlock
           (= :vlax-false (vla-get-IsLayout sourceBlock))
           (= :vlax-false (vla-get-IsXRef sourceBlock)))
    (progn
      (setq doc        (vla-get-ActiveDocument (vlax-get-acad-object)))
      (setq blocks     (vla-get-Blocks doc))
      (setq targetName
        (TNT:MEPB:UNIQUE-NAME
          (strcat
            TNT:MEPB:PREFIX
            "..."
            (TNT:MEPB:SANITIZE-NAME sourceName)
          )
        )
      )
      (setq targetBlock (vl-catch-all-apply 'vla-Add (list blocks (vlax-3d-point '(0.0 0.0 0.0)) targetName)))
      (if (vl-catch-all-error-p targetBlock)
        nil
        (if (TNT:MEPB:COPY-BLOCK-CONTENTS sourceBlock targetBlock)
          (list targetName targetBlock)
          nil
        )
      )
    )
    nil
  )
)

(defun TNT:MEPB:PUT-LAYER (obj layerName / result ent data)
  (setq result (vl-catch-all-apply 'vla-put-Layer (list obj layerName)))
  (if (vl-catch-all-error-p result)
    (progn
      (setq ent (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (vl-catch-all-error-p ent)
        nil
        (progn
          (setq data (entget ent))
          (if (assoc 8 data)
            (setq data (subst (cons 8 layerName) (assoc 8 data) data))
            (setq data (append data (list (cons 8 layerName))))
          )
          (not (null (entmod data)))
        )
      )
    )
    T
  )
)

(defun TNT:MEPB:STRIP-DXF-COLOR-OVERRIDES (data / item result)
  (setq result nil)
  (foreach item data
    (if (not (member (car item) '(420 430 440)))
      (setq result (cons item result))
    )
  )
  (reverse result)
)

(defun TNT:MEPB:PUT-COLOR-BYLAYER (obj / result ent data)
  (setq result (vl-catch-all-apply 'vla-put-Color (list obj TNT:MEPB:COLOR-BYLAYER)))
  (if (vl-catch-all-error-p result)
    (progn
      (setq ent (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (vl-catch-all-error-p ent)
        nil
        (progn
          (setq data (TNT:MEPB:STRIP-DXF-COLOR-OVERRIDES (entget ent)))
          (if (assoc 62 data)
            (setq data (subst (cons 62 TNT:MEPB:COLOR-BYLAYER) (assoc 62 data) data))
            (setq data (append data (list (cons 62 TNT:MEPB:COLOR-BYLAYER))))
          )
          (not (null (entmod data)))
        )
      )
    )
    T
  )
)

(defun TNT:MEPB:AEC-WALL-P (obj / objectName ent data dxfType)
  (setq objectName (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
  (if (and (not (vl-catch-all-error-p objectName))
           (vl-string-search "WALL" (strcase objectName))
           (or (vl-string-search "AEC" (strcase objectName))
               (vl-string-search "ARCH" (strcase objectName))))
    T
    (progn
      (setq ent (vl-catch-all-apply 'vlax-vla-object->ename (list obj)))
      (if (vl-catch-all-error-p ent)
        nil
        (progn
          (setq data (entget ent))
          (setq dxfType (cdr (assoc 0 data)))
          (and dxfType
               (vl-string-search "WALL" (strcase dxfType))
               (or (vl-string-search "AEC" (strcase dxfType))
                   (vl-string-search "ARCH" (strcase dxfType))))
        )
      )
    )
  )
)

(defun TNT:MEPB:STRIP (text /)
  (vl-string-trim " \t\r\n\"" text)
)

(defun TNT:MEPB:GET-PROP (obj prop / result)
  (setq result (vl-catch-all-apply 'vlax-get-property (list obj prop)))
  (if (vl-catch-all-error-p result) nil result)
)

(defun TNT:MEPB:PUT-PROP (obj prop value / result)
  (setq result (vl-catch-all-apply 'vlax-put-property (list obj prop value)))
  (not (vl-catch-all-error-p result))
)

(defun TNT:MEPB:BASELINE-JUSTIFICATION-P (value / text)
  (setq text (strcase (TNT:MEPB:STRIP (vl-princ-to-string value))))
  (or (= text "BASELINE")
      (= text (strcase TNT:MEPB:AEC-WALL-JUSTIFY-BASELINE)))
)

(defun TNT:MEPB:PUT-WALL-CENTER-IF-BASELINE (obj / just)
  (if (vlax-property-available-p obj 'Justification T)
    (progn
      (setq just (TNT:MEPB:GET-PROP obj 'Justification))
      (if (and just (TNT:MEPB:BASELINE-JUSTIFICATION-P just))
        (TNT:MEPB:PUT-PROP obj 'Justification TNT:MEPB:AEC-WALL-JUSTIFY-CENTER)
        T
      )
    )
    T
  )
)

(defun TNT:MEPB:PUT-AEC-WALL-STYLE (obj / result justifyOk)
  (if (TNT:MEPB:AEC-WALL-P obj)
    (progn
      (setq result (vl-catch-all-apply 'vla-put-StyleName (list obj TNT:MEPB:AEC-WALL-STYLE)))
      (setq justifyOk (TNT:MEPB:PUT-WALL-CENTER-IF-BASELINE obj))
      (and (not (vl-catch-all-error-p result)) justifyOk)
    )
    T
  )
)

(defun TNT:MEPB:PUT-ISO-PROPS (obj layerName / layerOk colorOk styleOk)
  (setq layerOk (TNT:MEPB:PUT-LAYER obj layerName))
  (setq colorOk (TNT:MEPB:PUT-COLOR-BYLAYER obj))
  (setq styleOk (TNT:MEPB:PUT-AEC-WALL-STYLE obj))
  (and layerOk colorOk styleOk)
)

(defun TNT:MEPB:MOVE-BLOCK-CONTENTS-REC (block layerName depth / obj objectName nested made nestedName nestedBlock setNameResult counts changed failed skipCurrent)
  (setq changed 0 failed 0)
  (vlax-for obj block
    (setq skipCurrent nil)
    (setq objectName (vl-catch-all-apply 'vla-get-ObjectName (list obj)))
    (if (and (> depth 0)
             (not (vl-catch-all-error-p objectName))
             (= objectName "AcDbBlockReference"))
      (progn
        (setq nested (TNT:MEPB:EFFECTIVE-NAME obj))
        (if (TNT:MEPB:EXPLODE-REBLOCK-P nested)
          (progn
            (setq counts (TNT:MEPB:PROCESS-NESTED-EXPLODE obj nested))
            (setq changed (+ changed (car counts)))
            (setq failed  (+ failed  (cadr counts)))
            (setq skipCurrent T)
          )
          (progn
            (setq made (TNT:MEPB:MAKE-PRIVATE-BLOCK nested))
            (if made
              (progn
                (setq nestedName  (car made))
                (setq nestedBlock (cadr made))
                (setq setNameResult (vl-catch-all-apply 'vla-put-Name (list obj nestedName)))
                (if (not (vl-catch-all-error-p setNameResult))
                  (progn
                    (setq counts (TNT:MEPB:MOVE-BLOCK-CONTENTS-REC nestedBlock layerName (1- depth)))
                    (setq changed (+ changed (car counts)))
                    (setq failed  (+ failed  (cadr counts)))
                  )
                )
              )
            )
          )
        )
      )
    )
    (if (not skipCurrent)
      (if (TNT:MEPB:PUT-ISO-PROPS obj layerName)
        (setq changed (1+ changed))
        (setq failed (1+ failed))
      )
    )
  )
  (list changed failed)
)

(defun TNT:MEPB:MOVE-BLOCK-CONTENTS (block layerName /)
  (TNT:MEPB:MOVE-BLOCK-CONTENTS-REC block layerName 24)
)

(defun TNT:MEPB:SELECT-OBJECTS (/ ss)
  (setq ss (ssget "_I"))
  (if (null ss)
    (progn
      (princ "\nSelect blocks/objects for TNT_MEP_BASE: ")
      (setq ss (ssget))
    )
  )
  ss
)

(defun TNT:MEPB:REBLOCK-NAME (sourceName /)
  (TNT:MEPB:UNIQUE-NAME
    (strcat
      TNT:MEPB:PREFIX
      "..."
      (TNT:MEPB:SANITIZE-NAME sourceName)
    )
  )
)

(defun TNT:MEPB:PROCESS-EXPLODE-REBLOCK (obj oldName / basePt newName objects ss counts hatchResult deleted failedDelete)
  (setq basePt (TNT:MEPB:INSERTION-POINT obj))
  (setq newName (TNT:MEPB:REBLOCK-NAME oldName))
  (setq objects (TNT:MEPB:EXPLODE-OBJECTS obj))
  (if objects
    (progn
      (vl-catch-all-apply 'vla-Delete (list obj))
      (setq hatchResult (TNT:MEPB:DELETE-HATCHES objects))
      (setq objects (car hatchResult))
      (setq deleted (cadr hatchResult))
      (setq failedDelete (caddr hatchResult))
      (setq counts (TNT:MEPB:APPLY-ISO-TO-OBJECTS objects))
      (setq ss (TNT:MEPB:OBJECTS->SS objects))
      (if (> (sslength ss) 0)
        (progn
          (command-s "_.-BLOCK" newName basePt ss "")
          (command-s "_.-INSERT" newName basePt 1 1 0)
          (princ
            (strcat
              "\n[TNT] DONE TNT_MEP_BASE EXPLODE/REBLOCK: "
              oldName
              " -> "
              newName
              ". Objects moved to "
              TNT:MEPB:TARGET-LAYER
              ": "
              (itoa (car counts))
              ". Hatches deleted: "
              (itoa deleted)
              ". Failed: "
              (itoa (+ (cadr counts) failedDelete))
              "."
            )
          )
        )
        (princ "\n[TNT] Exploded block, but no valid objects were available to reblock.")
      )
    )
    (princ "\n[TNT] Cannot explode selected block for TNT_MEP_BASE.")
  )
)

(defun TNT:MEPB:PROCESS-NESTED-EXPLODE (obj oldName / objects counts hatchResult deleted failedDelete)
  (setq objects (TNT:MEPB:EXPLODE-OBJECTS obj))
  (if objects
    (progn
      (vl-catch-all-apply 'vla-Delete (list obj))
      (setq hatchResult (TNT:MEPB:DELETE-HATCHES objects))
      (setq objects (car hatchResult))
      (setq deleted (cadr hatchResult))
      (setq failedDelete (caddr hatchResult))
      (setq counts (TNT:MEPB:APPLY-ISO-TO-OBJECTS objects))
      (list (+ (car counts) deleted) (+ (cadr counts) failedDelete))
    )
    '(0 1)
  )
)

(defun TNT:MEPB:PROCESS-BLOCK (obj / oldName made newName newBlock setNameResult counts)
  (setq oldName (TNT:MEPB:EFFECTIVE-NAME obj))
  (if (TNT:MEPB:EXPLODE-REBLOCK-P oldName)
    (TNT:MEPB:PROCESS-EXPLODE-REBLOCK obj oldName)
    (progn
      (setq made (TNT:MEPB:MAKE-PRIVATE-BLOCK oldName))
      (if made
        (progn
          (setq newName  (car made))
          (setq newBlock (cadr made))
          (setq setNameResult (vl-catch-all-apply 'vla-put-Name (list obj newName)))
          (if (vl-catch-all-error-p setNameResult)
            (princ "\n[TNT] Cannot assign selected block to the new definition. Dynamic/anonymous blocks may need REFEDIT/BEDIT workflow.")
            (progn
              (TNT:MEPB:PUT-ISO-PROPS obj TNT:MEPB:TARGET-LAYER)
              (setq counts (TNT:MEPB:MOVE-BLOCK-CONTENTS newBlock TNT:MEPB:TARGET-LAYER))
              (vl-catch-all-apply 'vla-Update (list obj))
              (princ
                (strcat
                  "\n[TNT] DONE TNT_MEP_BASE BLOCK. New block: "
                  newName
                  ". Objects moved to "
                  TNT:MEPB:TARGET-LAYER
                  ": "
                  (itoa (car counts))
                  ". Color forced ByLayer. AEC Wall style target: "
                  TNT:MEPB:AEC-WALL-STYLE
                  ". Failed: "
                  (itoa (cadr counts))
                  "."
                )
              )
            )
          )
        )
        (princ "\n[TNT] Cannot create private block definition from the selected block.")
      )
    )
  )
)

(defun TNT:MEPB:PROCESS-OBJECT (obj / ok)
  (setq ok (TNT:MEPB:PUT-ISO-PROPS obj TNT:MEPB:TARGET-LAYER))
  (vl-catch-all-apply 'vla-Update (list obj))
  (if ok
    (princ
      (strcat
        "\n[TNT] DONE TNT_MEP_BASE OBJECT. Moved to "
        TNT:MEPB:TARGET-LAYER
        ". Color forced ByLayer. AEC Wall style target: "
        TNT:MEPB:AEC-WALL-STYLE
        "."
      )
    )
    (princ "\n[TNT] Object selected, but one or more properties could not be changed.")
  )
)

(defun TNT:MEPB:RUN (/ oldcmdecho ss i ent obj total)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command-s "_.UNDO" "_BE")
  (TNT:MEPB:UNLOCK TNT:MEPB:TARGET-LAYER)
  (setq ss (TNT:MEPB:SELECT-OBJECTS))
  (if ss
    (progn
      (setq i 0)
      (setq total (sslength ss))
      (while (< i total)
        (setq ent (ssname ss i))
        (setq obj (vlax-ename->vla-object ent))
        (if (TNT:MEPB:BLOCK-REFERENCE-P obj)
          (TNT:MEPB:PROCESS-BLOCK obj)
          (TNT:MEPB:PROCESS-OBJECT obj)
        )
        (setq i (1+ i))
      )
      (sssetfirst nil nil)
      (princ
        (strcat
          "\n[TNT] TNT_MEP_BASE selection processed: "
          (itoa total)
          " object(s)."
        )
      )
    )
    (princ "\n[TNT] Nothing selected.")
  )
  (command-s "_.UNDO" "_END")
  (setvar "CMDECHO" oldcmdecho)
  (princ)
)

(defun c:TNT_MEP_BASE ()
  (TNT:MEPB:RUN)
)

(princ "\n[TNT] Loaded TNT_MEP_BASE. Command: TNT_MEP_BASE")
(princ)
