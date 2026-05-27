;;;***[AUTOLISP - AUTO RESET OSNAP]***
(Defun resetosmode (v1 v2 /)
(if (/= (getvar "osmode") 16383) (setvar "osmode" 16383))
(Princ))
(vlr-editor-reactor  nil
'((:vlr-lispEnded . ResetOsmode)
(:vlr-lispCancelled . ResetOsmode))
)
