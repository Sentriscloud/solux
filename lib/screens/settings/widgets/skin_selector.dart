import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/card_skin.dart';
import '../../../providers/skin_provider.dart';
import '../../../screens/home/widgets/card_patterns.dart';
import '../../../theme/app_colors.dart';

class SkinSelector extends ConsumerWidget {
  const SkinSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(cardSkinProvider);

    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: CardSkin.values.map((skin) {
          final config   = skinConfigs[skin]!;
          final isActive = skin == current;

          return GestureDetector(
            onTap: () => ref.read(cardSkinProvider.notifier).setSkin(skin),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80, height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive ? config.glowColor : AppColors.glassBorder,
                        width: isActive ? 2 : 1,
                      ),
                      boxShadow: isActive
                          ? [BoxShadow(
                              color: config.glowColor.withValues(alpha: 0.40),
                              blurRadius: 14,
                              spreadRadius: 1,
                            )]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Stack(
                        children: [
                          // Background gradient
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [config.bgFrom, config.bgTo],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          // Pattern preview
                          Positioned.fill(
                            child: CustomPaint(
                              painter: buildCardPatternPainter(
                                config.pattern,
                                config.patternColors,
                              ),
                            ),
                          ),
                          // Accent strip at top
                          Positioned(
                            top: 0, left: 0, right: 0,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(11)),
                                gradient: LinearGradient(
                                    colors: config.accentColors),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    config.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isActive ? config.glowColor : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
