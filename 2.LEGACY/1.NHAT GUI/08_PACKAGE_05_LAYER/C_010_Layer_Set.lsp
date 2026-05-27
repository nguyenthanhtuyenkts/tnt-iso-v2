;; 4.CHUYEN LAYER HIEN HANH NHANH
(defun 010_SET_OR_CHANGE_LAYER (layername / ss)
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
(defun c:NC  () (010_SET_OR_CHANGE_LAYER "...3_TNT_LINE_SECTION"))
(defun c:NT  () (010_SET_OR_CHANGE_LAYER "...4_TNT_LINE_VIRTURAL"))
(defun c:NM  () (010_SET_OR_CHANGE_LAYER "...5_TNT_LINE_THIN"))
(defun c:NK  () (010_SET_OR_CHANGE_LAYER "...6_TNT_LINE_HIDDEN"))
(defun c:NTR () (010_SET_OR_CHANGE_LAYER "...7_TNT_LINE_BASE"))
(defun c:NNT () (010_SET_OR_CHANGE_LAYER "...8_TNT_LINE_FUNITURE"))
(defun c:NH  () (010_SET_OR_CHANGE_LAYER "...10_TNT_LINE_HATCH"))
(defun c:ND  () (010_SET_OR_CHANGE_LAYER "...16_TNT_LINE_DETAIL"))
(defun c:NN  () (010_SET_OR_CHANGE_LAYER "...23_TNT_WATER-TEXT"))
(defun c:NE  () (010_SET_OR_CHANGE_LAYER "...31_TNT_ELECTRIC_TEXT"))