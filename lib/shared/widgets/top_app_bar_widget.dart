// lib/shared/widgets/top_app_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/theme_notifier.dart';

/// Model untuk item menu di TopAppBar
class TopAppBarMenuItem {
  const TopAppBarMenuItem({
    required this.text,
    required this.icon,
    this.route,
    this.onTap,
    this.isDestructive = false,
  });

  final String text;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isDestructive;
}

/// Widget Top App Bar yang dapat dikonfigurasi
class TopAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const TopAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.fallbackRoute = RouteConstants.home,
    this.withSearch = false,
    this.searchQuery = '',
    this.onSearchQueryChange,
    this.menuItems = const [],
  });

  final String title;
  final bool showBackButton;
  final String fallbackRoute;
  final bool withSearch;
  final String searchQuery;
  final ValueChanged<String>? onSearchQueryChange;
  final List<TopAppBarMenuItem> menuItems;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<TopAppBarWidget> createState() => _TopAppBarWidgetState();
}

class _TopAppBarWidgetState extends State<TopAppBarWidget> {
  bool _isSearchActive = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Akses ThemeNotifier dari widget tree untuk toggle dan baca state
    final themeNotifier = ThemeProvider.of(context);
    final isDark = themeNotifier.isDark;

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.5),
      scrolledUnderElevation: 4,
      // Tombol back
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(widget.fallbackRoute);
                }
              },
            )
          : null,
      // Title atau Search Field
      title: _isSearchActive
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari tanaman...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              onChanged: widget.onSearchQueryChange,
            )
          : Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
      // Aksi di kanan
      actions: [
        // Tombol toggle dark/light mode
        // Menampilkan ikon matahari (light) atau bulan (dark) sesuai mode aktif
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: IconButton(
            // key unik agar AnimatedSwitcher mendeteksi pergantian widget
            key: ValueKey(isDark),
            icon: Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            tooltip: isDark ? 'Ganti ke Light Mode' : 'Ganti ke Dark Mode',
            onPressed: themeNotifier.toggle,
          ),
        ),

        // Tombol search
        if (widget.withSearch)
          _isSearchActive
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _isSearchActive = false);
                    _searchController.clear();
                    widget.onSearchQueryChange?.call('');
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() => _isSearchActive = true),
                ),

        // Menu dropdown
        if (widget.menuItems.isNotEmpty)
          PopupMenuButton<TopAppBarMenuItem>(
            icon: const Icon(Icons.more_vert),
            color: colorScheme.primaryContainer,
            itemBuilder: (context) => widget.menuItems
                .map(
                  (item) => PopupMenuItem<TopAppBarMenuItem>(
                    value: item,
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: item.isDestructive
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.text,
                          style: TextStyle(
                            color: item.isDestructive
                                ? colorScheme.error
                                : colorScheme.onSurface,
                            fontWeight: item.isDestructive
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onSelected: (item) {
              if (item.route != null) {
                context.go(item.route!);
              }
              item.onTap?.call();
            },
          ),
      ],
    );
  }
}
