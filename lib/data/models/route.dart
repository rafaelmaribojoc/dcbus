import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

/// A bus route with its metadata and line geometry
@freezed
abstract class BusRoute with _$BusRoute {
  const BusRoute._();  // Private constructor for custom methods/getters
  
  const factory BusRoute({
    required String id,
    @JsonKey(name: 'route_number') required String routeNumber,
    required String name,
    required String area,
    @JsonKey(name: 'time_period') required String timePeriod,
    required String color,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required List<RoutePoint> points,
  }) = _BusRoute;

  factory BusRoute.fromJson(Map<String, dynamic> json) =>
      _$BusRouteFromJson(json);
  
  /// Get only named stops (excluding waypoints)
  List<RoutePoint> get stops => points.where((p) => p.isStop).toList();
  
  /// Get all coordinates as a list for map rendering
  List<(double lat, double lng)> get coordinates =>
      points.map((p) => (p.latitude, p.longitude)).toList();
  
  /// Check if route is currently operating
  bool isOperatingAt(DateTime time) {
    final now = time.hour * 60 + time.minute;
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    return now >= start && now <= end;
  }
  
  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
  
  /// Get display name with route number
  String get displayName => '$routeNumber - $name';

  /// Format "HH:mm" to "h:mm a"
  String _formatTime12H(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      final period = hour >= 12 ? 'PM' : 'AM';
      final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final m = minute.toString().padLeft(2, '0');
      
      return '$h:$m $period';
    } catch (e) {
      return time;
    }
  }

  String get formattedStartTime => _formatTime12H(startTime);
  String get formattedEndTime => _formatTime12H(endTime);
}

/// A point along a route - either a stop or a waypoint
@freezed
abstract class RoutePoint with _$RoutePoint {
  const RoutePoint._();  // Private constructor for custom methods/getters
  
  const factory RoutePoint({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    @Default('stop') String kind,
    double? heading,
  }) = _RoutePoint;
  
  /// Check if this is a named bus stop (not a waypoint)
  bool get isStop => kind == 'stop' && name.isNotEmpty;

  factory RoutePoint.fromJson(Map<String, dynamic> json) =>
      _$RoutePointFromJson(json);
}
