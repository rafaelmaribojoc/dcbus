import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// Premium glass card with BackdropFilter blur
/// Following Pillar II: Organic Modernism - "Glass & Depth"
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? blur;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.blur,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBlur = blur ?? DesignSystem.blurMedium;
    final effectiveRadius = borderRadius ?? DesignSystem.borderRadiusM;
    
    final effectiveBackgroundColor = backgroundColor ??
        (isDark
            ? DesignSystem.darkSurface.withValues(alpha: 0.7)
            : DesignSystem.lightSurface.withValues(alpha: 0.8));

    final effectiveShadow = boxShadow ??
        (isDark ? DesignSystem.shadowDark : DesignSystem.shadowLight);

    Widget content = ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: effectiveBlur,
          sigmaY: effectiveBlur,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(DesignSystem.spacingM),
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: effectiveRadius,
            boxShadow: effectiveShadow,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

/// Minimal glass container without blur (for overlays on maps)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveRadius = borderRadius ?? DesignSystem.borderRadiusM;

    return Container(
      padding: padding ?? const EdgeInsets.all(DesignSystem.spacingS),
      decoration: BoxDecoration(
        color: isDark
            ? DesignSystem.darkSurface.withValues(alpha: 0.9)
            : DesignSystem.lightSurface.withValues(alpha: 0.95),
        borderRadius: effectiveRadius,
        boxShadow: isDark ? DesignSystem.shadowDark : DesignSystem.shadowLight,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
