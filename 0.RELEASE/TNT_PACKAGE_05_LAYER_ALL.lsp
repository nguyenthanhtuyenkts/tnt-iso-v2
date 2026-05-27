;;; ====================================================================================================
;;; TNT_PACKAGE_05_LAYER_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Layer_Fix.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; *** B_TNT_LAYER_FIX.LSP ***
;;; ====================================================================================================
;;; * FILE    : B_TNT_LAYER_FIX.LSP
;;; * PURPOSE : 
;;;   - ÉP 1 ĐỐI TƯỢNG VỀ BYLAYER NẾU LAYER CỦA NÓ THUỘC DANH SÁCH CHUẨN
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [1] COMMAND / LỆNH NGƯỜI DÙNG
;;; ====================================================================================================
(DEFUN c:TNT_LAYER (/)
  (TNT:SYS:RUN-SAFE (FUNCTION TNT:LAYER:RUN))
  (PRINC))
;;; ====================================================================================================
;;; [2] CHỈ ÉP BYLAYER CHO LAYER CHUẨN
;;; ====================================================================================================
;; ÉP 1 ĐỐI TƯỢNG VỀ BYLAYER NẾU LAYER CỦA NÓ THUỘC DANH SÁCH CHUẨN
(DEFUN TNT:ENT:SET-BYLAYER-IF-STD (OBJ PSET PEX / LNAME)
  (SETQ LNAME (STRCASE (TNT:STR:TRIM (VLA-GET-LAYER OBJ))))
  (IF (AND (MEMBER LNAME PSET) (NOT (MEMBER LNAME PEX)))
    (PROGN
      (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-COLOR       (LIST OBJ 256))
      (IF (VLAX-PROPERTY-AVAILABLE-P OBJ 'LINETYPE)
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-LINETYPE  (LIST OBJ "BYLAYER")))
      (IF (VLAX-PROPERTY-AVAILABLE-P OBJ 'LINEWEIGHT)
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-LINEWEIGHT (LIST OBJ ACLNWTBYLAYER)))
      (IF (VLAX-PROPERTY-AVAILABLE-P OBJ 'PLOTSTYLENAME)
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-PLOTSTYLENAME (LIST OBJ "BYLAYER")))
      (IF (VLAX-PROPERTY-AVAILABLE-P OBJ 'TRANSPARENCY)
        (TNT:PACKAGE:FS:SAFE-PUT 'VLA-PUT-TRANSPARENCY (LIST OBJ 0)))
    ))
  (PRINC))

(DEFUN TNT:SPACE:FORCE-BYLAYER-STD (BTR PSET PEX / ENT)
  (if (and BTR (vlax-property-available-p BTR 'GetEntities))
    (VLAX-FOR ENT (vla-get-entities BTR) (TNT:ENT:SET-BYLAYER-IF-STD ENT PSET PEX))
    (VLAX-FOR ENT BTR (TNT:ENT:SET-BYLAYER-IF-STD ENT PSET PEX)))
  (PRINC))

(DEFUN TNT:MODEL:FORCE-BYLAYER-STD (/ DOC MS PSET PEX)
  (SETQ DOC  (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)))
  (SETQ MS   (VLA-GET-MODELSPACE DOC))
  (SETQ PSET (MAPCAR '(lambda (n) (strcase (TNT:STR:TRIM n))) (TNT:LAYER:STD-NAMES)))
  (SETQ PEX  (MAPCAR '(lambda (n) (strcase (TNT:STR:TRIM n))) (TNT:LAYER:STD-EXCLUDE-NAMES)))
  (TNT:SPACE:FORCE-BYLAYER-STD MS PSET PEX)
  (PRINC))

(DEFUN TNT:PAPER:FORCE-BYLAYER-STD (/ DOC LAYS LYT BTR PSET PEX)
  (SETQ DOC  (VLA-GET-ACTIVEDOCUMENT (VLAX-GET-ACAD-OBJECT)))
  (SETQ LAYS (VLA-GET-LAYOUTS DOC))
  (SETQ PSET (MAPCAR '(lambda (n) (strcase (TNT:STR:TRIM n))) (TNT:LAYER:STD-NAMES)))
  (SETQ PEX  (MAPCAR '(lambda (n) (strcase (TNT:STR:TRIM n))) (TNT:LAYER:STD-EXCLUDE-NAMES)))
  (VLAX-FOR LYT LAYS
    (IF (/= (STRCASE (VLA-GET-NAME LYT)) "MODEL")
      (PROGN
        (SETQ BTR (VLA-GET-BLOCK LYT))
        (TNT:SPACE:FORCE-BYLAYER-STD BTR PSET PEX))))
  (PRINC))
;;; ====================================================================================================
;;; [3] HÀM CON
;;; ====================================================================================================
;; 1) ÉP BYLAYER CHO CÁC ĐỐI TƯỢNG THUỘC LAYER CHUẨN
(DEFUN TNT:LAYER:FIX (/)
  (TNT:SYS:RUN-SAFE (FUNCTION (LAMBDA (/) (TNT:MODEL:FORCE-BYLAYER-STD))))
  (TNT:SYS:RUN-SAFE (FUNCTION (LAMBDA (/) (TNT:PAPER:FORCE-BYLAYER-STD))))
  (PRINC))
;; 2) TẠO/ĐỒNG BỘ LAYER CHUẨN + ÉP BYLAYER TRÊN CÁC LAYER CHUẨN (MODEL + PAPER)
(DEFUN TNT:LAYER:SYNC (/)
  (TNT:SYS:RUN-SAFE
    (FUNCTION
      (LAMBDA (/)
        (TNT:LAY:CREATE)                 ; TẠO/RESET CÁC LAYER CHUẨN
        (TNT:MODEL:FORCE-BYLAYER-STD)    ; ÉP ĐỐI TƯỢNG MODEL NẾU LAYER ∈ CHUẨN
        (TNT:PAPER:FORCE-BYLAYER-STD)    ; ÉP ĐỐI TƯỢNG PAPER NẾU LAYER ∈ CHUẨN
      )))
  (PRINC))
;;; ====================================================================================================
;;; END
;;; ====================================================================================================
;; 3) Dam bao cac layer TNT chuan ton tai sau PURGE/AUDIT
(DEFUN TNT:LAYER:ENSURE-STANDARD (/)
  (TNT:LAY:CREATE)
  (PRINC))

;; 4) Lenh tong hop: tao/reset layer, phan loai doi tuong, ep ByLayer
(DEFUN TNT:LAYER:RUN (/)
  (TNT:LAY:CREATE)
  (TNT:LAYER:CHANGE)
  (TNT:MODEL:FORCE-BYLAYER-STD)
  (PRINC "\n[TNT] DONE: TNT_LAYER.")
  (PRINC))
;;; ====================================================================================================
;;; END SOURCE: B_TNT_Layer_Fix.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: D_TNT_Layer_Change.lsp
;;; ====================================================================================================
;;; ====================================================================================================
;;; *** D_TNT_LAYER_CHANGE.LSP ***
;;; ====================================================================================================
;;; * FILE    :  D_TNT_LAYER_CHANGE.LSP
;;; * PURPOSE :
;;;   - CHANGE LAYER HATCH, TEXT, LEADER, DIM
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  TNT:A:...
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *TNT.A.B...*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*...
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*...
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:TNT_A_...
;;; * LƯU Ý:
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; ====================================================================================================
;;; [1] COMMAND / LỆNH NGƯỜI DÙNG
;;; ====================================================================================================
;;; ====================================================================================================
;;; [1] HAM CON
;;; ====================================================================================================
(defun TNT:LAYER:CHANGE (/ OLDCE)
  (setq OLDCE (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command-s "UNDO" "BE")
  (TNT:LAYER:CHANGE:TEXT)
  (TNT:LAYER:CHANGE:LEADER)
  (TNT:LAYER:CHANGE:DIMENSION)
  (TNT:LAYER:CHANGE:HATCH)
  (command-s "UNDO" "END")
  (setvar "CMDECHO" OLDCE)
  (princ))

(defun TNT:LAYER:CHANGE:TEXT (/ CNT)
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
                      (8 . "....23_TNT_N_HATCH")
                      (8 . "....24_TNT_N_ANNOTATE")                
                      (8 . "....25_TNT_M_NOTE")
                      (8 . "....26_TNT_M_TEXT")
                      (8 . "....32_TNT_E_NOTE")
                      (8 . "....33_TNT_E_TEXT")
                      (8 . "....36_TNT_P_NOTE")
                      (8 . "....37_TNT_P_TEXT")
                    (-4 . "OR>")
                  (-4 . "NOT>")
                (-4 . "AND>")
              )
            )
  )
  (if CNT
    (command-s "_.change" CNT "" "P" "LA" "....20_TNT_N_TEXT" "")
    (command-s ".TEXTTOFRONT" "A")    
  )
(princ))

(defun TNT:LAYER:CHANGE:LEADER (/ CNL)
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
                      (8 . "....23_TNT_N_HATCH")
                      (8 . "....24_TNT_N_ANNOTATE")                
                      (8 . "....25_TNT_M_NOTE")
                      (8 . "....26_TNT_M_TEXT")
                      (8 . "....32_TNT_E_NOTE")
                      (8 . "....33_TNT_E_TEXT")
                      (8 . "....36_TNT_P_NOTE")
                      (8 . "....37_TNT_P_TEXT")
                    (-4 . "OR>")
                  (-4 . "NOT>")
                (-4 . "AND>")
              )
            )
  )
  (if CNL
    (command-s "_.change" CNL "" "P" "LA" "....21_TNT_N_LEADER" "")
  )
(princ))

(defun TNT:LAYER:CHANGE:DIMENSION (/ CND)
  (setq CND (ssget "X" '((0 . "DIMENSION"))))
  (if CND
    (command-s "_.change" CND "" "P" "LA" "....22_TNT_N_DIMENSION" "")
  )
(princ))

(defun TNT:LAYER:CHANGE:HATCH (/ CNH)
  (setq CNH (ssget "X" '((0 . "HATCH"))))
  (if CNH
    (progn
      (command-s "_.change" CNH "" "P" "LA" "....23_TNT_N_HATCH" "")
      (command-s ".DRAWORDER" CNH "" "B")
    )
  )
(princ))
;;; ====================================================================================================
;;; END
;;; ====================================================================================================
;;; ====================================================================================================
;;; END SOURCE: D_TNT_Layer_Change.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; DIMENSION SHORTCUTS
;;; ====================================================================================================
(defun c:D1 (/)
  (command ".DIMLFAC")
  (princ)
)

(defun c:D2 (/)
  (command ".DIMSCALE")
  (princ)
)

(princ "\n[TNT] Loaded TNT_PACKAGE_05_LAYER_ALL.lsp")
(princ)
