// ============================================================
// FILE: lib/services/student_repository.dart
// TRÁCH NHIỆM: Tầng truy cập dữ liệu – giao tiếp với Firestore.
//   - Đọc collection "students" từ Firestore.
//   - Seed mock data nếu collection rỗng (để test kết nối).
//   - HomeViewModel gọi file này thay vì dùng mock data nội bộ.
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

/// Repository duy nhất truy cập Firestore cho entity Student.
///
/// Sử dụng:
/// ```dart
/// final repo = StudentRepository();
/// final students = await repo.fetchAll();
/// ```
class StudentRepository {
  // Tên collection trên Firestore
  static const String _collection = 'students';

  final FirebaseFirestore _db;

  /// Cho phép inject FirebaseFirestore (dễ mock khi test).
  StudentRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  // ─── READ ─────────────────────────────────────────────────

  /// Lấy toàn bộ danh sách sinh viên từ Firestore.
  /// Trả về [] nếu collection rỗng.
  Future<List<Student>> fetchAll() async {
    final snapshot = await _db.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Student.fromFirestore(doc))
        .toList();
  }

  // ─── SEED (chỉ dùng để test kết nối DB) ───────────────────

  /// Upload mock data lên Firestore nếu collection đang rỗng.
  /// Gọi một lần để seed, sau đó Firestore đã có dữ liệu.
  Future<void> seedIfEmpty() async {
    final snapshot =
        await _db.collection(_collection).limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Đã có data, bỏ qua

    final batch = _db.batch();
    for (final student in _mockStudents) {
      final ref = _db.collection(_collection).doc(student.id);
      batch.set(ref, student.toFirestore());
    }
    await batch.commit();
  }

  // ─── Mock data dùng để seed lên Firestore ─────────────────
  static final List<Student> _mockStudents = [
    const Student(
      id: 'sv001',
      studentCode: '2001215680',
      name: 'Nguyễn Văn An',
      major: 'Công nghệ Thông tin',
      gpa: 3.72,
      avatarUrl: '',
    ),
    const Student(
      id: 'sv002',
      studentCode: '2001215701',
      name: 'Trần Thị Bích Ngọc',
      major: 'Kỹ thuật Phần mềm',
      gpa: 3.45,
      avatarUrl: '',
    ),
    const Student(
      id: 'sv003',
      studentCode: '2001215733',
      name: 'Lê Hoàng Dũng',
      major: 'Hệ thống Thông tin',
      gpa: 2.88,
      avatarUrl: '',
    ),
    const Student(
      id: 'sv004',
      studentCode: '2001215759',
      name: 'Phạm Minh Khôi',
      major: 'An toàn Thông tin',
      gpa: 3.91,
      avatarUrl: '',
    ),
    const Student(
      id: 'sv005',
      studentCode: '2001215812',
      name: 'Đỗ Thị Thanh Huyền',
      major: 'Công nghệ Thông tin',
      gpa: 2.15,
      avatarUrl: '',
    ),
  ];
}
