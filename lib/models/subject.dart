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

  // Tính GPA của riêng môn này (thường là điểm số luôn, nhưng có thể map sang hệ 4 nếu cần)
  double get subjectGpa => score;
}
