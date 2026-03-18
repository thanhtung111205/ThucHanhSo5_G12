import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';
import 'student_provider.dart';

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

  // Đồng bộ GPA mới lên Firestore
  Future<void> _syncGpaWithFirestore(String studentId, StudentProvider studentProvider, Student currentStudent) async {
    final newGpa = calculateGpaByStudent(studentId);
    final updatedStudent = currentStudent.copyWith(gpa: newGpa);
    await studentProvider.updateStudent(updatedStudent);
  }

  // Thêm môn học
  Future<void> addSubject(String studentId, String name, int credits, double score, StudentProvider studentProvider, Student currentStudent) async {
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
    
    // Đồng bộ lên Firestore
    await _syncGpaWithFirestore(studentId, studentProvider, currentStudent);
  }

  // Cập nhật môn học
  Future<void> updateSubject(String studentId, String subjectId, String name, int credits, double score, StudentProvider studentProvider, Student currentStudent) async {
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
        
        // Đồng bộ lên Firestore
        await _syncGpaWithFirestore(studentId, studentProvider, currentStudent);
      }
    }
  }

  // Xóa môn học
  Future<void> deleteSubject(String studentId, String subjectId, StudentProvider studentProvider, Student currentStudent) async {
    final subjects = _studentSubjects[studentId];
    if (subjects != null) {
      subjects.removeWhere((s) => s.id == subjectId);
      notifyListeners();
      
      // Đồng bộ lên Firestore
      await _syncGpaWithFirestore(studentId, studentProvider, currentStudent);
    }
  }
}
