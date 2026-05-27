(defun C:SSC ( / 
	ListDataSetting
	ListDataStyleCurrent
	ListVlaLayerLock
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

		(setq NameSoftware "Current Style")
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
				(setq StringUrl "https://script.google.com/macros/s/AKfycbz1n3v780vBayl68zGEGeEc0swT9HgO1Sg5c_bz4xK-tO9oUARczwj59oH4UCPcgify/exec?")
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
	;(LIC_REQUESTCODE)
	(setq LIC_REQUESTCODE Nil)

	(vl-load-com)
	(setq VlaDrawingCurrent (vla-get-activedocument (vlax-get-acad-object)))
	(vla-startundomark VlaDrawingCurrent)
	(SSC_CREATE_LISTVLALAYERLOCK)

	(SSC_READ_REGISTRY)
	(setq ListDataStyleCurrent (SSC_CREATE_LISTDATASTYLECURRENT))
	(SSC_SET_CURRENT_STYLE ListDataStyleCurrent)
	(SSC_WRITE_REGISTRY)

	(SSC_RESTORE_LOCK_LAYER)
	(vla-endundomark VlaDrawingCurrent)
	(princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun C:ASC ( /
    ListDataColor
	ListVlaLayerLock
	ListVlaObject
	NameBlock
	NameDimmensionStyle
	NameLayer
	NameLineWeight
	NameLineType
	NameMaterial
	NameMultiLeaderStyle
	NamePlotStyle
	NameTableStyle
	NameTextStyle
	NameTransparency
	SelectionSet
	StringColor
	TypeObject
;	TypeStyle
	VlaDimmensionStyle
	VlaDrawingCurrent
	VlaLayer
	VlaLineType
	VlaMaterial
	VlaTextStyle)

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

		(setq NameSoftware "Current Style")
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
				(setq StringUrl "https://script.google.com/macros/s/AKfycbz1n3v780vBayl68zGEGeEc0swT9HgO1Sg5c_bz4xK-tO9oUARczwj59oH4UCPcgify/exec?")
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
	;(LIC_REQUESTCODE)
	(setq LIC_REQUESTCODE Nil)

	(vl-load-com)
	(setq VlaDrawingCurrent (vla-get-activedocument (vlax-get-acad-object)))
	(vla-startundomark VlaDrawingCurrent)

	(vl-catch-all-apply (function (lambda ( / )
		(SSC_SELECT_TYPESTYLE)
		(setq SelectionSet (ssget))
		(setq ListVlaObject (SSC_CONVERT_SELECTIONSET_TO_LISTVLAOBJECT SelectionSet))
	)))

	(SSC_CREATE_LISTVLALAYERLOCK)
	(if (= TypeStyle "Annotation Scale")
		(progn
			(setq SelectionSet (ssadd))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(setq TypeObject (vla-get-objectname VlaObject))
					(if
						(and
							(or
								(= TypeObject "AcDb2LineAngularDimension")
								(= TypeObject "AcDb3PointAngularDimension")
								(= TypeObject "AcDbAlignedDimension")
								(= TypeObject "AcDbAttributeDefinition")
								(= TypeObject "AcDbArcDimension")
								(= TypeObject "AcDbBlockReference")
								(= TypeObject "AcDbDiametricDimension")
								(= TypeObject "AcDbLeader")
								(= TypeObject "AcDbFcf")
								(= TypeObject "AcDbHatch")
								(= TypeObject "AcDbMText")
								(= TypeObject "AcDbOrdinateDimension")
								(= TypeObject "AcDbRadialDimension")
								(= TypeObject "AcDbRadialDimensionLarge")
								(= TypeObject "AcDbRotatedDimension")
								(= TypeObject "AcDbText")
							)
							(SSC_GET_ANNOTATIVE VlaObject)
						)
						(setq SelectionSet (ssadd (vlax-vla-object->ename VlaObject) SelectionSet))
					)
				)))
			)
			(command "_.AIOBJECTSCALEADD" SelectionSet "")
		)
	)

	(if (= TypeStyle "Block")
		(progn
			(setq NameBlock (getvar "INSNAME"))
			(if (/= NameBlock "")
				(foreach VlaObject ListVlaObject
					(vl-catch-all-apply (function (lambda ( / )
						(setq TypeObject (vla-get-objectname VlaObject))
						(if (= TypeObject "AcDbBlockReference")
							(vla-put-name VlaObject NameBlock)
						)
					)))
				)
			)
		)
	)

	(if (= TypeStyle "Dimmension Style")
		(progn
			(setq VlaDimmensionStyle (vla-get-Activedimstyle VlaDrawingCurrent))
			(setq NameDimmensionStyle (SSC_VLA_GET_NAME VlaDimmensionStyle))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(setq TypeObject (vla-get-objectname VlaObject))
					(if
						(or
							(= TypeObject "AcDb2LineAngularDimension")
							(= TypeObject "AcDb3PointAngularDimension")
							(= TypeObject "AcDbAlignedDimension")
							(= TypeObject "AcDbArcDimension")
							(= TypeObject "AcDbDiametricDimension")
							(= TypeObject "AcDbLeader")
							(= TypeObject "AcDbFcf")
							(= TypeObject "AcDbOrdinateDimension")
							(= TypeObject "AcDbRadialDimension")
							(= TypeObject "AcDbRadialDimensionLarge")
							(= TypeObject "AcDbRotatedDimension")
						)
						(vla-put-stylename VlaObject NameDimmensionStyle)
					)
				)))
			)
		)
	)

	(if (= TypeStyle "Color")
		(progn
			(setq StringColor (getvar "CECOLOR"))
			(setq ListDataColor (SSC_STRINGCOLOR_TO_LISTDATACOLOR StringColor))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(SSC_SET_NAMECOLOR VlaObject ListDataColor)
				)))
			)
		)
	)

	(if (= TypeStyle "Layer")
		(progn
			(setq VlaLayer (vla-get-ActiveLayer VlaDrawingCurrent))
			(setq NameLayer (SSC_VLA_GET_NAME VlaLayer))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(vla-put-Layer VlaObject NameLayer)
				)))
			)
		)
	)

	(if (= TypeStyle "LineType")
		(progn
			(setq VlaLineType (vla-get-ActiveLinetype VlaDrawingCurrent))
			(setq NameLineType (SSC_VLA_GET_NAME VlaLineType))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(vla-put-Linetype VlaObject NameLineType)
				)))
			)
		)
	)

	(if (= TypeStyle "LineWeight")
		(progn
			(setq NameLineWeight (getvar "CELWEIGHT"))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(vla-put-LineWeight VlaObject NameLineWeight)
				)))
			)
		)
	)

	(if (= TypeStyle "Material")
		(progn
			(setq VlaMaterial (vla-get-ActiveMaterial VlaDrawingCurrent))
			(setq NameMaterial (SSC_VLA_GET_NAME VlaMaterial))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(vla-put-Material VlaObject NameMaterial)
				)))
			)
		)
	)

	(if (= TypeStyle "MultiLeader Style")
		(progn
			(setq NameMultiLeaderStyle (getvar "CMLEADERSTYLE"))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(setq TypeObject (vla-get-objectname VlaObject))
					(if (= TypeObject "AcDbMLeader")
						(vla-put-stylename VlaObject NameMultiLeaderStyle)
					)
				)))
			)
		)
	)

	(if (= TypeStyle "Multiline Style")
		(progn
			(setq NameMultilineStyle (getvar "CMLSTYLE"))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(setq TypeObject (vla-get-objectname VlaObject))
					(if (= TypeObject "AcDbMline")
						(SSC_VLA_PUT_STYLENAME_MILNE VlaObject NameMultilineStyle)
					)
				)))
			)
		)
	)

	(if
		(and
			(= TypeStyle "Plot Style")
			(= (getvar "PSTYLEMODE") 0)
		)
		(progn
			(setq NamePlotStyle (getvar "CPLOTSTYLE"))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(vla-put-PlotStyleName VlaObject NamePlotStyle)
				)))
			)
		)
	)

	(if (= TypeStyle "Table Style")
		(progn
			(setq NameTableStyle (getvar "CTABLESTYLE"))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(setq TypeObject (vla-get-objectname VlaObject))
					(if (= TypeObject "AcDbTable")
						(vla-put-stylename VlaObject NameTableStyle)
					)
				)))
			)
		)
	)

	(if (= TypeStyle "Text Style")
		(progn
			(setq VlaTextStyle (vla-get-ActiveTextStyle VlaDrawingCurrent))
			(setq NameTextStyle (SSC_VLA_GET_NAME VlaTextStyle))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(setq TypeObject (vla-get-objectname VlaObject))
					(if
						(or
							(= TypeObject "AcDbAttributeDefinition")
							(= TypeObject "AcDbMText")
							(= TypeObject "AcDbText")
						)
						(vla-put-stylename VlaObject NameTextStyle)
					)
				)))
			)
		)
	)

	(if (= TypeStyle "Transparency")
		(progn
			(setq NameTransparency (getvar "CETRANSPARENCY"))
			(foreach VlaObject ListVlaObject
				(vl-catch-all-apply (function (lambda ( / )
					(vla-put-EntityTransparency VlaObject NameTransparency)
				)))
			)
		)
	)

	(SSC_RESTORE_LOCK_LAYER)
	(vla-endundomark VlaDrawingCurrent)
	(vla-Regen VlaDrawingCurrent acActiveViewport)
	(princ)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SELECT_TYPESTYLE ( / 
	ListDataStyle
	ListStringStyle
	ListTypeStyle
	Pos
	StringStyle
	StringStyleTemp
	StringTemp)

	(setq ListDataStyle
		(list
			(list "Annotation Scale" "AnnotationScale")
			(list "Block" "Block")
			(list "Color" "Color")
			(list "Dimmension Style" "DimmensionStyle")
			(list "Layer" "LAyer")
			(list "LineType" "LType")
			(list "LineWeight" "LWeight")
			(list "Material" "MAterial")
			(list "MultiLeader Style" "MLEaderStyle")
			(list "Multiline Style" "MLIneStyle")
			(list "Plot Style" "PlotStyle")
			(list "Table Style" "TAbleStyle")
			(list "Text Style" "TExtStyle")
			(list "Transparency" "TRansparency")
		)
	)
	(setq ListTypeStyle (mapcar '(lambda (x) (nth 0 x)) ListDataStyle))
	(setq ListStringStyle (mapcar '(lambda (x) (nth 1 x)) ListDataStyle))

	(if
		(not
			(and
				TypeStyle
				(setq Pos (vl-position TypeStyle ListTypeStyle))
				(setq StringStyle (nth Pos ListStringStyle))
			)
		)
		(progn
			(setq TypeStyle (car ListTypeStyle))
			(setq StringStyle (car ListStringStyle))
		)
	)

	(setq StringTemp (SSC_LIST_TO_STRING ListStringStyle " "))
	(initget 32 StringTemp)
	(setq StringTemp (SSC_LIST_TO_STRING ListStringStyle "/"))
	(setq StringStyleTemp (getkword (strcat "\nSelect the type of style you want to set for the object [" StringTemp "] <" StringStyle ">:")))
	(if StringStyleTemp
		(progn
			(setq Pos (vl-position StringStyleTemp ListStringStyle))
			(setq TypeStyle (nth Pos ListTypeStyle))
			(setq StringStyle (nth Pos ListStringStyle))
		)
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_CREATE_LISTDATASTYLECURRENT ( / 
	EnameObject
	ListDataCheck
	ListDataStyleCurrent
	ListNameAnnotationScale
	NameAnnotationScale
	NameBlock
	NameColor
	NameDimmensionStyle
	NameLayer
	NameLineType
	NameLineWeight
	NameMaterial
	NameMultiLineStyle
	NameMultiLeaderStyle
	NamePlotStyle
	TypeStyle
	NameTableStyle
	NameTextStyle
	NameTransparency
	Temp
	TypeObject
	VlaBlock
	VlaBlocksGroup
	VlaObject)

	(vl-catch-all-apply (function (lambda ( / )
		(while (not VlaObject)
			(initget 0 "Setting")
			(setq Temp (entsel "\nPick object to set current style or [Setting]:"))

			(if (= Temp "Setting")
				(SSC_GET_SETTING)
				(progn
					(setq EnameObject (car Temp))
					(if EnameObject
						(progn
							(setq VlaObject (vlax-ename->vla-object EnameObject))
							(setq TypeObject (vla-get-objectname VlaObject))
						)
					)
				)
			)
		)
	)))
	(setq ListDataCheck (mapcar '(lambda (x) (list (nth 1 x) (nth 2 x))) ListDataSetting))

	(setq TypeStyle "Annotation Scale")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if
				(or
					(= TypeObject "AcDb2LineAngularDimension")
					(= TypeObject "AcDb3PointAngularDimension")
					(= TypeObject "AcDbAlignedDimension")
					(= TypeObject "AcDbAttributeDefinition")
					(= TypeObject "AcDbArcDimension")
					(= TypeObject "AcDbBlockReference")
					(= TypeObject "AcDbDiametricDimension")
					(= TypeObject "AcDbLeader")
					(= TypeObject "AcDbFcf")
					(= TypeObject "AcDbHatch")
					(= TypeObject "AcDbMText")
					(= TypeObject "AcDbOrdinateDimension")
					(= TypeObject "AcDbRadialDimension")
					(= TypeObject "AcDbRadialDimensionLarge")
					(= TypeObject "AcDbRotatedDimension")
					(= TypeObject "AcDbText")
				)
				(progn
					(if (or (= (getvar "TILEMODE") 1) (and (= (getvar "TILEMODE") 0) (/= (getvar "CVPORT") 1)))
						(progn
							(setq ListNameAnnotationScale (SSC_GET_LISTNAMEANNOTATIONSCALE_OF_OBJECT VlaObject))
							(if (not (member (getvar "CANNOSCALE") ListNameAnnotationScale))
								(progn
									(setq NameAnnotationScale (last ListNameAnnotationScale))
									(if NameAnnotationScale
										(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameAnnotationScale)
									)
								)
							)
						)
					)
				)
			)
		)))
	)

	(setq TypeStyle "Block")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq VlaBlocksGroup (vla-get-blocks VlaDrawingCurrent))
			(if (= TypeObject "AcDbBlockReference")
				(progn
					(setq NameBlock (SSC_GET_EFFECTIVENAME_BLOCK VlaObject))
					(setq VlaBlock (vla-item VlaBlocksGroup NameBlock))
					(if
						(and
							(= (vla-get-IsLayout VlaBlock) :vlax-false)
							(= (vla-get-IsXRef VlaBlock) :vlax-false)
						)
						(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameBlock)
					)
				)
			)
		)))
	)

	(setq TypeStyle "Color")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameColor (SSC_GET_NAMECOLOR VlaObject))
			(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameColor)
		)))
	)

	(setq TypeStyle "Dimmension Style")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if
				(or
					(= TypeObject "AcDb2LineAngularDimension")
					(= TypeObject "AcDb3PointAngularDimension")
					(= TypeObject "AcDbAlignedDimension")
					(= TypeObject "AcDbArcDimension")
					(= TypeObject "AcDbDiametricDimension")
					(= TypeObject "AcDbLeader")
					(= TypeObject "AcDbFcf")
					(= TypeObject "AcDbOrdinateDimension")
					(= TypeObject "AcDbRadialDimension")
					(= TypeObject "AcDbRadialDimensionLarge")
					(= TypeObject "AcDbRotatedDimension")
				)
				(progn
					(setq NameDimmensionStyle (SSC_VLA_GET_STYLENAME VlaObject))
					(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameDimmensionStyle)
				)
			)
		)))
	)

	(setq TypeStyle "Layer")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameLayer (SSC_VLA_GET_LAYER VlaObject))
			(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameLayer)
		)))
	)

	(setq TypeStyle "LineType")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameLineType (SSC_VLA_GET_LINETYPE VlaObject))
			(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameLineType)
		)))
	)

	(setq TypeStyle "LineWeight")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameLineWeight (vla-get-lineweight VlaObject))
			(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameLineWeight)
		)))
	)

	(setq TypeStyle "Material")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameMaterial (SSC_VLA_GET_MATERIAL VlaObject))
			(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameMaterial)
		)))
	)

	(setq TypeStyle "MultiLeader Style")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeObject "AcDbMLeader")
				(progn
					(setq NameMultiLeaderStyle (SSC_VLA_GET_STYLENAME VlaObject))
					(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameMultiLeaderStyle)
				)
			)
		)))
	)

	(setq TypeStyle "Multiline Style")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeObject "AcDbMline")
				(progn
					(setq NameMultiLineStyle (SSC_VLA_GET_STYLENAME VlaObject))
					(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameMultiLineStyle)
				)
			)
		)))
	)

	(setq TypeStyle "Plot Style")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if (= (getvar "PSTYLEMODE") 0)
				(progn
					(setq NamePlotStyle (vla-get-PlotStyleName VlaObject))
					(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NamePlotStyle)
				)
			)
		)))
	)

	(setq TypeStyle "Table Style")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeObject "AcDbTable")
				(progn
					(setq NameTableStyle (SSC_VLA_GET_STYLENAME VlaObject))
					(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameTableStyle)
				)
			)
		)))
	)

	(setq TypeStyle "Text Style")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(if
				(or
					(= TypeObject "AcDbAttributeDefinition")
					(= TypeObject "AcDbMText")
					(= TypeObject "AcDbText")
				)
				(progn
					(setq NameTextStyle (SSC_VLA_GET_STYLENAME VlaObject))
					(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameTextStyle)
				)
			)
		)))
	)

	(setq TypeStyle "Transparency")
	(if (= (nth 1 (assoc TypeStyle ListDataCheck)) "1")
		(vl-catch-all-apply (function (lambda ( / )
			(setq NameTransparency (vla-get-EntityTransparency VlaObject))
			(cond
				(
					(= NameTransparency "ByLayer")
					(setq NameTransparency -1)
				)
				(
					(= NameTransparency "ByBlock")
					(setq NameTransparency -2)
				)
				(
					T
					(setq NameTransparency (atoi NameTransparency))
				)
			)
			(SSC_ADD_LISTDATASTYLECURRENT TypeStyle NameTransparency)
		)))
	)

	(setq ListDataStyleCurrent (reverse ListDataStyleCurrent))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SET_CURRENT_STYLE ( ListDataStyleCurrent / 
	NameStyle
	TypeStyle
	VlaDimmensionStyle
	VlaLayer
	VlaLineType
	VlaMaterial
	VlaTextStyle)

	(foreach DataStyle ListDataStyleCurrent
		(setq TypeStyle (nth 0 DataStyle))
		(setq NameStyle (nth 1 DataStyle))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Annotation Scale")
				(if (or (= (getvar "TILEMODE") 1) (and (= (getvar "TILEMODE") 0) (/= (getvar "CVPORT") 1)))
					(setvar "CANNOSCALE" NameStyle)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Block")
				(setvar "INSNAME" NameStyle)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Color")
				(setvar "CECOLOR" NameStyle)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Dimmension Style")
				(progn
					(setq VlaDimmensionStyle (vla-item (vla-get-dimstyles VlaDrawingCurrent) NameStyle))
					(vla-put-Activedimstyle VlaDrawingCurrent VlaDimmensionStyle)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Layer")
				(progn
					(setq VlaLayer (vla-item (vla-get-layers VlaDrawingCurrent) NameStyle))
					(if (= (vla-get-Freeze VlaLayer) :vlax-true)
						(vla-put-Freeze VlaLayer :vlax-false)
					)
					(vla-put-Activelayer VlaDrawingCurrent VlaLayer)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "LineType")
				(progn
					(setq VlaLineType (vla-item (vla-get-linetypes VlaDrawingCurrent) NameStyle))
					(vla-put-Activelinetype VlaDrawingCurrent VlaLineType)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "LineWeight")
				(setvar "CELWEIGHT" NameStyle)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Material")
				(progn
					(setq VlaMaterial (vla-item (vla-get-materials VlaDrawingCurrent) NameStyle))
					(vla-put-Activematerial VlaDrawingCurrent VlaMaterial)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "MultiLeader Style")
				(setvar "CMLEADERSTYLE" NameStyle)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Multiline Style")
				(setvar "CMLSTYLE" NameStyle)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Plot Style")
				(if (= (getvar "PSTYLEMODE") 0)
					(setvar "CPLOTSTYLE" NameStyle)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Table Style")
				(setvar "CTABLESTYLE" NameStyle)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Text Style")
				(progn
					(setq VlaTextStyle (vla-item (vla-get-textstyles VlaDrawingCurrent) NameStyle))
					(vla-put-Activetextstyle VlaDrawingCurrent VlaTextStyle)
				)
			)
		)))

		(vl-catch-all-apply (function (lambda ( / )
			(if (= TypeStyle "Transparency")
				(setvar "CETRANSPARENCY" NameStyle)
			)
		)))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_SETTING ( / 
	Key
	ListDataSettingEdit
	Version
	Main_DCL
	End_Main_DCL)

	(setq Version "1.00")
	(setq ListDataSettingEdit ListDataSetting)

	(SSC_MAKE_FILE_DCL)
	(setq Main_DCL (load_dialog "Set Current Style.dcl"))
	(new_dialog "SetCurrentStyle" Main_DCL)

	(SSC_SET_TILE_DECORATION 1)
	(SSC_SET_TILE_SETTING)

	(foreach DataSetting ListDataSettingEdit
		(action_tile (nth 0 DataSetting) "(SSC_GET_TILE_SETTING $Key)")
	)

	(setq End_Main_DCL (start_dialog))
	(cond
		(
			(= End_Main_DCL 0)
			(unload_dialog Main_DCL)
		)
		(
			(= End_Main_DCL 1)
			(unload_dialog Main_DCL)
			(setq ListDataSetting ListDataSettingEdit)
		)
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SET_TILE_SETTING ( / Key )
	(foreach DataSetting ListDataSettingEdit
		(setq Key (nth 0 DataSetting))
		(set_tile Key (nth 2 DataSetting))
	)
	(if (= (getvar "PSTYLEMODE") 0)
		(mode_tile "Tile_CheckPlotStyle" 0)
		(mode_tile "Tile_CheckPlotStyle" 1)
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_TILE_SETTING ( Key / 
	DataSetting
	DataSettingNew)
	
	(setq DataSetting (assoc Key ListDataSettingEdit))
	(setq DataSettingNew (list Key (nth 1 DataSetting) (get_tile Key) (nth 3 DataSetting)))
	(setq ListDataSettingEdit (subst DataSettingNew DataSetting ListDataSettingEdit))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_READ_REGISTRY ( / 
	CheckUse
	ListTemp
	Num
	NumSetting
	NumSettingMMax)

	(setq ListTemp
		(list
			(list "Tile_CheckAnnotationScale" "Annotation Scale")
			(list "Tile_CheckBlock" "Block")
			(list "Tile_CheckColor" "Color")
			(list "Tile_CheckDimmensionStyle" "Dimmension Style")
			(list "Tile_CheckLayer" "Layer")
			(list "Tile_CheckLineType" "LineType")
			(list "Tile_CheckLineWeight" "LineWeight")
			(list "Tile_CheckMaterial" "Material")
			(list "Tile_CheckMultiLeaderStyle" "MultiLeader Style")
			(list "Tile_CheckMultiLineStyle" "Multiline Style")
			(list "Tile_CheckPlotStyle" "Plot Style")
			(list "Tile_CheckTableStyle" "Table Style")
			(list "Tile_CheckTextStyle" "Text Style")
			(list "Tile_CheckTransparency" "Transparency")
		)
	)

	(setq NumSettingMMax (- (expt 2 (length ListTemp)) 1))
	(setq NumSetting (vl-registry-read "HKEY_CURRENT_USER\\Software\\Set Current Style" "NumSetting"))
	(if
		(not
			(and
				NumSetting
				(setq NumSetting (atoi NumSetting))
				(<= NumSetting NumSettingMMax)
				(>= NumSetting 0)
			)
		)
		(setq NumSetting NumSettingMMax)
	)
	(setq Num 1)
	(foreach Temp ListTemp
		(if (= (logand NumSetting Num) Num)
			(setq CheckUse "1")
			(setq CheckUse "0")
		)
		(setq ListDataSetting (append ListDataSetting (list (append Temp (list CheckUse Num)))))
		(setq Num (* Num 2))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_WRITE_REGISTRY ( / NumSetting)
	(setq NumSetting 0)
	(foreach DataSetting ListDataSetting
		(if (= (nth 2 DataSetting) "1")
			(setq NumSetting (+ NumSetting (nth 3 DataSetting)))
		)
	)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Set Current Style" "NumSetting" (itoa NumSetting))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_MAKE_FILE_DCL ( /
	DataSetting
	DclFile
	DirectoryDes
	Num)

	(setq DirectoryDes (strcat (getvar "roamablerootprefix") "Support"))
	(setq DclFile (open (strcat DirectoryDes "\\Set Current Style.dcl") "w"))
	(write-line "///------------------------------------------------------------------------" DclFile)
	(write-line "///Set Current Style.dcl" DclFile)
	(write-line "SetCurrentStyle:dialog{" DclFile)
	(write-line (strcat "label = \"Set Current Style " Version "\";") DclFile)

	(setq Num 0)
	(repeat (/ (length ListDataSettingEdit) 2)
		(write-line "	:row{" DclFile)
		(repeat 2
			(setq DataSetting (nth Num ListDataSettingEdit))
			(write-line "		:toggle{" DclFile)
			(write-line (strcat "		key = \"" (nth 0 DataSetting) "\";") DclFile)
			(write-line (strcat "		label = \"&" (nth 1 DataSetting) "\";") DclFile)
			(write-line "		width = 20;" DclFile)
			(write-line "		}" DclFile)
			(setq Num (+ Num 1))
		)
		(write-line "	}" DclFile)
	)

	(write-line "	:text{" DclFile)
	(write-line "	key = \"sep0\";" DclFile)
	(write-line "	}" DclFile)

	(write-line "	:row{" DclFile)
	(write-line "		:button{" DclFile)
	(write-line "		key = \"Tile_Ok\";" DclFile)
	(write-line "		label = \"&Ok\";" DclFile)
	(write-line "		is_default = true;" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:button{" DclFile)
	(write-line "		key = \"Tile_Cancel\";" DclFile)
	(write-line "		label = \"&Cancel\";" DclFile)
	(write-line "		is_cancel = true;" DclFile)
	(write-line "		width = 20;" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)
	(write-line "}" DclFile)

	(close DclFile)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SET_TILE_DECORATION ( NumTile / Num )
	(setq Num 0)
	(repeat NumTile
		(SSC_SET_TILE_OF_SEP (strcat "sep" (itoa Num)))
		(setq Num (+ Num 1))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SET_TILE_OF_SEP ( Tile / )
	(set_tile Tile "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------")
	(mode_tile Tile 1)                                                    
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_ADD_LISTDATASTYLECURRENT ( TypeStyle NameStyle / )
	(setq ListDataStyleCurrent (cons (list TypeStyle NameStyle) ListDataStyleCurrent))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_EFFECTIVENAME_BLOCK ( VlaObject / NameBlock )
	(vl-catch-all-apply (function (lambda ( / )
		(setq NameBlock (cdr (assoc 2 (entget (cdr (assoc 340 (entget (vlax-vla-object->ename (vla-item (vla-item (vla-GetExtensionDictionary VlaObject) "AcDbBlockRepresentation") "AcDbRepData")))))))))
	)))
	(if (not NameBlock)
		(setq NameBlock (cdr (assoc 2 (entget (vlax-vla-object->ename VlaObject)))))
	)
	NameBlock
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_VLA_GET_NAME ( VlaStyle /
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
				(setq NameStyle (SSC_VLA_GET_NAME (vlax-ename->vla-object (cdr (assoc 340 (entget (vlax-vla-object->ename VlaStyle)))))))
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
(defun SSC_VLA_PUT_STYLENAME_MILNE ( VlaObject NameStyle / 
	ListPropertyObject
	VlaObjectNew
	VlaSpace)

	(setq VlaSpace (vla-ObjectIdToObject VlaDrawingCurrent (vla-get-OwnerId VlaObject)))
	(setq VlaObjectNew (vla-AddMLine VlaSpace (vla-get-Coordinates VlaObject)))
	(vla-put-MLineScale VlaObjectNew (vla-get-MLineScale VlaObject))
	(vla-put-Justification VlaObjectNew (vla-get-Justification VlaObject))
	(setq ListPropertyObject (SSC_GET_PROPERTIES_OBJECT VlaObject))
	(SSC_PUT_PROPERTIES_OBJECT VlaObjectNew ListPropertyObject)
	(vla-delete VlaObject)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_PROPERTIES_OBJECT ( VlaObject /
	ListNameProperty
	ListPropertyObject)

	(setq ListNameProperty
		(list
			"EntityTransparency"
			"Layer"
			"Linetype"
			"LinetypeScale"
			"Lineweight"
			"Material"
			"PlotStyleName"
			"TrueColor"
		)
	)
	(foreach NameProperty ListNameProperty
		(vl-catch-all-error-p (vl-catch-all-apply (function (lambda ( / )
			(setq ListPropertyObject (cons (cons NameProperty (vlax-get-property VlaObject NameProperty)) ListPropertyObject))
		))))
	)
	ListPropertyObject
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_PUT_PROPERTIES_OBJECT ( VlaObject ListPropertyObject /
	NameProperty
	ValueProperty)

	(foreach PropertyObject ListPropertyObject
		(vl-catch-all-error-p (vl-catch-all-apply (function (lambda ( / )
			(setq NameProperty (car PropertyObject))
			(setq ValueProperty (cdr PropertyObject))
			(vlax-put-property VlaObject NameProperty ValueProperty)
		))))
	)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_VLA_GET_STYLENAME ( VlaObject /
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
							(setq NameStyle (SSC_VLA_GET_NAME (vlax-ename->vla-object (cdr (assoc NumCode DataEname)))))
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
							(setq NameStyle (SSC_VLA_GET_NAME (vlax-ename->vla-object (cdr (assoc NumCode DataEname)))))
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
(defun SSC_VLA_GET_LAYER ( VlaObject / NameLayer)
	(vl-catch-all-apply (function (lambda ( / )
		(setq NameLayer (vla-get-layer VlaObject))
	)))
	(if
		(or
			(not NameLayer)
			(and
				NameLayer
				(vl-string-search "?" NameLayer)
			)
		)
		(setq NameLayer (cdr (assoc 8 (entget (vlax-vla-object->ename VlaObject)))))
	)
	NameLayer
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_VLA_GET_LINETYPE ( VlaObject / NameLinetype)
	(vl-catch-all-apply (function (lambda ( / )
		(setq NameLinetype (vla-get-linetype VlaObject))
	)))
	(if
		(or
			(not NameLinetype)
			(and
				NameLinetype
				(vl-string-search "?" NameLinetype)
			)
		)
		(setq NameLinetype (cdr (assoc 6 (entget (vlax-vla-object->ename VlaObject)))))
	)
	NameLinetype
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_VLA_GET_MATERIAL ( VlaObject /
	DataEnameObject
	NameMaterial
	VlaLayerLayer)

	(vl-catch-all-apply (function (lambda ( / )
		(setq NameMaterial (vla-get-material VlaObject))
	)))
	(if
		(or
			(not NameMaterial)
			(and
				NameMaterial
				(vl-string-search "?" NameMaterial)
			)
		)
		(progn
			(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
			(if (assoc 347 DataEnameObject)
				(setq NameMaterial (cdr (assoc 1 (entget (cdr (assoc 347 DataEnameObject))))))
				(progn
					(setq VlaLayerLayer (vla-item (vla-get-layers (vla-get-Document VlaObject)) (cdr (assoc 8 DataEnameObject))))
					(setq NameMaterial (cdr (assoc 1 (entget (cdr (assoc 347 (entget (vlax-vla-object->ename VlaLayerLayer))))))))
				)
			)
		)
	)
	NameMaterial
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_LISTNAMEANNOTATIONSCALE_OF_OBJECT ( VlaObject /
	VlaDict1
	VlaDict2
	VlaDict3
	EnameContext
	NameAnnotationScale
	ListNameAnnotationScale
	ListEnameAnnotationScale_NameAnnotationScale)

	(vl-catch-all-apply (function (lambda ( / )
		(setq VlaDict1 (vla-GetExtensionDictionary VlaObject))
		(setq VlaDict2 (vla-item VlaDict1 "AcDbContextDataManager"))
		(setq VlaDict3 (vla-item VlaDict2 "ACDB_ANNOTATIONSCALES"))
		(if VlaDict3
			(progn
				(setq ListEnameAnnotationScale_NameAnnotationScale (SSC_CREATE_LISTENAMEANNOTATIONSCALE_NAMEANNOTATIONSCALE))
				(vlax-for VlaContext VlaDict3
					(setq EnameContext (vlax-vla-object->ename VlaContext))
					(setq NameAnnotationScale (cdr (assoc (cdr (assoc 340 (entget EnameContext))) ListEnameAnnotationScale_NameAnnotationScale)))
					(if NameAnnotationScale
						(setq ListNameAnnotationScale (cons NameAnnotationScale ListNameAnnotationScale))
					)
				)
				(setq ListNameAnnotationScale (reverse ListNameAnnotationScale))
			)
		)
	)))
	ListNameAnnotationScale
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_CREATE_LISTENAMEANNOTATIONSCALE_NAMEANNOTATIONSCALE ( /
	VlaAnnotationScalesGroup
	EnameAnnotationScale
	DataEnameAnnotationScale
	NameAnnotationScale
	ListEnameAnnotationScale_NameAnnotationScale)

	(vl-catch-all-apply (function (lambda ( / )
		(setq VlaAnnotationScalesGroup (vla-item (vla-get-Dictionaries (vla-get-Database VlaDrawingCurrent)) "ACAD_SCALELIST"))
		(vlax-for VlaAnnotationScale VlaAnnotationScalesGroup
			(setq EnameAnnotationScale (vlax-vla-object->ename VlaAnnotationScale))
			(setq DataEnameAnnotationScale (entget EnameAnnotationScale))
			(setq NameAnnotationScale (cdr (assoc 300 DataEnameAnnotationScale)))
			(setq ListEnameAnnotationScale_NameAnnotationScale (cons (cons EnameAnnotationScale NameAnnotationScale) ListEnameAnnotationScale_NameAnnotationScale))
		)
	)))
	ListEnameAnnotationScale_NameAnnotationScale
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_NAMECOLOR ( VlaObject / 
	DataEnameObject
	StringColor
	Temp)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(foreach Code (list 430 420 62)
		(setq Temp (cdr (assoc Code DataEnameObject)))
		(if
			(and
				(not StringColor)
				Temp
			)
			(progn
				(if (= Code 430)
					(setq StringColor Temp)
				)
				(if (= Code 420)
					(setq StringColor (SSC_TRUECOLOR_TO_RGBCOLOR Temp))
				)
				(if (= Code 62)
					(setq StringColor (itoa Temp))
				)
			)
		)
	)

	(if (not StringColor)
		(setq StringColor "BYLAYER")
	)

	(if (= StringColor "0")
		(setq StringColor "BYBLOCK")
	)

	StringColor
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SET_NAMECOLOR ( VlaObject ListDataColor / 
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(foreach Code (list 62 420 430)
		(setq DataEnameObject (vl-remove (assoc Code DataEnameObject) DataEnameObject))
	)
	(setq DataEnameObject (append DataEnameObject ListDataColor))
	(entmod DataEnameObject)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_STRINGCOLOR_TO_LISTDATACOLOR ( StringColor / 
	ListDataColor
	NumIndexColor
	NumTrueColor)

	(if (= StringColor "BYLAYER")
		(setq ListDataColor Nil)
	)

	(if (= StringColor "BYBLOCK")
		(setq ListDataColor (list (cons 62 0)))
	)

	(if
		(and
			(setq NumIndexColor (atoi StringColor))
			(= (itoa NumIndexColor) StringColor)
		)
		(setq ListDataColor (list (cons 62 NumIndexColor)))
	)

	(if
		(= (substr StringColor 1 4) "RGB:")
		(progn
			(setq NumIndexColor (SSC_RGBCOLOR_TO_INDEXCOLOR StringColor))
			(setq NumTrueColor (SSC_RGBCOLOR_TO_TRUECOLOR StringColor))
			(setq ListDataColor (list (cons 62 NumIndexColor) (cons 420 NumTrueColor)))
		)
	)

	(if
		(vl-string-search "$" StringColor)
		(progn
			(setq NumIndexColor (SSC_BOOKCOLOR_TO_INDEXCOLOR StringColor))
			(setq NumTrueColor (SSC_BOOKCOLOR_TO_TRUECOLOR StringColor))
			(setq ListDataColor (list (cons 62 NumIndexColor) (cons 420 NumTrueColor) (cons 430 StringColor)))
		)
	)
	ListDataColor
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_BOOKCOLOR_TO_INDEXCOLOR ( StringColor / 
	ListTemp
	NameBook
	NameColor
	NumIndexColor
	ObjectColor)

	(setq ListTemp (SSC_STRING_TO_LIST_NEW StringColor "$"))
	(setq NameBook (nth 0 ListTemp))
	(setq NameColor (nth 1 ListTemp))

    (if (setq ObjectColor (vla-getinterfaceobject (vlax-get-acad-object) (strcat "autocad.accmcolor." (substr (getvar "ACADVER") 1 2))))
        (progn
			(vla-SetColorBookColor ObjectColor NameBook NameColor)
			(setq NumIndexColor (vla-get-colorindex ObjectColor))
            (vlax-release-object ObjectColor)
        )
    )
	NumIndexColor
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_BOOKCOLOR_TO_TRUECOLOR ( StringColor / 
	ListTemp
	NameBook
	NameColor
	NumTrueColor
	ObjectColor)

	(setq ListTemp (SSC_STRING_TO_LIST_NEW StringColor "$"))
	(setq NameBook (nth 0 ListTemp))
	(setq NameColor (nth 1 ListTemp))

    (if (setq ObjectColor (vla-getinterfaceobject (vlax-get-acad-object) (strcat "autocad.accmcolor." (substr (getvar "ACADVER") 1 2))))
        (progn
			(vla-SetColorBookColor ObjectColor NameBook NameColor)
			(setq NumTrueColor (SSC_RGBCOLOR_TO_TRUECOLOR (strcat "RGB:" (itoa (vla-get-red ObjectColor)) "," (itoa (vla-get-green ObjectColor)) "," (itoa (vla-get-blue ObjectColor)))))
            (vlax-release-object ObjectColor)
        )
    )
	NumTrueColor
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_RGBCOLOR_TO_INDEXCOLOR ( StringColor /
	NumIndexColor
	ListNumColor
	NumBlue
	NumGreen
	NumRed
	ObjectColor)

	(setq ListNumColor (SSC_STRING_TO_LIST_NEW (substr StringColor 5) ","))
	(setq ListNumColor (mapcar 'atoi ListNumColor))
	(setq NumRed (nth 0 ListNumColor))
	(setq NumGreen (nth 1 ListNumColor))
	(setq NumBlue (nth 2 ListNumColor))

    (if (setq ObjectColor (vla-getinterfaceobject (vlax-get-acad-object) (strcat "autocad.accmcolor." (substr (getvar "ACADVER") 1 2))))
        (progn
			(vla-setrgb ObjectColor NumRed NumGreen NumBlue)
			(setq NumIndexColor (vla-get-colorindex ObjectColor))
            (vlax-release-object ObjectColor)
        )
    )

	NumIndexColor
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_TRUECOLOR_TO_RGBCOLOR ( ColorTrue / ColorRGB)
	(setq ColorRGB "")
	(foreach Num (list 8 16 24)
		(setq ColorRGB (strcat ColorRGB "," (itoa (lsh (lsh (fix ColorTrue) Num) -24))))
	)
	(setq ColorRGB (strcat "RGB:" (substr ColorRGB 2)))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_RGBCOLOR_TO_TRUECOLOR ( StringColor /
	ListNumColor
	NumBlue
	NumGreen
	NumRed
	NumTrueColor)

	(setq ListNumColor (SSC_STRING_TO_LIST_NEW (substr StringColor 5) ","))
	(setq ListNumColor (mapcar 'atoi ListNumColor))
	(setq NumRed (nth 0 ListNumColor))
	(setq NumGreen (nth 1 ListNumColor))
	(setq NumBlue (nth 2 ListNumColor))
	(setq NumTrueColor (logior (lsh (fix NumRed) 16) (lsh (fix NumGreen) 8) (fix NumBlue)))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_ANNOTATIVE ( VlaObject /
	Application
	Xdata1
	Xdata2
	Temp
	ModeAnnotative)

	(setq Application "AcadAnnotative")
	(regapp Application)
	(vla-getxdata VlaObject Application 'Xdata1 'Xdata2)
	(if Xdata2
		(progn
			(setq Temp (mapcar 'vlax-variant-value (vlax-safearray->list Xdata2)))
			(if (and (= (nth 1 (reverse Temp)) 1) (= (nth 2 (reverse Temp)) 1))
				(setq ModeAnnotative T)
			)
		)
	)
	ModeAnnotative
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_VARIANT_TO_LIST ( VariantPoint / ListPoint)
	(vl-catch-all-apply (function (lambda ( / )
		(setq ListPoint (vlax-safearray->list (vlax-variant-value VariantPoint)))
	)))
	ListPoint
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_CONVERT_LISTCOORDINATES_TO_LISTPOINT ( ListCoordinates NumElement / 
	ListPoint
	Num1
	Num2
	Point)

	(setq Num1 0)
	(repeat (/ (length ListCoordinates) NumElement)
		(setq Point nil)
		(setq Num2 0)
		(repeat NumElement
			(setq Point (cons (nth (+ (* Num1 NumElement) Num2) ListCoordinates) Point))
			(setq Num2 (+ Num2 1))
		)
		(setq Point (reverse Point))
		(setq ListPoint (cons Point ListPoint))
		(setq Num1 (+ Num1 1))
	)
	(setq ListPoint (reverse ListPoint))
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SELECTION_OBJECT_MAIN ( / 
	CheckAddObject
	CheckStop
	CheckStopSelection
	ListVlaObject
	ListVlaObjectTemp
	VariableOsmode
	VlaSpace)

	(if (= (getvar "CVPORT") 1)
		(setq VlaSpace (vla-get-PaperSpace VlaDrawingCurrent))
		(setq VlaSpace (vla-get-ModelSpace VlaDrawingCurrent))
	)

	(setq VariableOsmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)

	(if 
		(vl-catch-all-error-p (vl-catch-all-apply (function (lambda ( / )
			(while
				(and
					(not CheckStop)
					(not CheckStopSelection)
				)
				(setq ListVlaObjectTemp (SSC_SELECTION_OBJECT))
				(if
					(and
						(not ListVlaObject)
						CheckStopSelection
					)
					(setq CheckStop T)
				)
				(if CheckAddObject
					(foreach VlaObject ListVlaObjectTemp
						(setq ListVlaObject (cons VlaObject ListVlaObject))
						(vla-highlight VlaObject 1)
					)
					(foreach VlaObject ListVlaObjectTemp
						(setq ListVlaObject (vl-remove VlaObject ListVlaObject))
						(vla-highlight VlaObject 0)
					)
				)
			)
		))))
		(setq CheckStop T)
	)

	(if CheckStop
		(progn
			(foreach VlaObject ListVlaObject
				(vla-highlight VlaObject 0)
			)
			(setq ListVlaObject Nil)
		)
	)
	(setvar "OSMODE" VariableOsmode)
	(list CheckStop ListVlaObject)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_SELECTION_OBJECT ( /
	CodeMouse
	Color1
	Color2
	PointA
	PointB
	PointC
	PointD
	PointMax
	PointMin
	PointTemp
	Opacity
	ListCoordinates
	ListPoint
	ListSelectionFrame
	ListVlaObject
	SelectionSet
	Temp
	VlaObjectSolid)

	(setq PointA (SSC_GET_POINTA_WHEN_SELECTION_OBJECT))
	(if PointA
		(progn
			(setq PointB PointA)
			(setq VlaObjectSolid
				(vla-AddSolid
					VlaSpace
					(vlax-3d-point PointA) 
					(vlax-3d-point (list (nth 0 PointB) (nth 1 PointA) 0.0))
					(vlax-3d-point (list (nth 0 PointA) (nth 1 PointB) 0.0))
					(vlax-3d-point PointB) 
				)
			)
			(vl-catch-all-apply (function (lambda ( / )
				(setq Color1 (getvar "CROSSINGAREACOLOR"))
			)))
			(vl-catch-all-apply (function (lambda ( / )
				(setq Color2 (getvar "WINDOWAREACOLOR"))
			)))
			(vl-catch-all-apply (function (lambda ( / )
				(setq Opacity (getvar "SELECTIONAREAOPACITY"))
				(setq Opacity (itoa (/ (- 100 Opacity))))
			)))
			(if (not Color1) (setq Color1 100))
			(if (not Color2) (setq Color1 150))
			(if (not Opacity) (setq Color1 "75"))
			(vla-put-color VlaObjectSolid Color1)
			(vl-catch-all-apply (function (lambda ( / )
				(vla-put-EntityTransparency VlaObjectSolid Opacity)
			)))

			(if
				(vl-catch-all-error-p (vl-catch-all-apply (function (lambda ( / )
					(setq CodeMouse 5)
					(while (/= CodeMouse 3)
						(setq Temp (grread T 15 0))
						(setq CodeMouse (nth 0 Temp))
						(vl-catch-all-apply (function (lambda ( / )
							(if (or (= CodeMouse 5) (= CodeMouse 3))
								(progn
									(setq PointTemp (nth 1 Temp))
									(if (not (SSC_CHECK_SAME_POINT PointB PointTemp 1e-3))
										(progn
											(redraw)
											(setq PointB PointTemp)
											(setq PointC (list (nth 0 PointB) (nth 1 PointA) 0.0))
											(setq PointD (list (nth 0 PointA) (nth 1 PointB) 0.0))
											(grvecs (list 7 PointA PointC 7 PointC PointB 7 PointB PointD 7 PointD PointA))
											(setq ListCoordinates (append PointA PointC PointD PointB))
											(vla-put-Coordinates
												VlaObjectSolid
												(vlax-safearray-fill
													(vlax-make-safearray
														vlax-vbDouble
														(cons 0 (- (length ListCoordinates) 1))
													)
													ListCoordinates
												)
											)
											(if (>= (nth 0 PointA) (nth 0 PointB))
												(vla-put-color VlaObjectSolid Color1)
												(vla-put-color VlaObjectSolid Color2)
											)
										)
									)
								)
							)
						)))
					)
					(setq ListPoint
						(list
							(list (min (nth 0 PointA) (nth 0 PointB)) (min (nth 1 PointA) (nth 1 PointB)) 0.0)
							(list (max (nth 0 PointA) (nth 0 PointB)) (max (nth 1 PointA) (nth 1 PointB)) 0.0)
						)
					)
					(setq PointMin (nth 0 ListPoint))
					(setq PointMax (nth 1 ListPoint))
					(setq ListSelectionFrame
						(list
							(list (nth 0 PointMin) (nth 1 PointMin))
							(list (nth 0 PointMax) (nth 1 PointMin))
							(list (nth 0 PointMax) (nth 1 PointMax))
							(list (nth 0 PointMin) (nth 1 PointMax))
						)
					)
					(if (>= (nth 0 PointA) (nth 0 PointB))
						(setq SelectionSet (ssget "_CP" ListSelectionFrame))
						(setq SelectionSet (ssget "_WP" ListSelectionFrame))
					)
					(setq ListVlaObject (SSC_CONVERT_SELECTIONSET_TO_LISTVLAOBJECT SelectionSet))
					(setq ListVlaObject (vl-remove VlaObjectSolid ListVlaObject))
				))))
				(setq CheckStop T)
			)
			(vla-delete VlaObjectSolid)
			(redraw)
		)
	)
	ListVlaObject
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_GET_POINTA_WHEN_SELECTION_OBJECT ( / PointA)
	(if
		(vl-catch-all-error-p (vl-catch-all-apply (function (lambda ( / )
			(setq Temp (getpoint "\nSelect objects:"))
			(if (not Temp)
				(setq CheckStopSelection T)
				(setq PointA Temp)
			)
			(if (acet-sys-shift-down)
				(setq CheckAddObject Nil)
				(setq CheckAddObject T)
			)
		))))
		(setq CheckStop T)
	)
	PointA
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_CHECK_SAME_POINT ( Point1 Point2 ToleranceValue / DistanceLength)
	(setq DistanceLength (distance Point1 Point2))
	(equal DistanceLength 0.0 ToleranceValue)
)
-------------------------------------------------------------------------------------------------------------------
(defun SSC_CONVERT_SELECTIONSET_TO_LISTVLAOBJECT ( SelectionSet /
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
(defun SSC_LIST_TO_STRING ( ListString Sep / 
	StringTemp
	StringValue)

	(setq StringValue (car ListString))
	(foreach StringTemp (cdr ListString)
		(setq StringValue (strcat StringValue Sep StringTemp))
	)
	StringValue
)
--------------------------------------------------------------------------------------------------------------------
(defun SSC_STRING_TO_LIST_NEW ( Stg Del / ListString)
	(setq ListString (SSC_STRING_TO_LIST_NO_TRIM Stg Del))
	(setq ListString (mapcar '(lambda (x) (vl-string-trim " " x)) ListString))
	(setq ListString (mapcar '(lambda (x) (vl-string-trim "\t" x)) ListString))
	ListString
)
--------------------------------------------------------------------------------------------------------------------
(defun SSC_STRING_TO_LIST_NO_TRIM (Stg Del / LenDel StgTemp Pos StgSub StgSubTemp ListString)
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
(defun SSC_CREATE_LISTVLALAYERLOCK ( / VlaLayersGroup)
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
(defun SSC_RESTORE_LOCK_LAYER ( / )
	(foreach VlaLayerLock ListVlaLayerLock
		(vl-catch-all-error-p (vl-catch-all-apply 'vla-put-Lock (list VlaLayerLock :vlax-true)))
	)
)