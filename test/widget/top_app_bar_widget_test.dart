// test/widget/top_app_bar_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/shared/widgets/top_app_bar_widget.dart';

/// Helper untuk membungkus widget dengan semua provider yang dibutuhkan
Widget buildTestApp({required Widget child}) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, _) => child),
  ]);

  return ThemeProvider(
    notifier: notifier,
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  group('TopAppBarWidget', () {
    testWidgets('menampilkan judul dengan benar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const Scaffold(
          appBar: TopAppBarWidget(title: 'Delcom Plants'),
          body: SizedBox(),
        ),
      ));

      expect(find.text('Delcom Plants'), findsOneWidget);
    });

    testWidgets('tidak menampilkan tombol back secara default', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const Scaffold(
          appBar: TopAppBarWidget(title: 'Home'),
          body: SizedBox(),
        ),
      ));

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('menampilkan tombol back saat showBackButton = true',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Detail', showBackButton: true),
              body: SizedBox(),
            ),
          ));

          expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        });

    testWidgets('menampilkan tombol toggle light mode', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const Scaffold(
          appBar: TopAppBarWidget(title: 'Home'),
          body: SizedBox(),
        ),
      ));

      // Dalam light mode, ikon yang tampil adalah light_mode
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    });

    testWidgets('tombol toggle mengubah ikon saat ditekan', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const Scaffold(
          appBar: TopAppBarWidget(title: 'Home'),
          body: SizedBox(),
        ),
      ));

      // Awalnya light mode → ikon dark_mode
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

      // Tekan toggle
      await tester.tap(find.byIcon(Icons.light_mode_outlined));
      await tester.pumpAndSettle();

      // Setelah toggle → ikon light_mode
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('menampilkan tombol search saat withSearch = true',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Plants', withSearch: true),
              body: SizedBox(),
            ),
          ));

          expect(find.byIcon(Icons.search), findsOneWidget);
        });

    testWidgets('menekan tombol search menampilkan TextField', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const Scaffold(
          appBar: TopAppBarWidget(title: 'Plants', withSearch: true),
          body: SizedBox(),
        ),
      ));

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('menekan tombol close menutup search dan mereset query',
            (tester) async {
          String query = '';

          await tester.pumpWidget(buildTestApp(
            child: Scaffold(
              appBar: TopAppBarWidget(
                title: 'Plants',
                withSearch: true,
                onSearchQueryChange: (q) => query = q,
              ),
              body: const SizedBox(),
            ),
          ));

          // Buka search
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();

          // Ketik sesuatu
          await tester.enterText(find.byType(TextField), 'wortel');
          await tester.pump();

          // Tutup search
          await tester.tap(find.byIcon(Icons.close));
          await tester.pumpAndSettle();

          // TextField hilang, query direset
          expect(find.byType(TextField), findsNothing);
          expect(query, equals(''));
        });

    testWidgets('tidak menampilkan tombol search secara default',
            (tester) async {
          await tester.pumpWidget(buildTestApp(
            child: const Scaffold(
              appBar: TopAppBarWidget(title: 'Profile'),
              body: SizedBox(),
            ),
          ));

          expect(find.byIcon(Icons.search), findsNothing);
        });
  });
}