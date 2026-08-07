;;; TNT_STT.lsp
;;; Standalone STT numbering tool for Text, Mtext, Block Attribute, and Dimension.

(vl-load-com)

(defun TNT:STT-AttGet (ent / enx)
  (if (and (setq ent (entnext ent))
           (= "ATTRIB" (cdr (assoc 0 (setq enx (entget ent))))))
    (cons
      (cons (cdr (assoc 2 enx)) (cdr (assoc 1 (reverse enx))))
      (TNT:STT-AttGet ent)
    )
  )
)

(defun TNT:STT-AttSet (ent tag val)
  (setq tag (strcase tag))
  (vl-some
    '(lambda (att)
       (if (= tag (strcase (vla-get-TagString att)))
         (progn
           (vla-put-TextString att val)
           val
         )
       )
     )
    (vlax-invoke (vlax-ename->vla-object ent) 'GetAttributes)
  )
)

(defun TNT:STT-Unique (lst)
  (if lst
    (cons (car lst) (TNT:STT-Unique (vl-remove (car lst) (cdr lst))))
  )
)

(defun TNT:STT-Point (ent / data pt)
  (setq data (entget ent)
        pt   (cdr (assoc 11 data)))
  (if (or (null pt)
          (equal (list (car pt) (cadr pt)) '(0.0 0.0))
          (equal (list (car pt) (cadr pt)) '(1.0 0.0)))
    (cdr (assoc 10 data))
    pt
  )
)

(defun TNT:STT-DimPoint (ent / data pt p13 p14)
  (setq data (entget ent))
  (if (wcmatch (cdr (assoc 0 data)) "*DIMENSION")
    (progn
      (setq p13 (cdr (assoc 13 data))
            p14 (cdr (assoc 14 data)))
      (list
        (/ (+ (car p13) (car p14)) 2.0)
        (/ (+ (cadr p13) (cadr p14)) 2.0)
        0.0
      )
    )
    (TNT:STT-Point ent)
  )
)

(defun TNT:STT-Unformat (str / replace rx result)
  (defun replace (new old value)
    (vlax-put-property rx 'Pattern old)
    (vlax-invoke rx 'Replace value new)
  )
  (if (and str (setq rx (vlax-get-or-create-object "VBScript.RegExp")))
    (progn
      (setq result
        (vl-catch-all-apply
          '(lambda ()
             (vlax-put-property rx 'Global :vlax-true)
             (vlax-put-property rx 'MultiLine :vlax-true)
             (vlax-put-property rx 'IgnoreCase :vlax-false)
             (foreach pair
               '(
                  ("\032"    . "\\\\\\\\")
                  (" "       . "\\\\P|\\n|\\t")
                  ("$1"      . "\\\\(\\\\[ACcFfHLlOopQTW])|\\\\[ACcFfHLlOopQTW][^\\\\;]*;|\\\\[ACcFfHLlOopQTW]")
                  ("$1$2/$3" . "([^\\\\])\\\\S([^;]*)[/#\\^]([^;]*);")
                  ("$1$2"    . "\\\\(\\\\S)|[\\\\](})|}")
                  ("$1"      . "[\\\\]({)|{")
                )
               (setq str (replace (car pair) (cdr pair) str))
             )
             (replace "\\" "\032" str)
           )
        )
      )
      (vlax-release-object rx)
      (if (not (vl-catch-all-error-p result)) result str)
    )
    str
  )
)

(defun TNT:STT-GetReal (default promptText / value)
  (while (null value)
    (setq value
      (getstring
        (strcat
          "\n" promptText " <"
          (rtos (float default) 2 (getvar "LUPREC"))
          ">: "
        )
      )
    )
    (if (= "." (substr value 1 1))
      (setq value (strcat "0" value))
    )
    (setq value
      (cond
        ((= value "") (float default))
        ((numberp (read value)) (atof value))
        (t nil)
      )
    )
  )
  value
)

(defun TNT:STT-GetKey (items default promptText / clean defaults init result shown)
  (setq clean
    (mapcar
      '(lambda (item)
         (while (vl-string-search " " item)
           (setq item (vl-string-subst "" " " item))
         )
         item
       )
      items
    )
  )
  (setq defaults
    (mapcar
      '(lambda (item)
         (while (vl-string-search "_" item)
           (setq item (vl-string-subst "" "_" item))
         )
         item
       )
      items
    )
  )
  (setq init  (apply 'strcat (mapcar '(lambda (x) (strcat " " x)) clean))
        shown (apply 'strcat (mapcar '(lambda (x) (strcat "/" x)) defaults)))
  (setq init  (substr init 2)
        shown (substr shown 2))
  (if (member default items)
    (setq default (nth (vl-position default items) defaults))
    (setq default (car defaults))
  )
  (initget init)
  (setq result
    (getkword (strcat "\n" promptText " [" shown "] <" default ">: ")))
  (if result
    (nth (vl-position result clean) items)
    (nth (vl-position default defaults) items)
  )
)

(defun TNT:STT-PickEntity (typePattern promptText / ent)
  (while (null ent)
    (setq ent (car (entsel (strcat "\n" promptText))))
    (if (and ent (not (wcmatch (cdr (assoc 0 (entget ent))) typePattern)))
      (setq ent nil)
    )
  )
  ent
)

(defun TNT:STT-ListBox (items message width height multiple / dch file handle result)
  (if (> (length items) 1)
    (progn
      (setq file   (vl-filename-mktemp "TNT_STT_LIST_" nil ".dcl")
            handle (open file "w"))
      (write-line
        (strcat
          "tnt_stt_list:dialog{label=\"" message
          "\";spacer;:list_box{key=\"list\";multiple_select="
          (if multiple "true" "false")
          ";width=" (itoa width) ";height=" (itoa height)
          ";}spacer;ok_cancel;}"
        )
        handle
      )
      (close handle)
      (if (and (> (setq dch (load_dialog file)) 0)
               (new_dialog "tnt_stt_list" dch))
        (progn
          (start_list "list")
          (mapcar 'add_list items)
          (end_list)
          (set_tile "list" "0")
          (setq result "0")
          (action_tile "list" "(setq result $value)")
          (if (= 1 (start_dialog))
            (setq result
              (mapcar
                '(lambda (index) (nth index items))
                (read (strcat "(" result ")"))
              )
            )
            (setq result nil)
          )
        )
      )
      (if (and dch (> dch 0)) (unload_dialog dch))
      (if (findfile file) (vl-file-delete file))
      result
    )
    items
  )
)

(defun TNT:STT-SortXY (entities firstOrder secondOrder fuzz)
  (if secondOrder
    (vl-sort entities
      '(lambda (e1 e2 / p1 p2)
         (setq p1 (trans (TNT:STT-Point e1) 0 1)
               p2 (trans (TNT:STT-Point e2) 0 1))
         (if (wcmatch firstOrder "L,R")
           (if (equal (cadr p1) (cadr p2) fuzz)
             (if (= firstOrder "L")
               (< (car p1) (car p2))
               (> (car p1) (car p2))
             )
             (if (= secondOrder "D")
               (< (cadr p1) (cadr p2))
               (> (cadr p1) (cadr p2))
             )
           )
           (if (equal (car p1) (car p2) fuzz)
             (if (= firstOrder "D")
               (< (cadr p1) (cadr p2))
               (> (cadr p1) (cadr p2))
             )
             (if (= secondOrder "L")
               (< (car p1) (car p2))
               (> (car p1) (car p2))
             )
           )
         )
       )
    )
    (cond
      ((= firstOrder "U")
       (vl-sort entities
         '(lambda (e1 e2)
            (> (cadr (trans (TNT:STT-Point e1) 0 1))
               (cadr (trans (TNT:STT-Point e2) 0 1))))))
      ((= firstOrder "D")
       (vl-sort entities
         '(lambda (e1 e2)
            (< (cadr (trans (TNT:STT-Point e1) 0 1))
               (cadr (trans (TNT:STT-Point e2) 0 1))))))
      ((= firstOrder "L")
       (vl-sort entities
         '(lambda (e1 e2)
            (< (car (trans (TNT:STT-Point e1) 0 1))
               (car (trans (TNT:STT-Point e2) 0 1))))))
      ((= firstOrder "R")
       (vl-sort entities
         '(lambda (e1 e2)
            (> (car (trans (TNT:STT-Point e1) 0 1))
               (car (trans (TNT:STT-Point e2) 0 1))))))
      (t entities)
    )
  )
)

(defun TNT:STT-SortPline
  (entities / curve directionPoint distances firstPoint fuzz obj sample sorted startDistance type)
  (setq curve (TNT:STT-PickEntity "*LINE" "Chon Pline: "))
  (setq firstPoint (trans (getpoint "\nChon diem dau: ") 1 0))
  (setq firstPoint
    (car
      (vl-sort
        (mapcar 'TNT:STT-DimPoint entities)
        '(lambda (a b) (< (distance firstPoint a) (distance firstPoint b)))
      )
    )
  )
  (setq firstPoint     (vlax-curve-getClosestPointTo curve firstPoint)
        directionPoint (trans (getpoint (trans firstPoint 0 1) "\nChon huong: ") 1 0)
        directionPoint (vlax-curve-getClosestPointTo curve directionPoint)
        startDistance  (vlax-curve-getDistAtPoint curve firstPoint)
        distances      (vlax-curve-getDistAtPoint curve directionPoint)
        sample         (car entities)
        obj            (vlax-ename->vla-object sample)
        type           (cdr (assoc 0 (entget sample))))
  (setq fuzz
    (* 0.5
      (cond
        ((= type "INSERT") (cdr (assoc 41 (entget sample))))
        ((wcmatch type "*TEXT") (cdr (assoc 40 (entget sample))))
        ((wcmatch type "*DIMENSION")
         (* (vla-get-TextHeight obj) (vla-get-ScaleFactor obj)))
        (t 0.0)
      )
    )
  )
  (setq entities
    (vl-remove-if
      '(lambda (ent)
         (> (distance
              (TNT:STT-DimPoint ent)
              (vlax-curve-getClosestPointTo curve (TNT:STT-DimPoint ent)))
            fuzz))
      entities
    )
  )
  (setq sorted
    (vl-sort entities
      '(lambda (e1 e2)
         (<
           (vlax-curve-getDistAtPoint
             curve
             (vlax-curve-getClosestPointTo curve (TNT:STT-DimPoint e1)))
           (vlax-curve-getDistAtPoint
             curve
             (vlax-curve-getClosestPointTo curve (TNT:STT-DimPoint e2)))
         )
       )
    )
  )
  (setq sorted
    (mapcar
      '(lambda (ent)
         (cons
           (vlax-curve-getDistAtPoint
             curve
             (vlax-curve-getClosestPointTo curve (TNT:STT-DimPoint ent)))
           ent
         )
       )
      sorted
    )
  )
  (if (> startDistance distances) (setq sorted (reverse sorted)))
  (setq sorted
    (append
      (member (assoc startDistance sorted) sorted)
      (reverse (cdr (member (assoc startDistance sorted) (reverse sorted))))
    )
  )
  (mapcar 'cdr sorted)
)

(defun TNT:STT-WriteDcl (file / handle)
  (setq handle (open file "w"))
  (foreach line
    '(
      "TNT_STT:dialog { label=\"Danh so thu tu Text, Att, Dim\";"
      "  :row {"
      "    :boxed_column { label=\"Doi tuong\";"
      "      :toggle { key=\"obj_blk\"; label=\"Block Attribute\"; }"
      "      :toggle { key=\"obj_txt\"; label=\"Text\"; }"
      "      :toggle { key=\"obj_mtx\"; label=\"Mtext\"; }"
      "      :toggle { key=\"obj_dim\"; label=\"Dimension\"; }"
      "      :radio_button { key=\"dim_pre\"; label=\"Dim prefix\"; }"
      "      :radio_button { key=\"dim_suf\"; label=\"Dim suffix\"; }"
      "      :radio_button { key=\"dim_ovr\"; label=\"Text override\"; }"
      "    }"
      "    :column {"
      "      :boxed_column { label=\"Phuong thuc nhap\";"
      "        :radio_button { key=\"mode_ovr\"; label=\"Ghi de\"; }"
      "        :radio_button { key=\"mode_left\"; label=\"Them vao dau\"; }"
      "        :radio_button { key=\"mode_right\"; label=\"Them vao cuoi\"; }"
      "      }"
      "      :boxed_column { label=\"Quy tac danh so\";"
      "        :edit_box { key=\"prefix\"; label=\"Tien to\"; edit_width=8; }"
      "        :edit_box { key=\"suffix\"; label=\"Hau to\"; edit_width=8; }"
      "        :edit_box { key=\"start\"; label=\"STT bat dau\"; edit_width=8; }"
      "        :text { label=\"Bat dau bang so hoac mot chu cai.\"; }"
      "      }"
      "    }"
      "  }"
      "  ok_cancel;"
      "}"
    )
    (write-line line handle)
  )
  (close handle)
  file
)

(defun TNT:STT-DimMode ()
  (mode_tile "dim_pre" (- 1 (atoi (get_tile "obj_dim"))))
  (mode_tile "dim_suf" (- 1 (atoi (get_tile "obj_dim"))))
  (mode_tile "dim_ovr" (- 1 (atoi (get_tile "obj_dim"))))
)

(defun TNT:STT-GetDimText (obj)
  (cond
    ((= TNT-STT-DIM-PRE "1") (vla-get-TextPrefix obj))
    ((= TNT-STT-DIM-SUF "1") (vla-get-TextSuffix obj))
    (t (vla-get-TextOverride obj))
  )
)

(defun TNT:STT-PutDimText (obj value)
  (cond
    ((= TNT-STT-DIM-PRE "1") (vla-put-TextPrefix obj value))
    ((= TNT-STT-DIM-SUF "1") (vla-put-TextSuffix obj value))
    (t (vla-put-TextOverride obj value))
  )
)

(defun C:STT
  (/ *error* acadDoc dch dcl entities filter firstOrder flag fuzz index
     itemData mode obj order prefix selection sorted startString suffix
     tags type value width secondOrder)

  (vl-load-com)
  (setq acadDoc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (defun *error* (message)
    (if (and dch (> dch 0)) (unload_dialog dch))
    (if (and dcl (findfile dcl)) (vl-file-delete dcl))
    (if acadDoc (vla-EndUndoMark acadDoc))
    (if (and message
             (not (wcmatch (strcase message) "*CANCEL*,*QUIT*,*BREAK*")))
      (princ (strcat "\nLoi STT: " message))
    )
    (princ)
  )

  (vla-StartUndoMark acadDoc)
  (setq dcl (vl-filename-mktemp "TNT_STT_" nil ".dcl"))
  (TNT:STT-WriteDcl dcl)

  (if (and (> (setq dch (load_dialog dcl)) 0)
           (new_dialog "TNT_STT" dch))
    (progn
      (foreach pair
        '(
          (TNT-STT-OBJ-BLK . "1") (TNT-STT-OBJ-TXT . "1")
          (TNT-STT-OBJ-MTX . "1") (TNT-STT-OBJ-DIM . "1")
          (TNT-STT-DIM-PRE . "1") (TNT-STT-DIM-SUF . "0")
          (TNT-STT-DIM-OVR . "0") (TNT-STT-MODE-OVR . "1")
          (TNT-STT-MODE-LEFT . "0") (TNT-STT-MODE-RIGHT . "0")
          (TNT-STT-PREFIX . "") (TNT-STT-SUFFIX . "") (TNT-STT-START . "1")
        )
        (if (null (eval (car pair))) (set (car pair) (cdr pair)))
      )
      (foreach pair
        '(
          ("obj_blk" TNT-STT-OBJ-BLK) ("obj_txt" TNT-STT-OBJ-TXT)
          ("obj_mtx" TNT-STT-OBJ-MTX) ("obj_dim" TNT-STT-OBJ-DIM)
          ("dim_pre" TNT-STT-DIM-PRE) ("dim_suf" TNT-STT-DIM-SUF)
          ("dim_ovr" TNT-STT-DIM-OVR) ("mode_ovr" TNT-STT-MODE-OVR)
          ("mode_left" TNT-STT-MODE-LEFT) ("mode_right" TNT-STT-MODE-RIGHT)
          ("prefix" TNT-STT-PREFIX) ("suffix" TNT-STT-SUFFIX)
          ("start" TNT-STT-START)
        )
        (set_tile (car pair) (eval (cadr pair)))
      )
      (TNT:STT-DimMode)
      (action_tile "obj_dim" "(TNT:STT-DimMode)")
      (action_tile "accept"
        "(progn
           (setq TNT-STT-OBJ-BLK (get_tile \"obj_blk\")
                 TNT-STT-OBJ-TXT (get_tile \"obj_txt\")
                 TNT-STT-OBJ-MTX (get_tile \"obj_mtx\")
                 TNT-STT-OBJ-DIM (get_tile \"obj_dim\")
                 TNT-STT-DIM-PRE (get_tile \"dim_pre\")
                 TNT-STT-DIM-SUF (get_tile \"dim_suf\")
                 TNT-STT-DIM-OVR (get_tile \"dim_ovr\")
                 TNT-STT-MODE-OVR (get_tile \"mode_ovr\")
                 TNT-STT-MODE-LEFT (get_tile \"mode_left\")
                 TNT-STT-MODE-RIGHT (get_tile \"mode_right\")
                 TNT-STT-PREFIX (get_tile \"prefix\")
                 TNT-STT-SUFFIX (get_tile \"suffix\")
                 TNT-STT-START (get_tile \"start\"))
           (done_dialog 1))"
      )
      (action_tile "cancel" "(done_dialog 0)")
      (setq flag (start_dialog))
    )
  )
  (if (and dch (> dch 0)) (unload_dialog dch))
  (setq dch nil)
  (if (findfile dcl) (vl-file-delete dcl))
  (setq dcl nil)

  (if (= flag 1)
    (progn
      (setq filter
        (strcat
          (if (= TNT-STT-OBJ-BLK "1") "INSERT," "")
          (if (= TNT-STT-OBJ-TXT "1") "TEXT," "")
          (if (= TNT-STT-OBJ-MTX "1") "MTEXT," "")
          (if (= TNT-STT-OBJ-DIM "1") "*DIMENSION," "")
        )
      )
      (if (> (strlen filter) 0)
        (setq selection (ssget (list (cons 0 filter))))
      )
      (if selection
        (progn
          (setq entities
            (vl-remove-if
              'listp
              (mapcar 'cadr (ssnamex selection))
            )
          )
          (setq entities
            (vl-remove-if
              '(lambda (ent)
                 (and (= "INSERT" (cdr (assoc 0 (entget ent))))
                      (null (TNT:STT-AttGet ent))))
              entities
            )
          )
          (setq tags
            (if entities
              (TNT:STT-Unique
                (apply 'append
                  (mapcar
                    '(lambda (ent)
                       (if (= "INSERT" (cdr (assoc 0 (entget ent))))
                         (mapcar 'car (TNT:STT-AttGet ent))
                       )
                     )
                    entities
                  )
                )
              )
            )
          )
          (if tags
            (setq tags
              (TNT:STT-ListBox
                (vl-sort tags '<)
                "Chon Tag"
                20
                16
                T
              )
            )
          )

          (setq order
            (TNT:STT-GetKey
              '("U:tren->duoi" "D:duoi->tren" "L:trai->phai"
                "R:phai->trai" "X:theo-hai-chieu-XY"
                "P:theo-huong-pline" "C:theo-thu-tu-chon")
              TNT-STT-ORDER
              "Thu tu sap xep"
            )
          )
          (setq TNT-STT-ORDER order
                firstOrder (substr order 1 1)
                secondOrder nil
                fuzz nil)
          (if (= firstOrder "X")
            (progn
              (setq TNT-STT-ORDER1
                (TNT:STT-GetKey
                  '("L:trai->phai" "R:phai->trai"
                    "U:tren->duoi" "D:duoi->tren")
                  TNT-STT-ORDER1
                  "Thu tu trong mot nhom"
                )
              )
              (setq firstOrder (substr TNT-STT-ORDER1 1 1))
              (setq TNT-STT-ORDER2
                (TNT:STT-GetKey
                  (if (wcmatch firstOrder "L,R")
                    '("U:tren->duoi" "D:duoi->tren")
                    '("L:trai->phai" "R:phai->trai")
                  )
                  TNT-STT-ORDER2
                  "Thu tu giua cac nhom"
                )
              )
              (setq secondOrder (substr TNT-STT-ORDER2 1 1)
                    TNT-STT-FUZZ
                      (TNT:STT-GetReal
                        (if TNT-STT-FUZZ TNT-STT-FUZZ 0.5)
                        "Sai so khoang cach")
                    fuzz TNT-STT-FUZZ)
            )
          )
          (setq sorted
            (cond
              ((wcmatch (substr order 1 1) "U,D,L,R,X")
               (TNT:STT-SortXY entities firstOrder secondOrder fuzz))
              ((= (substr order 1 1) "P")
               (TNT:STT-SortPline entities))
              (t entities)
            )
          )

          (setq startString TNT-STT-START
                prefix TNT-STT-PREFIX
                suffix TNT-STT-SUFFIX)
          (if (= startString "") (setq startString "1"))
          (if (and (> (strlen startString) 0)
                   (>= (ascii startString) 48)
                   (<= (ascii startString) 57))
            (setq index (atoi startString)
                  width (strlen startString))
            (setq index (substr startString 1 1)
                  width nil)
          )

          (foreach ent sorted
            (if (numberp index)
              (progn
                (setq value (itoa index))
                (repeat (- width (strlen value))
                  (setq value (strcat "0" value))
                )
              )
              (setq value index)
            )
            (setq value (strcat prefix value suffix)
                  itemData (entget ent)
                  type (cdr (assoc 0 itemData))
                  mode nil)
            (cond
              ((and (= type "INSERT") (TNT:STT-AttGet ent))
               (foreach tag tags
                 (if (assoc tag (TNT:STT-AttGet ent))
                   (progn
                     (setq mode T)
                     (cond
                       ((= TNT-STT-MODE-OVR "1")
                        (TNT:STT-AttSet ent tag value))
                       ((= TNT-STT-MODE-LEFT "1")
                        (TNT:STT-AttSet ent tag
                          (strcat value (cdr (assoc tag (TNT:STT-AttGet ent))))))
                       (t
                        (TNT:STT-AttSet ent tag
                          (strcat (cdr (assoc tag (TNT:STT-AttGet ent))) value)))
                     )
                   )
                 )
               )
              )
              ((wcmatch type "*TEXT")
               (setq mode T)
               (setq value
                 (cond
                   ((= TNT-STT-MODE-OVR "1") value)
                   ((= TNT-STT-MODE-LEFT "1")
                    (strcat value (TNT:STT-Unformat (cdr (assoc 1 itemData)))))
                   (t
                    (strcat (TNT:STT-Unformat (cdr (assoc 1 itemData))) value))
                 )
               )
               (entmod (subst (cons 1 value) (assoc 1 itemData) itemData))
              )
              ((wcmatch type "*DIMENSION")
               (setq mode T
                     obj (vlax-ename->vla-object ent))
               (setq value
                 (cond
                   ((= TNT-STT-MODE-OVR "1") value)
                   ((= TNT-STT-MODE-LEFT "1")
                    (strcat value (TNT:STT-Unformat (TNT:STT-GetDimText obj))))
                   (t
                    (strcat (TNT:STT-Unformat (TNT:STT-GetDimText obj)) value))
                 )
               )
               (TNT:STT-PutDimText obj value)
              )
            )
            (if mode
              (if (numberp index)
                (setq index (1+ index))
                (progn
                  (setq index (1+ (ascii index)))
                  (if (not (or (<= 65 index 90) (<= 97 index 122)))
                    (setq index (if (> index 97) 97 65))
                  )
                  (setq index (chr index))
                )
              )
            )
          )
        )
        (princ "\nKhong co doi tuong nao duoc chon.")
      )
    )
  )

  (vla-EndUndoMark acadDoc)
  (princ "\n[TNT] Loaded/ran STT standalone.")
  (princ)
)

(princ "\n[TNT] Loaded TNT_STT.lsp. Lenh: STT")
(princ)
