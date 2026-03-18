import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';
import 'student_provider.dart';

class GpaProvider with ChangeNotifier {
  // Map lưu trữ danh sách môn học theo ID sinh viên để quản lý state cục bộ
  final Map<String, List<Subject>> _studentSubjects = {};

  // Lấy danh sách môn học: Ưu tiên lấy từ Firestore (thông qua đối tượng student) 
  // Nếu local state có thay đổi mới nhất thì dùng local state
  List<Subject> getSubjects(Student student) {
    if (_studentSubjects.containsKey(student.id)) {
      return [..._studentSubjects[student.id]!];
    }
    return student.subjects;
  }

  // Tính GPA realtime dựa trên danh sách hiện tại
  double calculateGpa(Student student) {
    final subjects = getSubjects(student);
    if (subjects.isEmpty) return 0.0;
    
    double totalPoints = subjects.fold(0, (sum, item) => sum + (item.score * item.credits));
    int totalCredits = subjects.fold(0, (sum, item) => sum + item.credits);
    
    return totalPoints / totalCredits;
  }

  // Đồng bộ toàn bộ danh sách môn học và GPA lên Firestore
  Future<void> _syncWithFirestore(String studentId, StudentProvider studentProvider, Student currentStudent) async {
    final subjects = _studentSubjects[studentId] ?? [];
    final newGpa = calculateGpa(currentStudent.copyWith(subjects: subjects));
    
    final updatedStudent = currentStudent.copyWith(
      subjects: subjects,
      gpa: newGpa,
    );
    
    await studentProvider.updateStudent(updatedStudent);
  }

  // Khởi tạo dữ liệu local từ Firestore khi bắt đầu tương tác
  void initFromFirestore(Student student) {
    if (!_studentSubjects.containsKey(student.id)) {
      _studentSubjects[student.id] = [...student.subjects];
    }
  }

  // Thêm môn học
  Future<void> addSubject(String studentId, String name, int credits, double score, StudentProvider studentProvider, Student currentStudent) async {
    initFromFirestore(currentStudent);
    
    final newSub = Subject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      credits: credits,
      score: score,
    );
    
    _studentSubjects[studentId]!.add(newSub);
    notifyListeners();
    
    await _syncWithFirestore(studentId, studentProvider, currentStudent);
  }

  // Cập nhật môn học
  Future<void> updateSubject(String studentId, String subjectId, String name, int credits, double score, StudentProvider studentProvider, Student currentStudent) async {
    initFromFirestore(currentStudent);
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
        await _syncWithFirestore(studentId, studentProvider, currentStudent);
      }
    }
  }

  // Xóa môn học
  Future<void> deleteSubject(String studentId, String subjectId, StudentProvider studentProvider, Student currentStudent) async {
    initFromFirestore(currentStudent);
    final subjects = _studentSubjects[studentId];
    
    if (subjects != null) {
      subjects.removeWhere((s) => s.id == subjectId);
      notifyListeners();
      await _syncWithFirestore(studentId, studentProvider, currentStudent);
    }
  }
}
