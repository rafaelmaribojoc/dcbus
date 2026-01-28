import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_system.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../data/models/route.dart';
import '../../../data/repositories/route_repository.dart';
import '../../tracking/screens/route_tracking_sheet.dart';

/// Grouped route containing AM and/or PM variants
/// AM = Outbound (origin → destination), PM = Inbound (destination → origin)
class GroupedRoute {
  final String routeNumber;
  final String name;
  final String area;
  final Color color;
  final BusRoute? amRoute;
  final BusRoute? pmRoute;

  GroupedRoute({
    required this.routeNumber,
    required this.name,
    required this.area,
    required this.color,
    this.amRoute,
    this.pmRoute,
  });

  /// Extract origin and destination from route name (e.g., "Toril to GE Torres")
  /// More reliable than using stop names since routes can be circular
  (String origin, String destination) _parseRouteName() {
    final parts = name.split(' to ');
    if (parts.length == 2) {
      return (parts[0].trim(), parts[1].trim());
    }
    // Fallback to first/last stops
    final stops = (amRoute ?? pmRoute)!.stops;
    return (stops.first.name, stops.last.name);
  }

  /// AM direction: origin → destination (outbound to city)
  String get amOrigin => _parseRouteName().$1;
  String get amDestination => _parseRouteName().$2;

  /// PM direction: destination → origin (return home)
  String get pmOrigin => _parseRouteName().$2;
  String get pmDestination => _parseRouteName().$1;

  /// Check if currently operating
  bool get isOperating {
    final now = DateTime.now();
    return (amRoute?.isOperatingAt(now) ?? false) ||
        (pmRoute?.isOperatingAt(now) ?? false);
  }

  /// Which period is currently active
  String? get activePeriod {
    final now = DateTime.now();
    if (amRoute?.isOperatingAt(now) ?? false) return 'AM';
    if (pmRoute?.isOperatingAt(now) ?? false) return 'PM';
    return null;
  }

  /// Total stops count
  int get stopsCount => (amRoute ?? pmRoute)!.stops.length;

  /// Primary route for tracking
  BusRoute get primaryRoute {
    final now = DateTime.now();
    if (amRoute != null && amRoute!.isOperatingAt(now)) return amRoute!;
    if (pmRoute != null && pmRoute!.isOperatingAt(now)) return pmRoute!;
    return amRoute ?? pmRoute!;
  }
}

/// Routes list screen
class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> {
  String? _selectedArea;

  @override
  Widget build(BuildContext context) {
    final routesAsync = ref.watch(allRoutesProvider);
    final areasAsync = ref.watch(areasProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DesignSystem.spacingM,
                DesignSystem.spacingM,
                DesignSystem.spacingM,
                DesignSystem.spacingS,
              ),
              child: Text(
                'Bus Routes',
                style: DesignSystem.headingXL.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),

            // Area filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
              child: areasAsync.when(
                data: (areas) => _AreaDropdown(
                  areas: areas,
                  selectedArea: _selectedArea,
                  onChanged: (value) => setState(() => _selectedArea = value),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            const SizedBox(height: DesignSystem.spacingS),

            // Routes list
            Expanded(
              child: routesAsync.when(
                data: (routes) {
                  final grouped = _groupRoutes(routes);
                  final filtered = _filterGroupedRoutes(grouped);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.route_outlined,
                            size: 64,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: DesignSystem.spacingS),
                          Text(
                            'No routes found',
                            style: DesignSystem.bodyL.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingM,
                      vertical: DesignSystem.spacingS,
                    ),
                    physics: DesignSystem.bouncingPhysics,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        curve: DesignSystem.animCurveDefault,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: DesignSystem.spacingS),
                          child: GroupedRouteCard(groupedRoute: filtered[index]),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: DesignSystem.actionColor),
                ),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GroupedRoute> _groupRoutes(List<BusRoute> routes) {
    final Map<String, List<BusRoute>> byRouteNumber = {};
    for (final route in routes) {
      byRouteNumber.putIfAbsent(route.routeNumber, () => []).add(route);
    }

    return byRouteNumber.entries.map((entry) {
      final routeList = entry.value;
      final amRoute = routeList.where((r) => r.timePeriod == 'AM').firstOrNull;
      final pmRoute = routeList.where((r) => r.timePeriod == 'PM').firstOrNull;
      final primary = amRoute ?? pmRoute!;

      return GroupedRoute(
        routeNumber: entry.key,
        name: primary.name,
        area: primary.area,
        color: Color(int.parse(primary.color.replaceFirst('#', '0xFF'))),
        amRoute: amRoute,
        pmRoute: pmRoute,
      );
    }).toList()
      ..sort((a, b) => a.routeNumber.compareTo(b.routeNumber));
  }

  List<GroupedRoute> _filterGroupedRoutes(List<GroupedRoute> routes) {
    if (_selectedArea == null) return routes;
    return routes.where((r) => r.area == _selectedArea).toList();
  }
}

/// Area dropdown filter
class _AreaDropdown extends StatelessWidget {
  final List<String> areas;
  final String? selectedArea;
  final ValueChanged<String?> onChanged;

  const _AreaDropdown({
    required this.areas,
    required this.selectedArea,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingS,
        vertical: DesignSystem.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? DesignSystem.darkSurfaceVariant
            : DesignSystem.lightSurfaceVariant,
        borderRadius: DesignSystem.borderRadiusS,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedArea,
          hint: Text(
            'All Areas',
            style: DesignSystem.bodyM.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          dropdownColor: isDark ? DesignSystem.darkSurface : DesignSystem.lightSurface,
          borderRadius: DesignSystem.borderRadiusS,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                'All Areas',
                style: DesignSystem.bodyM.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            ...areas.map(
              (area) => DropdownMenuItem<String>(
                value: area,
                child: Text(
                  area,
                  style: DesignSystem.bodyM.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Route card showing both AM and PM directions
class GroupedRouteCard extends StatelessWidget {
  final GroupedRoute groupedRoute;

  const GroupedRouteCard({super.key, required this.groupedRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BouncyButton(
      onTap: () => _showTrackingSheet(context),
      scaleAmount: 0.98,
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: isDark ? DesignSystem.darkSurface : DesignSystem.lightSurface,
          borderRadius: DesignSystem.borderRadiusM,
          boxShadow: isDark ? DesignSystem.shadowDark : DesignSystem.shadowLight,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Route number badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: groupedRoute.color.withValues(alpha: 0.15),
                    borderRadius: DesignSystem.borderRadiusS,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          groupedRoute.routeNumber,
                          style: DesignSystem.headingM.copyWith(
                            color: groupedRoute.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: DesignSystem.spacingS),

                // Route name and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupedRoute.name,
                        style: DesignSystem.bodyL.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              groupedRoute.area,
                              style: DesignSystem.labelM.copyWith(
                                color: Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.near_me, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 2),
                          Text(
                            '${groupedRoute.stopsCount} stops',
                            style: DesignSystem.labelM.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Live badge or chevron
                if (groupedRoute.isOperating)
                  _LiveBadge(period: groupedRoute.activePeriod)
                else
                  Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
              ],
            ),

            const SizedBox(height: DesignSystem.spacingS),

            // Direction rows
            if (groupedRoute.amRoute != null)
              _DirectionRow(
                label: 'AM',
                time: '${groupedRoute.amRoute!.formattedStartTime} - ${groupedRoute.amRoute!.formattedEndTime}',
                origin: groupedRoute.amOrigin,
                destination: groupedRoute.amDestination,
                color: DesignSystem.warningColor,
                isActive: groupedRoute.activePeriod == 'AM',
                isDark: isDark,
              ),

            if (groupedRoute.amRoute != null && groupedRoute.pmRoute != null)
              const SizedBox(height: 6),

            if (groupedRoute.pmRoute != null)
              _DirectionRow(
                label: 'PM',
                time: '${groupedRoute.pmRoute!.formattedStartTime} - ${groupedRoute.pmRoute!.formattedEndTime}',
                origin: groupedRoute.pmOrigin,
                destination: groupedRoute.pmDestination,
                color: const Color(0xFF5C6BC0),
                isActive: groupedRoute.activePeriod == 'PM',
                isDark: isDark,
              ),
          ],
        ),
      ),
    );
  }

  void _showTrackingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteTrackingSheet(route: groupedRoute.primaryRoute),
    );
  }
}

/// Direction row - RESPONSIVE layout
class _DirectionRow extends StatelessWidget {
  final String label;
  final String time;
  final String origin;
  final String destination;
  final Color color;
  final bool isActive;
  final bool isDark;

  const _DirectionRow({
    required this.label,
    required this.time,
    required this.origin,
    required this.destination,
    required this.color,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingS,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.1)
            : (isDark ? DesignSystem.darkSurfaceVariant : DesignSystem.lightSurfaceVariant),
        borderRadius: DesignSystem.borderRadiusS,
        border: isActive ? Border.all(color: color.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Label and time
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: DesignSystem.labelM.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Bottom row: Origin → Destination (wraps if needed)
          Row(
            children: [
              Flexible(
                child: Text(
                  origin,
                  style: DesignSystem.bodyM.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.arrow_forward, size: 14, color: color),
              ),
              Flexible(
                child: Text(
                  destination,
                  style: DesignSystem.bodyM.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Live status badge
class _LiveBadge extends StatelessWidget {
  final String? period;

  const _LiveBadge({this.period});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: DesignSystem.successColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: DesignSystem.successColor,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            period != null ? '$period' : 'Live',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: DesignSystem.successColor,
            ),
          ),
        ],
      ),
    );
  }
}
