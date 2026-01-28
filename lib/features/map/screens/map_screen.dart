import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/stop_navigation_provider.dart';
import '../../../core/services/route_service.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/route.dart';
import '../../../data/repositories/route_repository.dart';
import '../../../data/repositories/tracker_repository.dart';
import '../../../data/repositories/tracker_repository.dart';
import '../../tracking/screens/route_tracking_sheet.dart';
import 'package:geolocator/geolocator.dart' as geo;

/// Main map screen showing routes and live buses
/// Redesigned with Antigravity Design System
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  BusRoute? _selectedRoute;
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _stopMarkerManager;
  PointAnnotationManager? _routeStopsManager;
  PolylineAnnotationManager? _routeLineManager;
  RoutePoint? _highlightedStop;
  _NearestStopData? _nearestStopData;
  final Map<String, RoutePoint> _stopAnnotationMap = {};
  
  @override
  void initState() {
    super.initState();
    // Set the Mapbox access token
    MapboxOptions.setAccessToken(AppConfig.mapboxAccessToken);
  }
  
  @override
  Widget build(BuildContext context) {
    final routesAsync = ref.watch(allRoutesProvider);
    final busesAsync = ref.watch(allBusesProvider);
    
    // Listen for stop navigation requests
    ref.listen<StopNavigationState>(stopNavigationProvider, (previous, next) {
      if (next.targetStop != null) {
        _flyToStop(next.targetStop!, next.route);
        // Clear the navigation target
        ref.read(stopNavigationProvider.notifier).clearTarget();
      }
    });
    
    return Scaffold(
      body: Stack(
        children: [
          // Mapbox Map
          MapWidget(
            key: const ValueKey('mapWidget'),
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  AppConfig.davaoCenterLng,
                  AppConfig.davaoCenterLat,
                ),
              ),
              zoom: AppConfig.defaultZoom,
              pitch: 45.0,
            ),
            styleUri: MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
          ),
          
          // Route selector chip bar with glass effect
          Positioned(
            top: MediaQuery.of(context).padding.top + DesignSystem.spacingS,
            left: DesignSystem.spacingS,
            right: DesignSystem.spacingS,
            child: routesAsync.when(
              data: (routes) => _RouteChipBar(
                routes: routes,
                selectedRoute: _selectedRoute,
                onRouteSelected: _onRouteSelected,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          
          // Bus count overlay with glass effect
          Positioned(
            bottom: DesignSystem.spacingM,
            left: DesignSystem.spacingS,
            child: busesAsync.when(
              data: (buses) => _BusCountBadge(count: buses.length),
              loading: () => const _BusCountBadge(count: 0),
              error: (_, __) => const _BusCountBadge(count: 0),
            ),
          ),
          
          // Stop info overlay when a stop is highlighted
          if (_highlightedStop != null)
            Positioned(
              bottom: DesignSystem.spacingL + 60,
              left: DesignSystem.spacingS,
              right: DesignSystem.spacingS,
              child: _StopInfoCard(
                stop: _highlightedStop!,
                routeColor: _selectedRoute != null
                    ? Color(int.parse(_selectedRoute!.color.replaceFirst('#', '0xFF')))
                    : DesignSystem.actionColor,
                onDismiss: _clearHighlightedStop,
                nearestData: _nearestStopData,
              ),
            ),
        ],
      ),
      // Premium FABs with bouncy effect
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Nearest Station FAB
          BouncyButton(
            onTap: _findNearestStop,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: DesignSystem.lightSurface,
                shape: BoxShape.circle,
                boxShadow: DesignSystem.shadowMedium,
              ),
              child: const Icon(
                Icons.near_me_rounded,
                color: DesignSystem.actionColor,
              ),
            ),
          ),
          
          if (_selectedRoute != null) ...[
            const SizedBox(height: DesignSystem.spacingS),
            BouncyButton(
              onTap: () => _showTrackingSheet(_selectedRoute!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingM,
                  vertical: DesignSystem.spacingS,
                ),
                decoration: BoxDecoration(
                  color: DesignSystem.actionColor,
                  borderRadius: DesignSystem.borderRadiusM,
                  boxShadow: DesignSystem.shadowMedium,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                    ),
                    const SizedBox(width: DesignSystem.spacingXS),
                    const Text(
                      "I'm on this bus",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    
    // Initialize managers
    _routeLineManager = await mapboxMap.annotations.createPolylineAnnotationManager();
    _stopMarkerManager = await mapboxMap.annotations.createPointAnnotationManager();
    _routeStopsManager = await mapboxMap.annotations.createPointAnnotationManager();
    
    // Handle taps on station icons
    _routeStopsManager?.addOnPointAnnotationClickListener(_RouteStopsClickListener(this));
    
    // Add custom bus icon to style
    try {
      final busIconBytes = await _buildBusIconImage();
      await mapboxMap.style.addStyleImage("bus-icon", 2.0, MbxImage(width: 64, height: 64, data: busIconBytes), false, [], [], null);
    } catch (e) {
      debugPrint("Error adding bus icon: $e");
    }
    
    // Check for pending stop navigation
    final navState = ref.read(stopNavigationProvider);
    if (navState.targetStop != null) {
      // Use a slight delay to ensure map is fully ready for annotations
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _flyToStop(navState.targetStop!, navState.route);
          ref.read(stopNavigationProvider.notifier).clearTarget();
        }
      });
    }
    
    // Draw all routes initially
    final routes = await ref.read(allRoutesProvider.future);
    _drawRoutes(routes);
    
    // Enable location component
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: DesignSystem.actionColor.value,
        pulsingMaxRadius: 30.0,
      ),
    );
  }

  Future<Uint8List> _buildBusIconImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(64, 64);
    
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    // Draw circle background
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30, paint);
    
    // Draw border
    paint
      ..color = DesignSystem.actionColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 28, paint);
    
    // Draw bus icon
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.directions_bus_rounded.codePoint),
      style: TextStyle(
        fontSize: 40,
        fontFamily: Icons.directions_bus_rounded.fontFamily,
        color: DesignSystem.actionColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
    
    final picture = recorder.endRecording();
    final img = await picture.toImage(64, 64);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  
  void _onRouteSelected(BusRoute? route) {
    setState(() => _selectedRoute = route);
    
    if (route != null) {
      // Find all variants of this route (e.g., AM/PM)
      final allRoutes = ref.read(allRoutesProvider).asData?.value ?? [];
      final variants = allRoutes.where((r) => r.routeNumber == route.routeNumber).toList();
      
      // Filter by current time (operating hours)
      final now = DateTime.now();
      final activeRoutes = variants.where((r) => r.isOperatingAt(now)).toList();
      
      // Draw active routes (fallback to all variants if none active)
      final routesToDraw = activeRoutes.isNotEmpty ? activeRoutes : variants;
      
      _drawRoutes(routesToDraw);
      
      // Fly to the first route to draw
      if (routesToDraw.isNotEmpty) {
        _flyToRoute(routesToDraw.first);
        _highlightRoute(routesToDraw.first);
      }
    } else {
      // Show all routes
      final allRoutes = ref.read(allRoutesProvider).asData?.value ?? [];
      _drawRoutes(allRoutes);
      _resetMapView();
    }
  }
  
  void _drawRoutes(List<BusRoute> routes) async {
    if (_mapboxMap == null || _routeLineManager == null || _routeStopsManager == null) return;
    
    // Clear existing lines and stops
    await _routeLineManager!.deleteAll();
    await _routeStopsManager!.deleteAll();
    
    final drawnStopIds = <String>{};
    
    for (final route in routes) {
      final color = int.parse(route.color.replaceFirst('#', '0xFF'));
      
      // 1. Draw Route Line
      final coordinates = route.points.map((p) => 
        Position(p.longitude, p.latitude)
      ).toList();
      
      await _routeLineManager!.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: coordinates),
          lineColor: color,
          lineWidth: 4.0,
          lineOpacity: 0.8,
        ),
      );
      
      // 2. Draw Station Icons (deduplicate shared stops)
      for (final stop in route.stops) {
        if (drawnStopIds.contains(stop.id)) continue;
        drawnStopIds.add(stop.id);
        
        final annotation = await _routeStopsManager!.create(
          PointAnnotationOptions(
            geometry: Point(coordinates: Position(stop.longitude, stop.latitude)),
            iconImage: "bus-icon",
            iconSize: 1.0, 
            // Remove text to fix clutter
          ),
        );
        _stopAnnotationMap[annotation.id] = stop;
      }
    }
  }
  
  void _flyToRoute(BusRoute route) async {
    if (_mapboxMap == null || route.points.isEmpty) return;
    
    // Calculate the center of the route
    double minLat = double.infinity, maxLat = -double.infinity;
    double minLng = double.infinity, maxLng = -double.infinity;
    
    for (final point in route.points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    
    await _mapboxMap!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(centerLng, centerLat)),
        zoom: 13.0,
        pitch: 45.0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }
  
  /// Fly to a specific stop on the map
  void _flyToStop(RoutePoint stop, BusRoute? route) async {
    if (_mapboxMap == null) return;
    
    setState(() => _highlightedStop = stop);
    
    // Also select the route if provided
    if (route != null && _selectedRoute?.id != route.id) {
      _selectedRoute = route;
    }
    
    // Create stop marker manager if needed
    _stopMarkerManager ??= await _mapboxMap!.annotations.createPointAnnotationManager();
    
    // Clear previous markers
    await _stopMarkerManager!.deleteAll();
    
    // Add marker for the stop
    await _stopMarkerManager!.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(stop.longitude, stop.latitude)),
        iconSize: 1.5,
        iconColor: route != null 
            ? int.parse(route.color.replaceFirst('#', '0xFF'))
            : 0xFF6366F1,
        textField: stop.name,
        textSize: 14.0,
        textColor: Colors.black.value,
        textHaloColor: Colors.white.value,
        textHaloWidth: 2.0,
        textOffset: [0.0, 2.0],
      ),
    );
    
    await _mapboxMap!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(stop.longitude, stop.latitude)),
        zoom: 17.0, // Close zoom to see the stop clearly
        pitch: 50.0,
      ),
      MapAnimationOptions(duration: 800),
    );
  }
  
  void _highlightRoute(BusRoute route) {
    // Future enhancement: highlight the selected route
  }

  /// Find and highlight the nearest stop to the user
  Future<void> _findNearestStop() async {
    // check permission
    final permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      final requested = await geo.Geolocator.requestPermission();
      if (requested == geo.LocationPermission.denied) return;
    }
    
    // Get current position
    final position = await geo.Geolocator.getCurrentPosition();
    final routes = await ref.read(allRoutesProvider.future);
    
    RoutePoint? nearestStop;
    BusRoute? nearestRoute;
    double minDistance = double.infinity;
    
    // Find nearest stop across all routes
    for (final route in routes) {
      for (final stop in route.stops) {
        final distance = geo.Geolocator.distanceBetween(
          position.latitude, 
          position.longitude, 
          stop.latitude, 
          stop.longitude
        );
        
        if (distance < minDistance) {
          minDistance = distance;
          nearestStop = stop;
          nearestRoute = route;
        }
      }
    }
    
    if (nearestStop != null && nearestRoute != null) {
      // Calculate travel times
      final travelTimes = _calculateTravelTimes(minDistance);
      
      // Highlight it
      _highlightNearestStop(nearestStop, nearestRoute, minDistance, travelTimes, position);
      
      // Fly to show both user and stop
      // Simple bbox approach
      final latDiff = (nearestStop.latitude - position.latitude).abs();
      final lngDiff = (nearestStop.longitude - position.longitude).abs();
      final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
      final zoom = maxDiff > 0.05 ? 12.0 : (maxDiff > 0.01 ? 14.0 : 16.0);
      
      await _mapboxMap!.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
              (position.longitude + nearestStop.longitude) / 2, 
              (position.latitude + nearestStop.latitude) / 2
            ),
          ),
          zoom: zoom,
          pitch: 45.0,
        ),
        MapAnimationOptions(duration: 1000),
      );
    }
  }
  
  Map<String, int> _calculateTravelTimes(double distanceMeters) {
    // Speeds in km/h converted to m/min
    // Walk: 5 km/h ~= 83 m/min
    // Motor: 30 km/h ~= 500 m/min
    // Car: 40 km/h ~= 666 m/min
    
    const walkSpeed = 83.0; 
    const motorSpeed = 500.0;
    const carSpeed = 666.0;
    
    return {
      'Walk': (distanceMeters / walkSpeed).ceil(),
      'Motor': (distanceMeters / motorSpeed).ceil(),
      'Car': (distanceMeters / carSpeed).ceil(),
    };
  }
  
  void _highlightNearestStop(
    RoutePoint stop, 
    BusRoute route, 
    double distance, 
    Map<String, int> travelTimes,
    geo.Position userPosition,
  ) async {
    if (_mapboxMap == null) return;
    
    setState(() {
      _highlightedStop = stop;
      _nearestStopData = _NearestStopData(
        distance: distance,
        travelTimes: travelTimes,
      );
    });
    
    // Create stop marker manager if needed
    _stopMarkerManager ??= await _mapboxMap!.annotations.createPointAnnotationManager();
    await _stopMarkerManager!.deleteAll();
    
    // 1. Destination Marker (Bus Stop)
    await _stopMarkerManager!.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(stop.longitude, stop.latitude)),
        iconSize: 1.5,
        iconColor: int.parse(route.color.replaceFirst('#', '0xFF')),
        textField: "Nearest: ${stop.name}",
        textSize: 14.0,
        textColor: Colors.black.value,
        textHaloColor: Colors.white.value,
        textHaloWidth: 2.0,
        textOffset: [0.0, 2.0],
      ),
    );
    
    // 2. Start Marker (User Location)
    await _stopMarkerManager!.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(userPosition.longitude, userPosition.latitude)),
        // Using a distinct icon/color for start
        iconImage: "marker-15", 
        iconSize: 1.2,
        iconColor: DesignSystem.actionColor.value, 
        textField: "You",
        textSize: 12.0,
        textColor: DesignSystem.actionColor.value,
        textHaloColor: Colors.white.value,
        textHaloWidth: 2.0,
        textOffset: [0.0, -1.5],
      ),
    );
    
    // 3. Connecting Line
    // Fetch actual route geometry
    final routeCoordinates = await RouteService.getRoute(
      userPosition.latitude,
      userPosition.longitude,
      stop.latitude,
      stop.longitude,
    );

    final lineManager = await _mapboxMap!.annotations.createPolylineAnnotationManager();
    await lineManager.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: routeCoordinates),
        lineColor: DesignSystem.actionColor.value,
        lineWidth: 3.0,
        lineOpacity: 0.7,
      ),
    );
  }

  /// Clear the highlighted stop
  void _clearHighlightedStop() async {
    if (_stopMarkerManager != null) {
      await _stopMarkerManager!.deleteAll();
    }
    setState(() {
      _highlightedStop = null;
      _nearestStopData = null;
    });
  }
  
  void _resetMapView() async {
    if (_mapboxMap == null) return;
    
    await _mapboxMap!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            AppConfig.davaoCenterLng,
            AppConfig.davaoCenterLat,
          ),
        ),
        zoom: AppConfig.defaultZoom,
        pitch: 45.0,
      ),
      MapAnimationOptions(duration: 500),
    );
  }
  
  void _showTrackingSheet(BusRoute route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteTrackingSheet(route: route),
    );
  }
}

/// Horizontal scrollable route filter chips with glass effect
class _RouteChipBar extends StatelessWidget {
  final List<BusRoute> routes;
  final BusRoute? selectedRoute;
  final ValueChanged<BusRoute?> onRouteSelected;
  
  const _RouteChipBar({
    required this.routes,
    this.selectedRoute,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Group by route number (combine AM/PM)
    final routeNumbers = routes.map((r) => r.routeNumber).toSet().toList()..sort();
    
    return GlassContainer(
      padding: const EdgeInsets.symmetric(
        vertical: DesignSystem.spacingXS,
        horizontal: DesignSystem.spacingXS,
      ),
      borderRadius: DesignSystem.borderRadiusM,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: DesignSystem.bouncingPhysics,
        child: Row(
          children: [
            // All routes chip
            Padding(
              padding: const EdgeInsets.only(right: DesignSystem.spacingXS),
              child: BouncyChip(
                label: 'All',
                selected: selectedRoute == null,
                onTap: () => onRouteSelected(null),
              ),
            ),
            
            // Individual route chips
            ...routeNumbers.map((routeNum) {
              final route = routes.firstWhere((r) => r.routeNumber == routeNum);
              final isSelected = selectedRoute?.routeNumber == routeNum;
              final routeColor = Color(
                int.parse(route.color.replaceFirst('#', '0xFF')),
              );
              
              return Padding(
                padding: const EdgeInsets.only(right: DesignSystem.spacingXS),
                child: BouncyChip(
                  label: routeNum,
                  selected: isSelected,
                  color: routeColor,
                  onTap: () => onRouteSelected(isSelected ? null : route),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Badge showing active bus count with animated styling
class _BusCountBadge extends StatelessWidget {
  final int count;
  
  const _BusCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isActive = count > 0;
    
    return GlassContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingS,
        vertical: DesignSystem.spacingXS + 4,
      ),
      borderRadius: DesignSystem.borderRadiusM,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated dot indicator
          AnimatedContainer(
            duration: DesignSystem.animMedium,
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? DesignSystem.successColor : Colors.grey,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: DesignSystem.successColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: DesignSystem.spacingXS),
          // Count with large emphasis (Data as UI)
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isActive ? DesignSystem.successColor : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'active',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive 
                  ? DesignSystem.successColor.withValues(alpha: 0.8) 
                  : Colors.grey.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}


/// Info card for a selected stop with glass effect
class _StopInfoCard extends StatelessWidget {
  final RoutePoint stop;
  final Color routeColor;
  final VoidCallback onDismiss;
  final _NearestStopData? nearestData;

  const _StopInfoCard({
    required this.stop,
    required this.routeColor,
    required this.onDismiss,
    this.nearestData,
  });



  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      borderRadius: DesignSystem.borderRadiusM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: routeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: routeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: DesignSystem.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.name,
                      style: DesignSystem.headingS,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nearestData != null 
                        ? '${_formatDistance(nearestData!.distance)} away'
                        : 'Bus Stop',
                      style: DesignSystem.bodyS.copyWith(
                        color: nearestData != null ? DesignSystem.actionColor : Colors.grey,
                        fontWeight: nearestData != null ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withValues(alpha: 0.1),
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          
          if (nearestData != null) ...[
            const SizedBox(height: DesignSystem.spacingM),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
            const SizedBox(height: DesignSystem.spacingM),
            
            // Travel times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTravelTime(
                  Icons.directions_walk, 
                  'Walk', 
                  nearestData!.travelTimes['Walk']!,
                ),
                _buildTravelTime(
                  Icons.two_wheeler, 
                  'Motor', 
                  nearestData!.travelTimes['Motor']!,
                ),
                _buildTravelTime(
                  Icons.local_taxi, 
                  'Car', 
                  nearestData!.travelTimes['Car']!,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }
  
  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hrs = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hrs hr';
    return '$hrs hr $mins min';
  }
  
  Widget _buildTravelTime(IconData icon, String label, int minutes) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          _formatDuration(minutes),
          style: DesignSystem.headingS.copyWith(fontSize: 14),
        ),
        Text(
          label,
          style: DesignSystem.bodyS.copyWith(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}

class _NearestStopData {
  final double distance;
  final Map<String, int> travelTimes;
  
  _NearestStopData({
    required this.distance,
    required this.travelTimes,
  });
}

class _RouteStopsClickListener extends OnPointAnnotationClickListener {
  final _MapScreenState _state;
  
  _RouteStopsClickListener(this._state);
  
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final stop = _state._stopAnnotationMap[annotation.id];
    if (stop != null) {
      // Need to use a callback or expose method, but since we are in same file
      // we can access private state if we are careful, but typically we pass a callback.
      // However, for simplicity let's assume we can access it via the state object reference
      // or better, define a method on state.
      // Actually accessing private `_highlightedStop` from another class in same library is allowed in Dart.
      
      _state.setState(() {
        _state._highlightedStop = stop;
      });
      
      // Also fly to it for better UX
      _state._flyToStop(stop, _state._selectedRoute);
    }
  }
}
