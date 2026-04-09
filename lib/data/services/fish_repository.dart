import 'dart:io';
import 'dart:typed_data';

import '../models/api_response_model.dart';
import '../models/fish_model.dart';
import 'fish_service.dart';

class FishRepository {
  FishRepository({FishService? service}) : _service = service ?? FishService();

  final FishService _service;

  Future<ApiResponse<List<FishModel>>> getFish({String search = ''}) async {
    try {
      return await _service.getFish(search: search);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan jaringan: $e',
      );
    }
  }

  Future<ApiResponse<FishModel>> getFishById(String id) async {
    try {
      return await _service.getFishById(id);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan jaringan: $e',
      );
    }
  }

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
    try {
      return await _service.createFish(
        name: name,
        price: price,
        description: description,
        origin: origin,
        size: size,
        lifespan: lifespan,
        difficulty: difficulty,
        imageFile: imageFile,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan jaringan: $e',
      );
    }
  }

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
    try {
      return await _service.updateFish(
        id: id,
        name: name,
        price: price,
        description: description,
        origin: origin,
        size: size,
        lifespan: lifespan,
        difficulty: difficulty,
        imageFile: imageFile,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan jaringan: $e',
      );
    }
  }

  Future<ApiResponse<void>> deleteFish(String id) async {
    try {
      return await _service.deleteFish(id);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan jaringan: $e',
      );
    }
  }
}
