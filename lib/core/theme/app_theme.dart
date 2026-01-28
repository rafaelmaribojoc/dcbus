import 'package:flutter/material.dart';

import 'design_system.dart';

/// DCBus App Theme - Antigravity Design System
/// Premium, visceral design with organic modernism
class AppTheme {
  AppTheme._();

  // ============================================
  // Light Theme
  // ============================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignSystem.actionColor,
        brightness: Brightness.light,
        primary: DesignSystem.actionColor,
        secondary: DesignSystem.actionColorLight,
        surface: DesignSystem.lightSurface,
        error: DesignSystem.errorColor,
      ),
      scaffoldBackgroundColor: DesignSystem.lightBackground,

      // Premium AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: -0.3,
        ),
      ),

      // Organic Cards - Squircle Rule (24px radius)
      cardTheme: CardThemeData(
        elevation: 0,
        color: DesignSystem.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: DesignSystem.borderRadiusM,
        ),
        margin: EdgeInsets.zero,
      ),

      // Premium FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DesignSystem.actionColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignSystem.borderRadiusM,
        ),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingM,
          vertical: DesignSystem.spacingS,
        ),
      ),

      // Premium Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DesignSystem.lightSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignSystem.radiusL),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: Colors.grey.shade300,
        dragHandleSize: const Size(40, 4),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: DesignSystem.lightSurface,
        indicatorColor: DesignSystem.actionColor.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DesignSystem.labelM.copyWith(
              color: DesignSystem.actionColor,
              fontWeight: FontWeight.w600,
            );
          }
          return DesignSystem.labelM.copyWith(color: Colors.grey.shade600);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: DesignSystem.actionColor, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade600, size: 24);
        }),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignSystem.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: DesignSystem.borderRadiusS,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignSystem.borderRadiusS,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignSystem.borderRadiusS,
          borderSide: BorderSide(color: DesignSystem.actionColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingS,
          vertical: DesignSystem.spacingS,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusS),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingS,
          vertical: DesignSystem.spacingXS,
        ),
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DesignSystem.actionColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingM,
            vertical: DesignSystem.spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: DesignSystem.borderRadiusS,
          ),
          textStyle: DesignSystem.labelL,
        ),
      ),

      // Bouncing Scroll everywhere
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(DesignSystem.radiusS),
        thumbColor: WidgetStateProperty.all(Colors.grey.shade300),
      ),
    );
  }

  // ============================================
  // Dark Theme
  // ============================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignSystem.actionColor,
        brightness: Brightness.dark,
        primary: DesignSystem.actionColor,
        secondary: DesignSystem.actionColorLight,
        surface: DesignSystem.darkSurface,
        error: DesignSystem.errorColor,
      ),
      scaffoldBackgroundColor: DesignSystem.darkBackground,

      // Premium AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),

      // Organic Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: DesignSystem.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: DesignSystem.borderRadiusM,
        ),
        margin: EdgeInsets.zero,
      ),

      // Premium FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DesignSystem.actionColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignSystem.borderRadiusM,
        ),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingM,
          vertical: DesignSystem.spacingS,
        ),
      ),

      // Premium Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DesignSystem.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignSystem.radiusL),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: Colors.grey.shade700,
        dragHandleSize: const Size(40, 4),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: DesignSystem.darkSurface,
        indicatorColor: DesignSystem.actionColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return DesignSystem.labelM.copyWith(
              color: DesignSystem.actionColor,
              fontWeight: FontWeight.w600,
            );
          }
          return DesignSystem.labelM.copyWith(color: Colors.grey.shade400);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: DesignSystem.actionColor, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade400, size: 24);
        }),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignSystem.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: DesignSystem.borderRadiusS,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignSystem.borderRadiusS,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignSystem.borderRadiusS,
          borderSide: BorderSide(color: DesignSystem.actionColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingS,
          vertical: DesignSystem.spacingS,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusS),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingS,
          vertical: DesignSystem.spacingXS,
        ),
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DesignSystem.actionColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingM,
            vertical: DesignSystem.spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: DesignSystem.borderRadiusS,
          ),
          textStyle: DesignSystem.labelL,
        ),
      ),

      // Scrollbar
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(DesignSystem.radiusS),
        thumbColor: WidgetStateProperty.all(Colors.grey.shade700),
      ),
    );
  }
}

/// Custom scroll behavior for bouncing physics everywhere
class AntigravityScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return DesignSystem.bouncingPhysics;
  }
}

