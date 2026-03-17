import 'package:flutter/material.dart';
import 'package:bai_th5/models/subject.dart';
import 'package:bai_th5/utils/app_colors.dart';

class SubjectRowItem extends StatelessWidget {
  final int stt;
  final Subject subject;

  const SubjectRowItem({super.key, required this.stt, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '$stt',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
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
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(
              '${subject.credits}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          SizedBox(
            width: 84,
            child: Text(
              subject.score.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 80),

          /// TODO: Task 4 - Gắn icon Sửa/Xóa môn học vào đây
        ],
      ),
    );
  }
}
