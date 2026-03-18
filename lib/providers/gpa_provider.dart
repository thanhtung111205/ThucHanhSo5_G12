import 'package:flutter/material.dart';
import '../models/subject.dart';

class GpaProvider with ChangeNotifier {
  // Map lưu trữ danh sách môn học theo ID sinh viên
  final Map<String, List<Subject>> _studentSubjects = {};

  // Lấy danh sách môn học của một sinh viên cụ thể
  List<Subject> getSubjectsByStudent(String studentId) {
    return [...(_studentSubjects[studentId] ?? [])];
  }

  // Tính GPA cho một sinh viên cụ thể
  double calculateGpaByStudent(String studentId) {
    final subjects = _studentSubjects[studentId] ?? [];
    if (subjects.isEmpty) return 0.0;
    
    double totalPoints = subjects.fold(0, (sum, item) => sum + (item.score * item.credits));
    int totalCredits = subjects.fold(0, (sum, item) => sum + item.credits);
    
    return totalPoints / totalCredits;
  }

  // Thêm môn học cho một sinh viên
  void addSubject(String studentId, String name, int credits, double score) {
    if (!_studentSubjects.containsKey(studentId)) {
      _studentSubjects[studentId] = [];
    }
    
    final newSub = Subject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      credits: credits,
      score: score,
    );
    
    _studentSubjects[studentId]!.add(newSub);
    notifyListeners();
  }

  // Cập nhật môn học
  void updateSubject(String studentId, String subjectId, String name, int credits, double score) {
    final subjects = _studentSubjects[studentId];
    if (subjects != null) {
      final index = subjects.indexWhere((s) => s.id == subjectId);
      if (index >= 0) {
        subjects[index] = Subject(
          id: subjectId,
          name: name,
          credits: credits,
          score: score,
        );
        notifyListeners();
      }
    }
  }

  // Xóa môn học
  void deleteSubject(String studentId, String subjectId) {
    final subjects = _studentSubjects[studentId];
    if (subjects != null) {
      subjects.removeWhere((s) => s.id == subjectId);
      notifyListeners();
    }
  }
}
