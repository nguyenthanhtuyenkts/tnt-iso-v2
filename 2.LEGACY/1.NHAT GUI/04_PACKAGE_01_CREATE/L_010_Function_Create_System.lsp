;;; ====================================================================================================
;;; ----------------------------------- L_010_FUNCTION_CREATE_SYSTEM -----------------------------------
;;; ====================================================================================================
;;; * FILE      : L_010_FUNCTION_CREATE_SYSTEM
;;; * PURPOSE : 
;;;   - 
;;;   - 
;;; * QUY ƯỚC ĐẶT TÊN:
;;;   - HÀM/MÔ-ĐUN                             :  A:B:C
;;;   - BIẾN TOÀN CỤC (CÓ CHỦ ĐÍCH)            :  *A.B.C*
;;;   - THAM SỐ HÀM (TIỀN TỐ P)                :  P*
;;;   - BIẾN CỤC BỘ (TIỀN TỐ L, KHAI BÁO SAU /):  / L*
;;;   - COMMAND (BẮT ĐẦU BẰNG C:)              :  C:A_B_C
;;; * LƯU Ý:
;;; ====================================================================================================
;;; [0] APPLICATION / SIGNATURE
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
;;; ====================================================================================================
;;; [2] HÀM TẠO SYSTEM
;;; ====================================================================================================
(defun 010_SYSTEM_CREATE ()
  (010:SYS:RUN-SAFE (function 010:SYSTEM:CREATE_VARIABLES))
  (princ)
)
;;; ====================================================================================================
;;; [3] SETTING SYSTEM VARIABLES
;;; ====================================================================================================
(defun 010:SYSTEM:CREATE_VARIABLES (/)
  ;1 GROUP INTERFACE
    (010:SYSTEM_SETTING "MODEMACRO" "010.α")
    (010:SYSTEM_SETTING "MENUBAR" 1)                        	   ;HIEN THI MENUBAR
    (010:SYSTEM_SETTING "COLORTHEME" 0)                          ;GIAO DIỆN TỐI
    (010:SYSTEM_SETTING "STATUSBAR" 1)                           ;HIỆN THỊ THANH CÔNG CỤ BÊN DƯỚI GÓC PHẢI
    (010:SYSTEM_SETTING "LAYOUTTAB" 1)                           ;HIỆN THỊ THANH TAB LAYOUT
    (010:SYSTEM_SETTING "STARTMODE" 0)                           ;TẮT HIỆN THỊ THANH START BAN ĐẦU
    (010:SYSTEM_SETTING "CURSORSIZE" 100)                        ;TĂNG KÍCH THƯỚC CROSSHAIR CON TRO CHUOT
    (010:SYSTEM_SETTING "CURSORTYPE" 0)                          ;HIEN THI CHUOT HINH CHU THAP
    ;(010:SYSTEM_SETTING "APERTURE" 15)                          ;DO RONG O VUONG BAT DIEM
    ;(010:SYSTEM_SETTING "PICKBOX" 15)                           ;DO RONG O VUONG CHON DIEM
    ;(010:SYSTEM_SETTING "GRIPSIZE" 15)                          ;DO RONG O VUONG CHUC NANG
  ;2 GROUP LAYER & LINETYPE
    (010:SYSTEM_SETTING "DIMLAYER" "...11_TNT_LINE_DIMENSION")   ;LAYER "DIMENTION"
    (010:SYSTEM_SETTING "HPLAYER" "...10_TNT_LINE_HATCH")        ;LAYER "HATCH"
    (010:SYSTEM_SETTING "TEXTLAYER" "...9_TNT_LINE_TEXT")        ;LAYER "TEXT"
    (010:SYSTEM_SETTING "LTSCALE" 1)                             ;TỶ LỆ NÉT VẼ THỐNG NHẤT
    (010:SYSTEM_SETTING "CELTYPE" "CONTINUOUS")                  ;KIỂU NÉT MẶC ĐỊNH KHI VẼ MỚI  
  ;3 GROUP TEXT & DIMSTYLE
    (010:SYSTEM_SETTING "TEXTALLCAPS" 1)                         ;TEXT LUON LUON CAPSLOCK  
  ;4 GROUP LEADER & HATCH    
  ;5 GROUP ANNOTATION % PROPORTION
    (010:SYSTEM_SETTING "CANNOSCALE" "1:1")                      ;TỶ LỆ HIỆN HÀNH CỦA ANNOTATIVE SCALE
    (010:SYSTEM_SETTING "SELECTIONANNODISPLAY" 0)                ;TẮT HIỆN THỊ ANNOTATIVE
    (010:SYSTEM_SETTING "ANNOALLVISIBLE" 0)                      ;CHỈ HIỆN THỊ ANNOTATIVE PHÙ HỢP
    (010:SYSTEM_SETTING "ANNOAUTOSCALE" 0)                       ;KHÔNG TỰ THÊM SCALE KHI CHỈNH VIEWPORT
  ;6 GROUP VIEWPORT & SPACE
    (010:SYSTEM_SETTING "MIRRTEXT" 0)                            ;CHU KHONG BI LAT NGUOC KHI MIRROR
    (010:SYSTEM_SETTING "MIRRHATCH" 0)                           ;HATCH KHONG BI LAT NGUOC KHI MIRROR
    (010:SYSTEM_SETTING "UCSICON" 0)                             ;TẮT BIỂU TƯỢNG TRỤC TOẠ ĐỘ
  ;7 GROUP BLOCK & XREF
    (010:SYSTEM_SETTING "INSUNITS" 4)                            ;SET MILIMETERS KHI CHEN KHOI
    (010:SYSTEM_SETTING "INSUNITSDEFSOURCE" 4)                   ;SET MILIMETERS KHI CHEN KHOI
    (010:SYSTEM_SETTING "INSUNITSDEFTARGET" 4)                   ;SET MILIMETERS KHI XUAT BAN VE
    (010:SYSTEM_SETTING "ATTDIA" 1)                              ;INSERT CÓ HỘP THOẠI NHẬP THUỘC TÍNH
    (010:SYSTEM_SETTING "ATTREQ" 1)                              ;BẬT LỜI NHẮC HOẶC HỘP THOẠI CHO CÁC GIÁ TRỊ THUỘC TÍNH, THEO CHỈ ĐỊNH CỦA ATTDIA
  ;8 GROUP PRINTING
    (010:SYSTEM_SETTING "FILEDIA" 1)                             ;HIỆN THỊ HỘP THOẠI TRÊN FILE MENU SAVE OPEN
  ;9 GROUP SAVE & SYSTEM
    (010:SYSTEM_SETTING "ISAVEBAK" 1)                            ;TAO FILE BACKUP KHI SAVE
    (010:SYSTEM_SETTING "SAVETIME" 30)                           ;TU DONG SAVE FILE 30 PHUT
  ;10 SELECT & DISPLAY
    (010:SYSTEM:ENSURE_NAVVCUBE_OFF)
    (010:SYSTEM_SETTING "SELECTIONEFFECT" 1)                     ;CHỌN ĐỐI TƯỢNG KHÔNG BỊ DẠNG LƯỚI
    (010:SYSTEM_SETTING "TRANSPARENCYDISPLAY" 0)                 ;LAYER KHÔNG BỊ MỜ
    (010:SYSTEM_SETTING "SELECTIONPREVIEW" 0)                    ;TẮT HIGHT KHI DI CHUỘT VÀO ĐỐI TƯỢNG
    (010:SYSTEM_SETTING "HIGHLIGHT" 1)                           ;BẬT HIGHT KHI CHỌN ĐỐI TƯỢNG
  ;11 DRAW
    (010:SYSTEM_SETTING "SNAPMODE" 0)                            ;TẮT BẮT ĐIỂM GRID
    (010:SYSTEM_SETTING "GRIDMODE" 0)                            ;TẮT BẮT ĐIỂM GRID 
    (010:SYSTEM_SETTING "OSMODE" 16383)                          ;BAT TAT CA BAT DIEM
    (010:SYSTEM_SETTING "APERTURE" 20)                           ;KHOẢNG CÁCH HIỆN THỊ BẮT ĐIỂM
    (010:SYSTEM_SETTING "PEDITACCEPT" 1)                         ;TẠO NHANH PLINE TỪ LINE KHÔNG HIỂN THỊ HỘP THOẠI COMMAND
    (princ)
)
;;; ====================================================================================================
;;; [4] FUNCTION SYSTEM VARIABLES
;;; ====================================================================================================
(defun 010:SYSTEM_SETTING ( PVAR PVAL / LOLDVAL)
  (setq LOLDVAL (getvar PVAR))
  (if (not (equal LOLDVAL PVAL))
    (progn
      (setvar PVAR PVAL)
      (princ (strcat "\n[010] DONE: CHANGE SYSTEM VARIABLE " PVAR " FROM " (vl-princ-to-string LOLDVAL) " → " (vl-princ-to-string PVAL)))
    )
  )
)

(defun 010:SYSTEM:ENSURE_NAVVCUBE_OFF ( / LSPACE LOLD)
  (setq LSPACE (getvar "TILEMODE"))
  (if (= LSPACE 1)
    (progn
      (setq LOLD (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.NAVVCUBE" "_Off")
      (setvar "CMDECHO" LOLD)
      (princ "\n[010] DONE: CHANGE SYSTEM NAVVCUBE OFF.")
    )
    (princ "\n[010] DONE: CANCEL CHANGE SYSTEM NAVVCUBE LAYOUT.")
  )
)