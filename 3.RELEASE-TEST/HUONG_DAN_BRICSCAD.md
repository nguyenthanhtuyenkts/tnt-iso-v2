# Dùng bộ TNT LISP trên BricsCAD

Không dùng `TNT_TOOL_IN HANG LOAT.VLX`: VLX được biên dịch cho AutoCAD và không
phải định dạng triển khai tương thích BricsCAD.

1. Mở `APPLOAD` trong BricsCAD.
2. Chọn `TNT_BRICSCAD_LOAD.lsp`.
3. Nếu muốn tự nạp khi khởi động, thêm chính file này vào danh sách Startup Suite.
4. Kiểm tra dòng tổng kết: `BricsCAD load complete: 18 loaded, 0 failed`.

Loader luôn nạp package hệ thống trước để cung cấp lớp tương thích, sau đó mới
nạp các package lệnh và LISP hỗ trợ.

## Giới hạn theo nền tảng

- `AECFILLET` tự rơi về `FILLET` khi BricsCAD không có lệnh AEC.
- `TNT_AEC_TO_ACAD.lsp` không được tự nạp vì `-AECOBJEXPLODE` là lệnh riêng của
  AutoCAD Architecture. Có thể nạp thủ công khi chạy đúng sản phẩm Autodesk.
- Các đối tượng AEC proxy không thể được BricsCAD biến thành đối tượng native
  nếu thiếu object enabler/phần mềm nguồn.
- ObjectDBX thử ProgID của BricsCAD trước; chức năng tương ứng vẫn phụ thuộc
  edition và phiên bản BricsCAD đang cài.
