import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/api_response_model.dart';
import '../models/fish_model.dart';

class FishService {
  FishService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ApiResponse<List<FishModel>>> getFish({String search = ''}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.fish}');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      final jsonList = dataMap['fishes'] as List<dynamic>;
      final fish = jsonList
          .map((item) => FishModel.fromJson(item as Map<String, dynamic>))
          .toList();
      final filtered = search.isEmpty
          ? fish
          : fish
                .where(
                  (item) =>
                      item.name.toLowerCase().contains(search.toLowerCase()),
                )
                .toList();
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Berhasil.',
        data: filtered,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  Future<ApiResponse<FishModel>> getFishById(String id) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.fishById(id)}',
    );
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      final fish = FishModel.fromJson(dataMap['fish'] as Map<String, dynamic>);
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Berhasil.',
        data: fish,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
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
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.fish}');
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['price'] = price
      ..fields['description'] = description
      ..fields['origin'] = origin
      ..fields['size'] = size
      ..fields['lifespan'] = lifespan
      ..fields['difficulty'] = difficulty;

    if (kIsWeb && imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: imageFilename,
        ),
      );
    } else if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>? ?? {};
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Fish berhasil ditambahkan.',
        data: (dataMap['fishId'] ?? dataMap['id'] ?? '') as String,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
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
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.fishById(id)}',
    );
    final request = http.MultipartRequest('PUT', uri)
      ..fields['name'] = name
      ..fields['price'] = price
      ..fields['description'] = description
      ..fields['origin'] = origin
      ..fields['size'] = size
      ..fields['lifespan'] = lifespan
      ..fields['difficulty'] = difficulty;

    if (kIsWeb && imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: imageFilename,
        ),
      );
    } else if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Fish berhasil diperbarui.',
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  Future<ApiResponse<void>> deleteFish(String id) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.fishById(id)}',
    );
    final response = await _client.delete(uri);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return const ApiResponse(
        success: true,
        message: 'Fish berhasil dihapus.',
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ??
          'Gagal. Kode: ${response.statusCode}';
    } catch (_) {
      return 'Gagal. Kode: ${response.statusCode}';
    }
  }
}
