// test/widget/plants_screen_test.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/data/models/api_response_model.dart';
import 'package:pam_p7_2026_ifs23009/data/models/plant_model.dart';
import 'package:pam_p7_2026_ifs23009/data/services/plant_repository.dart';
import 'package:pam_p7_2026_ifs23009/features/plants/plants_screen.dart';
import 'package:pam_p7_2026_ifs23009/providers/plant_provider.dart';

class MockPlantRepository extends PlantRepository {
  final List<PlantModel> plants;
  MockPlantRepository(this.plants);

  @override
  Future<ApiResponse<List<PlantModel>>> getPlants({String search = ''}) async =>
      ApiResponse(success: true, message: 'OK', data: plants);
}

Widget buildPlantsScreenTest(List<PlantModel> plants) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final provider = PlantProvider(
    repository: MockPlantRepository(plants),
  );
  final router = GoRouter(
    initialLocation: '/plants',
    routes: [
      GoRoute(
        path: '/plants',
        builder: (_, __) => const PlantsScreen(),
      ),
      GoRoute(
        path: '/plants/:id',
        builder: (_, __) => const SizedBox(),
      ),
      GoRoute(
        path: '/plants/add',
        builder: (_, __) => const SizedBox(),
      ),
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
  const testPlants = [
    PlantModel(
        id: 'uuid-wortel',
        nama: 'Wortel',
        gambar: 'https://host/static/plants/wortel.png',
        deskripsi: 'Sayuran berwarna oranye.',
        manfaat: 'Baik untuk mata.',
        efekSamping: 'Karotenemia.'),
    PlantModel(
        id: 'uuid-tomat',
        nama: 'Tomat',
        gambar: 'https://host/static/plants/tomat.png',
        deskripsi: 'Buah merah segar.',
        manfaat: 'Kaya antioksidan.',
        efekSamping: 'Asam lambung.'),
  ];

  group('PlantsScreen', () {
    testWidgets('menampilkan daftar tanaman dari API', (tester) async {
      await tester.pumpWidget(buildPlantsScreenTest(testPlants));
      await tester.pumpAndSettle();

      expect(find.text('Wortel'), findsOneWidget);
      expect(find.text('Tomat'), findsOneWidget);
    });

    testWidgets('menampilkan pesan kosong ketika tidak ada tanaman',
            (tester) async {
          await tester.pumpWidget(buildPlantsScreenTest([]));
          await tester.pumpAndSettle();

          expect(find.text('Tidak ada data tanaman!'), findsOneWidget);
        });

    testWidgets('menampilkan tombol FAB untuk tambah tanaman',
            (tester) async {
          await tester.pumpWidget(buildPlantsScreenTest(testPlants));
          await tester.pumpAndSettle();

          expect(find.byType(FloatingActionButton), findsOneWidget);
          expect(find.byIcon(Icons.add), findsOneWidget);
        });

    testWidgets('menampilkan search icon di AppBar', (tester) async {
      await tester.pumpWidget(buildPlantsScreenTest(testPlants));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}