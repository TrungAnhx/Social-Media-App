# Tài liệu chi tiết về Source Code - Social Media App

## Tổng quan

Đây là tài liệu chi tiết về cấu trúc và chức năng của ứng dụng Social Media được xây dựng bằng SwiftUI và Firebase. Ứng dụng cho phép người dùng tạo tài khoản, đăng nhập, đăng bài, tương tác và quản lý hồ sơ cá nhân.

## Kiến trúc ứng dụng

### 1. File khởi tạo ứng dụng

#### Social_MediaApp.swift
- **Chức năng**: Điểm nhập khẩu chính của ứng dụng
- **Khởi tạo Firebase**: Cấu hình Firebase khi ứng dụng khởi động
- **Cấu trúc**:
```swift
@main
struct Social_MediaApp: App {
    init() {
        FirebaseApp.configure()  // Khởi tạo Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()  // View chính
        }
    }
}
```

### 2. View điều hướng chính

#### ContentView.swift
- **Chức năng**: Điều hướng người dùng dựa trên trạng thái đăng nhập
- **Sử dụng `@AppStorage`**: Lưu trạng thái đăng nhập (`log_status`)
- **Luồng điều hướng**:
  - Nếu đã đăng nhập → `MainView()`
  - Nếu chưa đăng nhập → `LoginView()`

## 3. Models (Mô hình dữ liệu)

### User.swift
- **Chức năng**: Định nghĩa cấu trúc dữ liệu người dùng
- **Kế thừa**: `Identifiable`, `Codable`
- **Thuộc tính**:
  - `id`: ID duy nhất của document trong Firestore
  - `username`: Tên người dùng
  - `userBio`: Tiểu sử người dùng
  - `userBioLink`: Link trong tiểu sử
  - `userUID`: UID từ Firebase Authentication
  - `userEmail`: Email người dùng
  - `userProfileURL`: URL ảnh đại diện
- **Sử dụng `@DocumentID`**: Để tự động mapping với Firestore document ID

### Post.swift
- **Chức năng**: Định nghĩa cấu trúc dữ liệu bài đăng
- **Kế thừa**: `Identifiable`, `Codable`, `Equatable`, `Hashable`
- **Thuộc tính**:
  - `id`: ID duy nhất của document
  - `text`: Nội dung bài đăng
  - `imageURL`: URL hình ảnh (nếu có)
  - `imageReferenceID`: ID tham chiếu hình ảnh trong Firebase Storage
  - `publishedDate`: Ngày đăng bài
  - `likedIDs`: Mảng ID người dùng đã thích
  - `dislikedIDs`: Mảng ID người dùng không thích
  - `userName`: Tên người đăng
  - `userUID`: UID người đăng
  - `userProfileURL`: URL avatar người đăng

## 4. Views

### 4.1. Views Xác thực

#### LoginView.swift
- **Chức năng**: View đăng nhập người dùng
- **Quản lý trạng thái**:
  - `emailID`, `password`: Thông tin đăng nhập
  - `createAccount`: Chuyển đến view đăng ký
  - `showError`, `errorMessage`: Hiển thị lỗi
  - `isLoading`: Trạng thái loading
- **AppStorage**: Lưu thông tin người dùng sau khi đăng nhập thành công
- **Firebase Authentication**: Sử dụng `Auth.auth().signIn()`

#### RegisterView.swift
- **Chức năng**: View đăng ký người dùng mới
- **Quản lý trạng thái**:
  - Thông tin đăng ký: `emailID`, `password`, `userName`, `userBio`, `userBioLink`
  - `userProfilePicData`: Dữ liệu ảnh đại diện
  - `photoItem`: Ảnh từ Photos Picker
- **Quy trình đăng ký**:
  1. Tạo tài khoản Authentication
  2. Upload ảnh đại diện lên Storage
  3. Lưu thông tin người dùng vào Firestore

### 4.2. MainView

#### MainView.swift
- **Chức năng**: View chính với TabView sau khi đăng nhập
- **Tabs**:
  - `PostsView`: Tab xem và tạo bài đăng
  - `ProfileView`: Tab quản lý hồ sơ

### 4.3. PostsView và các thành phần liên quan

#### PostsView.swift
- **Chức năng**: Hiển thị danh sách bài đăng
- **Tính năng**:
  - Nút tạo bài đăng mới (floating action button)
  - Toolbar với tìm kiếm người dùng
  - Hiển thị `ReusablePostsView` với danh sách bài đăng
  - Full screen cover cho `CreateNewPost`

#### CreateNewPost.swift
- **Chức năng**: View tạo bài đăng mới
- **Tính năng**:
  - Nhập nội dung văn bản
  - Chọn hình ảnh từ Photos Picker
  - Upload hình ảnh lên Firebase Storage
  - Lưu bài đăng vào Firestore
  - Callback để thêm bài đăng mới vào danh sách

#### ReusablePostsView.swift
- **Chức năng**: Component hiển thị danh sách bài đăng có tái sử dụng
- **Đặc điểm**:
  - Sử dụng `@Binding` cho danh sách bài đăng
  - Hiển thị `PostCardView` cho từng bài đăng
  - Xử lý refresh để tải lại danh sách

#### PostCardView.swift
- **Chức năng**: Component hiển thị một bài đăng
- **Thành phần**:
  - Hiển thị thông tin người đăng
  - Nội dung bài đăng
  - Hình ảnh (nếu có)
  - Nút thích/bỏ thích
  - Nút xóa (chỉ cho tác giả)
- **Tương tác**:
  - Cập nhật likedIDs trong Firestore
  - Xóa bài đăng (chỉ tác giả)

#### SearchUserView.swift
- **Chức năng**: Tìm kiếm người dùng theo username
- **Hiển thị**:
  - Search bar
  - Danh sách người dùng kết quả tìm kiếm
  - Navigation đến profile khi click vào người dùng

### 4.4. ProfileView và các thành phần liên quan

#### ProfileView.swift
- **Chức năng**: Hiển thị và quản lý hồ sơ cá nhân
- **Tính năng**:
  - Hiển thị thông tin người dùng
  - Menu với các tùy chọn: Đăng xuất, Xóa tài khoản
  - Refreshable để cập nhật dữ liệu
- **Quản lý trạng thái**:
  - `myProfile`: Thông tin người dùng hiện tại
  - Xử lý đăng xuất và xóa tài khoản

#### ReusableProfileContent.swift
- **Chức năng**: Component hiển thị thông tin hồ sơ có tái sử dụng
- **Sử dụng trong**:
  - ProfileView (hồ sơ cá nhân)
  - Search results (xem hồ sơ người khác)
- **Thành phần**:
  - Ảnh đại diện
  - Tên người dùng
  - Tiểu sử
  - Link (nếu có)
  - Các bài đăng của người dùng

### 4.5. Helper Components

#### LoadingView.swift
- **Chức năng**: Component hiển thị loading overlay
- **Đặc điểm**:
  - Sử dụng `@Binding` để điều khiển hiển thị
  - Background mờ
  - ProgressView với background trắng

#### View+Extensions.swift
- **Chức năng**: Extensions cho View để tái sử dụng code
- **Các phương thức**:
  - `closeKeyboard()`: Đóng keyboard
  - `disableWithOpacity()`: Vô hiệu hóa với opacity
  - `hAlign()`: Căn chỉnh theo chiều ngang
  - `vAlign()`: Căn chỉnh theo chiều dọc
  - `border()`: Tạo border custom
  - `fillView()`: Tạo background custom

## 5. Luồng hoạt động của ứng dụng

### 5.1. Luồng đăng nhập
1. Người dùng mở ứng dụng → `ContentView`
2. Kiểm tra `log_status` trong `AppStorage`
3. Nếu chưa đăng nhập → Hiển thị `LoginView`
4. Người dùng nhập email/password → Xác thực với Firebase Auth
5. Thành công → Lưu thông tin vào `AppStorage` → Chuyển đến `MainView`

### 5.2. Luồng đăng ký
1. Người dùng click "Create Account" → `RegisterView`
2. Điền thông tin cá nhân và chọn ảnh
3. Submit → Tạo tài khoản Firebase Auth
4. Upload ảnh lên Firebase Storage
5. Lưu thông tin người dùng vào Firestore
6. Cập nhật `AppStorage` → Chuyển đến `MainView`

### 5.3. Luồng tạo bài đăng
1. Người dùng click nút "+" → `CreateNewPost`
2. Nhập nội dung và chọn hình ảnh (tùy chọn)
3. Upload hình ảnh lên Storage (nếu có)
4. Lưu bài đăng vào Firestore
5. Callback thêm bài đăng mới vào danh sách trong `PostsView`

### 5.4. Luồng tương tác bài đăng
1. Người dùng click thích/bỏ thích → Cập nhật `likedIDs` trong Firestore
2. Người dùng xóa bài đăng (chỉ tác giả) → Xóa document và ảnh trong Storage

## 6. Firebase Integration

### 6.1. Authentication
- Sử dụng Email/Password authentication
- Lưu UID vào Firestore để liên kết với profile

### 6.2. Firestore
- **Collections**:
  - `users`: Lưu trữ thông tin người dùng
  - `posts`: Lưu trữ bài đăng
- **Real-time updates**: Sử dụng listeners để cập nhật UI khi data thay đổi

### 6.3. Storage
- Lưu trữ ảnh đại diện người dùng
- Lưu trữ hình ảnh trong bài đăng
- Sử dụng UUID cho tên file để tránh trùng lặp

## 7. Quản lý trạng thái

### 7.1. Local State Management
- Sử dụng `@State` và `@StateObject` cho state trong View
- Sử dụng `@Binding` để chia sẻ state giữa Views

### 7.2. Persistent Storage
- `@AppStorage` cho các thông tin cần lưu lại:
  - `log_status`: Trạng thái đăng nhập
  - `user_profile_url`: URL avatar
  - `user_name`: Tên người dùng
  - `user_UID`: UID người dùng

## 8. Error Handling

### 8.1. Display Errors
- Sử dụng `Alert` để hiển thị lỗi
- State variables: `showError`, `errorMessage`

### 8.2. Common Error Cases
- Đăng nhập thất bại
- Đăng ký thất bại
- Upload ảnh thất bại
- Lưu/lấy dữ liệu từ Firestore thất bại

## 9. Best Practices và Patterns

### 9.1. MVVM Architecture
- Models: `User.swift`, `Post.swift`
- Views: Tất cả các file trong thư mục View/
- ViewModel được tích hợp trực tiếp trong Views (do quy mô nhỏ)

### 9.2. Code Reusability
- `ReusablePostsView`: Component hiển thị danh sách bài đăng
- `ReusableProfileContent`: Component hiển thị thông tin profile
- `View+Extensions`: Extensions để tái sử dụng code UI

### 9.3. Firebase Best Practices
- Sử dụng `@DocumentID` để auto-map document ID
- Cleanup storage resources khi xóa bài đăng
- Batch operations khi cần

## 10. Kế hoạch phát triển (Future Enhancements)

1. **Notifications**: Push notifications cho tương tác
2. **Real-time Chat**: Tính năng nhắn tin giữa người dùng
3. **Stories**: Tính năng story tự hủy sau 24 giờ
4. **Advanced Search**: Tìm kiếm nâng cao với filters
5. **Analytics**: Tích hợp analytics để tracking user behavior
6. **Performance Optimization**: Caching và pagination cho large datasets

## 11. Testing

- **Unit Tests**: Trong thư mục `Social MediaTests`
- **UI Tests**: Trong thư mục `Social MediaUITests`
- Nên mở rộng coverage cho các components chính

## 12. Security Considerations

1. **Data Validation**: Validate tất cả input từ user
2. **Firestore Rules**: Cấu hình security rules để protect data
3. **Authentication**: Đảm bảo chỉ authenticated users có thể truy cập protected resources
4. **Input Sanitization**: Prevent injection attacks khi lưu text content

## 13. Performance Optimization

1. **Image Optimization**: Compress images trước khi upload
2. **Lazy Loading**: Pagination cho danh sách bài đăng
3. **Caching**: Cache images và user data
4. **Efficient Queries**: Optimized Firestore queries với indexes

---

Tài liệu này cung cấp cái nhìn chi tiết về cấu trúc và hoạt động của ứng dụng Social Media. Để hiểu sâu hơn, nên đọc trực tiếp source code và chạy ứng dụng để trải nghiệm thực tế.
