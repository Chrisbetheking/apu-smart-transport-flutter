import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0F3D5E);
  static const Color primarySoft = Color(0xFFEAF4FB);
  static const Color accent = Color(0xFF15A6A6);
  static const Color background = Color(0xFFF6F8FB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF17212B);
  static const Color textSecondary = Color(0xFF61707F);
  static const Color success = Color(0xFF168A4A);
  static const Color warning = Color(0xFFE8871E);
  static const Color danger = Color(0xFFD64545);
  static const Color reserved = Color(0xFF4657D9);
  static const Color notice = Color(0xFF7B4DD6);

  static Color alpha(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  static Color badgeColor(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('reserved') ||
        normalized.contains('已预约') ||
        normalized.contains('已签到') ||
        normalized.contains('checked')) {
      return reserved;
    }
    if (normalized.contains('on time') ||
        normalized.contains('available') ||
        normalized.contains('准点') ||
        normalized.contains('可预约') ||
        normalized.contains('行驶中')) {
      return success;
    }
    if (normalized.contains('limited') ||
        normalized.contains('warning') ||
        normalized.contains('delay') ||
        normalized.contains('提醒') ||
        normalized.contains('较少') ||
        normalized.contains('延误')) {
      return warning;
    }
    if (normalized.contains('cancel') ||
        normalized.contains('full') ||
        normalized.contains('arrived') ||
        normalized.contains('已取消') ||
        normalized.contains('已满') ||
        normalized.contains('已到达')) {
      return danger;
    }
    return notice;
  }
}
