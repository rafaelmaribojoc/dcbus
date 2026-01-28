// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveTracker {

 String get id;@JsonKey(name: 'device_id') String get deviceId;@JsonKey(name: 'route_id') String get routeId; double get latitude; double get longitude; double? get heading; double? get speed; double? get accuracy;@JsonKey(name: 'cluster_id') String? get clusterId;@JsonKey(name: 'is_valid') bool get isValid;@JsonKey(name: 'last_updated') DateTime? get lastUpdated;
/// Create a copy of ActiveTracker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveTrackerCopyWith<ActiveTracker> get copyWith => _$ActiveTrackerCopyWithImpl<ActiveTracker>(this as ActiveTracker, _$identity);

  /// Serializes this ActiveTracker to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveTracker&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.clusterId, clusterId) || other.clusterId == clusterId)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,routeId,latitude,longitude,heading,speed,accuracy,clusterId,isValid,lastUpdated);

@override
String toString() {
  return 'ActiveTracker(id: $id, deviceId: $deviceId, routeId: $routeId, latitude: $latitude, longitude: $longitude, heading: $heading, speed: $speed, accuracy: $accuracy, clusterId: $clusterId, isValid: $isValid, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $ActiveTrackerCopyWith<$Res>  {
  factory $ActiveTrackerCopyWith(ActiveTracker value, $Res Function(ActiveTracker) _then) = _$ActiveTrackerCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId,@JsonKey(name: 'route_id') String routeId, double latitude, double longitude, double? heading, double? speed, double? accuracy,@JsonKey(name: 'cluster_id') String? clusterId,@JsonKey(name: 'is_valid') bool isValid,@JsonKey(name: 'last_updated') DateTime? lastUpdated
});




}
/// @nodoc
class _$ActiveTrackerCopyWithImpl<$Res>
    implements $ActiveTrackerCopyWith<$Res> {
  _$ActiveTrackerCopyWithImpl(this._self, this._then);

  final ActiveTracker _self;
  final $Res Function(ActiveTracker) _then;

/// Create a copy of ActiveTracker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? routeId = null,Object? latitude = null,Object? longitude = null,Object? heading = freezed,Object? speed = freezed,Object? accuracy = freezed,Object? clusterId = freezed,Object? isValid = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,clusterId: freezed == clusterId ? _self.clusterId : clusterId // ignore: cast_nullable_to_non_nullable
as String?,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveTracker].
extension ActiveTrackerPatterns on ActiveTracker {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveTracker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveTracker() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveTracker value)  $default,){
final _that = this;
switch (_that) {
case _ActiveTracker():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveTracker value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveTracker() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'route_id')  String routeId,  double latitude,  double longitude,  double? heading,  double? speed,  double? accuracy, @JsonKey(name: 'cluster_id')  String? clusterId, @JsonKey(name: 'is_valid')  bool isValid, @JsonKey(name: 'last_updated')  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveTracker() when $default != null:
return $default(_that.id,_that.deviceId,_that.routeId,_that.latitude,_that.longitude,_that.heading,_that.speed,_that.accuracy,_that.clusterId,_that.isValid,_that.lastUpdated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'route_id')  String routeId,  double latitude,  double longitude,  double? heading,  double? speed,  double? accuracy, @JsonKey(name: 'cluster_id')  String? clusterId, @JsonKey(name: 'is_valid')  bool isValid, @JsonKey(name: 'last_updated')  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _ActiveTracker():
return $default(_that.id,_that.deviceId,_that.routeId,_that.latitude,_that.longitude,_that.heading,_that.speed,_that.accuracy,_that.clusterId,_that.isValid,_that.lastUpdated);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'device_id')  String deviceId, @JsonKey(name: 'route_id')  String routeId,  double latitude,  double longitude,  double? heading,  double? speed,  double? accuracy, @JsonKey(name: 'cluster_id')  String? clusterId, @JsonKey(name: 'is_valid')  bool isValid, @JsonKey(name: 'last_updated')  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _ActiveTracker() when $default != null:
return $default(_that.id,_that.deviceId,_that.routeId,_that.latitude,_that.longitude,_that.heading,_that.speed,_that.accuracy,_that.clusterId,_that.isValid,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveTracker implements ActiveTracker {
  const _ActiveTracker({required this.id, @JsonKey(name: 'device_id') required this.deviceId, @JsonKey(name: 'route_id') required this.routeId, required this.latitude, required this.longitude, this.heading, this.speed, this.accuracy, @JsonKey(name: 'cluster_id') this.clusterId, @JsonKey(name: 'is_valid') this.isValid = true, @JsonKey(name: 'last_updated') this.lastUpdated});
  factory _ActiveTracker.fromJson(Map<String, dynamic> json) => _$ActiveTrackerFromJson(json);

@override final  String id;
@override@JsonKey(name: 'device_id') final  String deviceId;
@override@JsonKey(name: 'route_id') final  String routeId;
@override final  double latitude;
@override final  double longitude;
@override final  double? heading;
@override final  double? speed;
@override final  double? accuracy;
@override@JsonKey(name: 'cluster_id') final  String? clusterId;
@override@JsonKey(name: 'is_valid') final  bool isValid;
@override@JsonKey(name: 'last_updated') final  DateTime? lastUpdated;

/// Create a copy of ActiveTracker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveTrackerCopyWith<_ActiveTracker> get copyWith => __$ActiveTrackerCopyWithImpl<_ActiveTracker>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveTrackerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveTracker&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.clusterId, clusterId) || other.clusterId == clusterId)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,routeId,latitude,longitude,heading,speed,accuracy,clusterId,isValid,lastUpdated);

@override
String toString() {
  return 'ActiveTracker(id: $id, deviceId: $deviceId, routeId: $routeId, latitude: $latitude, longitude: $longitude, heading: $heading, speed: $speed, accuracy: $accuracy, clusterId: $clusterId, isValid: $isValid, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$ActiveTrackerCopyWith<$Res> implements $ActiveTrackerCopyWith<$Res> {
  factory _$ActiveTrackerCopyWith(_ActiveTracker value, $Res Function(_ActiveTracker) _then) = __$ActiveTrackerCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId,@JsonKey(name: 'route_id') String routeId, double latitude, double longitude, double? heading, double? speed, double? accuracy,@JsonKey(name: 'cluster_id') String? clusterId,@JsonKey(name: 'is_valid') bool isValid,@JsonKey(name: 'last_updated') DateTime? lastUpdated
});




}
/// @nodoc
class __$ActiveTrackerCopyWithImpl<$Res>
    implements _$ActiveTrackerCopyWith<$Res> {
  __$ActiveTrackerCopyWithImpl(this._self, this._then);

  final _ActiveTracker _self;
  final $Res Function(_ActiveTracker) _then;

/// Create a copy of ActiveTracker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? routeId = null,Object? latitude = null,Object? longitude = null,Object? heading = freezed,Object? speed = freezed,Object? accuracy = freezed,Object? clusterId = freezed,Object? isValid = null,Object? lastUpdated = freezed,}) {
  return _then(_ActiveTracker(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,clusterId: freezed == clusterId ? _self.clusterId : clusterId // ignore: cast_nullable_to_non_nullable
as String?,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ClusteredBus {

 String get id;@JsonKey(name: 'route_id') String get routeId; double get latitude; double get longitude;@JsonKey(name: 'avg_heading') double? get avgHeading;@JsonKey(name: 'avg_speed') double? get avgSpeed;@JsonKey(name: 'tracker_count') int get trackerCount;@JsonKey(name: 'last_updated') DateTime? get lastUpdated;
/// Create a copy of ClusteredBus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClusteredBusCopyWith<ClusteredBus> get copyWith => _$ClusteredBusCopyWithImpl<ClusteredBus>(this as ClusteredBus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClusteredBus&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.avgHeading, avgHeading) || other.avgHeading == avgHeading)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.trackerCount, trackerCount) || other.trackerCount == trackerCount)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,id,routeId,latitude,longitude,avgHeading,avgSpeed,trackerCount,lastUpdated);

@override
String toString() {
  return 'ClusteredBus(id: $id, routeId: $routeId, latitude: $latitude, longitude: $longitude, avgHeading: $avgHeading, avgSpeed: $avgSpeed, trackerCount: $trackerCount, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $ClusteredBusCopyWith<$Res>  {
  factory $ClusteredBusCopyWith(ClusteredBus value, $Res Function(ClusteredBus) _then) = _$ClusteredBusCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'route_id') String routeId, double latitude, double longitude,@JsonKey(name: 'avg_heading') double? avgHeading,@JsonKey(name: 'avg_speed') double? avgSpeed,@JsonKey(name: 'tracker_count') int trackerCount,@JsonKey(name: 'last_updated') DateTime? lastUpdated
});




}
/// @nodoc
class _$ClusteredBusCopyWithImpl<$Res>
    implements $ClusteredBusCopyWith<$Res> {
  _$ClusteredBusCopyWithImpl(this._self, this._then);

  final ClusteredBus _self;
  final $Res Function(ClusteredBus) _then;

/// Create a copy of ClusteredBus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routeId = null,Object? latitude = null,Object? longitude = null,Object? avgHeading = freezed,Object? avgSpeed = freezed,Object? trackerCount = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,avgHeading: freezed == avgHeading ? _self.avgHeading : avgHeading // ignore: cast_nullable_to_non_nullable
as double?,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,trackerCount: null == trackerCount ? _self.trackerCount : trackerCount // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClusteredBus].
extension ClusteredBusPatterns on ClusteredBus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClusteredBus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClusteredBus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClusteredBus value)  $default,){
final _that = this;
switch (_that) {
case _ClusteredBus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClusteredBus value)?  $default,){
final _that = this;
switch (_that) {
case _ClusteredBus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'route_id')  String routeId,  double latitude,  double longitude, @JsonKey(name: 'avg_heading')  double? avgHeading, @JsonKey(name: 'avg_speed')  double? avgSpeed, @JsonKey(name: 'tracker_count')  int trackerCount, @JsonKey(name: 'last_updated')  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClusteredBus() when $default != null:
return $default(_that.id,_that.routeId,_that.latitude,_that.longitude,_that.avgHeading,_that.avgSpeed,_that.trackerCount,_that.lastUpdated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'route_id')  String routeId,  double latitude,  double longitude, @JsonKey(name: 'avg_heading')  double? avgHeading, @JsonKey(name: 'avg_speed')  double? avgSpeed, @JsonKey(name: 'tracker_count')  int trackerCount, @JsonKey(name: 'last_updated')  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _ClusteredBus():
return $default(_that.id,_that.routeId,_that.latitude,_that.longitude,_that.avgHeading,_that.avgSpeed,_that.trackerCount,_that.lastUpdated);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'route_id')  String routeId,  double latitude,  double longitude, @JsonKey(name: 'avg_heading')  double? avgHeading, @JsonKey(name: 'avg_speed')  double? avgSpeed, @JsonKey(name: 'tracker_count')  int trackerCount, @JsonKey(name: 'last_updated')  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _ClusteredBus() when $default != null:
return $default(_that.id,_that.routeId,_that.latitude,_that.longitude,_that.avgHeading,_that.avgSpeed,_that.trackerCount,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc


class _ClusteredBus extends ClusteredBus {
  const _ClusteredBus({required this.id, @JsonKey(name: 'route_id') required this.routeId, required this.latitude, required this.longitude, @JsonKey(name: 'avg_heading') this.avgHeading, @JsonKey(name: 'avg_speed') this.avgSpeed, @JsonKey(name: 'tracker_count') this.trackerCount = 1, @JsonKey(name: 'last_updated') this.lastUpdated}): super._();
  

@override final  String id;
@override@JsonKey(name: 'route_id') final  String routeId;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey(name: 'avg_heading') final  double? avgHeading;
@override@JsonKey(name: 'avg_speed') final  double? avgSpeed;
@override@JsonKey(name: 'tracker_count') final  int trackerCount;
@override@JsonKey(name: 'last_updated') final  DateTime? lastUpdated;

/// Create a copy of ClusteredBus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClusteredBusCopyWith<_ClusteredBus> get copyWith => __$ClusteredBusCopyWithImpl<_ClusteredBus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClusteredBus&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.avgHeading, avgHeading) || other.avgHeading == avgHeading)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.trackerCount, trackerCount) || other.trackerCount == trackerCount)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}


@override
int get hashCode => Object.hash(runtimeType,id,routeId,latitude,longitude,avgHeading,avgSpeed,trackerCount,lastUpdated);

@override
String toString() {
  return 'ClusteredBus(id: $id, routeId: $routeId, latitude: $latitude, longitude: $longitude, avgHeading: $avgHeading, avgSpeed: $avgSpeed, trackerCount: $trackerCount, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$ClusteredBusCopyWith<$Res> implements $ClusteredBusCopyWith<$Res> {
  factory _$ClusteredBusCopyWith(_ClusteredBus value, $Res Function(_ClusteredBus) _then) = __$ClusteredBusCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'route_id') String routeId, double latitude, double longitude,@JsonKey(name: 'avg_heading') double? avgHeading,@JsonKey(name: 'avg_speed') double? avgSpeed,@JsonKey(name: 'tracker_count') int trackerCount,@JsonKey(name: 'last_updated') DateTime? lastUpdated
});




}
/// @nodoc
class __$ClusteredBusCopyWithImpl<$Res>
    implements _$ClusteredBusCopyWith<$Res> {
  __$ClusteredBusCopyWithImpl(this._self, this._then);

  final _ClusteredBus _self;
  final $Res Function(_ClusteredBus) _then;

/// Create a copy of ClusteredBus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routeId = null,Object? latitude = null,Object? longitude = null,Object? avgHeading = freezed,Object? avgSpeed = freezed,Object? trackerCount = null,Object? lastUpdated = freezed,}) {
  return _then(_ClusteredBus(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,avgHeading: freezed == avgHeading ? _self.avgHeading : avgHeading // ignore: cast_nullable_to_non_nullable
as double?,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,trackerCount: null == trackerCount ? _self.trackerCount : trackerCount // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$BusSession {

 String get id;@JsonKey(name: 'route_id') String get routeId;@JsonKey(name: 'broadcaster_id') String? get broadcasterId; double get latitude; double get longitude; double? get heading; double? get speed;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of BusSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusSessionCopyWith<BusSession> get copyWith => _$BusSessionCopyWithImpl<BusSession>(this as BusSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusSession&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.broadcasterId, broadcasterId) || other.broadcasterId == broadcasterId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,routeId,broadcasterId,latitude,longitude,heading,speed,updatedAt);

@override
String toString() {
  return 'BusSession(id: $id, routeId: $routeId, broadcasterId: $broadcasterId, latitude: $latitude, longitude: $longitude, heading: $heading, speed: $speed, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BusSessionCopyWith<$Res>  {
  factory $BusSessionCopyWith(BusSession value, $Res Function(BusSession) _then) = _$BusSessionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'route_id') String routeId,@JsonKey(name: 'broadcaster_id') String? broadcasterId, double latitude, double longitude, double? heading, double? speed,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$BusSessionCopyWithImpl<$Res>
    implements $BusSessionCopyWith<$Res> {
  _$BusSessionCopyWithImpl(this._self, this._then);

  final BusSession _self;
  final $Res Function(BusSession) _then;

/// Create a copy of BusSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routeId = null,Object? broadcasterId = freezed,Object? latitude = null,Object? longitude = null,Object? heading = freezed,Object? speed = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,broadcasterId: freezed == broadcasterId ? _self.broadcasterId : broadcasterId // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusSession].
extension BusSessionPatterns on BusSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusSession value)  $default,){
final _that = this;
switch (_that) {
case _BusSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusSession value)?  $default,){
final _that = this;
switch (_that) {
case _BusSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'route_id')  String routeId, @JsonKey(name: 'broadcaster_id')  String? broadcasterId,  double latitude,  double longitude,  double? heading,  double? speed, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusSession() when $default != null:
return $default(_that.id,_that.routeId,_that.broadcasterId,_that.latitude,_that.longitude,_that.heading,_that.speed,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'route_id')  String routeId, @JsonKey(name: 'broadcaster_id')  String? broadcasterId,  double latitude,  double longitude,  double? heading,  double? speed, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BusSession():
return $default(_that.id,_that.routeId,_that.broadcasterId,_that.latitude,_that.longitude,_that.heading,_that.speed,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'route_id')  String routeId, @JsonKey(name: 'broadcaster_id')  String? broadcasterId,  double latitude,  double longitude,  double? heading,  double? speed, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BusSession() when $default != null:
return $default(_that.id,_that.routeId,_that.broadcasterId,_that.latitude,_that.longitude,_that.heading,_that.speed,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BusSession extends BusSession {
  const _BusSession({required this.id, @JsonKey(name: 'route_id') required this.routeId, @JsonKey(name: 'broadcaster_id') this.broadcasterId, required this.latitude, required this.longitude, this.heading, this.speed, @JsonKey(name: 'updated_at') this.updatedAt}): super._();
  

@override final  String id;
@override@JsonKey(name: 'route_id') final  String routeId;
@override@JsonKey(name: 'broadcaster_id') final  String? broadcasterId;
@override final  double latitude;
@override final  double longitude;
@override final  double? heading;
@override final  double? speed;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of BusSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusSessionCopyWith<_BusSession> get copyWith => __$BusSessionCopyWithImpl<_BusSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusSession&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.broadcasterId, broadcasterId) || other.broadcasterId == broadcasterId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,routeId,broadcasterId,latitude,longitude,heading,speed,updatedAt);

@override
String toString() {
  return 'BusSession(id: $id, routeId: $routeId, broadcasterId: $broadcasterId, latitude: $latitude, longitude: $longitude, heading: $heading, speed: $speed, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BusSessionCopyWith<$Res> implements $BusSessionCopyWith<$Res> {
  factory _$BusSessionCopyWith(_BusSession value, $Res Function(_BusSession) _then) = __$BusSessionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'route_id') String routeId,@JsonKey(name: 'broadcaster_id') String? broadcasterId, double latitude, double longitude, double? heading, double? speed,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$BusSessionCopyWithImpl<$Res>
    implements _$BusSessionCopyWith<$Res> {
  __$BusSessionCopyWithImpl(this._self, this._then);

  final _BusSession _self;
  final $Res Function(_BusSession) _then;

/// Create a copy of BusSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routeId = null,Object? broadcasterId = freezed,Object? latitude = null,Object? longitude = null,Object? heading = freezed,Object? speed = freezed,Object? updatedAt = freezed,}) {
  return _then(_BusSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,broadcasterId: freezed == broadcasterId ? _self.broadcasterId : broadcasterId // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
