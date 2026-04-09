import 'package:flutter/material.dart';

import '../../shared/widgets/top_app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBarWidget(title: 'Home'),
      body: _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  static const List<_FishPreview> _fishPreviews = [
    _FishPreview(
      name: 'Arapaima',
      imagePath: 'assets/images/arapaima.jpg',
      description: 'Ikan air tawar raksasa yang terkenal kuat dan eksotis.',
    ),
    _FishPreview(
      name: 'Arwana',
      imagePath: 'assets/images/arwana.jpg',
      description: 'Ikan hias premium dengan gerakan anggun dan sisik indah.',
    ),
    _FishPreview(
      name: 'Discus Fish',
      imagePath: 'assets/images/discusfish.jpg',
      description: 'Memiliki bentuk bundar unik dengan warna yang mencolok.',
    ),
    _FishPreview(
      name: 'Flowerhorn',
      imagePath: 'assets/images/flowerhorncichlid.jpg',
      description: 'Populer sebagai ikan akuarium dengan karakter yang kuat.',
    ),
  ];

  static const List<_HomeHighlight> _highlights = [
    _HomeHighlight(
      title: 'Ikan Hias',
      description: 'Jelajahi koleksi ikan dengan warna dan bentuk yang unik.',
      icon: Icons.auto_awesome,
    ),
    _HomeHighlight(
      title: 'Habitat',
      description: 'Pelajari lingkungan hidup terbaik untuk setiap jenis ikan.',
      icon: Icons.water_drop_outlined,
    ),
    _HomeHighlight(
      title: 'Perawatan',
      description: 'Kelola data makanan, deskripsi, dan karakteristik ikan.',
      icon: Icons.favorite_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.phishing, size: 44, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                'Delcom Fish',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aplikasi katalog ikan untuk melihat, menambah, mengubah, dan menghapus data sesuai topik yang dipilih.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Galeri ikan',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Beberapa koleksi ikan dari asset aplikasi ditampilkan di bawah ini agar beranda langsung terasa hidup dan sesuai tema.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 188,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _fishPreviews.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final fish = _fishPreviews[index];
              return _FishPreviewCard(fish: fish);
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Fokus utama',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._highlights.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(item.icon, color: colorScheme.primary),
              ),
              title: Text(item.title),
              subtitle: Text(item.description),
            ),
          ),
        ),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Gunakan menu Fish pada bottom navigation untuk mengakses dan mengelola seluruh data ikan.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeHighlight {
  const _HomeHighlight({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _FishPreview {
  const _FishPreview({
    required this.name,
    required this.imagePath,
    required this.description,
  });

  final String name;
  final String imagePath;
  final String description;
}

class _FishPreviewCard extends StatelessWidget {
  const _FishPreviewCard({required this.fish});

  final _FishPreview fish;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    fish.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: colorScheme.primary,
                        size: 36,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: Text(
                        fish.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                fish.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
