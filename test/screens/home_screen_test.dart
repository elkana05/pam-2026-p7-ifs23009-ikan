import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/features/home/home_screen.dart';

Widget buildHomeTest() {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final router = GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
  );

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(theme: AppTheme.lightTheme, routerConfig: router),
  );
}

void main() {
  group('HomeScreen', () {
    testWidgets('merender tanpa error', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('menampilkan judul "Home" di AppBar', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('menampilkan teks "Delcom Fish"', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Delcom Fish'), findsOneWidget);
    });

    testWidgets('menampilkan minimal satu Card', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('menampilkan informasi topik ikan', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.text('Galeri ikan'), findsOneWidget);
      expect(find.text('Arapaima'), findsOneWidget);
      expect(find.textContaining('Ikan air tawar raksasa'), findsOneWidget);
    });

    testWidgets('tombol toggle light mode tersedia di AppBar', (tester) async {
      await tester.pumpWidget(buildHomeTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    });
  });
}
