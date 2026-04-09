import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/app_theme.dart';
import 'package:pam_p7_2026_ifs23009/core/theme/theme_notifier.dart';
import 'package:pam_p7_2026_ifs23009/data/models/api_response_model.dart';
import 'package:pam_p7_2026_ifs23009/data/models/fish_model.dart';
import 'package:pam_p7_2026_ifs23009/data/services/fish_image_cache_service.dart';
import 'package:pam_p7_2026_ifs23009/data/services/fish_repository.dart';
import 'package:pam_p7_2026_ifs23009/features/fish/fish_detail_screen.dart';
import 'package:pam_p7_2026_ifs23009/providers/fish_provider.dart';

class FakeFishImageCacheService extends FishImageCacheService {}

class MockFishRepository extends FishRepository {
  MockFishRepository(this.mockFish);

  final List<FishModel> mockFish;

  @override
  Future<ApiResponse<FishModel>> getFishById(String id) async => ApiResponse(
    success: true,
    message: 'OK',
    data: mockFish.firstWhere((item) => item.id == id),
  );
}

Widget buildFishDetailTest(FishProvider provider) {
  final notifier = ThemeNotifier(initial: ThemeMode.light);
  final router = GoRouter(
    initialLocation: '/fish/fish-1',
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
    testWidgets('menampilkan section detail ikan dari API', (tester) async {
      final provider = FishProvider(
        repository: MockFishRepository([
          const FishModel(
            id: 'fish-1',
            name: 'Arapaima',
            gambar: '',
            pathGambar: 'uploads/fish/1.jpg',
            price: '500000',
            description: 'Ikan air tawar besar.',
            origin: 'Amazon',
            size: '120 cm',
            lifespan: '15 tahun',
            difficulty: 'Sulit',
          ),
        ]),
        imageCache: FakeFishImageCacheService(),
      );
      await provider.loadFishById('fish-1');
      await tester.pumpWidget(buildFishDetailTest(provider));
      await tester.pump();

      expect(find.text('Arapaima'), findsWidgets);
      expect(find.text('Deskripsi'), findsOneWidget);
      expect(find.text('Harga'), findsOneWidget);
      expect(find.text('Asal'), findsOneWidget);
      expect(find.text('Ukuran'), findsOneWidget);
      expect(find.text('Usia Hidup'), findsOneWidget);
      expect(find.text('Tingkat Kesulitan'), findsOneWidget);
    });
  });
}
