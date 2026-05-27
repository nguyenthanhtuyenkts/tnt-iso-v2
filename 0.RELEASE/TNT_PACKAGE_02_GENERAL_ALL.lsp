;;; ====================================================================================================
;;; TNT_PACKAGE_02_GENERAL_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_General_Sync.lsp
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
-------------------------------------------------------------------------------------------------------------------
(defun c:TNT ( / scale ss lstInsert lstLine lstLwpolyline lstCircle lstLeader lstMLeader lstDim lstText blockName )
  (command "UNDO" "BE")
  (setvar "CMDECHO" 0)
  (setq scale (TNT:GetScaleFromFrame))
  (if (not scale)
    (progn
      (prompt "\nLệnh đã bị hủy hoặc không chọn được khung. Kết thúc lệnh.")
      (setvar "CMDECHO" 1)
      (command "UNDO" "END")
      (princ)      
    )
    ;; nếu chọn đúng thì tiếp tục xử lý
    (progn
      (setq ss (ssget (list (cons 0 "INSERT,LINE,LWPOLYLINE,CIRCLE,LEADER,MULTILEADER,*TEXT,DIMENSION"))))
      (setq lstInsert     (TNT:FilterEntitiesByType ss "INSERT"))
      (setq lstLine       (TNT:FilterEntitiesByType ss "LINE"))
      (setq lstLwpolyline (TNT:FilterEntitiesByType ss "LWPOLYLINE"))
      (setq lstCircle     (TNT:FilterEntitiesByType ss "CIRCLE"))
      (setq lstLeader     (TNT:FilterEntitiesByType ss "LEADER"))
      (setq lstMLeader    (TNT:FilterEntitiesByType ss "MULTILEADER"))
      (setq lstDim        (TNT:FilterEntitiesByType ss "DIMENSION"))
      (setq lstText       (vl-remove-if-not (function (lambda (x) (wcmatch (cdr (assoc 0 (entget x))) "*TEXT"))) (TNT:GENERAL:SS-TO-LIST ss nil)))

      ;; Block theo tên
      (foreach blockName
        '(
          ".TNT_A_ANNO-TAG-BASE-01"
          ".TNT_ANNO-TAG-ANN-01"
          ".TNT_ANNO-TAG-ANN-02"
          ".TNT_ANNO-TAG-ANN-03"
          ".TNT_ANNO-TAG-ANN-04"
          ".TNT_ANNO-TAG-ANN-05"
          ".TNT_ANNO-TAG-ANN-06"
          ".TNT_ANNO-TAG-COT-01"
          ".TNT_ANNO-TAG-COT-02"
          ".TNT_ANNO-TAG-COT-03"
          ".TNT_ANNO-TAG-COT-04"
          ".TNT_ANNO-TAG-COT-05"
          ".TNT_ANNO-TAG-COT-06"
          ".TNT_ANNO-TAG-COT-07"
          ".TNT_ANNO-TAG-COT-08"
          ".TNT_ANNO-TAG-COT-09"
          ".TNT_ANNO-TAG-DOOR-01"
          ".TNT_ANNO-TAG-DOOR-02"
          ".TNT_ANNO-TAG-OTHER-01"
          ".TNT_ANNO-TAG-ROOM-01"
          ".TNT_ANNO-TAG-ROOM-2"
          ".TNT_ANNO-TAG-SEC-01"
          ".TNT_ANNO-TAG-SEC-02"
          ".TNT_ANNO-TAG-SEC-03"
          ".TNT_ANNO-TAG-SLOPE-01"
          ".TNT_ANNO-TAG-VIEW-01"
          ".TNT_ANNO-TAG-VIEW-02"
          ".TNT_BASE"
        )
        (TNT:ScaleBlocks (TNT:FilterBlocksByName lstInsert blockName) scale)
      )
      ;; Các đối tượng còn lại
      (TNT:ScaleCircle      lstCircle       scale)
      (TNT:ScaleLines       lstLine         scale)
      (TNT:ScaleLines       lstLwpolyline   scale)
      (TNT:ScaleLeader      lstLeader       scale)
      (TNT:ScaleMLeader     lstMLeader      scale)
      (TNT:ScaleDimension   lstDim          scale)
      (TNT:ScaleText        lstText         scale)

      (prompt "\nĐã đồng bộ xong các đối tượng theo khung!")
      (setvar "CMDECHO" 1)
      (command "UNDO" "END")
      (princ)
    )
  )
)

-------------------------------------------------------------------------------------------------------------------
;;;Hàm lấy biến Scale Iso TNT để đồng bộ
(defun TNT:GetScaleFromFrame ( / ename elist objtype refname effname scale )
  (while
    (progn
      (setq ename (car (entsel "\nChọn block khung tên (bấm Esc để thoát): ")))
      (cond
        ;;Nếu pick vào vùng trống thì báo và yêu cầu chọn lại
        ((null ename)
         (prompt "\nBạn chưa pick vào đối tượng nào! Vui lòng chọn lại block khung tên.")
         T ;Tiếp tục vòng lặp
        )

        ;;Chỉ cho phép chọn đối tượng loại block (INSERT)
        ((not (= (cdr (assoc 0 (entget ename))) "INSERT"))
         (prompt "\nChỉ được chọn block (INSERT). Vui lòng chọn lại!")
         T ;Tiếp tục vòng lặp
        )
        ;; Đúng là block, kiểm tra tên
        (T
          (setq elist   (entget ename))
          (setq refname (cdr (assoc 2 elist)))
          (setq effname (TNT:GENERAL:GET-EFFECTIVENAME-BLOCK (vlax-ename->vla-object ename)))
          (if (or (and refname (wcmatch (strcase refname) "*TNT*"))
                  (and effname (wcmatch (strcase effname) "*TNT*"))
              )
            nil ; kết thúc vòng lặp nếu đúng tên
            (progn
              (prompt (strcat "\nBlock không hợp lệ! Tên: " (if refname refname "<nil>") ", Hiệu lực: " (if effname effname "<nil>") ". Vui lòng chọn lại!"))
              T ; tiếp tục vòng lặp
            )
          )
        )
      )
    )
  )
  ;;Chỉ trả về scale nếu đúng block TNT, còn lại trả về nil
  (if (and ename
           (or (and refname (wcmatch (strcase refname) "*TNT*"))
               (and effname (wcmatch (strcase effname) "*TNT*"))
           )
      )
    (cdr (assoc 41 elist))
    nil
  )
)
-------------------------------------------------------------------------------------------------------------------
;
(defun TNT:FilterEntitiesByType (ss typeStr)
  (if ss
    (vl-remove-if-not
      (function (lambda (x) (= (cdr (assoc 0 (entget x))) typeStr)))
      (TNT:GENERAL:SS-TO-LIST ss nil)
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:FilterBlocksByName (lstInsert blockName)
  (vl-remove-if-not
    (function (lambda (x) (= (TNT:GENERAL:GET-EFFECTIVENAME-BLOCK (vlax-ename->vla-object x)) blockName)))
    lstInsert
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleBlocks (lstInsert scale / ent blockObj)
  (foreach ent lstInsert
    (setq blockObj (vlax-ename->vla-object ent))
    (vla-put-XScaleFactor blockObj scale)
    ;; Nếu muốn đồng bộ cả Y/Z, bỏ chú thích dưới đây
    ;; (vla-put-YScaleFactor blockObj scale)
    ;; (vla-put-ZScaleFactor blockObj scale)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleLines (lstLine scale / ent lineObj ls1 ls2 ls3 style layer)
  (foreach ent lstLine
    (setq lineObj (vlax-ename->vla-object ent)
          entData (entget ent)
          style   (cdr (assoc 6 entData))
          layer   (cdr (assoc 8 entData))
          ls1     (* 10 scale)
          ls2     (* 5 scale)
          ls3     (* 0.35 scale)
    )
    (cond
      ((= layer "....04_TNT_A_HIDDEN")         (vla-put-Linetype       lineObj "HIDDEN")                   (vla-put-LinetypeScale lineObj ls1))
      ((= layer "....06_TNT_A_SECTION-LINE")   (vla-put-Linetype       lineObj "ACAD_ISO07W100")           (vla-put-LinetypeScale lineObj ls3))    
      ((= layer "....07_TNT_A_BASE")           (vla-put-Linetype       lineObj "CENTER")                   (vla-put-LinetypeScale lineObj ls2))     
      ((= layer "....08_TNT_A_DETAIL")         (vla-put-Linetype       lineObj "HIDDEN")                   (vla-put-LinetypeScale lineObj ls1))
      ((= style "CENTER")                     (vla-put-Layer          lineObj "....07_TNT_A_BASE")         (vla-put-LinetypeScale lineObj ls2))
      ((= style "HIDDEN")                     (vla-put-LinetypeScale  lineObj ls1))
      ((= style "ACAD_ISO07W100")             (vla-put-Layer          lineObj "....06_TNT_A_SECTION-LINE") (vla-put-LinetypeScale lineObj ls3))
    )
    (vla-Update lineObj)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleCircle (lstCircle scale / ent obj style layer s1 s2)
  (foreach ent lstCircle
    (setq obj (vlax-ename->vla-object ent)
          entData (entget ent)
          style   (cdr (assoc 6 entData))
          layer   (cdr (assoc 8 entData))
          s1      (* 10 scale)
          s2      (* 5 scale)
    )
    (cond
      ((= layer "....04_TNT_A_HIDDEN")     (vla-put-Linetype       obj "HIDDEN")             (vla-put-LinetypeScale obj s1))
      ((= layer "....08_TNT_A_DETAIL")     (vla-put-Linetype       obj "HIDDEN")             (vla-put-LinetypeScale obj s1))
      ((= layer "....07_TNT_A_BASE")       (vla-put-Linetype       obj "CENTER")             (vla-put-LinetypeScale obj s2))
      ((= style "CENTER")                 (vla-put-Layer          obj "....07_TNT_A_BASE") (vla-put-LinetypeScale obj s2))
      ((= style "HIDDEN")                 (vla-put-LinetypeScale  obj s1))
    )
    (vla-Update obj)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleLeader (lstLeader scale / ent obj size)
  (foreach ent lstLeader
    (setq obj (vlax-ename->vla-object ent)
          size (* 2 scale)
    )
    (vla-put-ScaleFactor obj 1)
    (vla-put-ArrowheadSize obj size)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:GENERAL:SAFE-PUT (obj prop value / err)
  (if (and obj (vlax-property-available-p obj prop T))
    (progn
      (setq err (vl-catch-all-apply 'vlax-put-property (list obj prop value)))
      (if (vl-catch-all-error-p err) nil T)
    )
    nil
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleMLeader (lstMLeader scale / ent obj size)
  (foreach ent lstMLeader
    (setq obj (vlax-ename->vla-object ent)
          size (* 2 scale)
    )
    (TNT:GENERAL:SAFE-PUT obj 'ScaleFactor 1)
    (TNT:GENERAL:SAFE-PUT obj 'ArrowheadSize size)
    (vla-Update obj)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleDimension (lstDim scale / ent obj)
  (setvar "DIMSCALE" scale)
  (foreach ent lstDim
    (setq obj (vlax-ename->vla-object ent))
    (vla-put-ScaleFactor obj scale)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleText (lstText scale / ent obj style h1 h2 h3 entData)
  (foreach ent lstText
    (setq entData (entget ent)
          obj     (vlax-ename->vla-object ent)
          style   (cdr (assoc 7 entData))
          h1      (* 4 scale)          
          h2      (* 3 scale)
          h3      (* 2 scale)
    )
    (cond
      ((= style ".TNT_A_TXT_1_MAIN")  (vla-put-Height obj h1))
      ((= style ".TNT_A_TXT_2_SUB")   (vla-put-Height obj h2))
      ((= style ".TNT_A_TXT_3_NOTE")  (vla-put-Height obj h3))
    )
    (vla-Update obj)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:GENERAL:GET-EFFECTIVENAME-BLOCK (vlaObj)
  (if (and vlaObj (vlax-property-available-p vlaObj 'EffectiveName))
    (vla-get-EffectiveName vlaObj)
    (if (vlax-property-available-p vlaObj 'Name)
      (vla-get-Name vlaObj)
      nil
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:GENERAL:SS-TO-LIST ( SS VLA / N E L)
    (if SS
    (progn
        (setq N (sslength SS))
        (while (setq E (ssname SS (setq N (1- N))))
          (setq L (cons (if VLA (vlax-ename->vla-object E) E) L) )
        )
      )
    )
  )
-------------------------------------------------------------------------------------------------------------------
;;; ====================================================================================================
;;; END SOURCE: B_TNT_General_Sync.lsp
;;; ====================================================================================================

(princ "`n[TNT] Loaded TNT_PACKAGE_02_GENERAL_ALL.lsp")
(princ)
