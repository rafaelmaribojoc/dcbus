import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/route.dart';

/// State for navigating to a specific stop on the map
class StopNavigationState {
  final RoutePoint? targetStop;
  final BusRoute? route;

  const StopNavigationState({this.targetStop, this.route});

  StopNavigationState copyWith({RoutePoint? targetStop, BusRoute? route}) {
    return StopNavigationState(
      targetStop: targetStop ?? this.targetStop,
      route: route ?? this.route,
    );
  }

  /// Clear the navigation target
  static const StopNavigationState empty = StopNavigationState();
}

/// Provider for stop navigation state
class StopNavigationNotifier extends Notifier<StopNavigationState> {
  @override
  StopNavigationState build() => const StopNavigationState();

  /// Navigate to a specific stop
  void navigateToStop(RoutePoint stop, BusRoute route) {
    state = StopNavigationState(targetStop: stop, route: route);
  }

  /// Clear target after navigation is handled
  void clearTarget() {
    state = const StopNavigationState();
  }
}

final stopNavigationProvider =
    NotifierProvider<StopNavigationNotifier, StopNavigationState>(
  StopNavigationNotifier.new,
);
