import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/app_colors.dart';

class SubjectFormDialog extends StatefulWidget {
  final Subject? subject;
  final Function(String name, int credits, double score) onSave;

  const SubjectFormDialog({super.key, this.subject, required this.onSave});

  @override
  State<SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _creditsController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _creditsController = TextEditingController(text: widget.subject?.credits.toString() ?? '');
    _scoreController = TextEditingController(text: widget.subject?.score.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditsController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? 'Thêm môn học' : 'Sửa môn học'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên môn học', hintText: 'Nhập tên môn...'),
                validator: (v) => (v == null || v.isEmpty) ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'Số tín chỉ', hintText: 'Ví dụ: 3'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final val = int.tryParse(v ?? '');
                  if (val == null || val <= 0) return 'Phải là số nguyên > 0';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _scoreController,
                decoration: const InputDecoration(labelText: 'Điểm tổng kết', hintText: 'Hệ 10 (0 - 10)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val < 0 || val > 10) return 'Điểm không hợp lệ (0-10)';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text,
                int.parse(_creditsController.text),
                double.parse(_scoreController.text),
              );
              Navigator.pop(context);
            } else {
              // Thông báo khi save điểm bị thiếu hoặc sai dữ liệu
              _showError('Vui lòng điền đúng và đủ thông tin môn học!');
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
