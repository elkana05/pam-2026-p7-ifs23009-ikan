import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/data/models/api_response_model.dart';
import 'package:pam_p7_2026_ifs23009/data/models/fish_model.dart';
import 'package:pam_p7_2026_ifs23009/data/services/fish_image_cache_service.dart';
import 'package:pam_p7_2026_ifs23009/data/services/fish_repository.dart';
import 'package:pam_p7_2026_ifs23009/providers/fish_provider.dart';

class FakeFishImageCacheService extends FishImageCacheService {
  final Map<String, Uint8List> _cache = {};

  @override
  Future<Uint8List?> loadImage(String id) async => _cache[id];

  @override
  Future<void> saveImage(String id, Uint8List bytes) async {
    _cache[id] = bytes;
  }

  @override
  Future<void> removeImage(String id) async {
    _cache.remove(id);
  }
}

class MockFishRepository extends FishRepository {
  MockFishRepository({required this.mockFish, this.shouldFail = false});

  final List<FishModel> mockFish;
  final bool shouldFail;

  @override
  Future<ApiResponse<List<FishModel>>> getFish({String search = ''}) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal terhubung ke server.',
      );
    }
    return ApiResponse(success: true, message: 'OK', data: mockFish);
  }

  @override
  Future<ApiResponse<FishModel>> getFishById(String id) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal mengambil data.',
      );
    }
    return ApiResponse(
      success: true,
      message: 'OK',
      data: mockFish.firstWhere((item) => item.id == id),
    );
  }

  @override
  Future<ApiResponse<String>> createFish({
    required String name,
    required String price,
    required String description,
    required String origin,
    required String size,
    required String lifespan,
    required String difficulty,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'image.jpg',
  }) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal menambahkan data.',
      );
    }
    mockFish.insert(
      0,
      FishModel(
        id: 'new-fish-id',
        name: name,
        gambar: '',
        pathGambar: '',
        price: price,
        description: description,
        origin: origin,
        size: size,
        lifespan: lifespan,
        difficulty: difficulty,
      ),
    );
    return const ApiResponse(success: true, message: 'OK', data: 'new-fish-id');
  }

  @override
  Future<ApiResponse<void>> updateFish({
    required String id,
    required String name,
    required String price,
    required String description,
    required String origin,
    required String size,
    required String lifespan,
    required String difficulty,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'image.jpg',
  }) async {
    if (shouldFail) {
      return const ApiResponse(success: false, message: 'Gagal mengubah data.');
    }
    final index = mockFish.indexWhere((item) => item.id == id);
    mockFish[index] = mockFish[index].copyWith(
      name: name,
      price: price,
      description: description,
      origin: origin,
      size: size,
      lifespan: lifespan,
      difficulty: difficulty,
    );
    return const ApiResponse(success: true, message: 'OK');
  }

  @override
  Future<ApiResponse<void>> deleteFish(String id) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal menghapus data.',
      );
    }
    mockFish.removeWhere((item) => item.id == id);
    return const ApiResponse(success: true, message: 'OK');
  }
}

void main() {
  final testFish = <FishModel>[
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
    const FishModel(
      id: 'fish-2',
      name: 'Arwana',
      gambar: '',
      pathGambar: 'uploads/fish/2.jpg',
      price: '750000',
      description: 'Ikan hias premium.',
      origin: 'Asia',
      size: '90 cm',
      lifespan: '10 tahun',
      difficulty: 'Sedang',
    ),
  ];

  group('FishProvider', () {
    late FishProvider provider;
    late MockFishRepository repository;
    late FakeFishImageCacheService imageCache;

    setUp(() {
      repository = MockFishRepository(mockFish: List<FishModel>.from(testFish));
      imageCache = FakeFishImageCacheService();
      provider = FishProvider(repository: repository, imageCache: imageCache);
    });

    tearDown(() {
      provider.dispose();
    });

    test('status awal adalah initial', () {
      expect(provider.status, FishStatus.initial);
    });

    test('loadFish berhasil memuat data', () async {
      await provider.loadFish();
      expect(provider.status, FishStatus.success);
      expect(provider.fish.length, 2);
    });

    test('updateSearchQuery memfilter daftar ikan', () async {
      await provider.loadFish();
      provider.updateSearchQuery('arwana');
      expect(provider.fish.length, 1);
      expect(provider.fish.first.name, 'Arwana');
    });

    test('addFish menambahkan data baru', () async {
      await provider.loadFish();
      final success = await provider.addFish(
        name: 'Neon Tetra',
        price: '20000',
        description: 'Ikan kecil.',
        origin: 'Amerika Selatan',
        size: '4 cm',
        lifespan: '5 tahun',
        difficulty: 'Mudah',
      );
      expect(success, isTrue);
      expect(provider.fish.any((item) => item.name == 'Neon Tetra'), isTrue);
    });

    test('editFish mengubah data yang dipilih', () async {
      await provider.loadFish();
      final success = await provider.editFish(
        id: 'fish-1',
        name: 'Arapaima Baru',
        price: '900000',
        description: 'Deskripsi baru',
        origin: 'Brazil',
        size: '130 cm',
        lifespan: '18 tahun',
        difficulty: 'Sulit',
      );
      expect(success, isTrue);
      expect(provider.selectedFish?.name, 'Arapaima Baru');
    });

    test('removeFish menghapus data dari daftar', () async {
      await provider.loadFish();
      final success = await provider.removeFish('fish-1');
      expect(success, isTrue);
      expect(provider.fish.any((item) => item.id == 'fish-1'), isFalse);
    });
  });
}
