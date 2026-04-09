import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/route_constants.dart';
import '../../data/models/fish_model.dart';
import '../../providers/fish_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import 'widgets/fish_image_widget.dart';

class FishDetailScreen extends StatefulWidget {
  const FishDetailScreen({super.key, required this.fishId});

  final String fishId;

  @override
  State<FishDetailScreen> createState() => _FishDetailScreenState();
}

class _FishDetailScreenState extends State<FishDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FishProvider>().loadFishById(widget.fishId);
    });
  }

  Future<void> _confirmDelete(
    BuildContext context,
    FishProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Ikan'),
        content: const Text('Apakah kamu yakin ingin menghapus data ikan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await provider.removeFish(widget.fishId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data ikan berhasil dihapus.')),
        );
        context.go(RouteConstants.fish);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FishProvider>(
      builder: (context, provider, _) {
        if (provider.status == FishStatus.loading ||
            provider.status == FishStatus.initial) {
          return const Scaffold(
            appBar: TopAppBarWidget(
              title: 'Detail Ikan',
              showBackButton: true,
              fallbackRoute: RouteConstants.fish,
            ),
            body: LoadingWidget(),
          );
        }

        if (provider.status == FishStatus.error) {
          return Scaffold(
            appBar: const TopAppBarWidget(
              title: 'Detail Ikan',
              showBackButton: true,
              fallbackRoute: RouteConstants.fish,
            ),
            body: AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadFishById(widget.fishId),
            ),
          );
        }

        final fish = provider.selectedFish;
        if (fish == null) {
          return const Scaffold(
            appBar: TopAppBarWidget(
              title: 'Detail Ikan',
              showBackButton: true,
              fallbackRoute: RouteConstants.fish,
            ),
            body: Center(child: Text('Data ikan tidak ditemukan.')),
          );
        }

        return Scaffold(
          appBar: TopAppBarWidget(
            title: fish.nama,
            showBackButton: true,
            fallbackRoute: RouteConstants.fish,
            menuItems: [
              TopAppBarMenuItem(
                text: 'Edit',
                icon: Icons.edit_outlined,
                onTap: () async {
                  final edited = await context.push<bool>(
                    RouteConstants.fishEdit(fish.id),
                  );
                  if (edited == true && context.mounted) {
                    provider.loadFishById(widget.fishId);
                  }
                },
              ),
              TopAppBarMenuItem(
                text: 'Hapus',
                icon: Icons.delete_outline,
                isDestructive: true,
                onTap: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: _FishDetailBody(fish: fish),
        );
      },
    );
  }
}

class _FishDetailBody extends StatelessWidget {
  const _FishDetailBody({required this.fish});

  final FishModel fish;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: FishImageWidget(
                    imagePath: fish.imagePath,
                    imageBytes: fish.imageBytes,
                    width: double.infinity,
                    height: 260,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fish.nama,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Informasi lengkap ikan hias dan karakteristik utamanya.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          _InfoChip(
                            icon: Icons.photo_library_outlined,
                            label: 'Galeri Asset',
                          ),
                          _InfoChip(
                            icon: Icons.edit_note_outlined,
                            label: 'CRUD Aktif',
                          ),
                          _InfoChip(
                            icon: Icons.water_outlined,
                            label: 'Topik Ikan',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Deskripsi',
            content: fish.deskripsi,
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Habitat',
            content: fish.habitat,
            icon: Icons.water_drop_outlined,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Makanan',
            content: fish.makanan,
            icon: Icons.restaurant_outlined,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  final String title;
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(icon, color: colorScheme.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Text(
              content,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
