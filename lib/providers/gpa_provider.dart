import 'package:flutter/material.dart';
import '../models/subject.dart';

class GpaProvider with ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => [..._subjects];

  // Getter gpa để dùng trong UI
  double get gpa => calculateGPA();

  // Tính tổng số tín chỉ
  int get totalCredits => _subjects.fold(0, (sum, item) => sum + item.credits);

  // Logic tính GPA realtime: Tổng (Điểm * Tín chỉ) / Tổng tín chỉ
  double calculateGPA() {
    if (_subjects.isEmpty) return 0.0;
    double totalPoints = _subjects.fold(0, (sum, item) => sum + (item.score * item.credits));
    return totalPoints / totalCredits;
  }

  // Thêm môn học mới
  void addSubject(String name, int credits, double score) {
    final newSub = Subject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      credits: credits,
      score: score,
    );
    _subjects.add(newSub);
    notifyListeners(); // Thông báo UI cập nhật realtime
  }

  // Cập nhật môn học hiện có
  void updateSubject(String id, String name, int credits, double score) {
    final index = _subjects.indexWhere((s) => s.id == id);
    if (index >= 0) {
      _subjects[index] = Subject(
        id: id,
        name: name,
        credits: credits,
        score: score,
      );
      notifyListeners();
    }
  }

  // Xóa môn học
  void deleteSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
