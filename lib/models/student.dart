import 'package:cloud_firestore/cloud_firestore.dart';
import 'subject.dart';

class Student {
  final String id;
  final String studentCode;
  final String name;
  final String major;
  final String dateOfBirth;
  final double gpa;
  final String avatarUrl;
  final List<Subject> subjects;

  const Student({
    required this.id,
    required this.studentCode,
    required this.name,
    required this.major,
    required this.dateOfBirth,
    required this.gpa,
    required this.avatarUrl,
    this.subjects = const [],
  });

  factory Student.empty() {
    return const Student(
      id: '', studentCode: '', name: '', major: '', 
      dateOfBirth: '', gpa: 0.0, avatarUrl: '', subjects: [],
    );
  }

  Student copyWith({
    String? id, String? studentCode, String? name, String? major,
    String? dateOfBirth, double? gpa, String? avatarUrl, List<Subject>? subjects,
  }) {
    return Student(
      id: id ?? this.id,
      studentCode: studentCode ?? this.studentCode,
      name: name ?? this.name,
      major: major ?? this.major,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gpa: gpa ?? this.gpa,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      subjects: subjects ?? this.subjects,
    );
  }

  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Ép kiểu cực kỳ an toàn cho List
    List<Subject> subjectsList = [];
    if (data['subjects'] != null && data['subjects'] is List) {
      subjectsList = (data['subjects'] as List).map((item) {
        return Subject.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    }

    return Student(
      id: doc.id,
      studentCode: data['studentCode']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      major: data['major']?.toString() ?? '',
      dateOfBirth: data['dateOfBirth']?.toString() ?? '',
      gpa: (data['gpa'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: data['avatarUrl']?.toString() ?? '',
      subjects: subjectsList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentCode': studentCode,
      'name': name,
      'major': major,
      'dateOfBirth': dateOfBirth,
      'gpa': gpa,
      'avatarUrl': avatarUrl,
      'subjects': subjects.map((s) => s.toMap()).toList(),
    };
  }
}
