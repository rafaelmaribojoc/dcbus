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
  
  /// Stream of active bus sessions for a route
  Stream<List<BusSession>> watchBusesOnRoute(String routeId) {
    return _supabase
        .from('bus_sessions')
        .stream(primaryKey: ['id'])
        .map((rows) => rows
            .where((r) => r['route_id'] == routeId)
            .map((r) => BusSession.fromJson(r))
            .toList());
  }
  
  /// Stream of all active bus sessions
  Stream<List<BusSession>> watchAllBuses() {
    return _supabase
        .from('bus_sessions')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map((r) => BusSession.fromJson(r)).toList());
  }
  
  /// Join a bus session (or create one)
  /// Returns a record with (sessionId, isBroadcaster)
  Future<({String sessionId, bool isBroadcaster})> joinSession({
    required String routeId,
    required double latitude,
    required double longitude,
    required String destinationStopId,
  }) async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    // Call the join_bus_session RPC
    final response = await _supabase.rpc('join_bus_session', params: {
      'p_device_id': deviceId,
      'p_route_id': routeId,
      'p_lat': latitude,
      'p_lng': longitude,
      'p_destination_stop_id': destinationStopId,
    });
    
    // Response is a list of rows (should be length 1)
    final data = (response as List).first;
    return (
      sessionId: data['session_id'] as String,
      isBroadcaster: data['is_broadcaster'] as bool,
    );
  }
  
  /// Update session location (only if broadcaster)
  Future<void> updateLocation({
    required String sessionId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
  }) async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    await _supabase.rpc('update_session_location', params: {
      'p_session_id': sessionId,
      'p_device_id': deviceId,
      'p_lat': latitude,
      'p_lng': longitude,
      'p_heading': heading,
      'p_speed': speed,
    });
  }
  
  /// Leave session
  /// Returns new broadcaster ID if a handoff occurred, or null
  Future<String?> leaveSession() async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    final response = await _supabase.rpc('leave_bus_session', params: {
      'p_device_id': deviceId,
    });
    
    // Check if new broadcaster was elected
    if (response is List && response.isNotEmpty) {
      final data = response.first;
      return data['new_broadcaster_id'] as String?;
    }
    return null;
  }
  
  /// Listen for leadership changes (promotions)
  /// Returns true if this device just became the broadcaster
  Stream<bool> listenForPromotion(String sessionId) async* {
    final deviceId = await _deviceIdService.getDeviceId();
    
    // Listen to changes on session_passengers for this user
    // Note: Filtering client-side due to stream builder limitations in this version
    yield* _supabase
        .from('session_passengers')
        .stream(primaryKey: ['id'])
        .map((events) {
          final userRow = events.where((e) => 
            e['session_id'] == sessionId && 
            e['device_id'] == deviceId
          );
          
          if (userRow.isEmpty) return false;
          return userRow.first['is_broadcaster'] as bool;
        })
        .distinct(); // Only emit when role changes
  }
  
  /// Check if currently in a session
  Future<bool> isTracking() async {
    final deviceId = await _deviceIdService.getDeviceId();
    
    final result = await _supabase
        .from('session_passengers')
        .select('id')
        .eq('device_id', deviceId)
        .maybeSingle();
    
    return result != null;
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
/// Provider for buses on a specific route
final busesOnRouteProvider = StreamProvider.family<List<BusSession>, String>((ref, routeId) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchBusesOnRoute(routeId);
});

/// Provider for all buses
final allBusesProvider = StreamProvider<List<BusSession>>((ref) {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.watchAllBuses();
});

/// Provider for current tracking status
final isTrackingProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.isTracking();
});
