;;; ====================================================================================================
;;; *** D_010_LAYER_CHANGE.LSP ***
;;; ====================================================================================================
;;; * FILE    :  D_010_LAYER_CHANGE.LSP
;;; * PURPOSE :
;;;   - CHANGE LAYER HATCH, TEXT, LEADER, DIM
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  010:A:...
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *010.A.B...*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*...
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*...
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:010_A_...
;;; * LƯU Ý:
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; [1] COMMAND / LỆNH NGƯỜI DÙNG
;;; ====================================================================================================
(defun c:LAY ()
  (setvar "CMDECHO" 0)  
  (command-s "UNDO" "BE")
  (010:LAYER:CHANGE:TEXT)
  (010:LAYER:CHANGE:LEADER)
  (010:LAYER:CHANGE:DIMENSION)
  (010:LAYER:CHANGE:HATCH)
  (command-s "UNDO" "END")
  (setvar "CMDECHO" 1)
  (prompt "\n[INFO] DONE.")
  (princ))
;;; ====================================================================================================
;;; [1] HÀM CON
;;; ====================================================================================================
(defun 010:LAYER:CHANGE:TEXT (/ CNT)
  (setq CNT (ssget "X"
              '(
                (-4 . "<AND")
                  (-4 . "<OR")
                    (0 . "TEXT")
                    (0 . "MTEXT")
                  (-4 . "OR>")
                  (-4 . "<NOT")
                    (-4 . "<OR")
                      (8 . "Defpoints")
                      (8 . "...21_010_N_HATCH")                
                      (8 . "...22_010_N_ANNOTATE") 
                      (8 . "...11_010_A_PLOT")
                      (8 . "...23_010_M_NOTE")
                      (8 . "...24_010_M_TEXT")
                      (8 . "...30_010_E_NOTE")
                      (8 . "...31_010_E_TEXT")
                      (8 . "...34_010_P_NOTE")
                      (8 . "...35_010_P_TEXT")
                    (-4 . "OR>")
                  (-4 . "NOT>")
                (-4 . "AND>")
              )
            )
  )
  (if CNT
    (command-s "_.change" CNT "" "P" "LA" "...18_010_N_TEXT" "")
    (command-s ".TEXTTOFRONT" "A")    
  )
(princ))

(defun 010:LAYER:CHANGE:LEADER (/ CNL)
  (setq CNL (ssget "X"
              '(
                (-4 . "<AND")
                  (-4 . "<OR")
                    (0 . "LEADER")
                    (0 . "MLEADER")
                  (-4 . "OR>")
                  (-4 . "<NOT")
                    (-4 . "<OR")
                      (8 . "Defpoints")
                      (8 . "...21_010_N_HATCH")
                      (8 . "...22_010_N_ANNOTATE")                
                      (8 . "...23_010_M_NOTE")
                      (8 . "...24_010_M_TEXT")
                      (8 . "...30_010_E_NOTE")
                      (8 . "...31_010_E_TEXT")
                      (8 . "...34_010_P_NOTE")
                      (8 . "...35_010_P_TEXT")
                    (-4 . "OR>")
                  (-4 . "NOT>")
                (-4 . "AND>")
              )
            )
  )
  (if CNL
    (command-s "_.change" CNL "" "P" "LA" "...19_010_N_LEADER" "")
  )
(princ))

(defun 010:LAYER:CHANGE:DIMENSION (/ CND)
  (setq CND (ssget "X" '((0 . "DIMENSION"))))
  (if CND
    (command-s "_.change" CND "" "P" "LA" "...20_010_N_DIMENSION" "")
  )
(princ))

(defun 010:LAYER:CHANGE:HATCH (/ CNH)
  (setq CNH (ssget "X" '((0 . "HATCH"))))
    (setq CNH (ssget "X"
              '(
                (-4 . "<AND")
                  (-4 . "<OR")
                    (0 . "HATCH")
                  (-4 . "OR>")
                  (-4 . "<NOT")
                    (-4 . "<OR")
                      (8 . "Defpoints")
                      (8 . "...13_010_F_TREE")
                      (8 . "...11_010_A_PLOT")
                      (8 . "...16_010_S_CONCRETE")
                    (-4 . "OR>")
                  (-4 . "NOT>")
                (-4 . "AND>")
              )
            )
  )
  (if CNH
    (progn
      (command-s "_.change" CNH "" "P" "LA" "...21_010_N_HATCH" "")
      (command-s ".DRAWORDER" CNH "" "B")
    )
  )
(princ))
;;; ====================================================================================================
;;; END
;;; ====================================================================================================