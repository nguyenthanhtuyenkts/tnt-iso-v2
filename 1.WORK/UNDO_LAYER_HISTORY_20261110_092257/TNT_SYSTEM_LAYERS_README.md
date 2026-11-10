# Quản lý layer và lịch sử thay đổi

Chỉnh `TNT_SYSTEM_LAYERS.xlsx`, lưu và đóng Excel, rồi chạy
`TNT_UPDATE_SYSTEM_LAYERS.cmd` **trong `0.RELEASE`**.

## Các cột cần nhớ

- **Layer**: tên chuẩn hiện tại. Có thể đổi tên.
- **LayerID**: mã cố định. Khi đổi tên hoặc sắp xếp lại bảng, giữ nguyên mã.
  Layer mới để trống mã; công cụ cấp mã khi cập nhật thành công.
- **Status**: `ACTIVE` là đang sử dụng; `RETIRED` là ngừng sử dụng.
  Không xóa dòng đã có LayerID.
- **ReplacementID**: chỉ điền cho dòng RETIRED. Điền mã layer đích để gộp;
  để trống nếu muốn giữ đối tượng/layer cũ trong DWG và ngừng tạo layer đó.
  Nếu package còn tham chiếu layer này, phải có layer thay thế.
- **ExcludeByLayer**: `Y` miễn ép ByLayer trong package LAYER; `N` áp dụng bình thường.
- Màu dùng ACI 1–255; độ dày dùng mm với dấu chấm, 0/rỗng là ByLayer theo
  cơ chế CREATE hiện tại; độ trong suốt dùng số nguyên 0–90.

Sheet **Defaults** chứa layer mặc định DIM/HATCH/TEXT/MLEADER. Tên cũ trong
sheet này được chuyển sang tên mới theo LayerID. Sheet **History** chỉ để xem.

## Khi cập nhật

Công cụ giữ ảnh chụp trước/sau của từng phiên bản trong
`TNT_SYSTEM_LAYERS_HISTORY.json`, cấp mã cho layer mới và sinh mapping từ mọi
tên cũ về đích hiện tại. Ví dụ A → B → C tạo mapping A → C và B → C.
Chạy lại dữ liệu không đổi không tạo thêm phiên bản.

Tham chiếu chuỗi tên layer trong các Lisp thuộc `0.RELEASE` được đổi chính xác
theo tên đầy đủ. Trong `TNT_LAYER_SYNC_ALL.lsp`, chỉ đổi layer đích, giữ nguyên
các tên nguồn. Công cụ cập nhật mapping Excel cũ cũng tra lịch sử trước khi ghi
layer đích. Các tập tin DWG, VLX, menu và ứng dụng bên ngoài không được sửa.

Không được dùng tên lịch sử của một LayerID cho LayerID khác. Không hỗ trợ tự
tách đối tượng của một layer sang nhiều đích; cần quy tắc riêng cho trường hợp đó.

## Áp dụng vào bản vẽ

APPLOAD lại **SYSTEM và CREATE**, sau đó gọi `(TNT_LAYER_CREATE)` hoặc lệnh `0`.
Chỉ APPLOAD không thực hiện chuyển layer trong DWG.

- Chỉ có tên cũ: đổi tên, giữ layer handle và liên kết với đối tượng.
- Có cả hai tên: chuyển đối tượng trong Model, các Layout, định nghĩa block và
  attribute sang đích; chuyển CLAYER nếu cần; thử xóa layer cũ và báo nếu còn tồn tại.
- Áp dụng thuộc tính chuẩn từ Excel lên các layer ACTIVE.
- RETIRED không có đích: giữ nguyên layer/đối tượng cũ và báo trạng thái.

Quét lại mỗi lần chạy, kể cả khi bản vẽ đã từng cập nhật nhưng vừa được copy
đối tượng dùng tên cũ vào. Không chỉ dựa vào số phiên bản đã lưu trong DWG.

Layer khóa được xử lý khi gộp. Layer không xóa được hoặc đối tượng không sửa
được sẽ được báo là còn lỗi/chờ xử lý. Không sửa nội dung Xref: cần cập nhật
DWG nguồn. Khi gộp, thuộc tính chuẩn và các override viewport của layer đích
được sử dụng; override của layer cũ không tự chép sang đích.

Một lần CREATE được nhóm UNDO. Các lần chuyển layer được ghi trong dictionary
`TNT_LAYER_HISTORY` của DWG với phiên bản, thời điểm và số đổi tên/chuyển/xóa/lỗi.
DWG không được tự lưu.

## Sao lưu và khôi phục

Mỗi lần xuất bản có thư mục trong `1.WORK/SYSTEM_LAYER_BACKUPS`, gồm bản sao
các tập tin sắp sửa và `manifest.json` ghi đường dẫn gốc. Nếu ghi hoặc đồng bộ
thất bại, công cụ thử khôi phục các tập tin trước giao dịch.

Khôi phục phải dùng **cả bộ** tương ứng (Excel, JSON, SYSTEM và các Lisp liên
quan trong manifest), sau đó chạy `1.WORK/TNT_Sync_Release14.ps1` và chạy lại
với `-Check`. Không khôi phục riêng JSON hoặc xóa lịch sử để cấp lại mã.

Bản AutoCAD 2014 được đồng bộ tự động: Lisp dùng ASCII; mô tả tiếng Việt được
bỏ dấu bởi script sync. Tên layer và linetype trong bảng này yêu cầu ASCII để
không làm thay đổi định danh bản vẽ khi đồng bộ.

Kiểm tra trước, không ghi tập tin:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "0.RELEASE/TNT_SUPPORT_LISP/TNT_SYSTEM_LAYERS.ps1" -Check
```
