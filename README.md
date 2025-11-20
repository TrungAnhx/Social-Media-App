# Social Media App

Ứng dụng mạng xã hội được xây dựng bằng SwiftUI và Firebase, cho phép người dùng đăng ký, đăng nhập, tạo bài đăng, tìm kiếm người dùng và quản lý hồ sơ cá nhân.

## Tính năng chính

- 🔐 **Xác thực người dùng**: Đăng ký và đăng nhập với email/mật khẩu
- 👤 **Quản lý hồ sơ**: Cập nhật thông tin cá nhân, ảnh đại diện
- 📝 **Tạo bài đăng**: Chia sẻ văn bản và hình ảnh
- ❤️ **Tương tác**: Thích/bỏ thích bài đăng
- 🔍 **Tìm kiếm người dùng**: Tìm kiếm và xem hồ sơ người dùng khác
- 📱 **Giao diện hiện đại**: Thiết kế responsive với SwiftUI

## Công nghệ sử dụng

- **Frontend**: SwiftUI
- **Backend**: Firebase
  - Authentication (Xác thực)
  - Firestore (Database)
  - Storage (Lưu trữ hình ảnh)
- **Platform**: iOS

## Cấu trúc dự án

```
Social Media/
├── Social_MediaApp.swift     # File chính khởi tạo ứng dụng
├── ContentView.swift          # View chính điều hướng đăng nhập/đăng xuất
├── Model/                    # Các model dữ liệu
│   ├── User.swift           # Model người dùng
│   └── Post.swift           # Model bài đăng
└── View/                     # Các view của ứng dụng
    ├── Login/               # View đăng nhập & đăng ký
    ├── MainView/            # View chính sau khi đăng nhập
    │   ├── PostView/        # View quản lý bài đăng
    │   └── ProfileView/     # View quản lý hồ sơ
    └── Helpers/             # Các tiện ích mở rộng
```

## Hướng dẫn cài đặt

1. Clone dự án:
```bash
git clone <repository-url>
cd "Social-Media-App"
```

2. Mở project trong Xcode:
```bash
open "Social Media/Social Media.xcodeproj"
```

3. Cấu hình Firebase:
   - Tạo project mới trên [Firebase Console](https://console.firebase.google.com/)
   - Thêm ứng dụng iOS với Bundle Identifier phù hợp
   - Tải file `GoogleService-Info.plist` và thay thế file hiện có
   - Bật Authentication (Email/Password) và Firestore trong Firebase Console

4. Chạy ứng dụng:
   - Chọn simulator hoặc device
   - Nhấn Run (Cmd+R) trong Xcode

## Yêu cầu hệ thống

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Tác giả

- TrungAnhx
