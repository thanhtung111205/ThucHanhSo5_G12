import 'package:bai_th5/models/subject.dart';

class GpaCalculator {
  static double convertTo4Scale(double score) {
    if (score >= 8.5) return 4.0;
    if (score >= 7.0) return 3.0;
    if (score >= 5.5) return 2.0;
    if (score >= 4.0) return 1.0;
    return 0.0;
  }

  static double calculateGpa(List<Subject> subjects) {
    if (subjects.isEmpty) {
      return 0.0;
    }
    double totalPoints = 0;
    int totalCredits = 0;
    for (var subject in subjects) {
      totalPoints += convertTo4Scale(subject.score) * subject.credits;
      totalCredits += subject.credits;
    }
    return totalPoints / totalCredits;
  }
}
