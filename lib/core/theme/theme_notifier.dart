// lib/core/theme/theme_notifier.dart

import 'package:flutter/material.dart';

/// ValueNotifier yang menyimpan ThemeMode saat ini
/// Diakses melalui InheritedWidget (ThemeProvider)
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier({ThemeMode initial = ThemeMode.system}) : super(initial);

  /// Cek apakah mode saat ini adalah dark
  bool get isDark => value == ThemeMode.dark;

  /// Toggle antara light dan dark mode
  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Set mode secara eksplisit
  void setMode(ThemeMode mode) {
    value = mode;
  }
}

/// InheritedWidget untuk menyebarkan ThemeNotifier ke seluruh widget tree
class ThemeProvider extends InheritedNotifier<ThemeNotifier> {
  const ThemeProvider({
    super.key,
    required ThemeNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  /// Cara akses ThemeProvider dari widget mana pun:
  /// `ThemeProvider.of(context).toggle()`
  static ThemeNotifier of(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(provider != null, 'ThemeProvider tidak ditemukan di widget tree!');
    return provider!.notifier!;
  }
}