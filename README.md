# Solux

[![CI](https://github.com/Sentriscloud/solux/actions/workflows/ci.yml/badge.svg)](https://github.com/Sentriscloud/solux/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/Sentriscloud/solux)](LICENSE)
[![Latest release](https://img.shields.io/github/v/release/Sentriscloud/solux?include_prereleases&sort=semver)](https://github.com/Sentriscloud/solux/releases/latest)


> ⚠️ **PROTOTYPE — DO NOT SEND REAL FUNDS.** This repository currently contains UI scaffolding only. There is no key generation, no signing, no on-chain integration. The "send", "view seed phrase", and "export private key" buttons are non-functional placeholders. Treat any APK built from this repository as a design preview, NOT a working wallet. Crypto layer (key gen, BIP-39 seed, transaction signing, RPC integration) is on the roadmap; this README will be updated when those land.

UI prototype for a future self-custody mobile wallet on [Sentrix Chain](https://sentrixchain.com) (SRX). Flutter, multi-platform (Android primary; iOS, macOS, Linux, Windows targets supported).

Part of the [SentrisCloud](https://github.com/sentriscloud) product suite.

## Stack

- **Flutter 3.41.6** stable
- **Riverpod** — state management
- **go_router** — navigation
- **google_fonts** — SpaceGrotesk for balance display
- **sensors_plus** — accelerometer-driven 3D card tilt
- **qr_flutter** — QR address rendering
- **shared_preferences** — persisted card skin

## Run

```bash
flutter pub get
flutter run                  # connected device
flutter build apk --release  # output: build/app/outputs/flutter-apk/app-release.apk
flutter analyze lib/
```

## Design system

Dark navy palette (shared with the SentrisCloud brand family):

| Token | Value |
|---|---|
| `bg` | `#030712` |
| `bgElevated` | `#0A0F1A` |
| `surface` | `#0D1426` |
| `textPrimary` | `#F1F5F9` |
| `textSecondary` | `#8494A7` |
| `emerald` | `#10B981` |
| `pink` | `#EC4899` |
| `violet` | `#A855F7` |
| `indigo` | `#6366F1` |
| `cyan` | `#22D3EE` |

## Routes

| Route | Screen |
|---|---|
| `/` | Home |
| `/activity` | Activity (filter tabs + grouped by date) |
| `/profile` | Profile (avatar, stats, assets, actions) |
| `/send` | Send |
| `/receive` | Receive |
| `/swap` | Swap |
| `/stake` | Stake |
| `/buy` | Buy |
| `/settings` | Settings |
| `/dapps` | Placeholder |

## Balance card

`MetalBalanceCard` (`lib/widgets/metal_balance_card.dart`) — black metal (`#0D0D0D`) base with a debossed hexagon texture, accelerometer-driven 3D tilt, and a balance hide/show toggle (`balanceHiddenProvider`). The hex grid is rendered by `HexagonTexturePainter` with light/dark edge emboss.

## Card skins

Five skins selectable in Settings (configs in `lib/models/card_skin.dart`):

| Skin | Pattern | Colors |
|---|---|---|
| Neon | Diagonal neon beams | cyan / violet / pink |
| Circuit | PCB traces + particles | teal / sky blue |
| Hex | Hex grid + neon glow | electric blue / cyan |
| Cubes | Iso cubes + accent cube | pink accent |
| Stealth | Etched hex emboss | monochromatic black |

> The skin selector is currently wired to a separate skin card. The Home screen uses `MetalBalanceCard` as a fixed design; the selector can be connected to it later if needed.

## Key files

```
lib/
├── app.dart                      ← GoRouter routes
├── theme/app_colors.dart         ← full palette + aliases
├── models/
│   ├── transaction.dart          ← Tx model + TxType enum
│   ├── token.dart
│   └── card_skin.dart            ← CardSkin enum + SkinConfig
├── data/mock_data.dart           ← mockTokens, mockTxs
├── providers/
│   ├── wallet_provider.dart      ← balanceHiddenProvider, tokensProvider, txsProvider
│   └── skin_provider.dart        ← cardSkinProvider (persisted)
├── widgets/
│   ├── metal_balance_card.dart   ← primary balance card
│   ├── bottom_nav.dart           ← custom center-FAB bottom nav
│   └── token_icon.dart
└── screens/
    ├── home/widgets/
    │   ├── action_buttons.dart   ← Send / Receive / Swap / Stake / Buy
    │   ├── asset_list.dart       ← token rows + dividers
    │   ├── activity_list.dart    ← recent activity mini list
    │   ├── aurora_painter.dart   ← BgOrbPainter, CardGeometricPainter
    │   └── card_patterns.dart    ← five CustomPainter skin patterns
    ├── activity/activity_screen.dart
    ├── profile/profile_screen.dart
    └── settings/settings_screen.dart
```

## Roadmap

- [ ] dApps screen (currently placeholder)
- [ ] Real blockchain integration (currently mock data)
- [ ] Onboarding / create-wallet flow
- [ ] Wire card skin selector to `MetalBalanceCard`

## Bundle identifiers

| Platform | Identifier |
|---|---|
| Android | `com.sentriscloud.solux` |
| iOS | `com.sentriscloud.solux` |
| macOS | `com.sentriscloud.solux` |
| Linux GTK app ID | `com.sentriscloud.solux` |

## License

TBD.

## Related

- [Sentrix Chain](https://sentrixchain.com) — the L1
- [sentrix-labs/sentrix](https://github.com/sentrix-labs/sentrix) — chain core (Rust)
- [sentriscloud/frontend](https://github.com/sentriscloud/frontend) — TypeScript apps monorepo
