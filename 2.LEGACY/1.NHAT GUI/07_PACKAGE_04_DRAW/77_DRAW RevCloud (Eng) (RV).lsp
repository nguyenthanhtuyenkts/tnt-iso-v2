
(defun C:RV ( / cmd1 )
	(setq cmd1 (getvar 'cmdecho))
	(or savedglbwidth (setparameter))
	(or setmode (setq setmode "New"))
	(initget "New Select Change")
	(if (setq tmp (getkword (strcat "\nNew RevCloud or Select existing Polyline ? [New/Select/Change] <" setmode ">: "))) (setq setmode tmp))
	(cond
		((= setmode "New") (setvar "cmdecho" 0) (newrevcloud) (setvar "cmdecho" cmd1))
		((= setmode "Select") (setvar "cmdecho" 0) (selectpolyline) (setvar "cmdecho" cmd1))
		((= setmode "Change") (setparameter) (c:RV))
	)
	(princ)
)
;;Setting parameter
(defun setparameter ( / )
	(setq 
		savedRadius (cond ((getdist (strcat "\nEnter Arc Radius: <" (rtos (setq savedRadius (cond (savedRadius) (300)))) ">: "))) (savedRadius))
		savedglbwidth (cond ((getdist (strcat "\nEnter Global Width: <" (rtos (setq savedglbwidth (cond (savedglbwidth) (30)))) ">: "))) (savedglbwidth))
	)
)
;;Draw New RevCloud case
(defun newrevcloud (/ p1 p2)
	(setq p1 (getpoint "\nPick first point of Rectangle :")
		p2 (getcorner p1 "\nPick second point of Rectangle :")
	)
	(if (and p1 p2 savedRadius savedglbwidth)
		(progn
			(command "_.rectangle" p1 p2)
			(command "_.revcloud" "_A" savedRadius "" "_O" (entlast) "")
			(command "_.pedit" (entlast) "_W" savedglbwidth "")
		)
		(princ "\n:  Command failed, try again \n")
	)
)
;;Select Polyline case
(defun selectpolyline (/ ss)
	(setq ss (ssget "_:L+.:E:S" '((0 . "*POLYLINE"))))
	(if (and ss savedRadius savedglbwidth)
		(progn
			(command "_.revcloud" "_A" savedRadius "" "_O" ss "")
			(command "_.pedit" "_last" "W" savedglbwidth "")
		)
		(princ "\n:  No Polyline Selected, try again \n")
	)
)

(princ  "\n:  Command \"RV\" - Draw RevCloud" )
(princ)

;; Calligraphy Style
(defun c:zz (/)
	(setq p1 (getpoint "\nPick first point of Rectangle :")
		p2 (getcorner p1 "\nPick second point of Rectangle :")
	)
	(if (and p1 p2)
		(progn
			(command "_.rectangle" p1 p2)
			(command "_.revcloud" "_Style" "_Calligraphy" "_A" 500 "" "_O" (entlast) "")
		)
	)
(princ)
)