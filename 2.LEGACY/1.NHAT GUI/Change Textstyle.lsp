

(defun C:CHANGETEXTSTYLE ( /
	CheckLispSys
	ListDataCode
	ListDataCodeStart
	ListDataCodeMid
	ListDataCodeEnd
	ListDataTextStyle
	ListDataTypeCode
	ListNameVarTotal
	ListVlaLayerLock
	ListVarSystem
;	NameTextStyleTarget
;	TypeCodeSourceGlobal
;	TypeCodeTarget
	Version
	VlaDrawingCurrent)

	(vl-load-com)

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

		(setq NameSoftware "Change TextStyle")
		(defun LIC_LOAD_DIALOG ( NameSoftware /
			End_Main_DCL
			Main_DCL
			LicenseKey)

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

			(setq End_Main_DCL (start_dialog))
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
		(defun LIC_MAKE_FILE_DCL ( NameSoftware /
			Num
			DclFile
			DirectoryDes)

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
			(write-line "		width = 30;" DclFile)
			(write-line "		}" DclFile)

			(write-line "		:button{" DclFile)
			(write-line "		label = \"Copy &request code\";" DclFile)
			(write-line "		key = \"Tile_CopyRequestCode\";" DclFile)
			(write-line "		width = 30;" DclFile)
			(write-line "		}" DclFile)
			(write-line "	}" DclFile)
			(write-line "}" DclFile)
			(close DclFile)
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
		(defun LIC_SEND_REQUESTAPI_SENDDATAUSER ( ListData / 
			StringResponse
			StringUrl)

			(vl-catch-all-apply (function (lambda ( / )
				(setq StringUrl "https://script.google.com/home/projects/1puKyDiaQHjL7429vjMrDLbrhpcvFFwjJ7WrzKWM5hmsx7R96Fgar6VBr/edit")
				(foreach Data ListData
					(setq StringUrl (strcat StringUrl (car Data) "=" (cdr Data) "&"))
				)
				(setq StringResponse (LIC_SEND_REQUESTAPI StringUrl))
			)))
			StringResponse
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
				(if (LIC_SEND_REQUESTAPI_SENDDATAUSER ListDataUser)
					(progn
						(setq NumUsed "1")
						(setq DateUsed DateCurrent)
					)
				)
			)
		)
		(vl-registry-write (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "DateUsed" DateUsed)
		(vl-registry-write (strcat "HKEY_CURRENT_USER\\Software\\Cad Standard\\" NameSoftware) "NumUsed" NumUsed)
	)
	-------------------------------------------------------------------------------------------------------------------
	(LIC_REQUESTCODE)
	(setq LIC_REQUESTCODE nil)
  -------------------------------------------------------------------------------------------------------------------
	(setq Version "1.00")
	(setq VlaDrawingCurrent (vla-get-activedocument (vlax-get-acad-object)))
	(vla-startundomark VlaDrawingCurrent)
	(CTESTY_CREATE_LISTVLALAYERLOCK)
	(setq ListVarSystem (list (list "CMDECHO" 0) (list "DIMZIN" 8) (list "MODEMACRO" "Change textstyle...")))
	(CTESTY_SET_VARSYSTEM)
	(setq CheckLispSys (= (getvar "LISPSYS") 1))

	(CTESTY_INITIAL_LISTDATA)
	(CTESTY_CREATE_HASH_STRINGCODESTART)
	(CTESTY_CREATE_HASH_STRINGCODEMID)
	(CTESTY_CREATE_HASH_STRINGCODEEND)
	(CTESTY_CREATE_HASH_STRINGCODE)
	(CTESTY_CREATE_HASH_LISTNUMPOSCODEABCSAME)
	(CTESTY_CREATE_LISTDATATEXTSTYLE)

	(CTESTY_LOAD_DIALOG)

	(CTESTY_RESET_LISTNAMEVAR)
	(CTESTY_RESET_VARSYSTEM)
	(CTESTY_RESTORE_LOCK_LAYER)
	(vla-Regen VlaDrawingCurrent acActiveViewport)
	(vla-endundomark VlaDrawingCurrent)
	(princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_LOAD_DIALOG ( /
	ListVlaObject
	TypeObject
	End_Main_DCL
	Main_DCL)

	(CTESTY_MAKE_FILE_DCL)
	(setq Main_DCL (load_dialog "Change TextStyle.dcl"))
	(new_dialog "ChangeTextStyle" Main_DCL)
	(CTESTY_SET_TILE_DECORATION 1)
	(CTESTY_SET_TILE_LISTNAMETEXTSTYLETARGET)
	(CTESTY_SET_TILE_LISTTYPECODESOURCE)
	(CTESTY_SET_TILE_LISTTYPECODETARGET)

	(action_tile "Tile_ListNameTextStyleTarget"	"(CTESTY_GET_TILE_LISTNAMETEXTSTYLETARGET)")
	(action_tile "Tile_ListTypeCodeSource"		"(CTESTY_GET_TILE_LISTTYPECODESOURCE)")
	(action_tile "Tile_ListTypeCodeTarget"		"(CTESTY_GET_TILE_LISTTYPECODETARGET)")
	(action_tile "Tile_About"					"(CTESTY_ABOUT_PROGRAM)")

	(setq End_Main_DCL (start_dialog))
	(cond
		(
			(= End_Main_DCL 0)
			(unload_dialog Main_DCL)
		)
		(
			(= End_Main_DCL 1)
			(unload_dialog Main_DCL)

			(vl-catch-all-apply (function (lambda ( / )
				(setq ListVlaObject (CTESTY_SELECTOBLECT))
				(foreach VlaObject ListVlaObject
					(vl-catch-all-apply (function (lambda ( / )
						(setq TypeObject (vla-get-objectname VlaObject))

						(cond
							((= TypeObject "AcDbMLeader")
								(CTESTY_CHANGE_TEXTSTYLE_MLEADER VlaObject)
							)
							((= TypeObject "AcDbMText")
								(CTESTY_CHANGE_TEXTSTYLE_MTEXT VlaObject)
							)
							(
								(or
									(= TypeObject "AcDbAttribute")
									(= TypeObject "AcDbText")
                                )
								(CTESTY_CHANGE_TEXTSTYLE_TEXT_ATTRIBUTE VlaObject)
							)
                        )
					)))
				)
			)))
		)
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CHANGE_TEXTSTYLE_MLEADER ( VlaObject / 
	DataStringValueSource
	DataStringValueMap
	DataStringValueMapTemp
	ListDataStringValueOptimize
	ListDataStringValueSource
	NameFontTarget
	NameTextStyleSource
	Num
	StringSubValueSource
	StringValueSource
	StringValueTarget
	TypeCodeFontSource
	TypeDataString)

	(setq StringValueSource (CTESTY_VLA_GET_TEXTSTRING VlaObject))
	(setq NameTextStyleSource (CTESTY_VLA_GET_STYLENAME VlaObject))
	(setq TypeCodeFontSource (nth 2 (assoc NameTextStyleSource ListDataTextStyle)))
	(setq ListDataStringValueSource (CTESTY_ANALYSYS_FORMAT_MTEXT StringValueSource))
	(setq ListDataStringValueOptimize (CTESTY_OPTIMIZE_LISTDATASTRINGVALUE ListDataStringValueSource TypeCodeFontSource))

	(foreach ListTemp ListDataStringValueOptimize
		(setq TypeCodeFontSource (car ListTemp))
		(setq DataStringValueSource (cdr ListTemp))
		(setq DataStringValueMapTemp (CTESTY_DATASTRINGVALUESOURCE_TO_DATASTRINGVALUETARGET DataStringValueSource TypeCodeFontSource TypeCodeTarget))
		(setq DataStringValueMap (append DataStringValueMap DataStringValueMapTemp))
	)

	(setq StringValueTarget "")
	(setq NameFontTarget (nth 1 (assoc NameTextStyleTarget ListDataTextStyle)))
	(setq Num 0)
	(repeat (length ListDataStringValueSource)
		(setq DataStringValueSource (nth Num ListDataStringValueSource))

		(setq TypeDataString (car DataStringValueSource))
		(setq StringSubValueSource (cdr DataStringValueSource))
		(if (= TypeDataString 0)
			(setq StringSubValueSource (cdr (assoc Num DataStringValueMap)))
			(if (= (substr StringSubValueSource 1 2) "\\f")
				(setq StringSubValueSource
					(strcat
						"\\f"
						NameFontTarget
						(substr StringSubValueSource (+ (vl-string-search "|" StringSubValueSource) 1))
					)
				)
			)
		)
		(setq StringValueTarget (strcat StringValueTarget StringSubValueSource))
		(setq Num (+ Num 1))
	)

	(vla-put-TextString VlaObject StringValueTarget)
	(vla-put-TextStyleName VlaObject NameTextStyleTarget)
	(entmod (entget (vlax-vla-object->ename VlaObject)))
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CHANGE_TEXTSTYLE_TEXT_ATTRIBUTE ( VlaObject / 
	NameTextStyleSource
	StringValueSource
	StringValueTarget
	TypeCodeFontSource)

	(setq StringValueSource (CTESTY_VLA_GET_TEXTSTRING VlaObject))
	(setq NameTextStyleSource (CTESTY_VLA_GET_STYLENAME VlaObject))
	(setq TypeCodeFontSource (nth 2 (assoc NameTextStyleSource ListDataTextStyle)))
	(setq StringValueTarget (cdr (car (CTESTY_DATASTRINGVALUESOURCE_TO_DATASTRINGVALUETARGET (list (cons StringValueSource 0)) TypeCodeFontSource TypeCodeTarget))))
	(vla-put-TextString VlaObject StringValueTarget)
	(vla-put-StyleName VlaObject NameTextStyleTarget)
	(entmod (entget (vlax-vla-object->ename VlaObject)))
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CHANGE_TEXTSTYLE_MTEXT ( VlaObject / 
	DataStringValueSource
	DataStringValueMap
	DataStringValueMapTemp
	ListDataStringValueOptimize
	ListDataStringValueSource
	NameFontTarget
	NameTextStyleSource
	Num
	StringSubValueSource
	StringValueSource
	StringValueTarget
	TypeCodeFontSource
	TypeDataString)

	(setq StringValueSource (CTESTY_VLA_GET_TEXTSTRING VlaObject))
	(setq NameTextStyleSource (CTESTY_VLA_GET_STYLENAME VlaObject))
	(setq TypeCodeFontSource (nth 2 (assoc NameTextStyleSource ListDataTextStyle)))
	(setq ListDataStringValueSource (CTESTY_ANALYSYS_FORMAT_MTEXT StringValueSource))
	(setq ListDataStringValueOptimize (CTESTY_OPTIMIZE_LISTDATASTRINGVALUE ListDataStringValueSource TypeCodeFontSource))

	(foreach ListTemp ListDataStringValueOptimize
		(setq TypeCodeFontSource (car ListTemp))
		(setq DataStringValueSource (cdr ListTemp))
		(setq DataStringValueMapTemp (CTESTY_DATASTRINGVALUESOURCE_TO_DATASTRINGVALUETARGET DataStringValueSource TypeCodeFontSource TypeCodeTarget))
		(setq DataStringValueMap (append DataStringValueMap DataStringValueMapTemp))
	)

	(setq StringValueTarget "")
	(setq NameFontTarget (nth 1 (assoc NameTextStyleTarget ListDataTextStyle)))
	(setq Num 0)
	(repeat (length ListDataStringValueSource)
		(setq DataStringValueSource (nth Num ListDataStringValueSource))

		(setq TypeDataString (car DataStringValueSource))
		(setq StringSubValueSource (cdr DataStringValueSource))
		(if (= TypeDataString 0)
			(setq StringSubValueSource (cdr (assoc Num DataStringValueMap)))
			(if (= (substr StringSubValueSource 1 2) "\\f")
				(setq StringSubValueSource
					(strcat
						"\\f"
						NameFontTarget
						(substr StringSubValueSource (+ (vl-string-search "|" StringSubValueSource) 1))
					)
				)
			)
		)
		(setq StringValueTarget (strcat StringValueTarget StringSubValueSource))
		(setq Num (+ Num 1))
	)

	(vla-put-TextString VlaObject StringValueTarget)
	(vla-put-StyleName VlaObject NameTextStyleTarget)
	(entmod (entget (vlax-vla-object->ename VlaObject)))
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_ANALYSYS_FORMAT_MTEXT ( StringValue / 
	ListDataStringSubValue
	ListDataStringSubValueTemp
    ListTemp
	NumEnd
	NumMiddle
	NumTemp
	NumTotalTemp
	StringPattern
	StringPatternTemp
	StringValueEnd
	StringValueHead
	StringValueMiddle
	StringValueStart
	StringValueTemp)

	(setq NumMiddle -1)
	(while (/= StringValue "")
		(setq StringValueTemp StringValue)
		(setq NumMiddle (vl-string-search "\\" StringValueTemp (+ NumMiddle 1)))
		(if NumMiddle
			(progn
				(setq StringValueTemp (substr StringValue (+ NumMiddle 1)))
				(if StringValueTemp
					(progn
						(setq StringValueHead (substr StringValueTemp 1 2))
						(setq NumEnd Nil)
						(cond
							((= StringValueHead "\\f")
								(setq StringPattern "\\f*|b[01]|i[01]")

								(setq StringPatternTemp (strcat StringPattern "|c"))
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern "|p"))
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern ";"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							(
								(or
									(= StringValueHead "\\L")
									(= StringValueHead "\\l")
									(= StringValueHead "\\O")
									(= StringValueHead "\\0")
									(= StringValueHead "\\K")
									(= StringValueHead "\\k")
									(= StringValueHead "\\P")
								)
								(setq NumEnd (+ NumMiddle 2))
							)

							((= StringValueHead "\\p")
								(setq StringPattern "\\px*")

								(setq StringPatternTemp (strcat StringPattern ";"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\Q")
								(setq StringPattern "\\Q")

								(setq StringPatternTemp StringPattern)
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern "."))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
								)

								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPattern (vl-string-right-trim "." StringPattern))
								(setq StringPatternTemp (strcat StringPattern ";"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\H")
								(setq StringPattern "\\H")

								(setq StringPatternTemp StringPattern)
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern "."))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
								)

								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPattern (vl-string-right-trim "." StringPattern))
								(setq StringPatternTemp (strcat StringPattern "x;"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\W")
								(setq StringPattern "\\W")

								(setq StringPatternTemp StringPattern)
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern "."))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
								)

								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPattern (vl-string-right-trim "." StringPattern))
								(setq StringPatternTemp (strcat StringPattern "x;"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\A")
								(setq StringPattern "\\A[012]")

								(setq StringPatternTemp StringPattern)
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\C")
								(setq StringPattern StringValueHead)

								(setq StringPatternTemp StringPattern)
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern ";"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\c")
								(setq StringPattern StringValueHead)

								(setq StringPatternTemp StringPattern)
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern ";"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\T")
								(setq StringPattern StringValueHead)

								(setq StringPatternTemp StringPattern)
								(while (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(setq StringPattern StringPatternTemp)
									(setq StringPatternTemp (strcat StringPattern "[0123456789]"))
								)

								(setq StringPatternTemp (strcat StringPattern ";"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)

							((= StringValueHead "\\S")
								(setq StringPattern StringValueHead)

								(setq StringPatternTemp (strcat StringPattern "*[^/#]*;"))
								(if (wcmatch StringValueTemp (strcat StringPatternTemp "*"))
									(progn
										(setq StringPattern StringPatternTemp)
										(setq NumEnd (+ (vl-string-search ";" StringValueTemp) NumMiddle 1))
									)
								)
							)
						)

						(if NumEnd
							(progn
								(setq StringValueStart (substr StringValue 1 NumMiddle))
								(setq StringValueMiddle (substr StringValue (+ NumMiddle 1) (- NumEnd NumMiddle)))
								(setq StringValueEnd (substr StringValue (+ NumEnd 1)))
								(setq StringValue StringValueEnd)
								(setq NumMiddle -1)
								(if (/= StringValueStart "")
									(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 0 StringValueStart))))
								)

								(if (/= StringValueMiddle "")
									(if (= StringValueHead "\\S")
										(progn
											(setq NumTotalTemp (strlen StringValueMiddle))
											(setq NumTemp Nil)
											(foreach CharTemp (list "^" "/" "#")
												(if (not NumTemp)
													(setq NumTemp (vl-string-search CharTemp StringValueMiddle))
												)
											)
											(setq ListDataStringSubValue
												(append ListDataStringSubValue
													(append
														(list (cons 1 StringValueHead))
														(list (cons 0 (substr StringValueMiddle 3 (- NumTemp 2))))
														(list (cons 1 (substr StringValueMiddle (+ NumTemp 1) 1)))
														(list (cons 0 (substr StringValueMiddle (+ NumTemp 2) (- NumTotalTemp NumTemp 2))))
														(list (cons 1 (substr StringValueMiddle NumTotalTemp)))
													)
												)
											)
										)
										(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 1 StringValueMiddle))))
									)
								)
							)
						)
					)
					(progn
						(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 0 StringValue))))
						(setq StringValue "")
					)
				)
			)
			(progn
				(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 0 StringValue))))
				(setq StringValue "")
			)
		)
	)

	(setq ListDataStringSubValueTemp ListDataStringSubValue)
	(setq ListDataStringSubValue Nil)
	(foreach ListTemp ListDataStringSubValueTemp
		(if (= (car ListTemp) 0)
			(setq ListDataStringSubValue (append ListDataStringSubValue (CTESTY_SPLITSTRING_MTEXT_BRACKET (cdr ListTemp))))
			(setq ListDataStringSubValue (append ListDataStringSubValue (list ListTemp)))
		)
	)

	(setq ListDataStringSubValueTemp ListDataStringSubValue)
	(setq ListDataStringSubValue Nil)
	(foreach ListTemp ListDataStringSubValueTemp
		(if (= (car ListTemp) 0)
			(setq ListDataStringSubValue (append ListDataStringSubValue (CTESTY_SPLITSTRING_TAB (cdr ListTemp))))
			(setq ListDataStringSubValue (append ListDataStringSubValue (list ListTemp)))
		)
	)
	ListDataStringSubValue
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SPLITSTRING_MTEXT_BRACKET ( StringValue / 
	Char
	ListDataStringSubValue
	StringValueTemp)

	(setq StringValueTemp "")
	(while (/= StringValue "")
		(setq Char (substr StringValue 1 1))
		(setq StringValue (substr StringValue 2))
		(if
			(or
				(= Char "{")
				(= Char "}")
			)
			(progn
				(if (/= StringValueTemp "")
					(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 0 StringValueTemp))))
				)
				(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 1 Char))))
				(setq StringValueTemp "")
			)
			(setq StringValueTemp (strcat StringValueTemp Char))
		)
		(setq Char Nil)
	)
	(if (/= StringValueTemp "")
		(setq ListDataStringSubValue (append ListDataStringSubValue (list (cons 0 StringValueTemp))))
	)

	ListDataStringSubValue
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SPLITSTRING_TAB ( StringValue / 
	ListResult
	ListTemp)

	(setq ListTemp (CTESTY_STRING_TO_LIST_NO_TRIM StringValue "\t"))
	(setq ListResult (list (cons 0 (car ListTemp))))
	(foreach Temp (cdr ListTemp)
		(setq ListResult (append ListResult (list (cons 1 "\t") (cons 0 Temp))))
	)
	ListResult
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_OPTIMIZE_LISTDATASTRINGVALUE ( ListDataStringValue TypeCodeFont / 
	DataStringValueNew
	NameFont
	Num
	ListDataStringValueNew
	StringSubValue
	TypeDataString)

	(setq DataStringValueNew (list TypeCodeFont))
	(setq Num 0)
	(foreach DataStringValue ListDataStringValue
		(setq TypeDataString (car DataStringValue))
		(setq StringSubValue (cdr DataStringValue))
		(if
			(and
				(= TypeDataString 1)
				(= (substr StringSubValue 1 2) "\\f")
			)
			(progn
				(setq NameFont (substr StringSubValue 3 ))
				(substr NameFont 1 (vl-string-search "|" NameFont))
				(setq TypeCodeFont (CTESTY_FIND_TYPECODE_NAMEFONT NameFont))
				(if (> (length DataStringValueNew) 1)
					(setq ListDataStringValueNew (append ListDataStringValueNew (list DataStringValueNew)))
				)
				(setq DataStringValueNew (list TypeCodeFont))
			)
		)
		(if (= TypeDataString 0)
			(setq DataStringValueNew (append DataStringValueNew (list (cons StringSubValue Num))))
		)
		(setq Num (+ Num 1))
	)
	(if (> (length DataStringValueNew) 1)
		(setq ListDataStringValueNew (append ListDataStringValueNew (list DataStringValueNew)))
	)

	ListDataStringValueNew
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_TILE_LISTNAMETEXTSTYLETARGET ( / 
	ListNameTextStyle
	StringPos)

	(setq ListNameTextStyle (mapcar 'car ListDataTextStyle))
	(if (not (member NameTextStyleTarget ListNameTextStyle))
		(setq NameTextStyleTarget (car ListNameTextStyle))
	)
	(setq StringPos (itoa (vl-position NameTextStyleTarget ListNameTextStyle)))

	(CTESTY_LOAD_POPUP_LIST "Tile_ListNameTextStyleTarget" ListNameTextStyle)
	(set_tile "Tile_ListNameTextStyleTarget" StringPos)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_TILE_LISTNAMETEXTSTYLETARGET ( / ListNameTextStyle)

	(setq ListNameTextStyle (mapcar 'car ListDataTextStyle))
	(setq NameTextStyleTarget (nth (atoi (get_tile "Tile_ListNameTextStyleTarget")) ListNameTextStyle))
	(CTESTY_SET_TILE_LISTTYPECODETARGET)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_TILE_LISTTYPECODESOURCE ( / 
	ListDataTypeCodeSource
	ListTypeCodeSource
	StringPos)

	(setq ListDataTypeCodeSource (cons (cons "AUTO" "Auto detect") ListDataTypeCode))
	(setq ListTypeCodeSource (mapcar 'cdr ListDataTypeCodeSource))
	(if (not (assoc TypeCodeSourceGlobal ListDataTypeCodeSource))
		(setq TypeCodeSourceGlobal (car (car ListDataTypeCodeSource)))
	)
	(setq StringPos (itoa (vl-position (assoc TypeCodeSourceGlobal ListDataTypeCodeSource) ListDataTypeCodeSource)))
	(CTESTY_LOAD_POPUP_LIST "Tile_ListTypeCodeSource" ListTypeCodeSource)
	(set_tile "Tile_ListTypeCodeSource" StringPos)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_TILE_LISTTYPECODESOURCE ( / ListDataTypeCodeSource)

	(setq ListDataTypeCodeSource (cons (cons "AUTO" "Auto detect") ListDataTypeCode))
	(setq TypeCodeSourceGlobal (car (nth (atoi (get_tile "Tile_ListTypeCodeSource")) ListDataTypeCodeSource)))
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_TILE_LISTTYPECODETARGET ( / 
	ListTypeCodeTarget
	StringPos)

	(setq ListTypeCodeTarget (mapcar 'cdr ListDataTypeCode))
	(setq TypeCodeTarget (nth 2 (assoc NameTextStyleTarget ListDataTextStyle)))
	(setq StringPos (itoa (vl-position (assoc TypeCodeTarget ListDataTypeCode) ListDataTypeCode)))

	(CTESTY_LOAD_POPUP_LIST "Tile_ListTypeCodeTarget" ListTypeCodeTarget)
	(set_tile "Tile_ListTypeCodeTarget" StringPos)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_TILE_LISTTYPECODETARGET ( / )

	(setq TypeCodeTarget (car (nth (atoi (get_tile "Tile_ListTypeCodeTarget")) ListDataTypeCode)))
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_LOAD_POPUP_LIST ( KeyTile ListString / )
	(start_list KeyTile 3)
	(mapcar 'add_list ListString)
	(end_list)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_TILE_OF_SEP ( Tile / )
	(set_tile Tile "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
	(mode_tile Tile 1)                                                    
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_TILE_DECORATION ( NumTotal / Num Tile)
	(setq Num 0)
	(repeat NumTotal
		(setq Tile (strcat "sep" (itoa Num)))
		(set_tile Tile "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
		(setq Num (+ Num 1))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_ABOUT_PROGRAM (/
	About_DCL
	About_End_Dialog)

	(setq About_DCL (load_dialog "Change TextStyle.dcl"))
	(new_dialog "ChangeTextStyleAbout" About_DCL)
	(CTESTY_SET_TILE_OF_SEP "sep1")
	(CTESTY_SET_TILE_OF_SEP "sep2")
	(action_tile "OkAbout" "(done_dialog 0)")
	(setq About_End_Dialog (start_dialog))
	(unload_dialog About_DCL)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_MAKE_FILE_DCL ( /
	DclFile
	DirectoryDes)

	(setq DirectoryDes (strcat (getvar "roamablerootprefix") "Support"))
	(setq DclFile (open (strcat DirectoryDes "\\Change TextStyle.dcl") "w"))
	(write-line "///------------------------------------------------------------------------" DclFile)
	(write-line "///		 Change TextStyle.dcl" DclFile)
	(write-line "ChangeTextStyle:dialog{" DclFile)
	(write-line (strcat "label = \"Change TextStyle " Version "\";") DclFile)

	(write-line "	spacer;" dclfile)

	(write-line "	:row{" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		label = \"Textstyle\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:text{" DclFile)
	(write-line "		label = \"Source\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:text{" DclFile)
	(write-line "		label = \"Target\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)

	(write-line "	:row{" DclFile)
	(write-line "		:popup_list{" DclFile)
	(write-line "		key = \"Tile_ListNameTextStyleTarget\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:popup_list{" DclFile)
	(write-line "		key = \"Tile_ListTypeCodeSource\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:popup_list{" DclFile)
	(write-line "		key = \"Tile_ListTypeCodeTarget\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)

	(write-line "	spacer;" dclfile)

	(write-line "	:text{" DclFile)
	(write-line "	key = \"sep0\";" DclFile)
	(write-line "	}" DclFile)

	(write-line "	:row{" DclFile)

	(write-line "		:button{" DclFile)
	(write-line "		key = \"Tile_Ok\";" DclFile)
	(write-line "		label = \"&OK\";" DclFile)
	(write-line "		is_default = true;" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:button{" DclFile)
	(write-line "		key = \"Tile_Cancel\";" DclFile)
	(write-line "		label = \"&Cancel\";" DclFile)
	(write-line "		is_cancel = true;" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:button{" DclFile)
	(write-line "		key = \"Tile_About\";" DclFile)
	(write-line "		label = \"About ...\";" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)
	(write-line "}" DclFile)

	(write-line "/// About Dialog Box ----------------------------------------------" DclFile)
	(write-line "ChangeTextStyleAbout:dialog{" DclFile)
	(write-line "label = \"Infomations\";" DclFile)
	(write-line "	:boxed_column{" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		label = \"Change TextStyle\";" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line (strcat "		label = \"Copyright © " Version "\";") DclFile)
	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		key = \"sep1\";" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:row{" DclFile)
	(write-line "			:column{" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     Author\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     From\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     Email\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     Telephone\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "			}" DclFile)
	(write-line "			:column{" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     : Nhat Pham Hoang\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     : Hochiminh City - Vietnam\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     : phamhoangnhat@gmail.com\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "				:text{" DclFile)
	(write-line "				label = \"     : +84 933 648 160\";" DclFile)
	(write-line "				}" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		key = \"sep2\";" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:paragraph{" DclFile)
	(write-line "		width = 80;" DclFile)
	(write-line "			:text_part{" DclFile)
	(write-line "				value = \"Any comments please send email to phamhoangnhat@gmail.com.\";" DclFile)
	(write-line "			}" DclFile)
	(write-line "			:text_part{" DclFile)
	(write-line "				value = \"Thank you for using and supporting.\";" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)
	(write-line "	:button{" DclFile)
	(write-line "	label = \"&OK\";" DclFile)
	(write-line "	key = \"OkAbout\";" DclFile)
	(write-line "	is_default = true;" DclFile)
	(write-line "	is_cancel = true;" DclFile)
	(write-line "	width = 15;" DclFile)
	(write-line "	}" DclFile)
	(write-line "}" DclFile)

	(close DclFile)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SELECTOBLECT ( / 
	ListNameBlockCheck
	ListVlaObject
	ListVlaObjectTemp
	NameBlock
	SelectionSet
	VlaBlock
	VlaBlocksGroup)

	(while
		(not
			(and
				SelectionSet
				(> (sslength SelectionSet) 0)
			)
		)
		(setq SelectionSet (ssget ListSelectionFilter))
	)

	(setq ListVlaObjectTemp (CTESTY_CONVERT_SELECTIONSET_TO_LISTVLAOBJECT SelectionSet))

	(setq VlaBlocksGroup (vla-get-blocks VlaDrawingCurrent))
	(foreach VlaObject ListVlaObjectTemp
		(CTESTY_ADD_LISTVLAOBJECT VlaObject)
	)

	(while ListNameBlockCheck
		(setq NameBlock (car ListNameBlockCheck))
		(setq ListNameBlockCheck (cdr ListNameBlockCheck))
		(setq VlaBlock (vla-item VlaBlocksGroup NameBlock))
		(vlax-for VlaObject VlaBlock
			(CTESTY_ADD_LISTVLAOBJECT VlaObject)
		)
	)
	ListVlaObject
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_ADD_LISTVLAOBJECT ( VlaObject / 
	VlaAttibute
	ListVlaAttibute
	NameBlock
	TypeObject
	VlaBlock)

	(setq TypeObject (vla-get-objectname VlaObject))
	(if
		(or
			(= TypeObject "AcDbMLeader")
			(= TypeObject "AcDbMText")
			(= TypeObject "AcDbText")
		)
		(setq ListVlaObject (cons VlaObject ListVlaObject))
	)
	(if (= TypeObject "AcDbBlockReference")
		(progn
			(setq NameBlock (CTESTY_GET_EFFECTIVENAME_BLOCK VlaObject))
			(setq VlaBlock (vla-item VlaBlocksGroup NameBlock))
			(if (= (vla-get-IsXRef VlaBlock) :vlax-false)
				(progn
					(if (= (vla-get-HasAttributes VlaObject) :vlax-true)
						(progn
							(setq ListVlaAttibute (vlax-safearray->list (vlax-variant-value (vla-GetAttributes VlaObject))))
							(foreach VlaAttibute ListVlaAttibute
								(setq ListVlaObject (cons VlaAttibute ListVlaObject))
							)
						)
					)
					(if (not (member NameBlock ListNameBlockCheck))
						(setq ListNameBlockCheck (cons NameBlock ListNameBlockCheck))
					)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_DATASTRINGVALUESOURCE_TO_DATASTRINGVALUETARGET ( DataStringSubValueSource TypeCodeFont TypeCodeTarget / 
	CheckLower
	GroupCharSentence
	ListCharSentence
	ListDataStringValueTarget
	ListNumPos
	ListNumPosCode
	ListStringValueSource
	ListWordSentence
	NumPos
	StringValueTarget
	TypeCodeSource)

	(setq ListStringValueSource (mapcar 'car DataStringSubValueSource))
	(setq GroupCharSentence (mapcar 'CTESTY_STRINGVALUE_TO_LISTCHAR ListStringValueSource))

	(setq ListWordSentence (CTESTY_LISTCHARSENTENCE_TO_LISTWORDSENTENCE (apply 'append GroupCharSentence)))
	(if (= TypeCodeSourceGlobal "AUTO")
		(setq TypeCodeSource (CTESTY_FIND_TYPECODESOURCE ListWordSentence TypeCodeFont))
		(setq TypeCodeSource TypeCodeSourceGlobal)
	)
	(setq CheckLower (CTESTY_FIND_CHECKLOWER TypeCodeSource ListWordSentence))

	(setq ListNumPos (mapcar 'cdr DataStringSubValueSource))
	(setq Num 0)
	(repeat (length GroupCharSentence)
		(setq ListCharSentence (nth Num GroupCharSentence))
		(setq NumPos (nth Num ListNumPos))

		(setq ListNumPosCode (CTESTY_LISTCHARSENTENCE_TO_LISTNUMPOSCODE TypeCodeSource ListCharSentence CheckLower))
		(setq StringValueTarget (CTESTY_LISTNUMPOSCODE_TO_STRINGVALUETARGET TypeCodeTarget ListNumPosCode))
		(setq ListDataStringValueTarget (append ListDataStringValueTarget (list (cons NumPos StringValueTarget))))
		(setq Num (+ Num 1))
    )

	ListDataStringValueTarget
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_FIND_TYPECODESOURCE ( ListWordSentence TypeCodeFont / 
	CountTypeCodeMax
	ListDataCountTypeCode
	ListDataCountTypeCodeMax
	Temp
	TypeCodeSource)

	(setq ListDataCountTypeCode (mapcar '(lambda (x) (cons (nth 0 x) 0)) ListDataCode))
	(foreach ListCharWord ListWordSentence
		(setq ListCharWord (mapcar '(lambda (x) (strcase x T)) ListCharWord))
		(CTESTY_CHECK_TYPECODESOURCE_WORD ListCharWord)
	)

	(setq ListDataCountTypeCode (vl-sort ListDataCountTypeCode '(lambda (a b) (> (cdr a) (cdr b)))))
	(setq CountTypeCodeMax (cdr (car ListDataCountTypeCode)))
	(foreach DataCountTypeCode ListDataCountTypeCode
		(if (= (cdr DataCountTypeCode) CountTypeCodeMax)
			(setq ListDataCountTypeCodeMax (append ListDataCountTypeCodeMax (list DataCountTypeCode)))
		)
	)
	(if (setq Temp (assoc TypeCodeFont ListDataCountTypeCodeMax))
		(setq TypeCodeSource (car Temp))
		(setq TypeCodeSource (car (car ListDataCountTypeCodeMax)))
    )
	TypeCodeSource
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CHECK_TYPECODESOURCE_WORD ( ListCharWord / 
	Num
	CheckTypeCodeMid
	CheckTypeCodeStart
	CountTypeCode
	ListCharMid
	ListCharStart
	ListDataCountTypeCodeTemp
	StringCodeMid
	StringCodeStart
	Temp1
	Temp2
	TypeCodeSource)

	(setq ListDataCountTypeCodeTemp (mapcar '(lambda (x) (cons (nth 0 x) 0)) ListDataCode))
	(setq Num 0)
	(while (<= Num 3)
		(foreach Temp1 ListDataCountTypeCodeTemp
			(setq TypeCodeSource (car Temp1))
			(setq CountTypeCode (cdr Temp1))
			(setq ListCharStart (CTESTY_SUBTRACT_LIST ListCharWord 1 Num))
			(setq StringCodeStart (CTESTY_LISTCHAR_TO_STRINGCODE ListCharStart))
			(setq CheckTypeCodeStart (CTESTY_GET_HASH_STRINGCODESTART TypeCodeSource StringCodeStart))
			(if CheckTypeCodeStart
				(if (= CountTypeCode 0)
					(progn
						(setq ListCharMid (CTESTY_SUBTRACT_LIST ListCharWord (+ Num 1) Nil))
						(setq StringCodeMid (CTESTY_LISTCHAR_TO_STRINGCODE ListCharMid))
						(setq CheckTypeCodeMid (CTESTY_GET_HASH_STRINGCODEMID TypeCodeSource StringCodeMid))
						(if CheckTypeCodeMid
							(progn
								(setq ListDataCountTypeCodeTemp (subst (cons TypeCodeSource 1) Temp1 ListDataCountTypeCodeTemp))
								(setq Temp2 (assoc TypeCodeSource ListDataCountTypeCode))
								(setq ListDataCountTypeCode (subst (cons TypeCodeSource (+ (cdr Temp2) 1)) Temp2 ListDataCountTypeCode))
							)
						)
					)
				)
			)
		)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_LISTCHARSENTENCE_TO_LISTNUMPOSCODE ( TypeCodeSource ListCharSentence CheckLower / 
	NumLengthCode
	NumLengthCodeStart
	NumPosCode
	ListNumPosCode
	StringCode
	ListChar)

	(setq NumLengthCodeStart (nth 2 (assoc TypeCodeSource ListDataCode)))
	(while ListCharSentence
		(setq NumPosCode Nil)
		(setq NumLengthCode NumLengthCodeStart)
		(while
			(and
				(not NumPosCode)
				(> NumLengthCode 0)
			)
			(setq ListChar (CTESTY_SUBTRACT_LIST ListCharSentence 1 NumLengthCode))
			(setq StringCode (CTESTY_LISTCHAR_TO_STRINGCODE ListChar))
			(setq NumPosCode (CTESTY_GET_HASH_STRINGCODE TypeCodeSource StringCode))
			(if NumPosCode
				(progn
					(cond
						(
							(= CheckLower 1)
							(if (>= NumPosCode 94)
								(setq NumPosCode (- NumPosCode 94))
							)
						)
						(
							(= CheckLower 0)
							(if (< NumPosCode 94)
								(setq NumPosCode (+ NumPosCode 94))
							)
						)
                    )
					(setq ListNumPosCode (append ListNumPosCode (list NumPosCode)))
					(setq ListCharSentence (CTESTY_SUBTRACT_LIST ListCharSentence (+ NumLengthCode 1) Nil))
				)
			)
			(setq NumLengthCode (- NumLengthCode 1))
		)
		(if (not NumPosCode)
			(progn
				(setq ListNumPosCode (append ListNumPosCode (CTESTY_SUBTRACT_LIST ListCharSentence 1 1)))
				(setq ListCharSentence (CTESTY_SUBTRACT_LIST ListCharSentence 2 Nil))
			)
		)
	)
	ListNumPosCode
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_LISTNUMPOSCODE_TO_STRINGVALUETARGET ( TypeCodeTarget ListNumPosCode / 
	NumPosCode
	ListStringCode
	StringCode
	StringSubValue
	StringValue)

	(setq ListStringCode (nth 3 (assoc TypeCodeTarget ListDataCode)))
	(setq StringValue "")
	(foreach Temp ListNumPosCode
		(if (= (type Temp) 'STR)
			(setq StringSubValue Temp)
			(progn
				(setq NumPosCode Temp)
				(setq StringCode (nth NumPosCode ListStringCode))
				(setq StringSubValue (CTESTY_STRINGCODE_TO_STRINGSUBVALUE StringCode))
			)
		)
		(setq StringValue (strcat StringValue StringSubValue))
	)
	StringValue
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_FIND_CHECKLOWER ( TypeCodeSource ListWordSentence / 
	CheckLower
	ListCharWord)

	(if (= TypeCodeSource "ABC")
		(progn
			(while
				(and
					(not CheckLower)
					ListWordSentence
				)
				(setq ListCharWord (car ListWordSentence))
				(setq ListWordSentence (cdr ListWordSentence))
				(setq CheckLower (CTESTY_FIND_CHECKLOWER_WORD TypeCodeSource ListCharWord))
			)
			(if CheckLower
				(setq CheckLower 1)
				(setq CheckLower 0)
            )
		)
	)
	CheckLower
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_FIND_CHECKLOWER_WORD ( TypeCodeSource ListCharWord / 
	CheckTypeCode
	NumLengthTotal
	StringCode
	ListChar)

	(setq NumLengthTotal (length ListCharWord))

	(foreach Num (list 1 2 3)
		(if (not CheckTypeCode)
			(progn
				(if (<= Num NumLengthTotal)
					(progn
						(setq ListChar (CTESTY_SUBTRACT_LIST ListCharWord 1 Num))
						(setq StringCode (CTESTY_LISTCHAR_TO_STRINGCODE ListChar))
						(setq CheckTypeCode (CTESTY_GET_HASH_STRINGCODESTART TypeCodeSource StringCode))
					)
				)
			)
		)
	)

	(foreach Num (list 1 2)
		(if (not CheckTypeCode)
			(progn
				(setq NumTemp (- NumLengthTotal Num -1))
				(if (> NumTemp 0)
					(progn
						(setq ListChar (CTESTY_SUBTRACT_LIST ListCharWord NumTemp Nil))
						(setq StringCode (CTESTY_LISTCHAR_TO_STRINGCODE ListChar))
						(setq CheckTypeCode (CTESTY_GET_HASH_STRINGCODEEND TypeCodeSource StringCode))
					)
				)
			)
		)
	)
	CheckTypeCode
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_LISTCHAR_TO_STRINGCODE ( ListChar / StringCode )

	(setq StringCode (apply 'strcat (mapcar 'CTESTY_CHAR_TO_STRINGCODE ListChar)))
	StringCode
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CHAR_TO_STRINGCODE ( Char / StringCode )

	(if (= (strlen Char) 7)
		(setq StringCode (substr Char 4))
		(progn
			(setq StringCode (CTESTY_CONVERT_DECIMAL_TO_BASE (car (vl-string->list Char)) 16))
			(repeat (- 4 (strlen StringCode))
				(setq StringCode (strcat "0" StringCode))
			)
		)
	)
	StringCode
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CONVERT_DECIMAL_TO_BASE ( Num Base / 
	CharTemp
	NumMod
	StringNum)

	(setq StringNum "")
	(while (> Num 0)
		(setq NumMod (rem Num Base))
		(if (< NumMod 10)
			(setq CharTemp (chr (+ NumMod 48)))
			(setq CharTemp (chr (+ NumMod 55)))
		)
		(setq StringNum (strcat CharTemp StringNum))
		(setq Num (/ Num Base))
	)
	(if (= StringNum "")
		(setq StringNum "0")
	)
	StringNum
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_STRINGCODE_TO_STRINGSUBVALUE ( StringCode / 
	CharValue
	StringSubValue)

	(setq StringSubValue "")
	(while (/= StringCode "")
		(setq CharValue (strcat "\\U+" (substr StringCode 1 4)))
		(setq StringSubValue (strcat StringSubValue CharValue))
		(setq StringCode (substr StringCode 5))
	)
	StringSubValue
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_STRINGVALUE_TO_LISTCHAR ( StringValue / 
	CheckValidUnicode
	ListChar
	StringSubValue)

	(while (/= StringValue "")
		(setq StringSubValue (substr StringValue 1 7))
		(setq CheckValidUnicode (CTESTY_CHECKVALIDUNICODE StringSubValue))
		(if CheckValidUnicode
			(progn
				(setq ListChar (append ListChar (list StringSubValue)))
				(setq StringValue (substr StringValue 8))
			)
			(progn
				(setq StringSubValue (substr StringValue 1 1))
				(setq ListChar (append ListChar (list StringSubValue)))
				(setq StringValue (substr StringValue 2))
			)
		)
	)
	ListChar
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CHECKVALIDUNICODE ( StringSubValue / 
	Char
	CheckValidUnicode
	StringCode)

	(setq CheckValidUnicode T)
	(if (= (substr StringSubValue 1 3) "\\U+")
		(progn
			(setq StringCode (substr StringSubValue 4))
			(while
				(and
					CheckValidUnicode
					(/= StringCode "")
				)
				(setq Char (substr StringCode 1 1))
				(if
					(or
						(< Char "0")
						(and
							(> Char "9")
							(< Char "A")
						)
						(> Char "F")
					)
					(setq CheckValidUnicode Nil)
				)
				(setq StringCode (substr StringCode 2))
			)
		)
		(setq CheckValidUnicode Nil)
	)
	CheckValidUnicode
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_HASH_LISTNUMPOSCODEABCSAME ( / 
	ListStringCodeABC
	NumPosCode)

	(setq ListStringCodeABC (nth 3 (assoc "ABC" ListDataCode)))
	(setq NumPosCode 94)
	(repeat 94
		(if
			(=
				(nth NumPosCode ListStringCodeABC)
				(nth (- NumPosCode 94) ListStringCodeABC)
			)
			(CTESTY_SET_HASH_NUMPOSCODEABCSAME NumPosCode)
		)
		(setq NumPosCode (+ NumPosCode 1))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_HASH_NUMPOSCODEABCSAME ( NumPosCode / NameVar)

	(setq NameVar (CTESTY_CREATE_NAMEVAR "NUMPOSCODEABCSAME" (itoa NumPosCode)))
	(setq ListNameVarTotal (cons NameVar ListNameVarTotal))
	(set NameVar T)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_HASH_NUMPOSCODEABCSAME ( NumPosCode / NameVar)

	(setq NameVar (CTESTY_CREATE_NAMEVAR "NUMPOSCODEABCSAME" (itoa NumPosCode)))
	(eval NameVar)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_HASH_STRINGCODESTART ( / StringCode )

	(foreach DataCode ListDataCode
		(setq TypeCode (nth 0 DataCode))
		(setq ListStringCode (nth 3 DataCode))
		(foreach DataCodeStart ListDataCodeStart
			(setq StringCode "")
			(foreach PosCode DataCodeStart
				(setq StringCode (strcat StringCode (nth PosCode ListStringCode)))
			)
			(CTESTY_SET_HASH_STRINGCODESTART TypeCode StringCode)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_HASH_STRINGCODESTART ( TypeCode StringCode / NameVar)

	(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODESTART" TypeCode) StringCode))
	(setq ListNameVarTotal (cons NameVar ListNameVarTotal))
	(set NameVar T)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_HASH_STRINGCODESTART ( TypeCode StringCode /
	NameVar
	Result)

	(if (= StringCode "")
		(setq Result T)
		(progn
			(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODESTART" TypeCode) StringCode))
			(setq Result (eval NameVar))
		)
	)
	Result
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_HASH_STRINGCODEMID ( / 
	ListStringCode
	StringCode
	TypeCode)

	(foreach DataCode ListDataCode
		(setq TypeCode (nth 0 DataCode))
		(setq ListStringCode (nth 3 DataCode))
		(foreach DataCodeMid ListDataCodeMid
			(setq StringCode "")
			(foreach PosCode DataCodeMid
				(setq StringCode (strcat StringCode (nth PosCode ListStringCode)))
			)
			(CTESTY_SET_HASH_STRINGCODEMID TypeCode StringCode)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_HASH_STRINGCODEMID ( TypeCode StringCode / NameVar)

	(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODEMID" TypeCode) StringCode))
	(setq ListNameVarTotal (cons NameVar ListNameVarTotal))
	(set NameVar T)
)

--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_HASH_STRINGCODEMID ( TypeCode StringCode /
	NameVar
	Result)

	(if (= StringCode "")
		(setq Result T)
		(progn
			(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODEMID" TypeCode) StringCode))
			(setq Result (eval NameVar))
		)
	)
	Result
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_HASH_STRINGCODEEND ( /
	ListStringCode
	StringCode
	TypeCode)

	(foreach DataCode ListDataCode
		(setq TypeCode (nth 0 DataCode))
		(setq ListStringCode (nth 3 DataCode))
		(foreach DataCodeEnd ListDataCodeEnd
			(setq StringCode "")
			(foreach PosCode DataCodeEnd
				(setq StringCode (strcat StringCode (nth PosCode ListStringCode)))
			)
			(CTESTY_SET_HASH_STRINGCODEEND TypeCode StringCode)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_HASH_STRINGCODEEND ( TypeCode StringCode / NameVar)

	(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODEEND" TypeCode) StringCode))
	(setq ListNameVarTotal (cons NameVar ListNameVarTotal))
	(set NameVar T)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_HASH_STRINGCODEEND ( TypeCode StringCode /
	NameVar
	Result)

	(if (= StringCode "")
		(setq Result T)
		(progn
			(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODEEND" TypeCode) StringCode))
			(setq Result (eval NameVar))
		)
	)
	Result
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_HASH_STRINGCODE ( / 
	ListStringCode
	TypeCode)

	(foreach DataCode ListDataCode
		(setq TypeCode (nth 0 DataCode))
		(setq ListStringCode (nth 3 DataCode))
		(CTESTY_SET_HASH_LISTSTRINGCODE ListStringCode TypeCode)
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_HASH_LISTSTRINGCODE ( ListStringCode TypeCode / NumPosCode)

	(setq NumPosCode 0)
	(foreach StringCode ListStringCode
		(CTESTY_SET_HASH_STRINGCODE TypeCode StringCode NumPosCode)
		(setq NumPosCode (+ NumPosCode 1))
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_HASH_STRINGCODE ( TypeCode StringCode NumPosCode / NameVar)

	(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODE" TypeCode) StringCode))
	(setq ListNameVarTotal (cons NameVar ListNameVarTotal))
	(set NameVar NumPosCode)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_HASH_STRINGCODE ( TypeCode StringCode /
	NameVar
	NumPosCode)

	(setq NameVar (CTESTY_CREATE_NAMEVAR (strcat "STRINGCODE" TypeCode) StringCode))
	(setq NumPosCode (eval NameVar))
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_RESET_LISTNAMEVAR ( / )
	(foreach NameVar ListNameVarTotal
		(set NameVar T)
	)
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_LISTDATATEXTSTYLE ( / 
	DataFont
	NameTextStyle
	TypeCode
	VlaTextstylesGroup)

	(setq VlaTextstylesGroup (vla-get-textstyles VlaDrawingCurrent))
	(vlax-for VlaTextstyle VlaTextstylesGroup

		(setq NameTextStyle (CTESTY_VLA_GET_NAME VlaTextstyle))
		(if (not (vl-string-search "|" NameTextStyle))
			(progn
				(setq DataFont (CTESTY_FIND_DATAFONT_VLATEXTSTYLE VlaTextstyle))
				(setq NameFont (nth 0 DataFont))
				(setq TypeCode (nth 1 DataFont))
				(setq ListDataTextStyle (cons (list NameTextStyle NameFont TypeCode) ListDataTextStyle))
            )
        )
	)
	ListDataTextStyle
)
--------------------------------------------------------------------------------------------------------------------
(defun CTESTY_FIND_DATAFONT_VLATEXTSTYLE ( VlaTextstyle /
	Charset
	FontBold
	FontItalic
	NameFont
	PathFont
	PitchAndFamily
	TypeCode)

	(vla-GetFont VlaTextStyle 'NameFont 'FontBold 'FontItalic 'Charset 'PitchAndFamily)
	(setq TypeCode (CTESTY_FIND_TYPECODE_NAMEFONT NameFont))
	(if (not TypeCode)
		(progn
			(setq PathFont (vla-get-fontFile VlaTextStyle))
			(setq NameFont (vl-filename-base PathFont))
			(setq TypeCode (CTESTY_FIND_TYPECODE_NAMEFONT NameFont))
		)
	)
	(list NameFont TypeCode)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_FIND_TYPECODE_NAMEFONT ( NameFont / TypeCode)

	(cond
		(
			(= (strcase (substr NameFont 1 3)) "VNI")
			(setq TypeCode "VNI")
		)
		(
			(or
				(= (strcase (substr NameFont 1 3)) ".VN")
				(= (strcase (substr NameFont 1 2)) "VN")
			)
			(setq TypeCode "ABC")
		)
		(
			(/= NameFont "")
			(setq TypeCode "UNI")
		)
	)
	TypeCode
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_NAMEVAR ( TypeCode StringCode / 
	NameVar
	StringTemp)

	(setq StringTemp (strcat TypeCode StringCode))
	(setq NameVar (read StringTemp))
	NameVar
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_VLA_GET_STYLENAME ( VlaObject /
	NameStyle
	TypeObject
	DataEname
	NumCode
	NameStyle
	DataEname
	DataEnameTemp)

	(vl-catch-all-apply (function (lambda ( / )
		(setq NameStyle (vla-get-stylename VlaObject))
	)))
	(if
		(or
			(not NameStyle)
			(and
				NameStyle
				(vl-string-search "?" NameStyle)
			)
		)
		(progn
			(setq TypeObject (vla-get-ObjectName VlaObject))
			(if
				(or
					(= TypeObject "AcDb2LineAngularDimension")
					(= TypeObject "AcDb3PointAngularDimension")
					(= TypeObject "AcDbAlignedDimension")
					(= TypeObject "AcDbArcDimension")
					(= TypeObject "AcDbDiametricDimension")
					(= TypeObject "AcDbFcf")
					(= TypeObject "AcDbLeader")
					(= TypeObject "AcDbOrdinateDimension")
					(= TypeObject "AcDbRadialDimension")
					(= TypeObject "AcDbRadialDimensionLarge")
					(= TypeObject "AcDbRotatedDimension")
				)
				(setq NameStyle (cdr (assoc 3 (entget (vlax-vla-object->ename VlaObject)))))
			)
			(if
				(or
					(= TypeObject "AcDbAttributeDefinition")
					(= TypeObject "AcDbMText")
					(= TypeObject "AcDbText")
					(= TypeObject "AcDbAttribute")
				)
				(setq NameStyle (cdr (assoc 7 (entget (vlax-vla-object->ename VlaObject)))))
			)
			(if (= TypeObject "AcDbMline")
				(setq NameStyle (cdr (assoc 2 (entget (vlax-vla-object->ename VlaObject)))))
			)
			(if (= TypeObject "AcDbMLeader")
				(progn
					(setq DataEname (entget (vlax-vla-object->ename VlaObject)))
					(setq NumCode 340)
					(setq NameStyle Nil)
					(while (and (assoc NumCode DataEname) (not NameStyle))
						(setq DataEnameTemp (entget (cdr (assoc NumCode DataEname))))
						(if
							(= (cdr (assoc 0 DataEnameTemp)) "MLEADERSTYLE")
							(setq NameStyle (CTESTY_VLA_GET_NAME (vlax-ename->vla-object (cdr (assoc NumCode DataEname)))))
						)
						(setq DataEname (vl-remove (assoc NumCode DataEname) DataEname))
					)
				)
			)
			(if (= TypeObject "AcDbTable")
				(progn
					(setq DataEname (entget (vlax-vla-object->ename VlaObject)))
					(setq NumCode 342)
					(setq NameStyle Nil)
					(while (and (assoc NumCode DataEname) (not NameStyle))
						(setq DataEnameTemp (entget (cdr (assoc NumCode DataEname))))
						(if
							(= (cdr (assoc 0 DataEnameTemp)) "TABLESTYLE")
							(setq NameStyle (CTESTY_VLA_GET_NAME (vlax-ename->vla-object (cdr (assoc NumCode DataEname)))))
						)
						(setq DataEname (vl-remove (assoc NumCode DataEname) DataEname))
					)
				)
			)
		)
	)
	NameStyle
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_STRING_TO_LIST_NO_TRIM (Stg Del / LenDel StgTemp Pos StgSub StgSubTemp ListString)
	(if Stg
		(progn
			(setq LenDel (strlen Del))
			(setq StgTemp Stg)
			(while (setq Pos (vl-string-search Del StgTemp))
				(setq StgSub (substr StgTemp 1 Pos))
				(setq StgTemp (substr StgTemp (+ Pos 1 LenDel)))
				(setq StgSubTemp StgSub)
				(if (/= StgSubTemp "")
					(setq ListString (cons StgSub ListString))
				)
			)
			(setq StgSub StgTemp)
			(setq StgSubTemp StgSub)

			(if (/= StgSubTemp "")
				(setq ListString (cons StgSub ListString))
			)
			(if (not ListString)
				(setq ListString (list Stg))
			)
			(setq ListString (reverse ListString))
		)
	)
	ListString
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SUBTRACT_LIST ( ListValue NumStart NumElement /
	ListValueResult
	Num
	NumElementMin)

	(setq Num (- NumStart 1))
	(setq NumElementMin (- (length ListValue) NumStart -1))
	(if (not NumElement)
		(setq NumElement NumElementMin)
		(setq NumElement (min NumElement NumElementMin))
	)
	(repeat NumElement
		(setq ListValueResult (append ListValueResult (list (nth Num ListValue))))
		(setq Num (+ Num 1))
	)
	ListValueResult
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_LISTCHARSENTENCE_TO_LISTWORDSENTENCE ( ListCharSentence /
	Char
	ListWordSentence
	ListTemp)

	(setq ListTemp Nil)
	(while ListCharSentence
		(setq Char (car ListCharSentence))
		(setq ListCharSentence (cdr ListCharSentence))
		(if
			(or
				(= Char " ")
				(= Char "\t")
			)
			(if ListTemp
				(progn
					(setq ListWordSentence (append ListWordSentence (list ListTemp)))
					(setq ListTemp Nil)
				)
			)
			(setq ListTemp (append ListTemp (list Char)))
		)
	)
	(if ListTemp
		(setq ListWordSentence (append ListWordSentence (list ListTemp)))
	)
	ListWordSentence
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_INITIAL_LISTDATA ( / )

	(setq ListDataCode
		(list
			(list "UNI" "Unicode"		1 (list "0061" "00E1" "00E0" "1EA3" "00E3" "1EA1" "0103" "1EAF" "1EB1" "1EB3" "1EB5" "1EB7" "00E2" "1EA5" "1EA7" "1EA9" "1EAB" "1EAD" "0065" "00E9" "00E8" "1EBB" "1EBD" "1EB9" "00EA" "1EBF" "1EC1" "1EC3" "1EC5" "1EC7" "0069" "00ED" "00EC" "1EC9" "0129" "1ECB" "006F" "00F3" "00F2" "1ECF" "00F5" "1ECD" "00F4" "1ED1" "1ED3" "1ED5" "1ED7" "1ED9" "01A1" "1EDB" "1EDD" "1EDF" "1EE1" "1EE3" "0075" "00FA" "00F9" "1EE7" "0169" "1EE5" "01B0" "1EE9" "1EEB" "1EED" "1EEF" "1EF1" "0079" "00FD" "1EF3" "1EF7" "1EF9" "1EF5" "0111" "0062" "0063" "0064" "0067" "0068" "006B" "006C" "006D" "006E" "0070" "0071" "0072" "0073" "0074" "0076" "0078" "0079" "0066" "006A" "0077" "007A" "0041" "00C1" "00C0" "1EA2" "00C3" "1EA0" "0102" "1EAE" "1EB0" "1EB2" "1EB4" "1EB6" "00C2" "1EA4" "1EA6" "1EA8" "1EAA" "1EAC" "0045" "00C9" "00C8" "1EBA" "1EBC" "1EB8" "00CA" "1EBE" "1EC0" "1EC2" "1EC4" "1EC6" "0049" "00CD" "00CC" "1EC8" "0128" "1ECA" "004F" "00D3" "00D2" "1ECE" "00D5" "1ECC" "00D4" "1ED0" "1ED2" "1ED4" "1ED6" "1ED8" "01A0" "1EDA" "1EDC" "1EDE" "1EE0" "1EE2" "0055" "00DA" "00D9" "1EE6" "0168" "1EE4" "01AF" "1EE8" "1EEA" "1EEC" "1EEE" "1EF0" "0059" "00DD" "1EF2" "1EF6" "1EF8" "1EF4" "0110" "0042" "0043" "0044" "0047" "0048" "004B" "004C" "004D" "004E" "0050" "0051" "0052" "0053" "0054" "0056" "0058" "0059" "0046" "004A" "0057" "005A"))
			(list "VNI" "VNI Windows"	2 (list "0061" "006100F9" "006100F8" "006100FB" "006100F5" "006100EF" "006100EA" "006100E9" "006100E8" "006100FA" "006100FC" "006100EB" "006100E2" "006100E1" "006100E0" "006100E5" "006100E3" "006100E4" "0065" "006500F9" "006500F8" "006500FB" "006500F5" "006500EF" "006500E2" "006500E1" "006500E0" "006500E5" "006500E3" "006500E4" "0069" "00ED" "00EC" "00E6" "00F3" "00F2" "006F" "006F00F9" "006F00F8" "006F00FB" "006F00F5" "006F00EF" "006F00E2" "006F00E1" "006F00E0" "006F00E5" "006F00E3" "006F00E4" "00F4" "00F400F9" "00F400F8" "00F400FB" "00F400F5" "00F400EF" "0075" "007500F9" "007500F8" "007500FB" "007500F5" "007500EF" "00F6" "00F600F9" "00F600F8" "00F600FB" "00F600F5" "00F600EF" "0079" "007900F9" "007900F8" "007900FB" "007900F5" "00EE" "00F1" "0062" "0063" "0064" "0067" "0068" "006B" "006C" "006D" "006E" "0070" "0071" "0072" "0073" "0074" "0076" "0078" "0079" "0066" "006A" "0077" "007A" "0041" "004100D9" "004100D8" "004100DB" "004100D5" "004100CF" "004100CA" "004100C9" "004100C8" "004100DA" "004100DC" "004100CB" "004100C2" "004100C1" "004100C0" "004100C5" "004100C3" "004100C4" "0045" "004500D9" "004500D8" "004500DB" "004500D5" "004500CF" "004500C2" "004500C1" "004500C0" "004500C5" "004500C3" "004500C4" "0049" "00CD" "00CC" "00C6" "00D3" "00D2" "004F" "004F00D9" "004F00D8" "004F00DB" "004F00D5" "004F00CF" "004F00C2" "004F00C1" "004F00C0" "004F00C5" "004F00C3" "004F00C4" "00D4" "00D400D9" "00D400D8" "00D400DB" "00D400D5" "00D400CF" "0055" "005500D9" "005500D8" "005500DB" "005500D5" "005500CF" "00D6" "00D600D9" "00D600D8" "00D600DB" "00D600D5" "00D600CF" "0059" "005900D9" "005900D8" "005900DB" "005900D5" "00CE" "00D1" "0042" "0043" "0044" "0047" "0048" "004B" "004C" "004D" "004E" "0050" "0051" "0052" "0053" "0054" "0056" "0058" "0059" "0046" "004A" "0057" "005A"))
			(list "ABC" "TCVN3 (ABC)"	1 (list "0061" "00B8" "00B5" "00B6" "00B7" "00B9" "00A8" "00BE" "00BB" "00BC" "00BD" "00C6" "00A9" "00CA" "00C7" "00C8" "00C9" "00CB" "0065" "00D0" "00CC" "00CE" "00CF" "00D1" "00AA" "00D5" "00D2" "00D3" "00D4" "00D6" "0069" "00DD" "00D7" "00D8" "00DC" "00DE" "006F" "00E3" "00DF" "00E1" "00E2" "00E4" "00AB" "00E8" "00E5" "00E6" "00E7" "00E9" "00AC" "00ED" "00EA" "00EB" "00EC" "00EE" "0075" "00F3" "00EF" "00F1" "00F2" "00F4" "00AD" "00F8" "00F5" "00F6" "00F7" "00F9" "0079" "00FD" "00FA" "00FB" "00FC" "00FE" "00AE" "0062" "0063" "0064" "0067" "0068" "006B" "006C" "006D" "006E" "0070" "0071" "0072" "0073" "0074" "0076" "0078" "0079" "0066" "006A" "0077" "007A" "0041" "00B8" "00B5" "00B6" "00B7" "00B9" "00A1" "00BE" "00BB" "00BC" "00BD" "00C6" "00A2" "00CA" "00C7" "00C8" "00C9" "00CB" "0045" "00D0" "00CC" "00CE" "00CF" "00D1" "00A3" "00D5" "00D2" "00D3" "00D4" "00D6" "0049" "00DD" "00D7" "00D8" "00DC" "00DE" "004F" "00E3" "00DF" "00E1" "00E2" "00E4" "00A4" "00E8" "00E5" "00E6" "00E7" "00E9" "00A5" "00ED" "00EA" "00EB" "00EC" "00EE" "0055" "00F3" "00EF" "00F1" "00F2" "00F4" "00A6" "00F8" "00F5" "00F6" "00F7" "00F9" "0059" "00FD" "00FA" "00FB" "00FC" "00FE" "00A7" "0042" "0043" "0044" "0047" "0048" "004B" "004C" "004D" "004E" "0050" "0051" "0052" "0053" "0054" "0056" "0058" "0059" "0046" "004A" "0057" "005A"))
		)
	)

	(setq ListDataCodeStart
		(list
			nil
			(list 73)
			(list 74)
			(list 74 77)
			(list 75)
			(list 76)
			(list 76 77)
			(list 76 30)
			(list 77)
			(list 78)
			(list 78 77)
			(list 79)
			(list 80)
			(list 81)
			(list 81 76)
			(list 81 76 77)
			(list 81 77)
			(list 82)
			(list 82 77)
			(list 83 54)
			(list 84)
			(list 85)
			(list 86)
			(list 86 77)
			(list 86 84)
			(list 87)
			(list 88)
			(list 72)
		)
	)

	(setq ListDataCodeMid
		(list 
			(list 0)
			(list 0 74)
			(list 0 74 77)
			(list 0 30)
			(list 0 80)
			(list 0 81)
			(list 0 81 76)
			(list 0 81 77)
			(list 0 36)
			(list 0 82)
			(list 0 86)
			(list 0 54)
			(list 0 66)
			(list 1)
			(list 1 74)
			(list 1 74 77)
			(list 1 30)
			(list 1 80)
			(list 1 81)
			(list 1 81 76)
			(list 1 81 77)
			(list 1 36)
			(list 1 82)
			(list 1 86)
			(list 1 54)
			(list 1 66)
			(list 2)
			(list 2 74)
			(list 2 74 77)
			(list 2 30)
			(list 2 80)
			(list 2 81)
			(list 2 81 76)
			(list 2 81 77)
			(list 2 36)
			(list 2 82)
			(list 2 86)
			(list 2 54)
			(list 2 66)
			(list 3)
			(list 3 74)
			(list 3 74 77)
			(list 3 30)
			(list 3 80)
			(list 3 81)
			(list 3 81 76)
			(list 3 81 77)
			(list 3 36)
			(list 3 82)
			(list 3 86)
			(list 3 54)
			(list 3 66)
			(list 4)
			(list 4 74)
			(list 4 74 77)
			(list 4 30)
			(list 4 80)
			(list 4 81)
			(list 4 81 76)
			(list 4 81 77)
			(list 4 36)
			(list 4 82)
			(list 4 86)
			(list 4 54)
			(list 4 66)
			(list 5)
			(list 5 74)
			(list 5 74 77)
			(list 5 30)
			(list 5 80)
			(list 5 81)
			(list 5 81 76)
			(list 5 81 77)
			(list 5 36)
			(list 5 82)
			(list 5 86)
			(list 5 54)
			(list 5 66)
			(list 36 0)
			(list 36 0 74)
			(list 36 0 74 77)
			(list 36 0 30)
			(list 36 0 80)
			(list 36 0 81)
			(list 36 0 81 76)
			(list 36 0 81 77)
			(list 36 0 36)
			(list 36 0 82)
			(list 36 0 86)
			(list 36 0 66)
			(list 36 1)
			(list 36 1 74)
			(list 36 1 74 77)
			(list 36 1 30)
			(list 36 1 80)
			(list 36 1 81)
			(list 36 1 81 76)
			(list 36 1 81 77)
			(list 36 1 36)
			(list 36 1 82)
			(list 36 1 86)
			(list 36 1 66)
			(list 36 2)
			(list 36 2 74)
			(list 36 2 74 77)
			(list 36 2 30)
			(list 36 2 80)
			(list 36 2 81)
			(list 36 2 81 76)
			(list 36 2 81 77)
			(list 36 2 36)
			(list 36 2 82)
			(list 36 2 86)
			(list 36 2 66)
			(list 36 3)
			(list 36 3 74)
			(list 36 3 74 77)
			(list 36 3 30)
			(list 36 3 80)
			(list 36 3 81)
			(list 36 3 81 76)
			(list 36 3 81 77)
			(list 36 3 36)
			(list 36 3 82)
			(list 36 3 86)
			(list 36 3 66)
			(list 36 4)
			(list 36 4 74)
			(list 36 4 74 77)
			(list 36 4 30)
			(list 36 4 80)
			(list 36 4 81)
			(list 36 4 81 76)
			(list 36 4 81 77)
			(list 36 4 36)
			(list 36 4 82)
			(list 36 4 86)
			(list 36 4 66)
			(list 36 5)
			(list 36 5 74)
			(list 36 5 74 77)
			(list 36 5 30)
			(list 36 5 80)
			(list 36 5 81)
			(list 36 5 81 76)
			(list 36 5 81 77)
			(list 36 5 36)
			(list 36 5 82)
			(list 36 5 86)
			(list 36 5 66)
			(list 37 0)
			(list 37 0 74)
			(list 37 0 74 77)
			(list 37 0 30)
			(list 37 0 80)
			(list 37 0 81)
			(list 37 0 81 76)
			(list 37 0 81 77)
			(list 37 0 36)
			(list 37 0 82)
			(list 37 0 86)
			(list 37 0 66)
			(list 38 0)
			(list 38 0 74)
			(list 38 0 74 77)
			(list 38 0 30)
			(list 38 0 80)
			(list 38 0 81)
			(list 38 0 81 76)
			(list 38 0 81 77)
			(list 38 0 36)
			(list 38 0 82)
			(list 38 0 86)
			(list 38 0 66)
			(list 39 0)
			(list 39 0 74)
			(list 39 0 74 77)
			(list 39 0 30)
			(list 39 0 80)
			(list 39 0 81)
			(list 39 0 81 76)
			(list 39 0 81 77)
			(list 39 0 36)
			(list 39 0 82)
			(list 39 0 86)
			(list 39 0 66)
			(list 40 0)
			(list 40 0 74)
			(list 40 0 74 77)
			(list 40 0 30)
			(list 40 0 80)
			(list 40 0 81)
			(list 40 0 81 76)
			(list 40 0 81 77)
			(list 40 0 36)
			(list 40 0 82)
			(list 40 0 86)
			(list 40 0 66)
			(list 41 0)
			(list 41 0 74)
			(list 41 0 74 77)
			(list 41 0 30)
			(list 41 0 80)
			(list 41 0 81)
			(list 41 0 81 76)
			(list 41 0 81 77)
			(list 41 0 36)
			(list 41 0 82)
			(list 41 0 86)
			(list 41 0 66)
			(list 6 74)
			(list 6 80)
			(list 6 81)
			(list 6 81 76)
			(list 6 82)
			(list 6 86)
			(list 7 74)
			(list 7 80)
			(list 7 81)
			(list 7 81 76)
			(list 7 82)
			(list 7 86)
			(list 8 74)
			(list 8 80)
			(list 8 81)
			(list 8 81 76)
			(list 8 82)
			(list 8 86)
			(list 9 74)
			(list 9 80)
			(list 9 81)
			(list 9 81 76)
			(list 9 82)
			(list 9 86)
			(list 10 74)
			(list 10 80)
			(list 10 81)
			(list 10 81 76)
			(list 10 82)
			(list 10 86)
			(list 11 74)
			(list 11 80)
			(list 11 81)
			(list 11 81 76)
			(list 11 82)
			(list 11 86)
			(list 36 6 74)
			(list 36 6 80)
			(list 36 6 81)
			(list 36 6 81 76)
			(list 36 6 82)
			(list 36 6 86)
			(list 36 7 74)
			(list 36 7 80)
			(list 36 7 81)
			(list 36 7 81 76)
			(list 36 7 82)
			(list 36 7 86)
			(list 36 8 74)
			(list 36 8 80)
			(list 36 8 81)
			(list 36 8 81 76)
			(list 36 8 82)
			(list 36 8 86)
			(list 36 9 74)
			(list 36 9 80)
			(list 36 9 81)
			(list 36 9 81 76)
			(list 36 9 82)
			(list 36 9 86)
			(list 36 10 74)
			(list 36 10 80)
			(list 36 10 81)
			(list 36 10 81 76)
			(list 36 10 82)
			(list 36 10 86)
			(list 36 11 74)
			(list 36 11 80)
			(list 36 11 81)
			(list 36 11 81 76)
			(list 36 11 82)
			(list 36 11 86)
			(list 12 74)
			(list 12 80)
			(list 12 81)
			(list 12 81 76)
			(list 12 82)
			(list 12 86)
			(list 12 54)
			(list 12 66)
			(list 13 74)
			(list 13 80)
			(list 13 81)
			(list 13 81 76)
			(list 13 82)
			(list 13 86)
			(list 13 54)
			(list 13 66)
			(list 14 74)
			(list 14 80)
			(list 14 81)
			(list 14 81 76)
			(list 14 82)
			(list 14 86)
			(list 14 54)
			(list 14 66)
			(list 15 74)
			(list 15 80)
			(list 15 81)
			(list 15 81 76)
			(list 15 82)
			(list 15 86)
			(list 15 54)
			(list 15 66)
			(list 16 74)
			(list 16 80)
			(list 16 81)
			(list 16 81 76)
			(list 16 82)
			(list 16 86)
			(list 16 54)
			(list 16 66)
			(list 17 74)
			(list 17 80)
			(list 17 81)
			(list 17 81 76)
			(list 17 82)
			(list 17 86)
			(list 17 54)
			(list 17 66)
			(list 54 12 74)
			(list 54 12 81)
			(list 54 12 81 76)
			(list 54 12 86)
			(list 54 12 66)
			(list 54 13 74)
			(list 54 13 81)
			(list 54 13 81 76)
			(list 54 13 86)
			(list 54 13 66)
			(list 54 14 74)
			(list 54 14 81)
			(list 54 14 81 76)
			(list 54 14 86)
			(list 54 14 66)
			(list 54 15 74)
			(list 54 15 81)
			(list 54 15 81 76)
			(list 54 15 86)
			(list 54 15 66)
			(list 54 16 74)
			(list 54 16 81)
			(list 54 16 81 76)
			(list 54 16 86)
			(list 54 16 66)
			(list 54 17 74)
			(list 54 17 81)
			(list 54 17 81 76)
			(list 54 17 86)
			(list 54 17 66)
			(list 18)
			(list 18 74)
			(list 18 80)
			(list 18 81)
			(list 18 81 76)
			(list 18 36)
			(list 18 82)
			(list 18 86)
			(list 19)
			(list 19 74)
			(list 19 80)
			(list 19 81)
			(list 19 81 76)
			(list 19 36)
			(list 19 82)
			(list 19 86)
			(list 20)
			(list 20 74)
			(list 20 80)
			(list 20 81)
			(list 20 81 76)
			(list 20 36)
			(list 20 82)
			(list 20 86)
			(list 21)
			(list 21 74)
			(list 21 80)
			(list 21 81)
			(list 21 81 76)
			(list 21 36)
			(list 21 82)
			(list 21 86)
			(list 22)
			(list 22 74)
			(list 22 80)
			(list 22 81)
			(list 22 81 76)
			(list 22 36)
			(list 22 82)
			(list 22 86)
			(list 23)
			(list 23 74)
			(list 23 80)
			(list 23 81)
			(list 23 81 76)
			(list 23 36)
			(list 23 82)
			(list 23 86)
			(list 36 18)
			(list 36 18 81)
			(list 36 18 36)
			(list 36 18 82)
			(list 36 18 86)
			(list 36 19)
			(list 36 19 81)
			(list 36 19 36)
			(list 36 19 82)
			(list 36 19 86)
			(list 36 20)
			(list 36 20 81)
			(list 36 20 36)
			(list 36 20 82)
			(list 36 20 86)
			(list 36 21)
			(list 36 21 81)
			(list 36 21 36)
			(list 36 21 82)
			(list 36 21 86)
			(list 36 22)
			(list 36 22 81)
			(list 36 22 36)
			(list 36 22 82)
			(list 36 22 86)
			(list 36 23)
			(list 36 23 81)
			(list 36 23 36)
			(list 36 23 82)
			(list 36 23 86)
			(list 37 18)
			(list 37 18 81)
			(list 37 18 36)
			(list 37 18 82)
			(list 37 18 86)
			(list 38 18)
			(list 38 18 81)
			(list 38 18 36)
			(list 38 18 82)
			(list 38 18 86)
			(list 39 18)
			(list 39 18 81)
			(list 39 18 36)
			(list 39 18 82)
			(list 39 18 86)
			(list 40 18)
			(list 40 18 81)
			(list 40 18 36)
			(list 40 18 82)
			(list 40 18 86)
			(list 41 18)
			(list 41 18 81)
			(list 41 18 36)
			(list 41 18 82)
			(list 41 18 86)
			(list 24)
			(list 24 74 77)
			(list 24 80)
			(list 24 81)
			(list 24 81 77)
			(list 24 82)
			(list 24 86)
			(list 24 54)
			(list 25)
			(list 25 74 77)
			(list 25 80)
			(list 25 81)
			(list 25 81 77)
			(list 25 82)
			(list 25 86)
			(list 25 54)
			(list 26)
			(list 26 74 77)
			(list 26 80)
			(list 26 81)
			(list 26 81 77)
			(list 26 82)
			(list 26 86)
			(list 26 54)
			(list 27)
			(list 27 74 77)
			(list 27 80)
			(list 27 81)
			(list 27 81 77)
			(list 27 82)
			(list 27 86)
			(list 27 54)
			(list 28)
			(list 28 74 77)
			(list 28 80)
			(list 28 81)
			(list 28 81 77)
			(list 28 82)
			(list 28 86)
			(list 28 54)
			(list 29)
			(list 29 74 77)
			(list 29 80)
			(list 29 81)
			(list 29 81 77)
			(list 29 82)
			(list 29 86)
			(list 29 54)
			(list 54 24)
			(list 54 24 74 77)
			(list 54 24 81)
			(list 54 24 81 77)
			(list 54 24 86)
			(list 54 24 54)
			(list 54 25)
			(list 54 25 74 77)
			(list 54 25 81)
			(list 54 25 81 77)
			(list 54 25 86)
			(list 54 25 54)
			(list 54 26)
			(list 54 26 74 77)
			(list 54 26 81)
			(list 54 26 81 77)
			(list 54 26 86)
			(list 54 26 54)
			(list 54 27)
			(list 54 27 74 77)
			(list 54 27 81)
			(list 54 27 81 77)
			(list 54 27 86)
			(list 54 27 54)
			(list 54 28)
			(list 54 28 74 77)
			(list 54 28 81)
			(list 54 28 81 77)
			(list 54 28 86)
			(list 54 28 54)
			(list 54 29)
			(list 54 29 74 77)
			(list 54 29 81)
			(list 54 29 81 77)
			(list 54 29 86)
			(list 54 29 54)
			(list 30)
			(list 30 74 77)
			(list 30 80)
			(list 30 81)
			(list 30 81 77)
			(list 30 82)
			(list 30 86)
			(list 30 54)
			(list 31)
			(list 31 74 77)
			(list 31 80)
			(list 31 81)
			(list 31 81 77)
			(list 31 82)
			(list 31 86)
			(list 31 54)
			(list 32)
			(list 32 74 77)
			(list 32 80)
			(list 32 81)
			(list 32 81 77)
			(list 32 82)
			(list 32 86)
			(list 32 54)
			(list 33)
			(list 33 74 77)
			(list 33 80)
			(list 33 81)
			(list 33 81 77)
			(list 33 82)
			(list 33 86)
			(list 33 54)
			(list 34)
			(list 34 74 77)
			(list 34 80)
			(list 34 81)
			(list 34 81 77)
			(list 34 82)
			(list 34 86)
			(list 34 54)
			(list 35)
			(list 35 74 77)
			(list 35 80)
			(list 35 81)
			(list 35 81 77)
			(list 35 82)
			(list 35 86)
			(list 35 54)
			(list 66)
			(list 67)
			(list 68)
			(list 69)
			(list 70)
			(list 71)
			(list 54 66)
			(list 54 66 74 77)
			(list 54 66 81)
			(list 54 66 81 77)
			(list 54 66 82)
			(list 54 66 86)
			(list 54 66 54)
			(list 54 67)
			(list 54 67 74 77)
			(list 54 67 81)
			(list 54 67 81 77)
			(list 54 67 82)
			(list 54 67 86)
			(list 54 67 54)
			(list 54 68)
			(list 54 68 74 77)
			(list 54 68 81)
			(list 54 68 81 77)
			(list 54 68 82)
			(list 54 68 86)
			(list 54 68 54)
			(list 54 69)
			(list 54 69 74 77)
			(list 54 69 81)
			(list 54 69 81 77)
			(list 54 69 82)
			(list 54 69 86)
			(list 54 69 54)
			(list 54 70)
			(list 54 70 74 77)
			(list 54 70 81)
			(list 54 70 81 77)
			(list 54 70 82)
			(list 54 70 86)
			(list 54 70 54)
			(list 54 71)
			(list 54 71 74 77)
			(list 54 71 81)
			(list 54 71 81 77)
			(list 54 71 82)
			(list 54 71 86)
			(list 54 71 54)
			(list 55 66)
			(list 55 66 74 77)
			(list 55 66 81)
			(list 55 66 81 77)
			(list 55 66 82)
			(list 55 66 86)
			(list 55 66 54)
			(list 56 66)
			(list 56 66 74 77)
			(list 56 66 81)
			(list 56 66 81 77)
			(list 56 66 82)
			(list 56 66 86)
			(list 56 66 54)
			(list 57 66)
			(list 57 66 74 77)
			(list 57 66 81)
			(list 57 66 81 77)
			(list 57 66 82)
			(list 57 66 86)
			(list 57 66 54)
			(list 58 66)
			(list 58 66 74 77)
			(list 58 66 81)
			(list 58 66 81 77)
			(list 58 66 82)
			(list 58 66 86)
			(list 58 66 54)
			(list 59 66)
			(list 59 66 74 77)
			(list 59 66 81)
			(list 59 66 81 77)
			(list 59 66 82)
			(list 59 66 86)
			(list 59 66 54)
			(list 36)
			(list 36 74)
			(list 36 30)
			(list 36 80)
			(list 36 81)
			(list 36 81 76)
			(list 36 82)
			(list 36 86)
			(list 37)
			(list 37 74)
			(list 37 30)
			(list 37 80)
			(list 37 81)
			(list 37 81 76)
			(list 37 82)
			(list 37 86)
			(list 38)
			(list 38 74)
			(list 38 30)
			(list 38 80)
			(list 38 81)
			(list 38 81 76)
			(list 38 82)
			(list 38 86)
			(list 39)
			(list 39 74)
			(list 39 30)
			(list 39 80)
			(list 39 81)
			(list 39 81 76)
			(list 39 82)
			(list 39 86)
			(list 40)
			(list 40 74)
			(list 40 30)
			(list 40 80)
			(list 40 81)
			(list 40 81 76)
			(list 40 82)
			(list 40 86)
			(list 41)
			(list 41 74)
			(list 41 30)
			(list 41 80)
			(list 41 81)
			(list 41 81 76)
			(list 41 82)
			(list 41 86)
			(list 36 36 74)
			(list 36 36 81 76)
			(list 36 37 74)
			(list 36 37 81 76)
			(list 36 38 74)
			(list 36 38 81 76)
			(list 36 39 74)
			(list 36 39 81 76)
			(list 36 40 74)
			(list 36 40 81 76)
			(list 36 41 74)
			(list 36 41 81 76)
			(list 37 36 74)
			(list 37 36 81 76)
			(list 38 36 74)
			(list 38 36 81 76)
			(list 39 36 74)
			(list 39 36 81 76)
			(list 40 36 74)
			(list 40 36 81 76)
			(list 41 36 74)
			(list 41 36 81 76)
			(list 42)
			(list 42 74)
			(list 42 30)
			(list 42 80)
			(list 42 81)
			(list 42 81 76)
			(list 42 82)
			(list 42 86)
			(list 43)
			(list 43 74)
			(list 43 30)
			(list 43 80)
			(list 43 81)
			(list 43 81 76)
			(list 43 82)
			(list 43 86)
			(list 44)
			(list 44 74)
			(list 44 30)
			(list 44 80)
			(list 44 81)
			(list 44 81 76)
			(list 44 82)
			(list 44 86)
			(list 45)
			(list 45 74)
			(list 45 30)
			(list 45 80)
			(list 45 81)
			(list 45 81 76)
			(list 45 82)
			(list 45 86)
			(list 46)
			(list 46 74)
			(list 46 30)
			(list 46 80)
			(list 46 81)
			(list 46 81 76)
			(list 46 82)
			(list 46 86)
			(list 47)
			(list 47 74)
			(list 47 30)
			(list 47 80)
			(list 47 81)
			(list 47 81 76)
			(list 47 82)
			(list 47 86)
			(list 48)
			(list 48 30)
			(list 48 80)
			(list 48 81)
			(list 48 82)
			(list 48 86)
			(list 49)
			(list 49 30)
			(list 49 80)
			(list 49 81)
			(list 49 82)
			(list 49 86)
			(list 50)
			(list 50 30)
			(list 50 80)
			(list 50 81)
			(list 50 82)
			(list 50 86)
			(list 51)
			(list 51 30)
			(list 51 80)
			(list 51 81)
			(list 51 82)
			(list 51 86)
			(list 52)
			(list 52 30)
			(list 52 80)
			(list 52 81)
			(list 52 82)
			(list 52 86)
			(list 53)
			(list 53 30)
			(list 53 80)
			(list 53 81)
			(list 53 82)
			(list 53 86)
			(list 54 48)
			(list 54 49)
			(list 54 50)
			(list 54 51)
			(list 54 52)
			(list 54 53)
			(list 54)
			(list 54 74)
			(list 54 30)
			(list 54 80)
			(list 54 81)
			(list 54 81 76)
			(list 54 82)
			(list 54 86)
			(list 55)
			(list 55 74)
			(list 55 30)
			(list 55 80)
			(list 55 81)
			(list 55 81 76)
			(list 55 82)
			(list 55 86)
			(list 56)
			(list 56 74)
			(list 56 30)
			(list 56 80)
			(list 56 81)
			(list 56 81 76)
			(list 56 82)
			(list 56 86)
			(list 57)
			(list 57 74)
			(list 57 30)
			(list 57 80)
			(list 57 81)
			(list 57 81 76)
			(list 57 82)
			(list 57 86)
			(list 58)
			(list 58 74)
			(list 58 30)
			(list 58 80)
			(list 58 81)
			(list 58 81 76)
			(list 58 82)
			(list 58 86)
			(list 59)
			(list 59 74)
			(list 59 30)
			(list 59 80)
			(list 59 81)
			(list 59 81 76)
			(list 59 82)
			(list 59 86)
			(list 60)
			(list 60 74)
			(list 60 30)
			(list 60 80)
			(list 60 81)
			(list 60 81 76)
			(list 60 86)
			(list 60 54)
			(list 61)
			(list 61 74)
			(list 61 30)
			(list 61 80)
			(list 61 81)
			(list 61 81 76)
			(list 61 86)
			(list 61 54)
			(list 62)
			(list 62 74)
			(list 62 30)
			(list 62 80)
			(list 62 81)
			(list 62 81 76)
			(list 62 86)
			(list 62 54)
			(list 63)
			(list 63 74)
			(list 63 30)
			(list 63 80)
			(list 63 81)
			(list 63 81 76)
			(list 63 86)
			(list 63 54)
			(list 64)
			(list 64 74)
			(list 64 30)
			(list 64 80)
			(list 64 81)
			(list 64 81 76)
			(list 64 86)
			(list 64 54)
			(list 65)
			(list 65 74)
			(list 65 30)
			(list 65 80)
			(list 65 81)
			(list 65 81 76)
			(list 65 86)
			(list 65 54)
			(list 30 0)
			(list 31 0)
			(list 32 0)
			(list 33 0)
			(list 34 0)
			(list 35 0)
			(list 30 1)
			(list 30 2)
			(list 30 3)
			(list 30 4)
			(list 30 5)
			(list 54 66 0)
			(list 54 67 0)
			(list 54 68 0)
			(list 54 69 0)
			(list 54 70 0)
			(list 54 71 0)
			(list 30 24 74)
			(list 30 24 80)
			(list 30 24 81)
			(list 30 24 81 76)
			(list 30 24 82)
			(list 30 24 86)
			(list 30 24 54)
			(list 30 25 74)
			(list 30 25 80)
			(list 30 25 81)
			(list 30 25 81 76)
			(list 30 25 82)
			(list 30 25 86)
			(list 30 25 54)
			(list 30 26 74)
			(list 30 26 80)
			(list 30 26 81)
			(list 30 26 81 76)
			(list 30 26 82)
			(list 30 26 86)
			(list 30 26 54)
			(list 30 27 74)
			(list 30 27 80)
			(list 30 27 81)
			(list 30 27 81 76)
			(list 30 27 82)
			(list 30 27 86)
			(list 30 27 54)
			(list 30 28 74)
			(list 30 28 80)
			(list 30 28 81)
			(list 30 28 81 76)
			(list 30 28 82)
			(list 30 28 86)
			(list 30 28 54)
			(list 30 29 74)
			(list 30 29 80)
			(list 30 29 81)
			(list 30 29 81 76)
			(list 30 29 82)
			(list 30 29 86)
			(list 30 29 54)
			(list 66 24 80)
			(list 66 24 81)
			(list 66 24 81 76)
			(list 66 24 86)
			(list 66 24 54)
			(list 66 25 80)
			(list 66 25 81)
			(list 66 25 81 76)
			(list 66 25 86)
			(list 66 25 54)
			(list 66 26 80)
			(list 66 26 81)
			(list 66 26 81 76)
			(list 66 26 86)
			(list 66 26 54)
			(list 66 27 80)
			(list 66 27 81)
			(list 66 27 81 76)
			(list 66 27 86)
			(list 66 27 54)
			(list 66 28 80)
			(list 66 28 81)
			(list 66 28 81 76)
			(list 66 28 86)
			(list 66 28 54)
			(list 66 29 80)
			(list 66 29 81)
			(list 66 29 81 76)
			(list 66 29 86)
			(list 66 29 54)
			(list 54 66 24 81)
			(list 54 66 24 86)
			(list 54 66 25 81)
			(list 54 66 25 86)
			(list 54 66 26 81)
			(list 54 66 26 86)
			(list 54 66 27 81)
			(list 54 66 27 86)
			(list 54 66 28 81)
			(list 54 66 28 86)
			(list 54 66 29 81)
			(list 54 66 29 86)
			(list 54 0)
			(list 55 0)
			(list 56 0)
			(list 57 0)
			(list 58 0)
			(list 59 0)
			(list 54 42 74)
			(list 54 42 30)
			(list 54 42 80)
			(list 54 42 81)
			(list 54 42 81 76)
			(list 54 42 86)
			(list 54 43 74)
			(list 54 43 30)
			(list 54 43 80)
			(list 54 43 81)
			(list 54 43 81 76)
			(list 54 43 86)
			(list 54 44 74)
			(list 54 44 30)
			(list 54 44 80)
			(list 54 44 81)
			(list 54 44 81 76)
			(list 54 44 86)
			(list 54 45 74)
			(list 54 45 30)
			(list 54 45 80)
			(list 54 45 81)
			(list 54 45 81 76)
			(list 54 45 86)
			(list 54 46 74)
			(list 54 46 30)
			(list 54 46 80)
			(list 54 46 81)
			(list 54 46 81 76)
			(list 54 46 86)
			(list 54 47 74)
			(list 54 47 30)
			(list 54 47 80)
			(list 54 47 81)
			(list 54 47 81 76)
			(list 54 47 86)
			(list 60 0)
			(list 61 0)
			(list 62 0)
			(list 63 0)
			(list 64 0)
			(list 65 0)
			(list 60 48 74)
			(list 60 48 30)
			(list 60 48 80)
			(list 60 48 81)
			(list 60 48 81 76)
			(list 60 48 82)
			(list 60 48 86)
			(list 60 48 54)
			(list 60 49 74)
			(list 60 49 30)
			(list 60 49 80)
			(list 60 49 81)
			(list 60 49 81 76)
			(list 60 49 82)
			(list 60 49 86)
			(list 60 49 54)
			(list 60 50 74)
			(list 60 50 30)
			(list 60 50 80)
			(list 60 50 81)
			(list 60 50 81 76)
			(list 60 50 82)
			(list 60 50 86)
			(list 60 50 54)
			(list 60 51 74)
			(list 60 51 30)
			(list 60 51 80)
			(list 60 51 81)
			(list 60 51 81 76)
			(list 60 51 82)
			(list 60 51 86)
			(list 60 51 54)
			(list 60 52 74)
			(list 60 52 30)
			(list 60 52 80)
			(list 60 52 81)
			(list 60 52 81 76)
			(list 60 52 82)
			(list 60 52 86)
			(list 60 52 54)
			(list 60 53 74)
			(list 60 53 30)
			(list 60 53 80)
			(list 60 53 81)
			(list 60 53 81 76)
			(list 60 53 82)
			(list 60 53 86)
			(list 60 53 54)
		)
	)

	(setq ListDataCodeEnd
		(list 
			nil 
			(list 74)
			(list 74 77)
			(list 30)
			(list 80)
			(list 81)
			(list 81 76)
			(list 81 77)
			(list 36)
			(list 82)
			(list 86)
			(list 54)
			(list 66)
		)
	)

	(setq ListDataTypeCode (mapcar '(lambda (x) (cons (nth 0 x) (nth 1 x))) ListDataCode))
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_VLA_GET_TEXTSTRING ( VlaObject / 
	DataEname
	NumCode
	TextString
	TextStringTemp
	TypeObject)

	(setq DataEname (entget (vlax-vla-object->ename VlaObject)))
	(setq TypeObject (vla-get-objectname VlaObject))
	(if (= TypeObject "AcDbMLeader")
		(progn
			(setq DataEname (vl-remove (cons 304 "LEADER_LINE{") DataEname))
			(setq TextString (cdr (assoc 304 DataEname)))
		)
		(progn
			(setq TextString "")
			(foreach Temp DataEname
				(setq NumCode (car Temp))
				(setq TextStringTemp (cdr Temp))
				(if
					(and
						(or
							(= NumCode 1)
							(= NumCode 3)
						)
						(= (type TextStringTemp) 'STR)
					)
					(setq TextString (strcat TextString TextStringTemp))
				)
			)
		)
	)
	TextString
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CONVERT_SELECTIONSET_TO_LISTVLAOBJECT ( SelectionSet /
	VlaObject
	ListVlaObject
	Num)

	(if SelectionSet
		(progn
			(setq Num 0)
			(repeat (sslength SelectionSet)
				(setq VlaObject (vlax-ename->vla-object (ssname SelectionSet Num)))
				(setq ListVlaObject (cons VlaObject ListVlaObject))
				(setq Num (+ Num 1))
			)
		)
	)
	ListVlaObject
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_GET_EFFECTIVENAME_BLOCK ( VlaObject / NameBlock)
	(vl-catch-all-apply (function (lambda ( / )
		(setq NameBlock (cdr (assoc 2 (entget (cdr (assoc 340 (entget (vlax-vla-object->ename (vla-item (vla-item (vla-GetExtensionDictionary VlaObject) "AcDbBlockRepresentation") "AcDbRepData")))))))))
	)))
	(if (not NameBlock)
		(setq NameBlock (cdr (assoc 2 (entget (vlax-vla-object->ename VlaObject)))))
	)
	NameBlock
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_VLA_GET_NAME ( VlaStyle /
	NameStyle
	NameStyleTemp
	TypeObject
	DataEnameTemp)

	(vl-catch-all-apply (function (lambda ( / )
		(setq NameStyle (vla-get-name VlaStyle))
	)))
	(if
		(or
			(not NameStyle)
			(and
				NameStyle
				(vl-string-search "?" NameStyle)
			)
		)
		(progn
			(setq TypeObject (vla-get-ObjectName VlaStyle))
			(if
				(or
					(= TypeObject "AcDbBlockReference")
					(= TypeObject "AcDbBlockTableRecord")
					(= TypeObject "AcDbDimStyleTableRecord")
					(= TypeObject "AcDbLayerTableRecord")
					(= TypeObject "AcDbLinetypeTableRecord")
					(= TypeObject "AcDbTextStyleTableRecord")
					(= TypeObject "AcDbUCSTableRecord")
					(= TypeObject "AcDbMlineStyle")
				)
				(setq NameStyle (cdr (assoc 2 (entget (vlax-vla-object->ename VlaStyle)))))
			)
			(if
				(or
					(= TypeObject "AcDbLayout")
					(= TypeObject "AcDbMaterial")
					(= TypeObject "AcDbMLeaderStyle")
					(= TypeObject "AcDbPlotSettings")
					(= TypeObject "AcDbTableStyle")
					(= TypeObject "AcDbVisualStyle")
					(= TypeObject "AcDbDetailViewStyle")
					(= TypeObject "AcDbSectionViewStyle")
					(= TypeObject "AcDbPlaceHolder")
					(= TypeObject "AcDbXrecord")
					(= TypeObject "AcDbDictionary")
					(= TypeObject "AcDbRasterImageDef")
					(= TypeObject "AcDbDwfDefinition")
					(= TypeObject "AcDbPdfDefinition")
					(= TypeObject "AcDbDgnDefinition")
					(= TypeObject "AcDbPointCloudDefEx")
					(= TypeObject "AcDbNavisworksModelDef")
				)
				(progn
					(setq NameStyle (cdr (assoc 3 (member (cons 350 (vlax-vla-object->ename VlaStyle)) (reverse (entget (vlax-vla-object->ename (vla-ObjectIdToObject (vla-get-document VlaStyle) (vla-get-ownerid VlaStyle)))))))))
					(if (not NameStyle)
						(setq NameStyle (cdr (assoc 3 (member (cons 360 (vlax-vla-object->ename VlaStyle)) (reverse (entget (vlax-vla-object->ename (vla-ObjectIdToObject (vla-get-document VlaStyle) (vla-get-ownerid VlaStyle)))))))))
					)
				)
			)
			(if
				(or
					(= TypeObject "AcDbRasterImage")
					(= TypeObject "AcDbDwfReference")
					(= TypeObject "AcDbPdfReference")
					(= TypeObject "AcDbDgnReference")
					(= TypeObject "AcDbPointCloudEx")
					(= TypeObject "AcDbNavisworksModel")
				)
				(setq NameStyle (CTESTY_VLA_GET_NAME (vlax-ename->vla-object (cdr (assoc 340 (entget (vlax-vla-object->ename VlaStyle)))))))
			)
		)
	)
	(if (not NameStyle)
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameStyle (vla-get-name VlaStyle))
		)))
	)
	NameStyle
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_CREATE_LISTVLALAYERLOCK ( / VlaLayersGroup)
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
(defun CTESTY_RESTORE_LOCK_LAYER ( / )
	(foreach VlaLayerLock ListVlaLayerLock
		(vl-catch-all-error-p (vl-catch-all-apply 'vla-put-Lock (list VlaLayerLock :vlax-true)))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_SET_VARSYSTEM ( / )
	(foreach Temp ListVarSystem
		(vl-catch-all-apply (function (lambda ( / )
			(setq ListVarSystem (subst (append Temp (list (getvar (nth 0 Temp)))) Temp ListVarSystem))
			(setvar (nth 0 Temp) (nth 1 Temp))
		)))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun CTESTY_RESET_VARSYSTEM ( / )
	(foreach Temp ListVarSystem
		(vl-catch-all-apply (function (lambda ( / )
			(setvar (nth 0 Temp) (nth 2 Temp))
		)))
	)
)