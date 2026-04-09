// lib/data/models/api_response_model.dart

/// Model umum untuk response API
/// Digunakan untuk membungkus data dari server
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final T? data;

  @override
  String toString() =>
      'ApiResponse(success: $success, message: $message, data: $data)';
}