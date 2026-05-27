;;;BLOCK LAYER 0
  (defun c:B0 (/ *error* adoc lst_layer func_restore-layers  fun_get-block-subref-by-block selset)
  (setvar "MODEMACRO" "010.α")
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