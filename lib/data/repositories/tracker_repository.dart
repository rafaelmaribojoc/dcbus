import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/tracker.dart';
import '../../core/services/device_id_service.dart';

/// Repository for tracker data
/// Handles real-time tracking and Supabase communication
class TrackerRepository {
  final SupabaseClient _supabase;
  final DeviceIdService _deviceIdService;
  
  TrackerRepository(this._supabase, this._deviceIdService);
  
  /// Stream of clustered buses for a specific route
  Stream<List<ClusteredBus>> watchBusesOnRoute(String routeId) {
    return _supabase
        .from('clustered_buses')
        .stream(primaryKey: ['id'])
        .eq('route_id', routeId)
        .map((rows) => rows.map((r) => ClusteredBus.fromJson(r)).toList());
  }
  
  /// Stream of all clustered buses (for overview map)
  Stream<List<ClusteredBus>> watchAllBuses() {
    return _supabase
        .from('clustered_buses')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((r) => ClusteredBus.fromJson(r)).toList());
  }
  
  /// Start tracking on a route
  /// Returns the tracker ID
  Future<String?> startTracking({
    required String routeId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  }) async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    // Use the upsert_tracker_location function
    final response = await _supabase.rpc('upsert_tracker_location', params: {
      'p_device_id': deviceId,
      'p_route_id': routeId,
      'p_longitude': longitude,
      'p_latitude': latitude,
      'p_heading': heading,
      'p_speed': speed,
      'p_accuracy': accuracy,
    });
    
    return response as String?;
  }
  
  /// Update tracker location
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  }) async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    // Get current route
    final tracker = await _supabase
        .from('active_trackers')
        .select('route_id')
        .eq('device_id', deviceId)
        .maybeSingle();
    
    if (tracker == null) return;
    
    await _supabase.rpc('upsert_tracker_location', params: {
      'p_device_id': deviceId,
      'p_route_id': tracker['route_id'],
      'p_longitude': longitude,
      'p_latitude': latitude,
      'p_heading': heading,
      'p_speed': speed,
      'p_accuracy': accuracy,
    });
  }
  
  /// Stop tracking
  Future<void> stopTracking() async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    // Set device context for RLS
    await _supabase.rpc('set_device_context', params: {
      'p_device_id': deviceId,
    });
    
    await _supabase
        .from('active_trackers')
        .delete()
        .eq('device_id', deviceId);
  }
  
  /// Check if currently tracking
  Future<bool> isTracking() async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    final result = await _supabase
        .from('active_trackers')
        .select('id')
        .eq('device_id', deviceId)
        .maybeSingle();
    
    return result != null;
  }
  
  /// Get current tracking status
  Future<ActiveTracker?> getCurrentTracker() async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    final result = await _supabase
        .from('active_trackers')
        .select()
        .eq('device_id', deviceId)
        .maybeSingle();
    
    if (result == null) return null;
    
    // Parse location from PostGIS format
    final location = result['location'] as String?;
    double lat = 0, lng = 0;
    if (location != null && location.startsWith('POINT')) {
      final match = RegExp(r'POINT\(([\d.-]+) ([\d.-]+)\)').firstMatch(location);
      if (match != null) {
        lng = double.parse(match.group(1)!);
        lat = double.parse(match.group(2)!);
      }
    }
    
    return ActiveTracker(
      id: result['id'],
      deviceId: result['device_id'],
      routeId: result['route_id'],
      latitude: lat,
      longitude: lng,
      heading: (result['heading'] as num?)?.toDouble(),
      speed: (result['speed'] as num?)?.toDouble(),
      accuracy: (result['accuracy'] as num?)?.toDouble(),
      clusterId: result['cluster_id'],
      isValid: result['is_valid'] ?? true,
      lastUpdated: result['last_updated'] != null 
          ? DateTime.parse(result['last_updated']) 
          : null,
    );
  }
}

/// Provider for TrackerRepository
final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return TrackerRepository(
    Supabase.instance.client,
    ref.watch(deviceIdServiceProvider),
  );
});

/// Provider for buses on a specific route
final busesOnRouteProvider = StreamProvider.family<List<ClusteredBus>, String>((ref, routeId) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchBusesOnRoute(routeId);
});

/// Provider for all buses
final allBusesProvider = StreamProvider<List<ClusteredBus>>((ref) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchAllBuses();
});

/// Provider for current tracking status
final isTrackingProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.isTracking();
});
