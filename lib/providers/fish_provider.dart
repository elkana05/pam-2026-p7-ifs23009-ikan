import 'dart:io';

import 'package:flutter/foundation.dart';

import '../data/models/fish_model.dart';
import '../data/services/fish_image_cache_service.dart';
import '../data/services/fish_repository.dart';

enum FishStatus { initial, loading, success, error }

class FishProvider extends ChangeNotifier {
  FishProvider({FishRepository? repository, FishImageCacheService? imageCache})
    : _repository = repository ?? FishRepository(),
      _imageCache = imageCache ?? FishImageCacheService();

  final FishRepository _repository;
  final FishImageCacheService _imageCache;

  FishStatus _status = FishStatus.initial;
  List<FishModel> _fish = [];
  FishModel? _selectedFish;
  String _errorMessage = '';
  String _searchQuery = '';

  FishStatus get status => _status;
  FishModel? get selectedFish => _selectedFish;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<FishModel> get fish {
    if (_searchQuery.isEmpty) return List.unmodifiable(_fish);
    return _fish
        .where(
          (item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList(growable: false);
  }

  Future<void> loadFish() async {
    _setStatus(FishStatus.loading);
    final result = await _repository.getFish();
    if (result.success && result.data != null) {
      _fish = await _attachCachedImages(result.data!);
      _errorMessage = '';
      _setStatus(FishStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(FishStatus.error);
    }
  }

  Future<void> loadFishById(String id) async {
    _setStatus(FishStatus.loading);
    final result = await _repository.getFishById(id);
    if (result.success && result.data != null) {
      final bytes = await _imageCache.loadImage(result.data!.id!);
      _selectedFish = result.data!.copyWith(imageBytes: bytes);
      _errorMessage = '';
      _setStatus(FishStatus.success);
    } else {
      _selectedFish = null;
      _errorMessage = result.message;
      _setStatus(FishStatus.error);
    }
  }

  Future<bool> addFish({
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
    _setStatus(FishStatus.loading);
    final result = await _repository.createFish(
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
    if (result.success) {
      if (imageBytes != null &&
          result.data != null &&
          result.data!.isNotEmpty) {
        await _imageCache.saveImage(result.data!, imageBytes);
      }
      await loadFish();
      return true;
    }
    _errorMessage = result.message;
    _setStatus(FishStatus.error);
    return false;
  }

  Future<bool> editFish({
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
    _setStatus(FishStatus.loading);
    final result = await _repository.updateFish(
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
    if (result.success) {
      if (imageBytes != null) {
        await _imageCache.saveImage(id, imageBytes);
      }
      await loadFishById(id);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(FishStatus.error);
    return false;
  }

  Future<bool> removeFish(String id) async {
    _setStatus(FishStatus.loading);
    final result = await _repository.deleteFish(id);
    if (result.success) {
      _fish.removeWhere((item) => item.id == id);
      await _imageCache.removeImage(id);
      if (_selectedFish?.id == id) {
        _selectedFish = null;
      }
      _errorMessage = '';
      _setStatus(FishStatus.success);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(FishStatus.error);
    return false;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSelectedFish() {
    _selectedFish = null;
    notifyListeners();
  }

  void _setStatus(FishStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<List<FishModel>> _attachCachedImages(List<FishModel> fish) async {
    final mapped = <FishModel>[];
    for (final item in fish) {
      if (item.id == null) {
        mapped.add(item);
        continue;
      }
      final bytes = await _imageCache.loadImage(item.id!);
      mapped.add(item.copyWith(imageBytes: bytes));
    }
    return mapped;
  }
}
