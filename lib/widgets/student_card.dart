// ============================================================
// FILE: lib/widgets/student_card.dart
// TRÁCH NHIỆM: Widget thuần View – hiển thị thông tin 1 sinh viên.
//
// ⚠️  RANH GIỚI TRÁCH NHIỆM:
//   ✅ Được phép: Render UI, style, hiển thị dữ liệu từ Student.
//   ❌ TUYỆT ĐỐI KHÔNG Navigator.push/pop (người số 2 làm navigation).
//   ❌ TUYỆT ĐỐI KHÔNG bọc Dismissible (người khác làm swipe-to-delete).
//   ✅ onTap callback phải được inject từ bên ngoài.
// ============================================================

import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/app_colors.dart';

/// Widget hiển thị thông tin tóm tắt của một sinh viên.
///
/// Sử dụng:
/// ```dart
/// StudentCard(
///   student: student,
///   onTap: () {
///     // [Người số 2] xử lý navigation tại đây, KHÔNG viết ở đây.
///     Navigator.push(context, ...);
///   },
/// )
/// ```
class StudentCard extends StatelessWidget {
  final Student student;

  // ⚠️ RANH GIỚI: callback điều hướng phải truyền từ ngoài,
  // KHÔNG tự Navigator.push bên trong widget này.
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.onTap,
  });

  /// Trả về màu badge GPA tương ứng với mức điểm.
  Color _gpaColor(double gpa) {
    if (gpa >= 3.5) return AppColors.gpaExcellent;
    if (gpa >= 3.0) return AppColors.gpaGood;
    if (gpa >= 2.0) return AppColors.gpaAverage;
    return AppColors.gpaPoor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: AppColors.shadowColor,
        child: InkWell(
          // ⚠️ RANH GIỚI: onTap được inject từ HomeScreen (hoặc màn hình cha).
          // KHÔNG tự xử lý navigation tại đây.
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ─── Avatar ────────────────────────────────────────
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

                // ─── Thông tin chính ───────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sinh viên – tối đa 2 dòng
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

                      // Mã sinh viên
                      Row(
                        children: [
                          const Icon(
                            Icons.badge_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            student.studentCode,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Chuyên ngành
                      Row(
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              student.major,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // ─── GPA Badge ─────────────────────────────────────
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _gpaColor(student.gpa).withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _gpaColor(student.gpa).withAlpha(120),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        student.gpa.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _gpaColor(student.gpa),
                        ),
                      ),
                      Text(
                        'GPA',
                        style: TextStyle(
                          fontSize: 10,
                          color: _gpaColor(student.gpa),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Arrow icon ────────────────────────────────────
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
