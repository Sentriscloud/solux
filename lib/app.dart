import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home/home_screen.dart';
import 'screens/send/send_screen.dart';
import 'screens/receive/receive_screen.dart';
import 'screens/swap/swap_screen.dart';
import 'screens/stake/stake_screen.dart';
import 'screens/buy/buy_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/activity/activity_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',        builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/send',    builder: (_, __) => const SendScreen()),
    GoRoute(path: '/receive', builder: (_, __) => const ReceiveScreen()),
    GoRoute(path: '/swap',    builder: (_, __) => const SwapScreen()),
    GoRoute(path: '/stake',   builder: (_, __) => const StakeScreen()),
    GoRoute(path: '/buy',     builder: (_, __) => const BuyScreen()),
    GoRoute(path: '/settings',builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/dapps',    builder: (_, __) => const _Placeholder('dApps')),
    GoRoute(path: '/activity', builder: (_, __) => const ActivityScreen()),
    GoRoute(path: '/profile',  builder: (_, __) => const ProfileScreen()),
  ],
);

class SoluxApp extends StatelessWidget {
  const SoluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Solux',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String name;
  const _Placeholder(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text('$name — Coming soon',
            style: const TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}
