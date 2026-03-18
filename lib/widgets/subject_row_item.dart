import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/student.dart';
import '../utils/app_colors.dart';
import '../providers/gpa_provider.dart';
import '../providers/student_provider.dart';
import 'subject_form_dialog.dart';
import 'package:provider/provider.dart';

class SubjectRowItem extends StatelessWidget {
  final int stt;
  final Subject subject;
  final Student student;

  const SubjectRowItem({
    super.key,
    required this.stt,
    required this.subject,
    required this.student,
  });

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
    final gpaProvider = Provider.of<GpaProvider>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text('$stt', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              subject.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text('${subject.credits}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary)),
          ),
          SizedBox(
            width: 84,
            child: Text(subject.score.toStringAsFixed(1), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary)),
          ),
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Sửa
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => SubjectFormDialog(
                        subject: subject,
                        onSave: (name, credits, score) async {
                          await gpaProvider.updateSubject(student.id, subject.id, name, credits, score, studentProvider, student);
                          if (context.mounted) _showSnackBar(context, '✓ Đã cập nhật môn ${subject.name}');
                        },
                      ),
                    );
                  },
                  child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.edit, color: Colors.blue, size: 20)),
                ),
                const SizedBox(width: 8),
                // Nút Xóa (Đã cải tiến)
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: AppColors.error),
                            SizedBox(width: 10),
                            Text('Xác nhận xóa', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: Text('Bạn có chắc chắn muốn xóa môn "${subject.name}"? Điểm GPA sẽ được tính toán lại ngay lập tức.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx); // Đóng ngay để mượt mà
                              await gpaProvider.deleteSubject(student.id, subject.id, studentProvider, student);
                              if (context.mounted) {
                                _showSnackBar(context, '✓ Đã xóa môn học: ${subject.name}');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Xóa ngay'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.delete_forever, color: Colors.red, size: 22)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
