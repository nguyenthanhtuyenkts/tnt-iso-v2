;;; ====================================================================================================
;;; TNT_PACKAGE_11_SHORTCUT.lsp
;;; Layer shortcut commands generated from one editable table.
;;; ====================================================================================================

(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")

;;; ----------------------------------------------------------------------------------------------------
;;; [1] EDIT THIS TABLE
;;; ----------------------------------------------------------------------------------------------------
;;; Row format:
;;;   ("GROUP" "COMMAND" "LAYER" "DESCRIPTION")
;;;
;;; How each command works:
;;;   - If no object is selected: set current layer to LAYER.
;;;   - If objects are selected: change selected objects to LAYER, then set current layer to LAYER.
;;; ----------------------------------------------------------------------------------------------------
(defun TNT:SHORTCUT:LAYER:TABLE (/)
  '(
    ;; ==================== ARCHITECT ====================
    ("ARCHITECT" "NKH"  "....01_TNT_A_DRAWING"       "Drawing / khung ban ve")
    ("ARCHITECT" "NT"   "....02_TNT_A_VIRTURAL"      "Visible line / net thay")
    ("ARCHITECT" "NM"   "....03_TNT_A_THIN"          "Thin line / net manh")
    ("ARCHITECT" "NK"   "....04_TNT_A_HIDDEN"        "Hidden line / net khuat")
    ("ARCHITECT" "NC"   "....05_TNT_A_SECTION"       "Section / net cat")
    ("ARCHITECT" "NSL"  "....06_TNT_A_SECTION-LINE"  "Section line / truc cat")
    ("ARCHITECT" "NTR"  "....07_TNT_A_BASE"          "Base axis / net truc")
    ("ARCHITECT" "NDE"  "....08_TNT_A_DETAIL"        "Detail line / net chi tiet")
    ("ARCHITECT" "NCOM" "....09_TNT_A_COMPLETE"      "Complete line / net hoan thien")
    ("ARCHITECT" "NCOT" "....10_TNT_A_COTE"          "Cote / cao do")
    ("ARCHITECT" "NPL"  "....11_TNT_A_PLOT"          "Plot / net in")

    ;; ==================== FURNITURE ====================
    ("FURNITURE" "NNT"  "....12_TNT_F_FURNITURE"     "Furniture / noi that")
    ("FURNITURE" "NCC"  "....13_TNT_F_TREE"          "Tree / cay")
    ("FURNITURE" "NGL"  "....14_TNT_F_GLASS"         "Glass / kinh")
    ("FURNITURE" "NDO"  "....15_TNT_F_DOOR"          "Door / cua")

    ;; ==================== STRUCTURE ====================
    ("STRUCTURE" "NCON" "....16_TNT_S_CONCRETE"      "Concrete / BTCT")
    ("STRUCTURE" "NWA"  "....17_TNT_S_WALL"          "Wall / tuong")

    ;; ==================== ANNOTATE =====================
    ("ANNOTATE"  "NTE"  "....20_TNT_N_TEXT"          "Text / chu")
    ("ANNOTATE"  "NLE"  "....21_TNT_N_LEADER"        "Leader / ghi chu")
    ("ANNOTATE"  "NDI"  "....22_TNT_N_DIMENSION"     "Dimension / kich thuoc")
    ("ANNOTATE"  "NHA"  "....23_TNT_N_HATCH"         "Hatch / vat lieu")
    ("ANNOTATE"  "NAN"  "....24_TNT_N_ANNOTATE"      "Annotate / chu thich")
  )
)

;;; ----------------------------------------------------------------------------------------------------
;;; [2] INTERNAL HELPERS
;;; ----------------------------------------------------------------------------------------------------
(defun TNT:SHORTCUT:LAYER:ENSURE (layername /)
  (cond
    ((tblsearch "LAYER" layername) T)
    ((and (member "TNT:LAY:CREATE" (atoms-family 1))
          (not (tblsearch "LAYER" layername)))
      (TNT:LAY:CREATE)
      (tblsearch "LAYER" layername)
    )
    (T nil)
  )
)

(defun TNT:SHORTCUT:LAYER:SET-OR-CHANGE (layername / oldcmdecho ss)
  (setq oldcmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (cond
    ((not (TNT:SHORTCUT:LAYER:ENSURE layername))
      (setvar "CMDECHO" oldcmdecho)
      (princ (strcat "\n[TNT] Layer not found: " layername))
    )
    (T
      (setq ss (ssget))
      (if ss
        (command-s "_.CHANGE" ss "" "P" "LA" layername "")
      )
      (setvar "CLAYER" layername)
      (setvar "CMDECHO" oldcmdecho)
      (princ (strcat "\n[TNT] Current layer: " layername))
    )
  )
  (princ)
)

(defun TNT:SHORTCUT:LAYER:DEFINE-COMMAND (cmd layer / sym)
  (setq sym (read (strcat "C:" (strcase cmd))))
  (eval
    (list
      'defun
      sym
      '(/)
      (list 'TNT:SHORTCUT:LAYER:SET-OR-CHANGE layer)
      '(princ)
    )
  )
)

(defun TNT:SHORTCUT:LAYER:PRINT-TABLE (/ row)
  (princ "\n[TNT] Layer shortcuts:")
  (foreach row (TNT:SHORTCUT:LAYER:TABLE)
    (princ
      (strcat
        "\n  "
        (cadr row)
        "  ->  "
        (caddr row)
        "  |  "
        (car row)
        "  |  "
        (cadddr row)
      )
    )
  )
  (princ)
)

(defun TNT:SHORTCUT:PGP:TABLE (/)
  '(
    ("CC"  "CIRCLE")
    ("C"   "COPY")
    ("1"   "LAYISO")
    ("2"   "LAYOFF")
    ("3"   "LAYON")
    ("11"  "REFEDIT")
    ("22"  "REFCLOSE")
    ("MM"  "MIRROR")
    ("M"   "MOVE")
    ("ML"  "MLINE")
    ("R"   "ROTATE")
    ("S"   "STRETCH")
    ("SC"  "SCALE")
    ("SPL" "SPLINE")
    ("D"   "DIMLINEAR")
    ("DC"  "DIMCONTINUE")
    ("DD"  "DIMALIGNED")
    ("DST" "DIMSTYLE")
    ("LL"  "DIMSTYLE")
    ("XX"  "XLINE")
  )
)

(defun TNT:SHORTCUT:PGP:DEFINE-COMMAND (cmd target / sym)
  (setq sym (read (strcat "C:" (strcase cmd))))
  (if (not (member (strcat "C:" (strcase cmd)) (atoms-family 1)))
    (eval
      (list
        'defun
        sym
        '(/)
        (list 'setvar "MODEMACRO" "TNT Architecture")
        (list 'command (strcat "_." target))
        '(princ)
      )
    )
  )
)

;;; FT is intentionally skipped because release already has command c:ft in TNT_PACKAGE_06_TEXT_ALL.lsp.
(defun TNT:SHORTCUT:PGP:INIT (/ row)
  (foreach row (TNT:SHORTCUT:PGP:TABLE)
    (TNT:SHORTCUT:PGP:DEFINE-COMMAND (car row) (cadr row))
  )
  (princ)
)

;;; ----------------------------------------------------------------------------------------------------
;;; [3] PUBLIC INITIALIZER / COMMANDS
;;; ----------------------------------------------------------------------------------------------------
(defun TNT:SHORTCUT:LAYER:INIT (/ row)
  (setq *TNT.LAYER:SHORTCUTS*
    (mapcar
      '(lambda (row) (list (cadr row) (caddr row) (car row) (cadddr row)))
      (TNT:SHORTCUT:LAYER:TABLE)
    )
  )
  (foreach row (TNT:SHORTCUT:LAYER:TABLE)
    (TNT:SHORTCUT:LAYER:DEFINE-COMMAND (cadr row) (caddr row))
  )
  (TNT:SHORTCUT:PGP:INIT)
  (princ)
)

(defun TNT_SHORTCUT (/)
  (TNT:SHORTCUT:LAYER:INIT)
  (princ)
)

(defun c:TNT_SHORTCUT (/)
  (TNT_SHORTCUT)
  (princ)
)

(TNT:SHORTCUT:LAYER:INIT)
(princ "\n[TNT] Loaded TNT_PACKAGE_11_SHORTCUT.lsp")
(princ)
