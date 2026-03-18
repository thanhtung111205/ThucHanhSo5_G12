import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/gpa_provider.dart';
import '../providers/student_provider.dart';
import '../widgets/subject_row_item.dart';
import '../widgets/subject_form_dialog.dart';

class SubjectScreen extends StatelessWidget {
  final Student student;

  const SubjectScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tính GPA Môn Học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 28),
            tooltip: 'Thêm môn học',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => SubjectFormDialog(
                  onSave: (name, credits, score) async {
                    final gpaProvider = context.read<GpaProvider>();
                    final studentProvider = context.read<StudentProvider>();
                    await gpaProvider.addSubject(
                      student.id,
                      name,
                      credits,
                      score,
                      studentProvider,
                      student,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<GpaProvider>(
        builder: (context, gpaProvider, child) {
          final subjects = gpaProvider.getSubjects(student);
          final gpa = gpaProvider.calculateGpa(student);
          final totalCredits = subjects.fold<int>(0, (sum, item) => sum + item.credits);

          return Column(
            children: [
              // GPA Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'GPA TRUNG BÌNH',
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gpa.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tổng số tín chỉ: $totalCredits',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),

              // Subject List
              Expanded(
                child: subjects.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: subjects.length,
                        itemBuilder: (ctx, index) {
                          final studentProvider = context.read<StudentProvider>();
                          return SubjectRowItem(
                            stt: index + 1,
                            subject: subjects[index],
                            student: student,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Chưa có dữ liệu môn học',
            style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bấm nút (+) ở trên để bắt đầu',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
