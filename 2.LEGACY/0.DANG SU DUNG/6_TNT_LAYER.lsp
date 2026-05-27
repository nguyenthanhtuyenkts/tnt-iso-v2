;;; PHAN LAYER
  ;; 1.PHIM TAT LAYER    
  ;; 2.TAO LAYER    
    (setvar "MODEMACRO" "TNT Architecture")  
    TAOLAYER
    (defun c:TAOLAYER ()
      (setvar "CMDECHO" 0)
      (TAOLAYER)
      (setvar "CMDECHO" 1)
    (princ))
    (defun TAOLAYER ()
      (command "UNDO" "BE")
      (setvar "CMDECHO" 0)
            (if (not (tblsearch "LAYER" "...0_TNT_LINE_NAME" ))
            (command "-LAYER" "N" "...0_TNT_LINE_NAME"
                              "C" "7" "...0_TNT_LINE_NAME" 
                              "L" "CONTINUOUS" "...0_TNT_LINE_NAME" 
                              "LW" "0" "...0_TNT_LINE_NAME"
                              "TR" "0" "...0_TNT_LINE_NAME"
                              "P" "P" "...0_TNT_LINE_NAME"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...1_TNT_LINE_CONCRETE" ))
            (command "-LAYER" "N" "...1_TNT_LINE_CONCRETE"
                              "C" "7" "...1_TNT_LINE_CONCRETE" 
                              "L" "CONTINUOUS" "...1_TNT_LINE_CONCRETE" 
                              "LW" "0" "...1_TNT_LINE_CONCRETE"
                              "TR" "50" "...1_TNT_LINE_CONCRETE"
                              "P" "P" "...1_TNT_LINE_CONCRETE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...2_TNT_LINE_WALL" ))
            (command "-LAYER" "N" "...2_TNT_LINE_WALL" 
                              "C" "41" "...2_TNT_LINE_WALL" 
                              "L" "CONTINUOUS" "...2_TNT_LINE_WALL" 
                              "LW" "0" "...2_TNT_LINE_WALL"
                              "TR" "50" "...2_TNT_LINE_WALL"
                              "P" "P" "...2_TNT_LINE_WALL"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...3_TNT_LINE_SECTION" ))
            (command "-LAYER" "N" "...3_TNT_LINE_SECTION" 
                              "C" "30" "...3_TNT_LINE_SECTION" 
                              "L" "CONTINUOUS" "...3_TNT_LINE_SECTION" 
                              "LW" "0" "...3_TNT_LINE_SECTION"
                              "TR" "50" "...3_TNT_LINE_SECTION"
                              "P" "P" "...3_TNT_LINE_SECTION"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...4_TNT_LINE_VIRTURAL" ))
            (command "-LAYER" "N" "...4_TNT_LINE_VIRTURAL" 
                              "C" "9" "...4_TNT_LINE_VIRTURAL" 
                              "L" "CONTINUOUS" "...4_TNT_LINE_VIRTURAL" 
                              "LW" "0" "...4_TNT_LINE_VIRTURAL"
                              "TR" "50" "...4_TNT_LINE_VIRTURAL"
                              "P" "P" "...4_TNT_LINE_VIRTURAL"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...5_TNT_LINE_THIN" ))
            (command "-LAYER" "n" "...5_TNT_LINE_THIN" 
                              "c" "251" "...5_TNT_LINE_THIN" 
                              "L" "CONTINUOUS" "...5_TNT_LINE_THIN" 
                              "LW" "0" "...5_TNT_LINE_THIN"
                              "TR" "50" "...5_TNT_LINE_THIN"
                              "P" "P" "...5_TNT_LINE_THIN"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...6_TNT_LINE_HIDDEN" ))
            (command "-LAYER" "n" "...6_TNT_LINE_HIDDEN" 
                              "c" "251" "...6_TNT_LINE_HIDDEN" 
                              "L" "HIDDEN" "...6_TNT_LINE_HIDDEN" 
                              "LW" "0" "...6_TNT_LINE_HIDDEN"
                              "TR" "50" "...6_TNT_LINE_HIDDEN"
                              "P" "P" "...6_TNT_LINE_HIDDEN"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...7_TNT_LINE_BASE" ))
            (command "-LAYER" "n" "...7_TNT_LINE_BASE" 
                              "c" "177" "...7_TNT_LINE_BASE" 
                              "L" "CENTER" "...7_TNT_LINE_BASE" 
                              "LW" "0" "...7_TNT_LINE_BASE"
                              "TR" "50" "...7_TNT_LINE_BASE"
                              "P" "P" "...7_TNT_LINE_BASE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...8_TNT_LINE_FUNITURE" ))
            (command "-LAYER" "n" "...8_TNT_LINE_FUNITURE" 
                              "c" "27" "...8_TNT_LINE_FUNITURE" 
                              "L" "CONTINUOUS" "...8_TNT_LINE_FUNITURE" 
                              "LW" "0" "...8_TNT_LINE_FUNITURE"
                              "TR" "50" "...8_TNT_LINE_FUNITURE"
                              "P" "P" "...8_TNT_LINE_FUNITURE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...9_TNT_LINE_TEXT" ))
            (command "-LAYER" "n" "...9_TNT_LINE_TEXT" 
                              "c" "9" "...9_TNT_LINE_TEXT" 
                              "L" "CONTINUOUS" "...9_TNT_LINE_TEXT" 
                              "LW" "0" "...9_TNT_LINE_TEXT"
                              "TR" "50" "...9_TNT_LINE_TEXT"
                              "P" "P" "...9_TNT_LINE_TEXT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...10_TNT_LINE_HATCH" ))
            (command "-LAYER" "n" "...10_TNT_LINE_HATCH" 
                              "c" "250" "...10_TNT_LINE_HATCH" 
                              "L" "CONTINUOUS" "...10_TNT_LINE_HATCH" 
                              "LW" "0" "...10_TNT_LINE_HATCH"
                              "TR" "50" "...10_TNT_LINE_HATCH"
                              "P" "P" "...10_TNT_LINE_HATCH"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...11_TNT_LINE_DIMENSION" ))
            (command "-LAYER" "n" "...11_TNT_LINE_DIMENSION" 
                              "c" "251" "...11_TNT_LINE_DIMENSION" 
                              "L" "CONTINUOUS" "...11_TNT_LINE_DIMENSION" 
                              "LW" "0" "...11_TNT_LINE_DIMENSION"
                              "TR" "50" "...11_TNT_LINE_DIMENSION"
                              "P" "P" "...11_TNT_LINE_DIMENSION"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...12_TNT_LINE_ANNOTATE" ))
            (command "-LAYER" "n" "...12_TNT_LINE_ANNOTATE" 
                              "c" "14" "...12_TNT_LINE_ANNOTATE" 
                              "L" "CONTINUOUS" "...12_TNT_LINE_ANNOTATE" 
                              "LW" "0" "...12_TNT_LINE_ANNOTATE"
                              "TR" "50" "...12_TNT_LINE_ANNOTATE"
                              "P" "P" "...12_TNT_LINE_ANNOTATE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...13_TNT_LINE_TREE" ))
            (command "-LAYER" "n" "...13_TNT_LINE_TREE" 
                              "c" "76" "...13_TNT_LINE_TREE" 
                              "L" "CONTINUOUS" "...13_TNT_LINE_TREE" 
                              "LW" "0" "...13_TNT_LINE_TREE"
                              "TR" "50" "...13_TNT_LINE_TREE"
                              "P" "P" "...13_TNT_LINE_TREE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...14_TNT_LINE_GLASSES" ))
            (command "-LAYER" "n" "...14_TNT_LINE_GLASSES" 
                              "c" "147" "...14_TNT_LINE_GLASSES" 
                              "L" "CONTINUOUS" "...14_TNT_LINE_GLASSES" 
                              "LW" "0" "...14_TNT_LINE_GLASSES"
                              "TR" "50" "...14_TNT_LINE_GLASSES"
                              "P" "P" "...14_TNT_LINE_GLASSES"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...15_TNT_LINE_DOOR" ))
            (command "-LAYER" "n" "...15_TNT_LINE_DOOR" 
                              "c" "33" "...15_TNT_LINE_DOOR" 
                              "L" "CONTINUOUS" "...15_TNT_LINE_DOOR" 
                              "LW" "0" "...15_TNT_LINE_DOOR"
                              "TR" "50" "...15_TNT_LINE_DOOR"
                              "P" "P" "...15_TNT_LINE_DOOR"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...16_TNT_LINE_DETAIL" ))
            (command "-LAYER" "n" "...16_TNT_LINE_DETAIL" 
                              "c" "156" "...16_TNT_LINE_DETAIL" 
                              "L" "HIDDEN" "...16_TNT_LINE_DETAIL" 
                              "LW" "0" "...16_TNT_LINE_DETAIL"
                              "TR" "50" "...16_TNT_LINE_DETAIL"
                              "P" "P" "...16_TNT_LINE_DETAIL"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...17_TNT_SECTION_LINE" ))
            (command "-LAYER" "n" "...17_TNT_SECTION_LINE" 
                              "c" "6" "...17_TNT_SECTION_LINE" 
                              "L" "ACAD_ISO07W100" "...17_TNT_SECTION_LINE" 
                              "LW" "0" "...17_TNT_SECTION_LINE"
                              "TR" "50" "...17_TNT_SECTION_LINE"
                              "P" "P" "...17_TNT_SECTION_LINE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...18_TNT_LINE_TITLE" ))
            (command "-LAYER" "n" "...18_TNT_LINE_TITLE" 
                              "c" "9" "...18_TNT_LINE_TITLE" 
                              "L" "CONTINUOUS" "...18_TNT_LINE_TITLE" 
                              "LW" "0" "...18_TNT_LINE_TITLE"
                              "TR" "50" "...18_TNT_LINE_TITLE"
                              "P" "P" "...18_TNT_LINE_TITLE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...19_TNT_LAYOUT" ))
            (command "-LAYER" "n" "...19_TNT_LAYOUT" 
                              "c" "250" "...19_TNT_LAYOUT" 
                              "L" "CONTINUOUS" "...19_TNT_LAYOUT" 
                              "LW" "0" "...19_TNT_LAYOUT"
                              "TR" "50" "...19_TNT_LAYOUT"
                              "P" "N" "...19_TNT_LAYOUT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...20_TNT_COMPLETE" ))
            (command "-LAYER" "n" "...20_TNT_COMPLETE"
                              "c" "8" "...20_TNT_COMPLETE" 
                              "L" "CONTINUOUS" "...20_TNT_COMPLETE" 
                              "LW" "0" "...20_TNT_COMPLETE"
                              "TR" "50" "...20_TNT_COMPLETE"
                              "P" "P" "...20_TNT_COMPLETE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...21_TNT_COTE" ))
            (command "-LAYER" "n" "...21_TNT_COTE"
                              "c" "54" "...21_TNT_COTE" 
                              "L" "CONTINUOUS" "...21_TNT_COTE" 
                              "LW" "0" "...21_TNT_COTE"
                              "TR" "50" "...21_TNT_COTE"
                              "P" "P" "...21_TNT_COTE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...22_TNT_WATER-NOTE" ))
            (command "-LAYER" "n" "...22_TNT_WATER-NOTE"
                              "c" "11" "...22_TNT_WATER-NOTE" 
                              "L" "CONTINUOUS" "...22_TNT_WATER-NOTE" 
                              "LW" "0" "...22_TNT_WATER-NOTE"
                              "TR" "0" "...22_TNT_WATER-NOTE"
                              "P" "P" "...22_TNT_WATER-NOTE"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...23_TNT_WATER-TEXT" ))
            (command "-LAYER" "n" "...23_TNT_WATER-TEXT"
                              "c" "3" "...23_TNT_WATER-TEXT" 
                              "L" "CONTINUOUS" "...23_TNT_WATER-TEXT" 
                              "LW" "0" "...23_TNT_WATER-TEXT"
                              "TR" "0" "...23_TNT_WATER-TEXT"
                              "P" "P" "...23_TNT_WATER-TEXT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...24_TNT_WATER-SUPPLY" ))
            (command "-LAYER" "n" "...24_TNT_WATER-SUPPLY"
                              "c" "130" "...24_TNT_WATER-SUPPLY" 
                              "L" "CONTINUOUS" "...24_TNT_WATER-SUPPLY" 
                              "LW" "0" "...24_TNT_WATER-SUPPLY"
                              "TR" "0" "...24_TNT_WATER-SUPPLY"
                              "P" "P" "...24_TNT_WATER-SUPPLY"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...25_TNT_WATER-SUPPLY-HOT" ))
            (command "-LAYER" "n" "...25_TNT_WATER-SUPPLY-HOT"
                              "c" "240" "...25_TNT_WATER-SUPPLY-HOT" 
                              "L" "HIDDEN" "...25_TNT_WATER-SUPPLY-HOT" 
                              "LW" "0" "...25_TNT_WATER-SUPPLY-HOT"
                              "TR" "0" "...25_TNT_WATER-SUPPLY-HOT"
                              "P" "P" "...25_TNT_WATER-SUPPLY-HOT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...26_TNT_WATER-DRAIN-TOILET" ))
            (command "-LAYER" "n" "...26_TNT_WATER-DRAIN-TOILET"
                              "c" "4" "...26_TNT_WATER-DRAIN-TOILET" 
                              "L" "HIDDEN" "...26_TNT_WATER-DRAIN-TOILET" 
                              "LW" "0" "...26_TNT_WATER-DRAIN-TOILET"
                              "TR" "0" "...26_TNT_WATER-DRAIN-TOILET"
                              "P" "P" "...26_TNT_WATER-DRAIN-TOILET"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...27_TNT_WATER-DRAIN-RAIN" ))
            (command "-LAYER" "n" "...27_TNT_WATER-DRAIN-RAIN"
                              "c" "5" "...27_TNT_WATER-DRAIN-RAIN" 
                              "L" "HIDDEN" "...27_TNT_WATER-DRAIN-RAIN" 
                              "LW" "0" "...27_TNT_WATER-DRAIN-RAIN"
                              "TR" "0" "...27_TNT_WATER-DRAIN-RAIN"
                              "P" "P" "...27_TNT_WATER-DRAIN-RAIN"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...28_TNT_WATER-DRAIN-WASH" ))
            (command "-LAYER" "n" "...28_TNT_WATER-DRAIN-WASH"
                              "c" "6" "...28_TNT_WATER-DRAIN-WASH" 
                              "L" "HIDDEN" "...28_TNT_WATER-DRAIN-WASH" 
                              "LW" "0" "...28_TNT_WATER-DRAIN-WASH"
                              "TR" "0" "...28_TNT_WATER-DRAIN-WASH"
                              "P" "P" "...28_TNT_WATER-DRAIN-WASH"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...29_TNT_WATER-DRAIN-VENT" ))
            (command "-LAYER" "n" "...29_TNT_WATER-DRAIN-VENT"
                              "c" "50" "...29_TNT_WATER-DRAIN-VENT" 
                              "L" "HIDDEN" "...29_TNT_WATER-DRAIN-VENT" 
                              "LW" "0" "...29_TNT_WATER-DRAIN-VENT"
                              "TR" "0" "...29_TNT_WATER-DRAIN-VENT"
                              "P" "P" "...29_TNT_WATER-DRAIN-VENT"
                              ""
            ))
            (if (not (tblsearch "LAYER" "...22_TNT_ELECTRIC" ))
            (command "-LAYER" "n" "...22_TNT_ELECTRIC"
                              "c" "21" "...22_TNT_ELECTRIC" 
                              "L" "CONTINUOUS" "...22_TNT_ELECTRIC" 
                              "LW" "0" "...22_TNT_ELECTRIC"
                              "TR" "0" "...22_TNT_ELECTRIC"
                              "P" "P" "...22_TNT_ELECTRIC"
                              ""
            ))
            
      (setvar "CMDECHO" 1)
      (command "UNDO" "END")
      (princ))
      
  ;; 3.CHUYEN TAT CA LAYER  
    (defun c:LAY (/ CND CNT CNH)
      (setvar "MODEMACRO" "TNT Architecture")
      (command "UNDO" "BE")
      (setvar "CMDECHO" 0)
      (TAOLAYER)
      (setvar "PICKSTYLE" 0)
      (setq CND (ssget "X" '((-4 . "<OR")
                            (0 . "DIMENSION")
                            (-4 . "OR>"))))     
        (command ".CHANGE" CND "" "P" "LA" "...11_TNT_LINE_DIMENSION" "")          
      (setq CNT (ssget "X" '((-4 . "<OR")
                              (0 . "MTEXT")
                              (0 . "TEXT")
                              (0 . "LEADER")
                              (-4 . "OR>"))))
        (command ".CHANGE" CNT "" "P" "LA" "...9_TNT_LINE_TEXT" "")
      (setq CNH (ssget "X" '((-4 . "<AND")
                            (0 . "HATCH")       
                            (-4 . "AND>"))))        
        (command ".CHANGE" CNH "" "P" "LA" "...10_TNT_LINE_HATCH" "")        
        (command ".DRAWORDER" CNH "" "B" ) 
      (command ".TEXTTOFRONT" "A" )
      (setvar "PICKSTYLE" 1)
      (setvar "CMDECHO" 1)
      (command "UNDO" "END")
      (princ)
    )
  ;; 4.CHUYEN LAYER HIEN HANH NHANH
    (defun c:NT (/ NT)
      (setvar "CMDECHO" 0)
      (setq NT (ssget)) 								       
      (if (null NT)    
        (command "CLAYER" "...4_TNT_LINE_VIRTURAL")
        (progn
          (command ".CHANGE" NT "" "P" "LA" "...4_TNT_LINE_VIRTURAL" "")
          (command "CLAYER" "...4_TNT_LINE_VIRTURAL")    
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:N0 (/ N0)
      (setvar "CMDECHO" 0)
      (setq N0 (ssget))                                                        
      (if (null N0)    
        (command "CLAYER" "0")
        (progn
          (command ".CHANGE" N0 "" "P" "LA" "0" "")
          (command "CLAYER" "0")    
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NC (/ NC)
      (setvar "CMDECHO" 0)
      (setq NC (ssget))
      (if (null NC)
        (command "CLAYER" "...3_TNT_LINE_SECTION")
        (progn
          (command "_.change" NC "" "P" "LA" "...3_TNT_LINE_SECTION" "")
          (command "CLAYER" "...3_TNT_LINE_SECTION")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NK (/ NK)
      (setvar "CMDECHO" 0)
      (setq NK (ssget))
      (if (null NK)
        (command "CLAYER" "...6_TNT_LINE_HIDDEN")
        (progn
        (command "_.change" NK "" "P" "LA" "...6_TNT_LINE_HIDDEN" "")
        (command "CLAYER" "...6_TNT_LINE_HIDDEN")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NTR (/ NTR)
      (setvar "CMDECHO" 0)
      (setq NTR (ssget))
      (if (null NTR)
        (command "CLAYER" "...7_TNT_LINE_BASE")
        (progn 	
        (command "_.change" NTR "" "P" "LA" "...7_TNT_LINE_BASE" "")
        (command "CLAYER" "...7_TNT_LINE_BASE")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NNT (/ NNT)
      (setvar "CMDECHO" 0)
      (setq NNT (ssget))
      (if (null NNT)
        (command "CLAYER" "...8_TNT_LINE_FUNITURE")
        (progn  	  	
        (command "_.change" NNT "" "P" "LA" "...8_TNT_LINE_FUNITURE" "")
        (command "CLAYER" "...8_TNT_LINE_FUNITURE")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NH (/ NH)
      (setvar "CMDECHO" 0)
      (setq NH (ssget))
      (if (null NH)
        (command "CLAYER" "...10_TNT_LINE_HATCH")
        (progn	
          (command "_.change" NH "" "P" "LA" "...10_TNT_LINE_HATCH" "")
          (command "CLAYER" "...10_TNT_LINE_HATCH")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NM (/ NM)
      (setvar "CMDECHO" 0)
      (setq NM (ssget))
      (if (null NM)      
        (command "CLAYER" "...5_TNT_LINE_THIN")
        (progn  	    
          (command "_.change" NM "" "P" "LA" "...5_TNT_LINE_THIN" "")
          (command "CLAYER" "...5_TNT_LINE_THIN")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:ND (/ ND)
      (setvar "CMDECHO" 0)
      (setq ND (ssget))
      (if (null ND)      
        (command "CLAYER" "...16_TNT_LINE_DETAIL")
        (progn  	    
          (command "_.change" ND "" "P" "LA" "...16_TNT_LINE_DETAIL" "")
          (command "CLAYER" "...16_TNT_LINE_DETAIL")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )
    (defun c:NN (/ NN)
      (setvar "CMDECHO" 0)
      (setq NN (ssget))
      (if (null NN)      
        (command "CLAYER" "...11_TNT_LINE_DIMENSION")
        (progn  	    
          (command "_.change" NN "" "P" "LA" "...11_TNT_LINE_DIMENSION" "")
          (command "CLAYER" "...11_TNT_LINE_DIMENSION")
        )
      )
      (setvar "CMDECHO" 1)
      (princ)
    )