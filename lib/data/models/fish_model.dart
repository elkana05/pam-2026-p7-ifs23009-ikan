import 'dart:typed_data';

class FishModel {
  const FishModel({
    required this.id,
    required this.nama,
    required this.imagePath,
    this.imageBytes,
    required this.deskripsi,
    required this.habitat,
    required this.makanan,
  });

  final String id;
  final String nama;
  final String imagePath;
  final Uint8List? imageBytes;
  final String deskripsi;
  final String habitat;
  final String makanan;

  FishModel copyWith({
    String? id,
    String? nama,
    String? imagePath,
    Uint8List? imageBytes,
    bool clearImageBytes = false,
    String? deskripsi,
    String? habitat,
    String? makanan,
  }) {
    return FishModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      imagePath: imagePath ?? this.imagePath,
      imageBytes: clearImageBytes ? null : imageBytes ?? this.imageBytes,
      deskripsi: deskripsi ?? this.deskripsi,
      habitat: habitat ?? this.habitat,
      makanan: makanan ?? this.makanan,
    );
  }
}
