import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppText {
  static const labelUppercase = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.textMuted,
  );
  static const sectionTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.text,
  );
  static const screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );
  static const heroNumber = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -1.0,
  );
  static const buttonPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: Colors.white,
  );
  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
