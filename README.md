# 📚 Student Manager - Flutter Application

Ứng dụng quản lý thông tin sinh viên được xây dựng với **Flutter** sử dụng **Provider** Pattern và **MVC Architecture**.

## 🎯 Mục Tiêu Dự Án

- ✅ Quản lý danh sách sinh viên
- ✅ Tìm kiếm & lọc sinh viên
- ✅ Sắp xếp sinh viên (theo tên, mã số, etc.)
- ✅ Xem chi tiết sinh viên
- ✅ Thêm sinh viên mới
- ✅ Chỉnh sửa thông tin sinh viên
- ✅ Xóa sinh viên
- ✅ Lưu trữ dữ liệu cục bộ (SQLite/SharedPreferences)

## 🏗️ Kiến Trúc (Architecture)

### Pattern: **Provider + MVC**
- **Models**: Cấu trúc dữ liệu (Student, Filter, Sort)
- **Views**: Giao diện người dùng (Screens)
- **Providers**: Quản lý trạng thái (State Management)
- **Services**: Xử lý dữ liệu & logic business
- **Widgets**: Thành phần UI tái sử dụng

🔗 **Chi tiết cấu trúc**: Xem file [ARCHITECTURE.md](./ARCHITECTURE.md)

## 📂 Cấu Trúc Thư Mục

```
lib/
├── main.dart                      # Entry point
├── app.dart                       # App setup
├── models/                        # Data models
├── providers/                     # State management
├── services/                      # Business logic & data
├── views/                         # UI screens
│   ├── student_list/
│   ├── student_detail/
│   └── student_form/
├── widgets/                       # Reusable components
├── utils/                         # Constants, theme, validators
└── routes/                        # Navigation
```

## 👥 Phân Công Công Việc

| Thành viên | Công việc | Branch |
|-----------|----------|--------|
| Member 1 | Danh sách sinh viên | `feature/student-list` |
| Member 2 | Chi tiết sinh viên | `feature/student-detail` |
| Member 3 | Form thêm/sửa | `feature/student-form` |
| Member 4 | Lớp dữ liệu | `feature/data-services` |
| Member 5 | Quản lý trạng thái | `feature/state-management` |
| Member 6 | Models & Utils | `feature/models-utils` |

## 🚀 Bắt Đầu

### 1. Clone Repository
```bash
git clone [repository-url]
cd bai_th5
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Project
```bash
flutter run
```

### 4. Create Feature Branch
```bash
git checkout -b feature/[your-module]
```

## 📦 Dependencies

Xem file `pubspec.yaml` để biết danh sách đầy đủ các package được sử dụng.

**Chính yếu**:
- `provider`: State management
- `sqflite`: Local database
- `shared_preferences`: Preferences storage
- `dio`: HTTP client (nếu dùng API)

## 🔄 Git Workflow

1. **Tạo branch từ `main`**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature
   ```

2. **Commit thay đổi**
   ```bash
   git add .
   git commit -m "feat: your feature description"
   ```

3. **Push & Create PR**
   ```bash
   git push origin feature/your-feature
   ```

4. **Merge sau code review**

## 📝 Code Style

- Sử dụng `snake_case` cho tên file
- Sử dụng `PascalCase` cho class names
- Sử dụng `camelCase` cho variables/methods
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines

## 🐛 Troubleshooting

### Build Error
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Emulator Issues
```bash
flutter devices          # Check available devices
flutter run -d [device-id]
```

## 📚 Tài Liệu Tham Khảo

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Clean Code in Flutter](https://codewithandrea.com/)

## 📧 Liên Hệ & Hỗ Trợ

Nếu có thắc mắc, vui lòng liên hệ với leader hoặc mở issue trên repository.

---

**Project Status**: 🏗️ Under Development  
**Architecture**: Provider + MVC  
**Last Updated**: 16/03/2026
