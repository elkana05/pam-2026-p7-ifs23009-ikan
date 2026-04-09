import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class FishImageCacheService {
  static const String _prefix = 'fish_image_cache_';

  Future<Uint8List?> loadImage(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$id');
    if (raw == null || raw.isEmpty) return null;
    return base64Decode(raw);
  }

  Future<void> saveImage(String id, Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$id', base64Encode(bytes));
  }

  Future<void> removeImage(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$id');
  }
}
