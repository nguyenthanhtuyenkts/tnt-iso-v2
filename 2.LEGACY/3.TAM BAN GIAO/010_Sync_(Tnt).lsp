(vl-load-com)
(setvar "MODEMACRO" "010.α")
-------------------------------------------------------------------------------------------------------------------
(defun c:TNT ( / scale ss lstInsert lstLine lstLwpolyline lstCircle lstLeader lstDim lstText )
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
    (progn
      (setq ss (ssget (list (cons 0 "INSERT,LINE,LWPOLYLINE,CIRCLE,LEADER,*TEXT,DIMENSION"))))
      (setq lstInsert     (TNT:FilterEntitiesByType ss "INSERT"))
      (setq lstLine       (TNT:FilterEntitiesByType ss "LINE"))
      (setq lstLwpolyline (TNT:FilterEntitiesByType ss "LWPOLYLINE"))
      (setq lstCircle     (TNT:FilterEntitiesByType ss "CIRCLE"))
      (setq lstLeader     (TNT:FilterEntitiesByType ss "LEADER"))
      (setq lstDim        (TNT:FilterEntitiesByType ss "DIMENSION"))
      (setq lstText       (vl-remove-if-not (function (lambda (x) (wcmatch (cdr (assoc 0 (entget x))) "*TEXT"))) (CV:SS-TO-LIST ss nil)))

      (TNT:ScaleCircle      lstCircle       scale)
      (TNT:ScaleLines       lstLine         scale)
      (TNT:ScaleLines       lstLwpolyline   scale)
      (TNT:ScaleLeader      lstLeader       scale)
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
(defun TNT:GetScaleFromFrame ( / ename elist objtype refname effname scale )
  (while
    (progn
      (setq ename (car (entsel "\nChọn block khung tên (bấm Esc để thoát): ")))
      (cond
        ((null ename)
         (prompt "\nBạn chưa pick vào đối tượng nào! Vui lòng chọn lại block khung tên.")
         T
        )
        ((not (= (cdr (assoc 0 (entget ename))) "INSERT"))
         (prompt "\nChỉ được chọn block (INSERT). Vui lòng chọn lại!")
         T
        )
        (T
          (setq elist   (entget ename))
          (setq refname (cdr (assoc 2 elist)))
          (setq effname (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object ename)))
          (if (or (and refname (wcmatch (strcase refname) "*TNT*"))
                  (and effname (wcmatch (strcase effname) "*TNT*"))
              )
            nil
            (progn
              (prompt (strcat "\nBlock không hợp lệ! Tên: " (if refname refname "<nil>") ", Hiệu lực: " (if effname effname "<nil>") ". Vui lòng chọn lại!"))
              T
            )
          )
        )
      )
    )
  )
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
(defun TNT:FilterEntitiesByType (ss typeStr)
  (if ss
    (vl-remove-if-not
      (function (lambda (x) (= (cdr (assoc 0 (entget x))) typeStr)))
      (CV:SS-TO-LIST ss nil)
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:FilterBlocksByName (lstInsert blockName)
  (vl-remove-if-not
    (function (lambda (x) (= (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object x)) blockName)))
    lstInsert
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun TNT:ScaleBlocks (lstInsert scale / ent blockObj)
  (foreach ent lstInsert
    (setq blockObj (vlax-ename->vla-object ent))
    (vla-put-XScaleFactor blockObj scale)
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
      ((= layer "...04_010_A_HIDDEN")         (vla-put-Linetype       lineObj "HIDDEN")                   (vla-put-LinetypeScale lineObj ls1))
      ((= layer "...06_010_A_SECTION-LINE")   (vla-put-Linetype       lineObj "ACAD_ISO07W100")           (vla-put-LinetypeScale lineObj ls3))    
      ((= layer "...07_010_A_BASE")           (vla-put-Linetype       lineObj "CENTER")                   (vla-put-LinetypeScale lineObj ls2))     
      ((= layer "...08_010_A_DETAIL")         (vla-put-Linetype       lineObj "HIDDEN")                   (vla-put-LinetypeScale lineObj ls1))
      ((= style "CENTER")                     (vla-put-Layer          lineObj "...07_010_A_BASE")         (vla-put-LinetypeScale lineObj ls2))
      ((= style "HIDDEN")                     (vla-put-LinetypeScale  lineObj ls1))
      ((= style "ACAD_ISO07W100")             (vla-put-Layer          lineObj "...06_010_A_SECTION-LINE") (vla-put-LinetypeScale lineObj ls3))
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
      ((= layer "...04_010_A_HIDDEN")     (vla-put-Linetype       obj "HIDDEN")             (vla-put-LinetypeScale obj s1))
      ((= layer "...08_010_A_DETAIL")     (vla-put-Linetype       obj "HIDDEN")             (vla-put-LinetypeScale obj s1))
      ((= layer "...07_010_A_BASE")       (vla-put-Linetype       obj "CENTER")             (vla-put-LinetypeScale obj s2))
      ((= style "CENTER")                 (vla-put-Layer          obj "...07_010_A_BASE")   (vla-put-LinetypeScale obj s2))
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
      ((= style ".010_A_TXT_1_MAIN")  (vla-put-Height obj h1))
      ((= style ".010_A_TXT_2_SUB")   (vla-put-Height obj h2))
      ((= style ".010_A_TXT_3_NOTE")  (vla-put-Height obj h3))   
    )
    (vla-Update obj)
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun GET_EFFECTIVENAME_BLOCK (vlaObj)
  (if (and vlaObj (vlax-property-available-p vlaObj 'EffectiveName))
    (vla-get-EffectiveName vlaObj)
    (if (vlax-property-available-p vlaObj 'Name)
      (vla-get-Name vlaObj)
      nil
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
(defun CV:SS-TO-LIST ( SS VLA / N E L)
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