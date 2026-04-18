import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.glassPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 16,
                    color: AppColors.text,
                  ),
                ),
              ),
            )
          : leading,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          letterSpacing: 0.2,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
