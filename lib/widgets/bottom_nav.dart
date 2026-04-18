import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(
            top: BorderSide(color: Color(0x0DFFFFFF), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded, label: 'Home',
              active: currentIndex == 0,
              onTap: () => context.go('/'),
            ),
            _NavItem(
              icon: Icons.people_rounded, label: 'Social',
              active: currentIndex == 1,
              onTap: () => context.go('/dapps'),
            ),
            // Center FAB
            GestureDetector(
              onTap: () => context.push('/buy'),
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.black, size: 26),
              ),
            ),
            _NavItem(
              icon: Icons.receipt_long_rounded, label: 'History',
              active: currentIndex == 3,
              onTap: () => context.go('/activity'),
            ),
            _NavItem(
              icon: Icons.person_rounded, label: 'Profile',
              active: currentIndex == 4,
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon, required this.label,
    required this.active, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : Colors.white.withValues(alpha: 0.25);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
