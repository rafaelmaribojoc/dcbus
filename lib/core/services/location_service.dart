import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/app_config.dart';
import '../../data/repositories/tracker_repository.dart';
import '../../data/models/route.dart';

/// Service for handling GPS location tracking
/// Service for handling GPS location tracking and session management
class LocationService {
  final TrackerRepository _trackerRepository;
  
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<bool>? _promotionStream;
  
  String? _sessionId;
  bool _isBroadcaster = false;
  String? _destinationStopId;
  RoutePoint? _destinationStop;
  
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
  
  /// Join a session on a specific route
  Future<({bool success, bool isBroadcaster, String? error})> startTracking({
    required BusRoute route,
    required RoutePoint destinationStop,
  }) async {
    // Check permissions
    if (!await checkPermissions()) {
      return (success: false, isBroadcaster: false, error: 'Location permission denied');
    }
    
    _activeRouteId = route.id;
    _activeRoute = route;
    _destinationStopId = destinationStop.id;
    _destinationStop = destinationStop;
    
    try {
      // Get initial position
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      
      // Join/Start session in Supabase
      final result = await _trackerRepository.joinSession(
        routeId: route.id,
        latitude: initialPosition.latitude,
        longitude: initialPosition.longitude,
        destinationStopId: destinationStop.id,
      );
      
      _sessionId = result.sessionId;
      _isBroadcaster = result.isBroadcaster;
      
      // Listen for promotion if not broadcaster
      if (!_isBroadcaster) {
        _promotionStream = _trackerRepository
            .listenForPromotion(_sessionId!)
            .listen((isPromoted) {
          if (isPromoted) {
            _isBroadcaster = true;
          }
        });
      }
      
      // Start streaming location (for validcation/uploading)
      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: AppConfig.locationUpdateDistanceMeters,
        ),
      ).listen(_onPositionUpdate);
      
      return (success: true, isBroadcaster: _isBroadcaster, error: null);
      
    } catch (e) {
      return (success: false, isBroadcaster: false, error: e.toString());
    }
  }
  
  /// Handle position updates
  void _onPositionUpdate(Position position) async {
    if (_activeRouteId == null || _sessionId == null) return;
    
    // 1. Check if arrived at destination
    if (_destinationStop != null) {
      final distanceToDest = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _destinationStop!.latitude,
        _destinationStop!.longitude,
      );
      
      // Arrived within 100m
      if (distanceToDest < 100) {
        await stopTracking();
        return;
      }
    }
    
    // 2. Check if still on route (client-side validation for Broadcaster only)
    if (_isBroadcaster && _activeRoute != null && !_isOnRoute(position, _activeRoute!)) {
      // User has deviated from route significantly? Maybe don't kill session, but stop updating?
      // For now, let's just warn or ignore. 
      // Actually strictly, if deviated, we should probably yield leadership.
    }
    
    // 3. Update position in Supabase (ONLY IF BROADCASTER)
    if (_isBroadcaster) {
      await _trackerRepository.updateLocation(
        sessionId: _sessionId!,
        latitude: position.latitude,
        longitude: position.longitude,
        heading: position.heading,
        speed: position.speed,
      );
    }
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
  
  /// Stop tracking (Leave session)
  Future<void> stopTracking() async {
    await _positionStream?.cancel();
    await _promotionStream?.cancel();
    _positionStream = null;
    _promotionStream = null;
    
    _activeRouteId = null;
    _activeRoute = null;
    _sessionId = null;
    _isBroadcaster = false;
    _destinationStop = null;
    
    await _trackerRepository.leaveSession();
  }
  
  /// Check if currently tracking
  bool get isTracking => _activeRouteId != null;
  
  /// Get current role
  bool get isBroadcaster => _isBroadcaster;
  
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
  final bool isBroadcaster;
  final String? activeRouteId;
  final String? routeName;
  final String? destinationStopName;
  final String? error;
  
  const TrackingState({
    this.isTracking = false,
    this.isBroadcaster = false,
    this.activeRouteId,
    this.routeName,
    this.destinationStopName,
    this.error,
  });
  
  TrackingState copyWith({
    bool? isTracking,
    bool? isBroadcaster,
    String? activeRouteId,
    String? routeName,
    String? destinationStopName,
    String? error,
  }) {
    return TrackingState(
      isTracking: isTracking ?? this.isTracking,
      isBroadcaster: isBroadcaster ?? this.isBroadcaster,
      activeRouteId: activeRouteId ?? this.activeRouteId,
      routeName: routeName ?? this.routeName,
      destinationStopName: destinationStopName ?? this.destinationStopName,
      error: error ?? this.error,
    );
  }
}

/// Notifier for tracking state (Riverpod 3.x pattern)
class TrackingStateNotifier extends Notifier<TrackingState> {
  @override
  TrackingState build() => const TrackingState();
  
  Future<void> startTracking(BusRoute route, RoutePoint destinationStop) async {
    final locationService = ref.read(locationServiceProvider);
    
    // Optimistic loading state?
    state = state.copyWith(error: null);
    
    final result = await locationService.startTracking(
      route: route,
      destinationStop: destinationStop,
    );
    
    if (result.success) {
      state = state.copyWith(
        isTracking: true,
        isBroadcaster: result.isBroadcaster,
        activeRouteId: route.id,
        routeName: route.displayName,
        destinationStopName: destinationStop.name,
        error: null,
      );
    } else {
      state = state.copyWith(
        error: result.error ?? 'Failed to join session',
      );
    }
  }
  
  Future<void> stopTracking() async {
    final locationService = ref.read(locationServiceProvider);
    await locationService.stopTracking();
    state = const TrackingState();
  }
}
