import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/route.dart';

/// Repository for bus route data
/// Loads from local JSON assets with Hive caching for offline access
class RouteRepository {
  static const String _cacheBoxName = 'routes_cache';
  static const String _routesKey = 'all_routes';
  static const String _lastSyncKey = 'last_sync';
  
  Box? _cacheBox;
  List<BusRoute>? _cachedRoutes;
  
  /// Initialize the cache box
  Future<void> init() async {
    _cacheBox = await Hive.openBox(_cacheBoxName);
  }
  
  /// Get all routes (from cache or assets)
  Future<List<BusRoute>> getAllRoutes() async {
    // Return in-memory cache if available
    if (_cachedRoutes != null) return _cachedRoutes!;
    
    // Try loading from Hive cache first
    final cached = await _loadFromCache();
    if (cached != null) {
      _cachedRoutes = cached;
      return cached;
    }
    
    // Load from assets
    final routes = await _loadFromAssets();
    _cachedRoutes = routes;
    
    // Cache for offline use
    await _saveToCache(routes);
    
    return routes;
  }
  
  /// Load routes from bundled JSON assets
  Future<List<BusRoute>> _loadFromAssets() async {
    final List<BusRoute> routes = [];
    
    // Route files in the routes folder
    final routeFiles = [
      'routes/R102-AM.json', 'routes/R102-PM.json',
      'routes/R103-AM.json', 'routes/R103-PM.json',
      'routes/R402-AM.json', 'routes/R402-PM.json',
      'routes/R403-AM.json', 'routes/R403-PM.json',
      'routes/R503-AM.json', 'routes/R503-PM.json',
      'routes/R603-AM.json', 'routes/R603-PM.json',
      'routes/R763-AM.json', 'routes/R763-PM.json',
      'routes/R783-AM.json', 'routes/R783-PM.json',
      'routes/R793-AM.json', 'routes/R793-PM.json',
      'routes/Z999-AM.json',
    ];
    
    for (final file in routeFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        routes.add(BusRoute.fromJson(json));
      } catch (e) {
        // Skip files that don't exist or are malformed
        print('Warning: Could not load route file $file: $e');
      }
    }
    
    return routes;
  }
  
  /// Load from Hive cache
  Future<List<BusRoute>?> _loadFromCache() async {
    if (_cacheBox == null) await init();
    
    final cached = _cacheBox?.get(_routesKey);
    if (cached == null) return null;
    
    try {
      final List<dynamic> jsonList = jsonDecode(cached as String);
      return jsonList
          .map((json) => BusRoute.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Warning: Cache corrupted, will reload from assets: $e');
      return null;
    }
  }
  
  /// Save to Hive cache
  Future<void> _saveToCache(List<BusRoute> routes) async {
    if (_cacheBox == null) await init();
    
    // Convert to JSON for storage
    final jsonList = routes.map((r) => r.toJson()).toList();
    await _cacheBox?.put(_routesKey, jsonEncode(jsonList));
    await _cacheBox?.put(_lastSyncKey, DateTime.now().toIso8601String());
  }
  
  /// Get routes by area
  Future<List<BusRoute>> getRoutesByArea(String area) async {
    final routes = await getAllRoutes();
    return routes.where((r) => r.area == area).toList();
  }
  
  /// Get routes currently operating
  Future<List<BusRoute>> getActiveRoutes() async {
    final routes = await getAllRoutes();
    final now = DateTime.now();
    return routes.where((r) => r.isOperatingAt(now)).toList();
  }
  
  /// Get a single route by ID
  Future<BusRoute?> getRouteById(String id) async {
    final routes = await getAllRoutes();
    try {
      return routes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
  
  /// Get unique areas for filtering
  Future<List<String>> getAreas() async {
    final routes = await getAllRoutes();
    return routes.map((r) => r.area).toSet().toList()..sort();
  }
  
  /// Clear cache (force reload on next access)
  Future<void> clearCache() async {
    await _cacheBox?.delete(_routesKey);
    _cachedRoutes = null;
  }
}

/// Provider for RouteRepository
final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return RouteRepository();
});

/// Provider for all routes
final allRoutesProvider = FutureProvider<List<BusRoute>>((ref) async {
  final repo = ref.watch(routeRepositoryProvider);
  await repo.init();
  return repo.getAllRoutes();
});

/// Provider for currently active routes
final activeRoutesProvider = FutureProvider<List<BusRoute>>((ref) async {
  final repo = ref.watch(routeRepositoryProvider);
  await repo.init();
  return repo.getActiveRoutes();
});

/// Provider for routes by area
final routesByAreaProvider = FutureProvider.family<List<BusRoute>, String>((ref, area) async {
  final repo = ref.watch(routeRepositoryProvider);
  await repo.init();
  return repo.getRoutesByArea(area);
});

/// Provider for unique areas
final areasProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(routeRepositoryProvider);
  await repo.init();
  return repo.getAreas();
});
