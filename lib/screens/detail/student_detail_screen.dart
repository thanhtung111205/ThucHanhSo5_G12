import 'package:flutter/material.dart';
import 'package:bai_th5/models/student.dart';
import 'package:bai_th5/models/subject.dart';
import 'package:bai_th5/utils/app_colors.dart';
import 'package:bai_th5/widgets/subject_row_item.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  List<Subject> _mockSubjects() {
    return [
      Subject(
        id: 's1',
        name: 'Cấu trúc dữ liệu và giải thuật nâng cao cho kỹ sư phần mềm',
        credits: 4,
        score: 8.7,
      ),
      Subject(
        id: 's2',
        name: 'Lập trình di động với Flutter',
        credits: 3,
        score: 9.1,
      ),
      Subject(id: 's3', name: 'Cơ sở dữ liệu phân tán', credits: 3, score: 8.2),
    ];
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _mockSubjects();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sinh viên'),
        actions: const [
          SizedBox(width: 80),

          /// TODO: Task 3 - Gắn nút Sửa và Xóa sinh viên vào đây
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem('Họ tên', student.name),
                        _buildInfoItem('Mã SV', student.studentCode),
                        _buildInfoItem('Ngày sinh', '--/--/---- (Placeholder)'),
                        _buildInfoItem('Ngành đào tạo', student.major),
                        _buildInfoItem(
                          'GPA tổng',
                          student.gpa.toStringAsFixed(2),
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildInfoItem('Họ tên', student.name),
                            _buildInfoItem('Mã SV', student.studentCode),
                            _buildInfoItem(
                              'Ngày sinh',
                              '--/--/---- (Placeholder)',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            _buildInfoItem('Ngành đào tạo', student.major),
                            _buildInfoItem(
                              'GPA tổng',
                              student.gpa.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'BẢNG ĐIỂM CHI TIẾT TOÀN KHÓA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 40),

                /// TODO: Task 4 - Gắn nút Thêm môn học vào đây
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text(
                            'STT',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Tên học phần',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 72,
                          child: Text(
                            'Số tín chỉ',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 84,
                          child: Text(
                            'Điểm tổng kết',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'Hành động',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(
                    subjects.length,
                    (index) => SubjectRowItem(
                      stt: index + 1,
                      subject: subjects[index],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
