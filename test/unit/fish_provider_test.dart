import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/providers/fish_provider.dart';

void main() {
  group('FishProvider', () {
    late FishProvider provider;

    setUp(() {
      provider = FishProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    test('status awal adalah initial', () {
      expect(provider.status, FishStatus.initial);
    });

    test('loadFish berhasil memuat data awal', () async {
      await provider.loadFish();

      expect(provider.status, FishStatus.success);
      expect(provider.fish, isNotEmpty);
    });

    test('updateSearchQuery memfilter daftar ikan', () async {
      await provider.loadFish();

      provider.updateSearchQuery('arwana');

      expect(provider.fish.length, 1);
      expect(provider.fish.first.nama, 'Arwana');
    });

    test('addFish menambahkan data baru', () async {
      await provider.loadFish();
      final before = provider.fish.length;

      final success = await provider.addFish(
        nama: 'Blue Tang',
        imagePath: 'assets/images/blue.jpg',
        deskripsi: 'Ikan laut tropis berwarna biru.',
        habitat: 'Terumbu karang.',
        makanan: 'Alga dan plankton.',
      );

      expect(success, isTrue);
      expect(provider.fish.length, before + 1);
      expect(provider.fish.first.nama, 'Blue Tang');
    });

    test('editFish mengubah data yang dipilih', () async {
      await provider.loadFish();
      final target = provider.fish.first;

      final success = await provider.editFish(
        id: target.id,
        nama: 'Arapaima Updated',
        imagePath: target.imagePath,
        deskripsi: target.deskripsi,
        habitat: 'Habitat baru',
        makanan: target.makanan,
      );

      expect(success, isTrue);
      expect(provider.selectedFish?.nama, 'Arapaima Updated');
      expect(provider.fish.first.habitat, 'Habitat baru');
    });

    test('removeFish menghapus data dari daftar', () async {
      await provider.loadFish();
      final targetId = provider.fish.first.id;

      final success = await provider.removeFish(targetId);

      expect(success, isTrue);
      expect(provider.fish.any((item) => item.id == targetId), isFalse);
    });
  });
}
