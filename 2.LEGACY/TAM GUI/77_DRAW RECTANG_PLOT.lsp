(defun c:vbb (/ osm layer1 ss i blkEnt blkObj scaleX scaleY scale minPt maxPt offset pt1 pt2 existing found)
  (vl-load-com)

  ;; Lưu trạng thái
  (setq osm (getvar "osmode"))
  (setq layer1 (getvar "clayer"))

  ;; Chọn nhiều block
  (prompt "\nChọn các block khung tên: ")
  (setq ss (ssget '((0 . "INSERT"))))

  (if ss
    (progn
      ;; Tạo layer nếu chưa có
      (if (not (tblsearch "LAYER" "...19_TNT_LINE_LAYOUT"))
        (command "-LAYER" "n" "...19_TNT_LINE_LAYOUT"
                         "c" "250" "...19_TNT_LINE_LAYOUT"
                         "L" "CONTINUOUS" "...19_TNT_LINE_LAYOUT"
                         "LW" "0" "...19_TNT_LINE_LAYOUT"
                         "TR" "0" "...19_TNT_LINE_LAYOUT"
                         "P" "N" "...19_TNT_LINE_LAYOUT"
                         "")
        (setvar "clayer" "...19_TNT_LINE_LAYOUT")
      )

      ;; Duyệt từng block
      (setq i 0)
      (while (< i (sslength ss))
        (setq blkEnt (ssname ss i))
        (setq blkObj (vlax-ename->vla-object blkEnt))

        ;; Lấy scale trung bình
        (setq scaleX (vlax-get blkObj 'XScaleFactor))
        (setq scaleY (vlax-get blkObj 'YScaleFactor))
        (setq scale (/ (+ scaleX scaleY) 2.0))

        ;; Lấy bounding box
        (vla-GetBoundingBox blkObj 'minPt 'maxPt)
        (setq minPt (vlax-safearray->list minPt))
        (setq maxPt (vlax-safearray->list maxPt))

        ;; Offset vào trong
        (setq offset (* 15.0 scale))
        (setq pt1 (list (+ (car minPt) offset) (+ (cadr minPt) offset)))
        (setq pt2 (list (- (car maxPt) offset) (- (cadr maxPt) offset)))

        ;; Kiểm tra đã có RECTANG (LWPOLYLINE) nào trong vùng này chưa
        (setq existing
          (ssget "C" pt1 pt2 '((0 . "LWPOLYLINE") (8 . "...19_TNT_LINE_LAYOUT")))
        )
        (setq found nil)
        (if existing
          (repeat (sslength existing)
            (setq ent (ssname existing 0))
            ;; Có thể kiểm tra thêm chiều dài polyline để chắc chắn là khung
            (setq found T)
            (setq existing nil)
          )
        )

        ;; Nếu chưa có -> vẽ mới
        (if (not found)
          (progn
            (setvar "osmode" 0)
            (command "_.rectang" pt1 pt2)
          )
        )

        (setq i (1+ i))
      )

      ;; Trả lại trạng thái
      (setvar "clayer" layer1)
      (setvar "osmode" osm)
    )
    (prompt "\nKhông chọn block nào.")
  )
  (princ)
)


