// ============================================================
// FILE: lib/utils/app_colors.dart
// TRÁCH NHIỆM: Hằng số màu sắc dùng chung toàn ứng dụng.
//   Mọi widget chỉ tham chiếu màu từ file này, KHÔNG hardcode.
// ============================================================

import 'package:flutter/material.dart';

/// Bảng màu chính của ứng dụng Student Manager.
abstract final class AppColors {
  // ─── Brand colors ─────────────────────────────────────────
  static const Color primary = Color(0xFF1565C0);      // Blue 800
  static const Color primaryLight = Color(0xFFBBDEFB); // Blue 100
  static const Color primaryDark = Color(0xFF003C8F);  // Blue 900

  static const Color accent = Color(0xFF00BCD4);       // Cyan

  // ─── Background ───────────────────────────────────────────
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;

  // ─── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A237E);
  static const Color textSecondary = Color(0xFF757575);

  // ─── Status / Semantic ────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);

  // ─── GPA badge colors ─────────────────────────────────────
  static const Color gpaExcellent = Color(0xFF2E7D32); // GPA >= 3.5
  static const Color gpaGood = Color(0xFF1565C0);      // GPA >= 3.0
  static const Color gpaAverage = Color(0xFFF57C00);   // GPA >= 2.0
  static const Color gpaPoor = Color(0xFFD32F2F);      // GPA < 2.0

  // ─── Misc ─────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x1A000000);  // black @ 10%
}
