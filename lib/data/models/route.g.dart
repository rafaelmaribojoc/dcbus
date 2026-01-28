// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BusRoute _$BusRouteFromJson(Map<String, dynamic> json) => _BusRoute(
  id: json['id'] as String,
  routeNumber: json['route_number'] as String,
  name: json['name'] as String,
  area: json['area'] as String,
  timePeriod: json['time_period'] as String,
  color: json['color'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  points: (json['points'] as List<dynamic>)
      .map((e) => RoutePoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BusRouteToJson(_BusRoute instance) => <String, dynamic>{
  'id': instance.id,
  'route_number': instance.routeNumber,
  'name': instance.name,
  'area': instance.area,
  'time_period': instance.timePeriod,
  'color': instance.color,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'points': instance.points,
};

_RoutePoint _$RoutePointFromJson(Map<String, dynamic> json) => _RoutePoint(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  kind: json['kind'] as String? ?? 'stop',
  heading: (json['heading'] as num?)?.toDouble(),
);

Map<String, dynamic> _$RoutePointToJson(_RoutePoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'kind': instance.kind,
      'heading': instance.heading,
    };
