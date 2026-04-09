import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/features/fish/fish_detail_screen.dart';
import 'package:pam_p7_2026_ifs23009/providers/fish_provider.dart';

Widget buildFishDetailTest() {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final provider = FishProvider();
  final router = GoRouter(
    initialLocation: '/fish/fish-arapaima',
    routes: [
      GoRoute(
        path: '/fish/:id',
        builder: (_, state) =>
            FishDetailScreen(fishId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/fish/:id/edit', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/fish', builder: (_, __) => const SizedBox()),
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
  group('FishDetailScreen', () {
    testWidgets('menampilkan section detail ikan dengan teks lengkap', (
      tester,
    ) async {
      await tester.pumpWidget(buildFishDetailTest());
      await tester.pumpAndSettle();

      expect(find.text('Arapaima'), findsWidgets);
      expect(find.text('Deskripsi'), findsOneWidget);
      expect(find.text('Habitat'), findsOneWidget);
      expect(find.text('Makanan'), findsOneWidget);
      expect(find.text('Galeri Asset'), findsOneWidget);
    });
  });
}
