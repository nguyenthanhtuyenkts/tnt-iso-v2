;TAO DIM
  (defun c:TNT_DIM ()  
  (command "-style" "TNT_DIM1" "romans.shx" "" "0.8" "" "" "" "")
  (command 
    "DIMALT" "Off" "DIMALTD" "2" "DIMALTF" "25.4"
    "DIMALTTD" "2" "DIMALTTZ" "0" "DIMALTU" "2" "DIMALTZ" "0" "DIMASO" "On"
    "DIMAUNIT" "0" "DIMBLK1" "_ARCHTICK" "DIMBLK2" "_ARCHTICK"
    "DIMCEN" "0.09" "DIMCLRD" "256" "DIMCLRE" "256" "DIMCLRT" "14" "DIMDEC" "0"
    "DIMASZ" "1.1" "DIMDLE" "1.1" "DIMDLI" "1.1" "DIMEXE" "1.1" "DIMGAP" "7"
    "DIMEXO" "0" "DIMFIT" "5" "DIMJUST" "0" "DIMLFAC" "1" "DIMLIM" "Off"
    "DIMRND" "0" "DIMSAH" "On" "DIMSCALE" "0" "DIMSD1" "Off" "DIMSD2" "Off" "DIMSE1" "Off" "DIMSE2" "Off"
    "DIMSHO" "On" "DIMSOXD" "Off" "DIMTAD" "1" "DIMTDEC" "0"
    "DIMTFAC" "1" "DIMTIH" "Off" "DIMTIX" "Off" "DIMTM" "0"
    "DIMTOFL" "on" "DIMTOH" "Off" "DIMTOL" "Off" "DIMTOLJ" "1" "DIMTP" "0"
    "DIMTSZ" "0" "DIMTVP" "0" "DIMTXSTY" "RomanS" "DIMTXT" "2"
    "DIMTZIN" "8" "DIMUNIT" "2" "DIMUPT" "Off" "DIMZIN" "8" "FILLETRAD" "0"
  )
  (command "_dimstyle" "save" "TNT_DIM1" "y")
  (princ)
  )
;CAT DIM
  (defun myerror (s)                    ; If an error (such as CTRL-C) occurs
                                        ; while this command is active...
    (cond
      ((= s "quit / exit abort") (princ))
      ((/= s "Function cancelled") (princ (strcat "\nError: " s)))
    )
    (setvar "cmdecho" CMD)             ; Restore saved modes
    (setvar "osmode" OSM)
    (setq *error* OLDERR)               ; Restore old *error* handler
    (princ)
  )
  ;*******************************************************************************
  (DEFUN C:CD (/ CMD SS LTH DEM PT DS KDL N70 GOCX GOCY PT13 PT14 PTI PT13I PT14I
                  PT13N PT14N O13 O14 N13 N14 OSM OLDERR PT10 PT11)
  (SETQ CMD (GETVAR "CMDECHO"))
  (SETQ OSM (GETVAR "OSMODE"))
  (SETQ OLDERR *error*
        *error* myerror)
  (PRINC "Please select dimension object!")
  (SETQ SS (SSGET))
  (SETVAR "CMDECHO" 0)
  (SETQ PT (GETPOINT "Point to trim or extend:"))
  (SETQ PT (TRANS PT 1 0))
  (COMMAND "UCS" "W")
  (SETQ LTH (SSLENGTH SS))
  (SETQ DEM 0)
  (WHILE (< DEM LTH)
      (PROGN
    (SETQ DS (ENTGET (SSNAME SS DEM)))
    (SETQ KDL (CDR (ASSOC 0 DS)))
    (IF (= "DIMENSION" KDL)
      (PROGN
      (SETQ PT10 (CDR (ASSOC 10 DS)))
      (SETQ PT11 (CDR (ASSOC 11 DS)))
      (SETQ PT13 (CDR (ASSOC 13 DS)))
      (SETQ PT14 (CDR (ASSOC 14 DS)))
      (SETQ N70 (CDR (ASSOC 70 DS)))
      (IF (OR (= N70 0) (= N70 32) (= N70 33) (= N70 160) (= N70 161))
        (PROGN
        (SETQ GOCY (ANGLE PT10 PT14))
        (SETQ GOCX (+ GOCY (/ PI 2)))
        )
      )
      (SETVAR "OSMODE" 0)
      (SETQ PTI (POLAR PT GOCX 2))
      (SETQ PT13I (POLAR PT13 GOCY 2))
      (SETQ PT14I (POLAR PT14 GOCY 2))
      (SETQ PT13N (INTERS PT PTI PT13 PT13I NIL))
      (SETQ PT14N (INTERS PT PTI PT14 PT14I NIL))
      (SETQ O13 (ASSOC 13 DS))
      (SETQ O14 (ASSOC 14 DS))
      (SETQ N13 (CONS 13 PT13N))
      (SETQ N14 (CONS 14 PT14N))
      (SETQ DS (SUBST N13 O13 DS))
      (SETQ DS (SUBST N14 O14 DS))
      (ENTMOD DS)
      )
    )
    (SETQ DEM (+ DEM 1))
      )
  )
  (COMMAND "UCS" "P")
  (SETVAR "CMDECHO" CMD)
  (SETVAR "OSMODE" OSM)
  (setq *error* OLDERR)               ; Restore old *error* handler
  (PRINC)
  )
  ;******************************************************************************
;DONG DIM
  (DEFUN C:BD (/ CMD SS LTH DEM PT DS KDL N70 GOCX GOCY PT13 PT14 PTI
                  PT10 PT10I PT10N O10 N10 PT11 PT11N O11 N11 KC OSM OLDERR)
  (SETQ CMD (GETVAR "CMDECHO"))
  (SETQ OSM (GETVAR "OSMODE"))
  (SETQ OLDERR *error*
        *error* myerror)
  (PRINC "Please select dimension object!")
  (SETQ SS (SSGET))
  (SETVAR "CMDECHO" 0)
  (SETQ PT (GETPOINT "Point to trim or extend:"))
  (SETQ PT (TRANS PT 1 0))
  (COMMAND "UCS" "W")
  (SETQ LTH (SSLENGTH SS))
  (SETQ DEM 0)
  (WHILE (< DEM LTH)
      (PROGN
    (SETQ DS (ENTGET (SSNAME SS DEM)))
    (SETQ KDL (CDR (ASSOC 0 DS)))
    (IF (= "DIMENSION" KDL)
      (PROGN
      (SETQ PT13 (CDR (ASSOC 13 DS)))
      (SETQ PT14 (CDR (ASSOC 14 DS)))
      (SETQ PT10 (CDR (ASSOC 10 DS)))
      (SETQ PT11 (CDR (ASSOC 11 DS)))
      (SETQ N70 (CDR (ASSOC 70 DS)))
      (IF (OR (= N70 0) (= N70 32) (= N70 33) (= N70 160) (= N70 161))
        (PROGN
        (SETQ GOCY (ANGLE PT10 PT14))
        (SETQ GOCX (+ GOCY (/ PI 2)))
        )
      )
      (SETVAR "OSMODE" 0)
      (SETQ PTI (POLAR PT GOCX 2))
      (SETQ PT10I (POLAR PT10 GOCY 2))
      (SETQ PT10N (INTERS PT PTI PT10 PT10I NIL))
      (SETQ KC (DISTANCE PT10 PT10N))
      (SETQ O10 (ASSOC 10 DS))
      (SETQ N10 (CONS 10 PT10N))
      (SETQ DS (SUBST N10 O10 DS))
      (SETQ PT11N (POLAR PT11 (ANGLE PT10 PT10N) KC))
      (SETQ O11 (ASSOC 11 DS))
      (SETQ N11 (CONS 11 PT11N))
      (SETQ DS (SUBST N11 O11 DS))
      (ENTMOD DS)
      )
    )
    (SETQ DEM (+ DEM 1))
      )
  )
  (COMMAND "UCS" "P")
  (SETVAR "CMDECHO" CMD)
  (SETVAR "OSMODE" OSM)
  (setq *error* OLDERR)
  (PRINC)
  )
;KHOANG CACH DIM
  (defun c:D4 ()
      (defun ss2ent (ss / sodt index lstent)
      (setq sodt 
        (cond
        (ss (sslength ss))
        (t 0)
        )
        index 0
      )
      (repeat sodt
        (setq ent (ssname ss index)
        index (1+ index)
        lstent (cons ent lstent)
        )
      )
      (reverse lstent)
      )
      (defun hoanh_newerror (msg)
      (if (and (/= msg "Function cancelled")
      (/= msg "quit / exit abort")
      )
      (princ (strcat "\n" msg))
      )
      (done)
      )
    ;;----------
    (defun init ()
      (setq
      HOANH_CMD (getvar "CMDECHO")
      HOANH_OLDERROR *error*
      *error* hoanh_newerror
      )
      (setvar "CMDECHO" 0)
      (command ".undo" "BE")
      )
      ;;----------
    (defun done ()
      (command ".redraw")
      (command ".undo" "E")
      (if HOANH_CMD
      (setvar "CMDECHO" HOANH_CMD)
      )
      (if HOANH_OLDERROR
      (setq *error* HOANH_OLDERROR)
      )
      (princ)
      )
    ;;----------
    (defun cdim (entdt pchan pduong / tt old10
                old13 old14 new10 new13 new14 p10n
                p13n p14n p10o p13o p14o gocduong
                gocchan pchanb pduongb loaidim
                )
      (defun chanvuonggoc (ph p1 p2 / ptemp pkq goc)
        (setq
        goc (+ (angle p1 p2) (/ pi 2.0))
        ptemp (polar ph goc 1000.0)
        pkq (inters ph ptemp p1 p2 nil)
        )
        pkq
      )
      (setq
        tt    (entget entdt)
        old10 (assoc '10 tt)
        old13 (assoc '13 tt)
        old14 (assoc '14 tt)
        p10o  (cdr old10)
        p13o  (cdr old13)
        p14o  (cdr old14)
        loaidim (logand (cdr (assoc '70 tt)) 7)
        gocduong (cond
                  ((= loaidim 1) (angle p13o p14o))
                  ((= loaidim 0) (cdr (assoc '50 tt)))
                  (t nil)
                )
        pchan (cond
                (pchan (list (car pchan) (cadr pchan) 0.0))
                (t pchan)
              )
        pduong (cond
                (pduong (list (car pduong) (cadr pduong) 0.0))
                (t pduong)
              )
      )
      (if gocduong
        (progn
          (if pchan
            (setq
              pchanb (polar pchan gocduong 1000.0)
              p13n (chanvuonggoc
                    (list (car p13o) (cadr p13o) 0.0)
                    pchan
                    pchanb
                  )
              p14n (chanvuonggoc
                    (list (car p14o) (cadr p14o) 0.0)
                    pchan
                    pchanb
                  )
              new13 (cons 13 p13n)
              new14 (cons 14 p14n)
              tt (subst new13 old13 tt)
              tt (subst new14 old14 tt)
            )
          )
          (if pduong
            (setq
            pduongb (polar pduong gocduong 1000.0)
            p10n (chanvuonggoc
                  (list (car p10o) (cadr p10o) 0.0)
                  pduong
                  pduongb
                )
            new10 (cons 10 p10n)
            tt (subst new10 old10 tt)
            )
          )
          (entmod tt)
        )
      )
      gocduong
    )
    (defun textdimheight (ent / tmp)
      (command ".copy" ent "" (list 0.0 0.0 0.0) "@")
      (command ".explode" (entlast) "")
      (setq tmp (cdr (assoc 40 (entget (entlast)))))
      (command ".erase" "p" "")
      tmp
      )
    (defun phia (p1 p2 p3 / x1 y1 z1 x2 y2 z2 x3 y3 z3)
      (setq
        x1 (car p1)
        y1 (cadr p1)
        z1 (caddr p1)
        x2 (car p2)
        y2 (cadr p2)
        z2 (caddr p2)
        x3 (car p3)
        y3 (cadr p3)
        z3 (caddr p3)
        tmp (+ (* (- x1 x2) x3)
              (* (- y1 y2) y3)
              (* (- z1 z2) z3)
            )
      )
      (cond
        ((= tmp 0.0) 0.0)
        (t (/ tmp (abs tmp)))
      )
    )
    (defun khoangcachdim (p1 ent goc / tt p2 A B D)
      (setq tt (entget ent)
            p2 (cdr (assoc 10 tt))
            B (cdr (assoc 50 tt))
            A (angle p1 p2)
            D (distance p1 p2)
      )
      (* (* D (sin (- A B ))) (phia p1 (polar p1 goc 1.0) p2))
    )

    (defun phanloai (ent)
      (setq
      kc (khoangcachdim pgoc ent goc)
      loai (fix (/ kc heightdimgoc 0.93))
      )
      (cons loai ent)
    )

    (init)
    (princ "\nSap xep dim © CADViet.com")
    (while (not (setq entgoc (car (entsel "\n CHON DIM GOC: ")))))
    (setq
      ttgoc (entget entgoc)
      p13goc (cdr (assoc 13 ttgoc))
      pgoc (cdr (assoc 10 ttgoc))
      goc (cdr (assoc 50 ttgoc))
      heightdimgoc (textdimheight entgoc)
      ssd (ssget (list
      (cons 0 "DIMENSION")
      (cons -4 "<OR")
      (cons 70 32)
      (cons 70 64)
      (cons 70 96)
      (cons 70 128)
      (cons 70 160)
      (cons 70 196)
      (cons 70 224)
      (cons -4 "OR>")
      (cons -4 "<OR")
      (cons 50 goc)
      (cons 50 (+ goc pi))
      (cons 50 (- goc pi))
      (cons -4 "OR>")
      )
      )
      lstd (ss2ent ssd)
      lstd (mapcar 'phanloai lstd)
      lstlevel nil
    )
    (foreach pp lstd
      (if (not (member (car pp) lstlevel))
      (setq lstlevel (append lstlevel (list (car pp))))
      )
    )
    (setq lstlevel (vl-sort lstlevel '(lambda (x1 x2) (< x1 x2)))
      lstam nil
      lstduong nil
      lstamtmp nil
      lstduongtmp nil
    )
    (foreach pp lstlevel
      (if (< pp 0.0)
      (setq lstam (append lstam (list pp)))
      )
      (if (> pp 0.0)
      (setq lstduong (append lstduong (list pp)))
      )
    )
    (setq index 0)
    (foreach pp (reverse lstam)
      (setq
      index (1+ index)
      lstamtmp (append lstamtmp (list (cons pp index)))
      )
    )
    (setq
      lstam lstamtmp
      index 0
    )
    (foreach pp lstduong
      (setq
      index (1+ index)
      lstduongtmp (append lstduongtmp (list (cons pp index)))
      )
    )
    (setq lstduong lstduongtmp)
    (setq lstlevel (append lstduong lstam (list (cons 0.0 0))))
    (setq kcdimstandard (* 3.0 heightdimgoc)) ;KHOANG CACH DIM = X3 TEXT
    (foreach pp lstd
      (setq plht (car pp))
      (progn
      (setq
        kcdimht (khoangcachdim pgoc (cdr pp) goc)
        duongthu (cdr (assoc plht lstlevel))
        heso 
        (cond
        ((/= 0 kcdimht)
          (abs (* (/ kcdimstandard kcdimht) duongthu))
        )
        (t 0.0)
        )
        diemchenht (cdr (assoc 10 (entget (cdr pp))))
        pmoi 
        (polar pgoc
          (angle pgoc diemchenht)
          (* heso (distance pgoc diemchenht))
        )
      )
        (cdim (cdr pp) p13goc pmoi)
      )
    )
      (done)
      (princ)
  )