# Hướng dẫn cài đặt AI Chat với Groq

## Tổng quan
Tính năng AI Chat đã được tích hợp vào ứng dụng quản lý thu chi, thay thế màn hình "Đánh giá" cũ. Tính năng này sử dụng Groq AI để cung cấp lời khuyên tài chính thông minh.

## Tính năng chính
- 🤖 Chat với AI tư vấn tài chính
- 💰 Phân tích dữ liệu chi tiêu thực tế
- 📊 Đưa ra lời khuyên cá nhân hóa
- 🎯 Câu hỏi gợi ý thông minh
- 💬 Giao diện chat hiện đại

## Cài đặt API Key

### Bước 1: Tạo tài khoản Groq
1. Truy cập [https://console.groq.com/](https://console.groq.com/)
2. Đăng ký tài khoản miễn phí
3. Xác thực email

### Bước 2: Lấy API Key
1. Đăng nhập vào Groq Console
2. Vào mục "API Keys"
3. Tạo API key mới
4. Sao chép API key

### Bước 3: Cấu hình trong ứng dụng
1. Mở file `lib/service/groq_ai_service.dart`
2. Tìm dòng:
   ```dart
   static const String _apiKey = 'gsk_YOUR_GROQ_API_KEY_HERE';
   ```
3. Thay thế `gsk_YOUR_GROQ_API_KEY_HERE` bằng API key thực tế của bạn:
   ```dart
   static const String _apiKey = 'gsk_abc123xyz...'; // API key của bạn
   ```

### Bước 4: Chạy ứng dụng
```bash
flutter pub get
flutter run
```

## Sử dụng tính năng

### Truy cập AI Chat
- Mở ứng dụng
- Chọn tab "AI Chat" ở bottom navigation
- Bắt đầu trò chuyện với AI

### Các câu hỏi mẫu
- "Tôi nên cắt giảm chi tiêu ở đâu?"
- "Làm sao để tiết kiệm hiệu quả?"
- "Chi tiêu của tôi có hợp lý không?"
- "Cách lập ngân sách chi tiêu?"

### Dữ liệu được phân tích
AI sẽ phân tích:
- Tổng thu nhập
- Tổng chi tiêu
- Số dư hiện tại
- Chi tiêu theo từng danh mục

## Lưu ý quan trọng

### Bảo mật
- Không chia sẻ API key với người khác
- Không commit API key lên Git
- Sử dụng environment variables trong production

### Chi phí
- Groq cung cấp tier miễn phí
- Chi phí rất thấp: ~$0.1-0.5 per 1M tokens
- Phù hợp cho sử dụng cá nhân

### Fallback
- Nếu không có API key, ứng dụng vẫn hoạt động
- Sẽ hiển thị lời khuyên mặc định
- Không ảnh hưởng đến các tính năng khác

## Khắc phục sự cố

### Lỗi API Key
```
🔑 Vui lòng cấu hình API key Groq để sử dụng tính năng này.
```
**Giải pháp**: Cấu hình API key theo hướng dẫn trên

### Lỗi kết nối
```
Xin lỗi, có lỗi xảy ra khi kết nối với AI.
```
**Giải pháp**: 
- Kiểm tra kết nối internet
- Xác minh API key đúng
- Thử lại sau vài phút

### Lỗi dependencies
```
Target of URI doesn't exist: 'package:groq/groq.dart'
```
**Giải pháp**:
```bash
flutter clean
flutter pub get
```

## Tùy chỉnh

### Thay đổi mô hình AI
Trong `groq_ai_service.dart`:
```dart
model: "llama-3.3-70b-versatile", // Mô hình mới thay thế llama-3.1-70b-versatile
```

Các mô hình khả dụng:
- `llama-3.3-70b-versatile` (khuyến nghị - thay thế cho llama-3.1-70b-versatile đã bị deprecated)
- `llama-3.1-8b-instant`
- `gemma-7b-it`
- `mixtral-8x7b-32768`

### Tùy chỉnh hướng dẫn AI
Sửa `setCustomInstructionsWith()` để thay đổi cách AI phản hồi.

## Hỗ trợ
Nếu gặp vấn đề, vui lòng:
1. Kiểm tra console logs
2. Xem file `AI_CHAT_SETUP.md` này
3. Liên hệ team phát triển 