import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracker.freezed.dart';
part 'tracker.g.dart';

/// An active tracker (passenger with "I am on the bus" enabled)
@freezed
abstract class ActiveTracker with _$ActiveTracker {
  const factory ActiveTracker({
    required String id,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'route_id') required String routeId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
    @JsonKey(name: 'cluster_id') String? clusterId,
    @JsonKey(name: 'is_valid') @Default(true) bool isValid,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
  }) = _ActiveTracker;

  factory ActiveTracker.fromJson(Map<String, dynamic> json) =>
      _$ActiveTrackerFromJson(json);
}

/// A clustered bus (aggregated from nearby trackers)
@freezed
abstract class ClusteredBus with _$ClusteredBus {
  const ClusteredBus._();  // Private constructor for custom methods
  
  const factory ClusteredBus({
    required String id,
    @JsonKey(name: 'route_id') required String routeId,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'avg_heading') double? avgHeading,
    @JsonKey(name: 'avg_speed') double? avgSpeed,
    @JsonKey(name: 'tracker_count') @Default(1) int trackerCount,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
  }) = _ClusteredBus;
  
  /// Check if this bus data is stale (>5 min old)
  bool get isStale {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!).inMinutes > 5;
  }
  
  /// Get speed in km/h (stored as m/s)
  double get speedKmh => (avgSpeed ?? 0) * 3.6;

  /// Custom fromJson to handle PostGIS geography point format
  factory ClusteredBus.fromJson(Map<String, dynamic> json) {
    // Handle PostGIS geography point format
    final centroid = json['centroid'];
    double lat = 0, lng = 0;
    
    if (centroid is String && centroid.startsWith('POINT')) {
      // Parse POINT(lng lat) format from PostGIS
      final match = RegExp(r'POINT\(([\d.-]+) ([\d.-]+)\)').firstMatch(centroid);
      if (match != null) {
        lng = double.parse(match.group(1)!);
        lat = double.parse(match.group(2)!);
      }
    } else if (json.containsKey('latitude') && json.containsKey('longitude')) {
      lat = (json['latitude'] as num).toDouble();
      lng = (json['longitude'] as num).toDouble();
    }
    
    return ClusteredBus(
      id: json['id'] as String,
      routeId: json['route_id'] as String,
      latitude: lat,
      longitude: lng,
      avgHeading: (json['avg_heading'] as num?)?.toDouble(),
      avgSpeed: (json['avg_speed'] as num?)?.toDouble(),
      trackerCount: json['tracker_count'] as int? ?? 1,
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated'] as String) 
          : null,
    );
  }
}
