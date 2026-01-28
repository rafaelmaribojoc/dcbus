import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/app_config.dart';
import '../../data/repositories/tracker_repository.dart';
import '../../data/models/route.dart';

/// Service for handling GPS location tracking
class LocationService {
  final TrackerRepository _trackerRepository;
  
  StreamSubscription<Position>? _positionStream;
  String? _activeRouteId;
  BusRoute? _activeRoute;
  
  LocationService(this._trackerRepository);
  
  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    // Check location service
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }
    
    // Check permission
    var status = await Permission.locationWhenInUse.status;
    
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }
    
    return status.isGranted;
  }
  
  /// Start tracking on a specific route
  Future<bool> startTracking(BusRoute route) async {
    // Check permissions
    if (!await checkPermissions()) {
      return false;
    }
    
    _activeRouteId = route.id;
    _activeRoute = route;
    
    // Get initial position
    final initialPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    
    // Start tracking in Supabase
    await _trackerRepository.startTracking(
      routeId: route.id,
      latitude: initialPosition.latitude,
      longitude: initialPosition.longitude,
      heading: initialPosition.heading,
      speed: initialPosition.speed,
      accuracy: initialPosition.accuracy,
    );
    
    // Start streaming location
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: AppConfig.locationUpdateDistanceMeters,
      ),
    ).listen(_onPositionUpdate);
    
    return true;
  }
  
  /// Handle position updates
  void _onPositionUpdate(Position position) async {
    if (_activeRouteId == null) return;
    
    // Check if still on route (client-side validation)
    if (_activeRoute != null && !_isOnRoute(position, _activeRoute!)) {
      // User has deviated from route
      await stopTracking();
      return;
    }
    
    // Update position in Supabase
    await _trackerRepository.updateLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      heading: position.heading,
      speed: position.speed,
      accuracy: position.accuracy,
    );
  }
  
  /// Check if position is on route (simple distance check)
  bool _isOnRoute(Position position, BusRoute route) {
    final coords = route.coordinates;
    double minDistance = double.infinity;
    
    for (final (lat, lng) in coords) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        lat,
        lng,
      );
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
    
    return minDistance <= AppConfig.maxRouteDeviationMeters;
  }
  
  /// Stop tracking
  Future<void> stopTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    _activeRouteId = null;
    _activeRoute = null;
    
    await _trackerRepository.stopTracking();
  }
  
  /// Check if currently tracking
  bool get isTracking => _activeRouteId != null;
  
  /// Get current active route
  String? get activeRouteId => _activeRouteId;
  
  /// Get current position
  Future<Position?> getCurrentPosition() async {
    if (!await checkPermissions()) return null;
    
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}

/// Provider for LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref.watch(trackerRepositoryProvider));
});

/// Provider for tracking state (Riverpod 3.x Notifier pattern)
final trackingStateProvider = NotifierProvider<TrackingStateNotifier, TrackingState>(
  TrackingStateNotifier.new,
);

/// State for tracking
class TrackingState {
  final bool isTracking;
  final String? activeRouteId;
  final String? routeName;
  final String? error;
  
  const TrackingState({
    this.isTracking = false,
    this.activeRouteId,
    this.routeName,
    this.error,
  });
  
  TrackingState copyWith({
    bool? isTracking,
    String? activeRouteId,
    String? routeName,
    String? error,
  }) {
    return TrackingState(
      isTracking: isTracking ?? this.isTracking,
      activeRouteId: activeRouteId ?? this.activeRouteId,
      routeName: routeName ?? this.routeName,
      error: error ?? this.error,
    );
  }
}

/// Notifier for tracking state (Riverpod 3.x pattern)
class TrackingStateNotifier extends Notifier<TrackingState> {
  @override
  TrackingState build() => const TrackingState();
  
  Future<void> startTracking(BusRoute route) async {
    final locationService = ref.read(locationServiceProvider);
    
    try {
      final success = await locationService.startTracking(route);
      
      if (success) {
        state = state.copyWith(
          isTracking: true,
          activeRouteId: route.id,
          routeName: route.displayName,
          error: null,
        );
      } else {
        state = state.copyWith(
          error: 'Location permission denied',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }
  
  Future<void> stopTracking() async {
    final locationService = ref.read(locationServiceProvider);
    await locationService.stopTracking();
    state = const TrackingState();
  }
}
