(defun C:FIM ( /
	AngleDegRoundOffMain
	CheckKeepChamfer
	CheckKeepFillet
	CheckRoundOffBlockAgain
	LengthNumVariable
	ListAngDegStd
	ListNameBlockAll
	ListNameBlockChange
	ListNameBlockLayout
	ListNameBlock_ListNameBlockGrand
	ListNameBlock_ListVlaObjectInsert
	ListNameBlock_NameBlockEffective
	ListNameBlock_ScalefactorBlockPop
	ListNameBlock_ScalefactorBlockRoundOff
	ListNameBlockGrand_ListVlaObjectArc
	ListNameBlockGrand_ListVlaObjectAttDef
	ListNameBlockGrand_ListVlaObjectCircle
	ListNameBlockGrand_ListVlaObjectDimension2LineAngular
	ListNameBlockGrand_ListVlaObjectDimension3PointAngular
	ListNameBlockGrand_ListVlaObjectDimensionAligned
	ListNameBlockGrand_ListVlaObjectDimensionArc
	ListNameBlockGrand_ListVlaObjectDimensionDiametric
	ListNameBlockGrand_ListVlaObjectDimensionFcf
	ListNameBlockGrand_ListVlaObjectDimensionOrdinate
	ListNameBlockGrand_ListVlaObjectDimensionRadial
	ListNameBlockGrand_ListVlaObjectDimensionRadialLarge
	ListNameBlockGrand_ListVlaObjectDimensionRotated
	ListNameBlockGrand_ListVlaObjectEllipseClose
	ListNameBlockGrand_ListVlaObjectEllipseOpen
	ListNameBlockGrand_ListVlaObjectHatch
	ListNameBlockGrand_ListVlaObjectInsert
	ListNameBlockGrand_ListVlaObjectLeader
	ListNameBlockGrand_ListVlaObjectLine
	ListNameBlockGrand_ListVlaObjectMLeader
	ListNameBlockGrand_ListVlaObjectMline
	ListNameBlockGrand_ListVlaObjectMText
	ListNameBlockGrand_ListVlaObjectOle2Frame
	ListNameBlockGrand_ListVlaObjectDgnReference
	ListNameBlockGrand_ListVlaObjectDwfReference
	ListNameBlockGrand_ListVlaObjectPdfReference
	ListNameBlockGrand_ListVlaObjectPoint
	ListNameBlockGrand_ListVlaObjectPolyline
	ListNameBlockGrand_ListVlaObjectRay
	ListNameBlockGrand_ListVlaObjectRasterImage
	ListNameBlockGrand_ListVlaObjectShape
	ListNameBlockGrand_ListVlaObjectSolid
	ListNameBlockGrand_ListVlaObjectSpline
	ListNameBlockGrand_ListVlaObjectTable
	ListNameBlockGrand_ListVlaObjectText
	ListNameBlockGrand_ListVlaObjectViewport
	ListNameBlockGrand_ListVlaObjectXline
	ListNameBlockGrand_ListVlaObjectXref
	ListNameBlockGrand_ListVlaObjectWipeout

	ListNameBlockLibrary
	ListNameBlockSelection
	ListNameBlockAddFix
	ListNameBlockFix

	ListNameBlockRoundOff
	ListNameBlockRoundOffTemp
	ListNumUnit_Unit
	ListVlaLayerLock
	ListVlaObjectUpdate
	ListVlaObjectInsert_NameBlockGrand
	List_CheckPointOriginal_NameVar_NameBlockBase
	List_NameBlockGrand_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1_NameVar_NameBlockBase
	List_NameBlockGrand_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2_NameVar_NameBlockBase
	ListVarSystem_OldValue
	NameVar1
	NameVar2
	Num1
	Num2
	NumDirMaxDoNotCheckLinear
	NumDirMaxCheckLinear
	NumRoundOffMaxMain
	NumRoundOffMinMain
	NumRoundOffSubdiv
	NumZero
	PointOriginalMain
	PiHalf
	PiDoub
	ReactorVlaBlockRoundOff
	SelectionSetObject
	SeedVarDay
	SeedVarMain
	StringSelectNameBlockFix
	UnitCurrent
	VlaBlocksGroup
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

		(setq NameSoftware "Fix Imprecise 2D Drawing")
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
	(LIC_REQUESTCODE)
	(setq LIC_REQUESTCODE nil)


	(vl-load-com)
	(RND_SET_VARSYSTEM)
	(setq VlaDrawingCurrent (vla-get-activedocument (vlax-get-acad-object)))
	(setq VlaBlocksGroup (vla-get-blocks VlaDrawingCurrent))
	(setq ListNumUnit_Unit
		(list
			(cons 0 "Unitless")
			(cons 1 "Inch")
			(cons 2 "Feet")
			(cons 3 "Mile")
			(cons 4 "Millimeter")
			(cons 5 "Centimeter")
			(cons 6 "Meter")
			(cons 7 "Kilometer")
			(cons 8 "Microinche")
			(cons 9 "Mil")
			(cons 10 "Yard")
			(cons 11 "Angstrom")
			(cons 12 "Nanometer")
			(cons 13 "Micron")
			(cons 14 "Decimeter")
			(cons 15 "Dekameter")
			(cons 16 "Hectometer")
			(cons 17 "Gigameter")
			(cons 18 "astronomical_unit")
			(cons 19 "Light_Year")
			(cons 20 "Parsec")
		)
	)
	(setq LengthNumVariable 13)
	(setq SeedVarDay (RND_CREATE_SEED 10 "DAY"))
	(setq SeedVarMain (RND_CREATE_SEED 10 "SEC"))
	(setq NumZero 0.000000001)
	(setq PiHalf (* 0.5 Pi))
	(setq PiDoub (* 2.0 Pi))
	(setq UnitCurrent (cdr (assoc (getvar "INSUNITS") ListNumUnit_Unit)))
	(setq NumDirMaxDoNotCheckLinear 150)
	(setq NumDirMaxCheckLinear 50)
	(RND_CHECK_PATHNAMEBLOCKEXLUDE PathNameBlockExclude)
	(RND_CREATE_LISTNAMEBLOCKLIBRARY)
	(RND_RUN_DIALOG_MAIN)

	(if SelectionSetObject
		(progn
			(vla-startundomark VlaDrawingCurrent)
			(RND_CREATE_LISTVLALAYERLOCK)
			(set (read (strcat "ListPointCheck" SeedVarDay)) Nil)
			(setq NameVar1 (read (strcat "ListNameBlockRoundOff" SeedVarDay)))
			(setq ListNameBlockRoundOff (eval NameVar1))
			(setq NameVar2 (read (strcat "ReactorVlaBlockRoundOff" SeedVarDay)))
			(setq ReactorVlaBlockRoundOff (eval NameVar2))
			(if ReactorVlaBlockRoundOff
				(vlr-remove ReactorVlaBlockRoundOff)
			)

			(RND_ANALYSIS_SELECTIONSETOBJECT)
			(foreach NameBlock ListNameBlockAll
				(RND_GET_SCALEFACTOR_NAMEBLOCK NameBlock)
			)
			(foreach NameBlock ListNameBlockAll
				(if (or CheckRoundOffBlockAgain (not (member NameBlock ListNameBlockRoundOff)))
					(if
						(and
							(/= (substr NameBlock 1 2) "*U")
							(or
								(member NameBlock ListNameBlockFix)
								(member NameBlock ListNameBlockLayout)
							)
						)
						(progn
							(setq ListNameBlockChange (cons NameBlock ListNameBlockChange))
							(if (not (member NameBlock ListNameBlockLayout))
								(setq ListNameBlockRoundOffTemp (cons NameBlock ListNameBlockRoundOffTemp))
							)
						)
					)
				)
			)
			(setq Num1 1)
			(setq Num2 (length ListNameBlockChange))
			(foreach NameBlock ListNameBlockChange
				(setvar "MODEMACRO" (strcat "Changing block: " NameBlock " .......... " (itoa Num1) "/" (itoa Num2)))
				(RND_ALL_OBJECT_IN_BLOCK NameBlock)
				(princ (strcat "\nBlock: \"" NameBlock "\" changed."))
				(setq Num1 (+ Num1 1))
			)

			(RND_RESET_LISTVLALAYERLOCK)

			(foreach VlaObjectUpdate ListVlaObjectUpdate
				(vla-update VlaObjectUpdate)
			)
			(RND_CREATE_FILEBLOCKEXLUDE)

			(setq ListNameBlockRoundOff (append ListNameBlockRoundOff ListNameBlockRoundOffTemp))
			(set NameVar1 ListNameBlockRoundOff)
			(if ListNameBlockRoundOff
				(set NameVar2 (vlr-object-reactor (mapcar '(lambda (x) (vla-item VlaBlocksGroup x)) ListNameBlockRoundOff) "ListNameBlockRoundOff" '((:vlr-objectClosed . RND_REMOVE_NAMEBLOCK_FROM_LISTNAMEBLOCKROUNDOFF))))
			)
			(C:SHOWPOINTCHECK)
			(vla-endundomark VlaDrawingCurrent)
		)
	)

	(mapcar
		'RND_RESET_LISTNAMEVAR
		(list
			List_CheckPointOriginal_NameVar_NameBlockBase
			List_Prior_NameVar_AngStd
			List_NameBlockGrand_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1_NameVar_NameBlockBase
			List_NameBlockGrand_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2_NameVar_NameBlockBase
		)
	)
	(RND_RESET_VARSYSTEM)
	(princ)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTNAMEBLOCKLIBRARY ( / OpenFile NameBlockLibrary)
	(setq OpenFile (open PathNameBlockExclude "R"))
	(if OpenFile
		(progn
			(while (setq NameBlockLibrary (read-line OpenFile))
				(setq NameBlockLibrary (vl-list->string (vl-string->list (strcase NameBlockLibrary))))
				(setq ListNameBlockLibrary (cons NameBlockLibrary ListNameBlockLibrary))
			)
			(close OpenFile)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_PATHNAMEBLOCKEXLUDE ( PathNameBlockExclude /
	Directory
	ListFolder
	PathCurrent)

	(setq Directory (vl-filename-directory PathNameBlockExclude))
	(setq ListFolder (RND_STRING_TO_LIST_NEW Directory "\\"))
	(setq PathCurrent "")
	(foreach Folder ListFolder
		(setq PathCurrent (strcat PathCurrent Folder "\\" ))
		(if (not (vl-file-directory-p PathCurrent))
			(vl-mkdir PathCurrent)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_FILEBLOCKEXLUDE ( / OpenFile)
	(setq OpenFile (open PathNameBlockExclude "W"))
	(foreach NameBlockLibrary ListNameBlockLibrary
		(write-line NameBlockLibrary openfile)
	)
	(close OpenFile)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_RUN_DIALOG_MAIN ( /
	Version)

	(setq Version "1.00")
	(RND_MAKE_FILE_DCL)
	(RND_LOAD_DIALOG)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_MAKE_FILE_DCL ( /
	DclFile
	DirectoryDes
	StringModeStandardUI
	CheckModeStandardUI)

	(setq StringModeStandardUI (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckModeStandardUI"))
	(if
		(or
			(not StringModeStandardUI)
			(and
				(/= StringModeStandardUI "0")
				(/= StringModeStandardUI "1")
			)
		)
		(setq StringModeStandardUI "1")
	)
	(if (= StringModeStandardUI "0")
		(setq CheckModeStandardUI Nil)
	)
	(if (= StringModeStandardUI "1")
		(setq CheckModeStandardUI T)
	)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckModeStandardUI" StringModeStandardUI)

	(setq DirectoryDes (strcat (getvar "roamablerootprefix") "Support"))
	(setq DclFile (open (strcat DirectoryDes "\\Fix Imprecise 2D Drawing.dcl") "w"))
	(write-line "///------------------------------------------------------------------------" DclFile)
	(write-line "///		Fix Imprecise 2D Drawing.dcl" DclFile)
	(write-line "FixImprecise2DDrawing:dialog{" DclFile)
	(write-line (strcat "label = \"Fix Imprecise 2D Drawing " Version "\";") DclFile)

	(write-line "	:boxed_column{" DclFile)
	(write-line "	label = \"Main\";" DclFile)
	(write-line "		:row{" DclFile)
	(write-line "			:button{" DclFile)
	(write-line "			key = \"Tile_SelectObject\";" DclFile)
	(write-line "			label = \"Select objects \";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(if (not CheckModeStandardUI)
		(progn
			(write-line "			:button{" DclFile)
			(write-line "			key = \"Tile_GetPointOrigin\";" DclFile)
			(write-line "			label = \"Pick base point\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)
		)
	)

	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		key = \"Tile_TextSelectObject\";" DclFile)
	(write-line "		width = 15;" DclFile)
	(write-line "			alignment = centered;" DclFile)
	(write-line "		}" DclFile)

	(if (not CheckModeStandardUI)
		(progn
			(write-line "		:text{" DclFile)
			(write-line "		key = \"Tile_TextGetPointOrigin\";" DclFile)
			(write-line "		width = 15;" DclFile)
			(write-line "		alignment = centered;" DclFile)
			(write-line "		}" DclFile)
		)
	)

	(write-line "	}" DclFile)

	(write-line "	:boxed_row{" DclFile)
	(write-line "	label = \"Rounding values\";" DclFile)
	(write-line "		:column{" DclFile)
	(write-line "			spacer_0;" dclfile)
	(write-line "			fixed_width = true;" DclFile)
	(write-line "			:text{" DclFile)
	(if CheckModeStandardUI
		(write-line "			label = \"   Spacing\";" DclFile)
		(write-line "			label = \"   Spacing max\";" DclFile)
	)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(if (not CheckModeStandardUI)
		(progn
			(write-line "			:text{" DclFile)
			(write-line "			label = \"   Spacing min\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)

			(write-line "			:text{" DclFile)
			(write-line "			label = \"   Spacing subdivs\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)
		)
	)

	(write-line "			:text{" DclFile)
	(write-line "			label = \"   Angle\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)


	(write-line "		:column{" DclFile)
	(write-line "			:edit_box{" DclFile)
	(write-line "			key = \"Tile_NumRoundOffMax\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(if (not CheckModeStandardUI)
		(progn
			(write-line "			:edit_box{" DclFile)
			(write-line "			key = \"Tile_NumRoundOffMin\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)

			(write-line "			:edit_box{" DclFile)
			(write-line "			key = \"Tile_NumRoundOffSubdiv\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)
		)
	)

	(write-line "			:edit_box{" DclFile)
	(write-line "			key = \"Tile_AngleDegRoundOff\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)

	(if (not CheckModeStandardUI)
		(progn
			(write-line "	:boxed_column{" DclFile)
			(write-line "	label = \"List priority angles\";" DclFile)
			(write-line "		:list_box{" DclFile)
			(write-line "		key = \"Tile_ListStdAng\";" DclFile)
			(write-line "		multiple_select = true;" DclFile)
			(write-line "		width = 15;" DclFile)
			(write-line "		height = 6;" DclFile)
			(write-line "		}" DclFile)

			(write-line "		:row{" DclFile)
			(write-line "			:button{" DclFile)
			(write-line "			key = \"Tile_DeleteStdAng\";" DclFile)
			(write-line "			label = \"Remove\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)

			(write-line "			:button{" DclFile)
			(write-line "			key = \"Tile_AddStdAng\";" DclFile)
			(write-line "			label = \"Add...\";" DclFile)
			(write-line "			width = 15;" DclFile)
			(write-line "			}" DclFile)
			(write-line "		}" DclFile)

			(write-line "	}" DclFile)

			(write-line "	:boxed_column{" DclFile)
			(write-line "	label = \"Behavior\";" DclFile)
			(write-line "		:toggle{" DclFile)
			(write-line "		label = \"Repair block that is fixed previous\";" DclFile)
			(write-line "		key = \"Tile_CheckRoundOffBlockAgain\";" DclFile)
			(write-line "		}" DclFile)

			(write-line "		:toggle{" DclFile)
			(write-line "		label = \"Keep tanginess of arcs\";" DclFile)
			(write-line "		key = \"Tile_CheckKeepFillet\";" DclFile)
			(write-line "		}" DclFile)

			(write-line "		:toggle{" DclFile)
			(write-line "		label = \"Keep distances chamfer\";" DclFile)
			(write-line "		key = \"Tile_CheckKeepChamfer\";" DclFile)
			(write-line "		}" DclFile)
			(write-line "	}" DclFile)
		)
	)

	(write-line "	:boxed_column{" DclFile)
	(write-line "	label = \"List blocks fix\";" DclFile)
	(write-line "		:list_box{" DclFile)
	(write-line "		key = \"Tile_ListBlockFix\";" DclFile)
	(write-line "		multiple_select = true;" DclFile)
	(write-line "		width = 15;" DclFile)
	(write-line "		height = 6;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:row{" DclFile)
	(write-line "			:button{" DclFile)
	(write-line "			key = \"Tile_DeleteBlockFix\";" DclFile)
	(write-line "			label = \"Remove\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)
	(write-line "			:button{" DclFile)
	(write-line "			key = \"Tile_AddBlockFix\";" DclFile)
	(write-line "			label = \"Add...\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)

	(write-line "	}" DclFile)

	(write-line "	:boxed_column{" DclFile)
	(write-line "		:row{" DclFile)
	(write-line "			:button{" DclFile)
	(write-line "			key = \"Tile_Reset\";" DclFile)
	(write-line "			label = \"Reset Setting\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(write-line "			:button{" DclFile)
	(write-line "			key = \"Tile_SwitchUI\";" DclFile)
	(if CheckModeStandardUI
		(write-line "			label = \"   Advanced UI   \";" DclFile)
		(write-line "			label = \"   Default UI    \";" DclFile)
	)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(write-line "		}" DclFile)

	(write-line "		:row{" DclFile)
	(write-line "			:button{" DclFile)
	(write-line "			label = \"&OK\";" DclFile)
	(write-line "			key = \"Ok\";" DclFile)
	(write-line "			is_default = true;" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(write-line "			:button{" DclFile)
	(write-line "			key = \"Cancel\";" DclFile)
	(write-line "			label = \"&Cancel\";" DclFile)
	(write-line "			is_cancel = true;" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(write-line "			:button{" DclFile)
	(write-line "			key = \"About\";" DclFile)
	(write-line "			label = \"&About\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)
	(write-line "}" DclFile)

	(write-line "/// About Dialog Box ----------------------------------------------" DclFile)
	(write-line "FixImprecise2DDrawingAbout:dialog{" DclFile)
	(write-line "label = \"Infomations\";" DclFile)
	(write-line "	:boxed_column{" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		label = \"Fix Imprecise 2D Drawing\";" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line (strcat "		label = \"Copyright © " Version "\";") DclFile)
	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		key = \"Tile_About_Separate1\";" DclFile)
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
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:text{" DclFile)
	(write-line "		key = \"Tile_About_Separate2\";" DclFile)
	(write-line "		}" DclFile)
	(write-line "		:paragraph{" DclFile)
	(write-line "		width = 55;" DclFile)
	(write-line "			:text_part{" DclFile)
	(write-line "			value = \"Any comments please send email to phamhoangnhat@gmail.com.\";" DclFile)
	(write-line "			}" DclFile)
	(write-line "			:text_part{" DclFile)
	(write-line "			value = \"Thank you for using and supporting.\";" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	(write-line "	}" DclFile)
	(write-line "	:button{" DclFile)
	(write-line "	label = \"&OK\";" DclFile)
	(write-line "	key = \"Tile_About_Ok\";" DclFile)
	(write-line "	is_default = true;" DclFile)
	(write-line "	is_cancel = true;" DclFile)
	(write-line "	width = 15;" DclFile)
	(write-line "	}" DclFile)
	(write-line "}" DclFile)

	(write-line "/// Select Block Fix Dialog Box ----------------------------------------------" DclFile)
	(write-line "SelectBlockFix:dialog{" DclFile)
	(write-line "label = \"Select Block Fix\";" DclFile)

	(write-line "		:list_box{" DclFile)
	(write-line "		key = \"Tile_ListBlockAddFix\";" DclFile)
	(write-line "		multiple_select = true;" DclFile)
	(write-line "		width = 15;" DclFile)
	(write-line "		height = 20;" DclFile)
	(write-line "		}" DclFile)

	(write-line "		:row{" DclFile)

	(write-line "			:button{" DclFile)
	(write-line "			label = \"&Select\";" DclFile)
	(write-line "			key = \"Tile_AddFix_Select\";" DclFile)
	(write-line "			is_default = true;" DclFile)
	(write-line "			is_cancel = true;" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(write-line "			:button{" DclFile)
	(write-line "			label = \"&Select All\";" DclFile)
	(write-line "			key = \"Tile_AddFixAll_Select\";" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)

	(write-line "			:button{" DclFile)
	(write-line "			key = \"Tile_Cancel_Select\";" DclFile)
	(write-line "			label = \"&Cancel\";" DclFile)
	(write-line "			is_cancel = true;" DclFile)
	(write-line "			width = 15;" DclFile)
	(write-line "			}" DclFile)
	(write-line "		}" DclFile)
	
	(write-line "}" DclFile)

	(close DclFile)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_LOAD_DIALOG ( /
	End_Dialog
	Main_DCL)

	(setq Main_DCL (load_dialog "Fix Imprecise 2D Drawing.dcl"))
	(new_dialog "FixImprecise2DDrawing" Main_DCL)

	(RND_SET_TILE_TEXTSELECTOBJECT)
	(RND_SET_TILE_TEXTGETPOINTORIGIN)
	(RND_SET_TILE_SPACING)
	(RND_SET_TILE_ANGLE)
	(RND_SET_TILE_BLOCKFIX)
	(RND_SET_TILE_CHECKROUNDOFFBLOCKAGAIN)
	(RND_SET_TILE_CHECKKEEPFILLET)
	(RND_SET_TILE_CHECKKEEPCHAMFER)
	(RND_SET_TILE_OK)

	(action_tile "Tile_SelectObject"			"(done_dialog 2)")
	(action_tile "Tile_GetPointOrigin"			"(done_dialog 3)")
	(action_tile "Tile_NumRoundOffMax"			"(RND_GET_TILE_NUMROUNDOFFMAX)")
	(action_tile "Tile_NumRoundOffMin"			"(RND_GET_TILE_NUMROUNDOFFMIN)")
	(action_tile "Tile_NumRoundOffSubdiv"		"(RND_GET_TILE_NUMROUNDOFFSUBDIV)")
	(action_tile "Tile_AngleDegRoundOff"		"(RND_GET_TILE_ANGLEDEGROUNDOFFMAIN)")
	(action_tile "Tile_AddStdAng"				"(done_dialog 4)")
	(action_tile "Tile_DeleteStdAng"			"(RND_GET_TILE_DELETESTDANG)")
	(action_tile "Tile_ListBlockFix"			"(RND_GET_TILE_BLOCKFIX)")
	(action_tile "Tile_AddBlockFix"				"(RND_GET_TILE_ADDBLOCKFIX)")
	(action_tile "Tile_DeleteBlockFix"			"(RND_GET_TILE_DELETEBLOCKFIX)")
	(action_tile "About"						"(RND_SET_TILE_ABOUT)")
	(action_tile "Tile_CheckRoundOffBlockAgain"	"(RND_GET_TILE_CHECKROUNDOFFBLOCKAGAIN)")
	(action_tile "Tile_CheckKeepFillet"			"(RND_GET_TILE_CHECKKEEPFILLET)")
	(action_tile "Tile_CheckKeepChamfer"		"(RND_GET_TILE_CHECKKEEPCHAMFER)")
	(action_tile "Tile_Reset"					"(RND_GET_TILE_RESET)")
	(action_tile "Tile_SwitchUI"				"(done_dialog 5)")
	(action_tile "Ok"							"(done_dialog 1)")
	(action_tile "Cancel"						"(done_dialog 0)")
	(action_tile "About"						"(RND_SET_TILE_ABOUT)")

	(setq End_Dialog (start_dialog))
	(cond
		(
			(= End_Dialog 0)
			(setq SelectionSetObject Nil)
			(setq PointOriginalMain Nil)
			(unload_dialog Main_DCL)
		)

		(
			(= End_Dialog 1)
			(unload_dialog Main_DCL)
		)

		(
			(= End_Dialog 2)
			(unload_dialog Main_DCL)
			(RND_GET_TILE_SELECTOBJECT)
			(RND_LOAD_DIALOG)
		)

		(
			(= End_Dialog 3)
			(unload_dialog Main_DCL)
			(RND_GET_TILE_GETPOINTORIGIN)
			(RND_LOAD_DIALOG)
		)

		(
			(= End_Dialog 4)
			(unload_dialog Main_DCL)
			(RND_GET_TILE_ADDSTDANG)
			(RND_LOAD_DIALOG)
		)

		(
			(= End_Dialog 5)
			(unload_dialog Main_DCL)
			(RND_GET_TILE_SWITCHUI)
			(RND_LOAD_DIALOG)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_SELECTOBJECT ( / )
	(vl-catch-all-apply '(lambda ( / )
		(if
			(and
				SelectionSetObject
				(> (sslength SelectionSetObject) 0)
			)
			(progn
				(command "_.SELECT" SelectionSetObject)
				(while (> (getvar 'CMDACTIVE) 0) (command PAUSE))
				(setq SelectionSetObject (ssget "_P"))
			)
			(setq SelectionSetObject (ssget))
		)
		(RND_CREATE_LISTNAMEBLOCKSELECTION)
	))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTNAMEBLOCKSELECTION ( / Num VlaObject)
	(setq ListNameBlockSelection Nil)
	(setq Num 0)
	(if SelectionSetObject
		(repeat (sslength SelectionSetObject)
			(setq VlaObject (vlax-ename->vla-object (ssname SelectionSetObject Num)))
			(RND_CREATE_LISTNAMEBLOCKSELECTION_FROM_VLAOBJECT VlaObject)
			(setq Num (+ Num 1))
		)
	)
	(setq ListNameBlockSelection (vl-sort ListNameBlockSelection '<))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTNAMEBLOCKSELECTION_FROM_VLAOBJECT ( VlaObject /
	NameBlock
	ObjectType
	VlaBlock
	VlaObjectInBlock)

	(setq ObjectType (vla-get-objectname VlaObject))
	(if
		(and
			(= ObjectType "AcDbBlockReference")
			(setq NameBlock (RND_GET_EFFECTIVENAME_BLOCK VlaObject))
			(setq VlaBlock (vla-item VlaBlocksGroup NameBlock))
			(= (vla-get-isxref VlaBlock) :vlax-false)
		)
		(progn
			(if
				(not (member NameBlock ListNameBlockSelection))
				(progn
					(setq ListNameBlockSelection (cons NameBlock ListNameBlockSelection))
					(vlax-for VlaObjectInBlock VlaBlock
						(RND_CREATE_LISTNAMEBLOCKSELECTION_FROM_VLAOBJECT VlaObjectInBlock)
					)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_TEXTSELECTOBJECT ( / NumObject)
	(if SelectionSetObject
		(progn
			(setq NumObject (sslength SelectionSetObject))
			(if (> NumObject 1)
				(set_tile "Tile_TextSelectObject" (strcat (itoa NumObject) " objects selected"))
				(set_tile "Tile_TextSelectObject" (strcat (itoa NumObject) " object selected"))
			)
		)
		(set_tile "Tile_TextSelectObject" "No object selected")
	)
	
	(mode_tile "Tile_TextSelectObject" 1)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_GETPOINTORIGIN ( /
	NameVar
	PointOriginalMainTemp
	Temp)
	(vl-catch-all-apply '(lambda ( / )
		(setq NameVar (read (strcat "PointOriginalMain" SeedVarDay)))
		(if (setq Temp (eval NameVar))
			(setq PointOriginalMainTemp (trans Temp 0 1))
			(setq PointOriginalMainTemp (list 0.0 0.0 0.0))
		)	
		(setq Temp (getpoint (strcat "\nSpecify base point or [Setting] <" (rtos (nth 0 PointOriginalMainTemp) 2) " " (rtos (nth 1 PointOriginalMainTemp) 2) " " (rtos 0.0 2) ">:")))
		(if Temp
			(setq PointOriginalMain (trans Temp 1 0))
			(setq PointOriginalMain (trans PointOriginalMainTemp 1 0))
		)
		(set NameVar PointOriginalMain)
	))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_TEXTGETPOINTORIGIN ( /
	NameVar
	PointOriginalMainTemp
	Temp)

	(setq NameVar (read (strcat "PointOriginalMain" SeedVarDay)))
	(if (setq Temp (eval NameVar))
		(setq PointOriginalMainTemp (trans Temp 0 1))
		(setq PointOriginalMainTemp (list 0.0 0.0 0.0))	
	)
	(set_tile "Tile_TextGetPointOrigin" (strcat "X: " (rtos (nth 0 PointOriginalMainTemp) 2) "   Y: " (rtos (nth 1 PointOriginalMainTemp) 2)))
	(mode_tile "Tile_TextGetPointOrigin" 1)

	(setq PointOriginalMain (trans PointOriginalMainTemp 1 0))
	(set NameVar PointOriginalMain)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_SPACING ( /
	CheckReset
	StringRoundOffMaxMain
	StringRoundOffMinMain
	StringRoundOffSubdiv
	Temp)

	(if (not CheckReset)
		(progn
			(setq StringRoundOffMaxMain (RND_CHECK_STRING_IS_NUMBER (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMaxMain")))
			(if StringRoundOffMaxMain
				(setq Temp (atof StringRoundOffMaxMain))
			)
			(if (and Temp (> Temp 0.0))
				(setq NumRoundOffMaxMain Temp)
				(setq CheckReset T)
			)
		)
	)

	(if (not CheckReset)
		(progn
			(setq StringRoundOffMinMain (RND_CHECK_STRING_IS_NUMBER (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMinMain")))
			(if StringRoundOffMinMain
				(setq Temp (atof StringRoundOffMinMain))
			)
			(if (and Temp (> Temp 0.0))
				(setq NumRoundOffMinMain Temp)
				(setq CheckReset T)
			)
		)
	)

	(if (not CheckReset)
		(progn
			(setq StringRoundOffSubdiv (RND_CHECK_STRING_IS_NUMBER (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffSubdiv")))
			(if StringRoundOffSubdiv
				(setq Temp (atof StringRoundOffSubdiv))
			)
			(if (and Temp (> Temp 1.0))
				(setq NumRoundOffSubdiv Temp)
				(setq CheckReset T)
			)
		)
	)

	(if (not CheckReset)
		(progn
			(if (>= NumRoundOffMaxMain NumRoundOffMinMain)
				(setq Temp (/ NumRoundOffMaxMain (expt NumRoundOffSubdiv (atoi (rtos (/ (log (/ NumRoundOffMaxMain NumRoundOffMinMain)) (log NumRoundOffSubdiv)) 2 0)))))
				(setq Temp NumRoundOffMaxMain)	
			)
			(if (> Temp 0.0)
				(progn
					(setq NumRoundOffMinMain Temp)
					(setq StringRoundOffMinMain (rtos NumRoundOffMinMain 2 LengthNumVariable))
				)
				(setq CheckReset T)
			)	
		)
	)

	(if CheckReset
		(progn
			(Setq NumRoundOffMaxMain 5.0)
			(Setq NumRoundOffMinMain 0.0005)
			(Setq NumRoundOffSubdiv 10.0)
			(setq StringRoundOffMaxMain (rtos NumRoundOffMaxMain 2 LengthNumVariable))
			(setq StringRoundOffMinMain (rtos NumRoundOffMinMain 2 LengthNumVariable))
			(setq StringRoundOffSubdiv (rtos NumRoundOffSubdiv 2 LengthNumVariable))
		)
	)

	(set_tile "Tile_NumRoundOffMax" StringRoundOffMaxMain)
	(set_tile "Tile_NumRoundOffMin" StringRoundOffMinMain)
	(set_tile "Tile_NumRoundOffSubdiv" StringRoundOffSubdiv)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMaxMain" StringRoundOffMaxMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMinMain" StringRoundOffMinMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffSubdiv" StringRoundOffSubdiv)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_NUMROUNDOFFMIN ( NumRoundOffMaxMainTemp NumRoundOffMinMainTemp NumRoundOffSubdivTemp / NumRoundOffMinMainCheck)
	(if (>= NumRoundOffMaxMainTemp NumRoundOffMinMainTemp)
		(setq NumRoundOffMinMainCheck (/ NumRoundOffMaxMainTemp (expt NumRoundOffSubdivTemp (atoi (rtos (/ (log (/ NumRoundOffMaxMainTemp NumRoundOffMinMainTemp)) (log NumRoundOffSubdivTemp)) 2 0)))))
		(setq NumRoundOffMinMainCheck NumRoundOffMaxMainTemp)	
	)
	(if (<= (atof (rtos NumRoundOffMinMainCheck 2 LengthNumVariable)) 0.0)
		(setq NumRoundOffMinMainCheck Nil)
	)
	NumRoundOffMinMainCheck
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_NUMROUNDOFFMAX ( /
	NumRoundOffMaxMainTemp
	NumRoundOffMinMainTemp
	StringRoundOffMaxMain
	StringRoundOffMinMain)

	(setq StringRoundOffMaxMain (RND_CHECK_STRING_IS_NUMBER (get_tile "Tile_NumRoundOffMax")))
	(if StringRoundOffMaxMain
		(setq NumRoundOffMaxMainTemp (atof StringRoundOffMaxMain))
	)
	(if
		(and
			NumRoundOffMaxMainTemp
			(> NumRoundOffMaxMainTemp 0.0)
			(setq NumRoundOffMinMainTemp (RND_CHECK_NUMROUNDOFFMIN NumRoundOffMaxMainTemp NumRoundOffMinMain NumRoundOffSubdiv))
		)
		(progn
			(setq NumRoundOffMaxMain NumRoundOffMaxMainTemp)
			(setq NumRoundOffMinMain NumRoundOffMinMainTemp)
		)
		(setq StringRoundOffMaxMain (rtos NumRoundOffMaxMain 2 LengthNumVariable))
	)
	(setq StringRoundOffMinMain (rtos NumRoundOffMinMain 2 LengthNumVariable))

	(set_tile "Tile_NumRoundOffMax" StringRoundOffMaxMain)
	(set_tile "Tile_NumRoundOffMin" StringRoundOffMinMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMaxMain" StringRoundOffMaxMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMinMain" StringRoundOffMinMain)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_NUMROUNDOFFMIN ( /
	NumRoundOffMinMainTemp
	StringRoundOffMinMain)

	(setq StringRoundOffMinMain (RND_CHECK_STRING_IS_NUMBER (get_tile "Tile_NumRoundOffMin")))
	(if StringRoundOffMinMain
		(setq NumRoundOffMinMainTemp (atof StringRoundOffMinMain))
	)
	(if
		(and
			NumRoundOffMinMainTemp
			(> NumRoundOffMinMainTemp 0.0)
			(setq NumRoundOffMinMainTemp (RND_CHECK_NUMROUNDOFFMIN NumRoundOffMaxMain NumRoundOffMinMainTemp NumRoundOffSubdiv))
		)
		(setq NumRoundOffMinMain NumRoundOffMinMainTemp)
		(setq StringRoundOffMinMain (rtos NumRoundOffMinMain 2 LengthNumVariable))
	)

	(set_tile "Tile_NumRoundOffMin" StringRoundOffMinMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMinMain" StringRoundOffMinMain)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_NUMROUNDOFFSUBDIV ( /
	NumRoundOffMinMainTemp
	NumRoundOffSubdivTemp
	StringRoundOffSubdiv
	StringRoundOffMinMain)

	(setq StringRoundOffSubdiv (RND_CHECK_STRING_IS_NUMBER (get_tile "Tile_NumRoundOffSubdiv")))
	(if StringRoundOffSubdiv
		(setq NumRoundOffSubdivTemp (atof StringRoundOffSubdiv))
	)
	(if
		(and
			NumRoundOffSubdivTemp
			(> NumRoundOffSubdivTemp 1.0)
			(setq NumRoundOffMinMainTemp (RND_CHECK_NUMROUNDOFFMIN NumRoundOffMaxMain NumRoundOffMinMain NumRoundOffSubdivTemp))
		)
		(progn
			(setq NumRoundOffSubdiv NumRoundOffSubdivTemp)
			(setq NumRoundOffMinMain NumRoundOffMinMainTemp)
		)
		(setq StringRoundOffSubdiv (rtos NumRoundOffSubdiv 2 LengthNumVariable))
	)
	(setq StringRoundOffMinMain (rtos NumRoundOffMinMain 2 LengthNumVariable))

	(set_tile "Tile_NumRoundOffSubdiv" StringRoundOffSubdiv)
	(set_tile "Tile_NumRoundOffMin" StringRoundOffMinMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffSubdiv" StringRoundOffSubdiv)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMinMain" StringRoundOffMinMain)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_ANGLE ( /
	StringAngleDegRoundOffMain
	Temp)

	(setq StringAngleDegRoundOffMain (RND_CHECK_STRING_IS_NUMBER (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "AngleDegRoundOffMain")))
	(if StringAngleDegRoundOffMain
		(setq Temp (atof StringAngleDegRoundOffMain))
	)
	(if
		(and
			Temp
			(> Temp 0.0)
			(<= Temp 90.0)
		)
		(setq AngleDegRoundOffMain Temp)
		(progn
			(setq AngleDegRoundOffMain 0.5)
			(setq StringAngleDegRoundOffMain (rtos AngleDegRoundOffMain 2 LengthNumVariable))
		)	
	)
	(set_tile "Tile_AngleDegRoundOff" StringAngleDegRoundOffMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "AngleDegRoundOffMain" StringAngleDegRoundOffMain)

	(setq StringListAngDegStd (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "ListAngDegStd"))
	(if StringListAngDegStd
		(progn
			(setq ListAngDegStd (mapcar 'RND_CHECK_STRING_IS_NUMBER (RND_STRING_TO_LIST_NEW  StringListAngDegStd " ")))
			(setq ListAngDegStd (mapcar 'atof (vl-remove Nil ListAngDegStd)))
		)
		(setq ListAngDegStd (list 0.0 90.0 45.0 135.0))
	)
	(RND_CHECK_LISTANGDEGSTD_AND_SET_TILE_LISTSTDANG)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_ANGLEDEGROUNDOFFMAIN ( /
	AngleDegRoundOffMainTemp
	StringAngleDegRoundOffMain)

	(setq StringAngleDegRoundOffMain (RND_CHECK_STRING_IS_NUMBER (get_tile "Tile_AngleDegRoundOff")))
	(if StringAngleDegRoundOffMain
		(setq AngleDegRoundOffMainTemp (atof StringAngleDegRoundOffMain))
	)
	(if
		(and
			AngleDegRoundOffMainTemp
			(> AngleDegRoundOffMainTemp 0.0)
			(<= AngleDegRoundOffMainTemp 90.0)
		)
		(setq AngleDegRoundOffMain AngleDegRoundOffMainTemp)
		(setq StringAngleDegRoundOffMain (rtos AngleDegRoundOffMain 2 LengthNumVariable))
	)
	(set_tile "Tile_AngleDegRoundOff" StringAngleDegRoundOffMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "AngleDegRoundOffMain" StringAngleDegRoundOffMain)
	(RND_CHECK_LISTANGDEGSTD_AND_SET_TILE_LISTSTDANG)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_ADDSTDANG ( / AngDegStd StringListAngDegStd)
	(setq AngDegStd (getangle))
	(if AngDegStd
		(progn
			(setq AngDegStd (RND_ROUNDOFF_NUMBER (RND_RADIAN_TO_DEGREE AngDegStd) AngleDegRoundOffMain))
			(while (>= AngDegStd 180.0)
				(setq AngDegStd (- AngDegStd 180.0))
			)
			(if (not (member AngDegStd ListAngDegStd))
				(progn
					(setq ListAngDegStd (append ListAngDegStd (list AngDegStd)))
					(setq StringListAngDegStd "")
					(foreach Temp ListAngDegStd
						(setq StringListAngDegStd (strcat StringListAngDegStd " " (rtos Temp 2)))
					)
					(setq StringListAngDegStd (substr StringListAngDegStd 2))
					(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "ListAngDegStd" StringListAngDegStd)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_DELETESTDANG ( / StringListAngDegStd ListAngDegStdTemp)
	(setq ListAngDegStdTemp ListAngDegStd)
	(foreach Num (mapcar 'atoi (RND_STRING_TO_LIST_NEW (get_tile "Tile_ListStdAng") " "))				
		(setq ListAngDegStdTemp (vl-remove (nth Num ListAngDegStd) ListAngDegStdTemp))
	)
	(setq ListAngDegStd ListAngDegStdTemp)

	(setq StringListAngDegStd "")
	(foreach Temp ListAngDegStd
		(setq StringListAngDegStd (strcat StringListAngDegStd " " (rtos Temp 2 LengthNumVariable)))
	)
	(setq StringListAngDegStd (substr StringListAngDegStd 2))
	(RND_LOAD_POPUP_LIST "Tile_ListStdAng" (mapcar '(lambda (x) (rtos x 2 LengthNumVariable)) ListAngDegStd))
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "ListAngDegStd" StringListAngDegStd)

	(if ListAngDegStd
		(set_tile "Tile_ListStdAng" "0")
		(set_tile "Tile_ListStdAng" "")
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_BLOCKFIX ( / NameBlock )
	(setq ListNameBlockFix Nil)
	(foreach NameBlock ListNameBlockSelection
		(if (not (member (strcase NameBlock) ListNameBlockLibrary))
			(setq ListNameBlockFix (cons NameBlock ListNameBlockFix))
		)
	)
	(setq ListNameBlockFix (vl-sort ListNameBlockFix '<))

	(RND_LOAD_POPUP_LIST "Tile_ListBlockFix" ListNameBlockFix)
	(if ListNameBlockFix
		(setq StringSelectNameBlockFix "0")
		(setq StringSelectNameBlockFix "")
	)
	(set_tile "Tile_ListBlockFix" StringSelectNameBlockFix)
	(RND_SET_TILE_ADDBLOCKFIX)
	(RND_SET_TILE_DELETEBLOCKFIX)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_BLOCKFIX ( / )
	(setq StringSelectNameBlockFix (get_tile "Tile_ListBlockFix"))
	(RND_SET_TILE_DELETEBLOCKFIX)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_DELETEBLOCKFIX ( / )
	(if
		(and
			StringSelectNameBlockFix
			(/= StringSelectNameBlockFix "")
			ListNameBlockFix
		)
		(mode_tile "Tile_DeleteBlockFix" 0)
		(mode_tile "Tile_DeleteBlockFix" 1)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_DELETEBLOCKFIX ( /
	NameBlock
	ListNameBlockFixTemp)
	
	(setq ListNameBlockFixTemp ListNameBlockFix)
	(foreach Pos (mapcar 'atoi (RND_STRING_TO_LIST_NEW StringSelectNameBlockFix " "))
		(setq NameBlock (nth Pos ListNameBlockFix))
		(setq ListNameBlockFixTemp (vl-remove NameBlock ListNameBlockFixTemp))
		(setq ListNameBlockLibrary (cons (strcase NameBlock) ListNameBlockLibrary))
	)
	(setq ListNameBlockFix ListNameBlockFixTemp)
	(RND_LOAD_POPUP_LIST "Tile_ListBlockFix" ListNameBlockFix)
	(if ListNameBlockFix
		(setq StringSelectNameBlockFix "0")
		(setq StringSelectNameBlockFix "")
	)
	(set_tile "Tile_ListBlockFix" StringSelectNameBlockFix)
	(RND_SET_TILE_ADDBLOCKFIX)
	(RND_SET_TILE_DELETEBLOCKFIX)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_ADDBLOCKFIX ( / )

	(setq ListNameBlockAddFix Nil)
	(foreach NameBlockSelection ListNameBlockSelection
		(if (not (member NameBlockSelection ListNameBlockFix))
			(setq ListNameBlockAddFix (cons NameBlockSelection ListNameBlockAddFix))
		)
	)
	(setq ListNameBlockAddFix (vl-sort ListNameBlockAddFix '<))

	(if ListNameBlockAddFix
		(mode_tile "Tile_AddBlockFix" 0)
		(mode_tile "Tile_AddBlockFix" 1)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_ADDBLOCKFIX ( /
	NameBlockAdd
	SelectBlockFix_DCL
	SelectBlockFix_End_Dialog
	StringSelectNameBlockAddFix)

	(setq SelectBlockFix_DCL (load_dialog "Fix Imprecise 2D Drawing.dcl"))
	(new_dialog "SelectBlockFix" SelectBlockFix_DCL)

	(RND_SET_TILE_LISTBLOCKADDFIX)

	(action_tile "Tile_ListBlockAddFix"			"(RND_GET_TILE_LISTBLOCKADDFIX)")
	(action_tile "Tile_AddFix_Select"			"(RND_GET_TILE_ADDFIX_SELECT)")
	(action_tile "Tile_AddFixAll_Select"		"(RND_GET_TILE_ADDFIXALL_SELECT)")
	(action_tile "Tile_Cancel_Select"			"(done_dialog 0)")
	(setq SelectBlockFix_End_Dialog (start_dialog))
	
	(cond
		(
			(= SelectBlockFix_End_Dialog 0)
			(unload_dialog SelectBlockFix_DCL)
		)

		(
			(= SelectBlockFix_End_Dialog 1)
			(unload_dialog SelectBlockFix_DCL)
			(foreach Pos (mapcar 'atoi (RND_STRING_TO_LIST_NEW StringSelectNameBlockAddFix " "))
				(setq NameBlockAddFix (nth Pos ListNameBlockAddFix))
				(setq ListNameBlockLibrary (vl-remove (strcase NameBlockAddFix) ListNameBlockLibrary))
			)
			(RND_SET_TILE_BLOCKFIX)
		)

		(
			(= SelectBlockFix_End_Dialog 2)
			(unload_dialog SelectBlockFix_DCL)
			(foreach NameBlockAddFix ListNameBlockAddFix
				(setq ListNameBlockLibrary (vl-remove (strcase NameBlockAddFix) ListNameBlockLibrary))
			)
			(RND_SET_TILE_BLOCKFIX)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_LISTBLOCKADDFIX ( / )
	(RND_LOAD_POPUP_LIST "Tile_ListBlockAddFix" ListNameBlockAddFix)
	(setq StringSelectNameBlockAddFix "0")
	(set_tile "Tile_ListBlockAddFix" StringSelectNameBlockAddFix)
	(RND_SET_TILE_ADDFIX_SELECT)
	(RND_SET_TILE_ADDFIXALL_SELECT)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_LISTBLOCKADDFIX ( / )
	(setq StringSelectNameBlockAddFix (get_tile "Tile_ListBlockAddFix"))
	(RND_SET_TILE_ADDFIX_SELECT)
	(RND_SET_TILE_ADDFIXALL_SELECT)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_ADDFIX_SELECT ( / )
	(if
		(and
			ListNameBlockAddFix
			StringSelectNameBlockAddFix
			(/= StringSelectNameBlockAddFix "")
		)
		(mode_tile "Tile_AddFix_Select" 0)
		(mode_tile "Tile_AddFix_Select" 1)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_ADDFIX_SELECT ( / )
	(done_dialog 1)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_ADDFIXALL_SELECT ( / )
	(if
		ListNameBlockAddFix
		(mode_tile "Tile_AddFixAll_Select" 0)
		(mode_tile "Tile_AddFixAll_Select" 1)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_ADDFIXALL_SELECT ( / )
	(done_dialog 2)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_LOAD_POPUP_LIST ( KeyTile ListString / )
	(start_list KeyTile 3)
	(mapcar 'add_list ListString)
	(end_list)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_STRING_TO_LIST_NEW (Stg Del / LenDel StgTemp Pos StgSub StgSubTemp ListString)
	(if Stg
		(progn
			(setq LenDel (strlen Del))
			(setq StgTemp Stg)
			(while (setq Pos (vl-string-search Del StgTemp))
				(setq StgSub (substr StgTemp 1 Pos))
				(setq StgTemp (substr StgTemp (+ Pos 1 LenDel)))
				(setq StgSubTemp StgSub)
				(setq StgSubTemp (vl-string-trim " " StgSubTemp))
				(setq StgSubTemp (vl-string-trim "\t" StgSubTemp))
				(if (/= StgSubTemp "")
					(setq ListString (cons StgSub ListString))
				)
			)
			(setq StgSub StgTemp)
			(setq StgSubTemp StgSub)
			(setq StgSubTemp (vl-string-trim " " StgSubTemp))
			(setq StgSubTemp (vl-string-trim "\t" StgSubTemp))
			(if (/= StgSubTemp "")
				(setq ListString (cons StgSub ListString))
			)
			(setq ListString (reverse ListString))
		)
	)
	ListString
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_CHECKROUNDOFFBLOCKAGAIN ( / StringRoundOffBlockAgain)
	(setq StringRoundOffBlockAgain (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckRoundOffBlockAgain"))
	(if
		(or
			(not StringRoundOffBlockAgain)
			(and
				(/= StringRoundOffBlockAgain "0")
				(/= StringRoundOffBlockAgain "1")
			)
		)
		(setq StringRoundOffBlockAgain "0")
	)
	(if (= StringRoundOffBlockAgain "0")
		(setq CheckRoundOffBlockAgain Nil)
	)
	(if (= StringRoundOffBlockAgain "1")
		(setq CheckRoundOffBlockAgain T)
	)
	(set_tile "Tile_CheckRoundOffBlockAgain" StringRoundOffBlockAgain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckRoundOffBlockAgain" StringRoundOffBlockAgain)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_CHECKROUNDOFFBLOCKAGAIN ( / StringRoundOffBlockAgain)
	(setq StringRoundOffBlockAgain (get_tile "Tile_CheckRoundOffBlockAgain"))
	(if (= StringRoundOffBlockAgain "0")
		(setq CheckRoundOffBlockAgain Nil)
	)
	(if (= StringRoundOffBlockAgain "1")
		(setq CheckRoundOffBlockAgain T)
	)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckRoundOffBlockAgain" StringRoundOffBlockAgain)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_CHECKKEEPFILLET ( / StringKeepFillet)
	(setq StringKeepFillet (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepFillet"))
	(if
		(or
			(not StringKeepFillet)
			(and
				(/= StringKeepFillet "0")
				(/= StringKeepFillet "1")
			)
		)
		(setq StringKeepFillet "1")
	)
	(if (= StringKeepFillet "0")
		(setq CheckKeepFillet Nil)
	)
	(if (= StringKeepFillet "1")
		(setq CheckKeepFillet T)
	)
	(set_tile "Tile_CheckKeepFillet" StringKeepFillet)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepFillet" StringKeepFillet)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_CHECKKEEPFILLET ( / StringKeepFillet)
	(setq StringKeepFillet (get_tile "Tile_CheckKeepFillet"))
	(if (= StringKeepFillet "0")
		(setq CheckKeepFillet Nil)
	)
	(if (= StringKeepFillet "1")
		(setq CheckKeepFillet T)
	)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepFillet" StringKeepFillet)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_CHECKKEEPCHAMFER ( / StringKeepChamfer)
	(setq StringKeepChamfer (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepChamfer"))
	(if
		(or
			(not StringKeepChamfer)
			(and
				(/= StringKeepChamfer "0")
				(/= StringKeepChamfer "1")
			)
		)
		(setq StringKeepChamfer "1")
	)
	(if (= StringKeepChamfer "0")
		(setq CheckKeepChamfer Nil)
	)
	(if (= StringKeepChamfer "1")
		(setq CheckKeepChamfer T)
	)
	(set_tile "Tile_CheckKeepChamfer" StringKeepChamfer)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepChamfer" StringKeepChamfer)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_CHECKKEEPCHAMFER ( / StringKeepChamfer)
	(setq StringKeepChamfer (get_tile "Tile_CheckKeepChamfer"))
	(if (= StringKeepChamfer "0")
		(setq CheckKeepChamfer Nil)
	)
	(if (= StringKeepChamfer "1")
		(setq CheckKeepChamfer T)
	)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepChamfer" StringKeepChamfer)

	(set_tile "Tile_ListStdAng" "")
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_RESET ( /
	StringAngleDegRoundOffMain
	StringKeepFillet
	StringKeepChamfer
	StringRoundOffMaxMain
	StringRoundOffMinMain
	StringRoundOffSubdiv
	StringRoundOffBlockAgain)

	(Setq NumRoundOffMaxMain 5.0)
	(setq StringRoundOffMaxMain (rtos NumRoundOffMaxMain 2 LengthNumVariable))
	(set_tile "Tile_NumRoundOffMax" StringRoundOffMaxMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMaxMain" StringRoundOffMaxMain)

	(Setq NumRoundOffMinMain 0.0005)
	(setq StringRoundOffMinMain (rtos NumRoundOffMinMain 2 LengthNumVariable))
	(set_tile "Tile_NumRoundOffMin" StringRoundOffMinMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffMinMain" StringRoundOffMinMain)

	(Setq NumRoundOffSubdiv 10.0)
	(setq StringRoundOffSubdiv (rtos NumRoundOffSubdiv 2 LengthNumVariable))
	(set_tile "Tile_NumRoundOffSubdiv" StringRoundOffSubdiv)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "NumRoundOffSubdiv" StringRoundOffSubdiv)

	(setq AngleDegRoundOffMain 0.5)
	(setq StringAngleDegRoundOffMain (rtos AngleDegRoundOffMain 2 LengthNumVariable))
	(set_tile "Tile_AngleDegRoundOff" StringAngleDegRoundOffMain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "AngleDegRoundOffMain" StringAngleDegRoundOffMain)

	(setq ListAngDegStd (list 0.0 90.0 45.0 135.0))
	(RND_CHECK_LISTANGDEGSTD_AND_SET_TILE_LISTSTDANG)

	(setq CheckRoundOffBlockAgain Nil)
	(setq StringRoundOffBlockAgain "0")
	(set_tile "Tile_CheckRoundOffBlockAgain" StringRoundOffBlockAgain)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckRoundOffBlockAgain" StringRoundOffBlockAgain)

	(setq CheckKeepFillet T)
	(setq StringKeepFillet "1")
	(set_tile "Tile_CheckKeepFillet" StringKeepFillet)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepFillet" StringKeepFillet)

	(setq CheckKeepChamfer T)
	(setq StringKeepChamfer "1")
	(set_tile "Tile_CheckKeepChamfer" StringKeepChamfer)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckKeepChamfer" StringKeepChamfer)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_TILE_SWITCHUI ( / StringModeStandardUI)
	(setq StringModeStandardUI (vl-registry-read "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckModeStandardUI"))
	(if
		(or
			(not StringModeStandardUI)
			(and
				(/= StringModeStandardUI "0")
				(/= StringModeStandardUI "1")
			)
		)
		(setq StringModeStandardUI "1")
		(if (= StringModeStandardUI "0")
			(setq StringModeStandardUI "1")
			(setq StringModeStandardUI "0")
		)
	)
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "CheckModeStandardUI" StringModeStandardUI)
	(RND_MAKE_FILE_DCL)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_OK ( / )
	(if SelectionSetObject
		(mode_tile "Ok" 0)
		(mode_tile "Ok" 1)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_TILE_ABOUT (/
	About_DCL
	About_End_Dialog)

	(setq About_DCL (load_dialog "Fix Imprecise 2D Drawing.dcl"))
	(new_dialog "FixImprecise2DDrawingAbout" About_DCL)
	(set_tile "Tile_About_Separate1" "........................................................................................................................................................................................................")
	(set_tile "Tile_About_Separate2" "........................................................................................................................................................................................................")
	(action_tile "Tile_About_Ok" "(done_dialog 0)")
	(setq About_End_Dialog (start_dialog))
	(unload_dialog About_DCL)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_LISTANGDEGSTD_AND_SET_TILE_LISTSTDANG ( / ListAngDegStdTemp StringListAngDegStd)
	(setq ListAngDegStd (mapcar '(lambda (x) (RND_ROUNDOFF_NUMBER x AngleDegRoundOffMain)) ListAngDegStd))
	(foreach AngDegStd ListAngDegStd
		(while (< AngDegStd 0.0)
			(setq AngDegStd (+ AngDegStd 360.0))
		)
		(while (>= AngDegStd 180.0)
			(setq AngDegStd (- AngDegStd 180.0))
		)
		(if (not (member AngDegStd ListAngDegStdTemp))
			(setq ListAngDegStdTemp (cons AngDegStd ListAngDegStdTemp))
		)
	)
	(setq ListAngDegStd (reverse ListAngDegStdTemp))
	(setq StringListAngDegStd "")
	(foreach Temp ListAngDegStd
		(setq StringListAngDegStd (strcat StringListAngDegStd " " (rtos Temp 2 LengthNumVariable)))
	)
	(setq StringListAngDegStd (substr StringListAngDegStd 2))
	(RND_LOAD_POPUP_LIST "Tile_ListStdAng" (mapcar '(lambda (x) (rtos x 2 LengthNumVariable)) ListAngDegStd))
	(vl-registry-write "HKEY_CURRENT_USER\\Software\\Cad Standard\\Fix Imprecise 2D Drawing" "ListAngDegStd" StringListAngDegStd)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LIST_PRIOR_NAMEVAR_ANGSTD ( / NameVar Prior)
	(setq Prior 1)
	(foreach AngStd (reverse (mapcar 'RND_DEGREE_TO_RADIAN ListAngDegStd))
		(setq NameVar (RND_CREATE_NAMEVAR_DIR "Prior" AngStd))
		(setq List_Prior_NameVar_AngStd (cons (list NameVar AngStd) List_Prior_NameVar_AngStd))
		(set NameVar Prior)
		(setq Prior (+ Prior 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_PRIOR_FROM_ANGSTD ( AngStd / Prior)
	(setq Prior (eval (RND_CREATE_NAMEVAR_DIR "Prior" AngStd)))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_REMOVE_NAMEBLOCK_FROM_LISTNAMEBLOCKROUNDOFF ( VlaBlock ReactorObject ParameterList / NameVar)
	(setq NameVar (read (strcat "ListNameBlockRoundOff" (RND_CREATE_SEED 10 "DAY"))))
	(setq ListNameBlockRoundOff (eval NameVar))
	(setq NameBlock (RND_GET_NAME_BLOCK VlaBlock))
	(if (member NameBlock ListNameBlockRoundOff)
		(progn
			(princ (strcat "\nChange block: " NameBlock)) 
			(setq ListNameBlockRoundOff (vl-remove NameBlock ListNameBlockRoundOff))
			(set NameVar ListNameBlockRoundOff)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ANALYSIS_SELECTIONSETOBJECT ( /
	ListNameBlockCheck
	NameBlock
	NameBlockLayout
	VlaBlock
	VlaObject)

	(RND_FIND_NAMEBLOCK_IN_SELECTIONSETOBJECT)

	(foreach NameBlock (vl-remove NameBlockLayout ListNameBlockAll)
		(setq VlaBlock (vla-item VlaBlocksGroup NameBlock))
		(vlax-for VlaObject VlaBlock
			(RND_ANALYSIS_VLAOBJECT VlaObject NameBlock)
		)
	)

	(vlax-for VlaBlock VlaBlocksGroup
		(setq NameBlock (cdr (assoc 2 (entget (vlax-vla-object->ename VlaBlock)))))
		(if (= (vla-get-IsLayout VlaBlock) :vlax-true)
			(setq ListNameBlockLayout (cons NameBlock ListNameBlockLayout))
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NAMEBLOCK_IN_SELECTIONSETOBJECT ( /
	NameBlock
	Num
	VlaBlock
	VlaObject)

	(setq VlaObject (vlax-ename->vla-object (ssname SelectionSetObject 0)))
	(setq VlaBlock (vla-ObjectIDToObject VlaDrawingCurrent (vla-get-OwnerID VlaObject)))
	(setq NameBlockLayout (cdr (assoc 2 (entget (vlax-vla-object->ename VlaBlock)))))
	(if (not (member NameBlockLayout ListNameBlockAll))
		(setq ListNameBlockAll (cons NameBlockLayout ListNameBlockAll))
	)

	(setq Num 0)
	(repeat (sslength SelectionSetObject)
		(setq VlaObject (vlax-ename->vla-object (ssname SelectionSetObject Num)))
		(RND_ANALYSIS_VLAOBJECT VlaObject NameBlockLayout)
		(RND_FIND_NAMEBLOCK_FROM_VLAOBJECT VlaObject)
		(setq Num (+ Num 1))
	)

	(while ListNameBlockCheck
		(setq NameBlock (car ListNameBlockCheck))
		(vlax-for VlaObject (vla-item VlaBlocksGroup NameBlock)
			(RND_FIND_NAMEBLOCK_FROM_VLAOBJECT VlaObject)
		)
		(setq ListNameBlockCheck (vl-remove NameBlock ListNameBlockCheck))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NAMEBLOCK_FROM_VLAOBJECT ( VlaObject /
	NameBlockEffective
	NameBlock
	ListNameBlock
	ObjectType)
	(setq ObjectType (vla-get-ObjectName VlaObject))
	(if (= ObjectType "AcDbBlockReference")
		(progn
			(setq NameBlockEffective (RND_GET_EFFECTIVENAME_BLOCK VlaObject))
			(setq NameBlock (RND_GET_NAME_BLOCK VlaObject))
			
			(if (= NameBlockEffective NameBlock)
				(setq ListNameBlock (list NameBlockEffective))
				(setq ListNameBlock (list NameBlockEffective NameBlock))
			)

			(foreach NameBlock ListNameBlock
				(if (= (vla-get-IsXRef (vla-item VlaBlocksGroup NameBlock)) :vlax-false)
					(progn
						(if (not (assoc NameBlock ListNameBlock_NameBlockEffective))
							(setq ListNameBlock_NameBlockEffective (cons (cons NameBlock NameBlockEffective) ListNameBlock_NameBlockEffective))
						)
						(if (not (member NameBlock ListNameBlockAll))
							(progn
								(setq ListNameBlockAll (cons NameBlock ListNameBlockAll))
								(setq ListNameBlockCheck (cons NameBlock ListNameBlockCheck))
							)
						)
					)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ANALYSIS_VLAOBJECT ( VlaObject NameBlock /
	ListNameBlockChild
	NameBlockChild1
	NameBlockChild2
	ObjectType
	Temp)

	(setq ObjectType (vla-get-ObjectName VlaObject))
	(if (= ObjectType "AcDbBlockReference")
		(progn
			(setq NameBlockChild1 (RND_GET_EFFECTIVENAME_BLOCK VlaObject))
			(setq NameBlockChild2 (RND_GET_NAME_BLOCK VlaObject))
			(if (= NameBlockChild1 NameBlockChild2)
				(setq ListNameBlockChild (list NameBlockChild1))
				(setq ListNameBlockChild (list NameBlockChild1 NameBlockChild2))
			)
			(if
				(= (vla-get-IsXRef (vla-item VlaBlocksGroup NameBlockChild1)) :vlax-false)
				(progn
					(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectInsert))
						(setq ListNameBlockGrand_ListVlaObjectInsert (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectInsert))
						(setq ListNameBlockGrand_ListVlaObjectInsert (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectInsert))
					)

					(setq ListVlaObjectInsert_NameBlockGrand (cons (cons VlaObject NameBlock) ListVlaObjectInsert_NameBlockGrand))

					(foreach NameBlockChild ListNameBlockChild
						(if (setq Temp (assoc NameBlockChild ListNameBlock_ListVlaObjectInsert))
							(setq ListNameBlock_ListVlaObjectInsert (subst (cons NameBlockChild (cons VlaObject (cdr Temp))) Temp ListNameBlock_ListVlaObjectInsert))
							(setq ListNameBlock_ListVlaObjectInsert (cons (list NameBlockChild VlaObject) ListNameBlock_ListVlaObjectInsert))
						)
						(if (setq Temp (assoc NameBlockChild ListNameBlock_ListNameBlockGrand))
							(if (not (member NameBlock (cdr Temp)))
								(setq ListNameBlock_ListNameBlockGrand (subst (cons NameBlockChild (cons NameBlock (cdr Temp))) Temp ListNameBlock_ListNameBlockGrand))
							)
							(setq ListNameBlock_ListNameBlockGrand (cons (list NameBlockChild NameBlock) ListNameBlock_ListNameBlockGrand))
						)
					)
				)
				(progn
					(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectXref))
						(setq ListNameBlockGrand_ListVlaObjectXref (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectXref))
						(setq ListNameBlockGrand_ListVlaObjectXref (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectXref))
					)
				)
			)
		)
	)

	(if (= ObjectType "AcDbArc")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectArc))
				(setq ListNameBlockGrand_ListVlaObjectArc (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectArc))
				(setq ListNameBlockGrand_ListVlaObjectArc (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectArc))
			)
		)
	)

	(if (= ObjectType "AcDbAttributeDefinition")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectAttDef))
				(setq ListNameBlockGrand_ListVlaObjectAttDef (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectAttDef))
				(setq ListNameBlockGrand_ListVlaObjectAttDef (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectAttDef))
			)
		)
	)

	(if (= ObjectType "AcDbCircle")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectCircle))
				(setq ListNameBlockGrand_ListVlaObjectCircle (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectCircle))
				(setq ListNameBlockGrand_ListVlaObjectCircle (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectCircle))
			)
		)
	)

	(if
		(= ObjectType "AcDb2LineAngularDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimension2LineAngular))
				(setq ListNameBlockGrand_ListVlaObjectDimension2LineAngular (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimension2LineAngular))
				(setq ListNameBlockGrand_ListVlaObjectDimension2LineAngular (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimension2LineAngular))
			)
		)
	)

	(if
		(= ObjectType "AcDb3PointAngularDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimension3PointAngular))
				(setq ListNameBlockGrand_ListVlaObjectDimension3PointAngular (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimension3PointAngular))
				(setq ListNameBlockGrand_ListVlaObjectDimension3PointAngular (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimension3PointAngular))
			)
		)
	)

	(if
		(= ObjectType "AcDbAlignedDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionAligned))
				(setq ListNameBlockGrand_ListVlaObjectDimensionAligned (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionAligned))
				(setq ListNameBlockGrand_ListVlaObjectDimensionAligned (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionAligned))
			)
		)
	)

	(if
		(= ObjectType "AcDbArcDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionArc))
				(setq ListNameBlockGrand_ListVlaObjectDimensionArc (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionArc))
				(setq ListNameBlockGrand_ListVlaObjectDimensionArc (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionArc))
			)
		)
	)

	(if
		(= ObjectType "AcDbDiametricDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionDiametric))
				(setq ListNameBlockGrand_ListVlaObjectDimensionDiametric (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionDiametric))
				(setq ListNameBlockGrand_ListVlaObjectDimensionDiametric (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionDiametric))
			)
		)
	)

	(if
		(= ObjectType "AcDbFcf")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionFcf))
				(setq ListNameBlockGrand_ListVlaObjectDimensionFcf (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionFcf))
				(setq ListNameBlockGrand_ListVlaObjectDimensionFcf (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionFcf))
			)
		)
	)

	(if
		(= ObjectType "AcDbOrdinateDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionOrdinate))
				(setq ListNameBlockGrand_ListVlaObjectDimensionOrdinate (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionOrdinate))
				(setq ListNameBlockGrand_ListVlaObjectDimensionOrdinate (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionOrdinate))
			)
		)
	)

	(if
		(= ObjectType "AcDbRadialDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRadial))
				(setq ListNameBlockGrand_ListVlaObjectDimensionRadial (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionRadial))
				(setq ListNameBlockGrand_ListVlaObjectDimensionRadial (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionRadial))
			)
		)
	)

	(if
		(= ObjectType "AcDbRadialDimensionLarge")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRadialLarge))
				(setq ListNameBlockGrand_ListVlaObjectDimensionRadialLarge (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionRadialLarge))
				(setq ListNameBlockGrand_ListVlaObjectDimensionRadialLarge (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionRadialLarge))
			)
		)
	)

	(if
		(= ObjectType "AcDbRotatedDimension")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRotated))
				(setq ListNameBlockGrand_ListVlaObjectDimensionRotated (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDimensionRotated))
				(setq ListNameBlockGrand_ListVlaObjectDimensionRotated (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDimensionRotated))
			)
		)
	)

	(if (= ObjectType "AcDbDgnReference")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDgnReference))
				(setq ListNameBlockGrand_ListVlaObjectDgnReference (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDgnReference))
				(setq ListNameBlockGrand_ListVlaObjectDgnReference (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDgnReference))
			)
		)
	)

	(if (= ObjectType "AcDbDwfReference")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectDwfReference))
				(setq ListNameBlockGrand_ListVlaObjectDwfReference (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectDwfReference))
				(setq ListNameBlockGrand_ListVlaObjectDwfReference (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectDwfReference))
			)
		)
	)

	(if (= ObjectType "AcDbEllipse")
		(if
			(RND_CHECK_EQUAL_TWO_POINT
				(RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject))
				(RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject))
			)
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectEllipseClose))
				(setq ListNameBlockGrand_ListVlaObjectEllipseClose (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectEllipseClose))
				(setq ListNameBlockGrand_ListVlaObjectEllipseClose (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectEllipseClose))
			)
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectEllipseOpen))
				(setq ListNameBlockGrand_ListVlaObjectEllipseOpen (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectEllipseOpen))
				(setq ListNameBlockGrand_ListVlaObjectEllipseOpen (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectEllipseOpen))
			)
		)
	)

	(if (= ObjectType "AcDbHatch")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectHatch))
				(setq ListNameBlockGrand_ListVlaObjectHatch (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectHatch))
				(setq ListNameBlockGrand_ListVlaObjectHatch (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectHatch))
			)
		)
	)

	(if (= ObjectType "AcDbRasterImage")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectRasterImage))
				(setq ListNameBlockGrand_ListVlaObjectRasterImage (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectRasterImage))
				(setq ListNameBlockGrand_ListVlaObjectRasterImage (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectRasterImage))
			)
		)
	)

	(if (= ObjectType "AcDbLeader")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectLeader))
				(setq ListNameBlockGrand_ListVlaObjectLeader (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectLeader))
				(setq ListNameBlockGrand_ListVlaObjectLeader (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectLeader))
			)
		)
	)
	
	(if (= ObjectType "AcDbLine")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectLine))
				(setq ListNameBlockGrand_ListVlaObjectLine (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectLine))
				(setq ListNameBlockGrand_ListVlaObjectLine (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectLine))
			)
		)
	)

	(if (= ObjectType "AcDbMline")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectMline))
				(setq ListNameBlockGrand_ListVlaObjectMline (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectMline))
				(setq ListNameBlockGrand_ListVlaObjectMline (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectMline))
			)
		)
	)

	(if (= ObjectType "AcDbMLeader")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectMLeader))
				(setq ListNameBlockGrand_ListVlaObjectMLeader (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectMLeader))
				(setq ListNameBlockGrand_ListVlaObjectMLeader (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectMLeader))
			)
		)
	)

	(if (= ObjectType "AcDbMText")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectMText))
				(setq ListNameBlockGrand_ListVlaObjectMText (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectMText))
				(setq ListNameBlockGrand_ListVlaObjectMText (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectMText))
			)
		)
	)

	(if (= ObjectType "AcDbOle2Frame")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectOle2Frame))
				(setq ListNameBlockGrand_ListVlaObjectOle2Frame (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectOle2Frame))
				(setq ListNameBlockGrand_ListVlaObjectOle2Frame (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectOle2Frame))
			)
		)
	)

	(if (= ObjectType "AcDbPdfReference")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectPdfReference))
				(setq ListNameBlockGrand_ListVlaObjectPdfReference (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectPdfReference))
				(setq ListNameBlockGrand_ListVlaObjectPdfReference (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectPdfReference))
			)
		)
	)

	(if (= ObjectType "AcDbPoint")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectPoint))
				(setq ListNameBlockGrand_ListVlaObjectPoint (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectPoint))
				(setq ListNameBlockGrand_ListVlaObjectPoint (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectPoint))
			)
		)
	)

	(if (= ObjectType "AcDbPolyline")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectPolyline))
				(setq ListNameBlockGrand_ListVlaObjectPolyline (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectPolyline))
				(setq ListNameBlockGrand_ListVlaObjectPolyline (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectPolyline))
			)
		)
	)

	(if (= ObjectType "AcDbRay")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectRay))
				(setq ListNameBlockGrand_ListVlaObjectRay (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectRay))
				(setq ListNameBlockGrand_ListVlaObjectRay (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectRay))
			)
		)
	)

	(if (= ObjectType "AcDbShape")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectShape))
				(setq ListNameBlockGrand_ListVlaObjectShape (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectShape))
				(setq ListNameBlockGrand_ListVlaObjectShape (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectShape))
			)
		)
	)

	(if (= ObjectType "AcDbSolid")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectSolid))
				(setq ListNameBlockGrand_ListVlaObjectSolid (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectSolid))
				(setq ListNameBlockGrand_ListVlaObjectSolid (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectSolid))
			)
		)
	)

	(if (= ObjectType "AcDbSpline")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectSpline))
				(setq ListNameBlockGrand_ListVlaObjectSpline (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectSpline))
				(setq ListNameBlockGrand_ListVlaObjectSpline (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectSpline))
			)
		)
	)

	(if (= ObjectType "AcDbTable")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectTable))
				(setq ListNameBlockGrand_ListVlaObjectTable (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectTable))
				(setq ListNameBlockGrand_ListVlaObjectTable (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectTable))
			)
		)
	)

	(if (= ObjectType "AcDbText")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectText))
				(setq ListNameBlockGrand_ListVlaObjectText (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectText))
				(setq ListNameBlockGrand_ListVlaObjectText (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectText))
			)
		)
	)

	(if (= ObjectType "AcDbXline")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectXline))
				(setq ListNameBlockGrand_ListVlaObjectXline (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectXline))
				(setq ListNameBlockGrand_ListVlaObjectXline (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectXline))
			)
		)
	)

	(if (= ObjectType "AcDbViewport")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectViewport))
				(setq ListNameBlockGrand_ListVlaObjectViewport (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectViewport))
				(setq ListNameBlockGrand_ListVlaObjectViewport (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectViewport))
			)
		)
	)

	(if (= ObjectType "AcDbWipeout")
		(progn
			(if (setq Temp (assoc NameBlock ListNameBlockGrand_ListVlaObjectWipeout))
				(setq ListNameBlockGrand_ListVlaObjectWipeout (subst (cons NameBlock (cons VlaObject (cdr Temp))) Temp ListNameBlockGrand_ListVlaObjectWipeout))
				(setq ListNameBlockGrand_ListVlaObjectWipeout (cons (list NameBlock VlaObject) ListNameBlockGrand_ListVlaObjectWipeout))
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_SCALEFACTOR_NAMEBLOCK ( NameBlock /
	ListNameBlock_ListScaleFactor
	ListNameBlockLayout_ListScaleFactor
	ListScaleFactor
	ListScaleFactor_Count
	ScaleFactor
	Temp
	ScalefactorBlockMin
	ScalefactorBlockMin
	ScalefactorBlockRoundOff)

	(setq Temp (list NameBlock (list 1.0 1.0)))
	(setq ListNameBlock_ListScaleFactor (list Temp))
	(RND_GET_LISTSCALEFACTOR_NAMEBLOCK NameBlock)
	(setq ListNameBlock_ListScaleFactor (vl-remove Temp ListNameBlock_ListScaleFactor))

	(if ListNameBlock_ListScaleFactor
		(progn
			(foreach NameBlockLayout ListNameBlockLayout
				(setq Temp (assoc NameBlockLayout ListNameBlock_ListScaleFactor))
				(if Temp (setq ListNameBlockLayout_ListScaleFactor (cons Temp ListNameBlockLayout_ListScaleFactor)))
			)

			(if ListNameBlockLayout_ListScaleFactor
				(setq ListScaleFactor (apply 'append (mapcar 'cdr ListNameBlockLayout_ListScaleFactor)))
				(setq ListScaleFactor (apply 'append (mapcar 'cdr ListNameBlock_ListScaleFactor)))
			)

			(if (RND_CHECKPOINTORIGINAL NameBlock ListScaleFactor)
				(RND_ADD_LIST_CHECKPOINTORIGINAL_NAMEVAR_NAMEBLOCKBASE NameBlock)
			)

			(setq ListScaleFactor (mapcar 'car ListScaleFactor))

			(foreach ScaleFactor ListScaleFactor
				(if (setq Temp (assoc ScaleFactor ListScaleFactor_Count))
					(setq ListScaleFactor_Count (subst (cons ScaleFactor (+ (cdr Temp) 1)) Temp ListScaleFactor_Count))
					(setq ListScaleFactor_Count (cons (cons ScaleFactor 1) ListScaleFactor_Count))
				)
			)

			(setq ScalefactorBlockPop
				(cdr
					(assoc
						(car (vl-sort (mapcar 'cdr ListScaleFactor_Count) '>))
						(mapcar '(lambda (x) (cons (cdr x) (car x))) ListScaleFactor_Count)
					)
				)
			)
			(setq ScalefactorBlockMin (car (vl-sort ListScaleFactor '<)))
			(setq ScalefactorBlockRoundOff (/ ScalefactorBlockPop (fix (/ ScalefactorBlockPop ScalefactorBlockMin))))
		)
		(progn
			(RND_ADD_LIST_CHECKPOINTORIGINAL_NAMEVAR_NAMEBLOCKBASE NameBlock)
			(setq ScalefactorBlockPop 1.0)
			(setq ScalefactorBlockRoundOff 1.0)
		)
	)
	(setq ListNameBlock_ScalefactorBlockPop (cons (cons NameBlock ScalefactorBlockPop) ListNameBlock_ScalefactorBlockPop))
	(setq ListNameBlock_ScalefactorBlockRoundOff (cons (cons NameBlock ScalefactorBlockRoundOff) ListNameBlock_ScalefactorBlockRoundOff))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECKPOINTORIGINAL ( NameBlock ListScaleFactor / Temp)
	(and
		(/= (substr NameBlock 1 1) "*")
		(= (length ListScaleFactor) 1)
		(equal (mapcar '(lambda (x) (RND_ROUNDOFF_NUMBER x NumZero)) (car ListScaleFactor)) (list 1.0 1.0))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_LISTSCALEFACTOR_NAMEBLOCK (NameBlock /
	ListNameBlockTemp
	ListVlaObjectInsert
	ListScaleFactor
	NameBlockTemp
	ScaleFactorBlock
	ScalefactorBlockMin
	ScaleFactorResult
	ScaleFactorTemp
	Temp)
	(if (setq ListVlaObjectInsert (cdr (assoc NameBlock ListNameBlock_ListVlaObjectInsert)))
		(progn	
			(setq ScaleFactorBlock (RND_GET_SCALEFACTORBLOCK (vla-item VlaBlocksGroup (cdr (assoc NameBlock ListNameBlock_NameBlockEffective)))))

			(setq ListScaleFactor (cdr (assoc NameBlock ListNameBlock_ListScaleFactor)))
			(setq ListScaleFactor (mapcar '(lambda (x) (mapcar '(lambda (y) (* y ScaleFactorBlock)) x)) ListScaleFactor))

			(foreach VlaObjectInsert ListVlaObjectInsert
				(setq NameBlockTemp (cdr (assoc VlaObjectInsert ListVlaObjectInsert_NameBlockGrand)))
				(setq ScaleFactorTemp
					(list
						(abs (vla-get-XEffectiveScaleFactor VlaObjectInsert))
						(abs (vla-get-YEffectiveScaleFactor VlaObjectInsert))
					)
				)
				(foreach ScaleFactor ListScaleFactor
					(setq ScaleFactorResult (mapcar '* ScaleFactor ScaleFactorTemp))
					(if (setq Temp (assoc NameBlockTemp ListNameBlock_ListScaleFactor))
						(setq ListNameBlock_ListScaleFactor (subst (cons NameBlockTemp (cons ScaleFactorResult (cdr Temp))) Temp ListNameBlock_ListScaleFactor))
						(setq ListNameBlock_ListScaleFactor (cons (list NameBlockTemp ScaleFactorResult) ListNameBlock_ListScaleFactor))
					)
				)
			)
			(setq ListNameBlockTemp (cdr (assoc NameBlock ListNameBlock_ListNameBlockGrand)))
			(foreach NameBlockTemp ListNameBlockTemp
				(RND_GET_LISTSCALEFACTOR_NAMEBLOCK NameBlockTemp)
			)	
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_CHECKPOINTORIGINAL_NAMEVAR_NAMEBLOCKBASE ( NameBlockBase / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_NAMEBLOCK "CheckPointOriginal" NameBlockBase))
	(if (not (eval NameVar))
		(setq List_CheckPointOriginal_NameVar_NameBlockBase (cons (list NameVar NameBlockBase) List_CheckPointOriginal_NameVar_NameBlockBase))
	)
	(set NameVar T)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_NAMEBLOCKGRAND_MOVEX1_MOVEY1_DIR1_SCALEX1_SCALEY1_NAMEVAR_NAMEBLOCKBASE ( NameBlockBase NameBlockGrand VlaObjectInsertBase /
	Move
	NameVar)

	(setq NameVar (RND_CREATE_NAMEVAR_NAMEBLOCK "NameBlockGrand_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1" NameBlockBase))
	(if (not (eval NameVar))
		(setq List_NameBlockGrand_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1_NameVar_NameBlockBase (cons (list NameVar NameBlockBase) List_NameBlockGrand_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1_NameVar_NameBlockBase))
	)
	(setq Move (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObjectInsertBase)))
	(set
		NameVar
		(list
			NameBlockGrand
			(nth 0 Move)
			(nth 1 Move)
			(vla-get-Rotation VlaObjectInsertBase)
			(vla-get-XEffectiveScaleFactor VlaObjectInsertBase)
			(vla-get-YEffectiveScaleFactor VlaObjectInsertBase)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_NAMEBLOCKGRAND_MOVEX2_MOVEY2_DIR2_SCALEX2_SCALEY2_NAMEVAR_NAMEBLOCKBASE ( NameBlockBase NameBlockGrand VlaObjectInsertBase /
	Move
	NameVar)

	(setq NameVar (RND_CREATE_NAMEVAR_NAMEBLOCK "NameBlockGrand_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2" NameBlockBase))
	(if (not (eval NameVar))
		(setq List_NameBlockGrand_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2_NameVar_NameBlockBase (cons (list NameVar NameBlockBase) List_NameBlockGrand_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2_NameVar_NameBlockBase))
	)
	(setq Move (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObjectInsertBase)))
	(set
		NameVar
		(list
			NameBlockGrand
			(- (nth 0 Move))
			(- (nth 1 Move))
			(- (vla-get-Rotation VlaObjectInsertBase))
			(/ 1.0 (vla-get-XEffectiveScaleFactor VlaObjectInsertBase))
			(/ 1.0 (vla-get-YEffectiveScaleFactor VlaObjectInsertBase))
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_NAME_BLOCK ( VlaObject / NameBlock)
	(setq NameBlock (cdr (assoc 2 (entget (vlax-vla-object->ename VlaObject)))))
	NameBlock
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_EFFECTIVENAME_BLOCK ( VlaObject / NameBlock)
	(vl-catch-all-apply (function (lambda ( / )
		(setq NameBlock (cdr (assoc 2 (entget (cdr (assoc 340 (entget (vlax-vla-object->ename (vla-item (vla-item (vla-GetExtensionDictionary VlaObject) "AcDbBlockRepresentation") "AcDbRepData")))))))))
	)))
	(if (not NameBlock)
		(setq NameBlock (cdr (assoc 2 (entget (vlax-vla-object->ename VlaObject)))))
	)
	NameBlock
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ALL_OBJECT_IN_BLOCK ( NameBlock /
;;NameVar
;;	Prior
	List_Prior_NameVar_AngStd

;;Level 2

;;NameVar
;;	Node
	List_Node_NameVar_P

;;NameVar
;;	CheckTan
	List_CheckTan_NameVar_Node_DirTanNew

;;Level 3
;;NameVar
;;	P_PBase_NumRnd_NodeCnt
	List_P_PBase_NumRnd_NodeCnt_NameVar_Node_DirNew

;;Level 4
	DirMain

;;Level 5
;;NameVar
;;	NodeNew
	List_NodeNew_NameVar_Node

;;NameVar
;;	PointNewModel
	List_PointNewModel_NameVar_Node

;;Change Object
;;NameVar
;;	PCNew
	List_PCNew_NameVar_PC

;;NameVar
;;	PCNew_RadNew
	List_PCNew_RadNew_NameVar_PC_Rad

;;Main
	AngleDegRoundOff
	CheckConvertBasePoint
	CheckCreatePointCheck
	LengthVarNameDir
	LengthVarNameDirDeg
	LengthVarNameNum
	LengthVarNamePoint
	List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1
	List_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2
	ListNodeChangeNumRnd
	ListPointChangeNumRnd_ObjectLevel
	NumRoundOffMax
	NumRoundOffMin
	PiNear
	Point0_Block_To_Model
	Point0_Model_To_Block
	ScalefactorBlockPop
	SeedVar)

	(setq SeedVar (RND_CREATE_SEED 10 "SEC"))
	(setq ScalefactorBlockPop (cdr (assoc NameBlock ListNameBlock_ScalefactorBlockPop)))
	(setq NumRoundOffMax (/ NumRoundOffMaxMain ScalefactorBlockPop))
	(setq NumRoundOffMin (/ NumRoundOffMinMain ScalefactorBlockPop))
	(setq AngleDegRoundOff AngleDegRoundOffMain)
	(setq LengthVarNameDir 8)
	(setq LengthVarNameDirDeg 8)
	(setq LengthVarNameNum 0)
	(setq LengthVarNamePoint (fix (/ (log (/ NumRoundOffMax NumRoundOffMin)) (log 10.0))))
	(setq PiNear (RND_DEGREE_TO_RADIAN (- 180.0 (* AngleDegRoundOff 0.5))))
	(RND_CREATE_LIST_PRIOR_NAMEVAR_ANGSTD)
	(RND_CHECKCONVERTBASEPOINT NameBlock)
	(if (or (member NameBlock ListNameBlockLayout) List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1) (setq CheckCreatePointCheck T))

	(RND_FIND_NODENEW_LEVEL_1_OBJECTTYPE NameBlock "1")
	(RND_FIND_NODENEW_LEVEL_1_OBJECTTYPE NameBlock "2")
	(RND_FIND_NODENEW_LEVEL_1_OBJECTTYPE NameBlock "3")

	(RND_CHANGE_VLAOBJECT NameBlock)
	(RND_FIND_POINTCHECK)

	(mapcar
		'RND_RESET_LISTNAMEVAR
		(list
			List_Prior_NameVar_AngStd
			List_Node_NameVar_P
			List_CheckTan_NameVar_Node_DirTanNew
			List_P_PBase_NumRnd_NodeCnt_NameVar_Node_DirNew
			List_NodeNew_NameVar_Node
			List_PointNewModel_NameVar_Node
			List_PCNew_NameVar_PC
			List_PCNew_RadNew_NameVar_PC_Rad
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECKCONVERTBASEPOINT ( NameBlock /
	NameBlockBase
	Temp1
	Temp2)

	(setq NameBlockBase NameBlock)
	(while (setq Temp1 (eval (RND_CREATE_NAMEVAR_NAMEBLOCK "NameBlockGrand_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1" NameBlockBase)))
		(setq NameBlockBase (car Temp1))
		(setq Temp2 (cdr Temp1))
		(setq List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1 (cons Temp2 List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1))
	)
	(setq List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1 (reverse List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1))

	(setq NameBlockBase NameBlock)
	(while (setq Temp1 (eval (RND_CREATE_NAMEVAR_NAMEBLOCK "NameBlockGrand_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2" NameBlockBase)))
		(setq NameBlockBase (car Temp1))
		(setq Temp2 (cdr Temp1))
		(setq List_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2 (cons Temp2 List_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2))
	)

	(if (or (member NameBlock ListNameBlockLayout) List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1)
		(setq CheckConvertBasePoint T)
	)
	(if (and CheckConvertBasePoint List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1)
		(progn
			(setq Point0_Block_To_Model (RND_FIND_POINT_BLOCK_TO_MODEL (list 0.0 0.0 0.0)))
			(setq Point0_Model_To_Block (RND_FIND_POINT_MODEL_TO_BLOCK (list 0.0 0.0 0.0)))
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_DIR_FORM_DIR_CHECKREFLECTION ( Dir CheckReflection NumPi / )
	(if (< CheckReflection 0)
		(if (>= Dir NumPi)
			(setq Dir (- Dir Pi))
			(setq Dir (+ Dir Pi))
		)
	)
	Dir
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_OBJECTTYPE ( NameBlock ObjectLevel /

;;Level 1
;;NameVar
;;	Dir_DisObj_PCnt...
	List_Dir_DisObj_PCnt_NameVar_P

;;	[P_DirTan]...
	List_P_DirTan

;;Level 2
;;NameVar
;;	[P_Dir_DirNew_DisObj_PCnt]...
	List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node

;;NameVar
;;	NumRnd
	List_NumRnd_NameVar_Node

;;NameVar
;;	DirTanNew...
	List_DirTanNew_NameVar_Node

;;NameVar
;;	DirChamNew...
	List_DirChamNew_NameVar_Node

;;Level 3
;;NameVar
;;	DirNew...
	List_DirNew_NameVar_Node

;;Level 4
;;NameVar
;;	Count
	List_Count_NameVar_DirNew

;;	[Node_Dir1New_Dir2New]...
	List_Node_Dir1New_Dir2New)

	(if (= ObjectLevel "1")
		(progn
			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectArc))
				(RND_FIND_NODENEW_LEVEL_1_FROM_ARC VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectCircle))
				(RND_FIND_NODENEW_LEVEL_1_FROM_CIRCLE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectEllipseOpen))
				(RND_FIND_NODENEW_LEVEL_1_FROM_ELLIPSEOPEN VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectInsert))
				(RND_FIND_NODENEW_LEVEL_1_FROM_INSERT VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectLine))
				(RND_FIND_NODENEW_LEVEL_1_FROM_LINE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectMline))
				(RND_FIND_NODENEW_LEVEL_1_FROM_MLINE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectPolyline))
				(RND_FIND_NODENEW_LEVEL_1_FROM_POLYLINE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectWipeout))
				(RND_FIND_NODENEW_LEVEL_1_FROM_WIPEOUT VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectXref))
				(RND_FIND_NODENEW_LEVEL_1_FROM_XREF VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectViewport))
				(RND_FIND_NODENEW_LEVEL_1_FROM_VIEWPORT VlaObject)
			)
		)
	)

	(if (= ObjectLevel "2")
		(progn
			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDgnReference))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DGN_DWF_PDF_REFERENCE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDwfReference))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DGN_DWF_PDF_REFERENCE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectHatch))
				(RND_FIND_NODENEW_LEVEL_1_FROM_HATCH VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectOle2Frame))
				(RND_FIND_NODENEW_LEVEL_1_FROM_OLE2FRAME VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectPdfReference))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DGN_DWF_PDF_REFERENCE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectRasterImage))
				(RND_FIND_NODENEW_LEVEL_1_FROM_RASTERIMAGE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectSolid))
				(RND_FIND_NODENEW_LEVEL_1_FROM_SOLID VlaObject)
			)
		)
	)

	(if (= ObjectLevel "3")
		(progn
			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectAttDef))
				(RND_FIND_NODENEW_LEVEL_1_FROM_ATTDEF VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectEllipseClose))
				(RND_FIND_NODENEW_LEVEL_1_FROM_ELLIPSECLOSE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectLeader))
				(RND_FIND_NODENEW_LEVEL_1_FROM_LEADER VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectMLeader))
				(RND_FIND_NODENEW_LEVEL_1_FROM_MLEADER VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectMtext))
				(RND_FIND_NODENEW_LEVEL_1_FROM_MTEXT VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectRay))
				(RND_FIND_NODENEW_LEVEL_1_FROM_RAY VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectShape))
				(RND_FIND_NODENEW_LEVEL_1_FROM_SHAPE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectTable))
				(RND_FIND_NODENEW_LEVEL_1_FROM_TABLE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectText))
				(RND_FIND_NODENEW_LEVEL_1_FROM_TEXT VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectXline))
				(RND_FIND_NODENEW_LEVEL_1_FROM_XLINE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimension2LineAngular))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSION2LINEANGULAR VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimension3PointAngular))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSION3POINTANGULAR VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionAligned))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONALIGNED VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionArc))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONARC VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionDiametric))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONDIAMETRIC VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionFcf))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONFCF VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRadial))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONRADIAL VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRadialLarge))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONRADIALLARGE VlaObject)
			)

			(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRotated))
				(RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONROTATED VlaObject)
			)
		)
	)

	(RND_FIND_NODENEW_LEVEL_2)
	(RND_FIND_NODENEW_LEVEL_3)
	(RND_FIND_NODENEW_LEVEL_4)
	(RND_FIND_NODENEW_LEVEL_5)

	(mapcar
		'RND_RESET_LISTNAMEVAR
		(list
			List_Dir_DisObj_PCnt_NameVar_P
			List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node
			List_DirTanNew_NameVar_Node
			List_NumRnd_NameVar_Node
			List_DirNew_NameVar_Node
			List_Count_NameVar_DirNew
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_ARC ( VlaObject /	
	Dir
	Dir1
	Dir1Tan
	Dir2
	Dir2Tan
	DisObj
	DisObj1
	DisObj2
	P1
	P2
	PC)

	(setq P1 (RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject)))
	(setq P2 (RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject)))
	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Dir1 (angle PC P1))
	(setq Dir2 (angle PC P2))
	(if (RND_CHECK_PIHALF (RND_FIND_DIRLINNEW (- Dir1 Dir2)))
		(progn
			(setq DisObj1 (distance PC P1))
			(setq DisObj2 (distance PC P2))
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir1 DisObj1 PC)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir1 DisObj1 P1)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir2 DisObj2 PC)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir2 DisObj2 P2)
		)
		(progn
			(setq Dir (angle P1 P2))
			(setq DisObj (distance P1 P2))
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		)
	)

	(if CheckKeepFillet
		(progn
			(setq Dir1Tan (+ Dir1 PiHalf))
			(setq Dir2Tan (+ Dir2 PiHalf))
			(RND_ADD_LIST_P_DIRTAN P1 Dir1Tan)
			(RND_ADD_LIST_P_DIRTAN P2 Dir2Tan)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_CIRCLE ( VlaObject /
	Dir
	DisObj
	P1
	P2
	PC
	Rad)

	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Rad (vla-get-Radius VlaObject))
	(setq Dir 0.0)
	(setq P1 (polar PC Dir Rad))
	(setq P2 (polar PC Dir (- Rad)))
	(setq DisObj (* 2.0 Rad))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_ELLIPSEOPEN ( VlaObject /
	Dir
	DisObj
	P1
	P2)

	(setq P1 (RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject)))
	(setq P2 (RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject)))
	(setq Dir (angle P1 P2))
	(setq DisObj (distance P1 P2))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_INSERT ( VlaObject /
	DataBoundaryXclip
	Dir
	DisObj
	ListPoint
	Num
	NumCheck
	P
	P1
	P2)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (RND_GET_DIR_FORM_DIR_CHECKREFLECTION (vla-get-Rotation VlaObject) (vla-get-XEffectiveScaleFactor VlaObject) PiNear))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)

	(RND_FIND_NODENEW_LEVEL_1_FROM_ATTRIBUTE VlaObject)

	(setq DataBoundaryXclip (RND_FIND_DATAXCLIPBOUNDARY VlaObject))
	(if DataBoundaryXclip
		(progn
			(setq ListPoint (nth 1 DataBoundaryXclip))
			(setq Num 0)
			(setq NumCheck (- (length ListPoint) 1))
			(repeat (length ListPoint)
				(setq P1 (nth Num ListPoint))
				(if (= Num NumCheck)
					(setq P2 (nth 0 ListPoint))
					(setq P2 (nth (+ Num 1) ListPoint))
				)
				(setq Dir (angle P1 P2))
				(setq DisObj (distance P1 P2))
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
				(setq Num (+ Num 1))
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_ATTRIBUTE ( VlaObjectInsert /	
	Dir
	P
	VlaObject)

	(if (= (vla-get-HasAttributes VlaObjectInsert) :vlax-true)
		(foreach VlaObject (RND_VARIANT_TO_LIST (vla-GetAttributes VlaObjectInsert))
			(setq P (RND_VARIANT_TO_LIST (vla-get-TextAlignmentPoint VlaObject)))
			(setq Dir (vla-get-Rotation VlaObject))
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_LINE ( VlaObject /	
	Dir
	DisObj
	P1
	P2)

	(setq P1 (RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject)))
	(setq P2 (RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject)))
	(setq Dir (angle P1 P2))
	(setq DisObj (distance P1 P2))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_MLINE ( VlaObject /
	CheckClosed
	Dir
	DisObj
	ListCoordinates
	ListPoint
	Num
	NumNext
	NumPoint
	P1
	P2)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq Num 0)
	(repeat (/ (length ListCoordinates) 3)
		(setq ListPoint
			(cons
				(list
					(nth Num ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
				)
				ListPoint
			)
		)
		(setq Num (+ Num 1))
	)
	(setq ListPoint (reverse ListPoint))
	(setq CheckClosed (= 2 (logand 2 (cdr (assoc 71 (entget (vlax-vla-object->ename VlaObject)))))))
	(setq NumPoint (- (length ListPoint) 1))
	(setq Num 0)
	(repeat
		(if CheckClosed
			(length ListPoint)
			(- (length ListPoint) 1)
		)
		(setq P1 (nth Num ListPoint))
		(if  (= NumPoint Num)
			(setq NumNext 0)
			(setq NumNext (+ Num 1))
		)
		(setq P2 (nth NumNext ListPoint))
		(setq Dir (angle P1 P2))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_POLYLINE ( VlaObject /
	Bulge
	CheckClosed
	Dir
	Dir1
	Dir1Tan
	Dir2
	Dir2Tan
	DisObj
	DisObj1
	DisObj2
	ListBulge
	ListCoordinates
	ListPoint
	ListTemp
	Num
	NumNext
	NumPoint
	P1
	P2
	PC
	Rad)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq Num 0)
	(repeat (/ (length ListCoordinates) 2)
		(setq ListPoint (cons (list (nth Num ListCoordinates) (nth (+ Num 1) ListCoordinates) 0.0) ListPoint))
		(setq Num (+ Num 2))
	)
	(setq ListPoint (reverse ListPoint))

	(setq NumPoint (length ListPoint))
	(setq CheckClosed (= (vla-get-Closed VlaObject) :vlax-true))
	(if (not CheckClosed)
		(vla-SetBulge VlaObject (- NumPoint 1) 0.0)
	)
	(setq Num 0)
	(repeat NumPoint
		(setq ListBulge (cons (vla-GetBulge VlaObject Num) ListBulge))
		(setq Num (+ Num 1))
	)
	(setq ListBulge (reverse ListBulge))



	(setq NumPoint (- (length ListPoint) 1))
	(setq Num 0)
	(repeat
		(if
			CheckClosed
			(length ListPoint)
			(- (length ListPoint) 1)
		)

		(setq P1 (nth Num ListPoint))
		(if  (= NumPoint Num)
			(setq NumNext 0)
			(setq NumNext (+ Num 1))
		)
		(setq P2 (nth NumNext ListPoint))

		(setq Bulge (nth Num ListBulge))
		(if (= Bulge 0.0)
			(progn
				(setq Dir (angle P1 P2))
				(setq DisObj (distance P1 P2))
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
			)
			(progn
				(setq ListTemp (RND_BULGE_TO_ARC P1 P2 Bulge))
				(setq PC (car ListTemp))
				(setq Rad (cadr ListTemp))
				(setq Dir1 (angle PC P1))
				(setq Dir2 (angle PC P2))
				(if (RND_CHECK_PIHALF (RND_FIND_DIRLINNEW (- Dir1 Dir2)))
					(progn
						(setq DisObj1 (distance PC P1))
						(setq DisObj2 (distance PC P2))
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir1 DisObj1 PC)
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir1 DisObj1 P1)
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir2 DisObj2 PC)
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir2 DisObj2 P2)
					)
					(progn
						(setq Dir (angle P1 P2))
						(setq DisObj (distance P1 P2))
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
					)
				)

				(if CheckKeepFillet
					(progn
						(setq Dir1Tan (+ Dir1 PiHalf))
						(setq Dir2Tan (+ Dir2 PiHalf))
						(RND_ADD_LIST_P_DIRTAN P1 Dir1Tan)
						(RND_ADD_LIST_P_DIRTAN P2 Dir2Tan)
					)
				)
			)
		)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_WIPEOUT ( VlaObject /
	Dir
	DisObj
	ListPoint
	Num
	P1
	P2)

	(setq ListPoint (RND_FIND_LISTPOINT_WIPEOUT VlaObject))
	(setq Num 0)
	(repeat (- (length ListPoint) 1)
		(setq P1 (nth Num ListPoint))
		(setq P2 (nth (+ Num 1) ListPoint))
		(setq Dir (angle P1 P2))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_XREF ( VlaObject /
	DataBoundaryXclip
	Dir
	DisObj
	ListPoint
	Num
	NumCheck
	P
	P1
	P2)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)

	(setq DataBoundaryXclip (RND_FIND_DATAXCLIPBOUNDARY VlaObject))
	(if DataBoundaryXclip
		(progn
			(setq ListPoint (nth 1 DataBoundaryXclip))
			(setq Num 0)
			(setq NumCheck (- (length ListPoint) 1))
			(repeat (length ListPoint)
				(setq P1 (nth Num ListPoint))
				(if (= Num NumCheck)
					(setq P2 (nth 0 ListPoint))
					(setq P2 (nth (+ Num 1) ListPoint))
				)
				(setq Dir (angle P1 P2))
				(setq DisObj (distance P1 P2))
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
				(setq Num (+ Num 1))
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_VIEWPORT ( VlaObject /
	Dir
	DisObj
	ListPoint
	Num
	P
	P1
	P2)

	(setq P (RND_VARIANT_TO_LIST (vla-get-center VlaObject)))
	(setq Dir 0.0)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)

	(setq ListPoint (mapcar '(lambda (x) (cdr (assoc 10 (entget x)))) (RND_FIND_LISTENAMEOBJECTVERTEX_FROM_VIEWPORT VlaObject)))
	(setq Num 0)
	(repeat (- (length ListPoint) 1)
		(setq P1 (nth Num ListPoint))
		(setq P2 (nth (+ Num 1) ListPoint))
		(setq Dir (angle P1 P2))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DGN_DWF_PDF_REFERENCE ( VlaObject /
	Dir
	DisObj
	P
	P1
	P2
	ListPoint
	Num
	NumCheck)

	(setq P (RND_VARIANT_TO_LIST (vla-get-Position VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)

	(setq ListPoint (RND_FIND_LISTPOINT_CLIPBOUNDARY_DGN_DWF_PDF_REFERENCE VlaObject))
	(setq Num 0)
	(setq NumCheck (- (length ListPoint) 1))
	(repeat (length ListPoint)
		(setq P1 (nth Num ListPoint))
		(if (= Num NumCheck)
			(setq P2 (nth 0 ListPoint))
			(setq P2 (nth (+ Num 1) ListPoint))
		)
		(setq Dir (angle P1 P2))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_HATCH ( VlaObject /
	CheckPathTypePolyline
	DataEnameEdge
	DataEnameEdgeSub
	EdgeType
	ListDataEnameEdge
	ListDataEnameEdgeSub
	Temp)

	(setq ListDataEnameEdge (RND_CREATE_LISTDATAENAMEEDGE_HATCH VlaObject))
	(setq ListDataEnameEdge (vl-remove (car ListDataEnameEdge) ListDataEnameEdge))
	(setq ListDataEnameEdge (vl-remove (last ListDataEnameEdge) ListDataEnameEdge))
	
	(foreach DataEnameEdge ListDataEnameEdge
		(setq CheckPathTypePolyline (RND_CHECK_PATH_TYPE_POLYLINE_OF_HATCH DataEnameEdge))
		(if CheckPathTypePolyline
			(RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_POLYLINE DataEnameEdge)
			(progn
				(setq ListDataEnameEdgeSub (RND_CREATE_LISTDATAENAMEEDGESUB_HATCH DataEnameEdge))
				(foreach DataEnameEdgeSub ListDataEnameEdgeSub
					(setq EdgeType (cdr (assoc 72 DataEnameEdgeSub)))
					(if (=  EdgeType 0)
						(RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_POLYLINE DataEnameEdgeSub)
					)
					(if (=  EdgeType 1)
						(RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_LINE DataEnameEdgeSub)
					)
					(if (=  EdgeType 2)
						(RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_ARC DataEnameEdgeSub)
					)
					(if (=  EdgeType 3)
						(RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_ELLIPSE DataEnameEdgeSub)
					)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_PATH_TYPE_POLYLINE_OF_HATCH ( DataEnameEdge / )
	(= 2 (logand 2 (cdr (assoc 92 DataEnameEdge))))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTDATAENAMEEDGE_HATCH ( VlaObject /
	DataEnameObject
	DataEnameEdge
	DataEnameEdgeFirst
	DataEnameEdgeLast
	DataEnameEdgeTemp
	ListDataEnameEdge
	Num
	Temp)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq Num 0)
	(repeat (length DataEnameObject)
		(setq Temp (nth Num DataEnameObject))
		(if (= (car Temp) 92)
			(progn
				(setq ListDataEnameEdge (cons (reverse DataEnameEdge) ListDataEnameEdge))
				(setq DataEnameEdge nil)
			)
		)
		(setq DataEnameEdge (cons Temp DataEnameEdge))
		(setq Num (+ Num 1))
	)
	(setq ListDataEnameEdge (reverse ListDataEnameEdge))
	(setq DataEnameEdgeFirst (car ListDataEnameEdge))
	(setq ListDataEnameEdge (reverse (cdr ListDataEnameEdge)))

	(setq Num 0)
	(repeat (length DataEnameEdge)
		(setq Temp (nth Num DataEnameEdge))
		(if (and (= (car Temp) 97) (not DataEnameEdgeLast))
			(progn
				(setq DataEnameEdgeLast DataEnameEdgeTemp)
				(setq DataEnameEdgeTemp nil)
			)
		)
		(setq DataEnameEdgeTemp (cons Temp DataEnameEdgeTemp))
		(setq Num (+ Num 1))
	)
	(setq ListDataEnameEdge (reverse (cons DataEnameEdgeTemp ListDataEnameEdge)))
	(setq ListDataEnameEdge (append (list DataEnameEdgeFirst) ListDataEnameEdge (list DataEnameEdgeLast)))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTDATAENAMEEDGESUB_HATCH ( DataEnameEdge /
	CheckFirst
	DataEnameEdgeSub
	ListDataEnameEdgeSub
	Num
	Temp)

	(setq Num 0)
	(repeat (length DataEnameEdge)
		(setq Temp (nth Num DataEnameEdge))
		(if (= (car Temp) 72)
			(if CheckFirst
				(progn
					(setq ListDataEnameEdgeSub (cons (reverse DataEnameEdgeSub) ListDataEnameEdgeSub))
					(setq DataEnameEdgeSub nil)
				)
				(setq CheckFirst T)
			)
		)
		(setq DataEnameEdgeSub (cons Temp DataEnameEdgeSub))
		(setq Num (+ Num 1))
	)
	(setq ListDataEnameEdgeSub (cons (reverse DataEnameEdgeSub) ListDataEnameEdgeSub))
	(setq ListDataEnameEdgeSub (reverse ListDataEnameEdgeSub))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_LINE ( DataEnameEdge /
	Dir
	DisObj
	P1
	P2)

	(setq P1 (cdr (assoc 10 DataEnameEdge)))
	(setq P2 (cdr (assoc 11 DataEnameEdge)))
	(setq Dir (angle P1 P2))
	(setq DisObj (distance P1 P2))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_ARC ( DataEnameEdge /
	Ang1
	Ang2
	CheckClockwise
	Dir
	Dir1
	Dir1Tan
	Dir2
	Dir2Tan
	DisObj
	DisObj1
	DisObj2
	P1
	P2
	PC
	Rad)

	(setq PC (cdr (assoc 10 DataEnameEdge)))
	(setq Rad (cdr (assoc 40 DataEnameEdge)))
	(setq Ang1 (cdr (assoc 50 DataEnameEdge)))
	(setq Ang2 (cdr (assoc 51 DataEnameEdge)))
	(setq CheckClockwise (= (cdr (assoc 73 DataEnameEdge)) 0))
	(if CheckClockwise
		(progn
			(setq Ang1 (- Ang1))
			(setq Ang2 (- Ang2))
		)
	)
	(setq P1 (polar PC Ang1 Rad))
	(setq P2 (polar PC Ang2 Rad))
	(setq Dir1 (angle PC P1))
	(setq Dir2 (angle PC P2))
	(if (RND_CHECK_PIHALF (RND_FIND_DIRLINNEW (- Dir1 Dir2)))
		(progn
			(setq DisObj1 (distance PC P1))
			(setq DisObj2 (distance PC P2))
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir1 DisObj1 PC)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir1 DisObj1 P1)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir2 DisObj2 PC)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir2 DisObj2 P2)
		)
		(progn
			(setq Dir (angle P1 P2))
			(setq DisObj (distance P1 P2))
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		)
	)

	(if CheckKeepFillet
		(progn
			(setq Dir1Tan (+ Dir1 PiHalf))
			(setq Dir2Tan (+ Dir2 PiHalf))
			(RND_ADD_LIST_P_DIRTAN P1 Dir1Tan)
			(RND_ADD_LIST_P_DIRTAN P2 Dir2Tan)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_ELLIPSE ( DataEnameEdge /
	Ang1
	Ang2
	CheckClockwise
	Dir
	DisObj
	P1
	P2
	PC
	PM
	Rad1
	Rad2
	Ratio)

	(setq PC (cdr (assoc 10 DataEnameEdge)))
	(setq PM (cdr (assoc 11 DataEnameEdge)))
	(setq Ratio (cdr (assoc 40 DataEnameEdge)))
	(setq Dir (angle (list 0.0 0.0 0.0) PM))
	(setq Rad1 (distance (list 0.0 0.0 0.0) PM))
	(setq Rad2 (* Rad1 Ratio))
	(setq Ang1 (cdr (assoc 50 DataEnameEdge)))
	(setq Ang2 (cdr (assoc 51 DataEnameEdge)))
	(setq CheckClockwise (= (cdr (assoc 73 DataEnameEdge)) 0))
	(if CheckClockwise
		(progn
			(setq Ang1 (- Ang1))
			(setq Ang2 (- Ang2))
		)
	)
	(setq P1 (RND_FIND_POINT_OF_ELLIPSE PC Ratio Dir Rad1 Rad2 Ang1))
	(setq P2 (RND_FIND_POINT_OF_ELLIPSE PC Ratio Dir Rad1 Rad2 Ang2))
	(setq Dir (angle P1 P2))
	(setq DisObj (distance P1 P2))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)

)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_HATCH_EDGE_POLYLINE ( DataEnameEdge /
	Bulge
	CheckHasBulge
	DataEnameEdgeTemp
	Dir
	Dir1
	Dir1Tan
	Dir2
	Dir2Tan
	DisObj
	DisObj1
	DisObj2
	ListBulge
	ListPoint
	Num
	NumNext
	NumPoint
	P1
	P2
	PC
	Rad
	Temp)

	(setq DataEnameEdgeTemp DataEnameEdge)
	(foreach Temp DataEnameEdgeTemp
		(if (= (car Temp) 10)
			(setq ListPoint (cons (cdr Temp) ListPoint))
		)
	)
	(setq ListPoint (reverse ListPoint))

	(setq CheckHasBulge (= (cdr (assoc 72 DataEnameEdge)) 1))
	(if CheckHasBulge
		(progn
			(setq DataEnameEdgeTemp DataEnameEdge)
			(foreach Temp DataEnameEdgeTemp
				(if (= (car Temp) 42)
					(setq ListBulge (cons (cdr Temp) ListBulge))
				)
			)
			(setq ListBulge (reverse ListBulge))
		)
	)
	(setq NumPoint (- (length ListPoint) 1))
	(setq Num 0)
	(repeat (length ListPoint)
		(setq P1 (nth Num ListPoint))
		(if  (= NumPoint Num)
			(setq NumNext 0)
			(setq NumNext (+ Num 1))
		)
		(setq P2 (nth NumNext ListPoint))
		(if CheckHasBulge
			(progn
				(setq Bulge (nth Num ListBulge))
				(if (= Bulge 0.0)
					(progn
						(setq Dir (angle P1 P2))
						(setq DisObj (distance P1 P2))
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
						(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
					)
					(progn
						(setq ListTemp (RND_BULGE_TO_ARC P1 P2 Bulge))
						(setq PC (car ListTemp))
						(setq Rad (cadr ListTemp))
						(setq Dir1 (angle PC P1))
						(setq Dir2 (angle PC P2))
						(if (RND_CHECK_PIHALF (RND_FIND_DIRLINNEW (- Dir1 Dir2)))
							(progn
								(setq DisObj1 (distance PC P1))
								(setq DisObj2 (distance PC P2))
								(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir1 DisObj1 PC)
								(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir1 DisObj1 P1)
								(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir2 DisObj2 PC)
								(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir2 DisObj2 P2)
							)
							(progn
								(setq Dir (angle P1 P2))
								(setq DisObj (distance P1 P2))
								(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
								(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
							)
						)

						(if CheckKeepFillet
							(progn
								(setq Dir1Tan (+ Dir1 PiHalf))
								(setq Dir2Tan (+ Dir2 PiHalf))
								(RND_ADD_LIST_P_DIRTAN P1 Dir1Tan)
								(RND_ADD_LIST_P_DIRTAN P2 Dir2Tan)
							)
						)
					)
				)
			)
			(progn
				(setq Dir (angle P1 P2))
				(setq DisObj (distance P1 P2))
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
			)
		)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_OLE2FRAME ( VlaObject /
	Dir
	P)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir 0.0)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_RASTERIMAGE ( VlaObject /
	Dir
	DisObj
	ListPoint
	Num
	P
	P1
	P2)

	(setq P (RND_VARIANT_TO_LIST (vla-get-origin VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)

	(setq ListPoint (RND_FIND_LISTPOINT_CLIPBOUNDARYIMAGE VlaObject))
	(if (/= (length ListPoint) 2)
		(progn
			(setq Num 0)
			(repeat (- (length ListPoint) 1)
				(setq P1 (nth Num ListPoint))
				(setq P2 (nth (+ Num 1) ListPoint))
				(setq Dir (angle P1 P2))
				(setq DisObj (distance P1 P2))
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
				(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
				(setq Num (+ Num 1))
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_SOLID ( VlaObject /
	Dir
	DisObj
	ListCoordinates
	ListPoint
	Num
	NumNext
	NumPoint
	P1
	P2)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq ListPoint
		(list
			(list (nth 00 ListCoordinates) (nth 01 ListCoordinates) (nth 02 ListCoordinates))
			(list (nth 03 ListCoordinates) (nth 04 ListCoordinates) (nth 05 ListCoordinates))
			(list (nth 09 ListCoordinates) (nth 10 ListCoordinates) (nth 11 ListCoordinates))
			(list (nth 06 ListCoordinates) (nth 07 ListCoordinates) (nth 08 ListCoordinates))
		)
	)
	(setq NumPoint (- (length ListPoint) 1))
	(setq Num 0)
	(repeat (length ListPoint)
		(setq P1 (nth Num ListPoint))
		(if  (= NumPoint Num)
			(setq NumNext 0)
			(setq NumNext (+ Num 1))
		)
		(setq P2 (nth NumNext ListPoint))
		(setq Dir (angle P1 P2))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_ATTDEF ( VlaObject /	
	Dir
	P)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_ELLIPSECLOSE ( VlaObject /	
	Dir
	PC)

	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) (RND_VARIANT_TO_LIST (vla-get-MajorAxis VlaObject))))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_LEADER ( VlaObject /
	DataEnameObject
	Dir
	DisObj
	ListCoordinates
	ListPoint
	Num
	P1
	P2)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(entmod (vl-remove (assoc 340 DataEnameObject) DataEnameObject))

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq Num 0)
	(repeat (/ (length ListCoordinates) 3)
		(setq ListPoint
			(cons
				(list
					(nth Num ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
				)
				ListPoint
			)
		)
		(setq Num (+ Num 1))
	)
	(setq ListPoint (reverse ListPoint))

	(setq Num 0)
	(repeat (- (length ListPoint) 1)
		(setq P1 (nth Num ListPoint))
		(setq P2 (nth (+ Num 1) ListPoint))
		(setq Dir (angle P1 P2))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_MLEADER ( VlaObject /
	Dir
	DisObj
	DoglegLength
	Index
	ListCoordinates
	ListPoint
	Num
	P
	P1
	P2)

	(foreach Index (RND_VARIANT_TO_LIST (vla-getleaderlineindexes VlaObject 0))
		(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-getleaderlinevertices VlaObject Index)))
		(setq Num 0)
		(setq ListPoint Nil)
		(repeat (/ (length ListCoordinates) 3)
			(setq P
				(list
					(nth Num ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
				)
			)
			(setq ListPoint (cons P ListPoint))
			(setq Num (+ Num 1))
		)
		(setq ListPoint (reverse ListPoint))

		(setq Num 0)
		(repeat (- (length ListPoint) 1)
			(setq P1 (nth Num ListPoint))
			(setq P2 (nth (+ Num 1) ListPoint))
			(setq Dir (angle P1 P2))
			(setq DisObj (distance P1 P2))
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
			(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)
			(setq Num (+ Num 1))
		)

		(setq Dir (angle (list 0.0 0.0 0.0) (RND_VARIANT_TO_LIST (vla-GetDoglegDirection VlaObject Index))))
		(setq P1 P)
		(setq DoglegLength (vla-get-DoglegLength VlaObject))
		(setq P2 (polar P Dir DoglegLength))
		(setq DisObj (distance P1 P2))
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj P2)
		(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir DisObj P1)

	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_MTEXT ( VlaObject /	
	Dir
	P)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_RAY ( VlaObject /
	Dir
	DirVec
	PC)

	(setq P (RND_VARIANT_TO_LIST (vla-get-BasePoint VlaObject)))
	(setq DirVec (RND_VARIANT_TO_LIST (vla-get-DirectionVector VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) DirVec))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_SHAPE ( VlaObject /	
	Dir
	PC)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (RND_GET_DIR_FORM_DIR_CHECKREFLECTION (vla-get-Rotation VlaObject) (vla-get-ScaleFactor VlaObject) PiNear))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_TEXT ( VlaObject /	
	Dir
	P)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_TABLE ( VlaObject /	
	Dir
	P)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) (RND_VARIANT_TO_LIST (vla-get-Direction VlaObject))))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_XLINE ( VlaObject /	
	Dir
	DirVec
	PC)

	(setq P (RND_VARIANT_TO_LIST (vla-get-BasePoint VlaObject)))
	(setq DirVec (RND_VARIANT_TO_LIST (vla-get-DirectionVector VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) DirVec))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSION2LINEANGULAR ( VlaObject /
	DataEnameObject
	Dir05
	Dir34
	DisObj05
	DisObj34
	P0
	P3
	P4
	P5)
	
	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P0 (cdr (assoc 10 DataEnameObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq P4 (cdr (assoc 14 DataEnameObject)))
	(setq P5 (cdr (assoc 15 DataEnameObject)))
	(setq Dir05 (angle P0 P5))
	(setq Dir34 (angle P3 P4))
	(setq DisObj05 (distance P0 P5))
	(setq DisObj34 (distance P3 P4))

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P0 Dir05 DisObj05 P5)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P5 Dir05 DisObj05 P0)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 Dir34 DisObj34 P4)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 Dir34 DisObj34 P3)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSION3POINTANGULAR ( VlaObject /
	DataEnameObject
	Dir3
	Dir4
	DisObj3
	DisObj4
	P3
	P4
	PC)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq P4 (cdr (assoc 14 DataEnameObject)))
	(setq PC (cdr (assoc 15 DataEnameObject)))

	(setq Dir3 (angle PC P3))
	(setq Dir4 (angle PC P4))
	(setq DisObj3 (distance PC P3))
	(setq DisObj4 (distance PC P4))

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 Dir3 DisObj3 PC)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir3 DisObj3 P3)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 Dir4 DisObj4 PC)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir4 DisObj4 P4)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONARC ( VlaObject /
	DataEnameObject
	Dir3
	Dir4
	DisObj3
	DisObj4
	P3
	P4
	PC)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq P4 (cdr (assoc 14 DataEnameObject)))
	(setq PC (cdr (assoc 15 DataEnameObject)))

	(setq Dir3 (angle PC P3))
	(setq Dir4 (angle PC P4))
	(setq DisObj3 (distance PC P3))
	(setq DisObj4 (distance PC P4))

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 Dir3 DisObj3 PC)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir3 DisObj3 P3)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 Dir4 DisObj4 PC)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir4 DisObj4 P4)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONALIGNED ( VlaObject /
	DataEnameObject
	Dir
	DirPer
	P1
	P2
	P3
	P4)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P1 (cdr (assoc 14 DataEnameObject)))
	(setq P2 (cdr (assoc 13 DataEnameObject)))
	(setq P3 (cdr (assoc 10 DataEnameObject)))
	(setq Dir (angle P2 P1))
	(setq DirPer (+ Dir PiHalf))
	(setq P4 (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir P2 DirPer))

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir		Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 DirPer	Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 Dir		Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 DirPer	Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 Dir		Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 DirPer	Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 Dir		Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 DirPer	Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONDIAMETRIC ( VlaObject /
	Dir
	DisObj
	P1
	P2
	PC
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P1 (cdr (assoc 10 DataEnameObject)))
	(setq P2 (cdr (assoc 15 DataEnameObject)))
	(setq PC (RND_FIND_MIDPOINT P1 P2))

	(setq Dir (angle PC P1))
	(setq DisObj (distance PC P1))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir DisObj P1)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj PC)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONFCF ( VlaObject /
	Dir
	P
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P (cdr (assoc 10 DataEnameObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) (cdr (assoc 11 DataEnameObject))))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P Dir Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONRADIAL ( VlaObject /
	Dir
	DisObj
	PC
	P1
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq PC (cdr (assoc 10 DataEnameObject)))
	(setq P1 (cdr (assoc 15 DataEnameObject)))

	(setq Dir (angle PC P1))
	(setq DisObj (distance PC P1))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir DisObj P1)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj PC)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONRADIALLARGE ( VlaObject /
	Dir
	DisObj
	PC
	P1
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq PC (cdr (assoc 10 DataEnameObject)))
	(setq P1 (cdr (assoc 15 DataEnameObject)))

	(setq Dir (angle PC P1))
	(setq DisObj (distance PC P1))
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P PC Dir DisObj P1)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 Dir DisObj PC)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_1_FROM_DIMENSIONROTATED ( VlaObject /
	DataEnameObject
	Dir
	DirPer
	DisObj
	P1
	P2
	P3
	P4)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq Dir (cdr (assoc 50 DataEnameObject)))
	(setq DirPer (+ Dir PiHalf))
	(setq P1 (cdr (assoc 14 DataEnameObject)))
	(setq P2 (cdr (assoc 13 DataEnameObject)))
	(setq P3 (cdr (assoc 10 DataEnameObject)))
	(setq P4 (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir P2 DirPer))

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P1 DirPer	Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 DirPer	Nil Nil)

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P2 DirPer	Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 DirPer	Nil Nil)

	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P3 Dir		Nil Nil)
	(RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P P4 Dir		Nil Nil)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_2 ( /
	DirTan
	DirTanNew
	DisObjMin
	ListDirNew
	ListDisObj
	ListPoint
	List_AddTan_NameVar_Node_DirTanNew
	Node
	NumRoundOffLocal
	NumRoundOffLocalTemp
	Temp1
	Temp2)

;;Level 1
;;NameVar
;;	Dir_DisObj_PCnt...
;;	List_Dir_DisObj_PCnt_NameVar_P

;;	[P_DirTan]...
;;	List_P_DirTan

;;Level 2
;;NameVar
;;	[P_Dir_DirNew_DisObj_PCnt]...
;;	List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node

;;NameVar
;;	Node
;;	List_Node_NameVar_P

;;NameVar
;;	NumRnd
;;	List_NumRnd_NameVar_Node

;;NameVar
;;	CheckTan
;;	List_CheckTan_NameVar_Node_DirTanNew

;;NameVar
;;	DirTanNew...
;;	List_DirTanNew_NameVar_Node

;;NameVar
;;	DirChamNew...
;;	List_DirChamNew_NameVar_Node

	(setq ListDisObj (vl-remove Nil (apply 'append (mapcar '(lambda (x) (mapcar 'cadr (eval (car x)))) List_Dir_DisObj_PCnt_NameVar_P))))
	(setq DisObjMin (car ListDisObj))
	(foreach DisObj ListDisObj
		(if (and (< DisObj DisObjMin) (/= (RND_ROUNDOFF_NUMBER DisObj NumZero) 0.0))
			(setq DisObjMin DisObj)
		)
	)
	(if (not DisObjMin)
		(setq DisObjMin NumRoundOffSubdiv)
		(setq DisObjMin (/ DisObjMin NumRoundOffSubdiv))
	)
	(if (< DisObjMin NumRoundOffMin)
		(setq DisObjMin NumRoundOffMin)
	)

	(setq ListPoint (mapcar 'cadr List_Dir_DisObj_PCnt_NameVar_P))
	(setq NumRoundOffLocal NumRoundOffMax)
	(while ListPoint
		(setq ListPoint (RND_FIND_NODENEW_LEVEL_2_SUB ListPoint NumRoundOffLocal))
		(setq NumRoundOffLocal (/ NumRoundOffLocal NumRoundOffSubdiv))
	)

	(foreach Temp1 List_P_DirTan
		(setq Node (RND_FIND_NODE_FROM_P (car Temp1) ObjectLevel))
		(setq DirTan (cadr Temp1))
		(setq DirTanNew (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL DirTan))
		(RND_ADD_LIST_ADDTAN_NAMEVAR_NODE_DIRTANNEW (list Node DirTanNew))
	)

	(foreach Temp1 List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node
		(setq Node (cadr Temp1))
		(setq Temp2 (eval (car Temp1)))
		(setq NumRoundOffLocal (RND_FIND_NUMRND_FROM_NODE Node))
		(setq ListDirNew (mapcar '(lambda (x) (nth 2 x)) Temp2))
		(setq ListDisObj (mapcar '(lambda (x) (nth 3 x)) Temp2))
		(setq NumRoundOffLocalTemp NumRoundOffLocal)
		(setq NumRoundOffLocal (RND_FIND_NUMROUNDOFFLOCAL ListDirNew ListDisObj NumRoundOffLocal))

		(if
			(and
				CheckCreatePointCheck
				(/= NumRoundOffLocal NumRoundOffLocalTemp)
			)
			(setq ListNodeChangeNumRnd (cons Node ListNodeChangeNumRnd))
		)
		(RND_ADD_LIST_NUMRND_NAMEVAR_NODE Node NumRoundOffLocal)

		(if CheckKeepFillet
			(foreach DirNew ListDirNew
				(RND_ADD_LIST_CHECKTAN_NAMEVAR_NODE_DIRTANNEW (list Node DirNew) ObjectLevel)
			)
		)
	)

	(foreach Temp1 List_CheckTan_NameVar_Node_DirTanNew
		(setq Temp2 (cadr Temp1))
		(setq Node (car Temp2))
		(setq DirTanNew (cadr Temp2))
		(RND_ADD_LIST_DIRTANNEW_NAMEVAR_NODE Node DirTanNew)
	)
	
	(RND_RESET_LISTNAMEVAR List_AddTan_NameVar_Node_DirTanNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_2_SUB ( ListPoint NumRoundOffLocal /
	List_Node_Point
	List_Point_NameVar_Node
	ListPointAdd
	ListResult
	ListTemp
	NameVar
	Node
	NumRoundOffLocalNext
	P1
	Point
	Temp1)

	(foreach Point ListPoint
		(setq Node (RND_FIND_NODE_SUB Point NumRoundOffLocal))
		(setq NameVar (RND_CREATE_NAMEVAR_POINT "Point_FindNodeSub" Node))
		(if (not (setq ListTemp (eval NameVar)))
			(setq List_Point_NameVar_Node (cons (list NameVar Node) List_Point_NameVar_Node))
		)
		(set NameVar (cons Point ListTemp))
	)
	(setq List_Node_Point (mapcar '(lambda (x) (cons (cadr x) (eval (car x)))) List_Point_NameVar_Node))
	(setq NumRoundOffLocalNext (/ NumRoundOffLocal NumRoundOffSubdiv))
	(foreach Temp1 List_Node_Point
		(if
			(and
				(caddr Temp1)
				(>= NumRoundOffLocalNext DisObjMin)
			)
			(setq ListResult (append (cdr Temp1) ListResult))
			(progn
				(setq Node (car Temp1))
				(setq ListPointAdd (cdr Temp1))
				(foreach P1 ListPointAdd
					(RND_ADD_LIST_P_DIR_DIRNEW_DISOBJ_PCNT P1 Node NumRoundOffLocal)
					(RND_ADD_LIST_NODE_NAMEVAR_P P1 Node ObjectLevel)
				)
				(RND_ADD_LIST_NUMRND_NAMEVAR_NODE Node NumRoundOffLocal)
			)
		)
	)
	(RND_RESET_LISTNAMEVAR List_Point_NameVar_Node)

	(if (and CheckCreatePointCheck ListResult)
		(setq ListPointChangeNumRnd_ObjectLevel (append ListPointChangeNumRnd_ObjectLevel (list (list ListResult ObjectLevel))))
	)
	ListResult
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_P_DIR_DIRNEW_DISOBJ_PCNT ( P1 Node NumRoundOffLocal /
	List_Dir_DisObj_PCnt
	Dir
	DirCham
	DirNew
	DirChamNew
	DirTemp
	Dir1
	Dir2
	Dir2Temp
	Dis1
	Dis1New
	Dis2
	Dis2New
	DisObj
	Num1
	Num2
	P
	P2
	PCnt
	PTemp
	Temp1
	Temp2)

	(setq List_Dir_DisObj_PCnt (RND_FIND_LIST_DIR_DISOBJ_PCNT_FROM_P P1))
	(setq P (RND_FIND_POINT_BLOCK_TO_MODEL P1))

	(setq Num1 0)
	(foreach Temp1 List_Dir_DisObj_PCnt
		(setq Num2 0)
		(setq Dir1 (nth 0 Temp1))

		(setq DirTemp (RND_FIND_DIR_BLOCK_TO_MODEL Dir1))
		(setq Dir (RND_FIND_DIRLIN DirTemp))
		(setq DirNew (RND_FIND_DIRLINNEW DirTemp))
		(setq DisObj (nth 1 Temp1))
		(setq PCnt (nth 2 Temp1))
		(RND_ADD_LIST_P_DIR_DIRNEW_DISOBJ_PCNT_NAMEVAR_NODE Node P Dir DirNew DisObj PCnt)

		(if CheckKeepChamfer
			(foreach Temp2 List_Dir_DisObj_PCnt
				(if (/= Num1 Num2)
					(progn
						(setq P2 (nth 2 Temp2))
						(setq Dir2Temp (car Temp2))
						(foreach Dir2 (mapcar 'car (RND_FIND_LIST_DIR_DISOBJ_PCNT_FROM_P P2))
							(if (not (RND_CHECK_PI (- Dir2 Dir2Temp)))
								(progn
									(if (RND_CHECK_PIHALF (- Dir1 Dir2))
										(setq PTemp (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1 Dir1 P2 Dir2))
									)
									(if (RND_CHECK_PI (- Dir1 Dir2))
										(setq PTemp (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1 Dir1 P2 (+ Dir2 PiHalf)))
									)
									(if PTemp
										(progn
											(setq Dis1 (distance P1 PTemp))
											(setq Dis2 (distance P2 PTemp))
											(if
												(and
													(= (setq Dis1New (RND_ROUNDOFF_NUMBER Dis1 NumRoundOffLocal)) (RND_ROUNDOFF_NUMBER Dis1 NumRoundOffMin))
													(= (setq Dis2New (RND_ROUNDOFF_NUMBER Dis2 NumRoundOffLocal)) (RND_ROUNDOFF_NUMBER Dis2 NumRoundOffMin))
													(/= Dis1New Dis2New)
												)
												(progn
													(setq DirTemp (RND_FIND_DIR_BLOCK_TO_MODEL (+ Dir1 PiHalf)))
													(setq DirCham (RND_FIND_DIRLIN DirTemp))
													(setq DirChamNew (RND_FIND_DIRLINNEW DirTemp))
													(RND_ADD_LIST_P_DIR_DIRNEW_DISOBJ_PCNT_NAMEVAR_NODE Node P DirCham DirChamNew Nil Nil)
													(RND_ADD_LIST_DIRCHAMNEW_NAMEVAR_NODE Node (list DirNew DirChamNew))
												)
											)
										)
									)
								)
							)
						)
					)
				)
				(setq Num2 (+ Num2 1))
			)
		)
		(setq Num1 (+ Num1 1))
	)	
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_3 ( /
	Add
	Add1
	Add2
	Dir1
	DirMean
	DirNew
	DirNew_PVY
	DirNew_P1VY
	DirNew_P2VY
	DirNew
	List_PosNode_Add
	List_CheckDuplicateNode_NameVar_Pos1
	List_NumRnd_NameVar_DirNew_PVY
	List_PBase_NameVar_DirNew_PVY
	List_PosNode_Add_NameVar_DirNew_PVY
	List_PosNode_NameVar_DirNew
	ListDir1
	ListPoint
	ListTemp
	ListTemp1
	ListTemp2
	NameVar
	NameVar1
	NameVar2
	Node
	NodeCnt
	Num1
	Num2
	NumDir
	NumDirCount
	NumRnd
	NumRndMin
	P
	P1
	P1V
	P1VY
	P2
	P2V
	P2VY
	PBase
	PVY
	Pos1
	Pos2
	PosNode
	PosNode1
	PosNode2
	PosNode_Add
	Temp1
	Temp2
	Temp3)

;;Level 2
;;NameVar
;;	[P_Dir_DirNew_DisObj_PCnt]...
;;	List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node

;;Level 3
;;NameVar
;;	P_PBase_NumRnd_NodeCnt
;;	List_P_PBase_NumRnd_NodeCnt_NameVar_Node_DirNew

;;NameVar
;;	DirNew...
;;	List_DirNew_NameVar_Node

	(setq Pos1 0)
	(foreach Temp1 List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node
		(setq Pos2 0)
		(foreach Temp2 (eval (car Temp1))
			(setq DirNew (nth 2 Temp2))
			(setq NameVar (RND_CREATE_NAMEVAR_DIR "PosNode" DirNew))
			(if (not (setq ListTemp (eval NameVar)))
				(setq List_PosNode_NameVar_DirNew (cons (list NameVar DirNew) List_PosNode_NameVar_DirNew))
			)
			(set NameVar (cons (cons Pos1 Pos2) ListTemp))
			(setq Pos2 (+ Pos2 1))
		)
		(setq Pos1 (+ Pos1 1))
	)
	(setq List_PosNode_NameVar_DirNew (vl-sort List_PosNode_NameVar_DirNew '(lambda (e1 e2) (> (length (eval (car e1))) (length (eval (car e2)))))))

	(setq Num1 0)
	(foreach Temp1 List_PosNode_NameVar_DirNew
		(setq ListDir1 Nil)
		(RND_RESET_LISTNAMEVAR List_CheckDuplicateNode_NameVar_Pos1)
		(setq List_CheckDuplicateNode_NameVar_Pos1 Nil)
		(setq DirNew (cadr Temp1))
		(foreach PosNode1 (eval (car Temp1))
			(setq Add1 0)
			(if (RND_CHECKNOTDUPLICATENODE (car PosNode1) Add1)
				(progn
					(setq NameVar1 (car (nth (car PosNode1) List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node)))
					(setq ListTemp1 (nth (cdr PosNode1) (eval NameVar1)))
					(setq P1 (nth 0 ListTemp1))
					(setq Dir1 (nth 1 ListTemp1))
					(setq ListDir1 (cons Dir1 ListDir1))
					(setq P1V (RND_ROUNDOFF_POINT (RND_TRANSFORMATION_ROTATE P1 (- Dir1)) NumRoundOffMin))
					(setq P1VY (cadr P1V))
					(setq DirNew_P1VY (list DirNew P1VY))
					(setq NameVar1 (RND_CREATE_NAMEVAR_POINT_DIR_PY "PosNode_Add" DirNew_P1VY))
					(if (not (setq ListTemp1 (eval NameVar1)))
						(setq List_PosNode_Add_NameVar_DirNew_PVY (cons (list NameVar1 DirNew_P1VY) List_PosNode_Add_NameVar_DirNew_PVY))
					)
					(set NameVar1 (cons (list PosNode1 Add1) ListTemp1))
				)
			)
		)
		(setq DirMean (/ (apply '+ ListDir1) (length ListDir1)))

		(setq NumDir (length (mapcar '(lambda (x) (list (RND_RADIAN_TO_DEGREE (cadr x)) (length (eval (car x))))) List_PosNode_NameVar_DirNew)))
		(if (or (<= NumDir NumDirMaxDoNotCheckLinear) (= NumDirMaxDoNotCheckLinear 0))
			(progn
				(setq Num2 0)
				(setq NumDirCount 1)
				(foreach Temp1 List_PosNode_NameVar_DirNew
					(if (/= Num1 Num2)
						(if (or (<= NumDirCount NumDirMaxCheckLinear) (= NumDirMaxCheckLinear 0))
							(progn
								(foreach PosNode2 (eval (car Temp1))
									(setq Add2 1)
									(if (RND_CHECKNOTDUPLICATENODE (car PosNode2) Add2)
										(progn
											(setq NameVar2 (car (nth (car PosNode2) List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node)))
											(setq ListTemp2 (nth (cdr PosNode2) (eval NameVar2)))
											(setq P2 (nth 0 ListTemp2))
											(setq P2V (RND_ROUNDOFF_POINT (RND_TRANSFORMATION_ROTATE P2 (- DirMean)) NumRoundOffMin))
											(setq P2VY (cadr P2V))
											(setq DirNew_P2VY (list DirNew P2VY))
											(setq NameVar2 (RND_CREATE_NAMEVAR_POINT_DIR_PY "PosNode_Add" DirNew_P2VY))
											(if (setq ListTemp2 (eval NameVar2))
												(set NameVar2 (cons (list PosNode2 Add2) ListTemp2))
											)
										)
									)
								)
								(setq NumDirCount (+ NumDirCount 1))
							)
						)
					)
					(setq Num2 (+ Num2 1))
				)
			)
		)
		(setq Num1 (+ Num1 1))
	)

	(foreach Temp1 List_PosNode_Add_NameVar_DirNew_PVY
		(setq DirNew_PVY (cadr Temp1))
		(setq DirNew (car DirNew_PVY))
		(setq NumRndMin NumRoundOffMax)
		(setq ListPoint nil)
		(foreach PosNode_Add (eval (car Temp1))
			(setq PosNode (car PosNode_Add))
			(setq Temp2 (nth (car PosNode) List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node))
			(setq Node (cadr Temp2))
			(setq NumRnd (RND_FIND_NUMRND_FROM_NODE Node))
			(if (> NumRndMin NumRnd) (setq NumRndMin NumRnd))
			(setq Temp3 (nth (cdr PosNode) (eval (car Temp2))))
			(setq P (nth 0 Temp3))
			(setq ListPoint (cons P ListPoint))
		)

		(setq PBase (RND_FIND_PBASE ListPoint DirNew NumRndMin))
		(setq NameVar (RND_CREATE_NAMEVAR_POINT_DIR_PY "PBase" DirNew_PVY))
		(if (not (eval NameVar))
			(setq List_PBase_NameVar_DirNew_PVY (cons (list NameVar DirNew_PVY) List_PBase_NameVar_DirNew_PVY))
		)
		(set NameVar PBase)

		(setq NameVar (RND_CREATE_NAMEVAR_POINT_DIR_PY "NumRnd" DirNew_PVY))
		(if (not (eval NameVar))
			(setq List_NumRnd_NameVar_DirNew_PVY (cons (list NameVar DirNew_PVY) List_NumRnd_NameVar_DirNew_PVY))
		)
		(set NameVar NumRndMin)
	)

	(foreach Temp1 List_PosNode_Add_NameVar_DirNew_PVY
		(setq DirNew_PVY (cadr Temp1))
		(setq DirNew (car DirNew_PVY))
		(setq PBase (eval (RND_CREATE_NAMEVAR_POINT_DIR_PY "PBase" DirNew_PVY)))
		(setq NumRnd (eval (RND_CREATE_NAMEVAR_POINT_DIR_PY "NumRnd" DirNew_PVY)))

		(foreach PosNode_Add (eval (car Temp1))
			(setq PosNode (car PosNode_Add))
			(setq Add (cadr PosNode_Add))
			(setq Temp2 (nth (car PosNode) List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node))
			(setq Node (cadr Temp2))
			(setq Temp3 (nth (cdr PosNode) (eval (car Temp2))))
			(setq P (nth 0 Temp3))
			(if (= Add 0)
				(progn
					(setq DirNew (nth 2 Temp3))
					(setq NodeCnt (RND_FIND_NODE_FROM_P (nth 4 Temp3) ObjectLevel))
					(RND_ADD_LIST_P_PBASE_NUMRND_NODECNT_NAMEVAR_NODE_DIRNEW (list Node DirNew) P PBase NumRnd NodeCnt ObjectLevel)
					(RND_ADD_LIST_DIRNEW_NAMEVAR_NODE Node DirNew)
				)
			)
			(if (= Add 1)
				(foreach DirNew (list DirNew)
					(RND_ADD_LIST_P_PBASE_NUMRND_NODECNT_NAMEVAR_NODE_DIRNEW (list Node DirNew) P PBase NumRnd Nil ObjectLevel)
					(RND_ADD_LIST_DIRNEW_NAMEVAR_NODE Node DirNew)
				)
			)
		)
	)

	(mapcar
		'RND_RESET_LISTNAMEVAR
		(list
			List_CheckDuplicateNode_NameVar_Pos1
			List_NumRnd_NameVar_DirNew_PVY
			List_PBase_NameVar_DirNew_PVY
			List_PosNode_Add_NameVar_DirNew_PVY
			List_PosNode_NameVar_DirNew
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECKNOTDUPLICATENODE ( Pos1 Add / NameVar CheckResult)
	(setq NameVar (RND_CREATE_NAMEVAR_NUM "CheckNotDuplicateNode" Pos1))
	(if (= Add 0)
		(progn
			(setq CheckResult T)
			(if (not (eval NameVar))
				(progn
					(setq List_CheckDuplicateNode_NameVar_Pos1 (cons (list NameVar Pos1) List_CheckDuplicateNode_NameVar_Pos1))
					(set NameVar T)
				)
			)
		)
	)

	(if (= Add 1)
		(if (eval NameVar)
			(setq CheckResult Nil)
			(progn
				(setq List_CheckDuplicateNode_NameVar_Pos1 (cons (list NameVar Pos1) List_CheckDuplicateNode_NameVar_Pos1))
				(set NameVar T)
				(setq CheckResult T)
			)
		)
	)
	CheckResult
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_4 ( /
	Count
	Count1
	Count2
	CountMax
	DirNew
	Dir1New
	Dir2New
	DirTanNew
	List1
	List1CountSort
	List1Dir
	List1Reverse
	List2
	List2CountSort
	List2Dir
	List2Reverse
	List3Dir
	ListDirNew
	ListDirChamNew
	ListDirTanNew
	ListTemp
	ListTemp1
	ListTemp2
	ListTemp3
	List_DirNew_Count
	NumDir
	Node
	Temp1
	Temp2)

;;Level 2
;;NameVar
;;	CheckTan
;;	List_CheckTan_NameVar_Node_DirTanNew

;;NameVar
;;	DirTanNew...
;;	List_DirTanNew_NameVar_Node

;;NameVar
;;	DirChamNew...
;;	List_DirChamNew_NameVar_Node

;;Level 3
;;NameVar
;;	DirNew...
;;	List_DirNew_NameVar_Node

;;Level 4
;;NameVar
;;	Count
;;	List_Count_NameVar_DirNew

;;	DirMain

;;	[Node_Dir1New_Dir2New]...
;;	List_Node_Dir1New_Dir2New

	(setq ListDirNew (apply 'append (mapcar '(lambda (x) (eval (car x))) List_DirNew_NameVar_Node)))
	(setq List_DirNew_Count (RND_FIND_LIST_DIRNEW_COUNT ListDirNew))
	(foreach DirNew_Count List_DirNew_Count
		(setq DirNew (car DirNew_Count))
		(setq Count (cdr DirNew_Count))
		(RND_ADD_LIST_COUNT_NAMEVAR_DIRNEW DirNew Count)
	)

	(if (not DirMain)
		(progn
			(setq CountMax -1)
			(foreach DirNew_Count List_DirNew_Count
				(setq Count (cdr DirNew_Count))
				(if (< CountMax Count)
					(progn
						(setq DirNew (car DirNew_Count))
						(setq CountMax Count)
						(setq DirMain DirNew)
					)
				)
			)
		)
	)

	(foreach Temp1 List_DirNew_NameVar_Node
		(setq Node (cadr Temp1))
		(setq List1Dir (eval (car Temp1)))
		(setq NumDir (length List1Dir))
		
		(if (> NumDir 2)
			(progn
				(setq ListDirTanNew (RND_FIND_DIRTANNEW_FROM_NODE Node))
				(setq ListTemp
					(vl-sort
						(RND_FIND_LIST_DIRNEW_COUNT ListDirTanNew)
						'(lambda (e1 e2)
							(> (cdr e1) (cdr e2))
						)
					)
				)
				(setq Dir1New (car (car ListTemp)))
				(setq Dir2New (car (cadr ListTemp)))

				(if (not Dir1New)
					(progn
						(setq ListDirChamNew (RND_FIND_DIRCHAMNEW_FROM_NODE Node))
						(setq Dir1New (car ListDirChamNew))
						(setq Dir2New (cadr ListDirChamNew))
					)
				)

				(setq List1 (RND_FIND_LIST_DIRNEW_COUNT List1Dir))
				(setq List1Reverse (mapcar '(lambda (x) (cons (cdr x) (car x))) List1))
				(setq List1CountSort (vl-sort (mapcar 'car List1Reverse) '>))
				(foreach Count1 List1CountSort
					(if
						(or (not Dir1New) (not Dir2New))
						(progn
							(setq List2Dir (mapcar 'cdr (RND_FIND_LIST_FORM_FIRST_ELEMENT Count1 List1Reverse)))
							(setq List2 (RND_FIND_LIST_DIR_COUNT_FROM_DIR_COUNT_TOTAL List2Dir))
							(setq List2Reverse (mapcar '(lambda (x) (cons (cdr x) (car x))) List2))
							(setq List2CountSort (vl-sort (mapcar 'car List2Reverse) '>))
							(foreach Count2 List2CountSort
								(if
									(or (not Dir1New) (not Dir2New))
									(progn
										(setq List3Dir (mapcar 'cdr (RND_FIND_LIST_FORM_FIRST_ELEMENT Count2 List2Reverse)))
										(setq Temp2 (RND_FIND_DIR1NEW_AND_DIR2NEW_IN_LISTDIRNEW List3Dir Dir1New Dir2New))
										(setq Dir1New (nth 0 Temp2))
										(setq Dir2New (nth 1 Temp2))
									)
								)
							)
						)
					)
				)
				(setq ListTemp3 (cons (list Node Dir1New Dir2New) ListTemp3))
			)
		)
		(if (= NumDir 2)
			(progn
				(setq Temp2 (RND_FIND_DIR1NEW_AND_DIR2NEW_IN_LISTDIRNEW List1Dir Nil Nil))
				(setq Dir1New (nth 0 Temp2))
				(setq Dir2New (nth 1 Temp2))
				(setq ListTemp2 (cons (list Node Dir1New Dir2New) ListTemp2))
			)
		)
		(if (= NumDir 1)
			(progn
				(setq Temp2 (RND_FIND_DIR1NEW_AND_DIR2NEW_IN_LISTDIRNEW List1Dir Nil Nil))
				(setq Dir1New (nth 0 Temp2))
				(setq Dir2New (nth 1 Temp2))
				(setq ListTemp1 (cons (list Node Dir1New Dir2New) ListTemp1))
			)
		)
	)

	(setq List_Node_Dir1New_Dir2New (append ListTemp3 ListTemp2 ListTemp1))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LIST_DIRNEW_COUNT ( ListDirNew /
	Count
	List_DirNew_Count)

	(foreach DirNew ListDirNew
		(if (not (setq Count (RND_FIND_PRIOR_FROM_ANGSTD DirNew)))
			(setq Count 0)
		)
		(setq List_DirNew_Count (cons (cons DirNew Count) List_DirNew_Count))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_LEVEL_5 ( /
	Dir1New
	Dir2New
	ListTemp1
	ListTemp2
	Node
	NodeNew
	NumRoundOffLocal1
	P1
	P1Base
	P2Base
	P1Temp
	P2Temp
	PointNewModel
	Temp1)


;;Level 3
;;NameVar
;;	P_PBase_NumRnd_NodeCnt
;;	List_P_PBase_NumRnd_NodeCnt_NameVar_Node_DirNew

;;Level 4
;;	[Node_Dir1New_Dir2New]...
;;	List_Node_Dir1New_Dir2New

;;Level 5
;;	NodeNew
;;	List_NodeNew_NameVar_Node

;;	PointNewModel
;;	List_PointNewModel_NameVar_Node

	(foreach Temp List_Node_Dir1New_Dir2New
		(setq Node (nth 0 Temp))
		(if (not (RND_FIND_NODENEW_FROM_NODE Node))
			(progn
				(setq Dir1New (nth 1 Temp))
				(setq Dir2New (nth 2 Temp))
				(setq ListTemp1 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node Dir1New) ObjectLevel))
				(setq P1Temp (RND_FIND_POINTNEWMODEL_FROM_NODE (nth 3 ListTemp1)))
				(if P1Temp
					(setq P1Base P1Temp)
					(setq P1Base (nth 1 ListTemp1))
				)
				(if
					(and
						Dir2New
						(not (RND_CHECK_PI (- Dir1New Dir2New)))
					)
					(progn
						(setq ListTemp2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node Dir2New) ObjectLevel))
						(setq P2Temp (RND_FIND_POINTNEWMODEL_FROM_NODE (nth 3 ListTemp2)))
						(if P2Temp
							(setq P2Base P2Temp)
							(setq P2Base (nth 1 ListTemp2))
						)
					)
					(progn
						(setq Dir2New (+ Dir1New PiHalf))
						(setq P1 (nth 0 ListTemp1))
						(setq NumRoundOffLocal1 (nth 2 ListTemp1))
						(setq P2Base (RND_ROUNDOFF_POINT_IN_VIRTUAL_COORDINATE_SYSTEM P1 Dir1New NumRoundOffLocal1))
					)
				)
				(setq PointNewModel (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1Base Dir1New P2Base Dir2New))
				(RND_ADD_LIST_POINTNEWMODEL_NAMEVAR_NODE Node PointNewModel)
				(setq NodeNew (RND_FIND_POINT_MODEL_TO_BLOCK PointNewModel))
				(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node NodeNew)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;Level 1
(defun RND_ADD_LIST_DIR_DISOBJ_PCNT_NAMEVAR_P ( P Dir DisObj PCnt / ListTemp NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "Dir_DisObj_PCnt" P))
	(if (not (setq ListTemp (eval NameVar)))
		(setq List_Dir_DisObj_PCnt_NameVar_P (cons (list NameVar P) List_Dir_DisObj_PCnt_NameVar_P))
	)
	(set NameVar (cons (list Dir DisObj PCnt) ListTemp))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LIST_DIR_DISOBJ_PCNT_FROM_P ( P / )
	(eval (RND_CREATE_NAMEVAR_POINT "Dir_DisObj_PCnt" P))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_P_DIRTAN ( P DirTan / )
	(setq List_P_DirTan (cons (list P DirTan) List_P_DirTan))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;Level 2
(defun RND_ADD_LIST_P_DIR_DIRNEW_DISOBJ_PCNT_NAMEVAR_NODE ( Node P Dir DirNew DisObj PCnt / ListTemp NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "P_Dir_DirNew_DisObj_PCnt" Node))
	(if (not (setq ListTemp (eval NameVar)))
		(setq List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node (cons (list NameVar Node) List_P_Dir_DirNew_DisObj_PCnt_NameVar_Node))
	)
	(set NameVar (cons (list P Dir DirNew DisObj PCnt) ListTemp))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_NODE_NAMEVAR_P ( P Node ObjectLevel / NameVar StringType)
	(setq StringType (strcat "Node" ObjectLevel))
	(setq NameVar (RND_CREATE_NAMEVAR_POINT StringType P))
	(if (not (eval NameVar))
		(setq List_Node_NameVar_P (cons (list NameVar P) List_Node_NameVar_P))
	)
	(set NameVar Node)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODE_FROM_P ( P ObjectLevel / StringType)
	(setq StringType (strcat "Node" ObjectLevel))
	(eval (RND_CREATE_NAMEVAR_POINT StringType P))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_NUMRND_NAMEVAR_NODE ( Node NumRnd / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "NumRnd" Node))
	(if (not (eval NameVar))
		(setq List_NumRnd_NameVar_Node (cons (list NameVar Node) List_NumRnd_NameVar_Node))
	)
	(set NameVar NumRnd)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NUMRND_FROM_NODE ( Node / )
	(eval (RND_CREATE_NAMEVAR_POINT "NumRnd" Node))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_ADDTAN_NAMEVAR_NODE_DIRTANNEW ( Node_DirTanNew / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT_DIR "AddTan" Node_DirTanNew))
	(if (not (eval NameVar))
		(setq List_AddTan_NameVar_Node_DirTanNew (cons (list NameVar Node_DirTanNew) List_AddTan_NameVar_Node_DirTanNew))
	)
	(set NameVar T)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_CHECKTAN_NAMEVAR_NODE_DIRTANNEW ( Node_DirTanNew ObjectLevel / NameVar StringType)
	(if (eval (RND_CREATE_NAMEVAR_POINT_DIR "AddTan" Node_DirTanNew))
		(progn
			(setq StringType (strcat "CheckTan" ObjectLevel))
			(setq NameVar (RND_CREATE_NAMEVAR_POINT_DIR StringType Node_DirTanNew))
			(if (not (eval NameVar))
				(setq List_CheckTan_NameVar_Node_DirTanNew (cons (list NameVar Node_DirTanNew) List_CheckTan_NameVar_Node_DirTanNew))
			)
			(set NameVar T)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_CHECKTAN_FROM_NODE_DIRTANNEW ( Node_DirTanNew ObjectLevel / StringType)
	(setq StringType (strcat "CheckTan" ObjectLevel))
	(eval (RND_CREATE_NAMEVAR_POINT_DIR StringType Node_DirTanNew))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_DIRTANNEW_NAMEVAR_NODE ( Node DirTanNew / NameVar ListTemp)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "DirTanNew" Node))
	(if (not (setq ListTemp (eval NameVar)))
		(setq List_DirTanNew_NameVar_Node (cons (list NameVar Node) List_DirTanNew_NameVar_Node))
	)
	(set NameVar (cons DirTanNew ListTemp))	
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRTANNEW_FROM_NODE ( Node / )
	(eval (RND_CREATE_NAMEVAR_POINT "DirTanNew" Node))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_DIRCHAMNEW_NAMEVAR_NODE ( Node DirNew_DirChamNew / NameVar ListTemp)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "DirChamNew" Node))
	(if (not (eval NameVar))
		(progn
			(setq List_DirChamNew_NameVar_Node (cons (list NameVar Node) List_DirChamNew_NameVar_Node))
			(set NameVar DirNew_DirChamNew)	
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRCHAMNEW_FROM_NODE ( Node / )
	(eval (RND_CREATE_NAMEVAR_POINT "DirChamNew" Node))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;Level 3
(defun RND_ADD_LIST_P_PBASE_NUMRND_NODECNT_NAMEVAR_NODE_DIRNEW ( Node_DirNew P PBase NumRnd NodeCnt ObjectLevel / NameVar StringType)
	(setq StringType (strcat "P_PBase_NumRnd_NodeCnt" ObjectLevel))
	(setq NameVar (RND_CREATE_NAMEVAR_POINT_DIR StringType Node_DirNew))
	(if (not (eval NameVar))
		(setq List_P_PBase_NumRnd_NodeCnt_NameVar_Node_DirNew (cons (list NameVar Node_DirNew) List_P_PBase_NumRnd_NodeCnt_NameVar_Node_DirNew))
	)
	(set NameVar (list P PBase NumRnd NodeCnt))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW ( Node_DirNew ObjectLevel / StringType)
	(setq StringType (strcat "P_PBase_NumRnd_NodeCnt" ObjectLevel))
	(eval (RND_CREATE_NAMEVAR_POINT_DIR StringType Node_DirNew))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_DIRNEW_NAMEVAR_NODE ( Node DirNew / ListTemp NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "DirNew" Node))
	(if (not (setq ListTemp (eval NameVar)))
		(setq List_DirNew_NameVar_Node (cons (list NameVar Node) List_DirNew_NameVar_Node))
	)
	(set NameVar (cons DirNew ListTemp))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;Level 4
(defun RND_ADD_LIST_COUNT_NAMEVAR_DIRNEW ( DirNew Count / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_DIR "Count" DirNew))
	(if (not (eval NameVar))
		(setq List_Count_NameVar_DirNew (cons (list NameVar DirNew) List_Count_NameVar_DirNew))
	)
	(set NameVar Count)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;;Level 5
(defun RND_ADD_LIST_NODENEW_NAMEVAR_NODE ( Node NodeNew / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "NodeNew" Node))
	(if (not (eval NameVar))
		(setq List_NodeNew_NameVar_Node (cons (list NameVar Node) List_NodeNew_NameVar_Node))
	)
	(set NameVar NodeNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODENEW_FROM_NODE ( Node / )
	(if Node
		(eval (RND_CREATE_NAMEVAR_POINT "NodeNew" Node))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_POINTNEWMODEL_NAMEVAR_NODE ( Node PointNewModel / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "PointNewModel" Node))
	(if (not (eval NameVar))
		(setq List_PointNewModel_NameVar_Node (cons (list NameVar Node) List_PointNewModel_NameVar_Node))
	)
	(set NameVar PointNewModel)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINTNEWMODEL_FROM_NODE ( Node / )
	(if Node
		(eval (RND_CREATE_NAMEVAR_POINT "PointNewModel" Node))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_PCNEW_NAMEVAR_PC ( PC PCNew / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT "PCNew" PC))
	(if (not (eval NameVar))
		(setq List_PCNew_NameVar_PC (cons (list NameVar PC) List_PCNew_NameVar_PC))
	)
	(set NameVar PCNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_PCNEW_FROM_PC ( PC / )
	(eval (RND_CREATE_NAMEVAR_POINT "PCNew" PC))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ADD_LIST_PCNEW_RADNEW_NAMEVAR_PC_RAD ( PC_Rad PCNew_RadNew / NameVar)
	(setq NameVar (RND_CREATE_NAMEVAR_POINT_DISTANCE "PCNew_RadNew" PC_Rad))
	(if (not (eval NameVar))
		(setq List_PCNew_RadNew_NameVar_PC_Rad (cons (list NameVar PC_Rad) List_PCNew_RadNew_NameVar_PC_Rad))
	)
	(set NameVar PCNew_RadNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_PCNEW_RADNEW_FROM_PC_RAD ( PC_Rad / )
	(eval (RND_CREATE_NAMEVAR_POINT_DISTANCE "PCNew_RadNew" PC_Rad))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_POINT ( String Point / )
	(read
		(strcat
			String
			(apply 'strcat (mapcar '(lambda (x) (RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR x LengthVarNamePoint)) Point))
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_DIR ( String Dir / )
	(read
		(strcat
			String
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR Dir LengthVarNameDir)
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_DIRDEG ( String DirDeg / )
	(read
		(strcat
			String
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR DirDeg LengthVarNameDirDeg)
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_NUM ( String Num / )
	(read
		(strcat
			String
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR Num LengthVarNameNum)
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_LISTNUM ( String ListNum / )
	(read
		(strcat
			String
			(apply 'strcat (mapcar '(lambda (x) (RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR x LengthVarNameNum)) ListNum))
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_POINT_DIR ( String Point_Dir / )
	(read
		(strcat
			String
			(apply 'strcat (mapcar '(lambda (x) (RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR x LengthVarNamePoint)) (car Point_Dir)))
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR (cadr Point_Dir) LengthVarNameDir)
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_POINT_DISTANCE ( String Point_Distance / )
	(read
		(strcat
			String
			(apply 'strcat (mapcar '(lambda (x) (RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR x LengthVarNamePoint)) (car Point_Distance)))
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR (cadr Point_Distance) LengthVarNamePoint)
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_POINT_DIR_PY ( String Dir_PY / )
	(read
		(strcat
			String
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR (car Dir_PY) LengthVarNameDir)
			(RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR (cadr Dir_PY) LengthVarNamePoint)
			SeedVar
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_NAMEVAR_NAMEBLOCK ( String NameBlock / )
	(read
		(strcat
			String
			(vla-get-Handle (vla-item VlaBlocksGroup NameBlock))
			SeedVarMain
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CONVERT_NUMBER_TO_STRING_FOR_NAMEVAR ( RealNum LengthVarName / Num Sign String1 String2)
	(if (>= RealNum 0.0)
		(setq Sign "")
		(setq Sign "-")
	)
	(setq Num (fix RealNum))
	(setq String1 (itoa (abs Num)))
	(setq String2 (rtos (abs (- RealNum Num)) 2 LengthVarName))
	(if (= (substr String2 1 1) "0")
		(setq String2 (substr String2 3))
		(progn
			(setq String2 (substr String2 3))
			(setq String1 (itoa (+ (abs Num) 1)))
		)
	)
	(setq String2 (strcat "D" String2))
	(strcat Sign String1 String2)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIR1NEW_AND_DIR2NEW_IN_LISTDIRNEW ( ListDir Dir1 Dir2 / DirTemp)
	(if (not Dir1)
		(progn
			(setq Dir1 (car ListDir))
			(setq ListDir (cdr ListDir))
		)
	)

	(if (not Dir2)
		(while (and (not Dir2) ListDir)
			(setq DirTemp (car ListDir))
			(if (not (RND_CHECK_PI (- Dir1 DirTemp)))
				(setq Dir2 DirTemp)
			)
			(setq ListDir (cdr ListDir))
		)
	)
	(list Dir1 Dir2)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LIST_FORM_FIRST_ELEMENT ( Element List1 / Temp List2 )
	(while (setq Temp (assoc Element List1))
		(setq List2 (cons Temp List2))
		(setq List1 (vl-remove Temp List1))
	)
	List2
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LIST_DIR_COUNT_FROM_DIR_COUNT_TOTAL ( ListDir / Dir NameVar ListResult)
	(foreach Dir ListDir
		(setq NameVar (RND_CREATE_NAMEVAR_DIR "Count" Dir))
		(setq ListResult (cons (cons Dir (eval NameVar)) ListResult))
	)
	ListResult
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT ( NameBlock / NameBlockBase VlaObject)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectArc))
		(RND_CHANGE_VLAOBJECT_ARC VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectPolyline))
		(RND_CHANGE_VLAOBJECT_POLYLINE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectEllipseOpen))
		(RND_CHANGE_VLAOBJECT_ELLIPSEOPEN VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectInsert))
		(setq NameBlockBase (RND_GET_NAME_BLOCK VlaObject))
		(if
			(eval (RND_CREATE_NAMEVAR_NAMEBLOCK "CheckPointOriginal" NameBlockBase))
			(progn
				(RND_ADD_LIST_NAMEBLOCKGRAND_MOVEX1_MOVEY1_DIR1_SCALEX1_SCALEY1_NAMEVAR_NAMEBLOCKBASE NameBlockBase NameBlock VlaObject)
				(RND_CHANGE_VLAOBJECT_INSERT VlaObject)
				(RND_ADD_LIST_NAMEBLOCKGRAND_MOVEX2_MOVEY2_DIR2_SCALEX2_SCALEY2_NAMEVAR_NAMEBLOCKBASE NameBlockBase NameBlock VlaObject)
			)
			(RND_CHANGE_VLAOBJECT_INSERT VlaObject)
		)
		(setq ListVlaObjectUpdate (cons VlaObject ListVlaObjectUpdate))
		
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectLine))
		(RND_CHANGE_VLAOBJECT_LINE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectWipeout))
		(RND_CHANGE_VLAOBJECT_WIPEOUT VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectXref))
		(RND_CHANGE_VLAOBJECT_XREF VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectViewport))
		(RND_CHANGE_VLAOBJECT_VIEWPORT VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDgnReference))
		(RND_CHANGE_VLAOBJECT_DGN_DWF_PDF_REFERENCE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDwfReference))
		(RND_CHANGE_VLAOBJECT_DGN_DWF_PDF_REFERENCE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectHatch))
		(RND_CHANGE_VLAOBJECT_HATCH VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectOle2Frame))
		(RND_CHANGE_VLAOBJECT_OLE2FRAME VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectPdfReference))
		(RND_CHANGE_VLAOBJECT_DGN_DWF_PDF_REFERENCE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectRasterImage))
		(RND_CHANGE_VLAOBJECT_RASTERIMAGE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectSolid))
		(RND_CHANGE_VLAOBJECT_SOLID VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectCircle))
		(RND_CHANGE_VLAOBJECT_CIRCLE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectPoint))
		(RND_CHANGE_VLAOBJECT_POINT VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectSpline))
		(RND_CHANGE_VLAOBJECT_SPLINE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectAttDef))
		(RND_CHANGE_VLAOBJECT_ATTDEF VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectAttribute))
		(RND_CHANGE_VLAOBJECT_ATTRIBUTE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectEllipseClose))
		(RND_CHANGE_VLAOBJECT_ELLIPSECLOSE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectLeader))
		(RND_CHANGE_VLAOBJECT_LEADER VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectMLeader))
		(RND_CHANGE_VLAOBJECT_MLEADER VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectMline))
		(RND_CHANGE_VLAOBJECT_MLINE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectMtext))
		(RND_CHANGE_VLAOBJECT_MTEXT VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectRay))
		(RND_CHANGE_VLAOBJECT_RAY VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectShape))
		(RND_CHANGE_VLAOBJECT_SHAPE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectTable))
		(RND_CHANGE_VLAOBJECT_TABLE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectText))
		(RND_CHANGE_VLAOBJECT_TEXT VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectXline))
		(RND_CHANGE_VLAOBJECT_XLINE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimension2LineAngular))
		(RND_CHANGE_VLAOBJECT_DIMENSION2LINEANGULAR VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimension3PointAngular))
		(RND_CHANGE_VLAOBJECT_DIMENSION3POINTANGULAR VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionAligned))
		(RND_CHANGE_VLAOBJECT_DIMENSIONALIGNED VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionArc))
		(RND_CHANGE_VLAOBJECT_DIMENSIONARC VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionDiametric))
		(RND_CHANGE_VLAOBJECT_DIMENSIONDIAMETRIC VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionFcf))
		(RND_CHANGE_VLAOBJECT_DIMENSIONFCF VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionOrdinate))
		(RND_CHANGE_VLAOBJECT_DIMENSIONORDINATE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRadial))
		(RND_CHANGE_VLAOBJECT_DIMENSIONRADIAL VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRadialLarge))
		(RND_CHANGE_VLAOBJECT_DIMENSIONRADIALLARGE VlaObject)
	)

	(foreach VlaObject (cdr (assoc NameBlock ListNameBlockGrand_ListVlaObjectDimensionRotated))
		(RND_CHANGE_VLAOBJECT_DIMENSIONROTATED VlaObject)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_ARC ( VlaObject /
	ListTemp
	P1
	P1New
	P2
	P2New
	PC
	PCNew
	Rad
	RadNew)

	(setq P1 (RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject)))
	(setq P2 (RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject)))
	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Rad (vla-get-radius VlaObject))

	(setq ListTemp (RND_FIND_P1NEW_P2NEW_PCNEW_RADNEW P1 P2 PC Rad "1"))
	(setq P1New (nth 0 ListTemp))
	(setq P2New (nth 1 ListTemp))
	(setq PCNew (nth 2 ListTemp))
	(setq RadNew (nth 3 ListTemp))
	(if (= RadNew 0.0)
		(setq RadNew NumZero)
	)

	(vla-put-center VlaObject (vlax-3d-point PCNew))
	(vla-put-radius VlaObject RadNew)
	(vla-put-StartAngle VlaObject (angle PCNew P1New))
	(vla-put-EndAngle VlaObject (angle PCNew P2New))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_CIRCLE ( VlaObject /
	Dir
	Node1
	Node2
	P1
	P1New
	P2
	P2New
	PC
	PCNew
	Rad
	RadNew)

	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Rad (vla-get-Radius VlaObject))
	(setq Dir 0.0)
	(setq P1 (polar PC Dir Rad))
	(setq P2 (polar PC Dir (- Rad)))

	(setq Node1 (RND_FIND_NODE_FROM_P P1 "1"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "1"))
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))
	(setq PCNew (RND_FIND_MIDPOINT P1New P2New))
	(setq RadNew (distance PCNew P1New))
	(if (= RadNew 0.0)
		(setq RadNew NumZero)
	)
	(RND_ADD_LIST_PCNEW_NAMEVAR_PC PC PCNew)
	(RND_ADD_LIST_PCNEW_RADNEW_NAMEVAR_PC_RAD (list PC Rad) (list PCNew RadNew))

	(vla-put-Center VlaObject (vlax-3d-point PCNew))
	(vla-put-Radius VlaObject RadNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_ELLIPSEOPEN ( VlaObject /
	Ang1New
	Ang2New
	DataEnameObject
	Dir
	DirNew
	ListPCNew
	ListPCVNew
	Node1
	Node2
	Num
	NumRoundOffLocal
	P1
	P1New
	P1VNew
	P2
	P2New
	P2VNew
	PC
	PCNew
	PCVNew
	PM
	PMNew
	Rad1
	Rad1New
	Rad2
	Rad2New
	Temp
	VarA
	VarB
	VarT)

	(setq P1 (RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject)))
	(setq P2 (RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject)))
	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Rad1 (vla-get-MajorRadius VlaObject))
	(setq Rad2 (vla-get-MinorRadius VlaObject))
	(setq PM (RND_VARIANT_TO_LIST (vla-get-MajorAxis VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) PM))

	(setq Node1 (RND_FIND_NODE_FROM_P P1 "1"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "1"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node1 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL (angle P1 P2))) "1")))
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq Rad1New (RND_FIND_RADNEW Rad1 NumRoundOffLocal))
	(if (= Rad1New 0.0)
		(setq Rad1New NumZero)
	)
	(setq Rad2New (RND_FIND_RADNEW Rad2 NumRoundOffLocal))
	(if (= Rad2New 0.0)
		(setq Rad2New NumZero)
	)
	(if (RND_CHECK_EQUAL_TWO_POINT P1New P2New)
		(progn
			(setq PCNew (RND_FIND_POINTNEW_FOR_OBJECT_DIRECTION PC Dir NumRoundOffLocal))
			(setq Ang1New 0.0)
			(setq Ang2New PiDoub)
		)
		(progn
			(setq P1VNew (RND_TRANSFORMATION_ROTATE P1New (- DirNew)))
			(setq P2VNew (RND_TRANSFORMATION_ROTATE P2New (- DirNew)))
			(setq VarA (* (- (nth 0 P1VNew) (nth 0 P2VNew)) 0.5))
			(setq VarB (* (- (nth 1 P1VNew) (nth 1 P2VNew)) 0.5))

			(while
				(vl-catch-all-error-p (vl-catch-all-apply '(lambda ( / )
					(if (= (RND_ROUNDOFF_NUMBER VarB NumZero) 0.0)
						(progn
							(setq VarT (/
									(* -1.0 VarB (expt Rad1New 2.0)) 
									(* VarA (expt Rad2New 2.0))
								)
							)
							(setq
								Temp
								(expt
									(/
										(+
											(*
												(expt Rad1New 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarA 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarB 2.0)
												(expt Rad1New 2.0)
											)
										)
										(+
											(expt Rad1New 2.0)
											(*
												(expt VarT 2.0)
												(expt Rad2New 2.0)
											)
										)
									)
									0.5
								)
							)
							(setq ListPCVNew
								(mapcar
									'(lambda (Sign)
										(list
											(+ (* VarT (* Sign Temp)) (* (+ (nth 0 P1VNew) (nth 0 P2VNew)) 0.5))
											(+ (* Sign Temp) (* (+ (nth 1 P1VNew) (nth 1 P2VNew)) 0.5))
											0.0
										)
									)
									(list 1.0 -1.0)
								)
							)
						)
						(progn
							(setq VarT (/
									(* -1.0 VarA (expt Rad2New 2.0)) 
									(* VarB (expt Rad1New 2.0))
								)
							)
							(setq
								Temp
								(expt
									(/
										(+
											(*
												(expt Rad1New 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarA 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarB 2.0)
												(expt Rad1New 2.0)
											)
										)
										(+
											(expt Rad2New 2.0)
											(*
												(expt VarT 2.0)
												(expt Rad1New 2.0)
											)
										)
									)
									0.5
								)
							)
							(setq ListPCVNew
								(mapcar
									'(lambda (Sign)
										(list
											(+ (* Sign Temp) (* (+ (nth 0 P1VNew) (nth 0 P2VNew)) 0.5))
											(+ (* VarT (* Sign Temp)) (* (+ (nth 1 P1VNew) (nth 1 P2VNew)) 0.5))
											0.0
										)
									)
									(list 1.0 -1.0)
								)
							)
						)
					)
				)))
				(progn
					(setq Rad1New (+ Rad1New NumRoundOffLocal))
					(setq Rad2New (+ Rad2New NumRoundOffLocal))
				)
			)

			(setq ListPCNew (mapcar '(lambda (x) (RND_TRANSFORMATION_ROTATE x DirNew)) ListPCVNew))
			(setq Num (car (vl-sort-i (mapcar '(lambda (x) (distance x PC)) ListPCNew) '<)))
			(setq PCNew (nth Num ListPCNew))
			(setq PCVNew (nth Num ListPCVNew))
			(setq Ang1New (angle PCVNew P1VNew))
			(setq Ang2New (angle PCVNew P2VNew))
			(if (RND_CHECK_EQUAL_TWO_POINT (RND_VARIANT_TO_LIST (vla-get-Normal VlaObject)) (list 0.0 0.0 -1.0))
				(progn
					(setq Ang1New (angle PCVNew P2VNew))
					(setq Ang2New (angle PCVNew P1VNew))
				)
				(progn
					(setq Ang1New (angle PCVNew P1VNew))
					(setq Ang2New (angle PCVNew P2VNew))
				)
			)
		)
	)
	(setq PMNew (polar (list 0.0 0.0 0.0) DirNew Rad1New))

	(vla-put-Normal VlaObject (vlax-3d-point (list 0.0 0.0 1.0)))
	(vla-put-Center VlaObject (vlax-3d-point PCNew))
	(vla-put-MajorAxis VlaObject (vlax-3d-point PMNew))
	(vla-put-MinorRadius VlaObject Rad2New)
	(if
		(vl-catch-all-error-p (vl-catch-all-apply '(lambda ( / )
			(vla-put-StartAngle VlaObject Ang1New)
			(vla-put-EndAngle VlaObject Ang2New)
		)))
		(progn
			(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
			(setq DataEnameObject (subst (cons 41 0.0) (assoc 41 DataEnameObject) DataEnameObject))
			(setq DataEnameObject (subst (cons 42 PiDoub) (assoc 42 DataEnameObject) DataEnameObject))
			(entmod DataEnameObject)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_LINE ( VlaObject /
	Node1
	Node2
	P1
	P1New
	P2
	P2New)

	(setq P1 (RND_VARIANT_TO_LIST (vla-get-StartPoint VlaObject)))
	(setq P2 (RND_VARIANT_TO_LIST (vla-get-EndPoint VlaObject)))
	(setq Node1 (RND_FIND_NODE_FROM_P P1 "1"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "1"))
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))
	(vla-put-StartPoint VlaObject (vlax-3d-point P1New))
	(vla-put-EndPoint VlaObject (vlax-3d-point P2New))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_MLINE ( VlaObject / 
	ListCoordinates
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew
	Num)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq Num 0)
	(repeat (/ (length ListCoordinates) 3)
		(setq ListPoint
			(cons
				(list
					(nth Num ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
				)
				ListPoint
			)
		)
		(setq Num (+ Num 1))
	)
	(setq ListPoint (reverse ListPoint))

	(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "1")) ListPoint))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
	(setq ListCoordinatesNew (apply 'append ListPointNew))

	(vla-put-Coordinates
		VlaObject
		(vlax-safearray-fill
			(vlax-make-safearray
				vlax-vbDouble
				(cons 0 (- (length ListCoordinatesNew) 1))
			)
			ListCoordinatesNew
		)
	)
	(vla-update VlaObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_POLYLINE ( VlaObject / 
	Bulge
	BulgeNew
	ListBulge
	ListBulgeNew
	ListCoordinates
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew
	ListTemp
	Num
	NumPoint
	P1
	P1New
	P2
	P2New
	PC
	PCNew
	Rad
	RadNew)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq Num 0)
	(repeat (/ (length ListCoordinates) 2)
		(setq ListPoint (cons (list (nth Num ListCoordinates) (nth (+ Num 1) ListCoordinates) 0.0) ListPoint))
		(setq Num (+ Num 2))
	)
	(setq ListPoint (reverse ListPoint))
	(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "1")) ListPoint))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))

	(setq NumPoint (length ListPoint))
	(setq Num 0)
	(repeat NumPoint
		(setq ListBulge (cons (vla-GetBulge VlaObject Num) ListBulge))
		(setq Num (+ Num 1))
	)
	(setq ListBulge (reverse ListBulge))

	(setq Num 0)
	(repeat NumPoint
		(setq Bulge (nth Num ListBulge))
		(if (= Bulge 0.0)
			(setq BulgeNew 0.0)
			(progn
				(setq P1New (nth Num ListPointNew))
				(if (= Num (- NumPoint 1))
					(setq P2New (nth 0 ListPointNew))
					(setq P2New (nth (+ Num 1) ListPointNew))
				)
				(if (<= (distance P1New P2New) NumZero)
					(setq BulgeNew 0.0)
					(progn
						(setq P1 (nth Num ListPoint))
						(if (= Num (- NumPoint 1))
							(setq P2 (nth 0 ListPoint))
							(setq P2 (nth (+ Num 1) ListPoint))
						)
						(setq ListTemp (RND_BULGE_TO_ARC P1 P2 Bulge))
						(setq PC (car ListTemp))
						(setq Rad (cadr ListTemp))
						(setq ListTemp (RND_FIND_P1NEW_P2NEW_PCNEW_RADNEW P1 P2 PC Rad "1"))
						(setq P1New (nth 0 ListTemp))
						(setq P2New (nth 1 ListTemp))
						(setq PCNew (nth 2 ListTemp))
						(setq RadNew (nth 3 ListTemp))
						(setq BulgeNew (RND_ARC_TO_BULGE P1New P2New PCNew Bulge))
					)
				)
			)
		)
		(setq ListBulgeNew (cons BulgeNew ListBulgeNew))
		(setq Num (+ Num 1))
	)
	(setq ListBulgeNew (reverse ListBulgeNew))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
	(setq ListCoordinatesNew (apply 'append (mapcar '(lambda (x) (list (nth 0 x) (nth 1 x))) ListPointNew)))

	(vla-put-Coordinates
		VlaObject
		(vlax-safearray-fill
			(vlax-make-safearray
				vlax-vbDouble
				(cons 0 (- (length ListCoordinatesNew) 1))
			)
			ListCoordinatesNew
		)
	)
	(setq Num 0)
	(repeat NumPoint
		(vla-SetBulge VlaObject Num (nth Num ListBulgeNew))
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_INSERT ( VlaObject /
	CheckBlockScaling
	DataBoundaryXclip
	Dir
	DirNew
	FlagDisplayBoundary
	FlagInvertBoundary
	ListNode
	ListPoint
	ListPointNew
	ListVlaObjectAttribute_PNew_DirNew
	NameBlock
	Node
	P
	PNew
	ScalefactorBlockRoundOff
	ScaleFactorX
	ScaleFactorXNew
	ScaleFactorY
	ScaleFactorYNew
	ScaleFactorZ
	ScaleFactorZNew
	VlaBlock)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq NameBlock (RND_GET_EFFECTIVENAME_BLOCK VlaObject))
	(setq ScaleFactorX (vla-get-XEffectiveScaleFactor VlaObject))
	(setq ScaleFactorY (vla-get-YEffectiveScaleFactor VlaObject))
	(setq ScaleFactorZ (vla-get-ZEffectiveScaleFactor VlaObject))
	(setq Dir (vla-get-Rotation VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "1"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq VlaBlock (vla-item VlaBlocksGroup NameBlock))
	(setq CheckBlockScaling (vla-get-BlockScaling VlaBlock))
	(if (= CheckBlockScaling 1) (vla-put-BlockScaling VlaBlock 0))
	(setq ScalefactorBlockRoundOff
		(/
			(cdr (assoc NameBlock ListNameBlock_ScalefactorBlockRoundOff))
			ScalefactorBlockPop
			(RND_GET_SCALEFACTORBLOCK VlaBlock)
		)
	)
	(setq ScaleFactorXNew (RND_ROUNDOFF_NUMBER ScaleFactorX ScalefactorBlockRoundOff))
	(setq ScaleFactorYNew (/ (* ScaleFactorY ScaleFactorXNew) ScaleFactorX))
	(setq ScaleFactorZNew (/ (* ScaleFactorZ ScaleFactorXNew) ScaleFactorX))
	(if (= ScaleFactorXNew 0.0)
		(setq ScaleFactorXNew NumZero)
	)
	(if (= ScaleFactorYNew 0.0)
		(setq ScaleFactorYNew NumZero)
	)
	(if (= ScaleFactorZNew 0.0)
		(setq ScaleFactorZNew NumZero)
	)

	(RND_CREATE_LISTVLAOBJECTATTRIBUTE_PNEW_DIRNEW VlaObject)

	(setq DataBoundaryXclip (RND_FIND_DATAXCLIPBOUNDARY VlaObject))
	(if DataBoundaryXclip
		(progn
			(setq ListPoint (nth 1 DataBoundaryXclip))
			(setq FlagDisplayBoundary (nth 2 DataBoundaryXclip))
			(setq FlagInvertBoundary (nth 3 DataBoundaryXclip))
			(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "1")) ListPoint))
			(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
		)
	)

	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
	(vla-put-XEffectiveScaleFactor VlaObject ScaleFactorXNew)
	(vla-put-YEffectiveScaleFactor VlaObject ScaleFactorYNew)
	(vla-put-ZEffectiveScaleFactor VlaObject ScaleFactorZNew)
	(if (= CheckBlockScaling 1) (vla-put-BlockScaling VlaBlock 1))

	(RND_CHANGE_VLAOBJECT_ATTRIBUTE)

	(if DataBoundaryXclip
		(CREATE_NEW_XCLIP (vlax-vla-object->ename VlaObject) ListPointNew FlagDisplayBoundary FlagInvertBoundary)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTVLAOBJECTATTRIBUTE_PNEW_DIRNEW ( VlaObjectInsert /
	Dir
	DirNew
	Node
	P
	PNew
	VlaObject)

	(if (= (vla-get-HasAttributes VlaObjectInsert) :vlax-true)
		(foreach VlaObject (RND_VARIANT_TO_LIST (vla-GetAttributes VlaObjectInsert))
			(setq P (RND_VARIANT_TO_LIST (vla-get-TextAlignmentPoint VlaObject)))
			(setq Dir (vla-get-Rotation VlaObject))

			(setq Node (RND_FIND_NODE_FROM_P P "1"))
			(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
			(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))

			(setq ListVlaObjectAttribute_PNew_DirNew (cons (list VlaObject PNew DirNew) ListVlaObjectAttribute_PNew_DirNew))
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_ATTRIBUTE ( / DirNew PNew VlaObject )
	(foreach Temp ListVlaObjectAttribute_PNew_DirNew
		(setq VlaObject (nth 0 Temp))
		(setq PNew (nth 1 Temp))
		(setq DirNew (nth 2 Temp))
		(vl-catch-all-apply '(lambda ( / )
			(vla-put-TextAlignmentPoint VlaObject (vlax-3d-point PNew))
			(vla-put-Rotation VlaObject DirNew)
		))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_WIPEOUT ( VlaObject /
	Code
	DataEnameObject
	DataEnameObjectTemp
	ListNode
	ListPoint
	ListPointNew
	ListTemp
	C
	M
	P
	Temp)

	(setq ListPoint (RND_FIND_LISTPOINT_WIPEOUT VlaObject))
	(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "1")) ListPoint))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))

	(setq P (apply 'mapcar (cons 'min ListPointNew)))
	(setq M (apply 'max (mapcar '- (apply 'mapcar (cons 'max ListPointNew)) P)))
	(setq C (mapcar '+ P (list (/ M 2.0) (/ M 2.0))))
	(setq ListTemp
		(mapcar
			'(lambda
				( x )
				(cons 14
					(mapcar
						'(lambda
							( a b c )
							(/ (- a b) c)
						)
						x
						C
						(list M (- M))
					)
				)
			)
			ListPointNew
		)
	)
	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(foreach Temp DataEnameObject
		(setq Code (car Temp))
		(if (or (= code 10) (= code 11) (= code 12) (= code 14))
			(progn
				(if (= code 10)
					(setq Temp (cons 10 P))
				)
				(if (= code 11)
					(setq Temp (list 11 M 0.0 0.0))
				)
				(if (= code 12)
					(setq Temp (list 12 0.0 M 0.0))
				)
				(if (= code 14)
					(setq Temp Nil)
				)
			)
		)
		(if Temp (setq DataEnameObjectTemp (cons Temp DataEnameObjectTemp)))
	)
	(entmod (append (reverse DataEnameObjectTemp) ListTemp))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_XREF ( VlaObject /
	Dir
	DirNew
	DataBoundaryXclip
	FlagDisplayBoundary
	FlagInvertBoundary
	ListNode
	ListPoint
	ListPointNew
	Node
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(setq Node (RND_FIND_NODE_FROM_P P "1"))

	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))

	(setq DataBoundaryXclip (RND_FIND_DATAXCLIPBOUNDARY VlaObject))
	(if DataBoundaryXclip
		(progn
			(setq ListPoint (nth 1 DataBoundaryXclip))
			(setq FlagDisplayBoundary (nth 2 DataBoundaryXclip))
			(setq FlagInvertBoundary (nth 3 DataBoundaryXclip))
			(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "1")) ListPoint))
			(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
		)
	)

	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
	(if DataBoundaryXclip
		(CREATE_NEW_XCLIP (vlax-vla-object->ename VlaObject) ListPointNew FlagDisplayBoundary FlagInvertBoundary)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_VIEWPORT ( VlaObject /
	DataEnameObjectVertex
	EnameObjectVertex
	P
	PNew
	Node
	VlaObject)

	(setq P (RND_VARIANT_TO_LIST (vla-get-center VlaObject)))
	(setq Node (RND_FIND_NODE_FROM_P P "1"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(vla-put-center VlaObject (vlax-3d-point PNew))
	(vla-put-width VlaObject (RND_ROUNDOFF_NUMBER (vla-get-width VlaObject) NumRoundOffMax))
	(vla-put-height VlaObject (RND_ROUNDOFF_NUMBER (vla-get-height VlaObject) NumRoundOffMax))

	(foreach EnameObjectVertex (RND_FIND_LISTENAMEOBJECTVERTEX_FROM_VIEWPORT VlaObject)
		(setq DataEnameObjectVertex (entget EnameObjectVertex))
		(setq P (cdr (assoc 10 DataEnameObjectVertex)))
		(setq Node (RND_FIND_NODE_FROM_P P "1"))
		(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
		(setq DataEnameObjectVertex (subst (cons 10 PNew) (assoc 10 DataEnameObjectVertex) DataEnameObjectVertex))
		(entmod DataEnameObjectVertex)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DGN_DWF_PDF_REFERENCE ( VlaObject /
	Dir
	DirNew
	DirNewInv
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew
	MoveXNewInv
	MoveYNewInv
	Node
	NumRoundOffLocal
	P
	PNew
	ScaleNewInv
	ScaleXNewInv
	ScaleYNewInv
	Width
	WidthNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-Position VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(setq Width (vla-get-Width VlaObject))
	(setq ListPoint (RND_FIND_LISTPOINT_CLIPBOUNDARY_DGN_DWF_PDF_REFERENCE VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "2"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "2")))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq WidthNew (RND_ROUNDOFF_NUMBER Width NumRoundOffLocal))

	(vla-put-Position VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
	(if ListPoint
		(progn
			(setq PNew (RND_VARIANT_TO_LIST (vla-get-Position VlaObject)))
			(setq MoveXNewInv (- (nth 0 PNew)))
			(setq MoveYNewInv (- (nth 1 PNew)))
			(setq DirNewInv (- (vla-get-Rotation VlaObject)))
			(setq ScaleNewInv (/ 1.0 (vla-get-ScaleFactor VlaObject)))
			(setq ScaleXNewInv ScaleNewInv)
			(setq ScaleYNewInv ScaleNewInv)
			(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "2")) ListPoint))
			(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
			(setq ListPointNew (mapcar '(lambda (PointNew) (RND_TRANSFORMATION_MOVE PointNew MoveXNewInv MoveYNewInv)) ListPointNew))
			(setq ListPointNew (mapcar '(lambda (PointNew) (RND_TRANSFORMATION_ROTATE PointNew DirNewInv)) ListPointNew))
			(setq ListPointNew (mapcar '(lambda (PointNew) (RND_TRANSFORMATION_SCALE PointNew ScaleXNewInv ScaleYNewInv)) ListPointNew))
			(setq ListCoordinatesNew (apply 'append (mapcar '(lambda (x) (list (car x) (cadr x))) ListPointNew)))
			(vla-ClipBoundary
				VlaObject
				(vlax-safearray-fill
					(vlax-make-safearray
						vlax-vbDouble
						(cons 0 (- (length ListCoordinatesNew) 1))
					)
					ListCoordinatesNew
				)
			)
		)
		(vla-put-Width VlaObject WidthNew)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_HATCH ( VlaObject / 
	CheckPathTypePolyline
	DataEnameEdge
	DataEnameEdgeSub
	EdgeType
	ListDataEnameEdge
	ListDataEnameEdgeSub
	List_DataEnameEdge_NameVar_EdgeType
	NameVar
	NumEdge
	NumEdgeSub
	NumLast
	Temp)

	(setq ListDataEnameEdge (RND_CREATE_LISTDATAENAMEEDGE_HATCH VlaObject))
	(setq NumEdge 0)
	(setq NumLast (- (length ListDataEnameEdge) 1))
	(foreach DataEnameEdge ListDataEnameEdge
		(setq NumEdgeSub 0)
		(if (or (= NumEdge 0) (= NumEdge NumLast))
			(progn
				(setq EdgeType "Start_Last")
				(setq NameVar (RND_CREATE_NAMEVAR_LISTNUM "DataEnameEdgeHatch" (list NumEdge NumEdgeSub)))
				(set NameVar DataEnameEdge)
				(setq List_DataEnameEdge_NameVar_EdgeType (cons (list NameVar EdgeType) List_DataEnameEdge_NameVar_EdgeType))
			)
			(progn
				(setq CheckPathTypePolyline (RND_CHECK_PATH_TYPE_POLYLINE_OF_HATCH DataEnameEdge))
				(if CheckPathTypePolyline
					(progn
						(setq EdgeType 0)
						(setq NameVar (RND_CREATE_NAMEVAR_LISTNUM "DataEnameEdgeHatch" (list NumEdge NumEdgeSub)))
						(set NameVar DataEnameEdge)
						(setq List_DataEnameEdge_NameVar_EdgeType (cons (list NameVar EdgeType) List_DataEnameEdge_NameVar_EdgeType))
					)
					(progn
						(setq ListDataEnameEdgeSub (RND_CREATE_LISTDATAENAMEEDGESUB_HATCH DataEnameEdge))
						(foreach DataEnameEdgeSub ListDataEnameEdgeSub
							(setq EdgeType (cdr (assoc 72 DataEnameEdgeSub)))
							(setq NameVar (RND_CREATE_NAMEVAR_LISTNUM "DataEnameEdgeHatch" (list NumEdge NumEdgeSub)))
							(set NameVar DataEnameEdgeSub)
							(setq List_DataEnameEdge_NameVar_EdgeType (cons (list NameVar EdgeType) List_DataEnameEdge_NameVar_EdgeType))
							(setq NumEdgeSub (+ NumEdgeSub 1))
						)	
					)
				)
			)
			
		)
		(setq NumEdge (+ NumEdge 1))
	)
	(setq List_DataEnameEdge_NameVar_EdgeType (reverse List_DataEnameEdge_NameVar_EdgeType))

	(foreach Temp List_DataEnameEdge_NameVar_EdgeType
		(setq EdgeType (cadr Temp))
		(setq NameVar (car Temp))
		(setq DataEnameEdge (eval NameVar))
		(if (= EdgeType 2)
			(set NameVar (RND_CHANGE_VLAOBJECT_HATCH_ARC DataEnameEdge))
		)
	)

	(foreach Temp List_DataEnameEdge_NameVar_EdgeType
		(setq EdgeType (cadr Temp))
		(setq NameVar (car Temp))
		(setq DataEnameEdge (eval NameVar))
		(if (= EdgeType 0)
			(set NameVar (RND_CHANGE_VLAOBJECT_HATCH_POLYLINE DataEnameEdge))
		)
	)

	(foreach Temp List_DataEnameEdge_NameVar_EdgeType
		(setq EdgeType (cadr Temp))
		(setq NameVar (car Temp))
		(setq DataEnameEdge (eval NameVar))
		(if (= EdgeType 1)
			(set NameVar (RND_CHANGE_VLAOBJECT_HATCH_LINE DataEnameEdge))
		)
		(if (= EdgeType 3)
			(set NameVar (RND_CHANGE_VLAOBJECT_HATCH_ELLIPSE DataEnameEdge))
		)
		(if (= EdgeType 4)
			(set NameVar (RND_CHANGE_VLAOBJECT_HATCH_SPLINE DataEnameEdge))
		)
	)
	(entmod (apply 'append (mapcar 'eval (mapcar 'car List_DataEnameEdge_NameVar_EdgeType))))
	(RND_RESET_LISTNAMEVAR List_DataEnameEdge_NameVar_EdgeType)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_HATCH_LINE ( DataEnameEdge /
	P1
	P2
	Node1
	Node2
	P1New
	P2New)

	(setq P1 (cdr (assoc 10 DataEnameEdge)))
	(setq P2 (cdr (assoc 11 DataEnameEdge)))

	(setq Node1 (RND_FIND_NODE_FROM_P P1 "2"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "2"))
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))

	(setq DataEnameEdge (subst (cons 10 P1New) (cons 10 P1) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 11 P2New) (cons 11 P2) DataEnameEdge))
	DataEnameEdge
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_HATCH_ARC ( DataEnameEdge /
	Ang1
	Ang1New
	Ang2
	Ang2New
	CheckClockwise
	P1
	P1New
	P2
	P2New
	PC
	PCNew
	Rad
	RadNew
	ListTemp)

	(setq PC (cdr (assoc 10 DataEnameEdge)))
	(setq Rad (cdr (assoc 40 DataEnameEdge)))
	(setq Ang1 (cdr (assoc 50 DataEnameEdge)))
	(setq Ang2 (cdr (assoc 51 DataEnameEdge)))
	(setq CheckClockwise (= (cdr (assoc 73 DataEnameEdge)) 0))
	(if CheckClockwise
		(progn
			(setq Ang1 (- Ang1))
			(setq Ang2 (- Ang2))
		)
	)
	(setq P1 (polar PC Ang1 Rad))
	(setq P2 (polar PC Ang2 Rad))

	(setq ListTemp (RND_FIND_P1NEW_P2NEW_PCNEW_RADNEW P1 P2 PC Rad "2"))
	(setq P1New (nth 0 ListTemp))
	(setq P2New (nth 1 ListTemp))
	(setq PCNew (nth 2 ListTemp))
	(setq RadNew (nth 3 ListTemp))
	(if (= RadNew 0.0)
		(setq RadNew NumZero)
	)
	(setq Ang1New (angle PCNew P1New))
	(setq Ang2New (angle PCNew P2New))
	(if CheckClockwise
		(progn
			(setq Ang1New (- Ang1New))
			(setq Ang2New (- Ang2New))
		)
	)

	(setq DataEnameEdge (subst (cons 10 PCNew)	(assoc 10 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 40 RadNew)	(assoc 40 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 50 Ang1New)	(assoc 50 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 51 Ang2New)	(assoc 51 DataEnameEdge) DataEnameEdge))
	DataEnameEdge
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_HATCH_ELLIPSE ( DataEnameEdge /
	Ang1
	Ang1New
	Ang2
	Ang2New
	CheckClockwise
	Dir
	DirNew
	ListPCNew
	ListPCVNew
	Node1
	Node2
	Num
	NumRoundOffLocal
	P1
	P1New
	P1VNew
	P2
	P2New
	P2VNew
	PC
	PCNew
	PCVNew
	PM
	PMNew
	Rad1
	Rad1New
	Rad2
	Rad2New
	Ratio
	RatioNew
	Temp
	VarA
	VarB
	VarT)

	(setq PC (cdr (assoc 10 DataEnameEdge)))
	(setq PM (cdr (assoc 11 DataEnameEdge)))
	(setq Ratio (cdr (assoc 40 DataEnameEdge)))
	(setq Dir (angle (list 0.0 0.0 0.0) PM))
	(setq Rad1 (distance (list 0.0 0.0 0.0) PM))
	(setq Rad2 (* Rad1 Ratio))
	(setq Ang1 (cdr (assoc 50 DataEnameEdge)))
	(setq Ang2 (cdr (assoc 51 DataEnameEdge)))
	(setq CheckClockwise (= (cdr (assoc 73 DataEnameEdge)) 0))
	(if CheckClockwise
		(progn
			(setq Ang1 (- Ang1))
			(setq Ang2 (- Ang2))
		)
	)
	(setq P1 (RND_FIND_POINT_OF_ELLIPSE PC Ratio Dir Rad1 Rad2 Ang1))
	(setq P2 (RND_FIND_POINT_OF_ELLIPSE PC Ratio Dir Rad1 Rad2 Ang2))

	(setq Node1 (RND_FIND_NODE_FROM_P P1 "2"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "2"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node1 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL (angle P1 P2))) "2")))
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq Rad1New (RND_FIND_RADNEW Rad1 NumRoundOffLocal))
	(if (= Rad1New 0.0)
		(setq Rad1New NumZero)
	)
	(setq Rad2New (RND_FIND_RADNEW Rad2 NumRoundOffLocal))
	(if (= Rad2New 0.0)
		(setq Rad2New NumZero)
	)
	(if (RND_CHECK_EQUAL_TWO_POINT P1New P2New)
		(progn
			(setq PCNew (RND_FIND_POINTNEW_FOR_OBJECT_DIRECTION PC Dir NumRoundOffLocal))
			(setq Ang1New 0.0)
			(setq Ang2New PiDoub)
		)
		(progn
			(setq P1VNew (RND_TRANSFORMATION_ROTATE P1New (- DirNew)))
			(setq P2VNew (RND_TRANSFORMATION_ROTATE P2New (- DirNew)))
			(setq VarA (* (- (nth 0 P1VNew) (nth 0 P2VNew)) 0.5))
			(setq VarB (* (- (nth 1 P1VNew) (nth 1 P2VNew)) 0.5))

			(while
				(vl-catch-all-error-p (vl-catch-all-apply '(lambda ( / )
					(if (= (RND_ROUNDOFF_NUMBER VarB NumZero) 0.0)
						(progn
							(setq VarT
								(/
									(* -1.0 VarB (expt Rad1New 2.0)) 
									(* VarA (expt Rad2New 2.0))
								)
							)
							(setq
								Temp
								(expt
									(/
										(+
											(*
												(expt Rad1New 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarA 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarB 2.0)
												(expt Rad1New 2.0)
											)
										)
										(+
											(expt Rad1New 2.0)
											(*
												(expt VarT 2.0)
												(expt Rad2New 2.0)
											)
										)
									)
									0.5
								)
							)
							(setq ListPCVNew
								(mapcar
									'(lambda (Sign)
										(list
											(+ (* VarT (* Sign Temp)) (* (+ (nth 0 P1VNew) (nth 0 P2VNew)) 0.5))
											(+ (* Sign Temp) (* (+ (nth 1 P1VNew) (nth 1 P2VNew)) 0.5))
											0.0
										)
									)
									(list 1.0 -1.0)
								)
							)
						)
						(progn
							(setq VarT
								(/
									(* -1.0 VarA (expt Rad2New 2.0)) 
									(* VarB (expt Rad1New 2.0))
								)
							)
							(setq
								Temp
								(expt
									(/
										(+
											(*
												(expt Rad1New 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarA 2.0)
												(expt Rad2New 2.0)
											)
											(*
												-1.0
												(expt VarB 2.0)
												(expt Rad1New 2.0)
											)
										)
										(+
											(expt Rad2New 2.0)
											(*
												(expt VarT 2.0)
												(expt Rad1New 2.0)
											)
										)
									)
									0.5
								)
							)
							(setq ListPCVNew
								(mapcar
									'(lambda (Sign)
										(list
											(+ (* Sign Temp) (* (+ (nth 0 P1VNew) (nth 0 P2VNew)) 0.5))
											(+ (* VarT (* Sign Temp)) (* (+ (nth 1 P1VNew) (nth 1 P2VNew)) 0.5))
											0.0
										)
									)
									(list 1.0 -1.0)
								)
							)
						)
					)
				)))
				(progn
					(setq Rad1New (+ Rad1New NumRoundOffLocal))
					(setq Rad2New (+ Rad2New NumRoundOffLocal))
				)
			)

			(setq ListPCNew (mapcar '(lambda (x) (RND_TRANSFORMATION_ROTATE x DirNew)) ListPCVNew))
			(setq Num (car (vl-sort-i (mapcar '(lambda (x) (distance x PC)) ListPCNew) '<)))
			(setq PCNew (nth Num ListPCNew))
			(setq PCVNew (nth Num ListPCVNew))
			(setq Ang1New (angle PCVNew P1VNew))
			(setq Ang2New (angle PCVNew P2VNew))
			(if CheckClockwise
				(progn
					(setq Ang1New (- Ang1New))
					(setq Ang2New (- Ang2New))
				)
			)
		)
	)
	(setq RatioNew (/ Rad2New Rad1New))
	(setq PMNew (polar (list 0.0 0.0 0.0) DirNew Rad1New))

	(setq DataEnameEdge (subst (cons 10 PCNew)	(assoc 10 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 11 PMNew)	(assoc 11 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 40 RatioNew)	(assoc 40 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 50 Ang1New)	(assoc 50 DataEnameEdge) DataEnameEdge))
	(setq DataEnameEdge (subst (cons 51 Ang2New)	(assoc 51 DataEnameEdge) DataEnameEdge))
	DataEnameEdge
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_HATCH_SPLINE ( DataEnameEdge /
	P1
	P2
	P1New
	P2New)

	(setq P1 (cdr (assoc 10 DataEnameEdge)))
	(setq P2 (cdr (assoc 10 (reverse DataEnameEdge))))
	(if (not (RND_CHECK_EQUAL_TWO_POINT P1 P2))
		(progn
			(setq P1New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P1 NumRoundOffMax))
			(setq P2New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P2 NumRoundOffMax))
			(setq DataEnameEdge (subst (cons 10 P1New) (cons 10 P1) DataEnameEdge))
			(setq DataEnameEdge (subst (cons 10 P2New) (cons 10 P2) DataEnameEdge))
		)
	)
	DataEnameEdge
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_HATCH_POLYLINE ( DataEnameEdge /
	Bulge
	BulgeNew
	CheckHasBulge
	DataEnameEdgeNew
	DataEnameEdgeTemp
	ListBulge
	ListBulgeNew
	ListNode
	ListPoint
	ListPointNew
	ListTemp
	Num
	NumPoint
	P1New
	P1
	P2
	P2New
	PC
	PCNew
	Pos
	PosBulge
	PosPoint
	Rad
	RadNew
	Temp)

	(setq DataEnameEdgeTemp DataEnameEdge)
	(foreach Temp DataEnameEdgeTemp
		(if (= (car Temp) 10)
			(setq ListPoint (cons (cdr Temp) ListPoint))
		)
	)
	(setq ListPoint (reverse ListPoint))
	(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "2")) ListPoint))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))

	(setq CheckHasBulge (= (cdr (assoc 72 DataEnameEdge)) 1))
	(if CheckHasBulge
		(progn
			(setq DataEnameEdgeTemp DataEnameEdge)
			(foreach Temp DataEnameEdgeTemp
				(if (= (car Temp) 42)
					(setq ListBulge (cons (cdr Temp) ListBulge))
				)
			)
			(setq ListBulge (reverse ListBulge))
			(setq NumPoint (length ListPoint))
			(setq Num 0)
			(repeat NumPoint
				(setq Bulge (nth Num ListBulge))
				(if (= Bulge 0.0)
					(setq BulgeNew 0.0)
					(progn
						(setq P1New (nth Num ListPointNew))
						(if (= Num (- NumPoint 1))
							(setq P2New (nth 0 ListPointNew))
							(setq P2New (nth (+ Num 1) ListPointNew))
						)
						(if (<= (distance P1New P2New) NumZero)
							(setq BulgeNew 0.0)
							(progn
								(setq P1 (nth Num ListPoint))
								(if (= Num (- NumPoint 1))
									(setq P2 (nth 0 ListPoint))
									(setq P2 (nth (+ Num 1) ListPoint))
								)
								(setq ListTemp (RND_BULGE_TO_ARC P1 P2 Bulge))
								(setq PC (car ListTemp))
								(setq Rad (cadr ListTemp))
								(setq ListTemp (RND_FIND_P1NEW_P2NEW_PCNEW_RADNEW P1 P2 PC Rad "2"))
								(setq P1New (nth 0 ListTemp))
								(setq P2New (nth 1 ListTemp))
								(setq PCNew (nth 2 ListTemp))
								(setq RadNew (nth 3 ListTemp))
								(setq BulgeNew (RND_ARC_TO_BULGE P1New P2New PCNew Bulge))
							)
						)
					)
				)
				(setq ListBulgeNew (cons BulgeNew ListBulgeNew))
				(setq Num (+ Num 1))
			)
			(setq ListBulgeNew (reverse ListBulgeNew))
		)
	)
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))

	(setq Pos 0)
	(setq PosPoint 0)
	(setq PosBulge 0)
	(repeat (length DataEnameEdge)
		(setq Temp (nth Pos DataEnameEdge))
		(if (= (car Temp) 10)
			(progn
				(setq Temp (cons 10 (nth PosPoint ListPointNew)))
				(setq PosPoint (+ PosPoint 1))
			)
		)
		(if (= (car Temp) 42)
			(progn
				(setq Temp (cons 42 (nth PosBulge ListBulgeNew)))
				(setq PosBulge (+ PosBulge 1))
			)
		)
		(setq DataEnameEdgeNew (cons Temp DataEnameEdgeNew))
		(setq Pos (+ Pos 1))
	)
	(setq DataEnameEdgeNew (reverse DataEnameEdgeNew))
	DataEnameEdgeNew
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_OLE2FRAME ( VlaObject /
	Dir
	Height
	HeightNew
	LockAspectRatio
	Node
	NumRoundOffLocal
	P
	PNew
	Width
	WidthNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir 0.0)
	(setq LockAspectRatio (vla-get-LockAspectRatio VlaObject))
	(setq Width (vla-get-Width VlaObject))
	(setq Height (vla-get-Height VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "2"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "2")))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq WidthNew (RND_ROUNDOFF_NUMBER Width NumRoundOffLocal))
	(setq HeightNew (RND_ROUNDOFF_NUMBER Height NumRoundOffLocal))

	(vla-put-LockAspectRatio VlaObject :vlax-false)
	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Width VlaObject WidthNew)
	(vla-put-Height VlaObject HeightNew)
	(vla-put-LockAspectRatio VlaObject LockAspectRatio)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_RASTERIMAGE ( VlaObject /
	Dir
	DirNew
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew
	Node
	NumRoundOffLocal
	P
	PNew
	ScaleFactor
	ScaleFactorNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-origin VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(setq ScaleFactor (vla-get-ScaleFactor VlaObject))
	(setq ListPoint (RND_FIND_LISTPOINT_CLIPBOUNDARYIMAGE VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "2"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "2")))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq ScaleFactorNew (RND_ROUNDOFF_NUMBER ScaleFactor NumRoundOffLocal))
	(if (/= (length ListPoint) 2)
		(progn
			(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "2")) ListPoint))
			(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
			(setq ListCoordinatesNew (apply 'append (mapcar '(lambda (x) (list (car x) (cadr x))) ListPointNew)))
		)
	)

	(vla-put-origin VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
	(vla-put-ScaleFactor VlaObject ScaleFactorNew)
	(if ListCoordinatesNew
		(vla-ClipBoundary
			VlaObject
			(vlax-safearray-fill
				(vlax-make-safearray
					vlax-vbDouble
					(cons 0 (- (length ListCoordinatesNew) 1))
				)
				ListCoordinatesNew
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_SOLID ( VlaObject / 
	ListCoordinates
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq ListPoint
		(list
			(list (nth 00 ListCoordinates) (nth 01 ListCoordinates) (nth 02 ListCoordinates))
			(list (nth 03 ListCoordinates) (nth 04 ListCoordinates) (nth 05 ListCoordinates))
			(list (nth 06 ListCoordinates) (nth 07 ListCoordinates) (nth 08 ListCoordinates))
			(list (nth 09 ListCoordinates) (nth 10 ListCoordinates) (nth 11 ListCoordinates))
		)
	)

	(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "2")) ListPoint))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
	(setq ListCoordinatesNew (apply 'append ListPointNew))

	(vla-put-Coordinates
		VlaObject
		(vlax-safearray-fill
			(vlax-make-safearray
				vlax-vbDouble
				(cons 0 (- (length ListCoordinatesNew) 1))
			)
			ListCoordinatesNew
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_ATTDEF ( VlaObject /
	Dir
	DirNew
	Node
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))

	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_ELLIPSECLOSE ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	Node 
	PC
	PCNew
	MajorAxisNew
	NumRoundOffLocal
	Rad1
	Rad1New
	Rad2
	Rad2New)

	(setq PC (RND_VARIANT_TO_LIST (vla-get-Center VlaObject)))
	(setq Rad1 (vla-get-MajorRadius VlaObject))
	(setq Rad2 (vla-get-MinorRadius VlaObject))
	(setq Dir (angle (list 0.0 0.0 0.0) (RND_VARIANT_TO_LIST (vla-get-MajorAxis VlaObject))))

	(setq Node (RND_FIND_NODE_FROM_P PC "3"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))
	(setq PCNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq Rad1New (RND_FIND_RADNEW Rad1 NumRoundOffLocal))
	(if (= Rad1New 0.0)
		(setq Rad1New NumZero)
	)
	(setq Rad2New (RND_FIND_RADNEW Rad2 NumRoundOffLocal))
	(if (= Rad2New 0.0)
		(setq Rad2New NumZero)
	)
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq MajorAxisNew (polar (list 0.0 0.0 0.0) DirNew Rad1New))

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq DataEnameObject (subst (cons 41 0.0) (assoc 41 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 42 PiDoub) (assoc 42 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
	(vla-put-Center VlaObject (vlax-3d-point PCNew))
	(vla-put-MajorAxis VlaObject (vlax-3d-point MajorAxisNew))
	(vla-put-MinorRadius VlaObject Rad2New)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_LEADER  ( VlaObject /
	ListCoordinates
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew
	Num)

	(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq Num 0)
	(repeat (/ (length ListCoordinates) 3)
		(setq ListPoint
			(cons
				(list
					(nth Num ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
				)
				ListPoint
			)
		)
		(setq Num (+ Num 1))
	)
	(setq ListPoint (reverse ListPoint))

	(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "3")) ListPoint))
	(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
	(setq ListCoordinatesNew (apply 'append ListPointNew))

	(vla-put-Coordinates
		VlaObject
		(vlax-safearray-fill
			(vlax-make-safearray
				vlax-vbDouble
				(cons 0 (- (length ListCoordinatesNew) 1))
			)
			ListCoordinatesNew
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_MLEADER  ( VlaObject /
	Dir
	DirNew
	DoglegLength
	DoglegLengthNew
	Index
	LandingGap
	LandingGapNew
	ListCoordinates
	ListCoordinatesNew
	ListNode
	ListPoint
	ListPointNew
	Node
	Num
	NumRoundOffLocal
	P
	TextLineSpacingDistance
	TextLineSpacingDistanceNew)

	(foreach Index (RND_VARIANT_TO_LIST (vla-getleaderlineindexes VlaObject 0))
		(setq ListCoordinates (RND_VARIANT_TO_LIST (vla-getleaderlinevertices VlaObject Index)))
		(setq Num 0)
		(setq ListPoint Nil)
		(repeat (/ (length ListCoordinates) 3)
			(setq P
				(list
					(nth Num ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
					(nth (setq Num (+ Num 1)) ListCoordinates)
				)
			)
			(setq ListPoint (cons P ListPoint))
			(setq Num (+ Num 1))
		)
		(setq ListPoint (reverse ListPoint))

		(setq ListNode (mapcar '(lambda (x) (RND_FIND_NODE_FROM_P x "3")) ListPoint))
		(setq ListPointNew (mapcar 'RND_FIND_NODENEW_FROM_NODE ListNode))
		(setq ListCoordinatesNew (apply 'append ListPointNew))

		(vla-SetLeaderLineVertices
			VlaObject
			Index
			(vlax-safearray-fill
				(vlax-make-safearray
					vlax-vbDouble
					(cons 0 (- (length ListCoordinatesNew) 1))
				)
				ListCoordinatesNew
			)
		)

		(setq Dir (angle (list 0.0 0.0 0.0) (RND_VARIANT_TO_LIST (vla-GetDoglegDirection VlaObject Index))))
		(setq DoglegLength (vla-get-DoglegLength VlaObject))
		(setq P (polar P Dir DoglegLength))

		(setq Node (RND_FIND_NODE_FROM_P P "3"))
		(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))

		(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
		(vla-SetDoglegDirection VlaObject Index (vlax-3d-point (list (cos DirNew) (sin DirNew) 0.0)))

		(setq DoglegLengthNew (RND_ROUNDOFF_NUMBER DoglegLength NumRoundOffLocal))
		(vla-put-DoglegLength VlaObject DoglegLengthNew)

		(vl-catch-all-apply '(lambda ( / )
			(setq LandingGap (vla-get-LandingGap VlaObject))
			(setq LandingGapNew (RND_ROUNDOFF_NUMBER LandingGap NumRoundOffLocal))
			(vla-put-LandingGap VlaObject LandingGapNew)
		))

		(vl-catch-all-apply '(lambda ( / )
			(setq TextLineSpacingDistance (vla-get-TextLineSpacingDistance VlaObject))
			(setq TextLineSpacingDistanceNew (RND_ROUNDOFF_NUMBER TextLineSpacingDistance NumRoundOffLocal))
			(vla-put-TextLineSpacingDistance VlaObject TextLineSpacingDistanceNew)
		))


	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_MTEXT ( VlaObject / 
	Code
	DataEnameObject
	Dir
	DirNew
	Node
	P
	PNew
	NumRoundOffLocal
	SizeFrame
	SizeFrameNew
	Temp)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(foreach Code (list 41 46)
		(setq Temp (assoc Code DataEnameObject))
		(setq SizeFrame (cdr Temp))
		(setq SizeFrameNew (RND_ROUNDOFF_NUMBER SizeFrame NumRoundOffLocal))
		(setq DataEnameObject (subst (cons Code SizeFrameNew) Temp DataEnameObject))
	)
	(setq DataEnameObject (append DataEnameObject '((75 . 0))))

	(entmod DataEnameObject)
	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_RAY ( VlaObject / 
	Dir
	DirNew
	DirVec
	DirVecNew
	Node
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-BasePoint VlaObject)))
	(setq DirVec (RND_VARIANT_TO_LIST (vla-get-DirectionVector VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) DirVec))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DirVecNew (list (cos DirNew) (sin DirNew) 0.0))

	(vla-put-BasePoint VlaObject (vlax-3d-point PNew))
	(vla-put-DirectionVector VlaObject (vlax-3d-point DirVecNew))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_SHAPE ( VlaObject / 
	Dir
	DirNew
	Node
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))

	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_TABLE ( VlaObject /
	Dir
	DirNew
	DirVecNew
	Node
	Num
	NumRoundOffLocal
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) (RND_VARIANT_TO_LIST (vla-get-Direction VlaObject))))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DirVecNew (list (cos DirNew) (sin DirNew) 0.0))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))

	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Direction VlaObject (vlax-3d-point DirVecNew))
	(setq Num 0)
	(repeat (vla-get-columns VlaObject)
		(vla-SetColumnWidth VlaObject Num (RND_ROUNDOFF_NUMBER (vla-GetColumnWidth VlaObject Num) NumRoundOffLocal))
		(setq Num (+ Num 1))
	)
	(setq Num 0)
	(repeat (vla-get-rows VlaObject)
		(vla-SetRowHeight VlaObject Num (RND_ROUNDOFF_NUMBER (vla-GetRowHeight VlaObject Num) NumRoundOffLocal))
		(setq Num (+ Num 1))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_TEXT ( VlaObject /
	Dir
	DirNew
	Node
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))

	(vla-put-InsertionPoint VlaObject (vlax-3d-point PNew))
	(vla-put-Rotation VlaObject DirNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_XLINE ( VlaObject / 
	Dir
	DirNew
	DirVec
	DirVecNew
	Node
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-BasePoint VlaObject)))
	(setq DirVec (RND_VARIANT_TO_LIST (vla-get-DirectionVector VlaObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) DirVec))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DirVecNew (list (cos DirNew) (sin DirNew) 0.0))

	(vla-put-BasePoint VlaObject (vlax-3d-point PNew))
	(vla-put-DirectionVector VlaObject (vlax-3d-point DirVecNew))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSION2LINEANGULAR ( VlaObject /
	DataEnameObject
	Dir05
	Dir05New
	Dir34
	Dir34New
	Node0
	Node3
	Node4
	Node5
	NumRoundOffLocal
	P0
	P0New
	P3
	P3New
	P4
	P4New
	P5
	P5New
	P6
	P6New
	PC
	PCNew
	PT
	PTNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P0 (cdr (assoc 10 DataEnameObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq P4 (cdr (assoc 14 DataEnameObject)))
	(setq P5 (cdr (assoc 15 DataEnameObject)))
	(setq P6 (cdr (assoc 16 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))
	(setq Dir05 (angle P0 P5))
	(setq Dir34 (angle P3 P4))
	(setq PC (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P0 Dir05 P3 Dir34))

	(setq Dir05New (RND_FIND_DIRNEW_EFFECTIVE Dir05))
	(setq Dir34New (RND_FIND_DIRNEW_EFFECTIVE Dir34))

	(if (not (RND_CHECK_PI (- Dir05New Dir34New)))
		(progn
			(setq Node0 (RND_FIND_NODE_FROM_P P0 "3"))
			(setq Node3 (RND_FIND_NODE_FROM_P P3 "3"))
			(setq Node4 (RND_FIND_NODE_FROM_P P4 "3"))
			(setq Node5 (RND_FIND_NODE_FROM_P P5 "3"))
			(setq NumRoundOffLocal
				(min 
					(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node0 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir05)) "3"))
					(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node3 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir34)) "3"))
				)
			)
			(setq P0New (RND_FIND_NODENEW_FROM_NODE Node0))
			(setq P3New (RND_FIND_NODENEW_FROM_NODE Node3))
			(setq P4New (RND_FIND_NODENEW_FROM_NODE Node4))	
			(setq P5New (RND_FIND_NODENEW_FROM_NODE Node5))
			(setq PCNew (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P0New Dir05New P3New Dir34New))
			(setq P6New (polar PCNew (RND_FIND_DIRNEW_EFFECTIVE (angle PC P6)) (RND_ROUNDOFF_NUMBER (distance PC P6) NumRoundOffLocal)))
			(setq PTNew (polar PCNew (RND_FIND_DIRNEW_EFFECTIVE (angle PC PT)) (RND_ROUNDOFF_NUMBER (distance PC PT) NumRoundOffLocal)))

			(setq DataEnameObject (subst (cons 10 P0New) (assoc 10 DataEnameObject) DataEnameObject))
			(setq DataEnameObject (subst (cons 13 P3New) (assoc 13 DataEnameObject) DataEnameObject))
			(setq DataEnameObject (subst (cons 14 P4New) (assoc 14 DataEnameObject) DataEnameObject))
			(setq DataEnameObject (subst (cons 15 P5New) (assoc 15 DataEnameObject) DataEnameObject))
			(setq DataEnameObject (subst (cons 16 P6New) (assoc 16 DataEnameObject) DataEnameObject))
			(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
			(entmod DataEnameObject)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSION3POINTANGULAR ( VlaObject /
	DataEnameObject
	Dir
	Dir3
	Dir4
	DirT
	Node3
	Node4
	NodeC
	NumRoundOffLocal
	P
	PNew
	P3
	P3New
	P4
	P4New
	PC
	PCNew
	PT
	PTNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P (cdr (assoc 10 DataEnameObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq P4 (cdr (assoc 14 DataEnameObject)))
	(setq PC (cdr (assoc 15 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))
	(setq Dir (angle PC P))
	(setq Dir3 (angle PC P3))
	(setq Dir4 (angle PC P4))
	(setq DirT (angle PC PT))

	(setq NodeC (RND_FIND_NODE_FROM_P PC "3"))
	(setq NumRoundOffLocal
		(min 
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list NodeC (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir3)) "3"))
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list NodeC (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir4)) "3"))
		)
	)

	(setq PCNew (RND_FIND_PCNEW_FROM_PC PC))
	(if (not PCNew)
		(setq PCNew (RND_FIND_NODENEW_FROM_NODE NodeC))
	)

	(setq Node3 (RND_FIND_NODE_FROM_P P3 "3"))
	(setq P3New (RND_FIND_NODENEW_FROM_NODE Node3))
	(if (not P3New)
		(setq P3New
			(polar
				PCNew
				(RND_FIND_DIRNEW_EFFECTIVE Dir3)
				(RND_ROUNDOFF_NUMBER (distance PC P3) NumRoundOffLocal)
			)
		)
	)

	(setq Node4 (RND_FIND_NODE_FROM_P P4 "3"))
	(setq P4New (RND_FIND_NODENEW_FROM_NODE Node4))
	(if (not P4New)
		(setq P4New
			(polar
				PCNew
				(RND_FIND_DIRNEW_EFFECTIVE Dir4)
				(RND_ROUNDOFF_NUMBER (distance PC P4) NumRoundOffLocal)
			)
		)
	)

	(setq PNew
		(polar
			PCNew
			(RND_FIND_DIRNEW_EFFECTIVE Dir)
			(RND_ROUNDOFF_NUMBER (distance PC P) NumRoundOffLocal)
		)
	)

	(setq PTNew
		(polar
			PCNew
			(RND_FIND_DIRNEW_EFFECTIVE DirT)
			(RND_ROUNDOFF_NUMBER (distance PC PT) NumRoundOffLocal)
		)
	)

	(setq DataEnameObject (subst (cons 10 PNew) (assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 13 P3New) (assoc 13 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 14 P4New) (assoc 14 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 15 PCNew) (assoc 15 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONALIGNED ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	DirPer
	DirPerNew
	Node1
	Node2
	Node3
	Node4
	NumRoundOffLocal
	P1
	P1New
	P2
	P2New
	P3
	P3New
	P4
	P4New
	PT1
	PT1New
	PT2
	PT2New)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P1 (cdr (assoc 14 DataEnameObject)))
	(setq P2 (cdr (assoc 13 DataEnameObject)))
	(setq P3 (cdr (assoc 10 DataEnameObject)))
	(setq Dir (angle P2 P1))
	(setq P4 (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir P2 (+ Dir PiHalf)))
	(if (RND_CHECK_EQUAL_TWO_POINT P1 P3)
		(if (RND_CHECK_EQUAL_TWO_POINT P2 P4)
			(setq DirPer (+ Dir PiHalf))
			(setq DirPer (angle P2 P4))
		)
		(setq DirPer (angle P1 P3))
	)
	(setq PT1 (cdr (assoc 11 DataEnameObject)))
	(setq PT2 (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir PT1 DirPer))

	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DirPerNew (RND_FIND_DIRNEW_EFFECTIVE DirPer))
	(setq Node1 (RND_FIND_NODE_FROM_P P1 "3"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "3"))
	(setq Node3 (RND_FIND_NODE_FROM_P P3 "3"))
	(setq Node4 (RND_FIND_NODE_FROM_P P4 "3"))
	(setq NumRoundOffLocal
		(min 
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node1 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3"))
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node2 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3"))
		)
	)
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))
	(setq P3New (RND_FIND_NODENEW_FROM_NODE Node3))
	(setq P4New (RND_FIND_NODENEW_FROM_NODE Node4))
	(setq P2New (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1New DirNew P2New DirPerNew))
	(setq P3New (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1New DirPerNew P3New DirNew))
	(setq P4New (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P2New DirPerNew P3New DirNew))
	(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node2 P2New)
	(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node3 P3New)
	(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node4 P4New)

	(if
		(RND_CHECK_EQUAL_TWO_POINT
			(RND_ROUNDOFF_POINT PT2 NumZero)
			(RND_ROUNDOFF_POINT (RND_FIND_MIDPOINT P3 P4) NumZero)
		)
		(setq PT2New (RND_FIND_MIDPOINT P3New P4New))
		(setq PT2New
			(polar
				P3New
				(RND_FIND_DIRNEW_EFFECTIVE (angle P3 PT2))
				(RND_ROUNDOFF_NUMBER (distance P3 PT2) NumRoundOffLocal)
			)
		)
	)
	(setq PT1New
		(polar
			PT2New
			(RND_FIND_DIRNEW_EFFECTIVE (angle PT2 PT1))
			(RND_ROUNDOFF_NUMBER (distance PT2 PT1) NumRoundOffLocal)
		)
	)

	(setq DataEnameObject (subst (cons 14 P1New)	(assoc 14 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 13 P2New)	(assoc 13 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 10 P3New)	(assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PT1New)	(assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONARC ( VlaObject /
	DataEnameObject
	Dir
	Dir3
	Dir4
	DirT
	Node3
	Node4
	NodeC
	NumRoundOffLocal
	P
	PNew
	P3
	P3New
	P4
	P4New
	PC
	PCNew
	PT
	PTNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P (cdr (assoc 10 DataEnameObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq P4 (cdr (assoc 14 DataEnameObject)))
	(setq PC (cdr (assoc 15 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))
	(setq Dir (angle PC P))
	(setq Dir3 (angle PC P3))
	(setq Dir4 (angle PC P4))
	(setq DirT (angle PC PT))

	(setq NodeC (RND_FIND_NODE_FROM_P PC "3"))
	(setq NumRoundOffLocal
		(min 
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list NodeC (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir3)) "3"))
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list NodeC (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir4)) "3"))
		)
	)

	(setq PCNew (RND_FIND_PCNEW_FROM_PC PC))
	(if (not PCNew)
		(setq PCNew (RND_FIND_NODENEW_FROM_NODE NodeC))
	)

	(setq Node3 (RND_FIND_NODE_FROM_P P3 "3"))
	(setq P3New (RND_FIND_NODENEW_FROM_NODE Node3))
	(if (not P3New)
		(setq P3New
			(polar
				PCNew
				(RND_FIND_DIRNEW_EFFECTIVE Dir3)
				(RND_ROUNDOFF_NUMBER (distance PC P3) NumRoundOffLocal)
			)
		)
	)

	(setq Node4 (RND_FIND_NODE_FROM_P P4 "3"))
	(setq P4New (RND_FIND_NODENEW_FROM_NODE Node4))
	(if (not P4New)
		(setq P4New
			(polar
				PCNew
				(RND_FIND_DIRNEW_EFFECTIVE Dir4)
				(RND_ROUNDOFF_NUMBER (distance PC P4) NumRoundOffLocal)
			)
		)
	)

	(setq PNew
		(polar
			PCNew
			(RND_FIND_DIRNEW_EFFECTIVE Dir)
			(RND_ROUNDOFF_NUMBER (distance PC P) NumRoundOffLocal)
		)
	)

	(setq PTNew
		(polar
			PCNew
			(RND_FIND_DIRNEW_EFFECTIVE DirT)
			(RND_ROUNDOFF_NUMBER (distance PC PT) NumRoundOffLocal)
		)
	)

	(setq DataEnameObject (subst (cons 10 PNew) (assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 13 P3New) (assoc 13 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 14 P4New) (assoc 14 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 15 PCNew) (assoc 15 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONDIAMETRIC ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	ListTemp
	Node
	NumRoundOffLocal
	P1
	P1New
	P2
	P2New
	PC
	PCNew
	PT
	PTNew
	Rad
	RadNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P1 (cdr (assoc 10 DataEnameObject)))
	(setq P2 (cdr (assoc 15 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))
	(setq PC (RND_FIND_MIDPOINT P1 P2))
	(setq Rad (distance PC P1))
	(setq Dir (angle PC P1))

	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq Node (RND_FIND_NODE_FROM_P PC "3"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))
	(if (setq ListTemp (RND_FIND_PCNEW_RADNEW_FROM_PC_RAD (list PC Rad)))
		(progn
			(setq PCNew (car ListTemp))
			(setq RadNew (cadr ListTemp))
		)
		(progn
			(setq PCNew (RND_FIND_NODENEW_FROM_NODE Node))
			(setq RadNew (RND_ROUNDOFF_NUMBER Rad NumRoundOffLocal))
		)
	)
	(setq P1New (polar PCNew DirNew RadNew))
	(setq P2New (polar PCNew (- DirNew pi) RadNew))
	(setq PTNew (polar PCNew (RND_FIND_DIRNEW_EFFECTIVE (angle PC PT)) (RND_ROUNDOFF_NUMBER (distance PC PT) NumRoundOffLocal)))

	(setq DataEnameObject (subst (cons 10 P1New) (assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 15 P2New) (assoc 15 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONRADIAL ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	ListTemp
	Node
	NumRoundOffLocal
	P1
	P1New
	Rad
	RadNew
	PC
	PCNew
	PT
	PTNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq PC (cdr (assoc 10 DataEnameObject)))
	(setq P1 (cdr (assoc 15 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))
	(setq Rad (distance PC P1))
	(setq Dir (angle PC P1))

	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq Node (RND_FIND_NODE_FROM_P PC "3"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))
	(if (setq ListTemp (RND_FIND_PCNEW_RADNEW_FROM_PC_RAD (list PC Rad)))
		(progn
			(setq PCNew (car ListTemp))
			(setq RadNew (cadr ListTemp))
		)
		(progn
			(setq PCNew (RND_FIND_NODENEW_FROM_NODE Node))
			(setq RadNew (RND_ROUNDOFF_NUMBER Rad NumRoundOffLocal))
		)
	)
	(setq P1New (polar PCNew DirNew RadNew))
	(setq PTNew (polar PCNew (RND_FIND_DIRNEW_EFFECTIVE (angle PC PT)) (RND_ROUNDOFF_NUMBER (distance PC PT) NumRoundOffLocal)))

	(setq DataEnameObject (subst (cons 10 PCNew) (assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 15 P1New) (assoc 15 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONRADIALLARGE ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	DirPer
	DirPerNew
	DisT
	Dis1
	Dis2
	Dis3
	ListP2New
	ListTemp
	ListSign
	Node
	Num
	NumRoundOffLocal
	P1
	P1New
	PT
	PTNew
	P2
	P2New
	P3
	P3New
	PC
	PCNew
	PTemp
	Rad
	RadNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq PC (cdr (assoc 10 DataEnameObject)))
	(setq P1 (cdr (assoc 15 DataEnameObject)))
	(setq P2 (cdr (assoc 14 DataEnameObject)))
	(setq P3 (cdr (assoc 13 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))
	(setq Rad (distance PC P1))
	(setq Dir (angle PC P1))
	(setq DirPer (+ Dir PiHalf))
	(setq PTemp (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1 Dir P2 DirPer))
	(setq Dis1 (distance P1 PTemp))
	(setq Dis2 (distance P2 PTemp))
	(setq PTemp (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir P2 DirPer))
	(setq Dis3 (distance P3 PTemp))
	(setq DisT (distance PC PT))

	(setq Node (RND_FIND_NODE_FROM_P PC "3"))
	(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3")))
	(if (setq ListTemp (RND_FIND_PCNEW_RADNEW_FROM_PC_RAD (list PC Rad)))
		(progn
			(setq PCNew (car ListTemp))
			(setq RadNew (cadr ListTemp))
		)
		(progn
			(setq PCNew (RND_FIND_NODENEW_FROM_NODE Node))
			(setq RadNew (RND_ROUNDOFF_NUMBER Rad NumRoundOffLocal))
		)
	)
	(setq Dis1 (RND_ROUNDOFF_NUMBER Dis1 NumRoundOffLocal))
	(setq Dis2 (RND_ROUNDOFF_NUMBER Dis2 NumRoundOffLocal))
	(setq Dis3 (RND_ROUNDOFF_NUMBER Dis3 NumRoundOffLocal))
	(setq DisT (RND_ROUNDOFF_NUMBER DisT NumRoundOffLocal))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq P1New (polar PCNew DirNew RadNew))
	(setq PTemp (polar P1New DirNew Dis1))
	(setq ListSign (list 1.0 -1.0))
	(setq ListP2New (mapcar '(lambda (x) (polar PTemp (+ DirNew (* PiHalf x)) Dis2)) ListSign))
	(setq Num (car (vl-sort-i (mapcar '(lambda (x) (distance x P2)) ListP2New) '<)))
	(setq P2New (nth Num ListP2New))
	(setq DirPerNew (+ DirNew (* PiHalf (nth Num ListSign))))
	(setq PTemp (polar P2New DirPerNew Dis2))
	(setq P3New (polar PTemp DirNew Dis3))
	(setq PTNew (polar PCNew DirNew	DisT))

	(setq DataEnameObject (subst (cons 10 PCNew) (assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 15 P1New) (assoc 15 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 14 P2New) (assoc 14 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 13 P3New) (assoc 13 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONFCF ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	DirVecNew
	Node
	P
	PNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P (cdr (assoc 10 DataEnameObject)))
	(setq Dir (angle (list 0.0 0.0 0.0) (cdr (assoc 11 DataEnameObject))))

	(setq Node (RND_FIND_NODE_FROM_P P "3"))
	(setq PNew (RND_FIND_NODENEW_FROM_NODE Node))
	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DirVecNew (list (cos DirNew) (sin DirNew) 0.0))

	(setq DataEnameObject (subst (cons 10 PNew) (assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 DirVecNew) (assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONORDINATE ( VlaObject /
	DataEnameObject
	P1
	P1New
	P2
	P2New
	PT
	PTNew)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P1 (cdr (assoc 13 DataEnameObject)))
	(setq P2 (cdr (assoc 14 DataEnameObject)))
	(setq PT (cdr (assoc 11 DataEnameObject)))

	(setq P1New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P1 NumRoundOffMax))
	(setq P2New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P2 NumRoundOffMax))
	(setq PTNew (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION PT NumRoundOffMax))

	(setq DataEnameObject (subst (cons 13 P1New) (assoc 13 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 14 P2New) (assoc 14 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PTNew) (assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_DIMENSIONROTATED ( VlaObject /
	DataEnameObject
	Dir
	DirNew
	DirPer
	DirPerNew
	Node1
	Node2
	Node3
	Node4
	NumRoundOffLocal
	P1
	P1New
	P2
	P2New
	P3
	P3New
	P4
	P4New
	PT1
	PT1New
	PT2
	PT2New)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq Dir (cdr (assoc 50 DataEnameObject)))
	(setq P1 (cdr (assoc 14 DataEnameObject)))
	(setq P2 (cdr (assoc 13 DataEnameObject)))
	(setq P3 (cdr (assoc 10 DataEnameObject)))
	(setq P4 (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir P2 (+ Dir PiHalf)))
	(if (RND_CHECK_EQUAL_TWO_POINT P1 P3)
		(if (RND_CHECK_EQUAL_TWO_POINT P2 P4)
			(setq DirPer (+ Dir PiHalf))
			(setq DirPer (angle P2 P4))
		)
		(setq DirPer (angle P1 P3))
	)
	(setq PT1 (cdr (assoc 11 DataEnameObject)))
	(setq PT2 (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P3 Dir PT1 DirPer))

	(setq DirNew (RND_FIND_DIRNEW_EFFECTIVE Dir))
	(setq DirPerNew (RND_FIND_DIRNEW_EFFECTIVE DirPer))
	(setq Node1 (RND_FIND_NODE_FROM_P P1 "3"))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 "3"))
	(setq Node3 (RND_FIND_NODE_FROM_P P3 "3"))
	(setq Node4 (RND_FIND_NODE_FROM_P P4 "3"))
	(setq NumRoundOffLocal
		(min 
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node3 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3"))
			(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node4 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir)) "3"))
		)
	)
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))
	(setq P3New (RND_FIND_NODENEW_FROM_NODE Node3))
	(setq P4New (RND_FIND_NODENEW_FROM_NODE Node4))
	(setq P3New (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P1New DirPerNew P3New DirNew))
	(setq P4New (RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 P2New DirPerNew P4New DirNew))
	(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node3 P3New)
	(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node4 P4New)

	(if
		(RND_CHECK_EQUAL_TWO_POINT
			(RND_ROUNDOFF_POINT PT2 NumZero)
			(RND_ROUNDOFF_POINT (RND_FIND_MIDPOINT P3 P4) NumZero)
		)
		(setq PT2New (RND_FIND_MIDPOINT P3New P4New))
		(setq PT2New
			(polar
				P3New
				(RND_FIND_DIRNEW_EFFECTIVE (angle P3 PT2))
				(RND_ROUNDOFF_NUMBER (distance P3 PT2) NumRoundOffLocal)
			)
		)
	)
	(setq PT1New
		(polar
			PT2New
			(RND_FIND_DIRNEW_EFFECTIVE (angle PT2 PT1))
			(RND_ROUNDOFF_NUMBER (distance PT2 PT1) NumRoundOffLocal)
		)
	)

	(setq DataEnameObject (subst (cons 50 DirNew)	(assoc 50 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 14 P1New)	(assoc 14 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 13 P2New)	(assoc 13 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 10 P3New)	(assoc 10 DataEnameObject) DataEnameObject))
	(setq DataEnameObject (subst (cons 11 PT1New)	(assoc 11 DataEnameObject) DataEnameObject))
	(entmod DataEnameObject)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_POINT ( VlaObject / 
	P
	PNew)

	(setq P (RND_VARIANT_TO_LIST (vla-get-Coordinates VlaObject)))
	(setq PNew (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P NumRoundOffMax))
	(vla-put-Coordinates VlaObject (vlax-3d-point PNew))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHANGE_VLAOBJECT_SPLINE ( VlaObject / 
	DataEnameObject
	P1
	P2
	P1New
	P2New)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(if (/= 1 (logand 1 (cdr (assoc 70 DataEnameObject))))
		(progn
			(if (assoc 11 DataEnameObject)
				(progn
					(setq P1 (cdr (assoc 11 DataEnameObject)))
					(setq P2 (cdr (assoc 11 (reverse DataEnameObject))))

					(setq P1New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P1 NumRoundOffMax))
					(setq P2New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P2 NumRoundOffMax))

					(setq DataEnameObject (subst (cons 11 P1New) (cons 11 P1) DataEnameObject))
					(setq DataEnameObject (subst (cons 11 P2New) (cons 11 P2) DataEnameObject))
					(entmod DataEnameObject)
				)
				(progn
					(setq P1 (cdr (assoc 10 DataEnameObject)))
					(setq P2 (cdr (assoc 10 (reverse DataEnameObject))))

					(setq P1New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P1 NumRoundOffMax))
					(setq P2New (RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION P2 NumRoundOffMax))

					(setq DataEnameObject (subst (cons 10 P1New) (cons 10 P1) DataEnameObject))
					(setq DataEnameObject (subst (cons 10 P2New) (cons 10 P2) DataEnameObject))
					(entmod DataEnameObject)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINTCHECK ( /
	Dir
	ListPointCheck
	List_MoveX_MoveY_Dir_ScaleX_ScaleY
	MoveX
	MoveY
	Node
	NameVar
	ObjectLevel
	PointCheck
	ScaleX
	ScaleY)

	(foreach Temp List_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2
		(setq
			List_MoveX_MoveY_Dir_ScaleX_ScaleY
			(cons
				(list
					(setq MoveX	(- (nth 0 Temp)))
					(setq MoveY	(- (nth 1 Temp)))
					(setq Dir	(- (nth 2 Temp)))
					(setq ScaleX	(/ 1.0 (nth 3 Temp)))
					(setq ScaleY	(/ 1.0 (nth 4 Temp)))
				)
				List_MoveX_MoveY_Dir_ScaleX_ScaleY
			)
		)
	)
	(foreach Temp ListPointChangeNumRnd_ObjectLevel
		(setq ObjectLevel (cadr Temp))
		(foreach Point (car Temp)
			(if (setq Node (RND_FIND_NODE_FROM_P Point ObjectLevel))
				(setq ListNodeChangeNumRnd (cons Node ListNodeChangeNumRnd))
			)
		)
	)
	(foreach Node ListNodeChangeNumRnd
		(if (setq PointCheck (RND_FIND_NODENEW_FROM_NODE Node))
			(progn
				(if List_MoveX_MoveY_Dir_ScaleX_ScaleY
					(foreach Temp List_MoveX_MoveY_Dir_ScaleX_ScaleY
						(setq MoveX	(nth 0 Temp))
						(setq MoveY	(nth 1 Temp))
						(setq Dir	(nth 2 Temp))
						(setq ScaleX	(nth 3 Temp))
						(setq ScaleY	(nth 4 Temp))
						(setq PointCheck (RND_TRANSFORMATION_MOVE (RND_TRANSFORMATION_ROTATE (RND_TRANSFORMATION_SCALE PointCheck ScaleX ScaleY) Dir) MoveX MoveY))
					)
				)
				(setq ListPointCheck (cons PointCheck ListPointCheck))
			)
		)
	)
	(setq NameVar (read (strcat "ListPointCheck" SeedVarDay)))
	(set NameVar (append ListPointCheck (eval NameVar)))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun C:SHOWPOINTCHECK ( /
	DataEname
	ListPointCheck
	Num
	Rad
	SSTemp
	StateLayerOn
	StateLock
	VlaLayerCurrent)

	(setq ListPointCheck (eval (read (strcat "ListPointCheck" (RND_CREATE_SEED 10 "DAY")))))
	(if ListPointCheck
		(progn
			(setq VlaLayerCurrent (vla-get-ActiveLayer (vla-get-activedocument (vlax-get-acad-object))))
			(setq StateLayerOn (vla-get-layeron VlaLayerCurrent))
			(setq StateLock (vla-get-lock VlaLayerCurrent))
			(vla-put-layeron VlaLayerCurrent :vlax-true)
			(vla-put-lock VlaLayerCurrent :vlax-false)

			(setq Rad (/ (getvar "VIEWSIZE") 100))
			(setq SSTemp (ssadd))
			(foreach PointCheck ListPointCheck
				(entmakex
					(list
						(cons 0 "CIRCLE")
						(cons 10 PointCheck)
						(cons 40 Rad)
						(cons 62 1)
					)
				)
				(ssadd (entlast) SSTemp)
			)

			(vl-catch-all-apply '(lambda ( / )
				(while (= 5 (car (grread T 13 0)))
					(setq Rad (/ (getvar "VIEWSIZE") 100))
					(setq Num 0)
					(repeat (sslength SSTemp)
						(setq DataEname (entget (ssname SSTemp Num)))
						(entmod (subst (cons 40 Rad) (assoc 40 DataEname) DataEname))
						(setq Num (+ Num 1))
					)
					(redraw)
				)
			))

			(setq Num 0)
			(repeat (sslength SSTemp)
				(entdel (ssname SSTemp Num))
				(setq Num (+ Num 1))
			)
			(vla-put-layeron VlaLayerCurrent StateLayerOn)
			(vla-put-lock VlaLayerCurrent StateLock)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LISTPOINT_WIPEOUT ( VlaObject /
	DataEnameObject
	P
	Point
	ListPoint
	Temp
	U
	V
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P (cdr (assoc 10 DataEnameObject)))
	(setq U (cdr (assoc 11 DataEnameObject)))
	(setq V (cdr (assoc 12 DataEnameObject)))
	(foreach Temp DataEnameObject
		(if (= (car Temp) 14)
			(progn
				(setq Point (cdr Temp))
				(setq ListPoint
					(cons
						(list
							(+
								(* (+ 0.5 (nth 0 Point)) (nth 0 U))
								(* (- 0.5 (nth 1 Point)) (nth 0 V))
								(nth 0 P)
							)
							(+
								(* (+ 0.5 (nth 0 Point)) (nth 1 U))
								(* (- 0.5 (nth 1 Point)) (nth 1 V))
								(nth 1 P)
							)
							0.0
						)
						ListPoint
					)
				)
			)
		)
	)
	(setq ListPoint (reverse ListPoint))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LISTPOINT_CLIPBOUNDARYIMAGE ( VlaObject /
	DataEnameObject
	P
	Point
	ListPoint
	Temp
	U
	V
	DataEnameObject)

	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(setq P (cdr (assoc 10 DataEnameObject)))
	(setq U (cdr (assoc 11 DataEnameObject)))
	(setq V (cdr (assoc 12 DataEnameObject)))
	(foreach Temp DataEnameObject
		(if (= (car Temp) 14)
			(progn
				(setq Point (cdr Temp))
				(setq ListPoint
					(cons
						(list
							(+
								(* (+ 0.5 (nth 0 Point)) (nth 0 U))
								(* (- 0.5 (nth 1 Point)) (nth 0 V))
								(nth 0 P)
							)
							(+
								(* (+ 0.5 (nth 0 Point)) (nth 1 U))
								(* (- 0.5 (nth 1 Point)) (nth 1 V))
								(nth 1 P)
							)
							0.0
						)
						ListPoint
					)
				)
			)
		)
	)
	(setq ListPoint (reverse ListPoint))
	(setq Disp (mapcar '(lambda (x) (* x (- (cadr (cdr (assoc 13 DataEnameObject))) 1.0))) V))
	(setq ListPoint (mapcar '(lambda (Point) (mapcar '+ Point Disp)) ListPoint))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LISTENAMEOBJECTVERTEX_FROM_VIEWPORT ( VlaObject / EnameObject ListEnameObjectVertex)
	(setq EnameObject (cdr (assoc 340 (entget (vlax-vla-object->ename VlaObject)))))
	(if
		(and
			EnameObject
			(= (cdr (assoc 0 (entget EnameObject))) "POLYLINE")
		)
		(progn
			(setq EnameObject (entnext EnameObject))
			(while
				(and
					EnameObject
					(= (cdr (assoc 0 (entget EnameObject))) "VERTEX")
				)
				(setq ListEnameObjectVertex (cons EnameObject ListEnameObjectVertex))
				(setq EnameObject (entnext EnameObject))
			)
			(setq ListEnameObjectVertex (reverse ListEnameObjectVertex))
		)
	)
	ListEnameObjectVertex
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_LISTPOINT_CLIPBOUNDARY_DGN_DWF_PDF_REFERENCE ( VlaObject /
	DataEnameObject
	Dir
	ListPoint
	MoveX
	MoveY
	P
	Scale
	ScaleX
	ScaleY
	Temp)

	(setq P (RND_VARIANT_TO_LIST (vla-get-Position VlaObject)))
	(setq Dir (vla-get-Rotation VlaObject))
	(setq Scale (vla-get-ScaleFactor VlaObject))
	(setq MoveX (nth 0 P))
	(setq MoveY (nth 1 P))
	(setq ScaleX Scale)
	(setq ScaleY Scale)
	(setq DataEnameObject (entget (vlax-vla-object->ename VlaObject)))
	(foreach Temp DataEnameObject
		(if (= (car Temp) 11)
			(setq ListPoint (cons (cdr Temp) ListPoint))
		)
	)
	(setq ListPoint (reverse ListPoint))
	(setq ListPoint (mapcar '(lambda (Point) (RND_TRANSFORMATION_SCALE Point ScaleX ScaleY)) ListPoint))
	(setq ListPoint (mapcar '(lambda (Point) (RND_TRANSFORMATION_ROTATE Point Dir)) ListPoint))
	(setq ListPoint (mapcar '(lambda (Point) (RND_TRANSFORMATION_MOVE Point MoveX MoveY)) ListPoint))
	ListPoint
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DATAXCLIPBOUNDARY ( VlaObject /
	DataEname
	Dir
	Ename1
	Ename2
	FlagInvertBoundary
	FlagDisplayBoundary
	ListMatrix
	ListPoint
	ListResult
	ListTemp
	Num
	P
	P1
	P2
	P3
	P4
	MoveX
	MoveY
	ScaleFactorBlock
	ScaleX
	ScaleY
	Temp)

	(setq Ename1 (vlax-vla-object->ename VlaObject))
	(while (setq Ename2 (cdr (assoc 360 (entget Ename1)))) (setq Ename1 Ename2))
	(if (member '(0 . "SPATIAL_FILTER") (setq DataEname (entget Ename1)))
		(progn
			(foreach Temp DataEname
				(if (= (car Temp) 10)
					(setq ListPoint (cons (cdr Temp) ListPoint))
				)
			)
			(setq ListPoint (reverse ListPoint))
			(if (= (length ListPoint) 2)
				(progn
					(setq P1 (nth 0 ListPoint))
					(setq P3 (nth 1 ListPoint))
					(setq P2 (list (nth 0 P1) (nth 1 P3) 0.0))
					(setq P4 (list (nth 0 P3) (nth 1 P1) 0.0))
					(setq ListPoint (list P1 P2 P3 P4))
				)
			)
			(setq ListPoint (mapcar '(lambda (x) (append x (list 1.0))) ListPoint))

			(setq Num 0)
			(foreach Temp DataEname
				(if (= (car Temp) 40)
					(progn
						(setq ListTemp (cons (cdr Temp) ListTemp))
						(if (= Num 3)
							(progn
								(setq ListMatrix (cons (reverse ListTemp) ListMatrix))
								(setq ListTemp Nil)
								(setq Num -1)
							)
						)
						(setq Num (+ Num 1))
					)
				)
			)
			(setq ListMatrix (reverse ListMatrix))
			
			(setq ListPoint
				(mapcar
					'(lambda
						(Point)
						(list
							(apply '+ (mapcar '(lambda (a b) (* a b)) (nth 0 ListMatrix) Point))
							(apply '+ (mapcar '(lambda (a b) (* a b)) (nth 1 ListMatrix) Point))
							(apply '+ (mapcar '(lambda (a b) (* a b)) (nth 2 ListMatrix) Point))
						)
					)
					ListPoint
				)
			)

			(setq ScaleFactorBlock (RND_GET_SCALEFACTORBLOCK (vla-item VlaBlocksGroup (RND_GET_EFFECTIVENAME_BLOCK VlaObject))))
			(setq ScaleX (* (vla-get-XEffectiveScaleFactor VlaObject) ScaleFactorBlock))
			(setq ScaleY (* (vla-get-YEffectiveScaleFactor VlaObject) ScaleFactorBlock))
			(setq Dir (vla-get-Rotation VlaObject))
			(setq P (RND_VARIANT_TO_LIST (vla-get-InsertionPoint VlaObject)))
			(setq MoveX (nth 0 P))
			(setq MoveY (nth 1 P))
			(setq ListPoint (mapcar '(lambda (Point) (RND_TRANSFORMATION_SCALE Point ScaleX ScaleY)) ListPoint))
			(setq ListPoint (mapcar '(lambda (Point) (RND_TRANSFORMATION_ROTATE Point Dir)) ListPoint))
			(setq ListPoint (mapcar '(lambda (Point) (RND_TRANSFORMATION_MOVE Point MoveX MoveY)) ListPoint))

			(setq FlagDisplayBoundary (cdr (assoc 71 DataEname)))
			(setq FlagInvertBoundary (cdr (assoc 290 DataEname)))
			(setq ListResult (list Ename1 ListPoint FlagDisplayBoundary FlagInvertBoundary))
		)
	)
	ListResult
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun CREATE_NEW_XCLIP (Ename ListPoint FlagDisplayBoundary FlagInvertBoundary / DataEname DataEnameSpatialFilter Dict EnameSpatialFilter TempDict TempList)
	(if
		(and
			(setq DataEname (entget Ename))
					(setq Dict
				(if 
					(setq TempList (assoc 360 DataEname))
					(cdr TempList)
					(entmakex '((0 . "DICTIONARY") (100 . "AcDbDictionary")))
						 	)
			)
			(setq
				TempDict
				(if
					(setq TempList (dictsearch Dict "ACAD_FILTER"))
					(cdr (assoc -1 TempList))
					(dictadd Dict "ACAD_FILTER" (entmakex '((0 . "DICTIONARY") (100 . "AcDbDictionary"))))
				)
			)
		)
		(progn
			(entupd Ename)
			(dictremove TempDict "SPATIAL")
			(dictadd
				TempDict
				"SPATIAL"
				(setq EnameSpatialFilter
					(entmakex
						(append
							(list
								(cons 0 "SPATIAL_FILTER")
								(cons 100 "AcDbFilter")
								(cons 100 "AcDbSpatialFilter")
								(cons 70 (length ListPoint))
							)
							(mapcar
								(function
									(lambda
										(x)
										(cons 10 x)
									)
								)
								ListPoint
							)
							(list
								(assoc 210 (entget Ename))
								(list 11 0.0 0.0 0.0)
								(cons 71 FlagDisplayBoundary)
								(cons 72 0)
								(cons 73 0)
							)
							(mapcar
								(function
									(lambda
										(x)
										(cons 40 x)
									)
								)
								(apply
									(function append)
									(
										(lambda
											(a p x y z)
											(list
												(mapcar
													'(lambda (_x) (/ _x x))
													(list
														(cos a)
														(- (sin a))
														0.0
														(- 0.0 (* (car p) (cos a)) (* (cadr p) (- (sin a))))
													)
												)
												(mapcar
													'(lambda (_y) (/ _y y))
													(list
														(sin a)
														(cos a)
														0.0
														(- 0.0 (* (car p) (sin a)) (* (cadr p) (cos a)))
													)
												)
												'(0.0 0.0 1.0 0.0)
												'(1.0 0.0 0.0 0.0)
												'(0.0 1.0 0.0 0.0)
												'(0.0 0.0 1.0 0.0)
											)
										)
										(- (cdr (assoc 50 (entget Ename))))
										(cdr (assoc 10 (entget Ename)))
										(cdr (assoc 41 (entget Ename)))
										(cdr (assoc 42 (entget Ename)))
										(cdr (assoc 43 (entget Ename)))
									)
								)
							)
							(list
								(cons 290 1)
							)
						)
					)
				)
			)
			(entmod
				(if
					(setq TempList (assoc 360 DataEname))
					(subst (cons 360 Dict) TempList DataEname)
					(progn
						(setq TempList (member (assoc 5 DataEname) (reverse DataEname)))
						(append
							(reverse TempList)
							(append
								(list
									'(102 . "{ACAD_XDICTIONARY")
									(cons 360 Dict)
									'(102 . "}")
								)
								(member (assoc 5 DataEname) DataEname)
							)
						)
					)
				)
			)
			(if (= FlagInvertBoundary 1)
				(progn
					(setq DataEnameSpatialFilter (entget EnameSpatialFilter))
					(setq DataEnameSpatialFilter (subst (cons 290 FlagInvertBoundary) (assoc 290 DataEnameSpatialFilter) DataEnameSpatialFilter))
					(entmod DataEnameSpatialFilter)
				)
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_GET_SCALEFACTORBLOCK ( VlaBlock / UnitBlock)
	(setq UnitBlock (cdr (assoc (vla-get-units VlaBlock) ListNumUnit_Unit)))
	(if (or (= UnitCurrent "Unitless") (= UnitBlock "Unitless"))
		(setq ScaleFactorBlock 1.0)
		(setq ScaleFactorBlock
			(cvunit
				1.0
				UnitBlock
				UnitCurrent
			)
		)
	)
	ScaleFactorBlock
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_SEED (Numbercal Type / Modulus Multiplier Increment Temp RandomString)
	(if (= Type "SEC")
	 		(setq Seed (getvar "MILLISECS"))
	)
	(if (= Type "DAY")
	 		(setq Seed (atoi (rtos (getvar "CDATE") 2 0)))
	)
	(repeat Numbercal
		(setq	Modulus		65536
			Multiplier	25173
			Increment	13849
			Seed		(abs (fix (rem (+ (* Multiplier Seed) Increment) Modulus)))
			Temp		(rem Seed 36)
		)
		(if (= Temp 0) (setq Temp "0"))
		(if (= Temp 1) (setq Temp "1"))
		(if (= Temp 2) (setq Temp "2"))
		(if (= Temp 3) (setq Temp "3"))
		(if (= Temp 4) (setq Temp "4"))
		(if (= Temp 5) (setq Temp "5"))
		(if (= Temp 6) (setq Temp "6"))
		(if (= Temp 7) (setq Temp "7"))
		(if (= Temp 8) (setq Temp "8"))
		(if (= Temp 9) (setq Temp "9"))
		(if (= Temp 10) (setq Temp "A"))
		(if (= Temp 11) (setq Temp "B"))
		(if (= Temp 12) (setq Temp "C"))
		(if (= Temp 13) (setq Temp "D"))
		(if (= Temp 14) (setq Temp "E"))
		(if (= Temp 15) (setq Temp "F"))
		(if (= Temp 16) (setq Temp "G"))
		(if (= Temp 17) (setq Temp "H"))
		(if (= Temp 18) (setq Temp "I"))
		(if (= Temp 19) (setq Temp "J"))
		(if (= Temp 20) (setq Temp "K"))
		(if (= Temp 21) (setq Temp "L"))
		(if (= Temp 22) (setq Temp "M"))
		(if (= Temp 23) (setq Temp "N"))
		(if (= Temp 24) (setq Temp "O"))
		(if (= Temp 25) (setq Temp "P"))
		(if (= Temp 26) (setq Temp "Q"))
		(if (= Temp 27) (setq Temp "R"))
		(if (= Temp 28) (setq Temp "S"))
		(if (= Temp 29) (setq Temp "T"))
		(if (= Temp 30) (setq Temp "U"))
		(if (= Temp 31) (setq Temp "V"))
		(if (= Temp 32) (setq Temp "W"))
		(if (= Temp 33) (setq Temp "X"))
		(if (= Temp 34) (setq Temp "Y"))
		(if (= Temp 35) (setq Temp "Z"))
		(if RandomString
			(setq RandomString (strcat Temp RandomString))
			(setq RandomString Temp)
		)
	)
	RandomString
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_RESET_LISTNAMEVAR ( ListNameVar / )
	(mapcar '(lambda (x) (set x nil)) (mapcar 'car ListNameVar))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_RADNEW ( Rad NumRoundOff /)
	(RND_ROUNDOFF_NUMBER Rad NumRoundOff)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_SET_VARSYSTEM ( / Temp VarSystem)
	(foreach Temp (list (list "CMDECHO" 0) (list "MODEMACRO" "") (list "DIMZIN" 8))
		(setq VarSystem (car Temp))
		(setq ListVarSystem_OldValue (cons (list VarSystem (getvar VarSystem)) ListVarSystem_OldValue))
		(setvar VarSystem (cadr Temp))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_RESET_VARSYSTEM ( / Temp VarSystem)
	(foreach Temp ListVarSystem_OldValue
		(setvar (car Temp) (cadr Temp))
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CREATE_LISTVLALAYERLOCK ( / )
	(vlax-for VlaLayer (vla-get-layers VlaDrawingCurrent)
		(if (= (vla-get-lock VlaLayer) :vlax-true)
			(progn
				(vla-put-lock VlaLayer :vlax-false)
				(setq ListVlaLayerLock (cons VlaLayer ListVlaLayerLock))
			)
		)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_RESET_LISTVLALAYERLOCK ( / )
	(foreach VlaLayer ListVlaLayerLock
		(vla-put-lock VlaLayer :vlax-true)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_RADNEW ( RadNew CNew NumRoundOff / RadResult)
	(setq RadResult RadNew)

	(if (< (RND_ROUNDOFF_NUMBER (- RadResult CNew) NumZero) 0.0)
		(setq RadResult (RND_ROUNDOFF_NUMBER CNew NumRoundOff))
	)
	(while (< (RND_ROUNDOFF_NUMBER (- RadResult CNew) NumZero) 0.0)
		(setq RadResult (+ RadResult NumRoundOff))
	)
	RadResult
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINT_OF_ELLIPSE ( PC Ratio Dir Rad1 Rad2 Ang / Para)
	(setq Para (atan (sin Ang) (* Ratio (cos Ang))))
	(list
		(+
			(nth 0 PC)
			(-
				(* Rad1 (cos Dir) (cos Para))
				(* Rad2 (sin Dir) (sin Para))
			)
		)
		(+
			(nth 1 PC)
			(+
				(* Rad1 (sin Dir) (cos Para))
				(* Rad2 (cos Dir) (sin Para))
			)
		)
		0.0
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_BULGE_TO_ARC ( P1 P2 Bulge / Theta PC Rad )
	(setq Theta (* 2 (atan Bulge)))
	(setq Rad (/ (distance P1 P2) 2 (sin Theta)))
	(setq PC (polar P1 (+ (- PiHalf Theta) (angle P1 P2)) Rad))
	(setq Rad (abs Rad))
	(list PC Rad)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ARC_TO_BULGE ( P1New P2New PCNew Bulge / BulgeAbs BulgeNew ListBulgeAbsNew ThetaAbs)
	(setq ThetaAbs (abs (- (angle PCNew P1New) (angle PCNew P2New))))
	(setq ListBulgeAbsNew
		(mapcar
			'(lambda
				(x)
				(/ (sin x) (cos x))
			)	
			(list
				(/ ThetaAbs 4.0)
				(/ (- PiDoub ThetaAbs) 4.0)
			)
		)
	)
	(setq BulgeAbs (abs Bulge))
	(setq BulgeNew (nth (car (vl-sort-i (mapcar '(lambda (x) (abs (- x BulgeAbs))) ListBulgeAbsNew) '<)) ListBulgeAbsNew))
	(if (minusp Bulge)
		(setq BulgeNew (- BulgeNew))
	)
	BulgeNew
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_P1NEW_P2NEW_PCNEW_RADNEW ( P1 P2 PC Rad ObjectLevel /
	CheckError
	CheckRepeat
	CheckTan1
	CheckTan2
	CNew
	Dir1
	Dir1New
	Dir1TanNew
	Dir2
	Dir2New
	Dir2TanNew
	DisDifMax
	ListPCNew
	Node1
	Node2
	Num
	NumError
	NumRoundOffLocal
	P1New
	P1NewTemp
	P2New
	P2NewTemp
	PCNew
	PTemp
	RadNew
	RadNewTemp)

	(setq Node1 (RND_FIND_NODE_FROM_P P1 ObjectLevel))
	(setq Node2 (RND_FIND_NODE_FROM_P P2 ObjectLevel))
	(setq P1New (RND_FIND_NODENEW_FROM_NODE Node1))
	(setq P2New (RND_FIND_NODENEW_FROM_NODE Node2))

	(setq Dir1 (angle P1 PC))
	(setq Dir2 (angle P2 PC))
	(setq Dir1New (RND_FIND_DIRNEW_EFFECTIVE Dir1))
	(setq Dir2New (RND_FIND_DIRNEW_EFFECTIVE Dir2))
	(if (RND_CHECK_PIHALF (RND_FIND_DIRLINNEW (- Dir1 Dir2)))
		(setq NumRoundOffLocal
			(min
				(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node1 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir1)) ObjectLevel))
				(nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node2 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir2)) ObjectLevel))
			)
		)
		(setq NumRoundOffLocal (nth 2 (RND_FIND_P_PBASE_NUMRND_NODECNT_FROM_NODE_DIRNEW (list Node1 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL (angle P1 P2))) ObjectLevel)))
	)
	(if (RND_CHECK_PI (- Dir1New Dir2New))
		(progn
			(setq NumRoundOffLocal (* NumRoundOffLocal 0.5))
			(setq RadNew (setq CNew (* (distance P1New P2New) 0.5)))
		)
		(progn
			(setq CNew (* (distance P1New P2New) 0.5))
			(setq RadNew (RND_FIND_RADNEW Rad NumRoundOffLocal))
			(if (= RadNew 0.0)
				(setq RadNew NumZero)
			)
			(setq RadNew (RND_CHECK_RADNEW RadNew CNew NumRoundOffLocal))
		)
	)
	(setq DisDifMax (* NumRoundOffLocal 2.0))
	(setq Dir1TanNew (+ Dir1New PiHalf))
	(setq Dir2TanNew (+ Dir2New PiHalf))
	(setq CheckTan1 (RND_FIND_CHECKTAN_FROM_NODE_DIRTANNEW (list Node1 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL (+ Dir1 PiHalf))) ObjectLevel))
	(setq CheckTan2 (RND_FIND_CHECKTAN_FROM_NODE_DIRTANNEW (list Node2 (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL (+ Dir2 PiHalf))) ObjectLevel))

	(setq RadNewTemp RadNew)
	(setq P1NewTemp P1New)
	(setq P2NewTemp P2New)
	(setq NumError 0)
	(setq CheckRepeat T)
	(while CheckRepeat
		(setq CheckError
			(vl-catch-all-error-p (vl-catch-all-apply '(lambda ( / )
				(if (and (not CheckTan1) (not CheckTan2))
					(progn
						(setq PCNew (RND_FIND_POINT_CENTER_FROM_P1NEW_P2NEW_RADNEW P1New P2New RadNew PC))
						(setq CheckRepeat Nil)
					)
				)
				(if (and CheckTan1 (not CheckTan2))
					(progn
						(setq PTemp
							(RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2
								(polar P1New Dir1New RadNew)
								Dir1TanNew
								P2New
								Dir1New
							)
						)
						(setq ListPCNew
							(mapcar
								'(lambda
									(x) 
									(polar
										PTemp
										x
										(sqrt (- (expt RadNew 2.0) (expt (distance P2New PTemp) 2.0)))
									)
								)
								(list Dir1TanNew (+ Dir1TanNew pi))
							)
						)
						(setq Num (car (vl-sort-i (mapcar '(lambda (x) (distance x PC)) ListPCNew) '<)))
						(setq PCNew (nth Num ListPCNew))
						(setq P1New (polar PCNew (+ Dir1New pi) RadNew))

						(if (<= (distance P1NewTemp P1) DisDifMax)
							(progn
								(setq CheckRepeat Nil)
								(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node1 P1New)
							)
							(progn
								(setq CheckTan1 Nil)
								(setq P1New P1NewTemp)
								(setq RadNew RadNewTemp)
							)
						)
					)
				)
				(if (and (not CheckTan1) CheckTan2)
					(progn
						(setq PTemp
							(RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2
								(polar P2New Dir2New RadNew)
								Dir2TanNew
								P1New
								Dir2New
							)
						)
						(setq ListPCNew
							(mapcar
								'(lambda
									(x) 
									(polar
										PTemp
										x
										(sqrt (- (expt RadNew 2.0) (expt (distance P1New PTemp) 2.0)))
									)
								)
								(list Dir2TanNew (+ Dir2TanNew pi))
							)
						)
						(setq Num (car (vl-sort-i (mapcar '(lambda (x) (distance x PC)) ListPCNew) '<)))
						(setq PCNew (nth Num ListPCNew))
						(setq P2New (polar PCNew (+ Dir2New pi) RadNew))

						(if (<= (distance P2NewTemp P2) DisDifMax)
							(progn
								(setq CheckRepeat Nil)
								(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node2 P2New)
							)
							(progn
								(setq CheckTan2 Nil)
								(setq P2New P2NewTemp)
								(setq RadNew RadNewTemp)
							)
						)
					)
				)
				(if (and CheckTan1 CheckTan2)
					(progn
						(if (RND_CHECK_PI (- Dir1TanNew Dir2TanNew))
							(progn
								(setq PCNew (RND_FIND_MIDPOINT P1New P2New))
								(setq P1New
									(RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2
										PCNew
										Dir1New
										P1New
										Dir1TanNew
									)
								)
								(setq P2New
									(RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2
										PCNew
										Dir2New
										P2New
										Dir2TanNew
									)
								)
								(setq RadNew (distance PCNew P1New))
							)
							(progn
								(setq PCNew
									(RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2
										(polar P1New Dir1New RadNew)
										Dir1TanNew
										(polar P2New Dir2New RadNew)
										Dir2TanNew
									)
								)

								(setq P1New (polar PCNew (+ Dir1New pi) RadNew))
								(setq P2New (polar PCNew (+ Dir2New pi) RadNew))
							)
						)

						(if
							(and
								(<= (distance P1NewTemp P1) DisDifMax)
								(<= (distance P2NewTemp P2) DisDifMax)
							)
							(progn
								(setq CheckRepeat Nil)
								(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node1 P1New)
								(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node2 P2New)
							)
							(progn
								(setq CheckTan1 Nil)
								(setq CheckTan2 Nil)
								(setq P1New P1NewTemp)
								(setq P2New P2NewTemp)
								(setq RadNew RadNewTemp)
							)
						)
					)
				)
			)))
		)
		(if CheckError
			(progn
				(if (> NumError 2)
					(progn
						(setq CheckTan1 Nil)
						(setq CheckTan2 Nil)
						(setq RadNew RadNewTemp)
					)
					(setq RadNew (+ RadNewTemp (* NumRoundOffLocal NumError)))
				)
				(setq P1New P1NewTemp)
				(setq P2New P2NewTemp)
				(setq NumError (+ NumError 1))
			)
		)
	)
	(RND_ADD_LIST_PCNEW_NAMEVAR_PC PC PCNew)
	(RND_ADD_LIST_PCNEW_RADNEW_NAMEVAR_PC_RAD (list PC Rad) (list PCNew RadNew))
	(list P1New P2New PCNew RadNew)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINT_CENTER_FROM_P1NEW_P2NEW_RADNEW ( P1New P2New RadNew PC /
	DirNew
	CNew
	ListPCNew
	ListSign
	Num
	PCNew
	PMNew)

	(setq PMNew (RND_FIND_MIDPOINT P1New P2New))
	(setq DirNew (angle P1New P2New))
	(setq Temp (- (expt RadNew 2.0) (expt (distance PMNew P1New) 2.0)))
	(if (< Temp 0)
		(setq Temp (RND_ROUNDOFF_NUMBER Temp NumZero))
	)
	(setq CNew (expt Temp 0.5))
	(setq ListSign (list 1.0 -1.0))
	(setq ListPCNew (mapcar '(lambda (Sign) (polar PMNew (+ DirNew (* PiHalf Sign)) CNew)) ListSign))
	(setq Num (car (vl-sort-i (mapcar '(lambda (PCNew) (distance PCNew PC)) ListPCNew) '<)))
	(setq PCNew (nth Num ListPCNew))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINTNEW_FOR_OBJECT_DIRECTION ( P Dir NumRoundOff /
	DirNew
	Node
	NodeNew
	Point
	PointNewModel)

	(setq Node (RND_FIND_NODE_SUB P NumRoundOff))
	(setq NodeNew (RND_FIND_NODENEW_FROM_NODE Node))
	(if (not NodeNew)
		(progn
			(setq Point (RND_FIND_POINT_BLOCK_TO_MODEL P))
			(setq DirNew (RND_FIND_DIRLINNEW_BLOCK_TO_MODEL Dir))
			(setq PointNewModel (RND_ROUNDOFF_POINT_IN_VIRTUAL_COORDINATE_SYSTEM Point DirNew NumRoundOff))
			(setq NodeNew (RND_FIND_POINT_MODEL_TO_BLOCK PointNewModel))
			(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node NodeNew)
		)
	)
	NodeNew
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINTNEW_FOR_OBJECT_NON_DIRECTION ( P NumRoundOff /
	Node
	NodeNew
	Point
	PointNewModel)

	(if (not DirMain) (setq DirMain 0.0))
	(setq Node (RND_FIND_NODE_SUB P NumRoundOff))
	(setq NodeNew (RND_FIND_NODENEW_FROM_NODE Node))
	(if (not NodeNew)
		(progn
			(setq Point (RND_FIND_POINT_BLOCK_TO_MODEL P))
			(setq PointNewModel (RND_ROUNDOFF_POINT_IN_VIRTUAL_COORDINATE_SYSTEM Point DirMain NumRoundOff))
			(setq NodeNew (RND_FIND_POINT_MODEL_TO_BLOCK PointNewModel))
			(RND_ADD_LIST_NODENEW_NAMEVAR_NODE Node NodeNew)
		)
	)
	NodeNew
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_VARIANT_TO_LIST ( VariantPoint / )
	(vlax-safearray->list (vlax-variant-value VariantPoint))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NUMROUNDOFFLOCAL ( ListDirNew ListDisObj NumRoundOff /
	CheckRun
	DirNew
	DirNew1
	DirNew2
	DirNewMin
	DisObjMin
	DisObj
	ListDirNewTemp
	NumRoundOffLocal
	Temp)

	(setq DisObjMin (car ListDisObj))
	(foreach DisObj ListDisObj
		(if (> DisObjMin DisObj)
			(setq DisObjMin DisObj)
		)
	)

	(setq NumRoundOffLocal NumRoundOff)
	(if (and DisObjMin (/= DisObjMin 0.0))
		(progn
			(setq DirNewMin PiHalf)
			(setq ListDirNewTemp ListDirNew)
			(while (cdr ListDirNewTemp)
				(setq DirNew1 (car ListDirNewTemp))
				(setq ListDirNewTemp (cdr ListDirNewTemp))
				(foreach DirNew2 ListDirNewTemp
					(setq DirNew (abs (- DirNew1 DirNew2)))
					(if (>= DirNew pi)
						(setq DirNew (- DirNew pi))
					)
					(if (> DirNew PiHalf)
						(setq DirNew (- pi DirNew))
					)
					(setq DirNew (RND_ROUNDOFF_NUMBER DirNew NumZero))
					(if (and (/= DirNew 0.0) (> DirNewMin DirNew))
						(setq DirNewMin DirNew)
					)
				)
			)

			(setq Temp (/ (+ 1.0 (cos DirNewMin)) (sin DirNewMin)))
			(setq CheckRun T)
			(while CheckRun
				(if (> NumRoundOffLocal NumZero)
					(if
						(>= DisObjMin (* Temp NumRoundOffLocal))
						(setq CheckRun Nil)
					)
					(setq CheckRun Nil)
				)
				(if CheckRun (setq NumRoundOffLocal (/ NumRoundOffLocal NumRoundOffSubdiv)))
			)
		)
		(setq NumRoundOffLocal NumRoundOff)
	)
	NumRoundOffLocal
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_NODE_SUB ( P NumRoundOffLocal / )
	(RND_ROUNDOFF_POINT P NumRoundOffLocal)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_PBASE ( ListPoint DirNew NumRoundOff / Temp1 Temp2 Temp3 PBase)
	(setq Temp1 (mapcar '(lambda (x) (nth 0 x)) ListPoint))
	(setq Temp2 (mapcar '(lambda (x) (nth 1 x)) ListPoint))
	(setq Temp3 (mapcar '(lambda (x) (nth 2 x)) ListPoint))
	(setq PBase
		(RND_FIND_MIDPOINT
			(list
				(apply 'min Temp1)
				(apply 'min Temp2)
				(apply 'min Temp3)
			)
			(list
				(apply 'max Temp1)
				(apply 'max Temp2)
				(apply 'max Temp3)
			)
		)
	)
	(setq PBase (RND_ROUNDOFF_POINT_IN_VIRTUAL_COORDINATE_SYSTEM PBase DirNew NumRoundOff))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRLIN ( Dir / DirLin)
	(setq DirLin Dir)
	(while (< DirLin 0)
		(setq DirLin (+ DirLin pi))
	)
	(while (>= DirLin pi)
		(setq DirLin (- DirLin pi))
	)
	(if (>= DirLin PiNear)
		(setq DirLin (- DirLin pi))
	)
	DirLin
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRNEW ( Dir / )
	(RND_DEGREE_TO_RADIAN (RND_FIND_DIRDEGNEW Dir))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRDEGNEW ( Dir / )
	(RND_ROUNDOFF_NUMBER (RND_RADIAN_TO_DEGREE Dir) AngleDegRoundOff)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRLINNEW ( Dir / DirLinNew)
	(setq DirLinNew (RND_FIND_DIRNEW Dir))
	(while (< DirLinNew 0)
		(setq DirLinNew (+ DirLinNew pi))
	)
	(while (>= DirLinNew pi)
		(setq DirLinNew (- DirLinNew pi))
	)
	DirLinNew
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIR_BLOCK_TO_MODEL ( Dir / )
	(if (and CheckConvertBasePoint List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1)
		(setq Dir
			(angle
				Point0_Block_To_Model
				(RND_FIND_POINT_BLOCK_TO_MODEL (list (cos Dir) (sin Dir) 0.0))
			)
		)
	)
	Dir
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRLINNEW_BLOCK_TO_MODEL ( Dir / )
	(RND_FIND_DIRLINNEW (RND_FIND_DIR_BLOCK_TO_MODEL Dir))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_DIRNEW_EFFECTIVE ( Dir / DirNew)
	(if (and CheckConvertBasePoint List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1)
		(progn
			(setq DirNew (RND_FIND_DIRNEW (RND_FIND_DIR_BLOCK_TO_MODEL Dir)))
			(setq DirNew
				(angle
					Point0_Model_To_Block
					(RND_FIND_POINT_MODEL_TO_BLOCK (list (cos DirNew) (sin DirNew) 0.0))
				)
			)
		)
		(setq DirNew (RND_FIND_DIRNEW Dir))
	)
	DirNew
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINT_BLOCK_TO_MODEL ( Point / Dir1 MoveX1 MoveY1 ScaleX1 ScaleY1)
	(if CheckConvertBasePoint
		(if List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1
			(progn
				(foreach Temp List_MoveX1_MoveY1_Dir1_ScaleX1_ScaleY1
					(setq MoveX1	(nth 0 Temp))
					(setq MoveY1	(nth 1 Temp))
					(setq Dir1	(nth 2 Temp))
					(setq ScaleX1	(nth 3 Temp))
					(setq ScaleY1	(nth 4 Temp))
					(setq Point (RND_TRANSFORMATION_MOVE (RND_TRANSFORMATION_ROTATE (RND_TRANSFORMATION_SCALE Point ScaleX1 ScaleY1) Dir1) MoveX1 MoveY1))
				)
				(setq Point (mapcar '- Point PointOriginalMain))
			)
			(setq Point (mapcar '- Point PointOriginalMain))
		)
	)
	Point
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_POINT_MODEL_TO_BLOCK ( Point / Dir2 MoveX2 MoveY2 ScaleX2 ScaleY2)
	(if CheckConvertBasePoint
		(if List_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2
			(progn
				(setq Point (mapcar '+ Point PointOriginalMain))
				(foreach Temp List_MoveX2_MoveY2_Dir2_ScaleX2_ScaleY2
					(setq MoveX2	(nth 0 Temp))
					(setq MoveY2	(nth 1 Temp))
					(setq Dir2	(nth 2 Temp))
					(setq ScaleX2	(nth 3 Temp))
					(setq ScaleY2	(nth 4 Temp))
					(setq Point (RND_TRANSFORMATION_SCALE (RND_TRANSFORMATION_ROTATE (RND_TRANSFORMATION_MOVE Point MoveX2 MoveY2) Dir2) ScaleX2 ScaleY2))
				)
			)
			(setq Point (mapcar '+ Point PointOriginalMain))
		)
	)
	Point
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_REMOVE_DUPLICATE_IN_LISTDIRNEW ( ListDirNew / DirNew ListDirNewResult ListNameVarTemp NameVarTemp)
	(foreach DirNew ListDirNew
		(setq NameVarTemp (RND_CREATE_NAMEVAR_DIR "CheckDupDir" DirNew))
		(if (not (eval NameVarTemp))
			(progn
				(setq ListNameVarTemp (cons NameVarTemp ListNameVarTemp))
				(set NameVarTemp T)
				(setq ListDirNewResult (cons DirNew ListDirNewResult))
			)
		)
	)
	(mapcar '(lambda (x) (set x Nil)) ListNameVarTemp)
	(setq ListDirNewResult (reverse ListDirNewResult))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ROUNDOFF_POINT_IN_VIRTUAL_COORDINATE_SYSTEM ( Point Dir NumRoundOff / )
	(RND_TRANSFORMATION_ROTATE (RND_ROUNDOFF_POINT (RND_TRANSFORMATION_ROTATE Point (- Dir)) NumRoundOff) Dir)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_EQUAL_TWO_POINT ( P1 P2 / )
	(equal
		(RND_ROUNDOFF_POINT P1 NumZero)
		(RND_ROUNDOFF_POINT P2 NumZero)
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_PI ( Dir / )
	(= (RND_ROUNDOFF_NUMBER (sin Dir) NumZero) 0.0)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_PIHALF ( Dir / )
	(= (RND_ROUNDOFF_NUMBER (cos Dir) NumZero) 0.0)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ROUNDOFF_NUMBER ( Number NumRoundOff /
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
	(setq Temp1 (/ NumberActive NumRoundOff))
	(setq Temp2 (fix Temp1))
	(if (>= (abs (- Temp1 Temp2)) 0.4999999999999999)
		(setq ValueResult (* NumRoundOff (+ Temp2 1.0)))
		(setq ValueResult (* NumRoundOff (+ Temp2 0.0)))
	)
	(setq ValueResult (* NumSwitchPositveActive ValueResult))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_ROUNDOFF_POINT ( Point NumRoundOff / )
	(mapcar '(lambda (x) (RND_ROUNDOFF_NUMBER x NumRoundOff)) Point)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_RADIAN_TO_DEGREE ( Dir / )
	(/ (* Dir 180.0) pi)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_DEGREE_TO_RADIAN ( Dir / )
	(/ (* Dir pi) 180)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_MIDPOINT ( P1 P2 / )
	(mapcar '(lambda (x) (* x 0.5)) (mapcar '+ P1 P2))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_TRANSFORMATION_MOVE ( Point MoveX MoveY / )
	(list
		(+ (nth 0 Point) MoveX)
		(+ (nth 1 Point) MoveY)
		0.0
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_TRANSFORMATION_SCALE ( Point ScaleX ScaleY / )
	(list
		(* (nth 0 Point) ScaleX)
		(* (nth 1 Point) ScaleY)
		0.0
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_TRANSFORMATION_ROTATE ( Point Direction / )
	(list
		(+ (* (nth 0 Point) (cos Direction)) (* (nth 1 Point) (- (sin Direction))))
		(+ (* (nth 0 Point) (sin Direction)) (* (nth 1 Point) (cos Direction)))
		0.0
	)
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_FIND_INTERSECTION_FROM_P1_DIR1_P2_DIR2 ( P1 Dir1 P2 Dir2 /
	A1
	A2
	B1
	B2
	X1
	X2
	Y1
	Y2
	PointIntersection
	Temp1
	Temp2
	X
	Y)

	(setq X1 (nth 0 P1))
	(setq Y1 (nth 1 P1))
	(setq X2 (nth 0 P2))
	(setq Y2 (nth 1 P2))

	(if (setq Temp1 (= (RND_ROUNDOFF_NUMBER (cos Dir1) NumZero) 0.0))
		(progn
			(setq X X1)
			(setq A2 (/ (sin Dir2) (cos Dir2)))
			(setq B2 (- Y2 (* A2 X2)))
			(setq Y (+ (* A2 X) B2))
		)
	)
	(if (setq Temp2 (= (RND_ROUNDOFF_NUMBER (cos Dir2) NumZero) 0.0))
		(progn
			(setq X X2)
			(setq A1 (/ (sin Dir1) (cos Dir1)))
			(setq B1 (- Y1 (* A1 X1)))
			(setq Y (+ (* A1 X) B1))
		)
	)
	(if (not (or Temp1 Temp2))
		(progn
			(setq A1 (/ (sin Dir1) (cos Dir1)))
			(setq B1 (- Y1 (* A1 X1)))
			(setq A2 (/ (sin Dir2) (cos Dir2)))
			(setq B2 (- Y2 (* A2 X2)))
			(setq X (/ (- B2 B1) (- A1 A2)))
			(setq Y (+ (* A1 X) B1))
		)
	)
	(setq PointIntersection (list X Y 0.0))
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun RND_CHECK_STRING_IS_NUMBER ( String / )
	(if (and String (= (substr String 1 1) "."))
		(setq String (strcat "0" String))
	)
	(if (and String (numberp (read String)))
		(setq String (rtos (atof String) 2 LengthNumVariable))
		(setq String Nil)
	)
	String
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(setq PathNameBlockExclude
	(strcat
		(substr
			(getvar "ROAMABLEROOTPREFIX")
			1
			(+ 8 (vl-string-search "Autodesk" (getvar "ROAMABLEROOTPREFIX")))
		)
		"\\ApplicationPlugins\\Fix Imprecise 2D Drawing.bundle\\Contents\\Windows\\BlockExclude.rnd"
	)
)