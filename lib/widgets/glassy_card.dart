import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class GlassyCard extends StatelessWidget {
  final Widget child;
  final bool accentBar;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const GlassyCard({
    super.key,
    required this.child,
    this.accentBar = false,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final r = borderRadius ?? AppRadius.xl;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(r),
                border: Border.all(color: AppColors.glassBorder, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20A855F7),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
        if (accentBar)
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(r)),
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: AppColors.gradientCandy,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
