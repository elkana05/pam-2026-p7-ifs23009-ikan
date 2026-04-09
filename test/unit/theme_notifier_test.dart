// test/unit/theme_notifier_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';

void main() {
  group('ThemeNotifier', () {
    late ThemeNotifier notifier;

    setUp(() {
      // Buat instance baru sebelum setiap test
      notifier = ThemeNotifier(initial: ThemeMode.system);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('nilai awal sesuai parameter initial', () {
      expect(notifier.value, equals(ThemeMode.system));
      expect(notifier.isDark, isFalse);
    });

    test('isDark mengembalikan true saat mode adalah dark', () {
      notifier.setMode(ThemeMode.dark);
      expect(notifier.isDark, isTrue);
    });

    test('isDark mengembalikan false saat mode adalah light', () {
      notifier.setMode(ThemeMode.light);
      expect(notifier.isDark, isFalse);
    });

    test('toggle dari system ke dark', () {
      // system dianggap bukan dark, sehingga toggle → dark
      notifier.setMode(ThemeMode.system);
      notifier.toggle();
      expect(notifier.value, equals(ThemeMode.dark));
    });

    test('toggle dari dark ke light', () {
      notifier.setMode(ThemeMode.dark);
      notifier.toggle();
      expect(notifier.value, equals(ThemeMode.light));
    });

    test('toggle dari light ke dark', () {
      notifier.setMode(ThemeMode.light);
      notifier.toggle();
      expect(notifier.value, equals(ThemeMode.dark));
    });

    test('toggle dua kali kembali ke light', () {
      notifier.setMode(ThemeMode.light);
      notifier.toggle();
      notifier.toggle();
      expect(notifier.value, equals(ThemeMode.light));
    });

    test('setMode mengubah value dengan benar', () {
      notifier.setMode(ThemeMode.dark);
      expect(notifier.value, equals(ThemeMode.dark));

      notifier.setMode(ThemeMode.light);
      expect(notifier.value, equals(ThemeMode.light));

      notifier.setMode(ThemeMode.system);
      expect(notifier.value, equals(ThemeMode.system));
    });

    test('notifier memanggil listener saat value berubah', () {
      int callCount = 0;
      notifier.addListener(() => callCount++);

      notifier.toggle();
      notifier.toggle();

      expect(callCount, equals(2));
    });
  });
}