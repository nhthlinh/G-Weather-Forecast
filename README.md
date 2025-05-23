# G Weather Forecast - Bài test thực tập sinh Flutter tại Golden Owl

## Thông tin cá nhân

- **Họ và tên:** Nguyễn Hà Thùy Linh 
- **Năm sinh:** 2004
- **Email:** [linhnguyen.8023@gmail.com](mailto:linhnguyen.8023@gmail.com)

## Mô tả ứng dụng web:

- **Tên ứng dụng:** G Weather Forecast
- **Demo:** 
- **Mô tả:** G Weather Forecast cho phép người dùng **tìm kiếm thời tiết theo thành phố/quốc gia**, hiển thị thông tin **hiện tại (nhiệt độ, gió, độ ẩm)** và **dự báo 4+ ngày tới**. Ứng dụng cũng **lưu lịch sử tìm kiếm tạm thời** và có tính năng **đăng ký/hủy nhận dự báo hàng ngày qua email**, yêu cầu **xác nhận email** để đảm bảo.

## Cấu trúc project

- Kiến trúc project: **MVVM**
- Một số thư viện sử dụng:
    - **Dio:** Thực hiện các request API.
    - **Hive:** Lưu trữ dữ liệu local.
    - **Dart_ipify:** Lấy IP của người dùng.
    - **Firebase:** Gửi mail thông báo thời tiết hàng ngày và xác thực email. Deploy ứng dụng.

## Mô tả hướng dẫn sử dụng:

- **Trang chủ:** Hiển thị thời tiết hiện tại của thành phố mặc định sẽ lấy theo vị trí của người
  dùng thông qua IP.
    - **Chức năng:**
        - Xem thời tiết hiện tại.
        - Xem dự báo thời tiết 4 ngày tiếp theo.
        - Chọn thành phố khác để xem thời tiết.
          Khi nhập tên thành phố vào ô tìm kiếm sẽ được gợi ý các thành phố có tên tương tự.
        - Lưu lại thành phố đã xem trong ngày.
        - Đăng ký và hủy nhận thông báo qua email về thời tiết hàng ngày.
        - Tự động gửi mail về thời tiết mỗi ngày.

## Demo ứng dụng
