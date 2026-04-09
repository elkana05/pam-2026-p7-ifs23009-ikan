// lib/data/models/plant_model.dart

/// Model data untuk tanaman
/// Menggunakan immutable class (best practice Flutter/Dart)
class PlantModel {
  const PlantModel({
    this.id,
    required this.nama,
    this.gambar = '',
    this.pathGambar = '',
    required this.deskripsi,
    required this.manfaat,
    required this.efekSamping,
  });

  /// UUID dari database, contoh: "550e8400-e29b-41d4-a716-446655440000"
  final String? id;
  final String nama;

  /// URL publik gambar dari server, contoh: "https://host/static/plants/uuid.png"
  /// Dapat langsung digunakan oleh Image.network()
  final String gambar;

  /// Path relatif file di server, contoh: "uploads/plants/uuid.png"
  final String pathGambar;

  final String deskripsi;
  final String manfaat;
  final String efekSamping;

  /// Membuat PlantModel dari JSON (response API)
  /// Key JSON menggunakan camelCase sesuai response Ktor
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      gambar: json['gambar'] as String? ?? '',
      pathGambar: json['pathGambar'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      manfaat: json['manfaat'] as String? ?? '',
      efekSamping: json['efekSamping'] as String? ?? '',
    );
  }

  /// Metode copyWith memudahkan pembuatan objek baru dengan data yang diubah sebagian
  PlantModel copyWith({
    String? id,
    String? nama,
    String? gambar,
    String? pathGambar,
    String? deskripsi,
    String? manfaat,
    String? efekSamping,
  }) {
    return PlantModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      gambar: gambar ?? this.gambar,
      pathGambar: pathGambar ?? this.pathGambar,
      deskripsi: deskripsi ?? this.deskripsi,
      manfaat: manfaat ?? this.manfaat,
      efekSamping: efekSamping ?? this.efekSamping,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlantModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlantModel(id: $id, nama: $nama)';
}