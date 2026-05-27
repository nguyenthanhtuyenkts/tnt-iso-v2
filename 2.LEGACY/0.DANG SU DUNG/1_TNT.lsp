(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")
;;; HAM CON
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
  (defun GET_EFFECTIVENAME_BLOCK ( VlaObject / NameBlock )
    (vl-catch-all-apply (function (lambda ( / )
      (setq NameBlock (cdr (assoc 2 (entget (cdr (assoc 340 (entget (vlax-vla-object->ename (vla-item (vla-item (vla-GetExtensionDictionary VlaObject) "AcDbBlockRepresentation") "AcDbRepData")))))))))
    )))
    (if (not NameBlock)
      (setq NameBlock (cdr (assoc 2 (entget (vlax-vla-object->ename VlaObject)))))
    )
    NameBlock
  )
;;; LISP THANH DOI LEADER, TEXT, DIMENSION THEO TY LE KHUNG
  (defun C:TNT ( /
                  OCCHO ENAME1 ELIST1 ETYPE1 KHUNGSCALE
                  LSTSS LSTINSERT LSTLINE LSTLWPOLYLINE LSTSPLINE LSTLCIRCLE LSTLEDER LSTTEXT LSTDIM 
                  ENT                
                  O1 DT N E L
                  LEADEROBJ CIRCLEOBJ WPOLYLINEOBJ DIMROBJ LINEOBJ TEXTOBJ INSERTOBJ
                  LEADERSIZE CIRCLESIZE LWPOLYLINESIZE                   
                  LINESTYLE TEXTSTYLE TEXTSTYLE LINESIZE1 LINESIZE2                 
                  p1 lst1 lst botoadox toadox1 toadodiem1 lst2 
                  lts3 pt1 xdau pt pdat textObj cle alignmentPoint
                )
    (setvar "MODEMACRO" "TNT Architecture")
    (command "UNDO" "BE")
    (setvar "CMDECHO" 0)
    (setq OCCHO  (getvar "OSMODE"))
    (setq ENAME1 (entsel "\nCHON KHUNG")
          ELIST1 (entget (car ENAME1))
          ETYPE1 (cdr (assoc 0 ELIST1))
          KHUNGSCALE (cdr (assoc 41 ELIST1))
    )
    (setq LSTSS          (CV:SS-TO-LIST (ssget (list (cons 0 "INSERT,LINE,LWPOLYLINE,CIRCLE,LEADER,*TEXT,DIMENSION"))) nil))
    (setq LSTINSERT      (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "INSERT")) LSTSS))
    (setq LSTLINE        (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "LINE")) LSTSS))    
    (setq LSTLWPOLYLINE  (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "LWPOLYLINE")) LSTSS))
    (setq LSTSPLINE      (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "LINE")) LSTSS)) 
    (setq LSTLCIRCLE     (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "CIRCLE")) LSTSS))
    (setq LSTLEDER       (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "LEADER")) LSTSS)) 
    (setq LSTDIM         (vl-remove-if-not '(lambda (X) (=  (cdr (assoc 0 (entget X))) "DIMENSION")) LSTSS))
    (setq LSTTEXT        (vl-remove-if-not '(lambda (X) (/= (cdr (assoc 0 (entget X))) "LEADER,DIMENSION")) LSTSS))
    ;;;INSERT
      (foreach ENT LSTINSERT
        (setq LSTTAG (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT-ANNO-TAG-SEC-02")) LSTINSERT))
          (foreach ENT LSTTAG            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTBASE (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_BASE")) LSTINSERT))
          (foreach ENT LSTBASE            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTSECTION (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_SECTION")) LSTINSERT))
          (foreach ENT LSTSECTION            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTNOTE1 (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_NOTE_1")) LSTINSERT))
          (foreach ENT LSTNOTE1            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTNOTE2 (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_NOTE_2")) LSTINSERT))
          (foreach ENT LSTNOTE2            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTNOTE3 (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_NOTE_3")) LSTINSERT))
          (foreach ENT LSTNOTE3            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTSLOPE (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_SLOPE")) LSTINSERT))
          (foreach ENT LSTSLOPE            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTDOOR1 (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_DOOR_1")) LSTINSERT))
          (foreach ENT LSTDOOR1            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTDOOR2 (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_DOOR_2")) LSTINSERT))
          (foreach ENT LSTDOOR2            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
        (setq LSTCOTE (vl-remove-if-not '(lambda (X) (=  (GET_EFFECTIVENAME_BLOCK (vlax-ename->vla-object X)) "TNT_COTE")) LSTINSERT))
          (foreach ENT LSTCOTE            
            (cond
              (
                (setq BLOCKOBJ (vlax-ename->vla-object ENT))
                (vla-put-XScaleFactor BLOCKOBJ KHUNGSCALE)            
              )
            )
          )
      )
    ;;;CIRCLE
      (foreach ENT LSTLCIRCLE
        (setq O1 (entget ENT))
        (setq DT (cdr (assoc 0 O1)))
        (cond
          ((= DT "CIRCLE")
            (setq CIRCLEOBJ (vlax-ename->vla-object ENT)
                  CIRCLESIZE1 (* 10 KHUNGSCALE) ;DETAIL
                  CIRCLESIZE2 (* 5 KHUNGSCALE)  ;BASE
                  CIRCLESTYLE (cdr (assoc 6 O1))
                  CIRCLELAYER (cdr (assoc 8 O1))
            )
              (cond
                ((= CIRCLELAYER "...6_TNT_LINE_HIDDEN")
                  (vla-put-Linetype CIRCLEOBJ "HIDDEN")
                  (vla-put-LinetypeScale CIRCLEOBJ CIRCLESIZE1)
                  (vla-Update CIRCLEOBJ)
                )
                ((= CIRCLELAYER "...16_TNT_LINE_DETAIL")
                  (vla-put-Linetype CIRCLEOBJ "HIDDEN")
                  (vla-put-LinetypeScale CIRCLEOBJ CIRCLESIZE1)
                  (vla-Update CIRCLEOBJ)
                )
                ((= CIRCLELAYER "...7_TNT_LINE_BASE")
                  (vla-put-Linetype CIRCLEOBJ "CENTER")
                  (vla-put-LinetypeScale CIRCLEOBJ CIRCLESIZE2)
                  (vla-Update CIRCLEOBJ)
                )
                ((= CIRCLESTYLE "CENTER")
                  (vla-put-Layer CIRCLEOBJ "...7_TNT_LINE_BASE")
                  (vla-put-LinetypeScale CIRCLEOBJ CIRCLESIZE2)
                  (vla-Update CIRCLEOBJ)
                )
                ((= CIRCLESTYLE "HIDDEN")
                  ;(vla-put-Layer LINEOBJ "16_TNT_LINE_DETAIL")
                  (vla-put-LinetypeScale CIRCLEOBJ CIRCLESIZE1)
                  (vla-Update CIRCLEOBJ)
                )
              )
            )
          )
        )
    ;;;LWPOLYLINE
      (foreach ENT LSTLWPOLYLINE
        (setq O1 (entget ENT))
        (setq DT (cdr (assoc 0 O1)))
        (cond
          ((= DT "LWPOLYLINE")
            (setq LWPOLYLINEOBJ (vlax-ename->vla-object ENT)
                  LWPOLYLINESIZE1 (* 10 KHUNGSCALE) ;DETAIL
                  LWPOLYLINESIZE2 (* 5 KHUNGSCALE)  ;BASE
                  LWPOLYLINESTYLE (cdr (assoc 6 O1))
                  LWPOLYLINELAYER (cdr (assoc 8 O1))
            )
              (cond
                ((= LWPOLYLINELAYER "...6_TNT_LINE_HIDDEN")
                  (vla-put-Linetype LWPOLYLINEOBJ "HIDDEN")
                  (vla-put-LinetypeScale LWPOLYLINEOBJ LWPOLYLINESIZE1)
                  (vla-Update LWPOLYLINEOBJ)
                )
                ((= LWPOLYLINELAYER "...16_TNT_LINE_DETAIL")
                  (vla-put-Linetype LWPOLYLINEOBJ "HIDDEN")
                  (vla-put-LinetypeScale LWPOLYLINEOBJ LWPOLYLINESIZE1)
                  (vla-Update LWPOLYLINEOBJ)
                )
                ((= LWPOLYLINELAYER "...7_TNT_LINE_BASE")
                  (vla-put-Linetype LWPOLYLINEOBJ "CENTER")
                  (vla-put-LinetypeScale LWPOLYLINEOBJ LWPOLYLINESIZE2)
                  (vla-Update LWPOLYLINEOBJ)
                )
                ((= LWPOLYLINESTYLE "CENTER")
                  (vla-put-Layer LWPOLYLINEOBJ "...7_TNT_LINE_BASE")
                  (vla-put-LinetypeScale LWPOLYLINEOBJ LWPOLYLINESIZE2)
                  (vla-Update LWPOLYLINEOBJ)
                )
                ((= LWPOLYLINESTYLE "HIDDEN")
                  ;(vla-put-Layer LINEOBJ "16_TNT_LINE_DETAIL")
                  (vla-put-LinetypeScale LWPOLYLINEOBJ LWPOLYLINESIZE1)
                  (vla-Update LWPOLYLINEOBJ)
                )
              )
            )
          )
        )
    ;;;LINE
      (foreach ENT LSTLINE
        (setq O1 (entget ENT))
        (setq DT (cdr (assoc 0 O1)))      
        (cond
          ((= DT "LINE")
            (setq LINEOBJ (vlax-ename->vla-object ENT)
                  LINESIZE1 (* 10 KHUNGSCALE) ;DETAIL
                  LINESIZE2 (* 5 KHUNGSCALE)  ;BASE
                  LINESIZE3 (* 0.35 KHUNGSCALE);SECTION
                  LINESTYLE (cdr (assoc 6 O1))
                  LINELAYER (cdr (assoc 8 O1))
            )
              (cond
                ((= LINELAYER "...6_TNT_LINE_HIDDEN")
                  (vla-put-Linetype LINEOBJ "HIDDEN")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE1)
                  (vla-Update LINEOBJ)
                )
                ((= LINELAYER "...16_TNT_LINE_DETAIL")
                  (vla-put-Linetype LINEOBJ "HIDDEN")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE1)
                  (vla-Update LINEOBJ)
                )
                ((= LINELAYER "...7_TNT_LINE_BASE")
                  (vla-put-Linetype LINEOBJ "CENTER")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE2)
                  (vla-Update LINEOBJ)
                )
                ((= LINELAYER "...17_TNT_SECTION_LINE")
                  (vla-put-Linetype LINEOBJ "ACAD_ISO07W100")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE3)
                  (vla-Update LINEOBJ)
                )
                ((= LINESTYLE "CENTER")
                  (vla-put-Layer LINEOBJ "...7_TNT_LINE_BASE")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE2)
                  (vla-Update LINEOBJ)
                )
                ((= LINESTYLE "HIDDEN")
                  ;(vla-put-Layer LINEOBJ "6_TNT_LINE_HIDDEN")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE1)
                  (vla-Update LINEOBJ)
                )
                ((= LINESTYLE "ACAD_ISO07W100")
                  (vla-put-Layer LINEOBJ "...17_TNT_SECTION_LINE")
                  (vla-put-LinetypeScale LINEOBJ LINESIZE3)
                  (vla-Update LINEOBJ)
                )
              )
            )
          )
        )
    ;;;LEADER
      (foreach ENT LSTLEDER
        (setq O1 (entget ENT))
        (setq DT (cdr (assoc 0 O1)))
        (setq LEADERSIZE (* 2 KHUNGSCALE))
        (cond
          ((= DT "LEADER")
            (setq LEADEROBJ (vlax-ename->vla-object ENT))
            (vla-put-ScaleFactor LEADEROBJ 1 )
            (vla-put-ArrowheadSize LEADEROBJ LEADERSIZE)
          )
        )
      )
    ;;;DIMENSION
      (foreach ENT LSTDIM
        (setq O1 (entget ENT))
        (setq DT (cdr (assoc 0 O1)))
        (setvar "DIMSCALE" KHUNGSCALE)
        (cond
          ((= DT "DIMENSION")
            (setq DIMROBJ (vlax-ename->vla-object ENT))
            (vla-put-ScaleFactor DIMROBJ KHUNGSCALE)
          )
        )
      )
    ;;;TEXT
      (foreach ENT LSTTEXT
        (setq O1 (entget ENT))
        (setq DT (cdr (assoc 0 O1)))    
        (cond
          ((= DT "MTEXT")
          (setq TEXTOBJ (vlax-ename->vla-object ENT)
                TEXT1 (* 4 KHUNGSCALE)
                TEXT2 (* 2 KHUNGSCALE)
                TEXTSTYLE (cdr (assoc 7 O1))
          )
            (cond
              ((= TEXTSTYLE "01_TNT_CHUCNANG")
              (vla-put-HEIGHT TEXTOBJ TEXT1)
              (vla-Update TEXTOBJ)
              )
              ((= TEXTSTYLE "02_TNT_Text")
              (vla-put-HEIGHT TEXTOBJ TEXT2)
              (vla-Update TEXTOBJ)               
              )
            )
          )
          ((= DT "TEXT")
          (setq TEXTOBJ (vlax-ename->vla-object ENT)
                TEXT1 (* 4 KHUNGSCALE)
                TEXT2 (* 2 KHUNGSCALE)
                TEXTSTYLE (cdr (assoc 7 O1))
          )
            (cond
              ((= TEXTSTYLE "01_TNT_CHUCNANG")
              (vla-put-HEIGHT TEXTOBJ TEXT1)
              (vla-Update TEXTOBJ)
              )
              ((= TEXTSTYLE "02_TNT_Text")
              (vla-put-HEIGHT TEXTOBJ TEXT2)
              (vla-Update TEXTOBJ)               
              )
            )
          )
        )  
      )
    (setvar "OSMODE" OCCHO)
    (setvar "CMDECHO" 1)
    (command "UNDO" "END")
    (princ)
  )