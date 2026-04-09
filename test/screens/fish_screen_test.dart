import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/features/fish/fish_screen.dart';
import 'package:pam_p7_2026_ifs23009/providers/fish_provider.dart';

Widget buildFishScreenTest() {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final provider = FishProvider();
  final router = GoRouter(
    initialLocation: '/fish',
    routes: [
      GoRoute(path: '/fish', builder: (_, __) => const FishScreen()),
      GoRoute(path: '/fish/add', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/fish/:id', builder: (_, __) => const SizedBox()),
    ],
  );

  return ThemeProvider(
    notifier: notifier,
    child: ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    ),
  );
}

void main() {
  group('FishScreen', () {
    testWidgets('menampilkan daftar ikan awal', (tester) async {
      await tester.pumpWidget(buildFishScreenTest());
      await tester.pumpAndSettle();

      expect(find.text('Topik ikan'), findsOneWidget);
      expect(find.text('Koleksi ikan'), findsOneWidget);
      expect(find.text('Arapaima'), findsOneWidget);
      expect(
        find.textContaining('salah satu ikan air tawar terbesar'),
        findsOneWidget,
      );
    });

    testWidgets('menampilkan tombol FAB untuk tambah ikan', (tester) async {
      await tester.pumpWidget(buildFishScreenTest());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('menampilkan search icon di AppBar', (tester) async {
      await tester.pumpWidget(buildFishScreenTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
