import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gpa_provider.dart';
import '../widgets/subject_row_item.dart';
import '../widgets/subject_form_dialog.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

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
                  onSave: (name, credits, score) {
                    context.read<GpaProvider>().addSubject(name, credits, score);
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<GpaProvider>(
        builder: (context, provider, child) {
          final subjects = provider.subjects;
          final gpa = provider.calculateGPA();

          return Column(
            children: [
              // 5. Logic GPA Header (QUAN TRỌNG)
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
                      color: Colors.black.withOpacity(0.1),
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
                      gpa.toStringAsFixed(2), // 10. Bonus: Format GPA 2 chữ số
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tổng số tín chỉ: ${provider.totalCredits}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),

              // 2. UI: Danh sách môn học
              Expanded(
                child: subjects.isEmpty
                    ? _buildEmptyState() // 10. Bonus: Hiển thị "Chưa có dữ liệu"
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: subjects.length,
                        itemBuilder: (ctx, index) {
                          return SubjectItemWidget(
                            subject: subjects[index],
                            onEdit: (name, credits, score) {
                              provider.updateSubject(subjects[index].id, name, credits, score);
                            },
                            onDelete: () {
                              provider.deleteSubject(subjects[index].id);
                            },
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
