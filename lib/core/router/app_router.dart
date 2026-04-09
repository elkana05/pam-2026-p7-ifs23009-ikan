// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/fish/fish_detail_screen.dart';
import '../../features/fish/fish_form_screen.dart';
import '../../features/fish/fish_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/plants/plants_add_screen.dart';
import '../../features/plants/plants_detail_screen.dart';
import '../../features/plants/plants_edit_screen.dart';
import '../../features/plants/plants_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../constants/route_constants.dart';
import '../../shared/widgets/bottom_nav_widget.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.home,
  routes: [
    // ShellRoute menampilkan BottomNav untuk halaman utama
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: RouteConstants.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: RouteConstants.plants,
          builder: (context, state) => const PlantsScreen(),
        ),
        GoRoute(
          path: RouteConstants.fish,
          builder: (context, state) => const FishScreen(),
        ),
        GoRoute(
          path: RouteConstants.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Route di luar ShellRoute agar tidak menampilkan BottomNav
    GoRoute(
      path: '/plants/add',
      builder: (context, state) => const PlantsAddScreen(),
    ),
    GoRoute(
      path: '/plants/:id',
      builder: (context, state) {
        // ID bertipe String (UUID)
        final id = state.pathParameters['id'] ?? '';
        return PlantsDetailScreen(plantId: id);
      },
    ),
    GoRoute(
      path: '/plants/:id/edit',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PlantsEditScreen(plantId: id);
      },
    ),
    GoRoute(
      path: RouteConstants.fishAdd,
      builder: (context, state) => const FishFormScreen.add(),
    ),
    GoRoute(
      path: '/fish/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return FishDetailScreen(fishId: id);
      },
    ),
    GoRoute(
      path: '/fish/:id/edit',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return FishFormScreen.edit(fishId: id);
      },
    ),
  ],
);

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavWidget(child: child),
    );
  }
}
