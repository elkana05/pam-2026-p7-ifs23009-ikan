// test/unit/plant_provider_test.dart

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/data/models/api_response_model.dart';
import 'package:pam_p7_2026_ifs23009/data/models/plant_model.dart';
import 'package:pam_p7_2026_ifs23009/data/services/plant_repository.dart';
import 'package:pam_p7_2026_ifs23009/providers/plant_provider.dart';
import 'dart:typed_data';

/// Repository palsu (mock) untuk keperluan pengujian
/// Tidak melakukan HTTP request sungguhan
class MockPlantRepository extends PlantRepository {
  MockPlantRepository({
    required this.mockPlants,
    this.shouldFail = false,
  });

  final List<PlantModel> mockPlants;
  final bool shouldFail;

  @override
  Future<ApiResponse<List<PlantModel>>> getPlants({String search = ''}) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal terhubung ke server.',
      );
    }
    return ApiResponse(success: true, message: 'OK', data: mockPlants);
  }

  @override
  Future<ApiResponse<String>> createPlant({
    required String nama,
    required String deskripsi,
    required String manfaat,
    required String efekSamping,
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
    return const ApiResponse(
      success: true,
      message: 'OK',
      data: 'new-uuid-1234',
    );
  }

  @override
  Future<ApiResponse<void>> deletePlant(String id) async {
    if (shouldFail) {
      return const ApiResponse(
        success: false,
        message: 'Gagal menghapus data.',
      );
    }
    return const ApiResponse(success: true, message: 'OK');
  }
}

void main() {
  const testPlants = [
    PlantModel(
        id: 'uuid-wortel',
        nama: 'Wortel',
        gambar: 'https://host/static/plants/wortel.png',
        deskripsi: 'desc',
        manfaat: 'manfaat',
        efekSamping: 'efek'),
    PlantModel(
        id: 'uuid-tomat',
        nama: 'Tomat',
        gambar: 'https://host/static/plants/tomat.png',
        deskripsi: 'desc',
        manfaat: 'manfaat',
        efekSamping: 'efek'),
  ];

  group('PlantProvider', () {
    late PlantProvider provider;

    setUp(() {
      provider = PlantProvider(
        repository: MockPlantRepository(mockPlants: testPlants),
      );
    });

    tearDown(() {
      provider.dispose();
    });

    test('status awal adalah initial', () {
      expect(provider.status, equals(PlantStatus.initial));
    });

    test('loadPlants berhasil mengubah status ke success', () async {
      await provider.loadPlants();
      expect(provider.status, equals(PlantStatus.success));
      expect(provider.plants.length, equals(2));
    });

    test('loadPlants gagal mengubah status ke error', () async {
      provider = PlantProvider(
        repository: MockPlantRepository(
          mockPlants: [],
          shouldFail: true,
        ),
      );
      await provider.loadPlants();
      expect(provider.status, equals(PlantStatus.error));
      expect(provider.errorMessage, isNotEmpty);
    });

    test('updateSearchQuery memfilter daftar tanaman', () async {
      await provider.loadPlants();
      provider.updateSearchQuery('wortel');
      expect(provider.plants.length, equals(1));
      expect(provider.plants.first.nama, equals('Wortel'));
    });

    test('updateSearchQuery kosong menampilkan semua tanaman', () async {
      await provider.loadPlants();
      provider.updateSearchQuery('wortel');
      provider.updateSearchQuery('');
      expect(provider.plants.length, equals(2));
    });

    test('removePlant berhasil menghapus tanaman dari list', () async {
      await provider.loadPlants();
      final success = await provider.removePlant('uuid-wortel');
      expect(success, isTrue);
      expect(provider.plants.any((p) => p.id == 'uuid-wortel'), isFalse);
    });
  });
}