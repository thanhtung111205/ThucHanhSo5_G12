import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/app_colors.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.onTap,
  });

  // Tính GPA thật sự từ danh sách môn học, nếu không có môn nào thì trả về 0.0
  double _calculateRealGpa() {
    if (student.subjects.isEmpty) return 0.0;
    
    double totalPoints = 0;
    int totalCredits = 0;
    
    for (var subject in student.subjects) {
      totalPoints += (subject.score * subject.credits);
      totalCredits += subject.credits;
    }
    
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  Color _gpaColor(double gpa) {
    if (gpa >= 3.5) return AppColors.gpaExcellent;
    if (gpa >= 3.0) return AppColors.gpaGood;
    if (gpa >= 2.0) return AppColors.gpaAverage;
    return AppColors.gpaPoor;
  }

  @override
  Widget build(BuildContext context) {
    final realGpa = _calculateRealGpa();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: AppColors.shadowColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: student.avatarUrl.isNotEmpty
                      ? NetworkImage(student.avatarUrl)
                      : null,
                  child: student.avatarUrl.isEmpty
                      ? Text(
                          student.name.isNotEmpty
                              ? student.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.badge_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(student.studentCode, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.school_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              student.major,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _gpaColor(realGpa).withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _gpaColor(realGpa).withAlpha(120)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        realGpa.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _gpaColor(realGpa),
                        ),
                      ),
                      Text(
                        'GPA',
                        style: TextStyle(
                          fontSize: 10,
                          color: _gpaColor(realGpa),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
