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

class FishScreen extends StatefulWidget {
  const FishScreen({super.key});

  @override
  State<FishScreen> createState() => _FishScreenState();
}

class _FishScreenState extends State<FishScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FishProvider>().loadFish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FishProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: TopAppBarWidget(
            title: 'Fish',
            withSearch: true,
            searchQuery: provider.searchQuery,
            onSearchQueryChange: provider.updateSearchQuery,
          ),
          body: _buildBody(provider),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final added = await context.push<bool>(RouteConstants.fishAdd);
              if (added == true && context.mounted) {
                provider.loadFish();
              }
            },
            tooltip: 'Tambah Ikan',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(FishProvider provider) {
    return switch (provider.status) {
      FishStatus.loading || FishStatus.initial => const LoadingWidget(),
      FishStatus.error => AppErrorWidget(
        message: provider.errorMessage,
        onRetry: provider.loadFish,
      ),
      FishStatus.success => _FishBody(
        fish: provider.fish,
        onOpen: (id) => context.go(RouteConstants.fishDetail(id)),
      ),
    };
  }
}

class _FishBody extends StatelessWidget {
  const _FishBody({required this.fish, required this.onOpen});

  final List<FishModel> fish;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (fish.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Tidak ada data ikan!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FishProvider>().loadFish(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          _FishHeroHeader(totalFish: fish.length),
          const SizedBox(height: 20),
          Text(
            'Koleksi ikan',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Pilih salah satu ikan untuk melihat detail, mengubah data, atau menghapusnya.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...fish.map((item) => _FishItemCard(fish: item, onOpen: onOpen)),
        ],
      ),
    );
  }
}

class _FishItemCard extends StatelessWidget {
  const _FishItemCard({required this.fish, required this.onOpen});

  final FishModel fish;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onOpen(fish.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  FishImageWidget(
                    imagePath: fish.imagePath,
                    imageBytes: fish.imageBytes,
                    width: double.infinity,
                    height: 180,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.set_meal,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              fish.nama,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FishMetaChip(
                    icon: Icons.water_drop_outlined,
                    label: fish.habitat,
                  ),
                  const _FishMetaChip(
                    icon: Icons.edit_note_outlined,
                    label: 'Bisa diubah',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                fish.deskripsi,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.45),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FishHeroHeader extends StatelessWidget {
  const _FishHeroHeader({required this.totalFish});

  final int totalFish;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.phishing,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              const Spacer(),
              _FishStatBadge(totalFish: totalFish),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Topik ikan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola data ikan dengan tampilan yang lebih visual. Tambah gambar, edit informasi, dan buka detail setiap koleksi langsung dari halaman ini.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _FishStatBadge extends StatelessWidget {
  const _FishStatBadge({required this.totalFish});

  final int totalFish;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Text(
        '$totalFish koleksi',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _FishMetaChip extends StatelessWidget {
  const _FishMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
