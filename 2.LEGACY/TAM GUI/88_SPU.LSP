(defun c:SPU (/ file path pathfile *error* oldecho olddia)
 (vl-load-com)
 (defun *error* (msg)   ;This defines the error function so that if something goes wrong, it exits quietly and resets the variables
   (if oldecho
     (setvar 'cmdecho oldecho)
   )
   (if olddia
     (setvar 'CMDDIA olddia)
   )
   (if (not
  (member msg '("Function cancelled" "quit / exit abort"))
)
     (princ (strcat "\nError: " msg))
   )
   (princ)
 )
 (setq oldecho (getvar 'CMDECHO)) ;I am setting the variable oldecho equal to the variable cmdecho
 (setvar "CMDECHO" 0)
 (setq olddia (getvar 'CMDDIA))
 (setvar "CMDDIA" 0)
 (cond
   ((or (= (getvar 'writestat) 0) ;If the drawing is read only or hasn't ever been saved ie Drawing1, then it won't run 
 (= (getvar 'DWGTITLED) 0)
    )
    (alert
      "\n Superpurge cannot be used in files that haven't been named or are read only."
    )
   )
   (t     ;This is the "else" portion of the cond statement
    (setq file (getvar "DWGNAME")) ;This gets the drawing name
    (setq path (getvar "DWGPREFIX")) ;This gets the drawing's path
    (setq pathfile (strcat path file)) ;This combines the two variables into one
    (repeat 3
      (vl-cmdf "._AECCPURGESTYLES")
      (while (eq (logand (getvar "cmdactive") 1) 1)
 (command "_Y")
      )
    )
    (command "._PURGE" "_A" "*" "_N")
    (command "._PURGE" "_R" "*" "_N")
    (command-s "-WBLOCK" pathfile "_Y" "*" "_Y")
    ;Here I am running wblock and saving over the current drawing
    (princ "\nYour drawing is now squeaky clean")
   )
 )
 (setvar "CMDECHO" oldecho)  ;Resetting the variable cmdecho to its original value
 (setvar "CMDDIA" olddia)
 (princ)    ;Exit quietly
)