;;; ====================================================================================================
;;; TNT_PACKAGE_10_BLOCK_ALL.lsp
;;; Auto-generated consolidated package file. Source files are appended below in filename order.
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "TNT Architecture")


;;; ====================================================================================================
;;; BEGIN SOURCE: .Current Style.lsp
;;; ====================================================================================================
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
;;; ====================================================================================================
;;; END SOURCE: .Current Style.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: B_TNT_Block_Layer0_B0.lsp
;;; ====================================================================================================
;;;BLOCK LAYER 0
  (defun c:B0 (/ *error* adoc lst_layer func_restore-layers  fun_get-block-subref-by-block selset)
  (setvar "MODEMACRO" "TNT Architecture")
  (defun *error* (msg)
    (func_restore-layers)
    (vla-endundomark adoc)
    (princ msg)
    (princ)
    ) ;_ end of defun
  (defun fun_get-block-subref-by-block (blk-name)
    (setq res (list blk-name))
    (vlax-for subent (vla-item (vla-get-blocks adoc) blk-name)
      (if (wcmatch (strcase (vla-get-objectname subent)) "*BLOCK*")
        (setq res (append res (fun_get-block-subref-by-block (vla-get-name subent))))
        ) ;_ end of if
      ) ;_ end of vlax-for
    res
    ) ;_ end of defun
  (defun func_restore-layers ()
    (foreach item lst_layer
      (vla-put-lock (car item) (cdr (assoc "lock" (cdr item))))
      (vl-catch-all-apply
        '(lambda ()
            (vla-put-freeze
              (car item)
              (cdr (assoc "freeze" (cdr item)))
              ) ;_ end of vla-put-freeze
            ) ;_ end of lambda
        ) ;_ end of vl-catch-all-apply
      ) ;_ end of foreach
    ) ;_ end of defun
  (vl-load-com)
  (vla-startundomark
    (setq adoc (vla-get-activedocument (vlax-get-acad-object)))
    ) ;_ end of vla-startundomark
  (if (and (not (vl-catch-all-error-p
                  (setq selset
                          (vl-catch-all-apply
                            (function
                              (lambda ()
                                (ssget '((0 . "INSERT")))
                                ) ;_ end of lambda
                              ) ;_ end of function
                            ) ;_ end of vl-catch-all-apply
                        ) ;_ end of setq
                  ) ;_ end of vl-catch-all-error-p
                ) ;_ end of not
            selset
            ) ;_ end of and
    (progn
      (vlax-for item (vla-get-layers adoc)
        (setq
          lst_layer (cons (list item
                                (cons "lock" (vla-get-lock item))
                                (cons "freeze" (vla-get-freeze item))
                                ) ;_ end of list
                          lst_layer
                          ) ;_ end of cons
          ) ;_ end of setq
        (vla-put-lock item :vlax-false)
        (vl-catch-all-apply
          '(lambda () (vla-put-freeze item :vlax-false))
          ) ;_ end of vl-catch-all-apply
        ) ;_ end of vlax-for
      (foreach blk_def (mapcar
                          (function
                            (lambda (x)
                              (vla-item (vla-get-blocks adoc) x)
                              ) ;_ end of lambda
                            ) ;_ end of function
                          ((lambda (/ res)
                            (foreach item (apply (function append)
                                                  (mapcar
                                                    (function
                                                      (lambda (x)
                                                        (fun_get-block-subref-by-block
                                                          (vla-get-name
                                                            (vlax-ename->vla-object x)
                                                            ) ;_ end of vla-get-name
                                                          ) ;_ end of vla-get-name
                                                        ) ;_ end of lambda
                                                      ) ;_ end of function
                                                    ((lambda (/ tab item)
                                                      (repeat (setq tab  nil
                                                                    item (sslength selset)
                                                                    ) ;_ end setq
                                                        (setq
                                                          tab
                                                            (cons
                                                              (ssname selset
                                                                      (setq item (1- item))
                                                                      ) ;_ end of ssname
                                                              tab
                                                              ) ;_ end of cons
                                                          ) ;_ end of setq
                                                        ) ;_ end of repeat
                                                      tab
                                                      ) ;_ end of lambda
                                                    )
                                                    ) ;_ end of mapcar
                                                  ) ;_ end of apply
                              (if (not (member item res))
                                (setq res (cons item res))
                                ) ;_ end of if
                              ) ;_ end of foreach
                            (reverse res)
                            ) ;_ end of lambda
                          )
                          ) ;_ end of mapcar
        (vlax-for ent blk_def
          (vla-put-layer ent "0")
          (vla-put-color ent 0)
          (vla-put-lineweight ent aclnwtbyblock)
          (vla-put-linetype ent "byblock")
          ) ;_ end of vlax-for
        ) ;_ end of foreach
      (func_restore-layers)
      (vla-regen adoc acallviewports)
      ) ;_ end of progn
    ) ;_ end of if
  (vla-endundomark adoc)
  (princ)
  ) ;_ end of defun
;;; ====================================================================================================
;;; END SOURCE: B_TNT_Block_Layer0_B0.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: C_TNT_Block_Basepoint_B3.lsp
;;; ====================================================================================================

;;--------------------=={ Change Block Base Point }==-------------------;;
;;                                                                      ;;
;;  This program allows the user to change the base point for all       ;;
;;  block references of a block definition in a drawing.                ;;
;;                                                                      ;;
;;  The program offers two commands:                                    ;;
;;                                                                      ;;
;;  ------------------------------------------------------------------  ;;
;;  CBP (Change Base Point)                                             ;;
;;  ------------------------------------------------------------------  ;;
;;                                                                      ;;
;;  This command will retain the insertion point coordinates for all    ;;
;;  references of the selected block. Hence visually, the block         ;;
;;  components will be moved around the insertion point when the        ;;
;;  base point is changed.                                              ;;
;;                                                                      ;;
;;  ------------------------------------------------------------------  ;;
;;  CBPR (Change Base Point Retain Reference Position)                  ;;
;;  ------------------------------------------------------------------  ;;
;;                                                                      ;;
;;  This command will retain the position of the each block reference   ;;
;;  of the selected block. Hence, each block reference will be moved    ;;
;;  to retain the visual position when the base point is changed.       ;;
;;                                                                      ;;
;;  ------------------------------------------------------------------  ;;
;;                                                                      ;;
;;  Upon issuing a command syntax at the AutoCAD command-line, the      ;;
;;  program will prompt the user to select a block for which to change  ;;
;;  the base point.                                                     ;;
;;                                                                      ;;
;;  Following a valid selection, the user is then prompted to specify   ;;
;;  a new base point relative to the selected block.                    ;;
;;                                                                      ;;
;;  The block definition (and block reference depending on the command  ;;
;;  used) will then be modified to reflect the new block base point.    ;;
;;                                                                      ;;
;;  If the selected block is attributed, an ATTSYNC operation will      ;;
;;  also be performed to ensure all attributes are in the correct       ;;
;;  positions relative to the new base point.                           ;;
;;                                                                      ;;
;;  Finally, the active viewport is regenerated to reflect the changes  ;;
;;  throughout all references of the block.                             ;;
;;                                                                      ;;
;;  The program will furthermore perform successfully with rotated &    ;;
;;  scaled block references, constructed in any UCS plane.              ;;
;;                                                                      ;;
;;  ------------------------------------------------------------------  ;;
;;  Please Note:                                                        ;;
;;  ------------------------------------------------------------------  ;;
;;                                                                      ;;
;;  A REGEN is required if the UNDO command is used to undo the         ;;
;;  operations performed by this program.                               ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Author:  Lee Mac, Copyright � 2013  -  www.lee-mac.com              ;;
;;----------------------------------------------------------------------;;
;;  Version 1.5    -    20-10-2013                                      ;;
;;----------------------------------------------------------------------;;

;; Retains Insertion Point Coordinates
(defun c:cbp  nil (LM:changeblockbasepoint nil))

;; Retains Block Reference Position
(defun c:b3 nil (LM:changeblockbasepoint t))

;;----------------------------------------------------------------------;;

(defun LM:changeblockbasepoint ( flg / *error* bln cmd ent lck mat nbp vec )

    (defun *error* ( msg )
        (foreach lay lck (vla-put-lock lay :vlax-true))
        (if (= 'int (type cmd)) (setvar 'cmdecho cmd))
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )

    (while
        (progn (setvar 'errno 0) (setq ent (car (entsel "\nSelect Block: ")))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nMissed, try again.")
                )
                (   (= 'ename (type ent))
                    (if (/= "INSERT" (cdr (assoc 0 (entget ent))))
                        (princ "\nSelected object is not a block.")
                    )
                )
            )
        )
    )
    (if (and (= 'ename (type ent)) (setq nbp (getpoint "\nSpecify New Base Point: ")))
        (progn
            (setq mat (car (revrefgeom ent))
                  vec (mxv mat (mapcar '- (trans nbp 1 0) (trans (cdr (assoc 10 (entget ent))) ent 0)))
                  bln (LM:blockname (vlax-ename->vla-object ent))
            )
            (LM:startundo (LM:acdoc))
            (vlax-for lay (vla-get-layers (LM:acdoc))
                (if (= :vlax-true (vla-get-lock lay))
                    (progn
                        (vla-put-lock lay :vlax-false)
                        (setq lck (cons lay lck))
                    )
                )
            )
            (vlax-for obj (vla-item (vla-get-blocks (LM:acdoc)) bln)
                 (vlax-invoke obj 'move vec '(0.0 0.0 0.0))
            )
            (if flg
                (vlax-for blk (vla-get-blocks (LM:acdoc))
                    (if (= :vlax-false (vla-get-isxref blk))
                        (vlax-for obj blk
                            (if
                                (and
                                    (= "AcDbBlockReference" (vla-get-objectname obj))
                                    (= bln (LM:blockname obj))
                                    (vlax-write-enabled-p obj)
                                )
                                (vlax-invoke obj 'move '(0.0 0.0 0.0) (mxv (car (refgeom (vlax-vla-object->ename obj))) vec))
                            )
                        )
                    )
                )
            )
            (if (= 1 (cdr (assoc 66 (entget ent))))
                (progn
                    (setq cmd (getvar 'cmdecho))
                    (setvar 'cmdecho 0)
                    (vl-cmdf "_.attsync" "_N" bln)
                    (setvar 'cmdecho cmd)
                )
            )
            (foreach lay lck (vla-put-lock lay :vlax-true))
            (vla-regen  (LM:acdoc) acallviewports)
            (LM:endundo (LM:acdoc))
        )
    )
    (princ)
)

;; RefGeom (gile)
;; Returns a list whose first item is a 3x3 transformation matrix and
;; second item the object insertion point in its parent (xref, block or space)

(defun refgeom ( ent / ang enx mat ocs )
    (setq enx (entget ent)
          ang (cdr (assoc 050 enx))
          ocs (cdr (assoc 210 enx))
    )
    (list
        (setq mat
            (mxm
                (mapcar '(lambda ( v ) (trans v 0 ocs t))
                   '(
                        (1.0 0.0 0.0)
                        (0.0 1.0 0.0)
                        (0.0 0.0 1.0)
                    )
                )
                (mxm
                    (list
                        (list (cos ang) (- (sin ang)) 0.0)
                        (list (sin ang) (cos ang)     0.0)
                       '(0.0 0.0 1.0)
                    )
                    (list
                        (list (cdr (assoc 41 enx)) 0.0 0.0)
                        (list 0.0 (cdr (assoc 42 enx)) 0.0)
                        (list 0.0 0.0 (cdr (assoc 43 enx)))
                    )
                )
            )
        )
        (mapcar '- (trans (cdr (assoc 10 enx)) ocs 0)
            (mxv mat (cdr (assoc 10 (tblsearch "block" (cdr (assoc 2 enx))))))
        )
    )
)

;; RevRefGeom (gile)
;; The inverse of RefGeom

(defun revrefgeom ( ent / ang enx mat ocs )
    (setq enx (entget ent)
          ang (cdr (assoc 050 enx))
          ocs (cdr (assoc 210 enx))
    )
    (list
        (setq mat
            (mxm
                (list
                    (list (/ 1.0 (cdr (assoc 41 enx))) 0.0 0.0)
                    (list 0.0 (/ 1.0 (cdr (assoc 42 enx))) 0.0)
                    (list 0.0 0.0 (/ 1.0 (cdr (assoc 43 enx))))
                )
                (mxm
                    (list
                        (list (cos ang)     (sin ang) 0.0)
                        (list (- (sin ang)) (cos ang) 0.0)
                       '(0.0 0.0 1.0)
                    )
                    (mapcar '(lambda ( v ) (trans v ocs 0 t))
                        '(
                             (1.0 0.0 0.0)
                             (0.0 1.0 0.0)
                             (0.0 0.0 1.0)
                         )
                    )
                )
            )
        )
        (mapcar '- (cdr (assoc 10 (tblsearch "block" (cdr (assoc 2 enx)))))
            (mxv mat (trans (cdr (assoc 10 enx)) ocs 0))
        )
    )
)

;; Matrix x Vector  -  Vladimir Nesterovsky
;; Args: m - nxn matrix, v - vector in R^n

(defun mxv ( m v )
    (mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
)

;; Matrix x Matrix  -  Vladimir Nesterovsky
;; Args: m,n - nxn matrices

(defun mxm ( m n )
    ((lambda ( a ) (mapcar '(lambda ( r ) (mxv a r)) m)) (trp n))
)

;; Matrix Transpose  -  Doug Wilson
;; Args: m - nxn matrix

(defun trp ( m )
    (apply 'mapcar (cons 'list m))
)

;; Block Name  -  Lee Mac
;; Returns the true (effective) name of a supplied block reference
                        
(defun LM:blockname ( obj )
    (if (vlax-property-available-p obj 'effectivename)
        (defun LM:blockname ( obj ) (vla-get-effectivename obj))
        (defun LM:blockname ( obj ) (vla-get-name obj))
    )
    (LM:blockname obj)
)

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.

(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.

(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object

(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
;;; ====================================================================================================
;;; END SOURCE: C_TNT_Block_Basepoint_B3.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: D_TNT_Block_Copy_MAB.lsp
;;; ====================================================================================================

(defun c:MAB (/ *error* blk f ss temp sx sy sz rot)
  (vl-load-com)

  (defun *error* (msg)
    (and f *AcadDoc* (vla-endundomark *AcadDoc*))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*,")))
      (princ (strcat "\nError: " msg))
    )
  )

  (if
    (and
      (AT:GetSel
        entsel
        "\nSelect replacement block: "
        (lambda (x / e)
          (if
            (and
              (eq "INSERT" (cdr (assoc 0 (setq e (entget (car x))))))
              (/= 4 (logand (cdr (assoc 70 (tblsearch "BLOCK" (cdr (assoc 2 e))))) 4))
              (/= 4 (logand (cdr (assoc 70 (entget (tblobjname "LAYER" (cdr (assoc 8 e)))))) 4))
            )
            (progn
              (setq blk (vlax-ename->vla-object (car x)))
              ;; Lấy scale và rotation từ block mẫu
              (setq sx (vlax-get blk 'XEffectiveScaleFactor))
              (setq sy (vlax-get blk 'YEffectiveScaleFactor))
              (setq sz (vlax-get blk 'ZEffectiveScaleFactor))
              (setq rot (vlax-get blk 'Rotation))
            )
          )
        )
      )
      (princ "\nSelect blocks to be repalced: ")
      (setq ss (ssget "_:L" '((0 . "INSERT"))))
    )
    (progn
      (setq f (not (vla-startundomark
        (cond (*AcadDoc*)
              ((setq *AcadDoc* (vla-get-activedocument (vlax-get-acad-object))))
        )
      )))

      (vlax-for x (setq ss (vla-get-activeselectionset *AcadDoc*))
        (setq temp (vla-copy blk))
        (mapcar
          (function (lambda (p val)
            (vl-catch-all-apply
              (function vlax-put-property)
              (list temp p val)
            )
          ))
          '(InsertionPoint Rotation XEffectiveScaleFactor YEffectiveScaleFactor ZEffectiveScaleFactor)
          (list
            (vlax-get-property x 'InsertionPoint)
            rot ; <--- sử dụng rotation từ block mẫu
            sx sy sz ; <--- scale từ block mẫu
          )
        )
        (vla-delete x)
      )

      (vla-delete ss)
      (*error* nil)
    )
  )
  (princ)
)

(defun AT:GetSel (meth msg fnc / ent good)
  ;; meth - selection method (entsel, nentsel, nentselp)
  ;; msg - message to display (nil for default)
  ;; fnc - optional function to apply to selected object
  ;; Alan J. Thompson, 05.25.10
  (setvar 'errno 0)
  (while (not good)
    (setq ent (meth (cond (msg) ("\nSelect object: "))))
    (cond
      ((vl-consp ent)
        (setq good (cond ((or (not fnc) (fnc ent)) ent)
                         ((prompt "\nInvalid object!")))))
      ((eq (type ent) 'STR) (setq good ent))
      ((setq good (eq 52 (getvar 'errno))) nil)
      ((eq 7 (getvar 'errno)) (setq good (prompt "\nMissed, try again.")))
    )
  )
)

;;; ====================================================================================================
;;; END SOURCE: D_TNT_Block_Copy_MAB.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: E_TNT_Block_Rename_RB-CB.lsp
;;; ====================================================================================================
;;-----------------=={ Copy/Rename Block Reference }==------------------;;
;;                                                                      ;;
;;  This program allows a user to copy and/or rename a single block     ;;
;;  reference in the working drawing.                                   ;;
;;                                                                      ;;
;;  Many existing programs enable the user to rename the block          ;;
;;  definition for a given block reference, with the new name           ;;
;;  subsequently reflected across all references of the block           ;;
;;  definition in the drawing. However, this program will allow a       ;;
;;  single selected block reference to be renamed (or for the user to   ;;
;;  create a renamed copy of the selected block reference), by          ;;
;;  generating a duplicate renamed block definition for the selected    ;;
;;  block.                                                              ;;
;;                                                                      ;;
;;  The program may be called from the command-line using either 'CB'   ;;
;;  to create a renamed copy of a selected block reference, or 'RB' to  ;;
;;  simply rename the selected block reference.                         ;;
;;                                                                      ;;
;;  Following selection of a block reference, the user is prompted to   ;;
;;  specify a name for the selected/copied block reference; a default   ;;
;;  block name composed of the original block name concatenated with    ;;
;;  both an underscore and the minimum integer required for uniqueness  ;;
;;  within the block collection of the active drawing is offered.       ;;
;;                                                                      ;;
;;  The program will then proceed to duplicate the block definition     ;;
;;  using the new block name. To accomplish this without resulting in   ;;
;;  a duplicate key in the block collection of the active drawing, the  ;;
;;  program utilises an ObjectDBX interface to which the block          ;;
;;  definition of the selected block reference is deep-cloned, renamed, ;;
;;  and then deep-cloned back to the active drawing. This method also   ;;
;;  enables Dynamic Block definitions to be successfully copied         ;;
;;  & renamed.                                                          ;;
;;                                                                      ;;
;;  Finally, this program will perform successfully in all UCS/Views    ;;
;;  and is compatible with Anonymous Blocks, Dynamic Blocks & XRefs.    ;;
;;----------------------------------------------------------------------;;
;;  Author:  Lee Mac, Copyright � 2013  -  www.lee-mac.com              ;;
;;----------------------------------------------------------------------;;
;;  Version 1.5    -    05-07-2013                                      ;;
;;----------------------------------------------------------------------;;

(defun c:cb nil (LM:RenameBlockReference   t))
(defun c:rb nil (LM:RenameBlockReference nil))

(defun LM:RenameBlockReference ( cpy / *error* abc app dbc dbx def doc dxf new old prp src tmp vrs )

    (defun *error* ( msg )
        (if (and (= 'vla-object (type dbx)) (not (vlax-object-released-p dbx)))
            (vlax-release-object dbx)
        )
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    
    (while
        (progn
            (setvar 'errno 0)
            (setq src (car (entsel (strcat "\nSelect block reference to " (if cpy "copy & " "") "rename: "))))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nMissed, try again.")
                )
                (   (= 'ename (type src))
                    (setq dxf (entget src))
                    (cond
                        (   (/= "INSERT" (cdr (assoc 0 dxf)))
                            (princ "\nPlease select a block reference.")
                        )
                        (   (= 4 (logand 4 (cdr (assoc 70 (tblsearch "layer" (cdr (assoc 8 dxf)))))))
                            (princ "\nSelected block is on a locked layer.")
                        )
                    )
                )
            )
        )
    )
    (if (= 'ename (type src))
        (progn
            (setq app (vlax-get-acad-object)
                  doc (vla-get-activedocument app)
                  src (vlax-ename->vla-object src)
                  old (vlax-get-property src (if (vlax-property-available-p src 'effectivename) 'effectivename 'name))
                  tmp 0
            )
            (while (tblsearch "block" (setq def (strcat (vl-string-left-trim "*" old) "_" (itoa (setq tmp (1+ tmp)))))))
            (while
                (and (/= "" (setq new (getstring t (strcat "\nSpecify new block name <" def ">: "))))
                    (or (not (snvalid new))
                        (tblsearch "block" new)
                    )
                )
                (princ "\nBlock name invalid or already exists.")
            )
            (if (= "" new)
                (setq new def)
            )
            (setq dbx
                (vl-catch-all-apply 'vla-getinterfaceobject
                    (list app
                        (if (< (setq vrs (atoi (getvar 'acadver))) 16)
                            "objectdbx.axdbdocument"
                            (strcat "objectdbx.axdbdocument." (itoa vrs))
                        )
                    )
                )
            )
            (if (or (null dbx) (vl-catch-all-error-p dbx))
                (princ "\nUnable to interface with ObjectDBX.")
                (progn
                    (setq abc (vla-get-blocks doc)
                          dbc (vla-get-blocks dbx)
                    )
                    (vlax-invoke doc 'copyobjects (list (vla-item abc old)) dbc)
                    (if (wcmatch old "`**")
                        (vla-put-name (vla-item dbc (1- (vla-get-count dbc))) new)
                        (vla-put-name (vla-item dbc old) new)
                    )
                    (vlax-invoke dbx 'copyobjects (list (vla-item dbc new)) abc)
                    (vlax-release-object dbx)
                    (if cpy (setq src (vla-copy src)))
                    (if
                        (and
                            (vlax-property-available-p src 'isdynamicblock)
                            (= :vlax-true (vla-get-isdynamicblock src))
                        )
                        (progn
                            (setq prp (mapcar 'vla-get-value (vlax-invoke src 'getdynamicblockproperties)))
                            (vla-put-name src new)
                            (mapcar
                               '(lambda ( a b )
                                    (if (/= "ORIGIN" (strcase (vla-get-propertyname a)))
                                        (vla-put-value a b)
                                    )
                                )
                                (vlax-invoke src 'getdynamicblockproperties) prp
                            )
                        )
                        (vla-put-name src new)
                    )
                    (if (= :vlax-true (vla-get-isxref (setq def (vla-item (vla-get-blocks doc) new))))
                        (vla-reload def)
                    )
                    (if cpy (sssetfirst nil (ssadd (vlax-vla-object->ename src))))
                )
            )
        )
    )
    (princ)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;
;;; ====================================================================================================
;;; END SOURCE: E_TNT_Block_Rename_RB-CB.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: F_TNT_Block_Copy_Text_Att_AT1.lsp
;;; ====================================================================================================
(defun c:AT1 ()
(setq sublst '())
(setq blk1 (car (entsel "\nPick block 1")))
(foreach att (vlax-invoke (vlax-ename->vla-object blk1) 'getattributes)
(setq sublst (cons (vla-get-textstring att ) sublst))
)
(setq sublst (reverse sublst))
(setq x -1)
(setq blk2 (car (entsel "\nPick block 2")))
(foreach att (vlax-invoke (vlax-ename->vla-object blk2) 'getattributes)
(setq x (+ x 1))
(vla-put-textstring att (nth x sublst))
)
 (princ)
)
(defun c:AT2 ( / ss pt ent txt oldsnap)
(while (setq ent (nentsel "Pick Attribute"))
(setq pt (cadr ent))
(setq tag (cdr (assoc 2  (entget (car ent)))))
(setq ent (entsel "pick text"))
(setq txt (cdr (assoc 1  (entget (car ent)))))
(setq oldsnap (getvar 'osmode))
(setvar 'osmode 0)
(setq ss (ssget pt))
(foreach att (vlax-invoke (vlax-ename->vla-object (ssname SS 0 )) 'getattributes)
        (if (= tag (strcase (vla-get-tagstring att)))
        (vla-put-textstring att txt)
        )
)
)
(setvar 'osmode oldsnap)
(princ)
)
;;; ====================================================================================================
;;; END SOURCE: F_TNT_Block_Copy_Text_Att_AT1.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: G_TNT_Block_Change_Vibisility_B1.lsp
;;; ====================================================================================================
;;; HÀM CHÍNH
(defun c:b1 ()
  (Changevisibilyti)
)
;;
(defun Changevisibilyti ()
  (setq objblock (vlax-ename->vla-object (car (entsel))))
  (show-visibility-states objblock)
)
;;;
(defun show-visibility-states (blk)
  (setq visibility_param (LM:getvisibilityparametername blk))
  (if visibility_param
    (progn
      (setq allowed_values (LM:getdynpropallowedvalues blk visibility_param))
      (if allowed_values
        (progn
          (setq current_state (LM:getvisibilitystate blk)) ; Lấy trạng thái hiện tại của khối động
          (setq choice (get-user-choice allowed_values current_state)) ; Truyền trạng thái hiện tại vào hàm get-user-choice
          (if choice
            (LM:SetVisibilityState blk choice)
          )
        )
        (princ "Failed to get allowed visibility states")
      )
    )
    (princ "Failed to get visibility parameter name")
  )
)
;;;
(defun get-user-choice (options current_state) ; Thêm tham số current_state vào hàm
  (setq menu_text (list (strcat "Current visibility state: " current_state "\nChoose visibility state:\n")))
  (foreach option options
    (setq menu_text (append menu_text (list (strcat (itoa (length menu_text)) ": " option "\n"))))
  )
  (setq choice_number (getint (strcat (apply 'strcat menu_text) "Enter the number of your choice: ")))
  (if (and (>= choice_number 1) (<= choice_number (length options)))
    (nth (1- choice_number) options)
    (progn
      (prompt "\nInvalid choice. Please enter the number of one of the listed options.")
      (get-user-choice options current_state)
    )
  )
)

;;----------------------------------------------------------------------------
  ;; Get Dynamic Block Property Value  -  Lee Mac
  ;; Returns the value of a Dynamic Block property (if present)
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; prp - [str] Dynamic Block property name (case-insensitive)
    (defun LM:getdynpropvalue ( blk prp )
        (setq prp (strcase prp))
        (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'value)))
            (vlax-invoke blk 'getdynamicblockproperties)
        )
    )
;;----------------------------------------------------------------------------
  ;; Set Dynamic Block Property Value  -  Lee Mac
  ;; Modifies the value of a Dynamic Block property (if present)
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; prp - [str] Dynamic Block property name (case-insensitive)
  ;; val - [any] New value for property
  ;; Returns: [any] New value if successful, else nil
    (defun LM:setdynpropvalue ( blk prp val )
        (setq prp (strcase prp))
        (vl-some
          '(lambda ( x )
                (if (= prp (strcase (vla-get-propertyname x)))
                    (progn
                        (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
                        (cond (val) (t))
                    )
                )
            )
            (vlax-invoke blk 'getdynamicblockproperties)
        )
    )
;;----------------------------------------------------------------------------
  ;; Set Dynamic Block Properties  -  Lee Mac
  ;; Modifies values of Dynamic Block properties using a supplied association list.
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; lst - [lst] Association list of ((<Property> . <Value>) ... )
  ;; Returns: nil
    (defun LM:setdynprops ( blk lst / itm )
        (setq lst (mapcar '(lambda ( x ) (cons (strcase (car x)) (cdr x))) lst))
        (foreach x (vlax-invoke blk 'getdynamicblockproperties)
            (if (setq itm (assoc (strcase (vla-get-propertyname x)) lst))
                (vla-put-value x (vlax-make-variant (cdr itm) (vlax-variant-type (vla-get-value x))))
            )
        )
    )
;;----------------------------------------------------------------------------
  ;; Get Dynamic Block Property Allowed Values  -  Lee Mac
  ;; Returns the allowed values for a specific Dynamic Block property.
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; prp - [str] Dynamic Block property name (case-insensitive)
  ;; Returns: [lst] List of allowed values for property, else nil if no restrictions
  (defun LM:getdynpropallowedvalues ( blk prp )
      (setq prp (strcase prp))
      (vl-some '(lambda ( x ) (if (= prp (strcase (vla-get-propertyname x))) (vlax-get x 'allowedvalues)))
          (vlax-invoke blk 'getdynamicblockproperties)
      )
  )
;;----------------------------------------------------------------------------
  ;; Get Dynamic Block Properties  -  Lee Mac
  ;; Returns an association list of Dynamic Block properties & values.
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; Returns: [lst] Association list of ((<prop> . <value>) ... )
    (defun LM:getdynprops ( blk )
        (mapcar '(lambda ( x ) (cons (vla-get-propertyname x) (vlax-get x 'value)))
            (vlax-invoke blk 'getdynamicblockproperties)
        )
    )
;;----------------------------------------------------------------------------
  ;; Toggle Dynamic Block Flip State  -  Lee Mac
  ;; Toggles the Flip parameter if present in a supplied Dynamic Block.
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; Return: [int] New Flip Parameter value
    (defun LM:toggleflipstate ( blk )
        (vl-some
          '(lambda ( prp / rtn )
                (if (equal '(0 1) (vlax-get prp 'allowedvalues))
                    (progn
                        (vla-put-value prp (vlax-make-variant (setq rtn (- 1 (vlax-get prp 'value))) vlax-vbinteger))
                        rtn
                    )
                )
            )
            (vlax-invoke blk 'getdynamicblockproperties)
        )
    )
;;----------------------------------------------------------------------------
  ;; Get Visibility Parameter Name  -  Lee Mac
  ;; Returns the name of the Visibility Parameter of a Dynamic Block (if present)
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; Returns: [str] Name of Visibility Parameter, else nil
  (defun LM:getvisibilityparametername ( blk / vis )  
      (if
          (and
              (vlax-property-available-p blk 'effectivename)
              (setq blk
                  (vla-item
                      (vla-get-blocks (vla-get-document blk))
                      (vla-get-effectivename blk)
                  )
              )
              (= :vlax-true (vla-get-isdynamicblock blk))
              (= :vlax-true (vla-get-hasextensiondictionary blk))
              (setq vis
                  (vl-some
                    '(lambda ( pair )
                          (if
                              (and
                                  (= 360 (car pair))
                                  (= "BLOCKVISIBILITYPARAMETER" (cdr (assoc 0 (entget (cdr pair)))))
                              )
                              (cdr pair)
                          )
                      )
                      (dictsearch
                          (vlax-vla-object->ename (vla-getextensiondictionary blk))
                          "ACAD_ENHANCEDBLOCK"
                      )
                  )
              )
          )
          (cdr (assoc 301 (entget vis)))
      )
  )
;;----------------------------------------------------------------------------
  ;; Get Dynamic Block Visibility State  -  Lee Mac
  ;; Returns the value of the Visibility Parameter of a Dynamic Block (if present)
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; Returns: [str] Value of Visibility Parameter, else nil
  (defun LM:getvisibilitystate ( blk / vis )
      (if (setq vis (LM:getvisibilityparametername blk))
          (LM:getdynpropvalue blk vis)
      )
  )
;;----------------------------------------------------------------------------
  ;; Set Dynamic Block Visibility State  -  Lee Mac
  ;; Sets the Visibility Parameter of a Dynamic Block (if present) to a specific value (if allowed)
  ;; blk - [vla] VLA Dynamic Block Reference object
  ;; val - [str] Visibility State Parameter value
  ;; Returns: [str] New value of Visibility Parameter, else nil
  (defun LM:SetVisibilityState ( blk val / vis )
      (if
          (and
              (setq vis (LM:getvisibilityparametername blk))
              (member (strcase val) (mapcar 'strcase (LM:getdynpropallowedvalues blk vis)))
          )
          (LM:setdynpropvalue blk vis val)
      )
  )
;;; ====================================================================================================
;;; END SOURCE: G_TNT_Block_Change_Vibisility_B1.lsp
;;; ====================================================================================================

;;; ====================================================================================================
;;; BEGIN SOURCE: H_TNT_Block_Cote_CA.lsp
;;; ====================================================================================================
;; Set Attribute Value  -  Lee Mac
;; Sets the value of the first attribute with the given tag found within the block, if present.
;; blk - [ent] Block (Insert) Entity Name
;; tag - [str] Attribute TagString
;; val - [str] Attribute Value
;; Returns: [str] Attribute value if successful, else nil.
(defun LM:setattributevalue ( blk tag val / end enx )
    (while
        (and
            (null end)
            (setq blk (entnext blk))
            (= "ATTRIB" (cdr (assoc 0 (setq enx (entget blk)))))
        )
        (if (= (strcase tag) (strcase (cdr (assoc 2 enx))))
            (if (entmod (subst (cons 1 val) (assoc 1 (reverse enx)) enx))
                (progn
                    (entupd blk)
                    (setq end val)
                )
            )
        )
    )
)


(DEFUN C:CA (/ BHT BHT1 ent blkName tagName toadogoc t1 t1a phantich ss1 lengss n blk1 t3 t4 cham leng1 sokytu)
  (setvar "MODEMACRO" "TNT Architecture")
  (setq BHT (getvar "LUPREC"))
  (setq BHT1 (setvar "LUPREC" 3))
  (while (not (and
		(setq ent (car (nentsel "\nSelect ATT in Block:")))
		(if ent (eq (cdr (assoc 0 (entget ent))) "ATTRIB") ) ) )
  (princ "\n Ban chon nham roi! "))
  (setq blkName (cdr (assoc 2 (entget (cdr (assoc 330 (entget ent))))))
	tagName (cdr (assoc 2 (entget ent))))
  (setq toadogoc(cadr(cdr(assoc 10 (entget (cdr (assoc 330 (entget ent))))))))
  (setq t1  (cdr(assoc 1 (entget ent))))	;text lay ra tu att
  (setq t1a (substr t1 1 1))
  (setq phantich (substr (cdr(assoc 1 (entget ent))) 1 3))		    		;trich bo dau + -
  (IF (= phantich "%%P")
    (setq giatrigoc (atof(substr t1 4)))       ;lay gia tri att
    	(IF (= t1a "+")
            (setq giatrigoc (atof(substr t1 2)))
	    (setq giatrigoc (* -1 (atof(substr t1 2))))))	

 ;PHAN TICH TOA DO DIEM X CUA BLOCK

;CHON BLOCK
(setq ss1 (ssget  (list (cons 0 "INSERT")(cons 66 1)'(-4 . "<NOT") (assoc 10 (entget (cdr (assoc 330 (entget ent))))) '(-4 . "NOT>")  )))	;CHON BLOCK CAO DO(cons -4 "<NOT") (cons -1 ent) (cons -4 "NOT>")
(setq lengss (sslength ss1))
(setq n 0)
(REPEAT lengss
  (setq blk1 (ssname ss1 n))
  (setq t3 (+ giatrigoc  (* 0.001    (- (cadr(cdr(assoc 10 (entget (ssname ss1 n))))) toadogoc))));kiem tra gia tri so voi cao do goc la am hay duong
  (setq t4 (rtos  t3))

;KIEM TRA TEXT THIEU BAO NHIEU SO
  (setq cham (vl-string-search "." t4)) ;kiem tra dau "."
  (IF (= cham nil)
    (setq t4 (strcat t4 ".000"))
    (progn
      (setq leng1 (strlen (substr t4 (+ cham 2))))
      (setq sokytu (- 3 leng1))				;so ky tu phia sau dau cham
      (REPEAT sokytu
	(setq t4 (strcat t4 "0")))))
    	
  (IF (minusp t3)					;neu gia tri am
  	(setq giatri t4)			;quy doi so thanh chu�i
  	(setq giatri (strcat "+" t4)))		;quy doi so thanh chu�i
  
  (LM:setattributevalue blk1 tagName giatri)
  (setq n (+ 1 n)))
  (setvar "LUPREC" BHT)
  )

  




    

  
;;; ====================================================================================================
;;; END SOURCE: H_TNT_Block_Cote_CA.lsp
;;; ====================================================================================================

(princ "`n[TNT] Loaded TNT_PACKAGE_10_BLOCK_ALL.lsp")
(princ)
