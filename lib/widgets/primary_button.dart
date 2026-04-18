import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColors.gradientPinkViolet,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x50A855F7),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0x30EC4899),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(label, style: AppText.buttonPrimary),
        ),
      ),
    );
  }
}
