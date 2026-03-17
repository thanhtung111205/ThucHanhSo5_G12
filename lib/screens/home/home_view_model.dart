// ============================================================
// FILE: lib/screens/home/home_view_model.dart
// TRÁCH NHIỆM: ViewModel cho HomeScreen.
//   - Quản lý state: loading / error / data.
//   - Gọi StudentRepository để lấy dữ liệu từ Firestore.
//   - Không chứa bất kỳ Widget nào.
// ============================================================

import 'package:flutter/foundation.dart';
import '../../models/student.dart';
import '../../services/student_repository.dart';

/// [HomeViewModel] quản lý toàn bộ state của màn hình Home.
///
/// Sử dụng với Provider:
/// ```dart
/// ChangeNotifierProvider(
///   create: (_) => HomeViewModel()..fetchStudents(),
///   child: HomeScreen(),
/// )
/// ```
class HomeViewModel extends ChangeNotifier {
  // ─── Dependencies ─────────────────────────────────────────

  final StudentRepository _repository;

  HomeViewModel({StudentRepository? repository})
      : _repository = repository ?? StudentRepository();

  // ─── State variables ───────────────────────────────────────

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<Student> _students = [];

  // ─── Getters (read-only ngoài ViewModel) ──────────────────

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<Student> get students => List.unmodifiable(_students);

  // ─── Business logic ────────────────────────────────────────

  /// Fetch danh sách sinh viên từ Firestore.
  ///
  /// Lần đầu chạy: nếu collection rỗng, sẽ tự seed mock data
  /// lên Firestore để tiện test kết nối.
  Future<void> fetchStudents() async {
    // 1. Bật trạng thái loading
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      // 2. Seed nếu collection chưa có dữ liệu (chỉ chạy 1 lần)
      await _repository.seedIfEmpty();

      // 3. Lấy dữ liệu từ Firestore
      _students = await _repository.fetchAll();

      // 4. Tắt loading
      _isLoading = false;
    } catch (e) {
      // 5. Xử lý lỗi kết nối
      _isLoading = false;
      _hasError = true;
      _errorMessage =
          'Không thể kết nối Firestore. Kiểm tra internet hoặc cấu hình Firebase.\n\nChi tiết: $e';
    }

    notifyListeners();
  }
}
