// test/unit/plant_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/data/models/plant_model.dart';

void main() {
  group('PlantModel', () {
    const uuid = '550e8400-e29b-41d4-a716-446655440000';

    const plant = PlantModel(
      id: uuid,
      nama: 'Wortel',
      gambar:
      'https://pam-2026-p4-ifs23009-be.delcom.org:8080/static/plants/uuid.png',
      pathGambar: 'uploads/plants/uuid.png',
      deskripsi: 'Sayuran berwarna oranye.',
      manfaat: 'Baik untuk kesehatan mata.',
      efekSamping: 'Karotenemia jika berlebihan.',
    );

    test('membuat objek dengan semua field yang benar', () {
      expect(plant.id, equals(uuid));
      expect(plant.nama, equals('Wortel'));
      expect(plant.gambar, contains('/static/plants/'));
    });

    test('fromJson memetakan field dengan benar', () {
      final json = {
        'id': uuid,
        'nama': 'Wortel',
        'gambar':
        'https://pam-2026-p4-ifs23009-be.delcom.org:8080/static/plants/uuid.png',
        'pathGambar': 'uploads/plants/uuid.png',
        'deskripsi': 'Sayuran berwarna oranye.',
        'manfaat': 'Baik untuk kesehatan mata.',
        'efekSamping': 'Karotenemia jika berlebihan.',
      };
      final result = PlantModel.fromJson(json);
      expect(result.id, equals(uuid));
      expect(result.nama, equals('Wortel'));
      expect(result.efekSamping, equals('Karotenemia jika berlebihan.'));
      // gambar sudah berisi URL lengkap dari server
      expect(result.gambar, contains('http'));
    });

    test('copyWith mengubah hanya field yang diberikan', () {
      final updated = plant.copyWith(nama: 'Tomat');
      expect(updated.nama, equals('Tomat'));
      expect(updated.id, equals(plant.id));
      expect(updated.deskripsi, equals(plant.deskripsi));
    });

    test('dua objek dengan UUID yang sama dianggap equal', () {
      const other = PlantModel(
        id: uuid,
        nama: 'Wortel Berbeda',
        gambar: 'https://example.com/lain.jpg',
        deskripsi: '-',
        manfaat: '-',
        efekSamping: '-',
      );
      expect(plant, equals(other));
    });

    test('toString menampilkan id dan nama plant', () {
      expect(plant.toString(), contains('Wortel'));
      expect(plant.toString(), contains(uuid));
    });
  });
}