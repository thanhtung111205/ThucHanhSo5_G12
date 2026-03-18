import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/app_colors.dart';
import '../providers/gpa_provider.dart';
import 'subject_form_dialog.dart';
import 'package:provider/provider.dart';

class SubjectRowItem extends StatelessWidget {
  final int stt;
  final Subject subject;
  final String studentId;

  const SubjectRowItem({
    super.key,
    required this.stt,
    required this.subject,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GpaProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          // STT
          SizedBox(
            width: 36,
            child: Text(
              '$stt',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 8),
          // Tên môn học
          Expanded(
            flex: 5,
            child: Text(
              subject.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Số tín chỉ
          SizedBox(
            width: 72,
            child: Text(
              '${subject.credits}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          // Điểm tổng kết
          SizedBox(
            width: 84,
            child: Text(
              subject.score.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          // Hành động
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => SubjectFormDialog(
                        subject: subject,
                        onSave: (name, credits, score) {
                          gpaProvider.updateSubject(studentId, subject.id, name, credits, score);
                        },
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.edit, color: Colors.blue, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: Text('Bạn có chắc muốn xóa môn "${subject.name}"?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                          TextButton(
                            onPressed: () {
                              gpaProvider.deleteSubject(studentId, subject.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
