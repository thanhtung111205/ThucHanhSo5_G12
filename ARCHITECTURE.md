# 📱 Student Manager - Architecture & Project Structure

## 📂 Cấu Trúc Thư Mục (lib/)

```
lib/
├── main.dart                              # Entry point
├── app.dart                               # App configuration
├── models/
│   ├── student_model.dart                # Student data model
│   ├── student_filter_model.dart         # Filter criteria model
│   └── student_sort_option_model.dart    # Sort options model
├── providers/
│   ├── student_provider.dart             # State management - CRUD operations
│   ├── student_form_provider.dart        # State management - Form handling
│   └── student_filter_provider.dart      # State management - Filter/Sort logic
├── services/
│   ├── student_repository.dart           # Data repository layer
│   ├── local_storage_service.dart        # Local storage interface
│   ├── mock_api_service.dart             # Mock API for testing
│   ├── database/
│   │   ├── database_helper.dart          # SQLite helper
│   │   └── student_dao.dart              # Data Access Object
│   └── preferences/
│       └── app_preferences_service.dart  # SharedPreferences handler
├── views/
│   ├── student_list/
│   │   ├── student_list_screen.dart      # Main list screen
│   │   └── widgets/
│   │       ├── student_search_bar.dart   # Search functionality
│   │       ├── student_filter_bar.dart   # Filter UI
│   │       ├── student_sort_menu.dart    # Sort menu
│   │       ├── student_list_view.dart    # List display
│   │       └── empty_student_state.dart  # Empty state UI
│   ├── student_detail/
│   │   ├── student_detail_screen.dart    # Student details view
│   │   └── widgets/
│   │       ├── student_info_section.dart # Info display
│   │       └── student_action_buttons.dart # Action buttons
│   └── student_form/
│       ├── student_form_screen.dart      # Add/Edit form (unified)
│       └── widgets/
│           ├── student_form_fields.dart  # Form input fields
│           └── student_form_actions.dart # Save/Cancel buttons
├── widgets/
│   ├── student_card.dart                 # Reusable student card
│   ├── custom_text_field.dart            # Custom text input
│   ├── custom_dropdown_field.dart        # Custom dropdown
│   ├── custom_button.dart                # Custom button
│   ├── confirm_delete_dialog.dart        # Delete confirmation
│   └── loading_overlay.dart              # Loading indicator
├── utils/
│   ├── constants/
│   │   ├── app_constants.dart            # App-wide constants
│   │   ├── db_constants.dart             # Database constants
│   │   └── text_constants.dart           # UI text constants
│   ├── theme/
│   │   ├── app_colors.dart               # Color palette
│   │   ├── app_text_styles.dart          # Typography
│   │   └── app_theme.dart                # Theme configuration
│   ├── validators/
│   │   └── student_validators.dart       # Input validation logic
│   └── extensions/
│       └── string_extensions.dart        # String utility extensions
└── routes/
    └── app_routes.dart                   # Navigation routes
```

## 🏗️ Architecture Pattern: Provider + MVC

### Layers:
- **Models**: Data structures (`student_model.dart`)
- **Views**: UI screens (`views/student_list/`, `views/student_detail/`, `views/student_form/`)
- **Providers**: State management logic (`providers/*_provider.dart`)
- **Services**: Business logic & data access (`services/*`)
- **Widgets**: Reusable UI components (`widgets/`)
- **Utils**: Constants, themes, validators

## ✨ Core Features Supported

| Feature | Location | Status |
|---------|----------|--------|
| **View List** | `views/student_list/` | Ready |
| **Search** | `views/student_list/widgets/student_search_bar.dart` | Ready |
| **Filter** | `views/student_list/widgets/student_filter_bar.dart` | Ready |
| **Sort** | `views/student_list/widgets/student_sort_menu.dart` | Ready |
| **Create** | `views/student_form/student_form_screen.dart` | Ready |
| **Read** | `views/student_detail/student_detail_screen.dart` | Ready |
| **Update** | `views/student_form/student_form_screen.dart` | Ready |
| **Delete** | `widgets/confirm_delete_dialog.dart` | Ready |

## 👥 Team Task Assignment (Branching Strategy)

Each team member should work on their assigned module and create feature branches:

| Member | Module | Branches | Responsibilities |
|--------|--------|----------|------------------|
| **Member 1** | Student List | `feature/student-list` | Implement `student_list_screen.dart` + all widgets in `student_list/widgets/` |
| **Member 2** | Student Detail | `feature/student-detail` | Implement `student_detail_screen.dart` + detail widgets |
| **Member 3** | Student Form | `feature/student-form` | Implement `student_form_screen.dart` (Add/Edit unified) + form widgets |
| **Member 4** | Data Layer | `feature/data-services` | Implement `services/` layer (Repository, API, Database, Preferences) |
| **Member 5** | State Management | `feature/state-management` | Implement `providers/` (StudentProvider, FormProvider, FilterProvider) |
| **Member 6** | Models & Utils | `feature/models-utils` | Implement `models/` + `utils/` (constants, theme, validators) |

## 🔄 Development Workflow

1. **Each member creates a feature branch**:
   ```bash
   git checkout -b feature/[your-module]
   ```

2. **Implement the assigned files** (no code yet, structure only)

3. **Make commits after completing features**:
   ```bash
   git add .
   git commit -m "feat: implement [module-name]"
   ```

4. **Create Pull Requests** for code review before merging to `main`

5. **Resolve merge conflicts** if they arise

## 📦 Dependencies (pubspec.yaml addons suggested)

```yaml
# State Management
provider: ^6.0.0

# Database & Local Storage
sqflite: ^2.0.0
shared_preferences: ^2.0.0

# HTTP Client (if using real API)
dio: ^5.0.0

# Validation
validators: ^3.0.0

# Date & Time
intl: ^0.18.0
```

## 🎯 Next Steps

1. ✅ Create structure (DONE)
2. ⏳ Each member creates their feature branch
3. ⏳ Implement models and constants first
4. ⏳ Implement providers (state management)
5. ⏳ Implement services (data layer)
6. ⏳ Implement views and widgets
7. ⏳ Connect everything and test
8. ⏳ Integration & final testing

---

**Project**: Student Manager  
**Pattern**: Provider + MVC  
**Created**: 2026-03-16  
**Status**: Structure Ready ✓
