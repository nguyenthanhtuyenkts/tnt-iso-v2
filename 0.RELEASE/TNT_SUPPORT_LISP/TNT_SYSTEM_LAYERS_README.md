# Bảng layer đơn giản

1. Mở `TNT_SYSTEM_LAYERS.xlsx`, chỉnh sheet **Layers** hoặc **Defaults**.
2. Lưu và đóng Excel, chạy `TNT_UPDATE_SYSTEM_LAYERS.cmd` trong `0.RELEASE`.
3. APPLOAD lại package SYSTEM. Để áp dụng thuộc tính trong CAD, nạp package CREATE và gọi `(TNT_LAYER_CREATE)`.

Công cụ kiểm tra dữ liệu, sao lưu Lisp, cập nhật bảng layer trong SYSTEM và đồng bộ bản AutoCAD 2014. Hướng dẫn các cột nằm trong sheet **Guide**.

Không dùng LayerID, không lưu lịch sử đổi tên và không tự gộp/đổi tên layer trong DWG. Nếu đổi tên chuẩn trong Excel, cần xử lý layer cũ và các tham chiếu liên quan riêng.