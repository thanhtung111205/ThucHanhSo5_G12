// ============================================================
// FILE: lib/main.dart
// TRÁCH NHIỆM: Entry point – khởi động app và đăng ký Providers.
// ============================================================

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/home_view_model.dart';
import 'providers/student_provider.dart';
import 'utils/app_colors.dart';

void main() async {
  // Firebase phải được khởi tạo trước khi runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StudentManagerApp());
}

class StudentManagerApp extends StatelessWidget {
  const StudentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ⚠️ RANH GIỚI: Mỗi thành viên đăng ký Provider của mình tại đây.
        // Người số 1 (Home): HomeViewModel
        ChangeNotifierProvider(create: (_) => HomeViewModel()),

        // ✅ Task 3: StudentProvider – nhận refreshCallback từ HomeViewModel
        // để tự động fetch lại danh sách sau mỗi thao tác CRUD.
        ChangeNotifierProxyProvider<HomeViewModel, StudentProvider>(
          create: (_) => StudentProvider(),
          update: (_, homeVM, previous) {
            // Reuse instance cũ, chỉ cập nhật callback
            final provider = previous ?? StudentProvider();
            provider.updateRefreshCallback(homeVM.fetchStudents);
            return provider;
          },
        ),

        // TODO(người số 4): Thêm StudentRepository provider nếu cần.
        // TODO(người số 5): Thêm FilterProvider khi làm tìm kiếm.
      ],
      child: MaterialApp(
        title: 'Student Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
