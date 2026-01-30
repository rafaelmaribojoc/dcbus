import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// Glassmorphism Bottom Sheet with BackdropFilter blur
/// Uses frosted glass effect instead of solid background
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.blurSigma = 10.0,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final effectiveRadius = borderRadius ?? const BorderRadius.vertical(
      top: Radius.circular(DesignSystem.radiusL),
    );
    
    final effectiveBackground = backgroundColor ??
        (isDark
            ? DesignSystem.darkSurface.withValues(alpha: 0.85)
            : DesignSystem.lightSurface.withValues(alpha: 0.9));

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBackground,
            borderRadius: effectiveRadius,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Helper to show a glass-styled bottom sheet
Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double initialChildSize = 0.5,
  double minChildSize = 0.25,
  double maxChildSize = 0.9,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return GlassBottomSheet(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(DesignSystem.spacingM),
            physics: DesignSystem.bouncingPhysics,
            child: Column(
              children: [
                // Drag handle
                _DragHandle(),
                const SizedBox(height: DesignSystem.spacingS),
                builder(context),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Glassmorphism overlay card for map elements
class GlassOverlayCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;

  const GlassOverlayCard({
    super.key,
    required this.child,
    this.padding,
    this.blurSigma = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: DesignSystem.borderRadiusM,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(DesignSystem.spacingM),
          decoration: BoxDecoration(
            color: isDark
                ? DesignSystem.darkSurface.withValues(alpha: 0.8)
                : DesignSystem.lightSurface.withValues(alpha: 0.85),
            borderRadius: DesignSystem.borderRadiusM,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: DesignSystem.shadowLight,
          ),
          child: child,
        ),
      ),
    );
  }
}
