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

  // Hàm hiển thị thông báo duy nhất, xóa các thông báo cũ trước đó
  void _showMessengerSnackBar(ScaffoldMessengerState messenger, String message, {bool isError = false}) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GpaProvider>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '$stt',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Text(
                subject.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 72,
              child: Text(
                '${subject.credits}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 84,
              child: Text(
                subject.score.toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconAction(
                    icon: Icons.edit_outlined,
                    color: Colors.blue,
                    onTap: () {
                      final messenger = ScaffoldMessenger.of(context);
                      showDialog(
                        context: context,
                        builder: (ctx) => SubjectFormDialog(
                          subject: subject,
                          onSave: (name, credits, score) async {
                            // Chờ cập nhật Firestore hoàn tất
                            await gpaProvider.updateSubject(student.id, subject.id, name, credits, score, studentProvider, student);
                            // Hiển thị thông báo duy nhất
                            _showMessengerSnackBar(messenger, '✓ Đã cập nhật môn: $name');
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _buildIconAction(
                    icon: Icons.delete_outline,
                    color: AppColors.error,
                    onTap: () {
                      _showDeleteConfirmation(context, gpaProvider, studentProvider);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconAction({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, GpaProvider gpaProvider, StudentProvider studentProvider) {
    final messenger = ScaffoldMessenger.of(context);
    final subjectName = subject.name;

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
        content: Text('Bạn có chắc chắn muốn xóa môn "$subjectName"?\nGPA sẽ được tính toán lại sau khi xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              // 1. Chờ xóa xong hoàn toàn trên Cloud
              await gpaProvider.deleteSubject(student.id, subject.id, studentProvider, student);
              
              // 2. Chỉ hiện thông báo 1 lần sau khi hoàn tất
              _showMessengerSnackBar(messenger, '✓ Đã xóa môn: $subjectName');
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
  }
}
