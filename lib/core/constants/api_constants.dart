// lib/core/constants/api_constants.dart

/// Konstanta untuk konfigurasi API
class ApiConstants {
  ApiConstants._();

  /// Base URL API Delcom Plants
  /// Modifikasi username `ifs18005` sesuai dengan username kamu.
  static const String baseUrl =
      'https://pam-2026-p4-ifs23009-be.mathyoselahahah.fun:8080';

  /// Endpoint plants
  static const String plants = '/plants';

  /// Endpoint detail / edit / delete plant by UUID
  static String plantById(String id) => '/plants/$id';
}
