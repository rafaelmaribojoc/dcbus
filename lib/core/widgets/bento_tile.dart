import 'package:flutter/material.dart';
import '../theme/design_system.dart';

/// Hero Card for the Dashboard (Next Bus)
/// Glassmorphism effect with gradient background
class HeroTile extends StatelessWidget {
  final String routeNumber;
  final String destination;
  final String countdown;
  final VoidCallback? onTap;

  const HeroTile({
    super.key,
    required this.routeNumber,
    required this.destination,
    required this.countdown,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: DesignSystem.borderRadiusL,
          gradient: DesignSystem.heroCardGradient(isDark),
          boxShadow: DesignSystem.coloredShadow(DesignSystem.actionColor),
        ),
        child: Stack(
          children: [
            // Glass Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: DesignSystem.borderRadiusL,
                  color: DesignSystem.glassOverlay(isDark),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NEXT BUS',
                        style: DesignSystem.labelM.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          letterSpacing: 2.0,
                        ),
                      ),
                      Icon(
                        Icons.directions_bus_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Huge Countdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        countdown,
                        style: DesignSystem.headingHero.copyWith(
                          color: Colors.white,
                          fontSize: 64,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'min',
                        style: DesignSystem.headingM.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Route Info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, 
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          routeNumber,
                          style: DesignSystem.labelM.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'To $destination',
                          style: DesignSystem.bodyM.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: DesignSystem.spacingM),
                  
                  // Progress Bar (Decorative)
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.7, // Mock progress
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat Card (Active Buses, Routes)
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: DesignSystem.statCardBackground(isDark),
          borderRadius: DesignSystem.borderRadiusM,
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.grey.shade200, // Brighter border
          ),
          boxShadow: DesignSystem.shadowStatCard(isDark), // New shadow utility
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: DesignSystem.headingL.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  label,
                  style: DesignSystem.bodyS.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ActionButton class removed as Quick Actions section was deleted

// Deprecated classes removed
