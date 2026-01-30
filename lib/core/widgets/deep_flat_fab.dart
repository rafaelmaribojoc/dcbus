import 'package:flutter/material.dart';

import '../theme/design_system.dart';
import 'bouncy_button.dart';

/// Deep Flat styled Floating Action Button
/// Features diagonal gradient and colored shadow glow
class DeepFlatFab extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? gradientStart;
  final Color? gradientEnd;
  final double size;

  const DeepFlatFab({
    super.key,
    required this.icon,
    this.label,
    this.onPressed,
    this.gradientStart,
    this.gradientEnd,
    this.size = 56,
  });

  /// Mini FAB variant
  const DeepFlatFab.mini({
    super.key,
    required this.icon,
    this.label,
    this.onPressed,
    this.gradientStart,
    this.gradientEnd,
  }) : size = 48;

  /// Extended FAB variant with label
  const DeepFlatFab.extended({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.gradientStart,
    this.gradientEnd,
  }) : size = 56;

  @override
  Widget build(BuildContext context) {
    final startColor = gradientStart ?? DesignSystem.actionColorLight;
    final endColor = gradientEnd ?? DesignSystem.actionColorDark;
    final glowColor = endColor;

    if (label != null) {
      // Extended FAB
      return BouncyButton(
        onTap: onPressed,
        scaleAmount: 0.92,
        child: Container(
          height: size,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
            borderRadius: BorderRadius.circular(size / 2),
            boxShadow: DesignSystem.coloredShadow(glowColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                label!,
                style: DesignSystem.labelL.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Regular circular FAB
    return BouncyButton(
      onTap: onPressed,
      scaleAmount: 0.92,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [startColor, endColor],
          ),
          shape: BoxShape.circle,
          boxShadow: DesignSystem.coloredShadow(glowColor),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }
}

/// Secondary action FAB with outline style
class DeepFlatFabOutlined extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const DeepFlatFabOutlined({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? DesignSystem.actionColor;

    return BouncyButton(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark 
            ? DesignSystem.darkSurface 
            : DesignSystem.lightSurface,
          shape: BoxShape.circle,
          boxShadow: DesignSystem.shadowMedium,
          border: Border.all(
            color: effectiveColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: effectiveColor,
          size: size * 0.45,
        ),
      ),
    );
  }
}
