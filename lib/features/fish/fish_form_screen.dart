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
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originController = TextEditingController();
  final _sizeController = TextEditingController();
  final _lifespanController = TextEditingController();
  final _difficultyController = TextEditingController();

  File? _imageFile;
  Uint8List? _imageBytes;
  String _imageFilename = 'image.jpg';
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get _isEdit => widget.mode == FishFormMode.edit;
  bool get _hasImage => _imageBytes != null;

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
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _originController.dispose();
    _sizeController.dispose();
    _lifespanController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  void _populateForm(FishModel fish) {
    if (_isInitialized) return;
    _nameController.text = fish.name;
    _priceController.text = fish.price;
    _descriptionController.text = fish.description;
    _originController.text = fish.origin;
    _sizeController.text = fish.size;
    _lifespanController.text = fish.lifespan;
    _difficultyController.text = fish.difficulty;
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
      _imageBytes = bytes;
      _imageFilename = picked.name;
      _imageFile = kIsWeb ? null : File(picked.path);
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

  Future<void> _submit(FishModel? original) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isEdit && !_hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final provider = context.read<FishProvider>();

    final success = _isEdit
        ? await provider.editFish(
            id: original!.id!,
            name: _nameController.text.trim(),
            price: _priceController.text.trim(),
            description: _descriptionController.text.trim(),
            origin: _originController.text.trim(),
            size: _sizeController.text.trim(),
            lifespan: _lifespanController.text.trim(),
            difficulty: _difficultyController.text.trim(),
            imageFile: _imageFile,
            imageBytes: _imageBytes,
            imageFilename: _imageFilename,
          )
        : await provider.addFish(
            name: _nameController.text.trim(),
            price: _priceController.text.trim(),
            description: _descriptionController.text.trim(),
            origin: _originController.text.trim(),
            size: _sizeController.text.trim(),
            lifespan: _lifespanController.text.trim(),
            difficulty: _difficultyController.text.trim(),
            imageFile: _imageFile,
            imageBytes: _imageBytes,
            imageFilename: _imageFilename,
          );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Fish berhasil diperbarui.'
                : 'Fish berhasil ditambahkan.',
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
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<FishProvider>(
      builder: (context, provider, _) {
        final fish = provider.selectedFish;
        if (_isEdit && fish != null) {
          _populateForm(fish);
        }

        return Scaffold(
          appBar: TopAppBarWidget(
            title: _isEdit ? 'Edit Fish' : 'Tambah Fish',
            showBackButton: true,
            fallbackRoute: RouteConstants.fish,
          ),
          body: _isEdit && fish == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: _showImageSourceSheet,
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colorScheme.outline),
                            ),
                            child: _hasImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      _imageBytes!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _isEdit
                                            ? 'Ketuk untuk ganti gambar (opsional)'
                                            : 'Ketuk untuk memilih gambar *',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          controller: _nameController,
                          label: 'Nama Fish',
                          hint: 'Contoh: Arwana Platinum',
                          icon: Icons.set_meal_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _priceController,
                          label: 'Harga',
                          hint: 'Contoh: 2500000',
                          icon: Icons.payments_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _descriptionController,
                          label: 'Deskripsi',
                          hint: 'Deskripsikan fish ini...',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _originController,
                          label: 'Asal',
                          hint: 'Contoh: Jepang',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _sizeController,
                          label: 'Ukuran',
                          hint: 'Contoh: 20 cm',
                          icon: Icons.straighten_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _lifespanController,
                          label: 'Usia Hidup',
                          hint: 'Contoh: 5 tahun',
                          icon: Icons.schedule_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _difficultyController,
                          label: 'Tingkat Kesulitan',
                          hint: 'Contoh: Sulit',
                          icon: Icons.stacked_line_chart_outlined,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _isLoading ? null : () => _submit(fish),
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(_isLoading ? 'Menyimpan...' : 'Simpan'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
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
