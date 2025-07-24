# doan_ql_thu_chi

## Yêu cầu hệ thống
- Flutter : 3.24.1
- Dart : 3.5.1

## Cấu hình API Keys

### Groq AI API Key (Cho tính năng AI Chat)
Để sử dụng tính năng AI chat, bạn cần:
1. Đăng ký tài khoản tại [Groq Console](https://console.groq.com/)
2. Tạo API key
3. Chạy ứng dụng với API key:

```bash
flutter run --dart-define=GROQ_API_KEY=your_groq_api_key_here
```

Hoặc tạo file `launch.json` trong `.vscode/` để debug:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=GROQ_API_KEY=your_groq_api_key_here"
            ]
        }
    ]
}
```

**Build APK:**
```bash
flutter build apk --dart-define=GROQ_API_KEY=your_api_key
```

LINK YOUTUBE DEMO ĐỒ ÁN QUẢN LÝ THU CHI CÁ NHÂN: https://youtu.be/1H5t6fOrrEA

LINK SLIDE: https://sg.docworkspace.com/d/sIKqYktGQAbHnursG

## Mô tả dự án: Ứng dụng quản lí thu chi cá nhân
- Ứng dụng quản lí thu chi cá nhân giúp người dùng quản lí, theo dõi tài chính, dòng tiền và các khoản thu nhập, chi tiêu cá nhân. Kiểm soát được các giao dịch cũng như thống kê, báo cáo. Từ đó, nắm rõ được tình hình tài chính cá nhân để có thể đưa ra được quyết định chi tiêu và quản lí dòng tiền một cách hiệu quả.

Các tính năng chính của ứng dụng:

1, Quản lí đăng nhập:
- Đăng nhập, đăng ký bằng Firebase.
- Đăng nhập bằng email và cho phép người dùng đăng nhập bằng tài khoản Google.
- Lưu thông tin tài khoản.
- Quên mật khẩu (Cho phép người dùng đặt lại mật khẩu bằng email đã đăng ký).

2, Quản lí thu nhập và chi tiêu:
- Ghi nhận các giao dịch thu nhập và chi tiêu của người dùng và được phân loại theo từng danh mục thu nhập,chi tiêu cụ thể (tiền lương, thưởng, ăn uống, mua sắm ...).
- Tính toán, hiển thị số tiền giao dịch, số dư hiện tại sau mỗi giao dịch và tổng số dư để giúp người dùng nắm được tình hình tài chính của mình.

3, Theo dõi giao dịch:
- Hiển thị lịch sử các giao dịch thu nhập và chi tiêu của người dùng.
- Tra cứu, hiển thị, lọc các giao dịch thu nhập, chi chiêu theo ngày giao dịch cụ thể.

4, AI chat:
- Trò chuyện, hỗ trợ tư vấn tài chính. Đưa ra phướng án, cách tối ưu, phân bổ , đầu tư dòng tiền một cách hợp lí ...
- Đề xuất cách tiết kiệm, điều chỉnh thói quen sử dụng dòng tiền hiệu quả.

5, Quản lí danh mục:
- Người dùng có thể thêm các danh mục mới tùy theo nhu cầu sử dụng với các biểu tượng và màu sắc đa dạng.
- Người dùng có thể tùy chỉnh các danh mục sẵn có như thay đổi tên, biểu tượng, màu sắc.
- Có thể xóa các danh mục thu nhập và thu chi.

6, Thống kê,báo cáo:
- Hiển thị biểu đồ thống kê thu nhập và chi tiêu theo tháng (dạng cột và biểu đồ tròn).
- Hiển thị biểu đồ hình cột thống kê tổng thu nhập và tổng chi tiêu theo tháng ở màn hình Tổng quan.
- Hiển thị biểu đồ tròn thống kê tổng thu nhập và chi tiêu của từng danh mục có giao dịch theo tháng.
- Tính toán tổng thu nhập,tổng chi tiêu trong tháng và trung bình thu chi trên ngày.
- Thống kê, hiển thị chi tiết các giao dịch theo từng danh mục trong tháng.

7, Quản lí tài khoản người dùng:
- Hiển thị thông tin tài khoản người dùng (tên tài khoản, email).
- Cho phép người dùng tùy chỉnh thông tin cá nhân (chỉnh sửa tên tài khoản, chọn ảnh đại diện).
- Đặt lại mật khẩu thông qua việc gửi link reset mật khẩu qua email đăng ký tài khoản.

8, Cài đặt:
- Hỗ trợ nhiều ngôn ngữ.
- Thay đổi tiền tệ (VND, USD, EUR, Yên Nhật ).
- Nhắc nhở, thông báo ghi chép giao dịch.
- Cho phép người dùng tùy chỉnh giao diện sáng/tối.

## Giao diện ứng dụng:

### Giới thiệu

![image](https://github.com/user-attachments/assets/d807ea82-8f88-4313-a090-406f13e4787a)

### Đăng nhập, Đăng ký, Quên mật khẩu

![image](https://github.com/user-attachments/assets/526fe46c-9022-422c-bddd-a1485aec4e72)
![image](https://github.com/user-attachments/assets/0a065e25-ba61-4e7b-ba5a-2d443134a980)
![image](https://github.com/user-attachments/assets/7de7a84a-f4b7-4e7e-bca3-f5a93cb5f399)

### Tổng quan

![image](https://github.com/user-attachments/assets/3fd454d1-e16b-462e-a211-c9c6f5eda47a)

### Nhập liệu (Nhập giao dịch thu nhập, chi tiêu)

![image](https://github.com/user-attachments/assets/f973942f-3e85-4651-ba81-fd438b042eeb)
![image](https://github.com/user-attachments/assets/2fb1bea8-5c9b-4db1-a46f-36327f86a954)

### AI chat (hỗ trợ, tư vấn tài chính)

![image](https://github.com/user-attachments/assets/e3d7ea1a-cba1-48d0-bdbd-83ecac673144)

### Danh mục

![image](https://github.com/user-attachments/assets/83db8a64-3ad6-40fa-9878-c66fdb18d6f8)

### Thêm, sửa, xóa danh mục

![image](https://github.com/user-attachments/assets/4ad24779-1ee5-4d2f-b5f8-319867d6bc6b)
![image](https://github.com/user-attachments/assets/cee5feaf-4bc2-464f-be08-b2e5fe1fc3a7)

### Báo cáo (Báo cáo thu nhập, chi tiêu)

![image](https://github.com/user-attachments/assets/54123008-a5ba-42b4-bb01-fafe4df9300f)
![image](https://github.com/user-attachments/assets/463f9122-6d0b-44f5-8b35-71474517af09)

### Chi tiết báo cáo (theo danh mục giao dịch trong tháng)

![image](https://github.com/user-attachments/assets/a5ff473d-cb9a-4039-a3b6-294d278d1112)

### Tài khoản

![image](https://github.com/user-attachments/assets/1604610a-f4cc-49c6-a53b-4160321340ee)

### Cài đặt

![image](https://github.com/user-attachments/assets/f867b74d-46f8-4829-853a-2f61ac49104a)














