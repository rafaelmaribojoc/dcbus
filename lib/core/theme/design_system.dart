import 'package:flutter/material.dart';

/// Antigravity Design System
/// Centralized design tokens following the 4 Pillars of Design
class DesignSystem {
  DesignSystem._();

  // ============================================
  // PILLAR II: ORGANIC MODERNISM - Spacing
  // "Triple the default padding" principle
  // ============================================
  static const double spacingXS = 8.0;
  static const double spacingS = 16.0;
  static const double spacingM = 24.0;
  static const double spacingL = 32.0;
  static const double spacingXL = 48.0;

  // ============================================
  // PILLAR II: ORGANIC MODERNISM - Radii
  // "Squircle Rule: min 16px, preferred 24px"
  // ============================================
  static const double radiusS = 16.0;
  static const double radiusM = 24.0;
  static const double radiusL = 32.0;

  static BorderRadius get borderRadiusS => BorderRadius.circular(radiusS);
  static BorderRadius get borderRadiusM => BorderRadius.circular(radiusM);
  static BorderRadius get borderRadiusL => BorderRadius.circular(radiusL);

  // ============================================
  // PILLAR III: INTENTIONALITY - Brand Colors
  // "Deep Teal/Ocean reserved for primary action"
  // ============================================
  static const Color actionColor = Color(0xFF26A69A); // Deep Teal
  static const Color actionColorLight = Color(0xFF80CBC4);
  static const Color actionColorDark = Color(0xFF00796B);

  // Semantic Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color errorColor = Color(0xFFEF5350);

  // Surface Colors (Light Mode)
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F3F5);

  // Surface Colors (Dark Mode)
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF21262D);

  // ============================================
  // PILLAR I: VISCERALITY - Animation Durations
  // "Motion is Mandatory"
  // ============================================
  static const Duration animInstant = Duration(milliseconds: 100);
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve animCurveDefault = Curves.easeOutCubic;
  static const Curve animCurveBounce = Curves.elasticOut;
  static const Curve animCurveSharp = Curves.easeInOutCubic;

  // ============================================
  // PILLAR I: VISCERALITY - Scroll Physics
  // "BouncingScrollPhysics even on Android"
  // ============================================
  static const ScrollPhysics bouncingPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  // ============================================
  // PILLAR II: ORGANIC MODERNISM - Shadows
  // "Subtle shadows with high blur, low opacity"
  // ============================================
  static List<BoxShadow> get shadowLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 48,
          offset: const Offset(0, 16),
        ),
      ];

  static List<BoxShadow> get shadowDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];

  // ============================================
  // PILLAR II: Glass & Depth - Blur values
  // ============================================
  static const double blurLight = 8.0;
  static const double blurMedium = 16.0;
  static const double blurStrong = 24.0;

  // ============================================
  // Typography Scale
  // ============================================
  static const TextStyle headingXL = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headingL = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headingM = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headingS = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle bodyL = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyM = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyS = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle labelL = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle labelM = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // ============================================
  // NEO-BRUTALIST TYPOGRAPHY
  // Large, high-contrast, bold fonts for readability
  // ============================================
  static const TextStyle headingHero = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    height: 1.0,
  );

  static const TextStyle headingBold = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle countdownText = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    letterSpacing: -2.0,
    height: 1.0,
  );

  // ============================================
  // DEEP FLAT SHADOWS (Colored Glows)
  // Prominent soft shadows with color tinting
  // ============================================
  static List<BoxShadow> coloredShadow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get shadowDeepFlat => [
    BoxShadow(
      color: actionColor.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: actionColor.withValues(alpha: 0.15),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];

  // ============================================
  // GRADIENT UTILITIES (Deep Flat Buttons)
  // ============================================
  static LinearGradient get actionGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [actionColorLight, actionColorDark],
  );

  static LinearGradient tileGradient(bool isDark) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark 
      ? [darkSurface, darkSurfaceVariant]
      : [lightSurface, const Color(0xFFF0F4F8)],
  );

  /// Hero card gradient - teal to dark for glassmorphism
  static LinearGradient heroCardGradient(bool isDark) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark 
      ? [const Color(0xFF2E6B6B), const Color(0xFF1A3A3A)] // Brighter start for better visibility
      : [const Color(0xFF26A69A), const Color(0xFF00796B)],
  );

  /// Shadow for Stat Cards (Subtle lift in dark mode)
  static List<BoxShadow> shadowStatCard(bool isDark) => isDark
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.05), // Subtle glow
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ]
      : shadowLight;

  /// Glow shadow for action buttons
  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.5),
      blurRadius: 12,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.3),
      blurRadius: 24,
      spreadRadius: 2,
    ),
  ];

  /// Glass overlay color
  static Color glassOverlay(bool isDark) => isDark
      ? Colors.white.withValues(alpha: 0.05) // Reduced haze for cleaner text
      : Colors.white.withValues(alpha: 0.25);

  /// Stat card background
  static Color statCardBackground(bool isDark) => isDark
      ? const Color(0xFF21262D) // Brighter surface
      : const Color(0xFFF5F7FA);

  // ============================================
  // Page Transitions (Cupertino-style)
  // ============================================
  static PageRouteBuilder<T> slideRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: animCurveDefault,
          )),
          child: child,
        );
      },
      transitionDuration: animMedium,
    );
  }
}
