// ============================================================
// FILE: lib/providers/student_provider.dart
// TRÁCH NHIỆM: Thực hiện CRUD sinh viên lên Firestore thông qua
//   StudentRepository. Sau mỗi thao tác gọi refreshCallback để
//   HomeViewModel fetch lại danh sách mới nhất.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../services/student_repository.dart';

/// Provider xử lý các tác vụ CRUD sinh viên.
///
/// Cần được khởi tạo với [refreshCallback] – thường là
/// [HomeViewModel.fetchStudents] – để tự động làm mới danh sách
/// sau mỗi lần thêm / sửa / xóa.
class StudentProvider with ChangeNotifier {
  // ─── Dependencies ────────────────────────────────────────

  final StudentRepository _repository;

  /// Callback gọi sau mỗi thao tác CRUD thành công để
  /// HomeViewModel fetch lại dữ liệu từ Firestore.
  Future<void> Function()? refreshCallback;

  StudentProvider({
    StudentRepository? repository,
    this.refreshCallback,
  }) : _repository = repository ?? StudentRepository();

  /// Cập nhật callback từ ProxyProvider mà không tạo instance mới.
  void updateRefreshCallback(Future<void> Function() callback) {
    refreshCallback = callback;
  }

  // ─── State ───────────────────────────────────────────────

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Private helpers ─────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ─── CRUD – ghi thật lên Firestore ───────────────────────

  /// Thêm sinh viên mới lên Firestore.
  ///
  /// Trả về [true] nếu thành công, [false] nếu gặp lỗi.
  Future<bool> addStudent(Student student) async {
    try {
      _setLoading(true);
      await _repository.add(student);
      // Sau khi ghi xong → refresh HomeViewModel → UI cập nhật ngay
      await refreshCallback?.call();
      return true;
    } catch (e) {
      debugPrint('[StudentProvider] addStudent error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cập nhật thông tin sinh viên trên Firestore.
  ///
  /// Trả về [true] nếu thành công, [false] nếu gặp lỗi.
  Future<bool> updateStudent(Student student) async {
    try {
      _setLoading(true);
      await _repository.update(student);
      await refreshCallback?.call();
      return true;
    } catch (e) {
      debugPrint('[StudentProvider] updateStudent error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Xóa sinh viên khỏi Firestore theo [id].
  ///
  /// Trả về [true] nếu thành công, [false] nếu gặp lỗi.
  Future<bool> deleteStudent(String id) async {
    try {
      _setLoading(true);
      await _repository.delete(id);
      await refreshCallback?.call();
      return true;
    } catch (e) {
      debugPrint('[StudentProvider] deleteStudent error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
