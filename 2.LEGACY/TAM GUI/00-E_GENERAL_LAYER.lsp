;; 1.PHIM TAT LAYER
;;;
(defun TNT_CHANGE_LAYER_DIM (/ CND)
  (setq CND (ssget "X" '((0 . "DIMENSION"))))
  (if CND
    (command-s "_.change" CND "" "P" "LA" "...11_TNT_LINE_DIMENSION" "")
  )
)
;;;
(defun TNT_CHANGE_LAYER_HATCH (/ CNH)
  (setq CNH (ssget "X" '((0 . "HATCH"))))
  (if CNH
    (progn
      (command-s "_.change" CNH "" "P" "LA" "...10_TNT_LINE_HATCH" "")
      (command-s ".DRAWORDER" CNH "" "B")
    )
  )
)
;;;;
(defun TNT_CHANGE_LAYER_TEXT (/ CNT)
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
  (setvar "MODEMACRO" "010 Architect")
  (command-s "UNDO" "BE")

  ;; Gọi các xử lý layer ghi chú
  (TNT_CHANGE_LAYER_DIM)
  (TNT_CHANGE_LAYER_HATCH)
  (TNT_CHANGE_LAYER_TEXT)

  ;; Đưa TEXT/LEADER lên trên
  (command-s ".TEXTTOFRONT" "A")

  (command-s "UNDO" "END")
  (setvar "CMDECHO" 1)
  (prompt "\n[INFO] Đã hoàn tất chuyển ghi chú và sắp xếp.")
  (princ)
)
;; 4.CHUYEN LAYER HIEN HANH NHANH
(defun TNT_SET_OR_CHANGE_LAYER (layername / ss)
  (setvar "CMDECHO" 0)
  (setq ss (ssget))
  (if (null ss)
    (command-s "CLAYER" layername) ; chỉ đổi layer hiện hành
    (progn
      (command-s "_.CHANGE" ss "" "P" "LA" layername "") ; đổi layer cho đối tượng
      (command-s "CLAYER" layername)                     ; đặt lại layer hiện hành
    )
  )
  (setvar "CMDECHO" 1)
  (princ)
)
(defun c:NC  () (TNT_SET_OR_CHANGE_LAYER "...3_TNT_LINE_SECTION"))
(defun c:NT  () (TNT_SET_OR_CHANGE_LAYER "...4_TNT_LINE_VIRTURAL"))
(defun c:NM  () (TNT_SET_OR_CHANGE_LAYER "...5_TNT_LINE_THIN"))
(defun c:NK  () (TNT_SET_OR_CHANGE_LAYER "...6_TNT_LINE_HIDDEN"))
(defun c:NTR () (TNT_SET_OR_CHANGE_LAYER "...7_TNT_LINE_BASE"))
(defun c:NNT () (TNT_SET_OR_CHANGE_LAYER "...8_TNT_LINE_FUNITURE"))
(defun c:NH  () (TNT_SET_OR_CHANGE_LAYER "...10_TNT_LINE_HATCH"))
(defun c:ND  () (TNT_SET_OR_CHANGE_LAYER "...16_TNT_LINE_DETAIL"))
(defun c:NN  () (TNT_SET_OR_CHANGE_LAYER "...23_TNT_WATER-TEXT"))
(defun c:NE  () (TNT_SET_OR_CHANGE_LAYER "...31_TNT_ELECTRIC_TEXT"))