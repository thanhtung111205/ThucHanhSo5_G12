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
  List<Student> _allStudents = [];
  List<Student> _students = [];

  // Filter state
  String _searchText = '';
  String? _selectedMajor;
  String? _selectedGpaRange;

  // ─── Getters (read-only ngoài ViewModel) ──────────────────

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<Student> get students => List.unmodifiable(_students);

  /// Lấy danh sách ngành độc nhất từ tất cả sinh viên
  List<String> get uniqueMajors {
    final majors = _allStudents.map((s) => s.major).toSet().toList();
    majors.sort();
    return majors;
  }
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
      _allStudents = await _repository.fetchAll();
      _applyFilters();

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

  /// Lọc danh sách theo tên hoặc mã SV (realtime)
  void filterBySearch(String searchText) {
    _searchText = searchText.toLowerCase();
    _applyFilters();
  }

  /// Lọc danh sách theo ngành học
  void filterByMajor(String? major) {
    _selectedMajor = major;
    _applyFilters();
  }

  /// Lọc danh sách theo khoảng GPA
  void filterByGpaRange(String? gpaRange) {
    _selectedGpaRange = gpaRange;
    _applyFilters();
  }

  /// Áp dụng tất cả các bộ lọc vào danh sách (core logic)
  void _applyFilters() {
    _students = _allStudents.where((student) {
      // 1. Lọc theo tìm kiếm (name + studentCode)
      final matchesSearch =
          _searchText.isEmpty ||
          student.name.toLowerCase().contains(_searchText) ||
          student.studentCode.toLowerCase().contains(_searchText);

      // 2. Lọc theo ngành
      final matchesMajor =
          _selectedMajor == null || student.major == _selectedMajor;

      // 3. Lọc theo khoảng GPA
      final matchesGpa =
          _selectedGpaRange == null ||
          _isInGpaRange(student.gpa, _selectedGpaRange!);

      return matchesSearch && matchesMajor && matchesGpa;
    }).toList();

    notifyListeners();
  }

  /// Kiểm tra xem GPA có nằm trong khoảng không
  bool _isInGpaRange(double gpa, String range) {
    final parts = range.split(' - ');
    if (parts.length != 2) return true; // Or handle error

    try {
      final lowerBound = double.parse(parts[0]);
      final upperBound = double.parse(parts[1]);

      // Make the range inclusive for the upper bound in the highest bracket
      if (upperBound == 4.0) {
        return gpa >= lowerBound && gpa <= upperBound;
      }

      return gpa >= lowerBound && gpa < upperBound;
    } catch (e) {
      return true; // Or handle parsing error
    }
  }
}
