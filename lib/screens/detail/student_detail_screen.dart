import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bai_th5/models/student.dart';
import 'package:bai_th5/models/subject.dart';
import 'package:bai_th5/utils/app_colors.dart';
import 'package:bai_th5/widgets/subject_row_item.dart';
import 'package:bai_th5/widgets/student_form_dialog.dart';
import 'package:bai_th5/providers/student_provider.dart';
import 'package:bai_th5/screens/home/home_view_model.dart';
import 'package:bai_th5/providers/gpa_provider.dart';
import 'package:bai_th5/widgets/subject_form_dialog.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

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

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    final currentStudent = homeVM.students.firstWhere(
      (s) => s.id == student.id,
      orElse: () => student,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sinh viên'),
        actions: [
          IconButton(
            tooltip: 'Sửa thông tin',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<StudentProvider>(),
                  child: StudentFormDialog(student: currentStudent),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Xóa sinh viên',
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                  title: const Row(children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Xác nhận xóa'),
                  ]),
                  content: Text(
                    'Bạn có chắc chắn muốn xóa sinh viên "${currentStudent.name}" không? Hành động này không thể hoàn tác.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Hủy',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                final success = await context
                    .read<StudentProvider>()
                    .deleteStudent(currentStudent.id);
                if (context.mounted) {
                  _showSnackBar(
                    context, 
                    success ? '✓ Đã xóa sinh viên ${currentStudent.name}' : 'Xóa thất bại. Vui lòng thử lại.',
                    isError: !success
                  );
                  if (success) Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      ),
      body: Consumer<GpaProvider>(
        builder: (context, gpaProvider, child) {
          // Cập nhật: Sử dụng getSubjects và calculateGpa mới nhất từ Firestore/Local
          final subjects = gpaProvider.getSubjects(currentStudent);
          final gpa = gpaProvider.calculateGpa(currentStudent);
          final studentProvider = context.read<StudentProvider>();

          return SingleChildScrollView(
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
                            _buildInfoItem('Họ tên', currentStudent.name),
                            _buildInfoItem('Mã SV', currentStudent.studentCode),
                            _buildInfoItem(
                              'Ngày sinh',
                              currentStudent.dateOfBirth.isEmpty
                                  ? '--/--/----'
                                  : currentStudent.dateOfBirth,
                            ),
                            _buildInfoItem('Ngành đào tạo', currentStudent.major),
                            _buildInfoItem(
                              'GPA tổng kết',
                              gpa.toStringAsFixed(2),
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
                                _buildInfoItem('Họ tên', currentStudent.name),
                                _buildInfoItem('Mã SV', currentStudent.studentCode),
                                _buildInfoItem(
                                  'Ngày sinh',
                                  currentStudent.dateOfBirth.isEmpty
                                      ? '--/--/----'
                                      : currentStudent.dateOfBirth,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: [
                                _buildInfoItem('Ngành đào tạo', currentStudent.major),
                                _buildInfoItem(
                                  'GPA tổng kết (Hệ 10)',
                                  gpa.toStringAsFixed(2),
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
                  children: [
                    const Expanded(
                      child: Text(
                        'BẢNG ĐIỂM CHI TIẾT TOÀN KHÓA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => SubjectFormDialog(
                            onSave: (name, credits, score) async {
                              await gpaProvider.addSubject(currentStudent.id, name, credits, score, studentProvider, currentStudent);
                              if (context.mounted) {
                                _showSnackBar(context, 'Thêm môn học thành công');
                              }
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                      tooltip: 'Thêm môn học',
                    ),
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
                      if (subjects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Chưa có dữ liệu điểm'),
                        )
                      else
                        ...List.generate(
                          subjects.length,
                          (index) => SubjectRowItem(
                            stt: index + 1,
                            subject: subjects[index],
                            student: currentStudent,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
