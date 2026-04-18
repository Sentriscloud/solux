# Solux Wallet — Sentrix Chain

Flutter crypto wallet app untuk Sentrix (SRX) blockchain.

## Dev Info

**Flutter:** 3.41.6 stable  
**Device ADB ID:** `9XMR8D8XVCVW7LGA` (Xiaomi 2407FPN8EG, Android 16)  
**Flutter path:** `E:\apk\flutter\bin\flutter`

```bash
# Run di HP
/e/apk/flutter/bin/flutter run -d 9XMR8D8XVCVW7LGA

# Build APK release
/e/apk/flutter/bin/flutter build apk --release
# Output: build\app\outputs\flutter-apk\app-release.apk

# Analyze
/e/apk/flutter/bin/flutter analyze lib/
```

## Stack

- Flutter + Riverpod (state management)
- go_router (navigation)
- google_fonts — SpaceGrotesk untuk balance
- sensors_plus — accelerometer 3D card tilt
- qr_flutter — QR address di Profile
- shared_preferences — persist card skin

## Design System

**Palette (GSC dark navy):**
| Token | Value |
|-------|-------|
| bg | `#030712` |
| bgElevated | `#0A0F1A` |
| surface | `#0D1426` |
| textPrimary | `#F1F5F9` |
| textSecondary | `#8494A7` |
| emerald | `#10B981` |
| pink | `#EC4899` |
| violet | `#A855F7` |
| indigo | `#6366F1` |
| cyan | `#22D3EE` |

## Screens & Routes

| Route | Screen |
|-------|--------|
| `/` | HomeScreen |
| `/activity` | ActivityScreen (filter tabs + grouped date) |
| `/profile` | ProfileScreen (avatar, stats, assets, actions) |
| `/send` | SendScreen |
| `/receive` | ReceiveScreen |
| `/swap` | SwapScreen |
| `/stake` | StakeScreen |
| `/buy` | BuyScreen |
| `/settings` | SettingsScreen |
| `/dapps` | Placeholder |

## Balance Card

`MetalBalanceCard` — `lib/widgets/metal_balance_card.dart`  
- Black metal (#0D0D0D) + debossed hexagon texture
- `HexagonTexturePainter` — pointy-top hex grid dengan light/dark edge emboss effect
- Accelerometer 3D tilt (sensors_plus)
- Balance hide/show toggle (balanceHiddenProvider)

## Card Skin System

5 skins di Settings (skinConfigs di `lib/models/card_skin.dart`):

| Skin | Pattern | Colors |
|------|---------|--------|
| Neon | Diagonal neon beams | cyan / violet / pink |
| Circuit | PCB traces + particles | teal / sky blue |
| Hex | Hex grid + neon glow | electric blue / cyan |
| Cubes | Iso cubes + accent cube | pink accent |
| Stealth | Etched hex emboss | monochromatic black |

> Skin selector ada di Settings tapi Home screen pakai `MetalBalanceCard` (fixed design). Skin selector bisa di-connect ke MetalBalanceCard kalau dibutuhkan.

## Key Files

```
lib/
├── app.dart                      ← GoRouter routes
├── theme/app_colors.dart         ← full palette + aliases
├── models/
│   ├── transaction.dart          ← Tx model + TxType enum
│   ├── token.dart
│   └── card_skin.dart            ← CardSkin enum + SkinConfig
├── data/mock_data.dart           ← mockTokens, mockTxs, mockTxsExtended
├── providers/
│   ├── wallet_provider.dart      ← balanceHiddenProvider, tokensProvider, txsProvider
│   └── skin_provider.dart        ← cardSkinProvider (persisted)
├── widgets/
│   ├── metal_balance_card.dart   ← balance card utama
│   ├── bottom_nav.dart           ← custom center-FAB bottom nav
│   └── token_icon.dart
└── screens/
    ├── home/widgets/
    │   ├── action_buttons.dart   ← Send/Receive/Swap/Stake/Buy
    │   ├── asset_list.dart       ← token rows + dividers
    │   ├── activity_list.dart    ← recent activity mini list
    │   ├── aurora_painter.dart   ← BgOrbPainter, CardGeometricPainter
    │   └── card_patterns.dart    ← 5 CustomPainter skin patterns
    ├── activity/activity_screen.dart
    ├── profile/profile_screen.dart
    └── settings/settings_screen.dart
```

## TODO

- [ ] Dapps screen (masih placeholder)
- [ ] Real blockchain data integration (saat ini mock)
- [ ] Onboarding / create wallet flow
- [ ] Connect card skin system ke MetalBalanceCard
