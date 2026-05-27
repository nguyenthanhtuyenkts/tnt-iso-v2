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