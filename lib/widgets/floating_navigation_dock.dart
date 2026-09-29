import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A floating navigation surface over a transparent, softly blurred backdrop.
class FloatingNavigationDock extends StatelessWidget {
  const FloatingNavigationDock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Increase this value to lower the navbar; decrease it to raise the navbar.
    const lowerBy = 12.0;
    final bottomGap = (MediaQuery.paddingOf(context).bottom - lowerBy).clamp(
      8.0,
      double.infinity,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -48,
          child: IgnorePointer(
            child: Column(
              // Small, non-overlapping strips gradually increase the actual
              // backdrop blur. Each filter is clipped to its own strip.
              children: List.generate(12, (index) {
                final progress = (index + 1) / 12;
                final sigma = 10 * progress * progress;
                return Expanded(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).scaffoldBackgroundColor
                                  .withValues(alpha: 0.12 * index / 12),
                              Theme.of(context).scaffoldBackgroundColor
                                  .withValues(alpha: 0.12 * progress),
                            ],
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomGap),
            child: child,
          ),
        ),
      ],
    );
  }
}
