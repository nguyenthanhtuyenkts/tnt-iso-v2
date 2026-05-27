;;; ====================================================================================================
;;; -------------------------------------- A_010_SYSTEM_PACKAGE_6 --------------------------------------
;;; ====================================================================================================
(vl-load-com)
(setvar "MODEMACRO" "010.α")
(setq *010.PKG3.VERBOSE* 1) ; 0: im lặng | 1: ghi thông tin

;;; ------------------------------------ [0] LOG -------------------------------------------------------
(defun 010:PKG6:LOG  (S /) (if (= (type S) 'STR) (princ (strcat "\n[010-PKG6] " S))) (princ))
(defun 010:PKG3:INFO (S /) (if (and (boundp '*010.PKG3.VERBOSE*) (= *010.PKG3.VERBOSE* 1)) (010:PKG6:LOG S)) (princ))
(defun 010:PKG3:ERR  (S /) (010:PKG6:LOG S) (princ))
(defun 010:PKG3:STR? (S) (= (type S) 'STR))

;;; ------------------------------------ [1] PATH/EXT --------------------------------------------------
(defun 010:PKG3:EXT (PF / E)
  (if (010:PKG3:STR? PF)
    (progn (setq E (strcase (vl-filename-extension PF)))
           (cond ((= E ".LSP") 'LSP) ((= E ".FAS") 'FAS) ((= E ".VLX") 'VLX)
                 ((= E ".ARX") 'ARX) ((= E ".DBX") 'DBX) ((= E ".DLL") 'DLL) (T nil)))
    nil))

(defun 010:PKG3:JOIN (BASE REL /)
  (if (and (010:PKG3:STR? BASE) (010:PKG3:STR? REL))
    (if (wcmatch REL "*:\\*") REL
      (vl-string-right-trim "\\" (strcat (vl-string-right-trim "\\" BASE) "\\" REL)))
    nil))

(defun 010:PKG3:SELF-DIR ( / ME )
  (cond
    ((and (boundp '*010.CURRENT.PACKAGE.DIR*)
          (= (type *010.CURRENT.PACKAGE.DIR*) 'STR)
          (vl-file-directory-p *010.CURRENT.PACKAGE.DIR*))
     *010.CURRENT.PACKAGE.DIR*)
    (T (setq ME (vl-filename-directory (findfile "A_010_System_Package_6.lsp")))
       (if (and ME (vl-file-directory-p ME)) ME nil))))

;;; ------------------------------------ [3] LOADERS ---------------------------------------------------
(defun 010:PKG3:LOAD-TEXT (PF / ERR)
  (cond
    ((not (findfile PF)) (010:PKG3:ERR (strcat "MISSING: " PF)))
    (T
      (setq ERR
        (010:SYS:RUN-SAFE
          (function (lambda (/)
            (vl-catch-all-apply 'load (list PF))
          )))
      )
      (if (vl-catch-all-error-p ERR)
        (010:PKG3:ERR (strcat "LOAD ERROR: " PF " -> " (vl-catch-all-error-message ERR)))
        (010:PKG3:INFO (strcat "LOADED (.lsp/.fas/.vlx): " PF)))
    ))
  (princ))


(defun 010:PKG3:TRY-ARXLOAD (PF / ERR)
  (setq ERR (vl-catch-all-apply 'arxload (list PF)))
  (if (vl-catch-all-error-p ERR)
    nil
    (progn
      (010:PKG3:INFO (strcat "LOADED (.dll/.arx/.dbx via ARXLOAD): " PF))
      T
    )
  )
)


(defun 010:PKG3:LOAD-DLL-NET (PF / ERR)
  ;; NETLOAD im lặng, có bắt lỗi; thành công -> return T, thất bại -> return nil
  (setq ERR
    (010:SYS:RUN-SAFE
      (function (lambda (/)
        (vl-catch-all-apply 'vl-cmdf (list "_.NETLOAD" (vl-string-translate "/" "\\" PF)))
      )))
  )
  (if (vl-catch-all-error-p ERR)
    (progn
      (010:PKG3:ERR (strcat "NETLOAD ERROR: " PF " -> " (vl-catch-all-error-message ERR)))
      nil
    )
    (progn
      (010:PKG3:INFO (strcat "LOADED (.dll via NETLOAD): " PF))
      T
    )
  )
)


(defun 010:PKG3:LOAD-ONE (PF / TYP)
  (setq TYP (010:PKG3:EXT PF))
  (cond
    ((member TYP '(LSP FAS VLX)) (010:PKG3:LOAD-TEXT PF))
    ((member TYP '(ARX DBX))     (if (not (010:PKG3:TRY-ARXLOAD PF))
                                    (010:PKG3:ERR (strcat "ARXLOAD failed: " PF))
                                    (010:PKG3:INFO (strcat "LOADED (ARX/DBX): " PF))))
    ((= TYP 'DLL)
      (cond
        ((010:PKG3:TRY-ARXLOAD PF) ; DLL kiểu ARX
          nil)                     ; đã in LOADED ở TRY-ARXLOAD nếu VERBOSE=1
        ((010:PKG3:LOAD-DLL-NET PF)
          nil)                     ; NETLOAD thành công -> đã in LOADED nếu VERBOSE=1
        (T
          nil))                    ; thất bại đã có ERR ở các hàm con
    )
    (T (010:PKG3:INFO (strcat "SKIP (unknown ext): " (vl-princ-to-string PF)))))
  (princ))

;;; ------------------------------------ [4] FILE LIST -------------------------------------------------
(defun 010:PKG3:FILES () 
  '(
  "B_010_Text_Copy.lsp"
  "D_010_Text_Mask.lsp"  
  )
)
;;; ------------------------------------ [5] LOAD CHILDREN --------------------------------------------
(defun 010:PKG3:LOAD-CHILDREN ( / DIR RAW IT FP ERR )
  (setq DIR (010:PKG3:SELF-DIR))
  (if (not DIR)
    (010:PKG3:ERR "PACKAGE-DIR not found.")
    (progn
      (setq RAW (010:PKG3:FILES))
      (if (/= (type RAW) 'LIST)
        (010:PKG3:ERR "FILE LIST invalid.")
        (progn
          (setq ERR
            (vl-catch-all-apply
              (function (lambda (/)
                (foreach IT RAW
                  (if (010:PKG3:STR? IT)
                    (progn (setq FP (010:PKG3:JOIN DIR IT))
                           (if FP (010:PKG3:LOAD-ONE FP))))))) '()))
          (if (vl-catch-all-error-p ERR)
            (010:PKG3:ERR (strcat "PKG LOOP ERROR: " (vl-catch-all-error-message ERR))))))))
  (princ))

;;; ------------------------------------ [6] AUTORUN ---------------------------------------------------
(010:PKG3:LOAD-CHILDREN)
(princ)
