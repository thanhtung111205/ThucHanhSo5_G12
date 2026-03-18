// lib/models/subject.dart
class Subject {
  final String id;
  final String name;
  final int credits;
  final double score;

  Subject({
    required this.id,
    required this.name,
    required this.credits,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'credits': credits,
      'score': score,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      // Ép kiểu an toàn từ num (Firestore có thể trả về int hoặc double)
      credits: (map['credits'] as num?)?.toInt() ?? 0,
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
