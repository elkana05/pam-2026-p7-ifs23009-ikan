// lib/shared/widgets/loading_widget.dart

import 'package:flutter/material.dart';

/// Widget loading dengan animasi ripple
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple 1
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: (1 - _controller.value).clamp(0, 1),
                  child: Container(
                    width: 36 + (_controller.value * 114),
                    height: 36 + (_controller.value * 114),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                    ),
                  ),
                );
              },
            ),
            // Ripple 2 (delayed)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final delayed = ((_controller.value + 0.4) % 1.0);
                return Opacity(
                  opacity: (1 - delayed).clamp(0, 1),
                  child: Container(
                    width: 36 + (delayed * 114),
                    height: 36 + (delayed * 114),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                    ),
                  ),
                );
              },
            ),
            // Logo tengah
            Image.asset(
              'assets/images/img_kol.png',
              width: 76,
              height: 76,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}