// ============================================================
// FILE: lib/models/student.dart
// TRÁCH NHIỆM: Định nghĩa cấu trúc dữ liệu Student thuần tuý.
// Không chứa logic UI hay logic nghiệp vụ.
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

/// Model đại diện cho một sinh viên trong hệ thống.
class Student {
  /// Mã định danh duy nhất (UUID hoặc doc-id từ backend).
  final String id;

  /// Mã số sinh viên (VD: "2001215680").
  final String studentCode;

  /// Họ và tên đầy đủ.
  final String name;

  /// Chuyên ngành (VD: "Công nghệ Thông tin").
  final String major;

  /// Điểm trung bình tích lũy (GPA), thang 4.0.
  final double gpa;

  /// URL ảnh đại diện sinh viên.
  final String avatarUrl;

  const Student({
    required this.id,
    required this.studentCode,
    required this.name,
    required this.major,
    required this.gpa,
    required this.avatarUrl,
  });

  /// Factory constructor tạo một Student "rỗng" / mặc định.
  /// Dùng như giá trị khởi tạo khi chưa có dữ liệu.
  factory Student.empty() {
    return const Student(
      id: '',
      studentCode: '',
      name: '',
      major: '',
      gpa: 0.0,
      avatarUrl: '',
    );
  }

  /// Tạo bản sao Student với một số trường được thay đổi.
  Student copyWith({
    String? id,
    String? studentCode,
    String? name,
    String? major,
    double? gpa,
    String? avatarUrl,
  }) {
    return Student(
      id: id ?? this.id,
      studentCode: studentCode ?? this.studentCode,
      name: name ?? this.name,
      major: major ?? this.major,
      gpa: gpa ?? this.gpa,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  // ─── Firestore serialization ────────────────────────────────

  /// Tạo Student từ một Firestore document.
  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      studentCode: data['studentCode'] as String? ?? '',
      name: data['name'] as String? ?? '',
      major: data['major'] as String? ?? '',
      gpa: (data['gpa'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: data['avatarUrl'] as String? ?? '',
    );
  }

  /// Chuyển Student thành Map để lưu lên Firestore.
  /// Không bao gồm `id` vì đó là document ID trên Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'studentCode': studentCode,
      'name': name,
      'major': major,
      'gpa': gpa,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'Student(id: $id, code: $studentCode, name: $name, major: $major, gpa: $gpa)';
  }
}
