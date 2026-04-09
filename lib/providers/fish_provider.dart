import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../data/models/fish_model.dart';

enum FishStatus { initial, loading, success, error }

class FishProvider extends ChangeNotifier {
  FishStatus _status = FishStatus.initial;
  final List<FishModel> _fish = List.of(_initialFish);
  FishModel? _selectedFish;
  String _searchQuery = '';
  String _errorMessage = '';

  FishStatus get status => _status;
  FishModel? get selectedFish => _selectedFish;
  String get searchQuery => _searchQuery;
  String get errorMessage => _errorMessage;

  List<FishModel> get fish {
    if (_searchQuery.isEmpty) return List.unmodifiable(_fish);
    return _fish
        .where(
          (item) =>
              item.nama.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList(growable: false);
  }

  Future<void> loadFish() async {
    _setStatus(FishStatus.loading);
    _errorMessage = '';
    await Future<void>.delayed(Duration.zero);
    _setStatus(FishStatus.success);
  }

  Future<void> loadFishById(String id) async {
    _setStatus(FishStatus.loading);
    await Future<void>.delayed(Duration.zero);
    try {
      _selectedFish = _fish.firstWhere((item) => item.id == id);
      _errorMessage = '';
      _setStatus(FishStatus.success);
    } catch (_) {
      _selectedFish = null;
      _errorMessage = 'Data ikan tidak ditemukan.';
      _setStatus(FishStatus.error);
    }
  }

  Future<bool> addFish({
    required String nama,
    required String imagePath,
    Uint8List? imageBytes,
    required String deskripsi,
    required String habitat,
    required String makanan,
  }) async {
    _setStatus(FishStatus.loading);
    final newFish = FishModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nama: nama,
      imagePath: imagePath,
      imageBytes: imageBytes,
      deskripsi: deskripsi,
      habitat: habitat,
      makanan: makanan,
    );
    _fish.insert(0, newFish);
    _selectedFish = newFish;
    _errorMessage = '';
    _setStatus(FishStatus.success);
    return true;
  }

  Future<bool> editFish({
    required String id,
    required String nama,
    required String imagePath,
    Uint8List? imageBytes,
    required String deskripsi,
    required String habitat,
    required String makanan,
  }) async {
    _setStatus(FishStatus.loading);
    final index = _fish.indexWhere((item) => item.id == id);
    if (index == -1) {
      _errorMessage = 'Data ikan tidak ditemukan.';
      _setStatus(FishStatus.error);
      return false;
    }

    final updated = _fish[index].copyWith(
      nama: nama,
      imagePath: imagePath,
      imageBytes: imageBytes,
      clearImageBytes: imageBytes == null,
      deskripsi: deskripsi,
      habitat: habitat,
      makanan: makanan,
    );
    _fish[index] = updated;
    _selectedFish = updated;
    _errorMessage = '';
    _setStatus(FishStatus.success);
    return true;
  }

  Future<bool> removeFish(String id) async {
    _setStatus(FishStatus.loading);
    final originalLength = _fish.length;
    _fish.removeWhere((item) => item.id == id);
    if (_fish.length == originalLength) {
      _errorMessage = 'Data ikan tidak ditemukan.';
      _setStatus(FishStatus.error);
      return false;
    }
    if (_selectedFish?.id == id) {
      _selectedFish = null;
    }
    _errorMessage = '';
    _setStatus(FishStatus.success);
    return true;
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
}

const List<FishModel> _initialFish = [
  FishModel(
    id: 'fish-arapaima',
    nama: 'Arapaima',
    imagePath: 'assets/images/arapaima.jpg',
    deskripsi:
        'Arapaima dikenal sebagai salah satu ikan air tawar terbesar di dunia. Tubuhnya panjang, kuat, dan sering menjadi daya tarik utama dalam akuarium raksasa maupun koleksi ikan eksotis.',
    habitat:
        'Hidup di sungai, danau banjir, dan rawa air tawar yang tenang dengan suhu hangat.',
    makanan:
        'Memakan ikan kecil, krustasea, serangga, dan pakan berprotein tinggi.',
  ),
  FishModel(
    id: 'fish-arwana',
    nama: 'Arwana',
    imagePath: 'assets/images/arwana.jpg',
    deskripsi:
        'Arwana adalah ikan hias premium yang identik dengan gerakan anggun, tubuh memanjang, dan sisik besar berkilau. Ikan ini sering dipelihara karena tampilannya yang elegan.',
    habitat:
        'Umumnya hidup di perairan tawar yang tenang seperti sungai lambat, danau, atau akuarium besar.',
    makanan:
        'Menyukai serangga, udang, cacing, dan ikan kecil sebagai sumber protein.',
  ),
  FishModel(
    id: 'fish-discus',
    nama: 'Discus Fish',
    imagePath: 'assets/images/discusfish.jpg',
    deskripsi:
        'Discus Fish memiliki bentuk tubuh menyerupai cakram dengan kombinasi warna cerah yang sangat menarik. Ikan ini populer di kalangan pecinta akuarium karena tampilannya yang artistik.',
    habitat:
        'Cocok di air tawar hangat, bersih, dan tenang dengan kualitas air yang stabil.',
    makanan:
        'Biasanya diberi cacing darah, pelet khusus discus, larva, dan pakan beku.',
  ),
  FishModel(
    id: 'fish-flowerhorn',
    nama: 'Flowerhorn Cichlid',
    imagePath: 'assets/images/flowerhorncichlid.jpg',
    deskripsi:
        'Flowerhorn Cichlid terkenal karena benjolan kepala khas, warna tubuh tegas, dan perilaku yang aktif. Ikan ini sering dipilih sebagai pusat perhatian dalam akuarium.',
    habitat:
        'Biasanya dipelihara di akuarium air tawar dengan ruang gerak cukup luas dan air terjaga.',
    makanan:
        'Cocok diberi pelet berkualitas, udang kecil, cacing, dan pakan tambahan berprotein.',
  ),
  FishModel(
    id: 'fish-golden-basslet',
    nama: 'Golden Basslet',
    imagePath: 'assets/images/goldenbasslet.jpg',
    deskripsi:
        'Golden Basslet adalah ikan laut kecil dengan warna kuning keemasan yang cerah. Ukurannya mungil, tetapi penampilannya sangat menonjol di antara ikan hias laut lainnya.',
    habitat:
        'Hidup di area terumbu karang laut yang memiliki banyak celah dan perlindungan alami.',
    makanan:
        'Memakan plankton, organisme kecil, dan pakan mikro untuk ikan laut.',
  ),
  FishModel(
    id: 'fish-clarion',
    nama: 'Clarion Angelfish',
    imagePath: 'assets/images/clarionangelfish.jpg',
    deskripsi:
        'Clarion Angelfish merupakan ikan laut tropis dengan warna oranye cerah dan bentuk tubuh yang tegas. Ikan ini terlihat mewah dan sangat menarik untuk tampilan akuarium laut.',
    habitat:
        'Menempati perairan laut berbatu, karang, dan wilayah tropis dengan arus yang baik.',
    makanan:
        'Biasanya mengonsumsi spons, alga, dan berbagai invertebrata kecil.',
  ),
];
