// lib/core/constants/api_constants.dart

/// Konstanta untuk konfigurasi API
class ApiConstants {
  ApiConstants._();

  /// Base URL backend untuk plants dan fish.
  static const String baseUrl =
      'https://pam-2026-p4-ifs23009-be.mathyoselahahah.fun:8080';

  /// Endpoint plants
  static const String plants = '/plants';
  static const String fish = '/fish';

  /// Endpoint detail / edit / delete plant by UUID
  static String plantById(String id) => '/plants/$id';
  static String fishById(String id) => '/fish/$id';
}
