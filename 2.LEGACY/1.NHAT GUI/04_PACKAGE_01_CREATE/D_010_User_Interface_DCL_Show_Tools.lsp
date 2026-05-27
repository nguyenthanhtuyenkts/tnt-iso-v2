;;; ====================================================================================================
;;; -------------------------------- D_010_USER_INTERFACE_DCL_SHOW_TOOLS -------------------------------
;;; ====================================================================================================
;;; * FILE    : D_010_USER_INTERFACE_DCL_SHOW_TOOLS
;;; * PURPOSE : Gọi/Action hộp thoại:
;;;   - CREATE  : dialog
;;;   - ABOUT   : dialog
;;;   - HELP    : dialog
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; [1] HÀM GỌI HỘP THOẠI TOOLS
;;; ====================================================================================================
(defun 010:DCL:SHOW:TOOLS ( / TOOLSDCL TOOLSDCLID TOOLSACTION )
  (setq TOOLSDCL (010:DCL:MAKE:TOOLS))
  (setq TOOLSDCLID (load_dialog TOOLSDCL))  
  (if (new_dialog "TOOLS" TOOLSDCLID)
    (progn
      (010:DCL:SET_TILE_OF_SEP "sep0")
      (action_tile "Tile_Apcept"        "(done_dialog 0)")
      (action_tile "Tile_Create"        "(done_dialog 1)")
      (action_tile "Tile_Details"       "(done_dialog 2)")
      
      (action_tile "Layer"        "(done_dialog 3)")
      (action_tile "Textstyle"    "(done_dialog 4)")
      (action_tile "Dimension"    "(done_dialog 5)")
      (action_tile "System"       "(done_dialog 6)")
      (action_tile "Block"        "(done_dialog 7)")
      (action_tile "Shortcut"     "(done_dialog 8)")
      
      (setq TOOLSACTION (start_dialog))
      (unload_dialog TOOLSDCLID)
      (cond
        
      ((= TOOLSACTION 1)  (010:DCL:SHOW:CREATE))
	    ((= TOOLSACTION 2)  (010:DCL:SHOW:TOOLS))
      ((= TOOLSACTION 3)  (010_LAYER_CREATE)       (010:DCL:SHOW:CREATE)	(prompt "\n[010] DONE: CREATE 010_ISO_LAYER."))
      ((= TOOLSACTION 4)  (010_TEXTSTYLE_CREATE)   (010:DCL:SHOW:CREATE)	(prompt "\n[010] DONE: CREATE 010_ISO_TEXTSTYLE."))
      ((= TOOLSACTION 5)  (010_DIMENSION_CREATE)   (010:DCL:SHOW:CREATE)	(prompt "\n[010] DONE: CREATE 010_ISO_DIMENSION."))
      ((= TOOLSACTION 6)  (010_SYSTEM_CREATE)      (010:DCL:SHOW:CREATE)	(prompt "\n[010] DONE: CREATE 010_ISO_SYSTEM."))
      ((= TOOLSACTION 7)  (010_BLOCK_CREATE)       (010:DCL:SHOW:CREATE)	(prompt "\n[010] DONE: CREATE 010_ISO_BLOCK."))
      ((= TOOLSACTION 8)  (010_SHORTCUT_CREATE)    (010:DCL:SHOW:CREATE)	(prompt "\n[010] DONE: CREATE 010_ISO_SHORTCUT."))
      )
    )
  )
  (vl-file-delete TOOLSDCL)
  (princ)
)
;;; ====================================================================================================
;;; [2] HÀM GỌI HỘP THOẠI ABOUT
;;; ====================================================================================================
(defun 010:DCL:SHOW:ABOUT ( / DCLABOUT ABOUTDCLID ACTION_1 )
  (setq DCLABOUT (010:DCL:MAKE:CREATE))
  (setq ABOUTDCLID (load_dialog DCLABOUT))  
  (if (new_dialog "ABOUT" ABOUTDCLID)
    (progn
      (010:DCL:SET_TILE_OF_SEP "sep1")
      (010:DCL:SET_TILE_OF_SEP "sep2")
      (action_tile	"Tile_OK"	"(done_dialog 0)")
      (setq ACTION_1 (start_dialog))
      (cond
      ((= ACTION_1 0)	(010:DCL:SHOW:CREATE))      
      )
      (start_dialog)
      (unload_dialog ABOUTDCLID)
    )
  )
  (vl-file-delete DCLABOUT)
  (princ)
)
;;; ====================================================================================================
;;; [3] HÀM GỌI HỘP THOẠI HELP
;;; ====================================================================================================
(defun 010:DCL:SHOW:HELP ( / DCLHELP HELPDCLID ACTION_2 )
  (setq DCLHELP (010:DCL:MAKE:CREATE))
  (setq HELPDCLID (load_dialog DCLHELP))  
  (if (new_dialog "HELP" HELPDCLID)
    (progn
      (010:DCL:SET_TILE_OF_SEP "sep0")      
      (action_tile	"Tile_OK"	"(done_dialog 1)")
      (setq ACTION_2 (start_dialog))
      (cond
      ((= ACTION_2 1)	(010:DCL:SHOW:CREATE))      
      )
      (start_dialog)
      (unload_dialog HELPDCLID)
    )
  )
  (vl-file-delete DCLHELP)
  (princ)
)