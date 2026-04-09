// test/widget/loading_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam_p7_2026_ifs23009/shared/widgets/loading_widget.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('merender tanpa error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget()),
        ),
      );

      // Verifikasi widget ada di tree
      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('menampilkan Stack sebagai container animasi', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget()),
        ),
      );

      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('menampilkan gambar logo di tengah', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget()),
        ),
      );

      // Gambar logo ada
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('widget berada di posisi tengah layar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget()),
        ),
      );

      expect(find.byType(Center), findsWidgets);
    });
  });
}