// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusRoute {

 String get id;@JsonKey(name: 'route_number') String get routeNumber; String get name; String get area;@JsonKey(name: 'time_period') String get timePeriod; String get color;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime; List<RoutePoint> get points;
/// Create a copy of BusRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusRouteCopyWith<BusRoute> get copyWith => _$BusRouteCopyWithImpl<BusRoute>(this as BusRoute, _$identity);

  /// Serializes this BusRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.routeNumber, routeNumber) || other.routeNumber == routeNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.timePeriod, timePeriod) || other.timePeriod == timePeriod)&&(identical(other.color, color) || other.color == color)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other.points, points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routeNumber,name,area,timePeriod,color,startTime,endTime,const DeepCollectionEquality().hash(points));

@override
String toString() {
  return 'BusRoute(id: $id, routeNumber: $routeNumber, name: $name, area: $area, timePeriod: $timePeriod, color: $color, startTime: $startTime, endTime: $endTime, points: $points)';
}


}

/// @nodoc
abstract mixin class $BusRouteCopyWith<$Res>  {
  factory $BusRouteCopyWith(BusRoute value, $Res Function(BusRoute) _then) = _$BusRouteCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'route_number') String routeNumber, String name, String area,@JsonKey(name: 'time_period') String timePeriod, String color,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime, List<RoutePoint> points
});




}
/// @nodoc
class _$BusRouteCopyWithImpl<$Res>
    implements $BusRouteCopyWith<$Res> {
  _$BusRouteCopyWithImpl(this._self, this._then);

  final BusRoute _self;
  final $Res Function(BusRoute) _then;

/// Create a copy of BusRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routeNumber = null,Object? name = null,Object? area = null,Object? timePeriod = null,Object? color = null,Object? startTime = null,Object? endTime = null,Object? points = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeNumber: null == routeNumber ? _self.routeNumber : routeNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,timePeriod: null == timePeriod ? _self.timePeriod : timePeriod // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<RoutePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [BusRoute].
extension BusRoutePatterns on BusRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusRoute value)  $default,){
final _that = this;
switch (_that) {
case _BusRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusRoute value)?  $default,){
final _that = this;
switch (_that) {
case _BusRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'route_number')  String routeNumber,  String name,  String area, @JsonKey(name: 'time_period')  String timePeriod,  String color, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime,  List<RoutePoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusRoute() when $default != null:
return $default(_that.id,_that.routeNumber,_that.name,_that.area,_that.timePeriod,_that.color,_that.startTime,_that.endTime,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'route_number')  String routeNumber,  String name,  String area, @JsonKey(name: 'time_period')  String timePeriod,  String color, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime,  List<RoutePoint> points)  $default,) {final _that = this;
switch (_that) {
case _BusRoute():
return $default(_that.id,_that.routeNumber,_that.name,_that.area,_that.timePeriod,_that.color,_that.startTime,_that.endTime,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'route_number')  String routeNumber,  String name,  String area, @JsonKey(name: 'time_period')  String timePeriod,  String color, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime,  List<RoutePoint> points)?  $default,) {final _that = this;
switch (_that) {
case _BusRoute() when $default != null:
return $default(_that.id,_that.routeNumber,_that.name,_that.area,_that.timePeriod,_that.color,_that.startTime,_that.endTime,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusRoute extends BusRoute {
  const _BusRoute({required this.id, @JsonKey(name: 'route_number') required this.routeNumber, required this.name, required this.area, @JsonKey(name: 'time_period') required this.timePeriod, required this.color, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') required this.endTime, required final  List<RoutePoint> points}): _points = points,super._();
  factory _BusRoute.fromJson(Map<String, dynamic> json) => _$BusRouteFromJson(json);

@override final  String id;
@override@JsonKey(name: 'route_number') final  String routeNumber;
@override final  String name;
@override final  String area;
@override@JsonKey(name: 'time_period') final  String timePeriod;
@override final  String color;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
 final  List<RoutePoint> _points;
@override List<RoutePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of BusRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusRouteCopyWith<_BusRoute> get copyWith => __$BusRouteCopyWithImpl<_BusRoute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusRouteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.routeNumber, routeNumber) || other.routeNumber == routeNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area)&&(identical(other.timePeriod, timePeriod) || other.timePeriod == timePeriod)&&(identical(other.color, color) || other.color == color)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other._points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routeNumber,name,area,timePeriod,color,startTime,endTime,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'BusRoute(id: $id, routeNumber: $routeNumber, name: $name, area: $area, timePeriod: $timePeriod, color: $color, startTime: $startTime, endTime: $endTime, points: $points)';
}


}

/// @nodoc
abstract mixin class _$BusRouteCopyWith<$Res> implements $BusRouteCopyWith<$Res> {
  factory _$BusRouteCopyWith(_BusRoute value, $Res Function(_BusRoute) _then) = __$BusRouteCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'route_number') String routeNumber, String name, String area,@JsonKey(name: 'time_period') String timePeriod, String color,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime, List<RoutePoint> points
});




}
/// @nodoc
class __$BusRouteCopyWithImpl<$Res>
    implements _$BusRouteCopyWith<$Res> {
  __$BusRouteCopyWithImpl(this._self, this._then);

  final _BusRoute _self;
  final $Res Function(_BusRoute) _then;

/// Create a copy of BusRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routeNumber = null,Object? name = null,Object? area = null,Object? timePeriod = null,Object? color = null,Object? startTime = null,Object? endTime = null,Object? points = null,}) {
  return _then(_BusRoute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeNumber: null == routeNumber ? _self.routeNumber : routeNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,timePeriod: null == timePeriod ? _self.timePeriod : timePeriod // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<RoutePoint>,
  ));
}


}


/// @nodoc
mixin _$RoutePoint {

 String get id; String get name; double get latitude; double get longitude; String get kind; double? get heading;
/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutePointCopyWith<RoutePoint> get copyWith => _$RoutePointCopyWithImpl<RoutePoint>(this as RoutePoint, _$identity);

  /// Serializes this RoutePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutePoint&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.heading, heading) || other.heading == heading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,kind,heading);

@override
String toString() {
  return 'RoutePoint(id: $id, name: $name, latitude: $latitude, longitude: $longitude, kind: $kind, heading: $heading)';
}


}

/// @nodoc
abstract mixin class $RoutePointCopyWith<$Res>  {
  factory $RoutePointCopyWith(RoutePoint value, $Res Function(RoutePoint) _then) = _$RoutePointCopyWithImpl;
@useResult
$Res call({
 String id, String name, double latitude, double longitude, String kind, double? heading
});




}
/// @nodoc
class _$RoutePointCopyWithImpl<$Res>
    implements $RoutePointCopyWith<$Res> {
  _$RoutePointCopyWithImpl(this._self, this._then);

  final RoutePoint _self;
  final $Res Function(RoutePoint) _then;

/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? kind = null,Object? heading = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutePoint].
extension RoutePointPatterns on RoutePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutePoint value)  $default,){
final _that = this;
switch (_that) {
case _RoutePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutePoint value)?  $default,){
final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  String kind,  double? heading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.kind,_that.heading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  String kind,  double? heading)  $default,) {final _that = this;
switch (_that) {
case _RoutePoint():
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.kind,_that.heading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double latitude,  double longitude,  String kind,  double? heading)?  $default,) {final _that = this;
switch (_that) {
case _RoutePoint() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.kind,_that.heading);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutePoint extends RoutePoint {
  const _RoutePoint({required this.id, required this.name, required this.latitude, required this.longitude, this.kind = 'stop', this.heading}): super._();
  factory _RoutePoint.fromJson(Map<String, dynamic> json) => _$RoutePointFromJson(json);

@override final  String id;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey() final  String kind;
@override final  double? heading;

/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutePointCopyWith<_RoutePoint> get copyWith => __$RoutePointCopyWithImpl<_RoutePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutePointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutePoint&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.heading, heading) || other.heading == heading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,kind,heading);

@override
String toString() {
  return 'RoutePoint(id: $id, name: $name, latitude: $latitude, longitude: $longitude, kind: $kind, heading: $heading)';
}


}

/// @nodoc
abstract mixin class _$RoutePointCopyWith<$Res> implements $RoutePointCopyWith<$Res> {
  factory _$RoutePointCopyWith(_RoutePoint value, $Res Function(_RoutePoint) _then) = __$RoutePointCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double latitude, double longitude, String kind, double? heading
});




}
/// @nodoc
class __$RoutePointCopyWithImpl<$Res>
    implements _$RoutePointCopyWith<$Res> {
  __$RoutePointCopyWithImpl(this._self, this._then);

  final _RoutePoint _self;
  final $Res Function(_RoutePoint) _then;

/// Create a copy of RoutePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? kind = null,Object? heading = freezed,}) {
  return _then(_RoutePoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
