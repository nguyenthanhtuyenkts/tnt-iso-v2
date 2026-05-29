# TNT CTB Pipeline

Mục tiêu: chuyển `TNT_PLOT_STYLE_2026.ctb` sang dạng bảng để đọc, review, chỉnh thử; sau đó build ngược lại một file `.ctb` mới mà không ghi đè file gốc.

## Vì Sao Cần Pipeline

File `.ctb` là color-dependent plot style. Nghĩa là nét in không đi trực tiếp theo layer name, mà đi theo màu ACI của layer.

Ví dụ:

- Layer A dùng màu ACI 7.
- Layer B cũng dùng màu ACI 7.
- Nếu sửa CTB của ACI 7, cả layer A và layer B đều bị ảnh hưởng khi in.

Vì vậy pipeline có 2 bảng khác nhau:

- `Layer_CTB_Sync`: bảng để xem layer nào đang dùng màu nào và CTB của màu đó ra nét bao nhiêu.
- `CTB_255_Colors`: bảng nguồn để build lại CTB mới. Khi muốn sửa CTB, chỉnh bảng này.

## Cấu Trúc Folder

Folder này nằm tại:

`1.WORK\CTB_PIPELINE`

Script chính:

- `01_Export_CTB_Pipeline.ps1`: đọc CTB gốc, xuất bảng review.
- `02_Build_CTB_From_EditedCsv.ps1`: đọc bảng CTB đã chỉnh và tạo CTB mới.

Output mặc định:

- `OUT_REVIEW`: dữ liệu để đọc/chỉnh.
- `OUT_BUILD`: CTB mới được build ra.

## Bước 1 - Xuất CTB Sang Bảng Review

Chạy từ root repo:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "1.WORK\CTB_PIPELINE\01_Export_CTB_Pipeline.ps1"
```

Kết quả trong `1.WORK\CTB_PIPELINE\OUT_REVIEW`:

- `TNT_PLOT_STYLE_2026.raw.txt`: CTB giải nén nguyên bản, dùng để soi sâu.
- `CTB_255_Colors.csv`: 255 màu CTB, dùng làm nguồn chỉnh để build CTB mới.
- `Layer_Standard.csv`: bảng layer chuẩn từ `TNT_PACKAGE_00_SYSTEM_ALL.lsp`.
- `Layer_CTB_Sync.csv`: bảng layer + CTB join theo màu ACI.
- `Notes.csv`: ghi chú ngắn.
- `TNT_CTB_REVIEW.xlsx`: workbook Excel nếu máy có Excel COM.

Nếu máy không có Excel, script vẫn xuất CSV. Có thể mở CSV bằng Excel thủ công.

## Bước 2 - Review Trong Excel

Mở `TNT_CTB_REVIEW.xlsx`, ưu tiên xem sheet:

- `Layer_CTB_Sync`: để kiểm tra layer hiện tại đang in ra nét gì.
- `CTB_255_Colors`: để chỉnh CTB.

Các cột quan trọng:

- `ACI`: màu AutoCAD 1-255.
- `lineweight`: mã lineweight gốc trong CTB.
- `LineweightMm`: giá trị mm dễ đọc, sinh ra từ `lineweight`.
- `screen`: screening, thường là phần trăm độ đậm.
- `color_policy`: mã policy màu, giữ raw để tránh diễn giải sai.
- `linetype`: mã linetype trong CTB, giữ raw.

## Bước 3 - Chỉnh CTB

Khi muốn tạo CTB mới, chỉnh sheet hoặc file:

`CTB_255_Colors.csv`

Không chỉnh `Layer_CTB_Sync.csv` để build CTB, vì bảng đó là bảng review theo layer. CTB thật sự chỉ biết màu ACI.

Quy tắc an toàn:

- Không xóa dòng.
- Không đổi `PlotStyleIndex`.
- Không đổi `ACI` sai lệch với `PlotStyleIndex + 1`.
- Không để thiếu màu, phải đủ 255 dòng.
- Chỉ đổi các cột như `lineweight`, `screen`, `color_policy`, `linetype` khi hiểu tác động.
- Nếu chỉnh bằng Excel, lưu lại sheet `CTB_255_Colors` thành CSV UTF-8 trước khi build.

## Bước 4 - Build CTB Mới

Chạy:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "1.WORK\CTB_PIPELINE\02_Build_CTB_From_EditedCsv.ps1"
```

Mặc định script đọc:

`1.WORK\CTB_PIPELINE\OUT_REVIEW\CTB_255_Colors.csv`

và tạo:

`1.WORK\CTB_PIPELINE\OUT_BUILD\TNT_PLOT_STYLE_2026_EDITED.ctb`

File gốc không bị sửa:

`0.RELEASE\TNT_PLOT_STYLE_2026.ctb`

## Bước 5 - Test CTB Mới

Copy hoặc trỏ AutoCAD tới file:

`TNT_PLOT_STYLE_2026_EDITED.ctb`

Sau đó test trong bản vẽ mẫu:

1. In preview với vài layer chính.
2. Kiểm tra layer dùng chung một ACI có bị ảnh hưởng ngoài ý muốn không.
3. So sánh nét với CTB gốc.
4. Chỉ khi ổn mới cân nhắc thay CTB release.

## Ghi Chú Kỹ Thuật

CTB hiện tại có header:

```text
PIAFILEVERSION_2.0,CTBVER1,compress
pmzlibcodec
```

Nội dung chính là text config nén zlib. Script build lại CTB theo cách:

1. Giải nén CTB gốc thành raw text.
2. Thay các block `plot_style` theo `CTB_255_Colors.csv`.
3. Nén lại zlib.
4. Cập nhật độ dài raw/compressed trong header.
5. Ghi ra file CTB mới.

## Điểm Cần Cẩn Thận

Script build CTB là pipeline kỹ thuật dựa trên cấu trúc CTB hiện tại. Sau khi build, bắt buộc test trong AutoCAD trước khi dùng thật.

Không dùng pipeline này để ghi đè trực tiếp file release. Luôn build ra file mới, test, rồi mới quyết định thay thế.
