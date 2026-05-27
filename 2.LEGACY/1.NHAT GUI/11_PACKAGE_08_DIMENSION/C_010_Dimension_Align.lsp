(defun C:AD ( / )
  (setvar "MODEMACRO" "010.α")
  (setq OldDIMSCALE (getvar "DIMSCALE"))
  (defun *error* (msg)
    (setvar "DIMSCALE" OldDIMSCALE)
    (princ (strcat "\nLỗi: " msg))
    (princ)
  )
  (C:ADIM)
  (setvar "DIMSCALE" OldDIMSCALE)
  (princ (strcat "\nDIMSCALE: "(rtos (getvar "DIMSCALE"))))
  (princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun C:ADIM ( /
	AngleDimPer
	AnntativeScaleCurrent
	CheckModelSpace
	DistanceBaseGlobal
	DistanceBaseGlobalMax
	DistanceBaseGlobalMin
	ListClassificationLevel
	ListDataDimTotal
	ListEnameObjectDim
	ListVarSystem
	ListVlaLayerLock
	ListTemp
	NumRoundAngle
	NumRoundDistance
	NumRoundScale
	PointBaseGlobal
	ToleranceSelection
	VlaDrawingCurrent)

	-------------------------------------------------------------------------------------------------------------------
	(defun LIC_REQUESTCODE ( / 
		CheckLicense
		CodeSoftware
		DateCurrent
		DateUsed
		ListDataUser
		ListCharTotal
		ListNumHash
		ListSerialNumTotal
		ListSerialString
		ListStringQuery
		NameSoftware
		NumCharTotal
		NumCodeSoftware
		NumRequestCode
		NumHash
		NumSeedMax
		NumSeed
		NumUsed
		Pos
		LicenseKey
		LicenseKeyExact
		RequestCode
		UserName)

		(setq NameSoftware "Dimension Utility")

  ;; ======= TẠO HỘP THOẠI ABOUT =========
  (defun CREATE-ABOUT-DIALOG ( / NameSoftware Version )
    (setq NameSoftware "Dimension Utility"
          Version "1.00"
    )
    (list
      " ABOUT: dialog{"
      (strcat " label = \"About - " NameSoftware " " Version "\";")
      " :boxed_column {"
      (strcat "   :text { label = \" " NameSoftware " v" Version "\"; }")
      "   :text { label = \"Copyright © TNT\"; }"
      "   :text { label = \"Author: Tam Pham Nhu\"; }"
      "   :text { label = \"Email: Nhutam104@gmail.com\"; }"
      "   :text { label = \"Phone: +84 983 890 491\"; }"
      "   :paragraph{ width = 70;"
      "     :text_part{ value = \"Mọi ý kiến phản hồi vui lòng gửi về email trên.\"; }"
      "     :text_part{ value = \"Thank you for using and supporting.\"; }"
      "   }"
      " }"
      "   :button{ label = \"OK\"; key = \"OkAbout\"; is_default = true; is_cancel = true; width = 15; }"
      " }"
    )
  )

  ;; ======= HIỆN HỘP THOẠI ABOUT =========
  (defun SHOW-ABOUT-DIALOG ( / DCLABOUT ABOUT.DCL FILE_DCL DCL_ID_ABOUT )
    (setq DCLABOUT (CREATE-ABOUT-DIALOG))
    (setq ABOUT.DCL (vl-filename-mktemp "ABOUT.dcl"))
    (setq FILE_DCL (open ABOUT.DCL "w"))
    (foreach LL DCLABOUT (write-line LL FILE_DCL))
    (close FILE_DCL)
    (setq DCL_ID_ABOUT (load_dialog ABOUT.DCL))
    (if (< DCL_ID_ABOUT 1)
      (progn (alert "Not found ABOUT.dcl") (exit)))
    (if (not (new_dialog "ABOUT" DCL_ID_ABOUT))
      (progn (alert "Not found ABOUT dialog") (exit)))
    (start_dialog)
    (unload_dialog DCL_ID_ABOUT)
  )

  ;; ======= HÀM TẠO FILE DCL CHÍNH ========
  (defun LIC_MAKE_FILE_DCL ( NameSoftware /
    Num DclFile DirectoryDes)
    (setq DirectoryDes (strcat (getvar "roamablerootprefix") "Support"))
    (setq DclFile (open (strcat DirectoryDes "\\" NameSoftware " License.dcl") "w"))
    (write-line "///------------------------------------------------------------------------" DclFile)
    (write-line (strcat "///		 " NameSoftware " License.dcl") DclFile)
    (write-line (strcat (LIC_REMOVE_SPACE_OF_STRING NameSoftware) "License:dialog{") DclFile)
    (write-line (strcat "label = \"" NameSoftware " License\";") DclFile)
    (write-line "	:text{" DclFile)
    (write-line "	key = \"Tile_ActivateText\";" DclFile)
    (write-line "	alignment = centered;" DclFile)
    (write-line "	width = 60;" DclFile)
    (write-line "	}" DclFile)
    (write-line "	:text{" DclFile)
    (write-line "	key = \"sep0\";" DclFile)
    (write-line "	}" DclFile)
    (write-line "		:column{" DclFile)
    (write-line "		width = 60;" DclFile)
    (write-line "			:text{" DclFile)
    (write-line "				label = \"     You are using the trial version of this app.\";" DclFile)
    (write-line "			}" DclFile)
    (write-line "			:text{" DclFile)
    (write-line "				label = \"     If you find it useful, you can pay 5 USD per license.\";" DclFile)
    (write-line "			}" DclFile)
    (write-line "			:text{" DclFile)
    (write-line "				label = \"     Then you will not see this message board every time you use the application.\";" DclFile)
    (write-line "			}" DclFile)
    (write-line "			:text{" DclFile)
    (write-line "				label = \"     Please contact phamhoangnhat@gmail.com (+84 933 648 160) .\";" DclFile)
    (write-line "			}" DclFile)
    (write-line "			:text{" DclFile)
    (write-line "				label = \"     Thank you for using and supporting.\";" DclFile)
    (write-line "			}" DclFile)
    (write-line "		}" DclFile)
    (write-line "	:text{" DclFile)
    (write-line "	key = \"sep1\";" DclFile)
    (write-line "	}" DclFile)
    (write-line "	:row{" DclFile)
    (write-line "		:text{" DclFile)
    (write-line "		label = \"     Request code\";" DclFile)
    (write-line "		width = 15;" DclFile)
    (write-line "		}" DclFile)
    (write-line "		:text{" DclFile)
    (write-line "		key = \"Tile_RequestCode\";" DclFile)
    (write-line "		width = 45;" DclFile)
    (write-line "		}" DclFile)
    (write-line "	}" DclFile)
    (write-line "	:text{" DclFile)
    (write-line "	key = \"sep2\";" DclFile)
    (write-line "	}" DclFile)
    (write-line "	:row{" DclFile)
    (write-line "		:text{" DclFile)
    (write-line "		label = \"     Enter license\";" DclFile)
    (write-line "		width = 15;" DclFile)
    (write-line "		}" DclFile)
    (write-line "		:edit_box{" DclFile)
    (write-line "		key = \"Tile_LicenseNumber\";" DclFile)
    (write-line "		width = 45;" DclFile)
    (write-line "		}" DclFile)
    (write-line "	}" DclFile)
    (write-line "	:text{" DclFile)
    (write-line "	key = \"sep3\";" DclFile)
    (write-line "	}" DclFile)
    (write-line "	:row{" DclFile)
    (write-line "		:button{" DclFile)
    (write-line "		label = \"&Continue\";" DclFile)
    (write-line "		key = \"Ok\";" DclFile)
    (write-line "		is_default = true;" DclFile)
    (write-line "		is_cancel = true;" DclFile)
    (write-line "		width = 20;" DclFile)
    (write-line "		}" DclFile)
    (write-line "		:button{" DclFile)
    (write-line "		label = \"Copy &request code\";" DclFile)
    (write-line "		key = \"Tile_CopyRequestCode\";" DclFile)
    (write-line "		width = 20;" DclFile)
    (write-line "		}" DclFile)
    ;; ==== NÚT ABOUT ====
    (write-line "		:button{" DclFile)
    (write-line "		label = \"About...\";" DclFile)
    (write-line "		key = \"Tile_About\";" DclFile)
    (write-line "		width = 15;" DclFile)
    (write-line "		}" DclFile)
    (write-line "	}" DclFile)
    (write-line "}" DclFile)
    (close DclFile)
  )

  ;; ======= HÀM CHÍNH HIỆN DIALOG LICENSE =========
  (defun LIC_LOAD_DIALOG ( NameSoftware /
    End_Main_DCL Main_DCL LicenseKey )
    (defun LIC_GET_TILE_LICENSENUMBER ( / )
      (setq LicenseKey (vl-string-trim " " (get_tile "Tile_LicenseNumber")))
      (setq ListNumHash (vl-string->list RequestCode))
      (setq NumSeed (rem (apply '+ ListNumHash) NumSeedMax))
      (setq LicenseKeyExact "")
      (foreach NumHash ListNumHash
        (setq LicenseKeyExact (strcat LicenseKeyExact (nth (rem (setq NumSeed (rem (abs (fix (+ NumHash (* (sin NumSeed) NumSeedMax)))) NumSeedMax)) NumCharTotal) ListCharTotal)))
      )
      (if (= LicenseKeyExact LicenseKey)
        (progn
          (vl-registry-write (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "License Key" LicenseKey)
          (set_tile "Tile_ActivateText" "The official version has been activated!")
          (mode_tile "Tile_ActivateText" 1)
          (mode_tile "Tile_LicenseNumber" 1)
        )
        (progn
          (set_tile "Tile_ActivateText" "License number is incorrect!")
          (mode_tile "Tile_ActivateText" 1)
          (mode_tile "Tile_LicenseNumber" 0)
        )
      )
      (setq LicenseKeyExact Nil)
    )
    (LIC_MAKE_FILE_DCL NameSoftware)
    (setq Main_DCL (load_dialog (strcat NameSoftware " License.dcl")))
    (new_dialog (strcat (LIC_REMOVE_SPACE_OF_STRING NameSoftware) "License") Main_DCL)
    (setq LicenseKey "")
    (LIC_SET_TILE_DECORATION 4)
    (set_tile "Tile_RequestCode" RequestCode)
    (action_tile "Tile_LicenseNumber" "(LIC_GET_TILE_LICENSENUMBER)")
    (action_tile "Tile_CopyRequestCode" "(vlax-invoke (vlax-get (vlax-get (vlax-create-object \"HTMLFile\") 'ParentWindow) 'ClipBoardData) 'setData \"Text\" RequestCode)")
    (action_tile "Tile_About" "(SHOW-ABOUT-DIALOG)")
    (setq End_Main_DCL (start_dialog))
    (if (not CheckLicense)
      (princ (strcat "\nRequest Code: " RequestCode))
    )
    (cond
      (
        (or
          (= End_Main_DCL 0)
          (= End_Main_DCL 1)
        )
        (unload_dialog Main_DCL)
      )
    )
    (setq LIC_GET_TILE_LICENSENUMBER Nil)
    (princ)
  )
		-------------------------------------------------------------------------------------------------------------------
		(defun LIC_SET_TILE_DECORATION ( NumTotal / Num Tile)
			(setq Num 0)
			(repeat NumTotal
				(setq Tile (strcat "sep" (itoa Num)))
				(set_tile Tile "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
				(setq Num (+ Num 1))
			)
		)
		-------------------------------------------------------------------------------------------------------------------
		(defun LIC_REMOVE_SPACE_OF_STRING ( String / )
			(while (/= String (setq StringTemp (vl-string-subst "" " " String)))
				(setq String StringTemp)
			)
		)
		-------------------------------------------------------------------------------------------------------------------
		(defun LIC_GETSERIALNUMBER ( StringQuery StringNameSerial / 
			SerialNumber
			VlaObjectLocal
			VlaObjectServive
			VlaObjectSet)

			(setq VlaObjectLocal (vlax-create-object "WbemScripting.SWbemLocator"))
			(setq VlaObjectServive (vlax-invoke VlaObjectLocal 'ConnectServer nil nil nil nil nil nil nil nil))
			(setq Server (vlax-invoke VlaObjectLocal 'ConnectServer "." "root\\cimv2"))
			(setq VlaObjectSet
				(vlax-invoke 
					VlaObjectServive
					"ExecQuery"
					StringQuery
				)
			)
			(vlax-for VlaObject VlaObjectSet
				(setq SerialNumber (vlax-get VlaObject StringNameSerial))
			)
			SerialNumber
		)
		-------------------------------------------------------------------------------------------------------------------
		(defun LIC_SEND_REQUESTAPI ( StringUrl / 
			CodeStatus
			StringResponse
			VlaHttpRequest)

			(vl-catch-all-apply (function (lambda ( / )
				(setq VlaHttpRequest (vlax-invoke-method (vlax-get-acad-object) 'GetInterfaceObject "WinHttp.WinHttpRequest.5.1"))
				(vlax-invoke-method VlaHttpRequest 'Open "GET" StringUrl :vlax-false)
				(vlax-invoke-method VlaHttpRequest 'Send)
				(setq CodeStatus (vlax-get-property VlaHttpRequest 'Status))
				(if (= CodeStatus 200)
					(setq StringResponse (vlax-get-property VlaHttpRequest 'ResponseText))
				)
			)))
			StringResponse
		)
		-------------------------------------------------------------------------------------------------------------------
		(defun LIC_SEND_REQUESTAPI_SENDDATAUSER ( ListData / )
			""
    )
		-------------------------------------------------------------------------------------------------------------------
		(defun LIC_GET_CURRENT_DATE ( / )
			(setq StringTemp (rtos (getvar "CDATE") 2 6))
			(strcat (substr StringTemp 1 4) "-" (substr StringTemp 5 2) "-" (substr StringTemp 7 2))
		)
		-------------------------------------------------------------------------------------------------------------------
		(vl-load-com)
		(setq ListStringQuery
			(list
				(cons "Select * from Win32_BaseBoard" "SerialNumber")
				(cons "Select * from Win32_BIOS" "SerialNumber")
			)
		)
		(setq ListSerialString (cons NameSoftware (mapcar '(lambda (x) (LIC_GETSERIALNUMBER (car x) (cdr x))) ListStringQuery)))
		(setq ListSerialString (vl-remove Nil ListSerialString))
		(setq ListSerialNumTotal (mapcar 'vl-string->list ListSerialString))
		(setq LIC_GETSERIALNUMBER Nil)

		(setq ListCharTotal (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
		(setq NumCharTotal (length ListCharTotal))
		(setq NumSeedMax 100000000)

		(setq ListNumHash (vl-string->list NameSoftware))
		(setq NumSeed (rem (apply '+ ListNumHash) NumSeedMax))
		(setq CodeSoftware "")
		(setq NumCodeSoftware 6)
		(setq Pos 0)
		(while (< (strlen CodeSoftware) NumCodeSoftware)
			(setq NumHash (nth 0 ListNumHash))
			(if (not NumHash)
				(setq NumHash NumSeed)
			)
			(setq CodeSoftware (strcat CodeSoftware (nth (rem (setq NumSeed (rem (abs (fix (+ NumHash (* (sin NumSeed) NumSeedMax)))) NumSeedMax)) NumCharTotal) ListCharTotal)))
		)

		(setq RequestCode CodeSoftware)
		(setq Pos 0)
		(setq NumRequestCode 36)
		(while (< (strlen RequestCode) NumRequestCode)
			(foreach ListSerialNum ListSerialNumTotal
				(setq NumHash Nil)
				(vl-catch-all-apply (function (lambda ( / )
					(setq NumHash (nth Pos ListSerialNum))
				)))
				(if (not NumHash)
					(setq NumHash NumSeed)
				)
				(setq RequestCode (strcat RequestCode (nth (rem (setq NumSeed (rem (abs (fix (+ NumHash (* (sin NumSeed) NumSeedMax)))) NumSeedMax)) NumCharTotal) ListCharTotal)))
			)
			(setq Pos (+ Pos 1))
		)

		(setq LicenseKey (vl-registry-read (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "License Key"))
		(setq ListNumHash (vl-string->list RequestCode))
		(setq NumSeed (rem (apply '+ ListNumHash) NumSeedMax))
		(setq LicenseKeyExact "")
		(foreach NumHash ListNumHash
			(setq LicenseKeyExact (strcat LicenseKeyExact (nth (rem (setq NumSeed (rem (abs (fix (+ NumHash (* (sin NumSeed) NumSeedMax)))) NumSeedMax)) NumCharTotal) ListCharTotal)))
		)
		(if (= LicenseKeyExact LicenseKey)
			(setq CheckLicense T)
			(progn
				(setq CheckLicense Nil)
				(setq LicenseKey "")
			)
		)
		(setq LicenseKeyExact Nil)

		(if (not CheckLicense)
			(LIC_LOAD_DIALOG NameSoftware)
		)

		(setq UserName (getenv "ComputerName"))
		(setq DateUsed (vl-registry-read (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "DateUsed"))
		(setq NumUsed (vl-registry-read (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "NumUsed"))
		(setq DateCurrent (LIC_GET_CURRENT_DATE))
		(if (not NumUsed)
			(setq NumUsed "0")
		)
		(if (not DateUsed)
			(setq DateUsed DateCurrent)
		)
		(setq NumUsed (itoa (+ (atoi NumUsed) 1)))
		(if (/= DateUsed DateCurrent)
			(progn
				(setq ListDataUser
					(list
						(cons "NameSoftware" NameSoftware)
						(cons "UserName" UserName)
						(cons "RequestCode" RequestCode)
						(cons "LicenseKey" LicenseKey)
						(cons "DateUsed" DateUsed)
						(cons "NumUsed" NumUsed)
					)
				)
        ;; ==== ĐÃ BỎ GỬI DỮ LIỆU RA NGOÀI ====
				;(if (LIC_SEND_REQUESTAPI_SENDDATAUSER ListDataUser)
				;	(progn
				;		(setq NumUsed "1")
				;		(setq DateUsed DateCurrent)
				;	)
				;)
        (setq NumUsed "1")
				(setq DateUsed DateCurrent)
			)
		)
		(vl-registry-write (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "DateUsed" DateUsed)
		(vl-registry-write (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "NumUsed" NumUsed)
	)
	-------------------------------------------------------------------------------------------------------------------
	;(LIC_REQUESTCODE)
	(setq LIC_REQUESTCODE nil)

	(setq VlaDrawingCurrent (vla-get-activedocument (vlax-get-acad-object)))
	(DIMUL_CREATE_LISTVLALAYERLOCK)
	(vla-startundomark VlaDrawingCurrent)

	(setq NumRoundAngle 0.01)
	(setq NumRoundDistance 0.01)
	(setq NumRoundScale 0.01)
	(setq ToleranceSelection 0.01)
	(setq AnntativeScaleCurrent (getvar "CANNOSCALE"))
	(setq CheckModelSpace (= (getvar "TILEMODE") 1))
	(setq ListVarSystem (list (list "CMDECHO" 0) (list "SELECTIONCYCLING" 0) (list "MODEMACRO" "Arange dimensions...")))
	(DIMUL_SET_VARSYSTEM)

	(vl-catch-all-apply (function (lambda ( / )
		(setq ListDataDimTotal (DIMUL_SELECT_DIMENSION))
		(setq ListEnameObjectDim (mapcar 'car ListDataDimTotal))
		(foreach EnameObjectDim ListEnameObjectDim
			(vla-Highlight (vlax-ename->vla-object EnameObjectDim) 1)
		)

		(setq ListTemp (DIMUL_INITIAL_DISTANCEBASEGLOBAL))
		(setq DistanceBaseGlobal (nth 0 ListTemp))
		(setq DistanceBaseGlobalMax (nth 1 ListTemp))
		(setq DistanceBaseGlobalMin (nth 2 ListTemp))
		(setq ListTemp (DIMUL_GET_BASEPOINTGLOBAL_DISTANCEBASEGLOBAL))
		(setq PointBaseGlobal (nth 0 ListTemp))
		(setq DistanceBaseGlobal (nth 1 ListTemp))

		(setq AngleDimPer (DIMUL_GET_ANGLEDIMPERMAIN))
		(setq ListClassificationLevel (DIMUL_CLASSIFICATION_LEVEL))
		(DIMUL_ARANGEDIM)
	)))

	(foreach EnameObjectDim ListEnameObjectDim
		(vla-Highlight (vlax-ename->vla-object EnameObjectDim) 0)
	)

	(DIMUL_RESET_VARSYSTEM)
	(setvar "CANNOSCALE" AnntativeScaleCurrent)
	(DIMUL_RESTORE_LOCK_LAYER)
	(vla-endundomark VlaDrawingCurrent)
	(princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_INITIAL_DISTANCEBASEGLOBAL ( / 
	DistanceBaseGlobal
	DistanceBaseGlobalMax
	DistanceBaseGlobalMin
	DistanceBaseGlobalTemp
	ListTextHeight
	NameDimstyle
	TextHeight)

	(setq DistanceBaseGlobalTemp (vl-registry-read "HKEY_CURRENT_USER\\Software\\Dimension Utility" "DistanceBaseGlobal"))
	(if
		(and
			DistanceBaseGlobalTemp
			(setq DistanceBaseGlobalTemp (atof DistanceBaseGlobalTemp))
		)
		(setq DistanceBaseGlobal DistanceBaseGlobalTemp)
		(progn
			(setq NameDimstyle (nth 8 (car ListDataDimTotal)))
			(setq DistanceBaseGlobal (DIMUL_GET_DISTANCEBASE NameDimstyle))
		)
	)

	(setq ListTextHeight (mapcar '(lambda (x) (nth 10 x)) ListDataDimTotal))
	(setq TextHeight (/ (apply '+ ListTextHeight) (length ListTextHeight)))
	(setq DistanceBaseGlobalMax (* TextHeight 4.0))
	(setq DistanceBaseGlobalMin (* TextHeight 0.2))
	(if
		(or
			(> DistanceBaseGlobal DistanceBaseGlobalMax)
			(< DistanceBaseGlobal DistanceBaseGlobalMin)
		)
		(setq DistanceBaseGlobal (* TextHeight 3.0))
	)
	(list DistanceBaseGlobal DistanceBaseGlobalMax DistanceBaseGlobalMin)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_DISTANCEBASE ( NameDimstyle /
	DataEnameDimstyle
	DistanceBase
	DistanceBaseMax
	DistanceBaseMin
	TextHeight
	VlaDimstyle
	VlaDimstylesGroup)

	(setq VlaDimstylesGroup (vla-get-dimstyles VlaDrawingCurrent))
	(setq VlaDimstyle (vla-item VlaDimstylesGroup NameDimstyle))
	(setq DataEnameDimstyle (entget (vlax-vla-object->ename VlaDimstyle)))
	(setq DistanceBase (cdr (assoc 43 DataEnameDimstyle)))
	(if (not DistanceBase) (setq DistanceBase (getvar "DIMDLI")))
	(setq TextHeight (cdr (assoc 140 DataEnameDimstyle)))
	(setq DistanceBaseMax (* TextHeight 4.0))
	(setq DistanceBaseMin (* TextHeight 2.0))
	(if
		(not
			(and
				(<= DistanceBase DistanceBaseMax)
				(>= DistanceBase DistanceBaseMin)
			)
		)
		(setq DistanceBase (* TextHeight 3.0))
	)
	DistanceBase
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_DISTANCETEXT ( NameDimstyle /
	DataEnameDimstyle
	DistanceText
	TextGap
	TextHeight
	VlaDimstyle
	VlaDimstylesGroup)

	(setq VlaDimstylesGroup (vla-get-dimstyles VlaDrawingCurrent))
	(setq VlaDimstyle (vla-item VlaDimstylesGroup NameDimstyle))
	(setq DataEnameDimstyle (entget (vlax-vla-object->ename VlaDimstyle)))
	(setq TextGap (cdr (assoc 147 DataEnameDimstyle)))
	(if (not TextGap) (setq TextGap (getvar "DIMGAP")))
	(setq TextHeight (cdr (assoc 140 DataEnameDimstyle)))
	(if (not TextHeight) (setq TextHeight (getvar "DIMTXT")))
	(setq DistanceText (+ TextGap (/ TextHeight 2)))
	DistanceText
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_BASEPOINTGLOBAL_DISTANCEBASEGLOBAL ( / 
	ListTemp
	Temp)

	(initget 31 "Spacing")
	(setq Temp (getpoint (strcat "\nSpecify base point or change [Spacing " (rtos DistanceBaseGlobal 2 2) "]:") ))
	(if (= Temp "Spacing")
		(progn
			(setq DistanceBaseGlobal (DIMUL_GET_DISTANCEBASEGLOBAL))
			(setq ListTemp (DIMUL_GET_BASEPOINTGLOBAL_DISTANCEBASEGLOBAL))
			(setq PointBaseGlobal (nth 0 ListTemp))
			(setq DistanceBaseGlobal (nth 1 ListTemp))
		)
		(progn
			(setq PointBaseGlobal Temp)
			(vl-registry-write "HKEY_CURRENT_USER\\Software\\Dimension Utility" "DistanceBaseGlobal" (rtos DistanceBaseGlobal 2 2))
		)
	)
	(list PointBaseGlobal DistanceBaseGlobal)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_DISTANCEBASEGLOBAL ( / 
	StringDistanceBaseValid
	Temp)

	(setq StringDistanceBaseValid (strcat "recommended value from " (rtos DistanceBaseGlobalMin 2 2) " to " (rtos DistanceBaseGlobalMax 2 2)))
	(initget 6)
	(setq Temp (getreal (strcat "\nSpecify baseline spacing for scale 1:1 (" StringDistanceBaseValid ") <" (rtos DistanceBaseGlobal 2 2)">:")))
	(if Temp
		(progn
			(if
				(and
					(<= Temp DistanceBaseGlobalMax)
					(>= Temp DistanceBaseGlobalMin)
				)
				(setq DistanceBaseGlobal Temp)
				(progn
					(princ "\nThe distance base is too big or too small. Please try again!")
					(setq DistanceBaseGlobal (DIMUL_GET_DISTANCEBASEGLOBAL))
				)
			)
		)
	)
	DistanceBaseGlobal
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_CLASSIFICATION_LEVEL ( /
	AngleDim
	DistanceBase
	DistanceBaseMax
	DistanceBaseMin
	DistanceLevel
	DistanceLevelPre
	DistanceLevelTemp
	DistanceRound
	ListDataDim
	ListDistanceLevel_ListDataDimTotal
	ListDistanceLevel
	ListDistanceLevelGroup
	ListTemp
	ListClassificationLevel
	ScaleFactor
	Temp)

	(setq ListDataDim (car ListDataDimTotal))
	(setq AngleDim (nth 6 ListDataDim))
	(setq ScaleFactor (nth 7 ListDataDim))
	(setq DistanceBase DistanceBaseGlobal)
	(setq DistanceBaseMax (* ScaleFactor DistanceBaseGlobalMax))
	(setq DistanceBaseMin (* ScaleFactor DistanceBaseGlobalMin))
	(setq DistanceRound (* ScaleFactor DistanceBaseGlobal 0.1))

	(foreach ListDataDim ListDataDimTotal
		(setq DistanceLevel (nth 9 ListDataDim))
		(if (setq Temp (assoc DistanceLevel ListDistanceLevel_ListDataDimTotal))
			(setq ListDistanceLevel_ListDataDimTotal (subst (cons DistanceLevel (cons ListDataDim (cdr Temp))) Temp ListDistanceLevel_ListDataDimTotal))
			(setq ListDistanceLevel_ListDataDimTotal (cons (list DistanceLevel ListDataDim) ListDistanceLevel_ListDataDimTotal))
		)
	)
	
	(setq ListDistanceLevel_ListDataDimTotal (vl-sort ListDistanceLevel_ListDataDimTotal '(lambda (x y) (< (car x) (car y)))))
	(setq ListDistanceLevel (mapcar 'car ListDistanceLevel_ListDataDimTotal))
	(setq DistanceLevelPre (car ListDistanceLevel))
	(setq ListTemp (list DistanceLevelPre))
	(foreach DistanceLevel (cdr ListDistanceLevel)
		(setq DistanceLevelTemp (- DistanceLevel DistanceLevelPre))
		(if (<= DistanceLevelTemp DistanceBaseMin)
			(progn
				(setq ListTemp (cons DistanceLevel ListTemp))
			)
			(progn
				(setq ListDistanceLevelGroup (cons (reverse ListTemp) ListDistanceLevelGroup))
				(setq ListTemp (list DistanceLevel))
			)
		)
		(setq DistanceLevelPre DistanceLevel)
	)
	(setq ListDistanceLevelGroup (cons (reverse ListTemp) ListDistanceLevelGroup))

	(foreach ListTemp ListDistanceLevelGroup
		(setq ListTemp (apply 'append (mapcar '(lambda (x) (cdr (assoc x ListDistanceLevel_ListDataDimTotal))) ListTemp)))
		(setq ListClassificationLevel (cons ListTemp ListClassificationLevel))
	)
	(setq ListClassificationLevel (DIMUL_REVERSE_LEVEL ListClassificationLevel))

	ListClassificationLevel
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_REVERSE_LEVEL ( ListClassificationLevel /
	AngleDimPerTemp
	Point1
	Point2)

	(if (> (length ListClassificationLevel) 1)
		(progn
			(setq Point1 (nth 1 (car (car ListClassificationLevel))))
			(setq Point2 (nth 1 (car (last ListClassificationLevel))))
			(setq AngleDimPerTemp (angle Point1 (DIMUL_PROJECTION_TO_LINE Point1 Point2 (polar Point2 (+ AngleDimPer (* Pi 0.5)) 1000))))
			(if (/= (DIMUL_ROUNDOFF_NUMBER AngleDimPerTemp NumRoundAngle) (DIMUL_ROUNDOFF_NUMBER AngleDimPer NumRoundAngle))
				(setq ListClassificationLevel (reverse ListClassificationLevel))
			)
		)
	)
	ListClassificationLevel
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_ANGLEDIMPERMAIN (  /
	AngleDimPer
	AngleDimPerRound
	ListDataAngleDimPer
	ListAngleDimPer
	Temp)
	
	(setq ListAngleDimPer (mapcar '(lambda(x) (nth 11 x)) ListDataDimTotal))
	(foreach AngleDimPer ListAngleDimPer
		(setq AngleDimPerRound (DIMUL_ROUNDOFF_NUMBER AngleDimPer NumRoundAngle))
		(if (setq Temp (assoc AngleDimPerRound ListDataAngleDimPer))
			(setq ListDataAngleDimPer (subst (list AngleDimPerRound AngleDimPer (+ (nth 2 Temp) 1)) Temp ListDataAngleDimPer))
			(setq ListDataAngleDimPer (cons (list AngleDimPerRound AngleDimPer 1) ListDataAngleDimPer))
		)
	)
	(setq ListDataAngleDimPer (vl-sort ListDataAngleDimPer '(lambda (a b) (> (nth 2 a) (nth 2 b)))))
	(setq AngleDimPer (nth 1 (car ListDataAngleDimPer)))
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_ARANGEDIM ( / 
	AngleDim
	AngleTextPer
	CheckAnnotativeScale
	DataEnameObjectDim
	DistanceBaseEffect
	DistanceText
	DistanceTextEffect
	EnameObjectDim
	ListDataDim
	ListNameAnnotativeScale
	NumLevel
	Point10
	Point10New
	Point11
	Point11New
	Point11Per
	Point11PerNew
	Point13
	Point13New
	Point14
	Point14New
	PointBase1
	PointBase2
	PointDes1
	PointDes2
	ScaleFactor
	SetSectionObjectDim)

	(setq ListNameAnnotativeScale (DIMUL_GET_LISTANNOTATIONSCALES))
	(if ListNameAnnotativeScale
		(progn
			(setq SetSectionObjectDim (ssadd))
			(foreach EnameObjectDim (mapcar 'car ListDataDimTotal)
				(setq SetSectionObjectDim (ssadd EnameObjectDim SetSectionObjectDim))
			)
			(setq CheckAnnotativeScale T)
			(if (member AnntativeScaleCurrent ListNameAnnotativeScale)
				(setq ListNameAnnotativeScale (cons AnntativeScaleCurrent (vl-remove AnntativeScaleCurrent ListNameAnnotativeScale)))
			)
		)
		(setq ListNameAnnotativeScale (cons AnntativeScaleCurrent ListNameAnnotativeScale))
	)
	(if CheckModelSpace
		(setvar "CANNOSCALE" AnntativeScaleCurrent)
	)

	(setq AngleDim (+ AngleDimPer (/ pi 2)))
	(while (>= AngleDim Pi)
		(setq AngleDim (- AngleDim Pi))
	)

	(setq DistanceText (DIMUL_GET_DISTANCETEXT (nth 8 (car ListDataDimTotal))))

	(setq PointBase1 PointBaseGlobal)
	(setq PointBase2 (polar PointBase1 AngleDim 1000))

	(foreach NameAnnotativeScale ListNameAnnotativeScale
		(if (and CheckModelSpace CheckAnnotativeScale)
			(progn
				(setvar "CANNOSCALE" NameAnnotativeScale)
				(command "_AIOBJECTSCALEADD" SetSectionObjectDim "")
			)
		)
		(setq ScaleFactor (DIMUL_GET_SCALEFACTOR (car (car ListDataDimTotal))))
		(setq DistanceBaseEffect (* DistanceBaseGlobal ScaleFactor))
		(setq DistanceTextEffect (* DistanceText ScaleFactor 1.02))

		(setq NumLevel 1)
		(foreach ListTemp ListClassificationLevel
			(setq PointDes1 (polar PointBase1 AngleDimPer (* DistanceBaseEffect NumLevel)))
			(setq PointDes2 (polar PointBase2 AngleDimPer (* DistanceBaseEffect NumLevel)))
			(foreach ListDataDim ListTemp
				(setq EnameObjectDim (nth 0 ListDataDim))
				(setq ListDataDim (DIMUL_GET_LISTDATADIM EnameObjectDim))
				(setq DataEnameObjectDim (entget EnameObjectDim))

				(setq Point10 (nth 1 ListDataDim))
				(setq Point10New (DIMUL_PROJECTION_TO_LINE Point10 PointDes1 PointDes2))
				(setq DataEnameObjectDim (subst (cons 10 Point10New) (cons 10 Point10) DataEnameObjectDim))

				(setq Point13 (nth 4 ListDataDim))
				(setq Point13New (DIMUL_PROJECTION_TO_LINE Point13 PointBase1 PointBase2))
				(setq DataEnameObjectDim (subst (cons 13 Point13New) (cons 13 Point13) DataEnameObjectDim))

				(setq Point14 (nth 5 ListDataDim))
				(setq Point14New (DIMUL_PROJECTION_TO_LINE Point14 PointBase1 PointBase2))
				(setq DataEnameObjectDim (subst (cons 14 Point14New) (cons 14 Point14) DataEnameObjectDim))

				(setq Point11 (nth 2 ListDataDim))
				(setq Point11Per (DIMUL_PROJECTION_TO_LINE Point11 Point10 (polar Point10 AngleDim 1000)))
				(if (DIMUL_EQUAL_TWO_POINT Point11 Point11Per NumRoundDistance)
					(setq AngleTextPer AngleDimPer)
					(setq AngleTextPer (angle Point11Per Point11))
				)
				(setq Point11PerNew (DIMUL_PROJECTION_TO_LINE Point11 PointDes1 PointDes2))
				(setq Point11New (polar Point11PerNew AngleTextPer DistanceTextEffect))
				(setq DataEnameObjectDim (subst (cons 11 Point11New) (cons 11 Point11) DataEnameObjectDim))

				(entmod DataEnameObjectDim)
			)
			(setq NumLevel (+ NumLevel 1))
		)
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_LISTANNOTATIONSCALES ( /
	ListNameAnnotativeScale
	ListTemp
	ListVlaObjectDim)

	(setq ListVlaObjectDim (mapcar 'vlax-ename->vla-object (mapcar 'car ListDataDimTotal)))
	(foreach VlaObjectDim ListVlaObjectDim
		(setq ListTemp (mapcar 'car (DIMUL_GET_ANNOTATIONSCALES VlaObjectDim)))
		(foreach NameAnnotativeScale ListTemp
			(if (not (member NameAnnotativeScale ListNameAnnotativeScale))
				(setq ListNameAnnotativeScale (cons NameAnnotativeScale ListNameAnnotativeScale))
			)
		)
	)
	(setq ListNameAnnotativeScale (reverse ListNameAnnotativeScale))
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_SELECT_DIMENSION ( / 
	AngleDim
	AngleDimFirst
	EnameObjectDim
	EnameObjectDimFirst
	ListDataDim
	ListDataDimTotal
	ListEnameObjectDimTemp
	ListPointChain
	ListPointChainTemp
	ListPointChainTotal
	NameDimStyle
	NameDimStyleFirst
	PointChain
	ScaleFactor
	ScaleFactorFirst)

	(while (not EnameObjectDimFirst)
		(setq EnameObjectDimFirst (DIMUL_SELECT_DIMENSION_FIRST))
	)

	(setq EnameObjectDim EnameObjectDimFirst)
	(setq ListDataDim (DIMUL_GET_LISTDATADIM EnameObjectDim))
	(setq AngleDimFirst (DIMUL_ROUNDOFF_NUMBER (nth 6 ListDataDim) NumRoundAngle))
	(setq ScaleFactorFirst (DIMUL_ROUNDOFF_NUMBER (nth 7 ListDataDim) NumRoundScale))
	(setq NameDimStyleFirst (nth 8 ListDataDim))

	(setq ListPointChainTemp (list (nth 1 ListDataDim) (nth 3 ListDataDim) (nth 4 ListDataDim) (nth 5 ListDataDim)))
	(setq ListPointChainTemp (mapcar '(lambda (P) (mapcar '(lambda (x) (DIMUL_ROUNDOFF_NUMBER x NumRoundDistance)) P)) ListPointChainTemp))
	(setq ListPointChain ListPointChainTemp)
	(setq ListPointChainTotal ListPointChainTemp)
	(setq ListDataDimTotal (list ListDataDim))

	(while ListPointChain
		(setq PointChain (car ListPointChain))
		(setq ListPointChain (cdr ListPointChain))
		(setq ListEnameObjectDimTemp (DIMUL_CREATE_LISTENAMEOBJECT_ON_POINT PointChain))
		(foreach EnameObjectDim ListEnameObjectDimTemp
			(if (not (assoc EnameObjectDim ListDataDimTotal))
				(progn
					(setq ListDataDim (DIMUL_GET_LISTDATADIM EnameObjectDim))
					(if ListDataDim
						(progn
							(setq AngleDim (DIMUL_ROUNDOFF_NUMBER (nth 6 ListDataDim) NumRoundAngle))
							(setq ScaleFactor (DIMUL_ROUNDOFF_NUMBER (nth 7 ListDataDim) NumRoundScale))
							(setq NameDimStyle (nth 8 ListDataDim))
							(if
								(and
									(= AngleDimFirst AngleDim)
									(= ScaleFactorFirst ScaleFactor)
									(= NameDimStyleFirst NameDimStyle)
								)
								(progn
									(setq ListPointChainTemp (list (nth 1 ListDataDim) (nth 3 ListDataDim) (nth 4 ListDataDim) (nth 5 ListDataDim)))
									(setq ListPointChainTemp (mapcar '(lambda (P) (mapcar '(lambda (x) (DIMUL_ROUNDOFF_NUMBER x NumRoundDistance)) P)) ListPointChainTemp))
									(foreach PointChainTemp ListPointChainTemp
										(if (not (member PointChainTemp ListPointChainTotal))
											(progn
												(setq ListPointChain (cons PointChainTemp ListPointChain))
												(setq ListPointChainTotal (cons PointChainTemp ListPointChainTotal))
											)
										)
									)
									(setq ListDataDimTotal (cons ListDataDim ListDataDimTotal))
								)
							)
						)
					)
				)
			)
		)
	)
	(setq ListDataDimTotal (reverse ListDataDimTotal))

	ListDataDimTotal
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_SELECT_DIMENSION_FIRST ( / 
	EnameObjectDim
	EnameObjectDimFirst
	ListDataDim
	Temp)

	(initget 1)
	(setq Temp (entsel "\nSelect object dimension:"))

	(if Temp
		(progn
			(setq EnameObjectDim (car Temp))
			(setq ListDataDim (DIMUL_GET_LISTDATADIM EnameObjectDim))
			(if ListDataDim
				(setq EnameObjectDimFirst EnameObjectDim)
			)
		)
	)
	EnameObjectDimFirst
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_CREATE_LISTENAMEOBJECT_ON_POINT ( Point / 
	ListEnameObject
	SelectionFilter
	SelectionFrame
	SelectionSet
	Size)

	(setq Size ToleranceSelection)
	(setq SelectionFrame
		(list
			(list (- (nth 0 Point) Size) (- (nth 1 Point) Size))
			(list (+ (nth 0 Point) Size) (- (nth 1 Point) Size))
			(list (+ (nth 0 Point) Size) (+ (nth 1 Point) Size))
			(list (- (nth 0 Point) Size) (+ (nth 1 Point) Size))
		)
	)
	(setq SelectionFilter
		(list
			(cons -4 "<OR")
			(cons 100 "AcDbRotatedDimension")
			(cons 100 "AcDbAlignedDimension")
			(cons -4 "OR>")
		)
	)

	(setq SelectionSet (ssget "_CP" SelectionFrame SelectionFilter))
	(setq ListEnameObject (DIMUL_CONVERT_SELECTIONSET_TO_LISTENAMEOBJECT SelectionSet))
	ListEnameObject
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_LISTDATADIM ( EnameObjectDim / 
	AngleDim
	AngleDimPer
	CheckPosityDistance
	DataEnameObjectDim
	DistanceLevel
	ListDataDim
	NameDimStyle
	ObjectType
	Point0
	Point10
	Point11
	Point12
	Point13
	Point14
	PointTemp
	ScaleFactor
	TextHeight)

	(setq DataEnameObjectDim (entget EnameObjectDim))
	(setq ObjectType (cdr (assoc 100 (reverse DataEnameObjectDim))))
	(if
		(or
			(= ObjectType "AcDbRotatedDimension")
			(= ObjectType "AcDbAlignedDimension")
		)
		(progn
			(setq Point10 (cdr (assoc 10 DataEnameObjectDim)))
			(setq Point11 (cdr (assoc 11 DataEnameObjectDim)))
			(setq Point13 (cdr (assoc 13 DataEnameObjectDim)))
			(setq Point14 (cdr (assoc 14 DataEnameObjectDim)))
			(setq NameDimStyle (cdr (assoc 3 DataEnameObjectDim)))
			(if (= ObjectType "AcDbRotatedDimension")
				(progn
					(setq AngleDim (cdr (assoc 50 DataEnameObjectDim)))
				)
			)
			(if (= ObjectType "AcDbAlignedDimension")
				(progn
					(if (DIMUL_EQUAL_TWO_POINT Point13 Point14 NumRoundDistance)
						(setq AngleDim 0.0)
						(setq AngleDim (angle Point13 Point14))
					)
				)
			)
			(while (>= (DIMUL_ROUNDOFF_NUMBER (- AngleDim Pi) NumRoundAngle) 0.0) (setq AngleDim (- AngleDim Pi)))
			(if (DIMUL_EQUAL_TWO_POINT Point10 Point14 NumRoundDistance)
				(setq AngleDimPer (+ AngleDim (/ pi 2)))
				(setq AngleDimPer (angle Point14 Point10))
			)
			(setq Point12 (DIMUL_PROJECTION_TO_LINE Point13 Point10 (polar Point10 AngleDim 1000.0)))
			(setq ScaleFactor (DIMUL_GET_SCALEFACTOR EnameObjectDim))
			(setq Point0 (list 0.0 0.0 0.0))
			(setq PointTemp (DIMUL_PROJECTION_TO_LINE Point0 Point10 (polar Point10 AngleDim 1000.0)))
			(if (< (angle Point0 PointTemp) Pi)
				(setq CheckPosityDistance 1.0)
				(setq CheckPosityDistance -1.0)
			)
			(setq DistanceLevel (* (distance Point0 PointTemp) CheckPosityDistance))
			(setq DistanceLevel (DIMUL_ROUNDOFF_NUMBER DistanceLevel NumRoundDistance))
			(setq TextHeight (vla-get-textheight (vlax-ename->vla-object EnameObjectDim)))
			(setq ListDataDim (list EnameObjectDim Point10 Point11 Point12 Point13 Point14 AngleDim ScaleFactor NameDimStyle DistanceLevel TextHeight AngleDimPer))
		)
	)
	ListDataDim
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_FIND_LISTDELTA ( / 
	AngleDimPer
	ListDataDim1
	ListDataDim2
	ListDelta
	Point1
	Point2
	PointDes
	PointTar)

	(initget 1)
	(setq PointTar (getpoint "\nPick new position:"))

	(setq AngleDimPer (DIMUL_GET_ANGLEDIMPERMAIN))
	(setq ListDataDimTotal (vl-sort ListDataDimTotal '(lambda (a b) (< (nth 9 a) (nth 9 b)))))
	(setq ListDataDim1 (car ListDataDimTotal))
	(setq ListDataDim2 (last ListDataDimTotal))
	(setq Point1 (nth 1 ListDataDim1))
	(setq Point2 (nth 1 ListDataDim2))
	(setq Point2 (DIMUL_PROJECTION_TO_LINE Point2 Point1 (polar Point1 AngleDimPer 1000.0)))
	(if (DIMUL_EQUAL_TWO_POINT Point1 Point2 NumRoundDistance)
		(setq PointDes Point1)
		(if (= (DIMUL_ROUNDOFF_NUMBER (- (angle Point1 Point2) AngleDimPer) NumRoundAngle) 0.0)
			(setq PointDes Point2)
			(setq PointDes Point1)
		)
	)
	(setq PointTar (DIMUL_PROJECTION_TO_LINE PointTar PointDes (polar PointDes AngleDimPer 1000.0)))
	(setq ListDelta (mapcar '- PointTar PointDes))
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_SCALEFACTOR ( EnameObjectDim /
	ListNameAnnotativeScale_ScaleFactor
	ScaleFactor
	VlaObjectDim)

	(setq VlaObjectDim (vlax-ename->vla-object EnameObjectDim))
	(setq ListNameAnnotativeScale_ScaleFactor (DIMUL_GET_ANNOTATIONSCALES VlaObjectDim))
	(setq ScaleFactor (cdr (assoc (getvar "CANNOSCALE") ListNameAnnotativeScale_ScaleFactor)))
	(if (not ScaleFactor)
		(setq ScaleFactor (vla-get-ScaleFactor VlaObjectDim))
	)
	ScaleFactor
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_GET_ANNOTATIONSCALES ( VlaObjectDim / 
	ListTemp
	NameAnnotativeScale
	ScaleFactor
	ListNameAnnotativeScale_ScaleFactor)

	(vl-catch-all-apply (function (lambda ( / )
		(vlax-for VlaAnnotativeScale (vla-item (vla-item (vla-getextensiondictionary VlaObjectDim) "AcDbContextDataManager") "ACDB_ANNOTATIONSCALES")
			(setq ListTemp (entget (cdr (assoc 340 (member (cons 100 "AcDbAnnotScaleObjectContextData") (entget (vlax-vla-object->ename VlaAnnotativeScale)))))))
			(setq NameAnnotativeScale (cdr (assoc 300 ListTemp)))
			(setq ScaleFactor (/ (cdr (assoc 141 ListTemp)) (cdr (assoc 140 ListTemp))))
			(setq ListNameAnnotativeScale_ScaleFactor (cons (cons NameAnnotativeScale ScaleFactor) ListNameAnnotativeScale_ScaleFactor))
		)
	)))
	ListNameAnnotativeScale_ScaleFactor
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_ROUNDOFF_NUMBER ( Number ValueRoundOff /
	Temp1
	Temp2
	ValueResult
	NumberActive
	NumSwitchPositveActive)

	(setq NumberActive (abs (* Number 1.0)))
	(if (>= Number 0.0)
		(setq NumSwitchPositveActive 1.0)
		(setq NumSwitchPositveActive -1.0)
	)
	(setq Temp1 (/ NumberActive ValueRoundOff))
	(setq Temp2 (fix Temp1))
	(if (>= (abs (- Temp1 Temp2)) 0.4999999999)
		(setq ValueResult (* ValueRoundOff (+ Temp2 1.0)))
		(setq ValueResult (* ValueRoundOff (+ Temp2 0.0)))
	)
	(setq ValueResult (* NumSwitchPositveActive ValueResult))
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_EQUAL_TWO_POINT (Point1 Point2 RoundOff / )
	(= (DIMUL_ROUNDOFF_NUMBER (distance Point1 Point2) RoundOff) 0.0)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_PROJECTION_TO_LINE ( Point Point1 Point2 / Normal )
	(setq Normal (mapcar '- Point2 Point1))
	(setq Point1 (trans Point1 0 Normal))
	(setq Point (trans Point 0 Normal))
	(trans (list (car Point1) (cadr Point1) (caddr Point)) Normal 0)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_CONVERT_SELECTIONSET_TO_LISTENAMEOBJECT ( SelectionSet /
	ListEnameObject
	Num)

	(if SelectionSet
		(progn
			(setq Num 0)
			(repeat (sslength SelectionSet)
				(setq EnameObject (ssname SelectionSet Num))
				(if (entget EnameObject)
					(setq ListEnameObject (cons EnameObject ListEnameObject))
				)
				(setq Num (+ Num 1))
			)
		)
	)
	ListEnameObject
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_CREATE_LISTVLALAYERLOCK ( / VlaLayersGroup)
	(setq VlaLayersGroup (vla-get-layers VlaDrawingCurrent))
	(vlax-for VlaLayer VlaLayersGroup
		(if
			(= (vla-get-Lock VlaLayer) :vlax-true)
			(progn
				(vla-put-Lock VlaLayer :vlax-false)
				(setq ListVlaLayerLock (cons VlaLayer ListVlaLayerLock))
			)
		)
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_RESTORE_LOCK_LAYER ( / )
	(foreach VlaLayerLock ListVlaLayerLock
		(vl-catch-all-error-p (vl-catch-all-apply 'vla-put-Lock (list VlaLayerLock :vlax-true)))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_SET_VARSYSTEM ( / )
	(foreach Temp ListVarSystem
		(vl-catch-all-apply (function (lambda ( / )
			(setq ListVarSystem (subst (append Temp (list (getvar (nth 0 Temp)))) Temp ListVarSystem))
			(setvar (nth 0 Temp) (nth 1 Temp))
		)))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun DIMUL_RESET_VARSYSTEM ( / )
	(foreach Temp ListVarSystem
		(vl-catch-all-apply (function (lambda ( / )
			(setvar (nth 0 Temp) (nth 2 Temp))
		)))
	)
)