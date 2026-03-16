# 📋 Task Assignment & Development Guidelines

## 👥 Chi Tiết Phân Công

### **Member 1: Student List Screen**
**Branch**: `feature/student-list`  
**Files to Implement**:
- `lib/views/student_list/student_list_screen.dart` - Main screen
- `lib/views/student_list/widgets/student_search_bar.dart` - Search widget
- `lib/views/student_list/widgets/student_filter_bar.dart` - Filter UI
- `lib/views/student_list/widgets/student_sort_menu.dart` - Sort menu
- `lib/views/student_list/widgets/student_list_view.dart` - List display
- `lib/views/student_list/widgets/empty_student_state.dart` - Empty state

**Responsibilities**:
1. Hiển thị danh sách sinh viên từ StudentProvider
2. Implement tìm kiếm theo tên/mã số
3. Implement filter theo lớp/khóa
4. Implement sort (A-Z, Z-A, mới nhất)
5. Navigate to detail/form screens
6. Pull-to-refresh functionality

**Dependencies on**:
- Student Model (Member 6)
- StudentProvider (Member 5)
- StudentCard widget (Member 6)

---

### **Member 2: Student Detail Screen**
**Branch**: `feature/student-detail`  
**Files to Implement**:
- `lib/views/student_detail/student_detail_screen.dart` - Detail view
- `lib/views/student_detail/widgets/student_info_section.dart` - Info display
- `lib/views/student_detail/widgets/student_action_buttons.dart` - Edit/Delete buttons

**Responsibilities**:
1. Hiển thị toàn bộ thông tin chi tiết của sinh viên
2. Button "Sửa" → navigate to form
3. Button "Xóa" → show confirm dialog
4. Button "Quay lại" → back to list
5. Responsive layout
6. Handle loading state

**Dependencies on**:
- Student Model (Member 6)
- StudentProvider (Member 5)
- ConfirmDeleteDialog (Member 6)

---

### **Member 3: Student Form Screen (Add & Edit)**
**Branch**: `feature/student-form`  
**Files to Implement**:
- `lib/views/student_form/student_form_screen.dart` - Unified form
- `lib/views/student_form/widgets/student_form_fields.dart` - Input fields
- `lib/views/student_form/widgets/student_form_actions.dart` - Save/Cancel buttons

**Responsibilities**:
1. Form for **Thêm Mới** (Add)
   - Empty form
   - Pre-fill title "Thêm Sinh Viên"
2. Form for **Sửa** (Edit)
   - Load student data into fields
   - Pre-fill title "Sửa Thông Tin"
3. Form Validation
   - Required fields
   - Name format validation
   - ID uniqueness check
4. Save button → Submit to provider
5. Cancel button → Back without saving
6. Error handling & success feedback

**Dependencies on**:
- Student Model (Member 6)
- StudentFormProvider (Member 5)
- Student Validators (Member 6)
- CustomTextField (Member 6)

---

### **Member 4: Services Layer (Data Access)**
**Branch**: `feature/data-services`  
**Files to Implement**:
- `lib/services/student_repository.dart` - Data repository interface
- `lib/services/local_storage_service.dart` - Local storage interface
- `lib/services/mock_api_service.dart` - Mock API for testing
- `lib/services/database/database_helper.dart` - SQLite helper
- `lib/services/database/student_dao.dart` - Data Access Object
- `lib/services/preferences/app_preferences_service.dart` - SharedPreferences

**Responsibilities**:
1. Implement **StudentRepository**
   - CRUD operations interface
2. Implement **DatabaseHelper**
   - SQLite initialization
   - Database schema (students table)
   - Connection management
3. Implement **StudentDAO**
   - All SQLite queries
   - Insert, Read, Update, Delete, Query
4. Implement **AppPreferencesService**
   - Store user preferences (sort, filter settings)
5. Implement **MockAPIService**
   - Mock data for initial testing
6. Error handling & data validation

**Database Schema**:
```dart
// students table
- id: String (PRIMARY KEY)
- name: String (NOT NULL)
- email: String
- phone: String
- class: String
- enrollmentDate: DateTime
- gpa: double
- createdAt: DateTime
- updatedAt: DateTime
```

**Dependencies on**:
- Student Model (Member 6)
- sqflite, shared_preferences packages

---

### **Member 5: State Management (Providers)**
**Branch**: `feature/state-management`  
**Files to Implement**:
- `lib/providers/student_provider.dart` - Main CRUD provider
- `lib/providers/student_form_provider.dart` - Form state provider
- `lib/providers/student_filter_provider.dart` - Filter/Sort state provider

**Responsibilities**:

#### **StudentProvider**
- Get all students
- Get student by ID
- Add student
- Update student
- Delete student
- Listen to data changes
- Handle errors

#### **StudentFormProvider**
- Form state management
- Validation logic
- Submit form
- Pre-fill form data
- Reset form
- Error messages

#### **StudentFilterProvider**
- Store search query
- Store filter criteria (class, enrollment date)
- Store sort option
- Apply filters
- Reset filters
- Persist preferences

**ChangeNotifier Methods**:
```dart
// StudentProvider
- Future<List<Student>> getAllStudents()
- Future<Student> getStudentById(String id)
- Future<void> addStudent(Student student)
- Future<void> updateStudent(Student student)
- Future<void> deleteStudent(String id)

// StudentFormProvider
- void setFormData(Student student)
- void resetForm()
- bool validateForm()
- Future<void> submitForm()

// StudentFilterProvider
- void setSearchQuery(String query)
- void setFilterClass(String className)
- void setSortOption(SortOption option)
- void resetFilters()
```

**Dependencies on**:
- Student Model (Member 6)
- StudentRepository (Member 4)
- provider package

---

### **Member 6: Models, Widgets & Utils**
**Branch**: `feature/models-utils`  
**Files to Implement**:

#### **Models**:
- `lib/models/student_model.dart` - Student data class
- `lib/models/student_filter_model.dart` - Filter criteria
- `lib/models/student_sort_option_model.dart` - Sort options

#### **Widgets**:
- `lib/widgets/student_card.dart` - Card showing student info
- `lib/widgets/custom_text_field.dart` - Custom text input
- `lib/widgets/custom_dropdown_field.dart` - Custom dropdown
- `lib/widgets/custom_button.dart` - Custom button
- `lib/widgets/confirm_delete_dialog.dart` - Delete confirmation
- `lib/widgets/loading_overlay.dart` - Loading indicator

#### **Utils**:
- `lib/utils/constants/app_constants.dart` - App constants
- `lib/utils/constants/db_constants.dart` - DB table/column names
- `lib/utils/constants/text_constants.dart` - UI text labels
- `lib/utils/theme/app_colors.dart` - Color palette
- `lib/utils/theme/app_text_styles.dart` - Typography
- `lib/utils/theme/app_theme.dart` - Theme data
- `lib/utils/validators/student_validators.dart` - Validation logic
- `lib/utils/extensions/string_extensions.dart` - String utilities

**Responsibilities**:

1. **student_model.dart**
   - Student class with fields (id, name, email, phone, class, GPA, etc.)
   - toJson/fromJson methods
   - copyWith method
   - equality implementation

2. **Widgets**
   - student_card: Display student summary
   - custom_text_field: Reusable text input with label/validation
   - custom_dropdown_field: Dropdown for class selection
   - custom_button: Reusable button widget
   - confirm_delete_dialog: Confirmation dialog
   - loading_overlay: Loading spinner overlay

3. **Constants**
   - DB table/column names
   - Error messages
   - Success messages
   - Label text

4. **Theme**
   - Primary colors
   - Text styles (heading, body, caption)
   - Theme brightness and styling

5. **Validators**
   - Email validation
   - Phone validation
   - Name validation
   - GPA validation
   - Required field validation

6. **Extensions**
   - String trimming/validation
   - Email/phone formatting

---

## 💻 Development Steps for Each Member

1. **Create local feature branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Start with Models & Constants** (if depends on them)
   ```bash
   # Member 6 should start first
   ```

3. **Then implement Services** (if depends on models)
   ```bash
   # Member 4 after Member 6
   ```

4. **Then implement Providers** (if depends on services)
   ```bash
   # Member 5 after Member 4
   ```

5. **Finally implement Views/Screens**
   ```bash
   # Members 1, 2, 3 last
   ```

6. **Test locally**
   ```bash
   flutter run
   ```

7. **Commit & Push**
   ```bash
   git add .
   git commit -m "feat: implement [feature-name]"
   git push origin feature/your-feature
   ```

8. **Create Pull Request for review**

---

## 📱 Feature Testing Checklist

After implementation, members should test:

### **Member 1 - Student List**
- [ ] Display all students
- [ ] Search functionality works
- [ ] Filter works
- [ ] Sort works
- [ ] Navigate to detail
- [ ] Navigate to add form
- [ ] Pull to refresh

### **Member 2 - Student Detail**
- [ ] Display correct student info
- [ ] Edit button navigates correctly
- [ ] Delete button shows confirmation
- [ ] Back button works
- [ ] Responsive layout

### **Member 3 - Student Form**
- [ ] Add form displays empty
- [ ] Edit form pre-fills data
- [ ] Validation works
- [ ] Save button submits
- [ ] Cancel button exits
- [ ] Success/error messages

### **Member 4 - Services**
- [ ] Database initializes
- [ ] CRUD operations work
- [ ] Data persists after app restart
- [ ] Mock API returns data

### **Member 5 - Providers**
- [ ] Provider notifies listeners
- [ ] State updates correctly
- [ ] Filters apply
- [ ] Sort works

### **Member 6 - Models & Widgets**
- [ ] Models serialize/deserialize
- [ ] Widgets render correctly
- [ ] Theme applies
- [ ] Validation works

---

## 🎯 Timeline Suggestion

| Week | Task |
|------|------|
| Week 1 | Models & Constants (Member 6) |
| Week 1-2 | Services (Member 4) |
| Week 2 | Providers (Member 5) |
| Week 2-3 | Views & Screens (Members 1, 2, 3) |
| Week 3 | Integration & Testing |
| Week 4 | Bug fixes & Optimization |

---

## 🤝 Communication

- Daily standup: Share progress & blockers
- Code review before merge
- Help each other when stuck
- Update task status regularly

**Good luck! 🚀**
