// test/widget/screens/profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/features/profile/profile_screen.dart';

Widget buildProfileTest() {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, _) => const ProfileScreen()),
  ]);

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  group('ProfileScreen', () {
    testWidgets('merender tanpa error', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('menampilkan judul "Profile" di AppBar', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('menampilkan foto profil (CircleAvatar)', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('menampilkan nama pengguna', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      // Nama default sesuai kode
      expect(find.text('Abdullah Ubaid'), findsOneWidget);
    });

    testWidgets('menampilkan username', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      expect(find.text('ifs23009'), findsOneWidget);
    });

    testWidgets('menampilkan kartu "Tentang Saya"', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      expect(find.text('Tentang Saya'), findsOneWidget);
    });

    testWidgets('halaman dapat di-scroll', (tester) async {
      await tester.pumpWidget(buildProfileTest());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}