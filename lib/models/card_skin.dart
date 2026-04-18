import 'package:flutter/material.dart';

enum CardSkin { neonCandy, circuitBlue, hexCyan, isoCubes, stealthMetal }

class SkinConfig {
  final String label;
  final String pattern;        // 'neon' | 'circuit' | 'hex' | 'cubes'
  final Color bgFrom;
  final Color bgTo;
  final List<Color> patternColors;
  final Color glowColor;
  final List<Color> accentColors; // for preview strip

  const SkinConfig({
    required this.label,
    required this.pattern,
    required this.bgFrom,
    required this.bgTo,
    required this.patternColors,
    required this.glowColor,
    required this.accentColors,
  });
}

const skinConfigs = <CardSkin, SkinConfig>{

  // Card 1 ref: deep black + cyan/violet/pink neon diagonal beams
  CardSkin.neonCandy: SkinConfig(
    label: 'Neon',
    pattern: 'neon',
    bgFrom: Color(0xFF08050F),   // near black, slight purple
    bgTo:   Color(0xFF050812),   // near black, slight navy
    patternColors: [
      Color(0xFF22D3EE),  // cyan
      Color(0xFFA855F7),  // violet
      Color(0xFFEC4899),  // pink
    ],
    glowColor: Color(0xFFA855F7),
    accentColors: [Color(0xFF22D3EE), Color(0xFFA855F7), Color(0xFFEC4899)],
  ),

  // Card 2/3 ref: very dark navy + teal circuit traces + particle scatter
  CardSkin.circuitBlue: SkinConfig(
    label: 'Circuit',
    pattern: 'circuit',
    bgFrom: Color(0xFF030B14),   // near black navy
    bgTo:   Color(0xFF050F1A),   // dark navy
    patternColors: [
      Color(0xFF22D3EE),  // teal/cyan (matching card 3)
      Color(0xFF0EA5E9),  // sky blue secondary
    ],
    glowColor: Color(0xFF22D3EE),
    accentColors: [Color(0xFF22D3EE), Color(0xFF0EA5E9), Color(0xFF3B82F6)],
  ),

  // Card 4 ref: deep blue navy + electric blue/cyan hex honeycomb glow
  CardSkin.hexCyan: SkinConfig(
    label: 'Hex',
    pattern: 'hex',
    bgFrom: Color(0xFF060D1E),   // deep navy blue
    bgTo:   Color(0xFF0A1628),   // dark blue
    patternColors: [
      Color(0xFF3B82F6),  // electric blue
      Color(0xFF22D3EE),  // cyan glow
    ],
    glowColor: Color(0xFF3B82F6),
    accentColors: [Color(0xFF3B82F6), Color(0xFF22D3EE), Color(0xFF6366F1)],
  ),

  // Card 5 ref: dark charcoal + dark gray iso cubes + 1 bright accent cube
  CardSkin.isoCubes: SkinConfig(
    label: 'Cubes',
    pattern: 'cubes',
    bgFrom: Color(0xFF080810),
    bgTo:   Color(0xFF0C0C18),
    patternColors: [Color(0xFFEC4899)],
    glowColor: Color(0xFFEC4899),
    accentColors: [Color(0xFFEC4899), Color(0xFFA855F7), Color(0xFF6366F1)],
  ),

  // Card 6 ref: black metal etched hex — true black, zero bright colors
  CardSkin.stealthMetal: SkinConfig(
    label: 'Stealth',
    pattern: 'stealth',
    bgFrom: Color(0xFF070709),   // true black
    bgTo:   Color(0xFF0A0A0E),   // near black
    patternColors: [],
    glowColor: Color(0xFF2A2A36),
    accentColors: [Color(0xFF1E1E26), Color(0xFF252530), Color(0xFF18181F)],
  ),
};
