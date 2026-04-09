// test/widget/bottom_nav_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/shared/widgets/bottom_nav_widget.dart';

Widget buildNavTestApp(String initialRoute) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: BottomNavWidget(child: child),
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const SizedBox(key: Key('home')),
          ),
          GoRoute(
            path: '/plants',
            builder: (_, _) => const SizedBox(key: Key('plants')),
          ),
          GoRoute(
            path: '/fish',
            builder: (_, _) => const SizedBox(key: Key('fish')),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const SizedBox(key: Key('profile')),
          ),
        ],
      ),
    ],
  );

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
  );
}

void main() {
  group('BottomNavWidget', () {
    testWidgets('merender empat item navigasi', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Plants'), findsOneWidget);
      expect(find.text('Fish'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('menampilkan ikon home aktif di halaman home', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('menekan Plants menavigasi ke halaman Plants', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Plants'));
      await tester.pumpAndSettle();

      // Halaman plants dirender
      expect(find.byKey(const Key('plants')), findsOneWidget);
    });

    testWidgets('menekan Fish menavigasi ke halaman Fish', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fish'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('fish')), findsOneWidget);
    });

    testWidgets('menekan Profile menavigasi ke halaman Profile', (
      tester,
    ) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile')), findsOneWidget);
    });

    testWidgets('menampilkan NavigationBar sebagai bottom bar', (tester) async {
      await tester.pumpWidget(buildNavTestApp('/'));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });
}
