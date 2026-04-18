import 'package:flutter/material.dart';

class AppColors {
  // === BACKGROUNDS (GSC dark navy palette) ===
  static const bg          = Color(0xFF030712);
  static const bgElevated  = Color(0xFF0A0F1A);
  static const surface     = Color(0xFF0D1426);
  static const surfaceHigh = Color(0xFF0F1A2E);

  // === GLASS ===
  static const glass       = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x0FFFFFFF);
  static const glassHover  = Color(0x08FFFFFF);

  // === CANDY ACCENTS ===
  static const pink        = Color(0xFFEC4899);
  static const pinkLight   = Color(0xFFF472B6);
  static const pinkDark    = Color(0xFFBE185D);
  static const violet      = Color(0xFFA855F7);
  static const violetLight = Color(0xFFC084FC);
  static const violetDark  = Color(0xFF7E22CE);
  static const indigo      = Color(0xFF6366F1);
  static const indigoLight = Color(0xFF818CF8);
  static const blue        = Color(0xFF3B82F6);
  static const blueLight   = Color(0xFF60A5FA);

  // === SEMANTIC ===
  static const success   = Color(0xFF10B981);
  static const successBg = Color(0x1510B981);
  static const danger    = Color(0xFFF43F5E);
  static const dangerBg  = Color(0x15F43F5E);
  static const warning   = Color(0xFFF59E0B);

  // === TEXT (GSC palette) ===
  static const textPrimary   = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF8494A7);
  static const textMuted     = Color(0xFF7A8A9A);
  static const textDim       = Color(0xFF5A6A7A);

  // === GRADIENTS ===
  static const gradientCandy = LinearGradient(
    colors: [pink, violet, indigo],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const gradientPinkViolet = LinearGradient(
    colors: [pink, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const gradientVioletBlue = LinearGradient(
    colors: [violet, indigo, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const gradientCard = LinearGradient(
    colors: [Color(0xFF1E0A35), Color(0xFF101018), Color(0xFF0C1226)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === BACKWARD COMPAT ALIASES ===
  static const accentPurple   = violet;
  static const accentBlue     = blue;
  static const accentElectric = indigoLight;
  static const accentGreen    = success;
  static const accentRose     = danger;
  static const accentAmber    = warning;
  static const accentCyan     = Color(0xFF22D3EE);
  static const glassPrimary   = glass;
  static const glassShimmer   = glassHover;
  static const text           = textPrimary;
  static const card           = glass;
  static const border         = glassBorder;
  static const input          = glass;
  static const emerald        = success;
  static const emeraldLight   = Color(0xFF6EE7B7);
  static const emeraldDim     = Color(0x1F10B981);
  static const rose           = danger;
  static const roseDim        = Color(0x1FF43F5E);
  static const cyan           = accentCyan;
  static const cyanDim        = Color(0x1F22D3EE);
  static const amber          = warning;
  static const amberDim       = Color(0x1FF59E0B);
  static const purple         = violet;
  static const purpleDim      = Color(0x1FA855F7);
  static const cardSolid      = Color(0xFF0D1426);
  static const cardGradientStart = Color(0xFF0A0520);
  static const cardGradientMid   = Color(0xFF1A0A35);
  static const cardGradientEnd   = Color(0xFF0D1F18);
}
