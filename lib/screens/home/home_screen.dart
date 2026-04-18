import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import 'widgets/action_buttons.dart';
import 'widgets/activity_list.dart';
import 'widgets/asset_list.dart';
import 'widgets/aurora_painter.dart';
import '../../widgets/metal_balance_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _HomeAppBar(),
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.bg, AppColors.bgElevated],
                ),
              ),
            ),
          ),
          // Orb background
          const Positioned.fill(
            child: CustomPaint(painter: BgOrbPainter()),
          ),
          // Scrollable content
          const SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MetalBalanceCard(),
                  SizedBox(height: 16),
                  ActionButtons(),
                  SizedBox(height: 20),
                  AssetList(),
                  SizedBox(height: 16),
                  ActivityList(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 160,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPinkViolet,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet 1',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'My Account',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary, size: 16),
            ],
          ),
        ),
      ),
      actions: [
        // Notification bell
        Stack(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x12FFFFFF), width: 1),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: AppColors.text, size: 18),
              ),
            ),
            Positioned(
              top: 6, right: 6,
              child: Container(
                width: 7, height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.accentRose,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        // Settings gear
        GestureDetector(
          onTap: () => context.push('/settings'),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x12FFFFFF), width: 1),
            ),
            child: const Icon(Icons.settings_outlined,
                color: AppColors.text, size: 18),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
