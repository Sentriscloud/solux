# Solux Android ProGuard / R8 rules.
# Audit H3 (2026-05-07): R8 minify + resource shrinking enabled on release.
# Add specific keep rules below as new dependencies need them.

# Flutter built-in
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# When the crypto layer lands, add explicit -keep rules for any
# cryptographic classes that R8 might inadvertently strip.
