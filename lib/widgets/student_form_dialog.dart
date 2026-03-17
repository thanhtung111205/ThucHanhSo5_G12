// ============================================================
// FILE: lib/widgets/student_form_dialog.dart
// TRÁCH NHIỆM: Form nhập liệu dưới dạng Dialog để Thêm / Sửa sinh viên.
// Không chứa logic fetch dữ liệu – chỉ giao tiếp qua StudentProvider.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../providers/student_provider.dart';
import '../screens/home/home_view_model.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';

/// Dialog nhập liệu sinh viên.
///
/// - Nếu [student] == null → chế độ **THÊM MỚI**.
/// - Nếu [student] != null → chế độ **SỬA** (điền sẵn dữ liệu).
class StudentFormDialog extends StatefulWidget {
  final Student? student;

  const StudentFormDialog({super.key, this.student});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  // ─── Form key & Controllers ───────────────────────────────

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _dateController;

  // ─── Dropdown state ───────────────────────────────────────

  static const List<String> _majors = [
    'Công nghệ Thông tin',
    'Kỹ thuật Phần mềm',
    'Hệ thống Thông tin',
    'Khoa học Máy tính',
    'An toàn Thông tin',
    'Trí tuệ Nhân tạo',
  ];

  String? _selectedMajor;
  DateTime? _selectedDate;
  bool _isSaving = false;

  // ─── Lifecycle ────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final s = widget.student;

    // Điền sẵn dữ liệu khi đang ở chế độ Sửa
    _nameController = TextEditingController(text: s?.name ?? '');
    _codeController = TextEditingController(text: s?.studentCode ?? '');

    // Cập nhật ngày sinh (dateOfBirth)
    _dateController = TextEditingController(text: s?.dateOfBirth ?? '');
    _selectedMajor = (s != null && _majors.contains(s.major)) ? s.major : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────

  bool get _isEditMode => widget.student != null;

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  /// Mở Date Picker và cập nhật controller.
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1970),
      lastDate: now,
      helpText: 'Chọn ngày sinh',
      confirmText: 'Chọn',
      cancelText: 'Hủy',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // ─── Submit logic ─────────────────────────────────────────

  Future<void> _handleSave() async {
    // 1. Validate tất cả các trường
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedMajor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngành đào tạo'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final provider = context.read<StudentProvider>();

    // 2. Tạo object Student từ dữ liệu form
    final student = Student(
      // Khi thêm mới, id để trống – provider/repository sẽ tự sinh ID mới.
      id: widget.student?.id ?? '',
      studentCode: _codeController.text.trim(),
      name: _nameController.text.trim(),
      major: _selectedMajor!,
      // Ngày sinh
      dateOfBirth: _dateController.text.trim(),
      // GPA giữ nguyên khi sửa, mặc định 0.0 khi thêm mới
      gpa: widget.student?.gpa ?? 0.0,
      avatarUrl: widget.student?.avatarUrl ?? '',
    );

    // 3. Gọi Provider thực hiện CRUD
    final bool success = _isEditMode
        ? await provider.updateStudent(student)
        : await provider.addStudent(student);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      // 4. Hiện SnackBar thành công màu xanh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? '✓ Cập nhật sinh viên thành công!'
                : '✓ Thêm sinh viên thành công!',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // 5. Đóng dialog
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra. Vui lòng thử lại.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ─── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            _isEditMode ? Icons.edit_outlined : Icons.person_add_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            _isEditMode ? 'Sửa thông tin sinh viên' : 'Thêm sinh viên mới',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Họ và tên ──────────────────────────────
                _buildLabel('Họ và tên *'),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    hint: 'VD: Nguyễn Văn An',
                    icon: Icons.person_outline,
                  ),
                  validator: (v) => Validators.validateRequired(v, 'Họ và tên'),
                ),
                const SizedBox(height: 16),

                // ── Mã Sinh Viên ───────────────────────────
                _buildLabel('Mã sinh viên *'),
                Consumer<HomeViewModel>(
                  builder: (context, homeVM, _) {
                    return TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        hint: 'VD: 2001215001',
                        icon: Icons.badge_outlined,
                      ),
                      validator: (v) => Validators.validateStudentCode(
                        v,
                        homeVM.students, // Lấy danh sách từ HomeViewModel
                        widget.student?.id,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ── Ngày sinh ──────────────────────────────
                _buildLabel('Ngày sinh'),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: _inputDecoration(
                    hint: 'Chọn ngày sinh',
                    icon: Icons.calendar_today_outlined,
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Ngành đào tạo ──────────────────────────
                _buildLabel('Ngành đào tạo *'),
                DropdownButtonFormField<String>(
                  value: _selectedMajor,
                  isExpanded: true,
                  decoration: _inputDecoration(
                    hint: 'Chọn ngành đào tạo',
                    icon: Icons.school_outlined,
                  ),
                  items: _majors
                      .map(
                        (major) => DropdownMenuItem(
                          value: major,
                          child: Text(major),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedMajor = value),
                  validator: (v) =>
                      v == null ? 'Vui lòng chọn ngành đào tạo' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        // ── Nút Hủy ────────────────────────────────────────
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text(
            'Hủy',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),

        // ── Nút Lưu ────────────────────────────────────────
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // ─── Widget helpers ───────────────────────────────────────

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
