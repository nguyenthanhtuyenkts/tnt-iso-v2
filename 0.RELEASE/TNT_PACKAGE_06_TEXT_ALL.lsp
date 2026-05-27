;;; ====================================================================================================
;;; TNT_PACKAGE_06_TEXT_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Text_Copy.lsp
;;; ====================================================================================================
(defun c:T1 (/ source target itarget str)
  (setvar "MODEMACRO" "TNT Architecture")
	(command "undo" "be") 
	(prompt "\nSelect *TEXT, DIMENSION source:")
	(setq source (ssget "+.:S:N" '((0 . "*TEXT,DIMENSION"))))
		(if (and
      source
      (setq source (ssname source 0))
      (setq str (cdr (assoc 1 (entget source))))     
      (progn (prompt "\nSelect *TEXT, DIMENSION Target:") T)     
      (setq target (ssget '((0 . "*TEXT,DIMENSION"))))
      )
			  (progn
			    (setq i 0)
			    (while (setq itarget (ssname target i))
			         (entmod (subst  (cons 1 str) (assoc 1 (entget itarget)) (entget itarget)))
		           (setq i (1+ i))      
		    )   
	    (command "undo" "end")
	    (redraw)
		)
	)
)
;;; ====================================================================================================
;;; END SOURCE: B_TNT_Text_Copy.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: C_TNT_Text_Align_TA.lsp
;;; ====================================================================================================
;;; Text Align - 2022.05.04 exceed
(vl-load-com)
(defun c:TA ( / util mode s sl index ename obj box lll url basept targetpt modetxt originobj originbox olll ourl)
  (LM:startundo (LM:acdoc))
  (setvar "cmdecho" 0)
  (setq util (vla-get-utility (LM:acdoc)))

  ; Error control
  (defun *error* ( msg )
    (LM:endundo (LM:acdoc))
    (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
      (princ (strcat "\n Lỗi: " msg))
    )
    (setvar "cmdecho" 1)
    (princ)
  )

  ; Hiển thị tùy chọn tại con trỏ chuột cho hướng căn chỉnh
  (initget 1 "TRÁI PHẢI LÊN XUỐNG GIỮA-NGANG GIỮA-DỌC")
  (setq modetxt (getkword "\nChọn hướng căn chỉnh [TRÁI/PHẢI/LÊN/XUỐNG/GIỮA-NGANG/GIỮA-DỌC]: "))

  ; Chuyển đổi modetxt sang giá trị mode
  (cond 
    ((= modetxt "TRÁI")
      (setq mode "L")
    )
    ((= modetxt "PHẢI")
      (setq mode "R")
    )
    ((= modetxt "LÊN")
      (setq mode "U")
    )
    ((= modetxt "XUỐNG")
      (setq mode "D")
    )
    ((= modetxt "GIỮA-DỌC")
      (setq mode "HC")
      (setq modetxt "GIỮA-DỌC")
    )
    ((= modetxt "GIỮA-NGANG")
      (setq mode "VC")
      (setq modetxt "GIỮA-NGANG")
    )
  )

  ; Logic căn chỉnh
  (princ "\nChọn các đối tượng để căn chỉnh: ")
  (setq s (ssget ":L" '((0 . "TEXT,MTEXT"))))
  (if s
    (progn
      (princ "\nChọn đối tượng tham chiếu: ")
      (setq originobj (vlax-ename->vla-object (car (entsel))))
      (if originobj
        (progn
          (setq originbox (vla-getboundingbox originobj 'oll 'our))
          (setq olll (vlax-safearray->list oll))
          (setq ourl (vlax-safearray->list our))

          (cond 
            ((= mode "L") 
              (setq p (car olll))
            )
            ((= mode "R") 
              (setq p (car ourl))
            )
            ((= mode "HC") 
              (setq p (/ (+ (car olll) (car ourl)) 2))
            )  
            ((= mode "U") 
              (setq p (cadr ourl))
            )
            ((= mode "D") 
              (setq p (cadr olll))
            )
            ((= mode "VC") 
              (setq p (/ (+ (cadr olll) (cadr ourl)) 2))
            )  
          )

          (setq index 0)
          (repeat (sslength s)
            (setq ename (ssname s index))
            (setq obj (vlax-ename->vla-object ename))
            (setq box (vla-getboundingbox obj 'll 'ur))
            (setq lll (vlax-safearray->list ll)) ; lower left point
            (setq url (vlax-safearray->list ur)) ; upper right point

            (cond 
              ((= mode "L")
                (setq basept lll)
                (setq targetpt (list p (cadr basept) (caddr basept)))
              )
              ((= mode "R")
                (setq basept url)
                (setq targetpt (list p (cadr basept) (caddr basept)))
              )
              ((= mode "HC")
                (setq basept (list (/ (+ (car lll) (car url)) 2) (/ (+ (cadr lll) (cadr url)) 2) (/ (+ (caddr lll) (caddr url)) 2)))
                (setq targetpt (list p (cadr basept) (caddr basept)))
              )
              ((= mode "U")
                (setq basept url)
                (setq targetpt (list (car basept) p (caddr basept)))
              )
              ((= mode "D")
                (setq basept lll)
                (setq targetpt (list (car basept) p (caddr basept)))
              )
              ((= mode "VC")
                (setq basept (list (/ (+ (car lll) (car url)) 2) (/ (+ (cadr lll) (cadr url)) 2) (/ (+ (caddr lll) (caddr url)) 2)))
                (setq targetpt (list (car basept) p (caddr basept)))
              )
            )
            (vlax-invoke obj 'move basept targetpt)
            (setq index (+ index 1))
          )
        )
      )
    )
  )

  (setvar "cmdecho" 1)
  (LM:endundo (LM:acdoc))
  (princ)
)

;; Active Document - Lee Mac
(defun LM:acdoc nil
  (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
  (LM:acdoc)
)

;; Start Undo - Lee Mac
(defun LM:startundo ( doc )
  (LM:endundo doc)
  (vla-startundomark doc)
)

;; End Undo - Lee Mac
(defun LM:endundo ( doc )
  (while (= 8 (logand 8 (getvar 'undoctl)))
    (vla-endundomark doc)
  )
)


;;; ====================================================================================================
;;; END SOURCE: C_TNT_Text_Align_TA.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: CanChinhText-ft_df_dfx_dx.lsp
;;; ====================================================================================================
;; free lisp from cadviet.com
;;; this lisp was downloaded from http://www.cadviet.com/forum/index.php?showtopic=13440&st=20
(defun c:ft()
(setq txt (ssget '((0 . "*TEXT"))))
(setq mau (entget (car (entsel "\nChon text chuan"))))
(command "undo" "begin")
(setq oldos (getvar "osmode"))
(setq olcol (getvar "CEColor"))
(setq ollay (getvar "Clayer"))
(setq olstyle (getvar "textstyle"))
(setq TB  (textbox mau) LC  (car TB) RC (cadr TB) di (distance LC RC) i 0)
(setq h (cdr(assoc 40 mau)))
(setq x1 (cdr(assoc 10 mau)))
(setq x2 (list (+ (car x1) (* di 0.5) (* -0.03 h)) (cadr x1)))
(setq x3 (list (+ (car x1) di (* -0.06 h)) (cadr x1)))
(setq canle (cond (canle) ("Left")))
(initget "Left Center Right Fit")
(setq canle (cond ((getkword (strcat "\Vi tri can le [Left/Center/Right/Fit/]<" canle ">"))) (canle)))
(setq oldang (getvar "Angbase"))
(command "angbase" 0 "ucs" "w")
(repeat (sslength txt)
(setq txt_ent (entget (ssname txt i)))
(setq txt_val (cdr(assoc 1 txt_ent)))
(setq txt_st (cdr(assoc 7 txt_ent)))
(setq txt_lay (cdr(assoc 8 txt_ent)))
(setq txt_h (cdr(assoc 40 txt_ent)))
(setq txt_fctr (cdr(assoc 41 txt_ent)))
(setq txt_clr (cdr(assoc 62 txt_ent)))
(setq y1 (cdr(assoc 10 txt_ent)))
(if (cdr(assoc 43 txt_ent)) (setq txt_fctr 1 y1 (list (car y1) (- (cadr y1) txt_h))))
(setq pt1 (list (car x1) (cadr y1)))
(setq pt2 (list (car x2) (cadr y1)))
(setq pt3 (list (car x3) (cadr y1)))
(command "-style" txt_st "" 0 txt_fctr "" "" "" "" "clayer" txt_lay "color" txt_clr "osmode" 0)
(if (eq canle "Left") (command "text" pt1 txt_h 0 txt_val))
(if (eq canle "Center") (command "text" "C" pt2 txt_h 0 txt_val))
(if (eq canle "Right") (command "text" "R" pt3 txt_h 0 txt_val))
(if (eq canle "Fit") (command "text" "F" pt1 pt3 txt_h txt_val))
(setq i (+ i 1))
(command "color" "bylayer")
);repeat
(command "ucs" "p")
(setvar "textstyle" olstyle)
(setvar "angbase" oldang)
(setvar "Clayer" ollay)
(setvar "CECOLOR" olcol)
(setvar "osmode" oldos)
(command "erase" txt "")
(prompt"\n[CAN LE TEXT] by Thaistreetz - huuthais@yahoo.com\n")
(command "undo" "end")
);defun
;=================================================================
;dan deu khoang cach cac hang text theo phuong Y
;=================================================================
(defun TNT:TEXT:SS2ENT (ss / sodt index lstent)
(setq 	sodt (if ss (sslength ss) 0)
	index 0)
(repeat sodt
(setq 	ent (ssname ss index)
	index (1+ index)
	lstent (cons ent lstent)
);setq
);repeat
(reverse lstent)
)
(defun c:df()
(setq oldos (getvar "osmode"))
(setq 	ss (ssget '((0 . "*TEXT")))
	lst (TNT:TEXT:SS2ENT ss)
	lst (vl-sort lst '(lambda (e1 e2) (< (cadr (assoc 10 (entget e1))) (cadr (assoc 10 (entget e2))))))
	lst (vl-sort lst '(lambda (e1 e2) (> (caddr (assoc 10 (entget e1))) (caddr (assoc 10 (entget e2))))))
);setq
(command "undo" "begin")
(setvar "osmode" 14847)
(setq kc (getdist "\n Nhap khoang cach giua cac text"))
(setq ddau (cdr(assoc 10 (entget(car lst)))) i 0 a2 (ssadd))
(setq mau (entget (car (entsel "\nChon text chuan"))))
(setq ptmau (cdr(assoc 10 mau)))
(setq ym (cadr ptmau))
(foreach e lst
(setq ent (entget e))
(setq dcuoi (cdr(assoc 10 ent)))
(setq yi (cadr dcuoi))
(setq ddauu (list (car dcuoi) (- (cadr ddau) (* i kc))))
(if (= yi ym) (setq ptgoc (list (car dcuoi) (- (cadr ddau) (* i kc)))))
(setvar "osmode" 0)
(command "move" e "" dcuoi ddauu)
(setq 	a2 (ssadd e a2))
(setq i (1+ i))
);foreach
(command "move" a2 "" ptgoc ptmau)
(setvar "osmode" oldos)
(prompt"\n[Paragraph TEXT] by Thaistreetz - huuthais@yahoo.com\n")
(command "undo" "end")
(Princ)
)
;=========================================================================
;dan deu khoang cach cac text theo phuong X
;=========================================================================
(defun c:dfx()
(setq oldos (getvar "osmode"))
(setq 	ss (ssget '((0 . "*TEXT")))
	lst (TNT:TEXT:SS2ENT ss)
	lst (vl-sort lst '(lambda (e1 e2) (< (cadr (assoc 10 (entget e1))) (cadr (assoc 10 (entget e2))))))
	lst (vl-sort lst '(lambda (e1 e2) (> (caddr (assoc 10 (entget e1))) (caddr (assoc 10 (entget e2))))))
);setq
(command "undo" "begin")
(setvar "osmode" 14847)
(setq kc (getdist "\n Nhap khoang cach giua cac text"))

(setq ddau (cdr(assoc 10 (entget(car lst)))) i 0 di 0 a2 (ssadd))
(setq mau (entget (car (entsel "\nChon text chuan"))))
(setq ptmau (cdr(assoc 10 mau)))
(setq xm (car ptmau))
(foreach e lst
(setq ent (entget e))
(setq pti (cdr(assoc 10 ent)))
(setq xi (car pti))
(setq ddauu (list (+ (car ddau) di (* i kc)) (cadr ddau)))
(if (= xi xm) (setq ptgoc (list (+ (car ddau) di (* i kc)) (cadr ddau))))
(setq TBi  (textbox ent) LCi  (car TBi) RCi (cadr TBi) dii (distance LCi RCi) di (+ di dii))
(setvar "osmode" 0)
(command "move" e "" pti ddauu)
(setq 	a2 (ssadd e a2))
(setq i (1+ i))
);foreach
(command "move" a2 "" ptgoc ptmau)
(setvar "osmode" oldos)
(prompt"\n[Dan deu khoang cach TEXT theo phuong ngang] by Thaistreetz - huuthais@yahoo.com\n")
(command "undo" "end")
(Princ)
)
;========================================================================
;Sap xep text thang hang (co cung tung do Y)
;========================================================================
(defun c:dx()
(setq oldos (getvar "osmode"))
(setq txt (ssget '((0 . "TEXT"))))
(command "undo" "begin")
(setq ym (cadr (cdr(assoc 10 (entget (car (entsel "\nChon text chuan")))))) i 0)
(repeat (sslength txt)
(setq txt_pt (cdr(assoc 10 (entget (ssname txt i)))))
(setq ptcuoi (list (car txt_pt) ym))
(setvar "osmode" 0)
(command "move" (ssname txt i) "" txt_pt ptcuoi)
(setq i (+ i 1))
);repeat
(setvar "osmode" oldos)
(prompt"\n[Sap xep text thang hang] by Thaistreetz - huuthais@yahoo.com\n")
(command "undo" "end")
(Princ)
)


;;; ====================================================================================================
;;; END SOURCE: CanChinhText-ft_df_dfx_dx.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: D_TNT_Text_Mask.lsp
;;; ====================================================================================================
;;------------------------------=={ Mask }==----------------------------;;
;;                                                                      ;;
;;  This program allows the user to manipulate all available properties ;;
;;  of the background mask for a selection of Multiline Text (MText),   ;;
;;  Multileader (MLeader), and Dimension objects.                       ;;
;;                                                                      ;;
;;  Upon calling the program with the syntax 'bmask', the user is       ;;
;;  prompted to make a selection of MText, MLeaders and/or Dimensions   ;;
;;  for which to alter the background mask settings.                    ;;
;;                                                                      ;;
;;  Following a valid selection, the user is presented with a dialog    ;;
;;  interface, enabling the user to toggle the use of a background      ;;
;;  mask, change the mask offset (not applicable to dimensions), and    ;;
;;  change the mask colour for all objects in the selection             ;;
;;  simultaneously.                                                     ;;
;;                                                                      ;;
;;  The background mask for dimensions will be applied as a dimension   ;;
;;  style override unless the settings held by the dimension style      ;;
;;  associated with the dimension match those selected by the user.     ;;
;;                                                                      ;;
;;  The background mask offset is only applicable to MText & MLeader    ;;
;;  objects and will therefore have no effect on selected Dimensions.   ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.AUTHOR*:  Lee Mac, Copyright � 2012  -  www.lee-mac.com              ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.VERSION* 1.0    -    2012-04-16                                      ;;
;;                                                                      ;;
;;  - First release.                                                    ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.VERSION* 1.1    -    2013-02-06                                      ;;
;;                                                                      ;;
;;  - Changed command syntax to 'bmask' since 'mask' is an existing     ;;
;;    command in AutoCAD Civil 3D.                                      ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.VERSION* 1.2    -    2016-05-22                                      ;;
;;                                                                      ;;
;;  - Program restructured to enable dialog bypass.                     ;;
;;  - Added ability to mask dimensions.                                 ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.VERSION* 1.3    -    2016-05-23                                      ;;
;;                                                                      ;;
;;  - Defined dedicated mask:selection function to facilitate the       ;;
;;    creation of custom programs which bypass the program dialog.      ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.VERSION* 1.4    -    2017-04-17                                      ;;
;;                                                                      ;;
;;  - Fixed a bug causing the program to crash when modifying the       ;;
;;    background mask of dimensions with dimension style overrides.     ;;
;;----------------------------------------------------------------------;;
;;  *TNT.TEXT.ED2.VERSION* 1.5    -    2018-11-10                                      ;;
;;                                                                      ;;
;;  - Added code to account for a bug in AutoCAD in which multileader   ;;
;;    text spacing is altered after modifying the background mask.      ;;
;;----------------------------------------------------------------------;;

(defun c:bmask ( / *error* key sel tmp )
    
    (defun *error* ( msg )
        (if (< 0 dch)
            (setq dch (unload_dialog dch))
        )
        (if (= 'file (type des))
            (close des)
        )
        (if (and (= 'str (type dcl)) (findfile dcl))
            (vl-file-delete dcl)
        )
        (mask:endundo (mask:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )

    (setq key "LMac\\mask")
    (if (and (setq sel (mask:selection "\nSelect mtext, mleaders or dimensions: "))
             (setq tmp (mask:settings (mask:getdefaults key)))
        )
        (progn
            (mask:setdefaults key tmp)
            (apply 'mask:main (cons sel tmp))
        )
    )
    (princ)
)

;;----------------------------------------------------------------------;;

(defun mask:getdefaults ( key / tmp )
    (if
        (not
            (and
                (setq tmp (getenv key))
                (= 'list (type (setq tmp (read tmp))))
                (= 4 (length tmp))
            )
        )
        (mask:setdefaults key '("0" 1.5 "0" ((62 . 1))))
        tmp
    )
)

;;----------------------------------------------------------------------;;

(defun mask:setdefaults ( key val )
    (if (apply 'and val)
        (setenv key (vl-prin1-to-string val))
    )
    val
)

;;----------------------------------------------------------------------;;

(defun mask:settings ( arg / col dcf dch dcl des dis fn1 fn2 fn3 img msk off rtn trn )
    (mapcar 'set '(msk off trn col) arg)
    (cond
        (   (not
                (and
                    (setq dcl (vl-filename-mktemp nil nil ".dcl"))
                    (setq des (open dcl "w"))
                    (progn
                        (foreach str
                           '(
                                "imgbox : image_button"
                                "{"
                                "    alignment = centered;"
                                "    height = 1.5;"
                                "    aspect_ratio = 1;"
                                "    fixed_width = true;"
                                "    fixed_height = true;"
                                "    color = 1;"
                                "}"
                                "mask : dialog"
                                "{"
                                "    label = \"Background Mask\";"
                                "    spacer;"
                                "    : toggle"
                                "    {"
                                "        label = \"Use Background Mask\";"
                                "        key = \"msk\";"
                                "    }"
                                "    spacer;"
                                "    : boxed_column"
                                "    {"
                                "        label = \"Mask Offset\";"
                                "        : row"
                                "        {"
                                "            alignment = centered;"
                                "            : edit_box"
                                "            {"
                                "                key = \"off\";"
                                "            }"
                                "            : button"
                                "            {"
                                "                label = \">>\";"
                                "                key = \"pik\";"
                                "                fixed_width = true;"
                                "            }"
                                "        }"
                                "        spacer;"
                                "    }"
                                "    spacer;"
                                "    : boxed_column"
                                "    {"
                                "        label = \"Fill Color\";"
                                "        : row"
                                "        {"
                                "            alignment = centered;"
                                "            fixed_width = true;"
                                "            : toggle"
                                "            {"
                                "                key = \"trn\";"
                                "                label = \"Transparent\";"
                                "            }"
                                "            : imgbox"
                                "            {"
                                "                key = \"col\";"
                                "            }"
                                "        }"
                                "        spacer;"
                                "    }"
                                "    spacer;"
                                "    ok_cancel;"
                                "}"
                            )
                            (write-line str des)
                        )
                        (setq des (close des))
                        (< 0 (setq dch (load_dialog dcl)))
                    )
                )
            )
            (prompt "\nUnable to write and/or load Mask dialog.")
        )
        (   (progn
                (while (not (member dcf '(0 1)))
                    (cond
                        (   (null (new_dialog "mask" dch))
                            (princ "\nMask dialog not defined.")
                            (setq dcf 0)
                        )
                        (   t
                            (setq img
                                (lambda ( key aci )
                                    (start_image key)
                                    (fill_image 0 0 (dimx_tile key) (dimy_tile key) aci)
                                    (end_image)
                                )
                            )
                            (   (setq fn1
                                    (lambda ( )
                                        (img "col"
                                            (cond
                                                (   (= "0" msk) -15)
                                                (   (= "1" trn)   0)
                                                (   (cdr (assoc 62 col)))
                                                (   -15   )
                                            )
                                        )
                                    )
                                )
                            )
                            (   (setq fn2
                                    (lambda ( val )
                                        (fn1) (mode_tile "col" (atoi val))
                                    )
                                )
                                (set_tile "trn" trn)
                            )
                            (   (setq fn3
                                    (lambda ( val )
                                        (setq val (- 1 (atoi val)))
                                        (foreach key  '("off" "pik" "trn" "col")
                                            (mode_tile key val)
                                        )
                                        (fn2 (if (= "0" msk) "1" trn))
                                    )
                                )
                                (set_tile "msk" msk)
                            )
                            (action_tile "trn" "(fn2 (setq trn $value))")
                            (action_tile "msk" "(fn3 (setq msk $value))")
                        
                            (set_tile    "off" (rtos off 2))
                            (action_tile "off"
                                (vl-prin1-to-string
                                   '(if
                                        (or
                                            (null (setq dis (distof $value)))
                                            (< 5.0 dis)
                                            (< dis 1.0)
                                        )
                                        (progn
                                            (alert "Please provide a value between 1 and 5.")
                                            (set_tile "off" (rtos off 2))
                                            (mode_tile "off" 2)
                                        )
                                        (set_tile "off" (rtos (setq off dis) 2))
                                    )
                                )
                            )

                            (action_tile "col"
                                (vl-prin1-to-string
                                   '(if (setq tmp (acad_truecolordlg (vl-some '(lambda ( x ) (assoc x col)) '(430 420 62)) nil))
                                        (img "col" (cdr (assoc 62 (setq col tmp))))
                                    )
                                )
                            )
                            (action_tile "pik" "(done_dialog 2)")
                         
                            (setq dcf (start_dialog))
                        )
                    )
                    (if
                        (and (= 2 dcf)
                            (progn
                                (while
                                    (not
                                        (or (null (setq dis (getdist (strcat "\nPick Mask Offset Factor <" (rtos off 2) ">: "))))
                                            (<= 1.0 dis 5.0)
                                        )
                                    )
                                    (princ "\nOffset must be between 1 and 5.")
                                )
                                dis
                            )
                        )
                        (setq off dis)
                    )
                )
                (zerop dcf)
            )
            (prompt "\n*Cancel*")
        )
        (   (setq rtn (list msk off trn col)))
    )
    (if (< 0 dch)
        (setq dch (unload_dialog dch))
    )
    (if (and dcl (findfile dcl))
        (vl-file-delete dcl)
    )
    rtn
)

;;----------------------------------------------------------------------;;

(defun mask:selection ( msg )
    (mask:ssget msg
       '("_:L" ((0 . "*DIMENSION,MTEXT,MULTILEADER")))
    )
)

;;----------------------------------------------------------------------;;

(defun mask:main ( sel msk off trn col )
    (mask:maskselection sel (= "1" msk) off (= "1" trn) col)
)

;;----------------------------------------------------------------------;;

(defun mask:maskselection ( sel msk off trn col / idx )
    (if (= 'pickset (type sel))
        (repeat (setq idx (sslength sel))
            (mask:maskentity (ssname sel (setq idx (1- idx))) msk off trn col)
        )
    )
)

;;----------------------------------------------------------------------;;

(defun mask:maskentity ( ent msk off trn col / enx typ )
    (setq enx (entget ent)
          typ (cdr (assoc 0 enx))
    )
    (cond
        (   (= "MTEXT" typ)
            (if msk
                (entmod
                    (append (vl-remove-if '(lambda ( x ) (member (car x) '(45 63 90 421 431 441))) enx)
                        (if trn
                           '((90 . 3) (63 . 256))
                            (cons '(90 . 1) (mapcar '(lambda ( x ) (cons (1+ (car x)) (cdr x))) col))
                        )
                        (list (cons 45 off) '(441 . 0))
                    )
                )
                (vla-put-backgroundfill (vlax-ename->vla-object (cdr (assoc -1 enx))) :vlax-false)
            )
        )
        (   (= "MULTILEADER" typ)
            (entmod
                (mask:substonce enx
                    (if msk
                        (list
                            (cons 091 (mask:color->mleadercolor (if trn '((62 . 256)) col)))
                            (cons 141 off)
                            (if trn '(291 . 1) '(291 . 0))
                           '(292 . 1)
                        )
                       '((292 . 0))
                    )
                )
            )
            (vla-put-textlinespacingfactor (vlax-ename->vla-object ent) (cdr (assoc 045 enx))) ;; AutoCAD bug
        )
        (   (wcmatch typ "*DIMENSION")
            (setq sty (mask:dimstylefill (cdr (assoc 3 enx)))
                  ovr (vl-remove-if '(lambda ( x ) (< 68 (cdar x) 71)) (mask:getdimxdata ent))
            )
            (cond
                (   (not msk)
                    (if (assoc 69 sty)
                        (mask:setdimxdata ent (append ovr '(((1070 . 70) (1070 . 0)) ((1070 . 69) (1070 . 0)))))
                        (mask:setdimxdata ent ovr)
                    )
                )
                (   trn
                    (if (= 1 (cdr (assoc 69 sty)))
                        (mask:setdimxdata ent ovr)
                        (mask:setdimxdata ent (append ovr '(((1070 . 69) (1070 . 1)))))
                    )
                )
                (   (and (= 2 (cdr (assoc 69 sty)))
                         (=   (cdr (assoc 62 col)) (cdr (assoc 70 sty)))
                    )
                    (mask:setdimxdata ent ovr)
                )
                (   (mask:setdimxdata ent (append ovr (list (list '(1070 . 70) (cons 1070 (cdr (assoc 62 col)))) '((1070 . 69) (1070 . 2))))))
            )
        )
    )
)

;;----------------------------------------------------------------------;;

(defun mask:dimstylefill ( sty / tmp )
    (if
        (and
            (setq sty (tblobjname "dimstyle" sty))
            (setq sty (entget sty))
            (setq tmp (assoc 69 sty))
        )
        (list tmp (assoc 70 (member tmp sty)))
    )
)

;;----------------------------------------------------------------------;;

(defun mask:getdimxdata ( dim / lst ovr )
    (setq lst (cddr (member '(1000 . "DSTYLE") (cdadr (assoc -3 (entget dim '("acad")))))))
    (while (and lst (not (equal '(1002 . "}") (car lst))))
        (setq ovr (cons (list (car lst) (cadr lst)) ovr)
              lst (cddr lst)
        )
    )
    (reverse ovr)
)

;;----------------------------------------------------------------------;;

(defun mask:setdimxdata ( dim ovr / lst tmp )
    (if ovr
        (setq ovr
           (append
               '(
                    (1000 . "DSTYLE")
                    (1002 . "{")
                )
                (apply 'append ovr)
               '(
                    (1002 . "}")
                )
            )
        )
    )
    (cond
        (   (not (setq lst (cdadr (assoc -3 (entget dim '("acad"))))))
            (regapp "acad")
            (entmod (append (entget dim) (list (list -3 (cons "acad" ovr)))))
        )
        (   (setq tmp (member '(1000 . "DSTYLE") lst))
            (entmod
                (append (entget dim)
                    (list
                        (list -3
                            (cons "acad"
                                (append
                                    (reverse (cdr (member '(1000 . "DSTYLE") (reverse lst))))
                                    ovr
                                    (cdr (member '(1002 . "}") tmp))
                                )
                            )
                        )
                    )
                )
            )
        )
        (   (entmod (append (entget dim) (list (list -3 (cons "acad" (append lst ovr)))))))
    )
)

;;----------------------------------------------------------------------;;

(defun mask:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)

;;----------------------------------------------------------------------;;

(defun mask:substonce ( enx lst )
    (mapcar
       '(lambda ( dxf / itm )
            (cond
                (   (setq itm (assoc (car dxf) lst))
                    (setq lst (vl-remove itm lst))
                    itm
                )
                (   dxf   )
            )
        )
        enx
    )
)

;;----------------------------------------------------------------------;;

(defun mask:color->mleadercolor ( c / x )
    (cond
        (   (setq x (cdr (assoc 420 c))) (+ -1040187392 x))
        (   (zerop (setq x (cdr (assoc 62 c)))) -1056964608)
        (   (= 256 x) -1073741824)
        (   (< 0 x 256) (+ -1023410176 x))
    )
)

;;----------------------------------------------------------------------;;

(defun mask:startundo ( doc )
    (mask:endundo doc)
    (vla-startundomark doc)
)

;;----------------------------------------------------------------------;;

(defun mask:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;;----------------------------------------------------------------------;;

(defun mask:acdoc nil
    (eval (list 'defun 'mask:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (mask:acdoc)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
;;; ====================================================================================================
;;; END SOURCE: D_TNT_Text_Mask.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: F_A1_TEXT_CHINH SUA TEXT.lsp
;;; ====================================================================================================
;; ------------------ Biến toàn cục phần mềm (khởi tạo 1 lần) -------------------
(setq *TNT.TEXT.ED2.NAME* "Edit Text "
      *TNT.TEXT.ED2.VERSION* "1.00"
      *TNT.TEXT.ED2.AUTHOR* "Tam Pham Nhu"
      *TNT.TEXT.ED2.EMAIL* "Nhutam104@gmail.com"
      *TNT.TEXT.ED2.CITY* "HaNoi *TNT.TEXT.ED2.CITY* - Vietnam"
      *TNT.TEXT.ED2.PHONE* "+84 983 890 491"
)

;; ------------------ Hàm khởi động chỉnh sửa thuộc tính -----------------------
(defun C:ED2 (/ *error* DCLEDITTEXT DCLABOUT CURCMD CANCEL-PRESSED ATT)
  (setq *error* TNT:TEXT:ED2:ERR)
  (vl-load-com)
  (setq DCLEDITTEXT (TNT:TEXT:ED2:CREATE-EDIT-TEXT-DIALOG))
  (setq DCLABOUT (TNT:TEXT:ED2:CREATE-ABOUT-DIALOG)) ; Khởi tạo DCLABOUT 1 lần dùng toàn phiên
  (setq CURCMD (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setq CANCEL-PRESSED nil)
  (while (and (not CANCEL-PRESSED)
              (/= (setq ATT (car (nentselp "\nSelect Attribute for edit: "))) nil))
    (if (member (TNT:TEXT:ED2:GET-GC 0 ATT) '("ATTRIB" "TEXT" "MTEXT" "DIMENSION"))
        (TNT:TEXT:ED2:EDIT-ATTRIBUTE ATT (TNT:TEXT:ED2:GET-GC 1 ATT) DCLEDITTEXT DCLABOUT)
      (princ "\nSelect ATTRIB/TEXT/MTEXT/DIMENSION")))
  (setvar "CMDECHO" CURCMD)
  (setq *error* nil)
  (princ)
)

;; ------------------ Hàm xử lý lỗi ----------------------
(defun TNT:TEXT:ED2:ERR (MSG)
  (cond 
    ((= MSG "Function cancelled") (princ "\n\tUser abort"))
    (t (princ MSG)))
  (setq *error* nil)
  (princ)
)

;; ----------------- Hàm get/put thuộc tính ---------------------
(defun TNT:TEXT:ED2:GET-GC (GROUP ENTITY)
  (cdr (assoc GROUP (entget ENTITY)))
)

(defun TNT:TEXT:ED2:PUT-GC (VALUE GROUP ENTITY)
  (entmod (subst (cons GROUP VALUE) (assoc GROUP (entget ENTITY)) (entget ENTITY)))
)

;; ----------------- Hàm chỉnh sửa thuộc tính -------------------
(defun TNT:TEXT:ED2:EDIT-ATTRIBUTE (ATT OLDVAL DCLEDITTEXT DCLABOUT)
  (setq TEXT OLDVAL)
  (TNT:TEXT:ED2:SHOW-EDIT-DIALOG DCLEDITTEXT OLDVAL DCLABOUT)
  (TNT:TEXT:ED2:PUT-GC TEXT 1 ATT)
)

;; ----------------- Hàm ghi file DCL tạm -----------------------
(defun TNT:TEXT:ED2:MAKE-FILE-DCL (DCL-LINES NAME)
  (setq FNAME (vl-filename-mktemp (strcat NAME ".dcl"))
        FILE  (open FNAME "w"))
  (foreach LL DCL-LINES (write-line LL FILE))
  (close FILE)
  FNAME
)

;; ----------------- Hàm hiển thị hộp thoại chỉnh sửa -----------
(defun TNT:TEXT:ED2:SHOW-EDIT-DIALOG (DCLEDITTEXT OLDVAL DCLABOUT / DCL_ID_EDIT)
  (setq DCL_ID_EDIT (load_dialog (TNT:TEXT:ED2:MAKE-FILE-DCL DCLEDITTEXT "EditText")))
  (if (< DCL_ID_EDIT 1)
      (progn (alert "Không tìm thấy file EditText.DCL") (exit)))
  (if (not (new_dialog "EDIT" DCL_ID_EDIT))
      (progn (alert "Không tìm thấy hộp thoại EDIT") (exit)))
  (TNT:TEXT:ED2:SET_TILE_DECORATION 4)
  (set_tile "text" OLDVAL)
  (action_tile "Tile_Ok"     "(setq TEXT (get_tile \"text\"))(done_dialog)")
  (action_tile "Tile_Cancel" "(setq CANCEL-PRESSED T)(done_dialog)")
  ;; Truyền DCLABOUT qua closure để luôn gọi đúng thông tin
  (action_tile "Tile_About"  "(TNT:TEXT:ED2:SHOW-ABOUT-DIALOG DCLABOUT)")
  (start_dialog)
  (unload_dialog DCL_ID_EDIT)
)

;; --------------- Hàm hiển thị hộp thoại About -----------------
(defun TNT:TEXT:ED2:SHOW-ABOUT-DIALOG (DCLABOUT / DCL_ID_ABOUT)
  (setq DCL_ID_ABOUT (load_dialog (TNT:TEXT:ED2:MAKE-FILE-DCL DCLABOUT "About")))
  (if (< DCL_ID_ABOUT 1)
      (progn (alert "Không tìm thấy file About.DCL") (exit)))
  (if (not (new_dialog "ABOUT" DCL_ID_ABOUT))
      (progn (alert "Không tìm thấy hộp thoại ABOUT") (exit)))
  (TNT:TEXT:ED2:SET_TILE_OF_SEP "sep1")
  (TNT:TEXT:ED2:SET_TILE_OF_SEP "sep2")
  (start_dialog)
  (unload_dialog DCL_ID_ABOUT)
)

;; ------------- Hàm tạo DCL chỉnh sửa văn bản -------------------
(defun TNT:TEXT:ED2:CREATE-EDIT-TEXT-DIALOG ()
  (list 
    "EDIT : dialog {"
    (strcat " label = \"" *TNT.TEXT.ED2.NAME* *TNT.TEXT.ED2.VERSION* "\";")
    " initial_focus = \"text\";"
    " : column {"
    "   : text { key = \"txt1\"; value = \"- This is the main dialogue box.\"; }"
    "   : text { key = \"txt2\"; value = \"- To display the next, nested dialogue,\"; }"
    "   : text { key = \"txt3\"; value = \"- Press Next...\"; }"
    "   : spacer { width = 1; }"
    "   : text { key = \"sep0\"; }"
    "   : edit_box { label = \"TEXT CHANGE:\"; allow_accept = true; edit_width = 40; key = \"text\"; }"
    "   : text { key = \"sep1\"; }"
    "   : row {"
    "     : spacer { width = 1; }"
    "     : button { label = \"Accept\"; key = \"Tile_Ok\"; width = 12; fixed_width = true; mnemonic = A; is_default = true; }"
    "     : button { label = \"Cancel\"; key = \"Tile_Cancel\"; width = 12; fixed_width = true; mnemonic = C; is_cancel = true; }"
    "     : button { label = \"About...\"; key = \"Tile_About\"; width = 12; fixed_width = true; mnemonic = B; }"
    "     : spacer { width = 1; }"
    "   }"
    " }"
    "}"
  )
)

;; ------------- Hàm tạo DCL About -------------------------------
(defun TNT:TEXT:ED2:CREATE-ABOUT-DIALOG ()
  (list
    "ABOUT : dialog {"
    " label = \"Information\";"
    " : boxed_column {"
    (strcat "   : text { label = \"" *TNT.TEXT.ED2.NAME* *TNT.TEXT.ED2.VERSION* "\"; };")
    "   : text { label = \"Copyright © TNT\"; };"
    "   : text { key = \"sep1\"; };"
    "   : row {"
    "     : column {"
    "       : text { label = \"     *TNT.TEXT.ED2.AUTHOR*\"; };"
    "       : text { label = \"     From\"; };"
    "       : text { label = \"     *TNT.TEXT.ED2.EMAIL*\"; };"
    "       : text { label = \"     Telephone\"; };"
    "     };"
    "     : column {"
    (strcat "       : text { label = \"     : " *TNT.TEXT.ED2.AUTHOR* "\"; };")
    (strcat "       : text { label = \"     : " *TNT.TEXT.ED2.CITY* "\"; };")
    (strcat "       : text { label = \"     : " *TNT.TEXT.ED2.EMAIL* "\"; };")
    (strcat "       : text { label = \"     : " *TNT.TEXT.ED2.PHONE* "\"; };")
    "     };"
    "   };"
    "   : text { key = \"sep2\"; };"
    "   : paragraph { width = 80;"
    (strcat "     : text_part { value = \"Any comments please send email to " *TNT.TEXT.ED2.EMAIL* "\"; };")
    "     : text_part { value = \"Thank you for using and supporting.\"; };"
    "   };"
    " };"
    " : button { label = \"&OK\"; key = \"OkAbout\"; is_default = true; is_cancel = true; width = 15; };"
    "}"
  )
)


;; ------------- Hàm trang trí separator DCL ---------------------
(defun TNT:TEXT:ED2:SET_TILE_DECORATION (NumTotal / Num Tile)
  (setq Num 0)
  (repeat NumTotal
    (setq Tile (strcat "sep" (itoa Num)))
    (set_tile Tile
      "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    )
    (setq Num (+ Num 1))
  )
)

(defun TNT:TEXT:ED2:SET_TILE_OF_SEP (Tile /)
  (set_tile Tile
    "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
  )
  (mode_tile Tile 1)
)

;;; ====================================================================================================
;;; END SOURCE: F_A1_TEXT_CHINH SUA TEXT.lsp
;;; ====================================================================================================

(princ "`n[TNT] Loaded TNT_PACKAGE_06_TEXT_ALL.lsp")
(princ)
