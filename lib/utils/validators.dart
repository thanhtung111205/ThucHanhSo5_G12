// ============================================================
// FILE: lib/utils/validators.dart
// TRÁCH NHIỆM: Chứa các hàm static dùng chung để validate form.
// Không chứa logic UI hay logic nghiệp vụ khác.
// ============================================================

import '../models/student.dart';

/// Tập hợp các hàm kiểm tra dữ liệu form (Validation).
class Validators {
  Validators._(); // Ngăn khởi tạo class

  // ─── Validators từ Task 1 (giữ nguyên) ────────────────────

  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Trường này không được để trống';
    }
    return null;
  }

  static String? validateNumber(String? value) {
    if (value == null || double.tryParse(value) == null) {
      return 'Vui lòng nhập một số hợp lệ';
    }
    return null;
  }

  // ─── Validators mới cho Task 3 ────────────────────────────

  /// Kiểm tra trường bắt buộc phải có giá trị.
  ///
  /// [value]     : Nội dung do người dùng nhập.
  /// [fieldName] : Tên trường hiển thị trong thông báo lỗi.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  /// Kiểm tra Mã Sinh Viên có hợp lệ và chưa tồn tại trong danh sách.
  ///
  /// [value]           : Mã SV do người dùng nhập.
  /// [currentStudents] : Danh sách sinh viên hiện có để kiểm tra trùng.
  /// [currentId]       : ID của sinh viên đang được chỉnh sửa (null nếu thêm mới).
  ///                     Được dùng để bỏ qua chính sinh viên đó khi kiểm tra trùng.
  static String? validateStudentCode(
    String? value,
    List<Student> currentStudents,
    String? currentId,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Mã sinh viên không được để trống';
    }

    final trimmed = value.trim();
    final isDuplicate = currentStudents.any(
      (s) => s.studentCode == trimmed && s.id != currentId,
    );

    if (isDuplicate) {
      return 'Mã sinh viên "$trimmed" đã tồn tại trong hệ thống';
    }

    return null;
  }
}
