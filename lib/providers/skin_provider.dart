import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_skin.dart';
import 'shared_preferences_provider.dart';

const _kSkinKey = 'card_skin';

class SkinNotifier extends StateNotifier<CardSkin> {
  final Ref _ref;

  SkinNotifier(this._ref) : super(CardSkin.neonCandy) {
    _load();
  }

  void _load() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_kSkinKey);
    if (saved != null) {
      state = CardSkin.values.firstWhere(
        (s) => s.name == saved,
        orElse: () => CardSkin.neonCandy,
      );
    }
  }

  void setSkin(CardSkin skin) {
    state = skin;
    _ref.read(sharedPreferencesProvider).setString(_kSkinKey, skin.name);
  }
}

final cardSkinProvider = StateNotifierProvider<SkinNotifier, CardSkin>((ref) {
  return SkinNotifier(ref);
});
