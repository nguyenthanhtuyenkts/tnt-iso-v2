# Danh mục bản vẽ — DM

1. APPLOAD `TNT_DANH_MUC_BAN_VE.lsp`. Với AutoCAD 2014, nạp file tương ứng trong `00.RELEASE 14`.
2. Chuyển sang Model, gõ `DM`. Chọn theo kiểu Fence: pick điểm đầu, rồi pick liên tiếp các điểm để vạch đường quét qua vùng khung của bìa và bản vẽ. Enter kết thúc chọn. Không cần vẽ LINE trước. Các đoạn quét hiện tạm, không tạo đối tượng trong bản vẽ; Esc hủy chọn.
3. Sau khi chọn Fence xong, hộp thoại mapping mới hiện bốn nội dung: nhãn cụm/bìa, số thứ tự, ký hiệu bản vẽ, tên bản vẽ. Danh sách TAG và nội dung mẫu chỉ lấy từ các block đã chọn qua đường quét. Chọn TAG để thêm vào mục tương ứng, hoặc nhập TAG trực tiếp trong ô bên dưới. Xóa TAG mặc định nếu không dùng. Nhấn OK để tiếp tục; Cancel không tạo bảng. Nếu không chọn được block có Attribute thì không mở hộp thoại.
4. Nhập chiều cao dòng theo đơn vị bản vẽ (mặc định 8), rồi chọn điểm chèn góc trên trái. Lisp tự chia mỗi dải tối đa 45 dòng nội dung, không hỏi số dòng nữa.
5. Kiểm tra các cảnh báo trên dòng lệnh (F2). Handle trong cảnh báo là handle block nguồn.

### Preview khi chọn Fence

- Sau mỗi điểm pick, toàn bộ đường Fence đã chọn được vẽ lại màu xanh lá.
- Các block khung/bìa đã nhận được tô sáng và có hình chữ nhật bao màu vàng. Đây là vùng Lisp dùng để xét giao với Fence, giúp phát hiện chọn nhầm khung lân cận.
- Dòng lệnh báo số khung/bìa mới và tổng số đã chọn. Khung đã chọn không bị đếm lại khi Fence đi qua lần nữa.
- Enter kết thúc chọn hoặc Esc hủy sẽ xóa đường preview, vùng bao và trạng thái tô sáng. Preview không tạo đối tượng LINE, không đổi màu hoặc layer của khung nguồn.
- Preview được vẽ lại sau mỗi lần pick; thao tác zoom/pan hoặc REGEN có thể làm mất nét preview tạm cho tới lần pick tiếp theo.

## Dữ liệu

### Pick Attribute trực tiếp để mapping

- Mỗi mục nhãn cụm, STT, ký hiệu và tên bản vẽ có nút **Pick Attribute**. Bấm nút để tạm đóng hộp thoại, rồi pick trực tiếp chữ Attribute trong khung/bìa đã chọn bằng Fence.
- Hộp thoại mở lại và gán TAG vừa pick vào mục tương ứng, thay danh sách TAG cũ của riêng mục đó. Các mục khác và nội dung đang nhập được giữ nguyên. Có thể thêm TAG bằng danh sách chọn hoặc sửa ô nhập như trước.
- Chỉ nhận Attribute thuộc các block đã chọn bằng Fence và có TAG trong danh sách ATTDEF được phép. Pick TEXT, đường khung hoặc Attribute ngoài phạm vi chọn sẽ báo trên dòng lệnh và giữ cấu hình cũ. Nhấn Enter hoặc Esc ở bước pick để trở lại hộp thoại.
- Attribute hằng hoặc ẩn không pick trực tiếp được có thể chọn bằng danh sách TAG. Pick chỉ đọc TAG, không sửa giá trị Attribute nguồn.

- Mapping chỉ liệt kê TAG của đối tượng Attribute Definition (`ATTDEF`) trực tiếp trong định nghĩa block khung/bìa đã chọn qua Fence. Block động đọc định nghĩa gốc theo `EffectiveName`. Không lấy TAG từ TEXT, MTEXT, block lồng, Xref hoặc Attribute rời không còn ATTDEF tương ứng. TAG nhập tay cũng phải thuộc danh sách ATTDEF này; cấu hình cũ được lọc lại theo các khung đang chọn.
- ATTDEF xác định TAG được phép mapping; nội dung mẫu và dữ liệu xuất vẫn lấy giá trị Attribute của từng block đã chèn, không lấy giá trị mặc định của ATTDEF.

- Bìa là block riêng có Attribute TAG `TITLE_KHUNG-HM`: tạo dòng nhãn gộp ba cột.
- Block khung tên có `STTBV_DOC`, `KHBV_DOC`, `TENBANVE_DOC`: tạo dòng STT / ký hiệu / tên.
- Các TAG trên là mặc định, có thể đổi trong hộp thoại. Khi bản vẽ có nhiều mẫu khung, nhập nhiều TAG cho cùng một nội dung, cách nhau bằng dấu phẩy, ví dụ `STTBV_DOC,SHEET_NO`. Lisp lấy giá trị không rỗng đầu tiên theo thứ tự từ trái sang phải; nếu tất cả rỗng sẽ báo thiếu dữ liệu. Một TAG chỉ được ánh xạ vào một nội dung. Lisp nhớ cấu hình đã xác nhận trong phiên bản vẽ hiện tại, không sửa Attribute nguồn.
- Đọc Attribute trực tiếp trên block reference trong Model, bao gồm Attribute hằng. Chưa đọc block lồng hoặc Xref.
- Giữ nguyên nội dung Attribute và số 0 đầu; không đánh lại STT, không sửa dữ liệu nguồn.
- Mỗi khung chỉ lấy một lần trong một lượt lệnh. Cụm tiếp tục qua đoạn quét kế tiếp đến khi gặp bìa mới.
- Thứ tự theo chiều vạch Fence từ điểm đầu, lần lượt từng đoạn, không theo STT. Các khung có cùng vị trí giao cần kiểm tra thứ tự thực tế.

## Bảng và giới hạn

- Tiêu đề tổng dùng text style `.TNT_A_TXT_1_MAIN`; nhãn cụm và ba tiêu đề cột (STT, ký hiệu, tên bản vẽ) dùng `.TNT_A_TXT_2_SUB`; dữ liệu bản vẽ dùng `.TNT_A_TXT_3_NOTE`. Bản vẽ cần có đủ ba style này; nếu thiếu, DM báo tên style và dừng để tránh tự đoán font.
- Tên bản vẽ được chuyển về một dòng nội dung: mã xuống đoạn `\P`, ký tự xuống dòng thật và tab được thay bằng khoảng trắng; khoảng trắng liên tiếp được gộp. Ví dụ `MẶT BẰNG \PĐỊNH VỊ THỬA ĐẤT` thành `MẶT BẰNG ĐỊNH VỊ THỬA ĐẤT`. Chỉ xử lý nội dung xuất ra, không sửa Attribute nguồn. Chữ vẫn có thể tự xuống dòng nếu cột hẹp.
- Khung TABLE nằm trên layer `....03_TNT_A_THIN`. Nội dung là các MTEXT riêng trên layer `....20_TNT_N_TEXT` để tách layer chữ khỏi khung. Layer thiếu được tạo mới, màu đối tượng đặt ByLayer. Chữ không nằm trong ô TABLE: sửa chữ bằng MTEXT, và khi di chuyển bảng cần chọn cả khung lẫn chữ.

- Tạo các đối tượng TABLE đặt cạnh nhau từ trái sang phải. Dải 1 chứa dòng nội dung 1–45, dải 2 chứa 46–90, dải 3 chứa 91–135, dải 4 bắt đầu từ 136; tiếp tục tương tự. Đúng 45 dòng chưa tạo dải thứ hai; dòng 46 mới mở dải mới.
- Mỗi dải đều có đủ ba tiêu đề cột **STT | KÍ HIỆU BẢN VẼ | TÊN BẢN VẼ**, dùng style `.TNT_A_TXT_2_SUB`. Tiêu đề tổng và hàng tiêu đề cột không tính vào 45 dòng; nhãn cụm có tính một dòng nội dung. Ngắt đúng mốc 45 dòng, kể cả khi nhãn cụm ở dòng cuối dải. Dải tiếp theo không tự lặp nhãn cụm.
- Nhận diện giao đường quét theo hình chữ nhật bao block trên mặt phẳng XY của WCS. Block xoay, có hình học/Attribute nằm xa khung có thể làm vùng bao rộng; nên kiểm tra và vạch Fence tránh vùng bao khung lân cận. Đây là thao tác pick chuỗi điểm với đường kéo cao su, chưa hỗ trợ giữ chuột kéo tự do (lasso).
- Bảng dùng table style hiện tại. Font của style cần hỗ trợ nội dung Attribute. Chữ dài có thể xuống dòng và cần chỉnh chiều rộng/chiều cao sau khi tạo.
- Báo thiếu dữ liệu, bản vẽ trước bìa và STT/ký hiệu trùng; vẫn giữ dòng để người dùng kiểm tra.
- Undo một lần để hủy đợt tạo bảng. Chạy lại DM tạo bảng mới; chưa có lệnh cập nhật bảng cũ.

## Kiểm tra phiên bản

Đã kiểm tra cân bằng ngoặc/chuỗi và nguồn ASCII; chạy đồng bộ Release14 và chế độ `-Check`. Nguồn không dùng lệnh hoặc system variable mới hơn 2014; phần bảng dùng ActiveX TABLE, hộp thoại dùng DCL tiêu chuẩn được tạo tạm và xóa sau khi đóng.

Chưa xác nhận runtime. Lần thử AutoCAD 2014 Core Console ngày 10/11/2026 không khởi chạy được vì `FATAL ERROR: Problem with setting up current profile.` Bộ thử trong `1.WORK/ACAD2014_TEST/dmbv_test.lsp` cần chạy trên bản vẽ trống, không lưu, để kiểm tra hình học và tạo TABLE khi môi trường AutoCAD hoạt động.
