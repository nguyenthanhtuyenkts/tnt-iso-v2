# Hướng dẫn lệnh tắt TNT Architecture

Tài liệu này tổng hợp các lệnh có trong bộ Lisp tại thư mục `0.RELEASE`, được nhóm theo chức năng.

## Cách sử dụng chung

1. Nạp các file Lisp của bộ TNT vào AutoCAD.
2. Gõ lệnh tại command line rồi nhấn `Enter`.
3. Làm theo lời nhắc chọn đối tượng, chọn điểm hoặc nhập giá trị.
4. Nhấn `Esc` để hủy lệnh đang chạy.

> **Lưu ý:** Với nhóm lệnh chuyển layer `N...`, có thể chọn đối tượng trước rồi gọi lệnh. Nếu không chọn đối tượng, lệnh chỉ đặt layer tương ứng thành layer hiện hành.

## 1. Khởi tạo và hệ thống

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `0` | Khởi tạo toàn bộ môi trường TNT | Gõ `0` để áp dụng thiết lập hệ thống, tạo dữ liệu chuẩn và nạp lại shortcut. Nên chạy sau khi nạp bộ Lisp hoặc khi bản vẽ chưa có tiêu chuẩn TNT. |
| `TNT_SETTING` | Áp dụng thiết lập hệ thống TNT | Gõ lệnh để thiết lập biến hệ thống, giao diện, layer mặc định cho Dim/Hatch và các cấu hình chuẩn. |
| `TNT_SHORTCUT` | Khởi tạo lại các lệnh tắt | Dùng khi shortcut chưa nhận hoặc sau khi nạp lại `TNT_PACKAGE_11_SHORTCUT.lsp`. |
| `TNT_LAYER` | Chuẩn hóa layer toàn bản vẽ | Tạo/reset layer TNT, phân loại đối tượng và ép thuộc tính về `ByLayer` trên các layer chuẩn. Nên lưu bản vẽ trước khi chạy. |
| `TNT` | Đồng bộ đối tượng theo tỷ lệ khung | Chọn khung để lấy tỷ lệ, sau đó chọn block, line, polyline, circle, leader, text và dimension cần đồng bộ. |

## 2. Shortcut AutoCAD cơ bản

| Lệnh tắt | Lệnh AutoCAD | Chức năng | Cách dùng |
|---|---|---|---|
| `C` | `COPY` | Sao chép đối tượng | Chọn đối tượng, chọn điểm gốc, chọn điểm đặt bản sao. |
| `M` | `MOVE` | Di chuyển đối tượng | Chọn đối tượng, chọn điểm gốc, chọn điểm đích. |
| `MM` | `MIRROR` | Đối xứng đối tượng | Chọn đối tượng, xác định hai điểm trục đối xứng, chọn có xóa bản gốc hay không. |
| `R` | `ROTATE` | Xoay đối tượng | Chọn đối tượng, chọn tâm xoay, nhập góc hoặc dùng tùy chọn `Reference`. |
| `S` | `STRETCH` | Kéo giãn đối tượng | Quét chọn crossing phần cần kéo, chọn điểm gốc và điểm đích. |
| `SC` | `SCALE` | Thay đổi tỷ lệ | Chọn đối tượng, chọn điểm gốc, nhập hệ số hoặc dùng `Reference`. |
| `CC` | `CIRCLE` | Vẽ đường tròn | Chọn tâm rồi nhập bán kính/đường kính. |
| `ML` | `MLINE` | Vẽ đường nhiều nét | Gõ `ML`, chọn các điểm, nhấn `Enter` để kết thúc. |
| `SPL` | `SPLINE` | Vẽ đường cong spline | Chọn lần lượt các điểm điều khiển, nhấn `Enter` để kết thúc. |
| `XX` | `XLINE` | Vẽ đường dựng vô hạn | Chọn kiểu và các điểm xác định đường dựng. |
| `D` | `DIMLINEAR` | Ghi kích thước ngang/đứng | Chọn hai điểm đo rồi đặt đường kích thước. |
| `DD` | `DIMALIGNED` | Ghi kích thước xiên | Chọn hai điểm đo rồi đặt đường kích thước song song với phương đo. |
| `DC` | `DIMCONTINUE` | Ghi kích thước nối tiếp | Chọn kích thước gốc nếu cần, sau đó chọn các điểm tiếp theo. |
| `DST` | `DIMSTYLE` | Mở trình quản lý Dimstyle | Gõ `DST` để tạo, sửa hoặc đặt Dimstyle hiện hành. |
| `LL` | `DIMSTYLE` | Mở trình quản lý Dimstyle | Lệnh đồng nghĩa với `DST`. |

## 3. Quản lý hiển thị và layer

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `1` | Cô lập layer (`LAYISO`) | Chọn đối tượng thuộc các layer cần giữ lại; các layer khác sẽ bị ẩn/khóa theo thiết lập AutoCAD. |
| `2` | Bật toàn bộ layer (`LAYON`) | Gõ lệnh để bật lại tất cả layer đang tắt. |
| `3` | Tắt layer (`LAYOFF`) | Chọn đối tượng thuộc layer cần tắt. |
| `11` | Sửa block/Xref tại chỗ (`REFEDIT`) | Chọn block hoặc Xref cần chỉnh sửa ngay trong bản vẽ hiện hành. |
| `22` | Kết thúc sửa tại chỗ (`REFCLOSE`) | Gõ lệnh rồi chọn lưu hoặc bỏ thay đổi của phiên `REFEDIT`. |
| `D1` | Chỉnh hệ số đo kích thước `DIMLFAC` | Gõ `D1`, nhập hệ số đo mới; lệnh đồng thời đặt `DIMASZ = 1.1`. |
| `D2` | Chỉnh tỷ lệ tổng thể `DIMSCALE` | Gõ `D2`, nhập tỷ lệ Dim mới; lệnh đồng thời đặt `DIMASZ = 1.1`. |

## 4. Chuyển nhanh layer kiến trúc

| Lệnh | Layer đích | Chức năng / Cách dùng |
|---|---|---|
| `NKH` | `....01_TNT_A_DRAWING` | Khung bản vẽ. Chọn trước đối tượng để chuyển layer, hoặc gọi lệnh để đặt layer hiện hành. |
| `NT` | `....02_TNT_A_VIRTURAL` | Nét thấy. |
| `NM` | `....03_TNT_A_THIN` | Nét mảnh. |
| `NK` | `....04_TNT_A_HIDDEN` | Nét khuất. |
| `NC` | `....05_TNT_A_SECTION` | Nét cắt. |
| `NSL` | `....06_TNT_A_SECTION-LINE` | Trục/đường chỉ mặt cắt. |
| `NTR` | `....07_TNT_A_BASE` | Nét trục hoặc đường cơ sở. |
| `NDE` | `....08_TNT_A_DETAIL` | Nét chi tiết. |
| `NCOM` | `....09_TNT_A_COMPLETE` | Nét hoàn thiện. |
| `NCOT` | `....10_TNT_A_COTE` | Cao độ/cốt. |
| `NPL` | `....11_TNT_A_PLOT` | Nét phục vụ in/khung plot. |

## 5. Chuyển nhanh layer nội thất và kết cấu

| Lệnh | Layer đích | Chức năng / Cách dùng |
|---|---|---|
| `NNT` | `....12_TNT_F_FURNITURE` | Nội thất. Chọn trước đối tượng để chuyển layer, hoặc gọi lệnh để đặt layer hiện hành. |
| `NCC` | `....13_TNT_F_TREE` | Cây xanh. |
| `NGL` | `....14_TNT_F_GLASS` | Kính. |
| `NDO` | `....15_TNT_F_DOOR` | Cửa. |
| `NCON` | `....16_TNT_S_CONCRETE` | Bê tông/Bê tông cốt thép. |
| `NWA` | `....17_TNT_S_WALL` | Tường. |

## 6. Chuyển nhanh layer ghi chú

| Lệnh | Layer đích | Chức năng / Cách dùng |
|---|---|---|
| `NTE` | `....20_TNT_N_TEXT` | Text/chữ. Chọn trước đối tượng để chuyển layer, hoặc gọi lệnh để đặt layer hiện hành. |
| `NLE` | `....21_TNT_N_LEADER` | Leader/đường dẫn ghi chú. |
| `NDI` | `....22_TNT_N_DIMENSION` | Dimension/kích thước. |
| `NHA` | `....23_TNT_N_HATCH` | Hatch/vật liệu. |
| `NAN` | `....24_TNT_N_ANNOTATE` | Ký hiệu và chú thích khác. |

## 7. Vẽ và hiệu chỉnh hình học

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `VBB` | Tạo khung plot quanh block khung tên | Chọn các block khung tên; lệnh tạo rectangle bao ngoài trên layer `....11_TNT_A_PLOT`. |
| `NC1` | Vẽ ký hiệu đường cắt dạng zíc-zắc | Chọn điểm đầu và điểm cuối; lệnh tự tạo polyline ký hiệu ở giữa đoạn. |
| `CLD` | Tạo revision cloud hình chữ nhật | Chọn hai góc chữ nhật, nhập bán kính cung; lệnh chuyển rectangle thành revision cloud. |
| `RV` | Tạo/chuyển đổi revision cloud | Chọn `New`, `Select` hoặc `Change`; có thể đặt bán kính cung và bề rộng nét. |
| `ZZ` | Tạo revision cloud kiểu Calligraphy | Chọn hai góc chữ nhật; lệnh tạo cloud với bán kính cung mặc định `500`. |
| `WQ1` | Tạo Wipeout theo biên đối tượng | Chọn Circle, Ellipse hoặc Polyline; sau đó chọn có xóa đường biên nguồn hay không. |
| `DTM` | Tính và ghi diện tích m² | Chọn `Pick` để bấm trong vùng kín, `Select` để cộng diện tích đối tượng, hoặc `Settings` để chỉnh hệ số, số lẻ và chiều cao chữ. |

## 8. Quản lý và sắp xếp đối tượng

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `VC` | Di chuyển tâm nhóm đối tượng đến một điểm | Chọn nhóm đối tượng, sau đó chọn điểm đích; lệnh lấy tâm bounding box làm điểm gốc di chuyển. |
| `VC1` | Đưa đối tượng vào tâm một vùng kín | Chọn đối tượng cần di chuyển, sau đó bấm điểm bên trong vùng kín đích. |
| `VC2` | Biến thể căn tâm nhóm đối tượng | Chọn nhóm đối tượng và làm theo lời nhắc chọn vị trí đích; dùng tâm bounding box của nhóm. |
| `VR1` | Xoay hướng nhìn theo ba điểm | Chọn tâm, phương hiện tại và phương mới; lệnh xoay UCS/PLAN nhưng giữ vùng nhìn. |
| `VR2` | Xoay hướng nhìn `+90°` | Gõ lệnh để xoay UCS quanh trục Z và cập nhật PLAN. |
| `VR3` | Xoay hướng nhìn `-90°` | Gõ lệnh để xoay UCS quanh trục Z và cập nhật PLAN. |
| `VRR` | Trả hướng nhìn về World | Đặt UCS và PLAN về hệ tọa độ World. |
| `STT` | Đánh số thứ tự Text, Attribute, Dimension | Mở hộp thoại, đặt tiền tố/hậu tố/số bắt đầu và chọn đối tượng cần đánh số. |

## 9. Text và ghi chú

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `T1` | Sao chép nội dung Text/Dimension | Chọn một Text/Dimension nguồn, sau đó chọn các Text/Dimension đích. |
| `TA` | Căn chỉnh nhiều Text | Chọn hướng `TRÁI`, `PHẢI`, `LÊN`, `XUỐNG`, `GIỮA-NGANG` hoặc `GIỮA-DỌC`, rồi chọn các text và vị trí chuẩn. |
| `FT` | Căn lề text theo text mẫu | Chọn các text cần xử lý, chọn text chuẩn, sau đó chọn kiểu `Left`, `Center`, `Right` hoặc `Fit`. |
| `DF` | Dàn đều text theo phương Y | Chọn text, nhập khoảng cách, rồi chọn text chuẩn để giữ mốc. |
| `DFX` | Dàn đều text theo phương X | Chọn text, nhập khoảng cách, rồi chọn text chuẩn để giữ mốc. |
| `DX` | Căn các Text thẳng hàng theo Y | Chọn các Text, sau đó chọn Text chuẩn có tung độ cần dùng. |
| `MAT` | Sao chép nội dung giữa các đối tượng chữ | Chọn đối tượng nguồn, rồi chọn các đối tượng đích có hỗ trợ nội dung chữ. |
| `TS1` | Áp dụng Textstyle chính | Chọn Text/MText cần đổi sang `.TNT_A_TXT_1_MAIN`. |
| `TS2` | Áp dụng Textstyle phụ | Chọn Text/MText cần đổi sang `.TNT_A_TXT_2_SUB`. |
| `TS3` | Áp dụng Textstyle ghi chú | Chọn Text/MText cần đổi sang `.TNT_A_TXT_3_NOTE`. |
| `BMASK` | Chỉnh background mask | Chọn MText, MLeader hoặc Dimension; thiết lập trạng thái, khoảng hở và màu nền trong hộp thoại. |
| `ED2` | Sửa nhanh nội dung chữ/attribute | Chọn `ATTRIB`, `TEXT`, `MTEXT` hoặc `DIMENSION`; sửa nội dung trong hộp thoại, tiếp tục chọn đối tượng khác hoặc nhấn `Esc`. |

## 10. Leader

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `A1` | Căn Text/MText theo Leader | Chọn Text/MText và Leader theo lời nhắc để đưa chữ về đúng vị trí đầu Leader. |
| `A2` | Chỉnh đồng loạt góc Leader | Chọn các Leader, sau đó xác định hướng/góc mới. |
| `A3` | Gom đầu Leader và Text theo một vị trí | Chọn Leader cùng Text, sau đó chọn điểm cuối Leader mới. |
| `A4` | Chỉnh đoạn cuối Leader nằm ngang | Chọn các Leader cần hiệu chỉnh; lệnh đưa đoạn nối với chữ về phương ngang. |

## 11. Dimension

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `SD1` | Áp dụng Dimstyle `.TNT_A_DIM_1` | Chọn Dimension/Leader để đổi style; nhấn `Enter` khi không chọn để đặt style này hiện hành. |
| `SD2` | Áp dụng Dimstyle `.TNT_A_DIM_2` | Cách dùng tương tự `SD1`. |
| `SD3` | Áp dụng Dimstyle `.TNT_A_DIM_3` | Cách dùng tương tự `SD1`. |
| `D3` | Đồng bộ tỷ lệ theo đối tượng mẫu | Chọn Block, Dimension, Text hoặc Leader mẫu để lấy và áp dụng thông số tỷ lệ liên quan. |
| `D4` | Chỉnh khoảng cách các đường Dimension | Chọn các Dimension và làm theo lời nhắc để sắp xếp khoảng cách. |
| `D5` | Đặt tỷ lệ/giá trị scale cho Dimension | Nhập tỷ lệ, chọn các Dimension; lệnh cập nhật hệ số và xóa text override cũ. |
| `CD` | Cắt hoặc kéo dài đường gióng Dimension | Chọn các Dimension rồi chọn điểm chuẩn cắt/kéo. |
| `BD` | Dóng/căn các Dimension theo điểm chọn | Chọn các Dimension rồi chọn điểm chuẩn để đưa đường kích thước về cùng vị trí. |
| `AD` | Căn chỉnh Dimension tự động | Chọn nhóm Dimension theo lời nhắc; lệnh gọi bộ căn chỉnh `ADIM` và khôi phục `DIMSCALE`. |
| `ADIM` | Công cụ căn Dimension nâng cao | Chọn các Dimension cần phân loại và sắp xếp; dùng trực tiếp khi cần đầy đủ tùy chọn của bộ căn Dim. |
| `LB1` | Kiểm tra kích thước theo thước Lỗ Ban 52.2 cm | Chọn Dimension; lệnh thêm kết quả `(tốt)` hoặc `(xấu)` vào nội dung kích thước. |
| `LB2` | Kiểm tra kích thước theo thước Lỗ Ban 42.9 cm | Chọn Dimension; lệnh thêm kết quả `(tốt)` hoặc `(xấu)`. |
| `LB3` | Kiểm tra kích thước theo thước Lỗ Ban 38.8 cm | Chọn Dimension; lệnh thêm kết quả `(tốt)` hoặc `(xấu)`. |

## 12. Hatch

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `H25` | Tạo Hatch màu 250 | Gõ lệnh rồi chọn điểm/đối tượng theo quy trình `-HATCH`. |
| `H251` | Tạo Hatch màu 251 | Cách dùng tương tự `H25`. |
| `H252` | Tạo Hatch màu 252 | Cách dùng tương tự `H25`. |
| `H253` | Tạo Hatch màu 253 | Cách dùng tương tự `H25`. |
| `H254` | Tạo Hatch màu 254 | Cách dùng tương tự `H25`. |
| `H255` | Tạo Hatch màu 255 | Cách dùng tương tự `H25`. |
| `HB` | Đưa Hatch xuống dưới biên | Chọn Hatch cần đổi draw order. |
| `HF` | Đưa Hatch lên trước biên | Chọn Hatch cần đổi draw order. |
| `HC` | Sao chép mẫu Hatch sang vùng khác | Chọn Hatch mẫu, sau đó bấm điểm trong vùng cần hatch. |
| `HV` | Di chuyển/tạo lại Hatch theo vùng mới | Chọn Hatch mẫu rồi bấm vùng đích; lệnh giữ mẫu, góc, tỷ lệ và layer. |
| `HS` | Đổi tỷ lệ Hatch | Chọn Hatch, nhập tỷ lệ mới. |
| `HA` | Đổi góc Hatch | Chọn Hatch, nhập hoặc chỉ góc mới. |
| `HT` | Chia Hatch bằng đường cắt | Chọn Line/Polyline cắt, sau đó chọn Hatch tại phía cần xử lý. |
| `HG` | Đổi origin của Hatch | Chọn một hoặc nhiều Hatch, sau đó chọn điểm origin mới. |
| `HSE` | Bật/tắt bắt điểm trên Hatch | Chuyển đổi biến `OSNAPHATCH` giữa `0` và `1`. |
| `HSA` | Tắt liên kết Associative của Hatch | Chọn các Hatch cần tách khỏi đường biên. |
| `RHB` | Tạo lại đường biên Hatch | Chọn Hatch; lệnh tạo boundary dạng Polyline và giữ liên kết nếu AutoCAD hỗ trợ. |

## 13. Block và Attribute

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `B0` | Đưa hình học trong block về layer `0` | Chọn block cần chuẩn hóa; lệnh xử lý cả block lồng. Nên lưu bản vẽ trước khi chạy. |
| `CBP` | Đổi base point, giữ nguyên tọa độ insertion | Chọn block rồi chọn base point mới; vị trí tham chiếu block có thể thay đổi theo base point. |
| `B3` | Đổi base point, giữ nguyên vị trí block trên bản vẽ | Chọn block rồi chọn base point mới; các block reference được bù vị trí để không dịch chuyển hình học. |
| `MAB` | Thay nhiều block bằng block mẫu | Chọn block thay thế, sau đó chọn các block cần thay; giữ vị trí đích nhưng dùng rotation và scale của block mẫu. |
| `MABT` | Sao chép Attribute theo Tag | Chọn block nguồn có Attribute, sau đó chọn các block đích; chỉ các Tag trùng nhau được cập nhật. |
| `RB` | Đổi tên block | Chọn block reference, nhập tên mới; đổi tên definition hiện có. |
| `CB` | Sao chép block thành tên mới | Chọn block reference, nhập tên mới; tạo definition mới và giữ definition cũ. |
| `AT1` | Chép toàn bộ Attribute giữa hai block | Chọn block nguồn rồi block đích; giá trị được chép theo thứ tự Attribute. |
| `AT2` | Chép Text vào Attribute cùng Tag | Chọn Attribute mẫu để lấy Tag, chọn Text nguồn, sau đó chọn block đích tại điểm chỉ. |
| `B1` | Đổi Visibility State của Dynamic Block | Chọn Dynamic Block rồi chọn trạng thái hiển thị trong danh sách. |
| `CA` | Cập nhật cao độ Attribute hàng loạt | Chọn Attribute cao độ mẫu trong block, sau đó chọn các block cần tính/cập nhật theo tọa độ. |
| `MATB` | Sao chép style/thuộc tính trình bày block | Chọn block nguồn rồi các block đích để áp dụng bản đồ thuộc tính/style tương ứng. |
| `SSC` | Ghi/khôi phục bộ style hiện hành | Chạy lệnh để lấy và áp dụng trạng thái style hiện hành đã lưu trong Registry. |
| `ASC` | Đồng bộ thuộc tính/style theo đối tượng | Chọn đối tượng theo lời nhắc để áp dụng các thuộc tính như layer, màu, linetype, lineweight và style liên quan. |

## 14. Chuyển đổi bản vẽ cũ

Các lệnh này nằm trong `TNT_SUPPORT_LISP` và chỉ dùng khi đã nạp file hỗ trợ tương ứng.

| Lệnh | Chức năng | Cách dùng / Ghi chú |
|---|---|---|
| `TNT_MIGRATE_SIMPLE` | Chuyển toàn bộ layer V16 cũ sang layer TNT ISO | Chạy trên bản sao hoặc sau khi lưu file; lệnh chuyển đối tượng, block definition và cố gắng xóa layer cũ. |
| `TNT_MIGRATE_SELECTION` | Chuyển layer V16 cho vùng chọn | Chọn các đối tượng cấp cao nhất cần chuyển; phù hợp khi không muốn xử lý toàn bản vẽ. |
| `TNT_MIGRATE_DIMSTYLE` | Chuyển Dimstyle cũ sang chuẩn mới | Chuyển `TNT_DIM`, `TNT_DIM1`, `TNT_DIM2` sang `.TNT_A_DIM_1`, `.TNT_A_DIM_2`, `.TNT_A_DIM_3` và cố gắng xóa style cũ. |

## Ghi chú an toàn

| Tình huống | Khuyến nghị |
|---|---|
| Lệnh không nhận | Chạy `0` hoặc `TNT_SHORTCUT`, kiểm tra file Lisp tương ứng đã được nạp. |
| Layer/style chuẩn chưa tồn tại | Chạy `0`, `TNT_SETTING` hoặc `TNT_LAYER` trước. |
| Xử lý hàng loạt block/layer | Lưu bản vẽ hoặc tạo bản sao trước khi dùng `B0`, `MAB`, `TNT_LAYER` và các lệnh `TNT_MIGRATE_*`. |
| Kết quả không đúng mong muốn | Dùng `UNDO` ngay sau lệnh; phần lớn lệnh TNT đã gom thao tác vào một nhóm Undo. |
