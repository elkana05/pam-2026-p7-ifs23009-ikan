import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/route_constants.dart';
import '../../data/models/fish_model.dart';
import '../../providers/fish_provider.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import 'widgets/fish_image_widget.dart';

class FishFormScreen extends StatefulWidget {
  const FishFormScreen.add({super.key})
    : mode = FishFormMode.add,
      fishId = null;

  const FishFormScreen.edit({super.key, required this.fishId})
    : mode = FishFormMode.edit;

  final FishFormMode mode;
  final String? fishId;

  @override
  State<FishFormScreen> createState() => _FishFormScreenState();
}

enum FishFormMode { add, edit }

class _FishFormScreenState extends State<FishFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _habitatController = TextEditingController();
  final _makananController = TextEditingController();
  String _selectedImagePath = fishImageOptions.first.path;
  Uint8List? _selectedImageBytes;
  File? _selectedImageFile;
  bool _isSaving = false;
  bool _isInitialized = false;

  bool get _isEdit => widget.mode == FishFormMode.edit;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FishProvider>().loadFishById(widget.fishId!);
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _habitatController.dispose();
    _makananController.dispose();
    super.dispose();
  }

  void _populateForm(FishModel fish) {
    if (_isInitialized) return;
    _namaController.text = fish.nama;
    _deskripsiController.text = fish.deskripsi;
    _habitatController.text = fish.habitat;
    _makananController.text = fish.makanan;
    _selectedImagePath = fish.imagePath.isNotEmpty
        ? fish.imagePath
        : fishImageOptions.first.path;
    _selectedImageBytes = fish.imageBytes;
    _isInitialized = true;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _selectedImageBytes = bytes;
      _selectedImageFile = kIsWeb ? null : File(picked.path);
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(FishProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = _isEdit
        ? await provider.editFish(
            id: widget.fishId!,
            nama: _namaController.text.trim(),
            imagePath: _selectedImagePath,
            imageBytes: _selectedImageBytes,
            deskripsi: _deskripsiController.text.trim(),
            habitat: _habitatController.text.trim(),
            makanan: _makananController.text.trim(),
          )
        : await provider.addFish(
            nama: _namaController.text.trim(),
            imagePath: _selectedImagePath,
            imageBytes: _selectedImageBytes,
            deskripsi: _deskripsiController.text.trim(),
            habitat: _habitatController.text.trim(),
            makanan: _makananController.text.trim(),
          );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Data ikan berhasil diperbarui.'
                : 'Data ikan berhasil ditambahkan.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FishProvider>(
      builder: (context, provider, _) {
        final fish = provider.selectedFish;
        if (_isEdit && fish != null) {
          _populateForm(fish);
        }

        final showLoading =
            _isEdit && !_isInitialized && provider.status == FishStatus.loading;
        final showError =
            _isEdit && provider.status == FishStatus.error && fish == null;

        return Scaffold(
          appBar: TopAppBarWidget(
            title: _isEdit ? 'Edit Ikan' : 'Tambah Ikan',
            showBackButton: true,
            fallbackRoute: RouteConstants.fish,
          ),
          body: showLoading
              ? const Center(child: CircularProgressIndicator())
              : showError
              ? Center(child: Text(provider.errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _FormHero(isEdit: _isEdit),
                        const SizedBox(height: 16),
                        _FormSection(
                          title: 'Gambar ikan',
                          subtitle:
                              'Upload gambar yang paling sesuai agar data ikan terlihat menarik.',
                          child: _buildImageSelector(),
                        ),
                        const SizedBox(height: 20),
                        _FormSection(
                          title: 'Informasi utama',
                          subtitle:
                              'Isi nama, deskripsi, habitat, dan makanan ikan secara lengkap.',
                          child: Column(
                            children: [
                              _buildField(
                                controller: _namaController,
                                label: 'Nama Ikan',
                                hint: 'Contoh: Arwana',
                                icon: Icons.set_meal_outlined,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: _deskripsiController,
                                label: 'Deskripsi',
                                hint: 'Deskripsikan ikan ini...',
                                icon: Icons.description_outlined,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: _habitatController,
                                label: 'Habitat',
                                hint: 'Contoh: Sungai air tawar',
                                icon: Icons.water_outlined,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                controller: _makananController,
                                label: 'Makanan',
                                hint: 'Contoh: Serangga dan ikan kecil',
                                icon: Icons.restaurant_outlined,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _isSaving ? null : () => _submit(provider),
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildImageSelector() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _showImageSourceSheet,
          child: Stack(
            children: [
              FishImageWidget(
                imagePath: _selectedImagePath,
                imageBytes: _selectedImageBytes,
                height: 200,
                borderRadius: BorderRadius.circular(12),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Ganti Gambar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _showImageSourceSheet,
          icon: const Icon(Icons.upload_outlined),
          label: Text(
            _selectedImageBytes != null
                ? 'Pilih Ulang Gambar'
                : 'Upload Gambar Sendiri',
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Gunakan foto yang jelas agar tampilan daftar dan detail ikan terlihat lebih rapi.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        if (_selectedImageBytes != null) ...[
          const SizedBox(height: 8),
          Text(
            'Menggunakan gambar baru${_selectedImageFile != null ? ' dari perangkat' : ''}.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label tidak boleh kosong.';
        }
        return null;
      },
    );
  }
}

class _FormHero extends StatelessWidget {
  const _FormHero({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isEdit ? Icons.edit_outlined : Icons.add_circle_outline,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Perbarui data ikan' : 'Tambah data ikan baru',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEdit
                      ? 'Ubah informasi dan gambar agar koleksi ikan tetap rapi.'
                      : 'Lengkapi gambar dan informasi agar koleksi ikan terlihat menarik.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class FishImageOption {
  const FishImageOption({required this.label, required this.path});

  final String label;
  final String path;
}

const List<FishImageOption> fishImageOptions = [
  FishImageOption(label: 'Arapaima', path: 'assets/images/arapaima.jpg'),
  FishImageOption(label: 'Arwana', path: 'assets/images/arwana.jpg'),
  FishImageOption(label: 'Discus Fish', path: 'assets/images/discusfish.jpg'),
  FishImageOption(
    label: 'Flowerhorn Cichlid',
    path: 'assets/images/flowerhorncichlid.jpg',
  ),
  FishImageOption(
    label: 'Golden Basslet',
    path: 'assets/images/goldenbasslet.jpg',
  ),
  FishImageOption(
    label: 'Clarion Angelfish',
    path: 'assets/images/clarionangelfish.jpg',
  ),
];
