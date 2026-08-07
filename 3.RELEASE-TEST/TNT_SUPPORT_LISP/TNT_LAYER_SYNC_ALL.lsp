;;; ====================================================================================================
;;; TNT_LAYER_SYNC_ALL.lsp
;;; Run command TNT_LAYER_SYNC_ALL to sync mapped layers to TNT ISO layers immediately.
;;; No preview. No report. Layers not listed in the mapping are unchanged.
;;; Also syncs entities inside block definitions, then deletes old layers when AutoCAD allows it.
;;; Run command TNT_LAYER_SYNC_SELECTION to sync selected top-level objects to mapped layers.
;;; ====================================================================================================

(vl-load-com)

(defun TNT:LAYER-SYNC:MAP-GROUPS (/)
  '(
    ;; ....01_TNT_A_DRAWING
    ("....01_TNT_A_DRAWING"
      ("...0_TNT_LINE_NAME"
       "...01_010_A_DRAWING"
       "0_TNT-KHUNGTEN"
       "KHUNG"
       "19_TNT_LAYOUT")
    )
    ;; ....02_TNT_A_VIRTURAL
    ("....02_TNT_A_VIRTURAL"
      ("...4_TNT_LINE_VIRTURAL"
       "4_TNT_LINE_VIRTURAL"
       "TNT-Virtural"
       "...20_TNT_LINE_COMPLETE"
       "LC-NETTHAY"
       "20_TNT_COMPLETE"
       "3.Net.Thay.KT")
    )
    ;; ....03_TNT_A_THIN
    ("....03_TNT_A_THIN"
      ("...5_TNT_LINE_THIN"
       "LC-LOPTRAT"
       "5_TNT_LINE_THIN")
    )
    ;; ....04_TNT_A_HIDDEN
    ("....04_TNT_A_HIDDEN"
      ("...6_TNT_LINE_HIDDEN"
       "6_TNT_LINE_HIDDEN"
       "TNT-Hidden N")
    )
    ;; ....05_TNT_A_SECTION
    ("....05_TNT_A_SECTION"
      ("...3_TNT_LINE_SECTION"
       "...05_010_A_SECTION"
       "TNT-Net Cat"
       "3_TNT_LINE_SECTION")
    )
    ;; ....06_TNT_A_SECTION-LINE
    ("....06_TNT_A_SECTION-LINE"
      ("3_TNT_LINE_SECTION"
       "...17_TNT_SECTION_LINE"
       "17_TNT_SECTION_LINE")
    )
    ;; ....07_TNT_A_BASE
    ("....07_TNT_A_BASE"
      ("...7_TNT_LINE_BASE"
       "...07_010_A_BASE"
       "7_TNT_LINE_BASE")
    )
    ;; ....08_TNT_A_DETAIL
    ("....08_TNT_A_DETAIL"
      ("...16_TNT_LINE_DETAIL"
       "16_TNT_LINE_DETAIL")
    )
    ;; ....10_TNT_A_COTE
    ("....10_TNT_A_COTE"
      ("...21_TNT_LINE_COTE"
       "21_TNT_COTE")
    )
    ;; ....11_TNT_A_PLOT
    ("....11_TNT_A_PLOT"
      ("...19_TNT_LINE_LAYOUT"
       "IN")
    )
    ;; ....12_TNT_F_FURNITURE
    ("....12_TNT_F_FURNITURE"
      ("...8_TNT_LINE_FUNITURE"
       "A-Noithat"
       "FF-FURN"
       "TNT-Funiture"
       "8_TNT_LINE_FUNITURE"
       "LC-NOITHAT")
    )
    ;; ....13_TNT_F_TREE
    ("....13_TNT_F_TREE"
      ("...13_TNT_LINE_TREE"
       "13_TNT_LINE_TREE")
    )
    ;; ....14_TNT_F_GLASS
    ("....14_TNT_F_GLASS"
      ("14_TNT _LINE_GLASSE"
       "...14_TNT_LINE_GLASSE"
       "A-Glaz")
    )
    ;; ....15_TNT_F_DOOR
    ("....15_TNT_F_DOOR"
      ("...15_TNT_LINE_DOOR"
       "15_TNT_LINE_DOOR"
       "TNT-Door"
       "A-Door"
       "LC-CUA"
       "CC01$0$A-Cua")
    )
    ;; ....16_TNT_S_CONCRETE
    ("....16_TNT_S_CONCRETE"
      ("TNT-Concrete"
       "1_TNT_LINE_CONCRETE")
    )
    ;; ....17_TNT_S_WALL
    ("....17_TNT_S_WALL"
      ("...2_TNT_LINE_WALL"
       "2_TNT_LINE_WALL"
       "H-WALL"
       "TNT-Walls"
       "A-Wall-G")
    )
    ;; ....20_TNT_N_TEXT
    ("....20_TNT_N_TEXT"
      ("...9_TNT_LINE_TEXT"
       "TNT-Text"
       "H_text"
       "VTSDD"
       "9_TNT_LINE_TEXT"
       "18_TNT_LINE_TITLE"
       "LC-TEXT")
    )
    ;; ....22_TNT_N_DIMENSION
    ("....22_TNT_N_DIMENSION"
      ("...11_TNT_LINE_DIMENSION"
       "11_TNT_LINE_DIMENSION"
       "TNT-Dimention")
    )
    ;; ....23_TNT_N_HATCH
    ("....23_TNT_N_HATCH"
      ("...10_TNT_LINE_HATCH"
       "...21_010_N_HATCH"
       "TNT-Hatch"
       "10_TNT_LINE_HATCH")
    )
    ;; ....24_TNT_N_ANNOTATE
    ("....24_TNT_N_ANNOTATE"
      ("...12_TNT_LINE_ANNOTATE"
       "12_TNT_LINE_ANNOTATE"
       "G-Anno-Nplt"
       "A-Anno-Scrn"
       "Aec-AnnotationNonPlot-T")
    )
    ;; ....26_TNT_M_TEXT
    ("....26_TNT_M_TEXT"
      ("...18_TNT_N_TEXT"
       "TNT-Text"
       "...9_TNT_LINE_TEXT")
    )
  )
)

(defun TNT:LAYER-SYNC:MAP (/ group oldLayer result)
  (setq result nil)
  (foreach group (TNT:LAYER-SYNC:MAP-GROUPS)
    (foreach oldLayer (cadr group)
      (setq result (cons (list oldLayer (car group)) result))
    )
  )
  (reverse result)
)

(defun TNT:LAYER-SYNC:LAYER-OBJ (name / doc layers result)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq layers (vla-get-Layers doc))
  (setq result (vl-catch-all-apply 'vla-Item (list layers name)))
  (if (vl-catch-all-error-p result) nil result)
)

(defun TNT:LAYER-SYNC:ENSURE-LAYER (name / doc layers layerObj)
  (setq layerObj (TNT:LAYER-SYNC:LAYER-OBJ name))
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

(defun TNT:LAYER-SYNC:UNLOCK (name / layerObj)
  (setq layerObj (TNT:LAYER-SYNC:ENSURE-LAYER name))
  (if layerObj
    (progn
      (vl-catch-all-apply 'vla-put-LayerOn (list layerObj :vlax-true))
      (vl-catch-all-apply 'vla-put-Freeze (list layerObj :vlax-false))
      (vl-catch-all-apply 'vla-put-Lock (list layerObj :vlax-false))
    )
  )
  (princ)
)

(defun TNT:LAYER-SYNC:MOVE (oldLayer newLayer / ss n)
  (TNT:LAYER-SYNC:UNLOCK oldLayer)
  (TNT:LAYER-SYNC:UNLOCK newLayer)
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

(defun TNT:LAYER-SYNC:MOVE-BLOCK-DEFS (oldLayer newLayer / doc blocks block obj count objLayer)
  (setq doc    (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq blocks (vla-get-Blocks doc))
  (setq count 0)
  (TNT:LAYER-SYNC:UNLOCK oldLayer)
  (TNT:LAYER-SYNC:UNLOCK newLayer)
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

(defun TNT:LAYER-SYNC:PURGE-OLD-LAYER (oldLayer newLayer / layerObj result)
  (setq layerObj (TNT:LAYER-SYNC:LAYER-OBJ oldLayer))
  (if layerObj
    (progn
      (TNT:LAYER-SYNC:UNLOCK oldLayer)
      (if (= (strcase (getvar "CLAYER")) (strcase oldLayer))
        (vl-catch-all-apply 'setvar (list "CLAYER" newLayer))
      )
      (setq result (vl-catch-all-apply 'vla-Delete (list layerObj)))
      (not (vl-catch-all-error-p result))
    )
    nil
  )
)

(defun TNT:LAYER-SYNC:TARGET-LAYER (layerName / pair result)
  (setq result nil)
  (foreach pair (TNT:LAYER-SYNC:MAP)
    (if (= (strcase layerName) (strcase (car pair)))
      (setq result (cadr pair))
    )
  )
  result
)

(defun TNT:LAYER-SYNC:RUN-SELECTION (/ oldcmdecho ss i ent obj oldLayer newLayer changed skipped failed)
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
            (setq newLayer (TNT:LAYER-SYNC:TARGET-LAYER oldLayer))
            (if newLayer
              (progn
                (TNT:LAYER-SYNC:UNLOCK oldLayer)
                (TNT:LAYER-SYNC:UNLOCK newLayer)
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
          "\n[TNT] DONE LAYER SYNC SELECTION. Changed: "
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

(defun TNT:LAYER-SYNC:RUN (/ oldcmdecho pair total totalBlocks count blockCount deleted deleteCount)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command-s "_.UNDO" "_BE")
  (setq total 0)
  (setq totalBlocks 0)
  (setq deleteCount 0)
  (foreach pair (TNT:LAYER-SYNC:MAP)
    (setq count (TNT:LAYER-SYNC:MOVE (car pair) (cadr pair)))
    (setq blockCount (TNT:LAYER-SYNC:MOVE-BLOCK-DEFS (car pair) (cadr pair)))
    (setq total (+ total count))
    (setq totalBlocks (+ totalBlocks blockCount))
    (setq deleted (TNT:LAYER-SYNC:PURGE-OLD-LAYER (car pair) (cadr pair)))
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
      "\n[TNT] DONE LAYER SYNC ALL. Objects changed: "
      (itoa total)
      " direct, "
      (itoa totalBlocks)
      " in blocks. Old layers deleted: "
      (itoa deleteCount)
    )
  )
  (princ)
)

(defun c:TNT_LAYER_SYNC_ALL (/)
  (TNT:LAYER-SYNC:RUN)
)

(defun c:TNT_LAYER_SYNC_SELECTION (/)
  (TNT:LAYER-SYNC:RUN-SELECTION)
)

(princ "\n[TNT] Loaded TNT_LAYER_SYNC_ALL.lsp. Commands: TNT_LAYER_SYNC_ALL, TNT_LAYER_SYNC_SELECTION")
(princ)
