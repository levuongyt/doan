# Ứng dụng Quản lý Thu Chi

## Cài đặt

1. Clone repository:
```bash
git clone <repository-url>
cd doan
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Cấu hình API Keys:

### Groq AI API Key
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

## Chạy ứng dụng

```bash
flutter run --dart-define=GROQ_API_KEY=your_api_key
```

## Build APK

```bash
flutter build apk --dart-define=GROQ_API_KEY=your_api_key
```

## Lưu ý bảo mật

- Không bao giờ commit API keys vào Git
- Sử dụng environment variables cho production
- File `.env` đã được thêm vào `.gitignore`














