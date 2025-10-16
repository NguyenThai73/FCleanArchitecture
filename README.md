# Flutter Base - Clean Architecture

Dự án Flutter được xây dựng theo Clean Architecture với BLoC pattern và Go Router.

## Cấu trúc dự án

```
lib/
├── core/                          # Core layer chứa các thành phần dùng chung
│   ├── constants/                 # Hằng số (API, Storage keys)
│   ├── di/                        # Dependency Injection
│   ├── errors/                    # Error handling (Failures, Exceptions)
│   ├── network/                   # Network client (Dio)
│   ├── usecases/                  # Base UseCase
│   └── utils/                     # Utilities (Validators)
│
├── features/                      # Features của ứng dụng
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer
│   │   │   ├── datasources/       # Remote & Local data sources
│   │   │   ├── models/            # Data models
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/                # Domain layer
│   │   │   ├── entities/          # Business entities
│   │   │   ├── repositories/      # Repository interfaces
│   │   │   └── usecases/          # Use cases
│   │   └── presentation/          # Presentation layer
│   │       ├── bloc/              # BLoC/Cubit
│   │       ├── pages/             # UI pages (Login, Register, Forgot Password)
│   │       └── widgets/           # Reusable widgets
│   │
│   ├── home/                      # Home feature
│   │   └── presentation/pages/
│   ├── favorites/                 # Favorites feature
│   │   └── presentation/pages/
│   ├── profile/                   # Profile/Account feature
│   │   └── presentation/pages/
│   └── main/                      # Main screen with Bottom Navigation
│       └── presentation/pages/
│
└── config/                        # Configuration
    ├── routes/                    # Go Router configuration
    └── theme/                     # Theme configuration
```

## Công nghệ sử dụng

- **State Management**: flutter_bloc (BLoC pattern)
- **Routing**: go_router
- **Dependency Injection**: get_it + injectable
- **Networking**: dio + retrofit
- **Local Storage**: shared_preferences
- **Functional Programming**: dartz
- **Code Generation**: build_runner + json_serializable

## Cài đặt

1. Clone repository:
```bash
git clone <repository_url>
cd flutter_base
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Generate code (models, DI):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Chạy ứng dụng:
```bash
flutter run
```

## Kiến trúc Clean Architecture

### Domain Layer
- **Entities**: Các đối tượng nghiệp vụ thuần túy
- **Repositories**: Interfaces định nghĩa cách lấy dữ liệu
- **Use Cases**: Các nghiệp vụ cụ thể của ứng dụng

### Data Layer
- **Models**: Chuyển đổi giữa JSON và Entities
- **Data Sources**: Remote (API) và Local (Cache)
- **Repository Implementations**: Implement các interfaces từ Domain

### Presentation Layer
- **BLoC/Cubit**: Quản lý state
- **Pages**: Các màn hình UI
- **Widgets**: Components tái sử dụng

## Tài khoản test

Ứng dụng đã được cấu hình với tài khoản test mặc định để development:

```
Email: admin@example.com
Password: 123456
```

**Lưu ý**:
- Tài khoản này sử dụng mock data, không gọi API thật
- Đăng ký tài khoản mới cũng sử dụng mock data
- Để sử dụng API thật, uncomment code trong `lib/features/auth/data/datasources/auth_remote_datasource.dart`

## Các chức năng hiện có

### Authentication
- Đăng nhập với validation
- Đăng ký tài khoản mới
- Quên mật khẩu
- Đăng xuất
- Mock authentication (không cần backend)

### Main Features
- **Bottom Navigation Bar** với 3 tabs:
  - **Trang chủ**: Hiển thị thông tin tổng quan về app
  - **Yêu thích**: Quản lý các mục yêu thích
  - **Tài khoản**: Thông tin cá nhân và cài đặt

### Profile/Account
- Hiển thị thông tin người dùng
- Chỉnh sửa hồ sơ
- Cài đặt thông báo
- Chế độ tối (Dark mode)
- Cài đặt ngôn ngữ
- Trợ giúp & Hỗ trợ
- Về ứng dụng

## Cấu hình API

Thay đổi base URL trong file `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'https://your-api-url.com/api/v1';
```

## Thêm feature mới

1. Tạo cấu trúc thư mục trong `lib/features/<feature_name>/`
2. Implement Domain layer (entities, repositories, use cases)
3. Implement Data layer (models, data sources, repositories)
4. Implement Presentation layer (bloc, pages, widgets)
5. Thêm routes trong `lib/config/routes/app_router.dart`
6. Run build_runner nếu có code generation

## Build runner commands

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (tự động generate khi có thay đổi)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Lưu ý

- Luôn chạy `build_runner` sau khi thêm hoặc sửa models có `@JsonSerializable()`
- Thêm annotation `@injectable` hoặc `@lazySingleton` cho các class cần inject
- Tuân thủ nguyên tắc Dependency Rule: Domain không phụ thuộc vào Data và Presentation

## License

MIT License
# FCleanArchitecture
