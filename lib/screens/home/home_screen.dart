// ============================================================
// FILE: lib/screens/home/home_screen.dart
// TRÁCH NHIỆM: UI màn hình chính – hiển thị danh sách sinh viên.
//
// ⚠️  RANH GIỚI TRÁCH NHIỆM:
//   ✅ Render danh sách StudentCard.
//   ✅ Xử lý loading / error / empty / data UI state.
//   ✅ RefreshIndicator (pull-to-refresh).
//   ✅ SizedBox(height: 60) giữ chỗ cho thanh tìm kiếm [Người số 5].
//   ❌ KHÔNG tự vẽ FloatingActionButton [Người số 3 làm].
//   ❌ KHÔNG tự xử lý logic navigation khi tap card.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../detail/student_detail_screen.dart';
import '../../utils/app_colors.dart';
import '../../widgets/student_card.dart';
import '../../widgets/student_form_dialog.dart';
import '../../providers/student_provider.dart';
import '../../providers/gpa_provider.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch dữ liệu ngay khi màn hình được tạo.
    // Dùng addPostFrameCallback để tránh gọi setState trong build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // ─── Thay [Số nhóm] bằng số nhóm thực tế ─────────────
        title: const Text(
          'TH5 - Nhóm 12',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // ✅ Task 3: FAB mở form thêm sinh viên mới
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<StudentProvider>(),
              child: const StudentFormDialog(),
            ),
          );
        },
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Thêm sinh viên'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          // ─── State 1: Đang tải ────────────────────────────────
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // ─── State 2: Lỗi ─────────────────────────────────────
          if (viewModel.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => viewModel.fetchStudents(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ─── State 3: Danh sách rỗng ─────────────────────────
          if (viewModel.students.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_off_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có sinh viên nào',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          // ─── State 4: Có dữ liệu ─────────────────────────────
          return RefreshIndicator(
            // Pull-to-refresh gọi lại hàm fetch
            onRefresh: () => viewModel.fetchStudents(),
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // ⚠️ RANH GIỚI: SizedBox(height: 60) giữ chỗ
                // cho thanh Search mà [Người số 5] sẽ ráp vào.
                // KHÔNG xóa hoặc thay thế phần này.
                const SliverToBoxAdapter(
                  child: SizedBox(height: 60),
                  // TODO(người số 5): Thay SizedBox này bằng widget
                  // SearchBar của bạn khi ráp code.
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final student = viewModel.students[index];

                    // ✅ Task 3: Dismissible – vuốt sang trái để xóa
                    return Dismissible(
                      key: ValueKey(student.id),
                      direction: DismissDirection.endToStart,
                      // Nền đỏ + icon thùng rác
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline,
                                color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text('Xóa',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      // Hỏi xác nhận trước khi xóa
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                            title: const Row(children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: AppColors.error),
                              SizedBox(width: 8),
                              Text('Xác nhận xóa'),
                            ]),
                            content: Text(
                              'Bạn có chắc chắn muốn xóa sinh viên "${student.name}" không?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(false),
                                child: const Text('Hủy',
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(ctx).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                ),
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                      },
                      // Thực hiện xóa sau khi người dùng xác nhận
                      onDismissed: (direction) async {
                        final success = await context
                            .read<StudentProvider>()
                            .deleteStudent(student.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? '✓ Đã xóa sinh viên ${student.name}'
                                  : 'Xóa thất bại. Vui lòng thử lại.'),
                              backgroundColor: success
                                  ? AppColors.success
                                  : AppColors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      child: StudentCard(
                        student: student,
                        onTap: () {
                          // Lấy GpaProvider instance từ context cha (HomeScreen)
                          final gpaProvider = context.read<GpaProvider>();
                          
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: gpaProvider,
                                child: StudentDetailScreen(student: student),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }, childCount: viewModel.students.length),
                ),

                // Padding cuối list
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }
}
