import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_system.dart';
import '../../../core/widgets/bento_tile.dart';
import '../../../data/repositories/route_repository.dart';
import '../../../data/repositories/tracker_repository.dart';

/// Dashboard screen with Premium Redesign
/// Shows Hero Glassmorphism card, Stats, and Quick Actions
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routesAsync = ref.watch(allRoutesProvider);
    final busesAsync = ref.watch(allBusesProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: DesignSystem.bouncingPhysics,
          child: Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Dashboard',
                  style: DesignSystem.headingXL.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your commute at a glance',
                  style: DesignSystem.bodyL.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingL),

                // Hero Card (Next Bus)
                busesAsync.when(
                  data: (buses) {
                    if (buses.isEmpty) {
                      return HeroTile(
                        routeNumber: '--',
                        destination: 'No Active Buses',
                        countdown: '--',
                        onTap: () {},
                      );
                    }
                    final firstBus = buses.first;
                    return HeroTile(
                      routeNumber: firstBus.routeId.split('-').first,
                      destination: 'Downtown Station', // Mock destination
                      countdown: '3', // Mock countdown
                      onTap: () {},
                    );
                  },
                  loading: () => const _LoadingHeroTile(),
                  error: (_, __) => HeroTile(
                    routeNumber: '--',
                    destination: 'Error Loading',
                    countdown: '--',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: DesignSystem.spacingM),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: busesAsync.when(
                        data: (buses) => StatCard(
                          label: 'Active Buses',
                          value: '${buses.length}',
                          icon: Icons.directions_bus_rounded,
                          color: DesignSystem.successColor,
                          onTap: () {},
                        ),
                        loading: () => const _LoadingStatCard(),
                        error: (_, __) => const _ErrorStatCard(),
                      ),
                    ),
                    const SizedBox(width: DesignSystem.spacingM),
                    Expanded(
                      child: routesAsync.when(
                        data: (routes) {
                          final uniqueRoutes =
                              routes.map((r) => r.routeNumber).toSet();
                          return StatCard(
                            label: 'Routes',
                            value: '${uniqueRoutes.length}',
                            icon: Icons.map_rounded,
                            color: DesignSystem.warningColor,
                            onTap: () {},
                          );
                        },
                        loading: () => const _LoadingStatCard(),
                        error: (_, __) => const _ErrorStatCard(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DesignSystem.spacingXL),

                // Bottom padding for scrolling
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingHeroTile extends StatelessWidget {
  const _LoadingHeroTile();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: isDark ? DesignSystem.darkSurfaceVariant : Colors.grey.shade200,
        borderRadius: DesignSystem.borderRadiusL,
      ),
      child: const Center(
        child: CircularProgressIndicator(color: DesignSystem.actionColor),
      ),
    );
  }
}

class _LoadingStatCard extends StatelessWidget {
  const _LoadingStatCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 140, // Approx height of StatCard
      decoration: BoxDecoration(
        color: isDark ? DesignSystem.darkSurfaceVariant : Colors.grey.shade200,
        borderRadius: DesignSystem.borderRadiusM,
      ),
    );
  }
}

class _ErrorStatCard extends StatelessWidget {
  const _ErrorStatCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: isDark ? DesignSystem.darkSurfaceVariant : Colors.grey.shade200,
        borderRadius: DesignSystem.borderRadiusM,
      ),
      child: const Center(child: Icon(Icons.error_outline, color: Colors.grey)),
    );
  }
}
