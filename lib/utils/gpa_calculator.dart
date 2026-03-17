import 'package:ThucHanhSo5_G12/models/subject.dart';

class GpaCalculator {
  static double calculateGpa(List<Subject> subjects) {
    if (subjects.isEmpty) {
      return 0.0;
    }
    double totalPoints = 0;
    int totalCredits = 0;
    for (var subject in subjects) {
      totalPoints += subject.score * subject.credits;
      totalCredits += subject.credits;
    }
    return totalPoints / totalCredits;
  }
}
