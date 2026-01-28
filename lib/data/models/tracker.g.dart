// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveTracker _$ActiveTrackerFromJson(Map<String, dynamic> json) =>
    _ActiveTracker(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      routeId: json['route_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      clusterId: json['cluster_id'] as String?,
      isValid: json['is_valid'] as bool? ?? true,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$ActiveTrackerToJson(_ActiveTracker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'route_id': instance.routeId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'heading': instance.heading,
      'speed': instance.speed,
      'accuracy': instance.accuracy,
      'cluster_id': instance.clusterId,
      'is_valid': instance.isValid,
      'last_updated': instance.lastUpdated?.toIso8601String(),
    };
