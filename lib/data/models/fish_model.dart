import '../../core/constants/api_constants.dart';
import 'dart:typed_data';

class FishModel {
  const FishModel({
    this.id,
    required this.name,
    this.gambar = '',
    this.pathGambar = '',
    this.imageBytes,
    required this.price,
    required this.description,
    required this.origin,
    required this.size,
    required this.lifespan,
    required this.difficulty,
  });

  final String? id;
  final String name;
  final String gambar;
  final String pathGambar;
  final Uint8List? imageBytes;
  final String price;
  final String description;
  final String origin;
  final String size;
  final String lifespan;
  final String difficulty;

  factory FishModel.fromJson(Map<String, dynamic> json) {
    final pathGambar = json['pathGambar'] as String? ?? '';
    final fileName = pathGambar.split('/').isNotEmpty
        ? pathGambar.split('/').last
        : '';

    return FishModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      gambar: fileName.isNotEmpty
          ? '${ApiConstants.baseUrl}/static/fish/$fileName'
          : '',
      pathGambar: pathGambar,
      imageBytes: null,
      price: json['price'] as String? ?? '',
      description: json['description'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      size: json['size'] as String? ?? '',
      lifespan: json['lifespan'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
    );
  }

  FishModel copyWith({
    String? id,
    String? name,
    String? gambar,
    String? pathGambar,
    Uint8List? imageBytes,
    String? price,
    String? description,
    String? origin,
    String? size,
    String? lifespan,
    String? difficulty,
  }) {
    return FishModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gambar: gambar ?? this.gambar,
      pathGambar: pathGambar ?? this.pathGambar,
      imageBytes: imageBytes ?? this.imageBytes,
      price: price ?? this.price,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      size: size ?? this.size,
      lifespan: lifespan ?? this.lifespan,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
