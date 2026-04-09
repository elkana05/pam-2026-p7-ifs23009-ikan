// lib/features/profile/profile_screen.dart

import 'package:flutter/material.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBarWidget(title: 'Profile'),  // AppBar bersifat PreferredSizeWidget
      body: _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Column(
              children: [
                // Foto profil
                CircleAvatar(
                  radius: 55,
                  backgroundColor: colorScheme.primary,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.png',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 60,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Nama
                Text(
                  'Elkana Sitorus',  // Ubah dengan nama kamu
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Username
                Text(
                  'ifs23009',  // Ubah dengan username kamu
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Kartu Bio
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Tentang Saya',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Saya adalah seorang developer yang tertarik pada mobile development, '
                        'backend API, dan berbagai teknologi pengembangan aplikasi. '
                        'Senang belajar hal baru dan membangun aplikasi yang berguna.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}