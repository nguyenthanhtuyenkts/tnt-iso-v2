;;;
(defun 010_CHANGE_LAYER_DIM (/ CND)
  (setq CND (ssget "X" '((0 . "DIMENSION"))))
  (if CND
    (command-s "_.change" CND "" "P" "LA" "...11_TNT_LINE_DIMENSION" "")
  )
)
;;;
(defun 010_CHANGE_LAYER_HATCH (/ CNH)
  (setq CNH (ssget "X" '((0 . "HATCH"))))
  (if CNH
    (progn
      (command-s "_.change" CNH "" "P" "LA" "...10_TNT_LINE_HATCH" "")
      (command-s ".DRAWORDER" CNH "" "B")
    )
  )
)
;;;;
(defun 010_CHANGE_LAYER_TEXT (/ CNT)
  (setq CNT (ssget "X"
              '(
                (-4 . "<AND")
                  (-4 . "<OR")
                    (0 . "TEXT")
                    (0 . "MTEXT")
                    (0 . "LEADER")
                  (-4 . "OR>")
                  (-4 . "<NOT")
                    (-4 . "<OR")
                      (8 . "Defpoints")
                      (8 . "...22_TNT_WATER-NOTE")
                      (8 . "...23_TNT_WATER-TEXT")
                      (8 . "...30_TNT_ELECTRIC_NOTE")
                      (8 . "...31_TNT_ELECTRIC_TEXT")
                      (8 . "...12_TNT_LINE_ANNOTATE")
                      (8 . "...10_TNT_LINE_HATCH")
                    (-4 . "OR>")
                  (-4 . "NOT>")
                (-4 . "AND>")
              )
            )
  )
  (if CNT
    (command-s "_.change" CNT "" "P" "LA" "...9_TNT_LINE_TEXT" "")
  )
)
;;;;
(defun c:TNT_LAYAUTO ()
  (setvar "CMDECHO" 0)
  (setvar "MODEMACRO" "010.α")
  (command-s "UNDO" "BE")

  ;; Gọi các xử lý layer ghi chú
  (010_CHANGE_LAYER_DIM)
  (010_CHANGE_LAYER_HATCH)
  (010_CHANGE_LAYER_TEXT)

  ;; Đưa TEXT/LEADER lên trên
  (command-s ".TEXTTOFRONT" "A")

  (command-s "UNDO" "END")
  (setvar "CMDECHO" 1)
  (prompt "\n[INFO] Đã hoàn tất chuyển ghi chú và sắp xếp.")
  (princ)
)