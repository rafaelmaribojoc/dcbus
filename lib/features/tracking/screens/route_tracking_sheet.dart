import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/stop_navigation_provider.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../data/models/route.dart';
import '../../../data/repositories/tracker_repository.dart';

/// Bottom sheet for starting tracking on a route
/// Redesigned with Antigravity Design System
class RouteTrackingSheet extends ConsumerStatefulWidget {
  final BusRoute route;
  
  const RouteTrackingSheet({super.key, required this.route});

  @override
  ConsumerState<RouteTrackingSheet> createState() => _RouteTrackingSheetState();
}

class _RouteTrackingSheetState extends ConsumerState<RouteTrackingSheet> {

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(trackingStateProvider);
    final busesAsync = ref.watch(busesOnRouteProvider(widget.route.id));
    final routeColor = Color(
      int.parse(widget.route.color.replaceFirst('#', '0xFF')),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        // Glassmorphism container with BackdropFilter
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignSystem.radiusL),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark 
                    ? DesignSystem.darkSurface.withValues(alpha: 0.85)
                    : DesignSystem.lightSurface.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(DesignSystem.radiusL),
                ),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(DesignSystem.spacingM),
            physics: DesignSystem.bouncingPhysics,
            children: [
              // Premium drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Route header with large number
              Row(
                children: [
                  // Large route badge
                  Hero(
                    tag: 'route_${widget.route.id}',
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: routeColor.withValues(alpha: 0.15),
                        borderRadius: DesignSystem.borderRadiusM,
                      ),
                      child: Center(
                        child: Text(
                          widget.route.routeNumber,
                          style: DesignSystem.headingXL.copyWith(
                            color: routeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingS),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.route.name,
                          style: DesignSystem.headingM.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: widget.route.timePeriod == 'AM'
                                    ? DesignSystem.warningColor.withValues(alpha: 0.15)
                                    : const Color(0xFF5C6BC0).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.route.timePeriod,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: widget.route.timePeriod == 'AM'
                                      ? DesignSystem.warningColor
                                      : const Color(0xFF5C6BC0),
                                ),
                              ),
                            ),
                            const SizedBox(width: DesignSystem.spacingXS),
                            Text(
                              '${widget.route.formattedStartTime} - ${widget.route.formattedEndTime}',
                              style: DesignSystem.labelM.copyWith(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignSystem.spacingM),
              
              // Live buses section
              busesAsync.when(
                data: (buses) {
                  if (buses.isEmpty) {
                    return _InfoCard(
                      icon: Icons.directions_bus_outlined,
                      iconColor: Colors.grey,
                      backgroundColor: isDark
                          ? DesignSystem.darkSurfaceVariant
                          : DesignSystem.lightSurfaceVariant,
                      title: 'No buses tracked yet',
                      subtitle: 'Be the first to help other commuters!',
                    );
                  }
                  
                  return _InfoCard(
                    icon: Icons.directions_bus,
                    iconColor: DesignSystem.successColor,
                    backgroundColor: DesignSystem.successColor.withValues(alpha: 0.1),
                    title: '${buses.length} bus${buses.length > 1 ? 'es' : ''} active',
                    subtitle: 'Currently being tracked on this route',
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(DesignSystem.spacingM),
                    child: CircularProgressIndicator(
                      color: DesignSystem.actionColor,
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              
              const SizedBox(height: DesignSystem.spacingM),
              
              // Stops preview header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Stops',
                        style: DesignSystem.headingM.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: DesignSystem.spacingXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: routeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.route.stops.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: routeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.spacingS),
              
              // Stops list
              ...widget.route.stops.asMap().entries.map((entry) {
                final index = entry.key;
                final stop = entry.value;
                final isLast = index == widget.route.stops.length - 1;
                final isSelected = false; // logic removed
                
                return BouncyButton(
                  onTap: () => _navigateToStop(context, ref, stop),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: DesignSystem.spacingXS),
                    child: Row(
                      children: [
                        // Stop indicator with connector
                        SizedBox(
                          width: 24,
                          child: Column(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: routeColor,
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 16,
                                  color: routeColor.withValues(alpha: 0.3),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingXS),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignSystem.spacingS,
                              vertical: DesignSystem.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: isDark ? DesignSystem.darkSurfaceVariant : DesignSystem.lightSurfaceVariant,
                              borderRadius: DesignSystem.borderRadiusS,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    stop.name,
                                    style: DesignSystem.bodyM.copyWith(
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: routeColor.withValues(alpha: 0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: DesignSystem.spacingL),
              
              // Tracking button
              _buildTrackingButton(context, ref, trackingState, routeColor, isDark),
              
              // Error message
              if (trackingState.error != null) ...[
                const SizedBox(height: DesignSystem.spacingS),
                Text(
                  trackingState.error!,
                  style: TextStyle(color: DesignSystem.errorColor),
                  textAlign: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: DesignSystem.spacingM),
              
              // How it works info
              _InfoCard(
                icon: Icons.help_outline,
                iconColor: DesignSystem.actionColor,
                backgroundColor: DesignSystem.actionColor.withValues(alpha: 0.1),
                title: 'How does this help?',
                subtitle: 'Your location helps other commuters see where the bus is. Shared anonymously.',
              ),
            ],
          ),
            ),
          ),
        );
      },
    );
  }

  /// Navigate to a stop on the map
  void _navigateToStop(BuildContext context, WidgetRef ref, RoutePoint stop) {
    // Set the navigation target
    ref.read(stopNavigationProvider.notifier).navigateToStop(stop, widget.route);
    // Close the sheet and switch to map tab
    Navigator.of(context).pop();
  }

  Widget _buildTrackingButton(
    BuildContext context,
    WidgetRef ref,
    dynamic trackingState,
    Color routeColor,
    bool isDark,
  ) {
    // Currently tracking this route
    if (trackingState.isTracking && trackingState.activeRouteId == widget.route.id) {
      return Column(
        children: [
          // Role Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: trackingState.isBroadcaster 
                  ? DesignSystem.actionColor.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: trackingState.isBroadcaster 
                    ? DesignSystem.actionColor 
                    : Colors.grey,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trackingState.isBroadcaster ? Icons.wifi_tethering : Icons.people_outline,
                  size: 16,
                  color: trackingState.isBroadcaster ? DesignSystem.actionColor : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  trackingState.isBroadcaster ? 'Broadcasting Location' : 'Passenger Mode',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: trackingState.isBroadcaster ? DesignSystem.actionColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          
          // Show destination if known
          if (trackingState.destinationStopName != null)
             _InfoCard(
              icon: Icons.flag,
              iconColor: DesignSystem.actionColor,
              backgroundColor: DesignSystem.actionColor.withValues(alpha: 0.1),
              title: 'Destination: ${trackingState.destinationStopName}',
              subtitle: 'Tracking will end automatically when you arrive.',
            ),
          const SizedBox(height: DesignSystem.spacingS),
          BouncyButton(
            onTap: () {
              ref.read(trackingStateProvider.notifier).stopTracking();
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingS),
              decoration: BoxDecoration(
                color: DesignSystem.errorColor.withValues(alpha: 0.1),
                borderRadius: DesignSystem.borderRadiusS,
                border: Border.all(color: DesignSystem.errorColor),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stop_circle_outlined, color: DesignSystem.errorColor),
                  SizedBox(width: DesignSystem.spacingXS),
                  Text(
                    'Stop Tracking',
                    style: TextStyle(
                      color: DesignSystem.errorColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    // Tracking a different route
    if (trackingState.isTracking) {
      return Column(
        children: [
          _InfoCard(
            icon: Icons.warning_amber,
            iconColor: DesignSystem.warningColor,
            backgroundColor: DesignSystem.warningColor.withValues(alpha: 0.1),
            title: 'Already tracking ${trackingState.routeName}',
            subtitle: 'Stop that session before starting a new one.',
          ),
        ],
      );
    }
    
    // Not tracking - Instructions
    return _InfoCard(
      icon: Icons.touch_app,
      iconColor: Colors.grey,
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      title: 'Tap a stop on the map to start tracking',
      subtitle: 'Select your destination station on the map to begin your trip.',
    );
  }
}

/// Reusable info card
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingS),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: DesignSystem.borderRadiusS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: DesignSystem.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DesignSystem.labelL.copyWith(
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: DesignSystem.bodyM.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

