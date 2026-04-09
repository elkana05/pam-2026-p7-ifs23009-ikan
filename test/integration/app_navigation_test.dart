// test/integration/app_navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/app.dart';

void main() {
  group('Navigasi Aplikasi (End-to-End)', () {
    testWidgets('aplikasi berjalan dan menampilkan HomeScreen', (tester) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      // Halaman awal adalah Home
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });

    testWidgets('navigasi dari Home ke Plants via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      // Tap Plants di bottom nav
      await tester.tap(find.text('Plants'));
      await tester.pumpAndSettle();

      // Halaman Plants muncul
      expect(find.text('Plants'), findsWidgets);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('navigasi dari Home ke Profile via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Tentang Saya'), findsOneWidget);
    });

    testWidgets('navigasi dari Home ke Fish via BottomNav', (tester) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fish'));
      await tester.pumpAndSettle();

      expect(find.text('Topik ikan'), findsOneWidget);
    });

    testWidgets('toggle dark mode mengubah tema aplikasi', (tester) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      // Awalnya light mode
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

      // Toggle ke dark mode
      await tester.tap(find.byIcon(Icons.light_mode_outlined));
      await tester.pumpAndSettle();

      // Ikon berubah ke dark mode
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('toggle dark mode tetap aktif saat berpindah halaman', (
      tester,
    ) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      // Aktifkan dark mode di Home
      await tester.tap(find.byIcon(Icons.light_mode_outlined));
      await tester.pumpAndSettle();

      // Pindah ke Plants
      await tester.tap(find.text('Plants'));
      await tester.pumpAndSettle();

      // Ikon tetap dark_mode
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('pencarian di halaman Plants dapat menemukan tanaman', (
      tester,
    ) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      // Navigasi ke Plants
      await tester.tap(find.byKey(const Key('Plants')));
      await tester.pumpAndSettle();

      // Buka search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Ketik nama tanaman
      await tester.enterText(find.byType(TextField), 'Tomat');
      await tester.pumpAndSettle();

      // Hanya Tomat yang tampil
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Tomat'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('navigasi kembali ke Home dari Plants menggunakan BottomNav', (
      tester,
    ) async {
      await tester.pumpWidget(const DelcomPlantsApp());
      await tester.pumpAndSettle();

      // Navigasi ke Plants
      await tester.tap(find.byKey(const Key('Plants')));
      await tester.pumpAndSettle();

      // Kembali ke Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Home ditampilkan
      expect(find.textContaining('Delcom Plants'), findsOneWidget);
    });
  });
}
