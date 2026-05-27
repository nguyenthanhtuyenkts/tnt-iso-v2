;;; AUTOLISP TNT
;;; APPLOAD
;;; NO FIX
-------------------------------------------------------------------------------------------------------------------
;;; SETTING BAN DAU
;; 1. CAI CAC BIEN HE THONG 
;; HAM CON
(defun SETTING ( / )
    (ensure-navvcube-off)
    (set-if-needed "MODEMACRO" "010 Architect")    
    (set-if-needed "UCSICON" 0)
    (set-if-needed "MENUBAR" 1)                        	    ;HIEN THI MENUBAR
    (set-if-needed "cursorsize" 100)                        ;CHINH SIZE CON TRO CHUOT
    (set-if-needed "cursortype" 0)                          ;HIEN THI CHUOT HINH CHU THAP
    (set-if-needed "ISAVEBAK" 1)                            ;TAO FILE BACKUP KHI SAVE
    (set-if-needed "SAVETIME" 30)                           ;TU DONG SAVE FILE 30 PHUT
    (set-if-needed "INSUNITSDEFSOURCE" 4)                   ;SET MILIMETERS KHI CHEN KHOI
    (set-if-needed "INSUNITSDEFTARGET" 4)                   ;SET MILIMETERS KHI XUAT BAN VE
    (set-if-needed "TEXTALLCAPS" 1)                         ;TEXT LUON LUON CAPSLOCK    
    ;(set-if-needed "APERTURE" 15)                          ;DO RONG O VUONG BAT DIEM
    ;(set-if-needed "PICKBOX" 15)                           ;DO RONG O VUONG CHON DIEM
    ;(set-if-needed "GRIPSIZE" 15)                          ;DO RONG O VUONG CHUC NANG
    (set-if-needed "MIRRTEXT" 0)                            ;CHU KHONG BI LAT NGUOC KHI MIRROR
    (set-if-needed "MIRRHATCH" 0)                           ;HATCH KHONG BI LAT NGUOC KHI MIRROR
    (set-if-needed "OSMODE" 16383)                          ;BAT TAT CA BAT DIEM
    (set-if-needed "APERTURE" 10)                           ;KHOẢNG CÁCH HIỆN THỊ BẮT ĐIỂM    C
    (set-if-needed "PEDITACCEPT" 1)                         ;TẠO NHANH PLINE TỪ LINE KHÔNG HIỂN THỊ HỘP THOẠI COMMAND
    (set-if-needed "CANNOSCALE" "1:1")                      ;TY LE 1:1
    (set-if-needed "LTSCALE" 1)                             ;LTS = 1
    (set-if-needed "SELECTIONANNODISPLAY" 0)                ;TẮT HIỆN THỊ Annotative
    (set-if-needed "ANNOALLVISIBLE" 0)
    (set-if-needed "ANNOAUTOSCALE" 0)
    (set-if-needed "SELECTIONEFFECT" 1)                     ;CHỌN ĐỐI TƯỢNG KHÔNG BỊ DẠNG LƯỚI
    (set-if-needed "TRANSPARENCYDISPLAY" 0)                 ;LAYER KHÔNG BỊ MỜ
    (set-if-needed "SELECTIONPREVIEW" 0)                    ;TẮT HIGHT KHI DI CHUỘT VÀO ĐỐI TƯỢNG
    (set-if-needed "HIGHLIGHT" 1)                           ;BẬT HIGHT KHI CHỌN ĐỐI TƯỢNG
    (set-if-needed "COLORTHEME" 0)                          ;GIAO DIỆN TỐI
    (set-if-needed "FILEDIA" 1)                             ;HIỆN THỊ HỘP THOẠI TRÊN FILE MENU SAVE OPEN
    (set-if-needed "STATUSBAR" 1)                           ;HIỆN THỊ THANH CÔNG CỤ BÊN DƯỚI GÓC PHẢI 
    ;(set-if-needed "LAYOUTTAB" 1)                           ;HIỆN THỊ THANH TAB LAYOUT
    (set-if-needed "STARTMODE" 0)                           ;TẮT HIỆN THỊ THANH START BAN ĐẦU
    (set-if-needed "SNAPMODE" 0)                            ;TẮT BẮT ĐIỂM GRID
    (set-if-needed "GRIDMODE" 0)                            ;TẮT BẮT ĐIỂM GRID
    (set-if-needed "DIMLAYER" "...11_TNT_LINE_DIMENSION")   ;LAYER "DIMENTION"
    (set-if-needed "HPLAYER" "...10_TNT_LINE_HATCH")        ;LAYER "HATCH"
    (set-if-needed "TEXTLAYER" "...9_TNT_LINE_TEXT")        ;LAYER "TEXT"
    (princ "\nĐã hoàn tất thiết lập hệ thống (chỉ thay đổi nếu cần).")
    (princ)
)
-------------------------------------------------------------------------------------------------------------------
;; HAM CON
(defun set-if-needed (var val / oldval)
  (setq oldval (getvar var))
  (if (not (equal oldval val))
    (progn
      (setvar var val)
      (princ (strcat "\n[INFO] Đã đổi biến " var " từ " (vl-princ-to-string oldval) " → " (vl-princ-to-string val)))
    )
  )
)
-------------------------------------------------------------------------------------------------------------------
;; HAM CON
(defun ensure-navvcube-off ( / space old)
  (setq space (getvar "TILEMODE")) ; 1 = Model Space
  (if (= space 1)
    (progn
      (setq old (getvar "CMDECHO"))
      (setvar "CMDECHO" 0)
      (command "_.NAVVCUBE" "_Off")
      (setvar "CMDECHO" old)
      (princ "\n[INFO] Đã gọi lệnh NAVVCUBE OFF.")
    )
    (princ "\n[INFO] Bỏ qua NAVVCUBE vì đang ở Layout.")
  )
)
-------------------------------------------------------------------------------------------------------------------
;;;KEY
  (vl-load-com)
    (defun getHDDInfo ()
      (setq SerialList nil)   
      (defun getHDD (Serial)
        (if Serial (setq SerialList (cons (vl-string-trim " " Serial) SerialList)))
      )

      (defun main ()
        (setq where (vlax-create-object "WbemScripting.SWbemLocator"))
        (setq Dowhat
              (vlax-invoke where 'ConnectServer nil nil nil nil nil nil nil nil)
        )
        (setq SerialObject (vlax-invoke Dowhat 'ExecQuery "Select * from Win32_PhysicalMedia"))
        (vlax-for Obj SerialObject
          (getHDD (vlax-get Obj 'SerialNumber))
        )  
      )
      (main)
    )
-------------------------------------------------------------------------------------------------------------------
  ;; MAIN
    (defun c:TNT_SYSTEM ()
      (getHDDInfo)
      (setq list1 '(
                    "C3GEF7R9GT0M730N8C18"
                    "W9AKB81V" 
                    "Z9AWLK2E"                             
                    )
      )
      (foreach item list1
        (if (member item SerialList)
          (progn
            (setq found T)      s
          )
        )
      )
      (if found
        (SETTING)
      )
      (princ)
    )
-------------------------------------------------------------------------------------------------------------------