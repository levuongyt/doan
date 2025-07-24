# Ứng dụng quản lí thu chi cá nhân

## Yêu cầu hệ thống
- Flutter : 3.29.2
- Dart : 3.7.2


## Mô tả dự án: Ứng dụng quản lí thu chi cá nhân
- Ứng dụng quản lí thu chi cá nhân giúp người dùng quản lí, theo dõi tài chính, dòng tiền và các khoản thu nhập, chi tiêu cá nhân. Kết hợp AI chat để hỗ trợ tư vấn, đưa ra các gợi ý chi tiêu, đầu tư hiệu quả. Kiểm soát được các giao dịch cũng như thống kê, báo cáo. Từ đó, nắm rõ được tình hình tài chính cá nhân để có thể đưa ra được quyết định chi tiêu và quản lí dòng tiền một cách hiệu quả.

### Các tính năng chính của ứng dụng:

### 1, Quản lí đăng nhập:
- Đăng nhập, đăng ký bằng Firebase.
- Đăng nhập bằng email và cho phép người dùng đăng nhập bằng tài khoản Google.
- Lưu thông tin tài khoản.
- Quên mật khẩu (Cho phép ngcười dùng đặt lại mật khẩu bằng email đã đăng ký).

### 2, Quản lí thu nhập và chi tiêu:
- Ghi nhận các giao dịch thu nhập và chi tiêu của người dùng và được phân loại theo từng danh mục thu nhập,chi tiêu cụ thể (tiền lương, thưởng, ăn uống, mua sắm ...).
- Tính toán, hiển thị số tiền giao dịch, số dư hiện tại sau mỗi giao dịch và tổng số dư để giúp người dùng nắm được tình hình tài chính của mình.

### 3, Theo dõi giao dịch:
- Hiển thị lịch sử các giao dịch thu nhập và chi tiêu của người dùng.
- Tra cứu, hiển thị, lọc các giao dịch thu nhập, chi chiêu theo ngày giao dịch cụ thể.

### 4, AI chat:
- Trò chuyện, hỗ trợ tư vấn tài chính. Đưa ra phướng án, cách tối ưu, phân bổ , đầu tư dòng tiền một cách hợp lí ...
- Đề xuất cách tiết kiệm, điều chỉnh thói quen sử dụng dòng tiền hiệu quả.

### 5, Quản lí danh mục:
- Người dùng có thể thêm các danh mục mới tùy theo nhu cầu sử dụng với các biểu tượng và màu sắc đa dạng.
- Người dùng có thể tùy chỉnh các danh mục sẵn có như thay đổi tên, biểu tượng, màu sắc.
- Có thể xóa các danh mục thu nhập và thu chi.

### 6, Thống kê,báo cáo:
- Hiển thị biểu đồ thống kê thu nhập và chi tiêu theo tháng (dạng cột và biểu đồ tròn).
- Hiển thị biểu đồ hình cột thống kê tổng thu nhập và tổng chi tiêu theo tháng ở màn hình Tổng quan.
- Hiển thị biểu đồ tròn thống kê tổng thu nhập và chi tiêu của từng danh mục có giao dịch theo tháng.
- Tính toán tổng thu nhập,tổng chi tiêu trong tháng và trung bình thu chi trên ngày.
- Thống kê, hiển thị chi tiết các giao dịch theo từng danh mục trong tháng.

### 7, Quản lí tài khoản người dùng:
- Hiển thị thông tin tài khoản người dùng (tên tài khoản, email).
- Cho phép người dùng tùy chỉnh thông tin cá nhân (chỉnh sửa tên tài khoản, chọn ảnh đại diện).
- Đặt lại mật khẩu thông qua việc gửi link reset mật khẩu qua email đăng ký tài khoản.

### 8, Cài đặt:
- Hỗ trợ nhiều ngôn ngữ.
- Thay đổi tiền tệ (VND, USD, EUR, Yên Nhật ).
- Nhắc nhở, thông báo ghi chép giao dịch.
- Cho phép người dùng tùy chỉnh giao diện sáng/tối.

## Giao diện ứng dụng:

### Giới thiệu

![image](https://github.com/user-attachments/assets/d807ea82-8f88-4313-a090-406f13e4787a)

### Đăng nhập, Đăng ký, Quên mật khẩu

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/95924196-73b0-419e-8087-09946bfa681a" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/607e581e-3888-4d06-82fa-8e498780f70f" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/2c7582a0-319d-4bd6-874f-c7984cefbaba" />

### Tổng quan

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/645b5b1c-803b-4f81-997a-853b0c3767a3" />


### Nhập liệu (Nhập giao dịch thu nhập, chi tiêu)

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/441ab227-eead-4823-a73a-9eddc530cd21" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/77ea3943-4561-41ee-805c-76516b2d2277" />

### AI chat (hỗ trợ, tư vấn tài chính)

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/e3d7ea1a-cba1-48d0-bdbd-83ecac673144" />

### Danh mục

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/406adc04-e2b7-44d2-8378-cfbe2bcedac9" />



### Thêm, sửa, xóa danh mục

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/b37caaa2-afdc-4066-966a-f16e4e515040" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/065bc617-b878-4ff0-a710-831b0b6557bd" />

### Báo cáo (Báo cáo thu nhập, chi tiêu)

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/e3a96faf-a813-4adb-bcda-8a825d3ea52f" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/ec5b4ce5-bfb7-452b-aac4-5958f72cbacd" />

### Chi tiết báo cáo (theo danh mục giao dịch trong tháng)


<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/0c12bfd5-a0d5-496c-a843-31fe3c59c724" />

### Tài khoản

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/619ce45d-6294-4003-9d96-bb0f7b9e0a89" />

### Cài đặt

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/604d8e1a-eeba-4894-8558-693c15d1c104" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/3b7ae419-872a-4416-955b-a8c988da9518" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/f96d44a7-d3f5-4622-9400-79ee9efa1fe2" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/74425521-b5fe-45bd-88e8-e8dc3edebbf9" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/2a006454-347d-4012-b6eb-d24621cbf28c" />

<img width="360" height="800" alt="Image" src="https://github.com/user-attachments/assets/27d284e8-3062-4de1-831a-847a3d894c7a" />














