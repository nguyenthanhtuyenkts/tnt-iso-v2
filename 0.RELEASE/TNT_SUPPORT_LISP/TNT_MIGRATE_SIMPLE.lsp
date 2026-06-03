;;; ====================================================================================================
;;; TNT_MIGRATE_SIMPLE.lsp
;;; Run command TNT_MIGRATE_SIMPLE to move old V16 layers to TNT ISO layers immediately.
;;; No preview. No report. Layers not listed here are unchanged.
;;; Also migrates entities inside block definitions, then deletes old layers when AutoCAD allows it.
;;; Run command TNT_MIGRATE_SELECTION to migrate only selected top-level objects.
;;; ====================================================================================================

(vl-load-com)

(defun TNT:V16S:MAP-GROUPS (/)
  '(
    ("....01_TNT_A_DRAWING"
      ("...0_TNT_LINE_NAME"
       "...01_010_A_DRAWING"
       "0_TNT-KHUNGTEN"))
    ("....02_TNT_A_VIRTURAL"
      ("...4_TNT_LINE_VIRTURAL"
       "4_TNT_LINE_VIRTURAL"
       "TNT-Virtural"))
    ("....03_TNT_A_THIN"
      ("...5_TNT_LINE_THIN"))
    ("....04_TNT_A_HIDDEN"
      ("...6_TNT_LINE_HIDDEN"
       "6_TNT_LINE_HIDDEN"
       "TNT-Hidden N"))
    ("....05_TNT_A_SECTION"
      ("...3_TNT_LINE_SECTION"
       "...05_010_A_SECTION"
       "TNT-Net Cat"))
    ("....06_TNT_A_SECTION-LINE"
      ("3_TNT_LINE_SECTION"
       "...17_TNT_SECTION_LINE"))
    ("....07_TNT_A_BASE"
      ("...7_TNT_LINE_BASE"
       "...07_010_A_BASE"
       "7_TNT_LINE_BASE"))
    ("....08_TNT_A_DETAIL"
      ("...16_TNT_LINE_DETAIL"
       "16_TNT_LINE_DETAIL"))
    ("....10_TNT_A_COTE"
      ("...21_TNT_LINE_COTE"))
    ("....11_TNT_A_PLOT"
      ("...19_TNT_LINE_LAYOUT"))
    ("....12_TNT_F_FURNITURE"
      ("...8_TNT_LINE_FUNITURE"
       "A-Noithat"
       "FF-FURN"
       "TNT-Funiture"))
    ("....13_TNT_F_TREE"
      ("...13_TNT_LINE_TREE"))
    ("....14_TNT_F_GLASS"
      ("14_TNT _LINE_GLASSE"))
    ("....15_TNT_F_DOOR"
      ("...15_TNT_LINE_DOOR"
       "15_TNT_LINE_DOOR"
       "TNT-Door"))
    ("....16_TNT_S_CONCRETE"
      ("TNT-Concrete"))
    ("....17_TNT_S_WALL"
      ("...2_TNT_LINE_WALL"
       "2_TNT_LINE_WALL"
       "H-WALL"
       "TNT-Walls"))
    ("....20_TNT_N_TEXT"
      ("...9_TNT_LINE_TEXT"))
    ("....22_TNT_N_DIMENSION"
      ("...11_TNT_LINE_DIMENSION"
       "11_TNT_LINE_DIMENSION"))
    ("....23_TNT_N_HATCH"
      ("...10_TNT_LINE_HATCH"
       "...21_010_N_HATCH"
       "TNT-Hatch"))
    ("....24_TNT_N_ANNOTATE"
      ("...12_TNT_LINE_ANNOTATE"
       "12_TNT_LINE_ANNOTATE"))
    ("....26_TNT_M_TEXT"
      ("...18_TNT_N_TEXT"
       "TNT-Text"))
  )
)

(defun TNT:V16S:MAP (/ group oldLayer result)
  (setq result nil)
  (foreach group (TNT:V16S:MAP-GROUPS)
    (foreach oldLayer (cadr group)
      (setq result (cons (list oldLayer (car group)) result))
    )
  )
  (reverse result)
)

(defun TNT:V16S:LAYER-OBJ (name / doc layers result)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq layers (vla-get-Layers doc))
  (setq result (vl-catch-all-apply 'vla-Item (list layers name)))
  (if (vl-catch-all-error-p result) nil result)
)

(defun TNT:V16S:ENSURE-LAYER (name / doc layers layerObj)
  (setq layerObj (TNT:V16S:LAYER-OBJ name))
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

(defun TNT:V16S:UNLOCK (name / layerObj)
  (setq layerObj (TNT:V16S:ENSURE-LAYER name))
  (if layerObj
    (progn
      (vl-catch-all-apply 'vla-put-LayerOn (list layerObj :vlax-true))
      (vl-catch-all-apply 'vla-put-Freeze (list layerObj :vlax-false))
      (vl-catch-all-apply 'vla-put-Lock (list layerObj :vlax-false))
    )
  )
  (princ)
)

(defun TNT:V16S:MOVE (oldLayer newLayer / ss n)
  (TNT:V16S:UNLOCK oldLayer)
  (TNT:V16S:UNLOCK newLayer)
  (setq ss (ssget "_X" (list (cons 8 oldLayer))))
  (if ss
    (progn
      (setq n (sslength ss))
      (command-s "_.CHPROP" ss "" "_LA" newLayer "")
      n
    )
    0
  )
)

(defun TNT:V16S:MOVE-BLOCK-DEFS (oldLayer newLayer / doc blocks block obj count objLayer)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq blocks (vla-get-Blocks doc))
  (setq count 0)
  (TNT:V16S:UNLOCK oldLayer)
  (TNT:V16S:UNLOCK newLayer)
  (vlax-for block blocks
    (if (and (= :vlax-false (vla-get-IsLayout block))
             (= :vlax-false (vla-get-IsXRef block)))
      (vlax-for obj block
        (setq objLayer (vl-catch-all-apply 'vla-get-Layer (list obj)))
        (if (and (not (vl-catch-all-error-p objLayer))
                 (= (strcase objLayer) (strcase oldLayer)))
          (if (not (vl-catch-all-error-p
                     (vl-catch-all-apply 'vla-put-Layer (list obj newLayer))))
            (setq count (1+ count))
          )
        )
      )
    )
  )
  count
)

(defun TNT:V16S:PURGE-OLD-LAYER (oldLayer newLayer / layerObj result)
  (setq layerObj (TNT:V16S:LAYER-OBJ oldLayer))
  (if layerObj
    (progn
      (TNT:V16S:UNLOCK oldLayer)
      (if (= (strcase (getvar "CLAYER")) (strcase oldLayer))
        (vl-catch-all-apply 'setvar (list "CLAYER" newLayer))
      )
      (setq result (vl-catch-all-apply 'vla-Delete (list layerObj)))
      (not (vl-catch-all-error-p result))
    )
    nil
  )
)

(defun TNT:V16S:TARGET-LAYER (layerName / pair result)
  (setq result nil)
  (foreach pair (TNT:V16S:MAP)
    (if (= (strcase layerName) (strcase (car pair)))
      (setq result (cadr pair))
    )
  )
  result
)

(defun TNT:V16S:RUN-SELECTION (/ oldcmdecho ss i ent obj oldLayer newLayer changed skipped failed)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setq ss (ssget))
  (if ss
    (progn
      (command-s "_.UNDO" "_BE")
      (setq i 0 changed 0 skipped 0 failed 0)
      (while (setq ent (ssname ss i))
        (setq obj (vlax-ename->vla-object ent))
        (setq oldLayer (vl-catch-all-apply 'vla-get-Layer (list obj)))
        (if (vl-catch-all-error-p oldLayer)
          (setq failed (1+ failed))
          (progn
            (setq newLayer (TNT:V16S:TARGET-LAYER oldLayer))
            (if newLayer
              (progn
                (TNT:V16S:UNLOCK oldLayer)
                (TNT:V16S:UNLOCK newLayer)
                (if (not (vl-catch-all-error-p
                           (vl-catch-all-apply 'vla-put-Layer (list obj newLayer))))
                  (setq changed (1+ changed))
                  (setq failed (1+ failed))
                )
              )
              (setq skipped (1+ skipped))
            )
          )
        )
        (setq i (1+ i))
      )
      (command-s "_.UNDO" "_END")
      (princ
        (strcat
          "\n[TNT] DONE SELECTION MIGRATE. Changed: "
          (itoa changed)
          ". Skipped: "
          (itoa skipped)
          ". Failed: "
          (itoa failed)
          "."
        )
      )
    )
    (princ "\n[TNT] No objects selected.")
  )
  (setvar "CMDECHO" oldcmdecho)
  (princ)
)

(defun TNT:V16S:RUN (/ oldcmdecho pair total totalBlocks count blockCount deleted deleteCount)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command-s "_.UNDO" "_BE")
  (setq total 0)
  (setq totalBlocks 0)
  (setq deleteCount 0)
  (foreach pair (TNT:V16S:MAP)
    (setq count (TNT:V16S:MOVE (car pair) (cadr pair)))
    (setq blockCount (TNT:V16S:MOVE-BLOCK-DEFS (car pair) (cadr pair)))
    (setq total (+ total count))
    (setq totalBlocks (+ totalBlocks blockCount))
    (setq deleted (TNT:V16S:PURGE-OLD-LAYER (car pair) (cadr pair)))
    (if deleted
      (setq deleteCount (1+ deleteCount))
    )
    (if (or (> count 0) (> blockCount 0) deleted)
      (princ
        (strcat
          "\n[TNT] "
          (car pair)
          " -> "
          (cadr pair)
          " : "
          (itoa count)
          " direct, "
          (itoa blockCount)
          " in blocks"
          (if deleted " | old layer deleted" "")
        )
      )
    )
  )
  (command-s "_.UNDO" "_END")
  (setvar "CMDECHO" oldcmdecho)
  (princ
    (strcat
      "\n[TNT] DONE V16 SIMPLE MIGRATE. Objects changed: "
      (itoa total)
      " direct, "
      (itoa totalBlocks)
      " in blocks. Old layers deleted: "
      (itoa deleteCount)
    )
  )
  (princ)
)

(defun c:TNT_MIGRATE_SIMPLE (/)
  (TNT:V16S:RUN)
)

(defun c:TNT_MIGRATE_SELECTION (/)
  (TNT:V16S:RUN-SELECTION)
)

(princ "\n[TNT] Loaded TNT_MIGRATE_SIMPLE.lsp. Commands: TNT_MIGRATE_SIMPLE, TNT_MIGRATE_SELECTION")
(princ)
