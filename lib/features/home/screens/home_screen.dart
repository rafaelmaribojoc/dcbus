import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/stop_navigation_provider.dart';
import '../../../core/theme/design_system.dart';
import '../../../data/repositories/route_repository.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../map/screens/map_screen.dart';
import '../../routes/screens/routes_screen.dart';
import '../../tracking/widgets/tracking_banner.dart';

/// Home screen with premium bottom navigation and animated transitions
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = const [
    DashboardScreen(),
    MapScreen(),
    RoutesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-load routes
    ref.read(routeRepositoryProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for stop navigation requests
    ref.listen<StopNavigationState>(stopNavigationProvider, (previous, next) {
      if (next.targetStop != null && _currentIndex != 1) {
        // Switch to map tab when a stop is selected
        setState(() => _currentIndex = 1);
      }
    });

    return Scaffold(
      body: Column(
        children: [
          // Tracking status banner with slide animation
          const TrackingBanner(),
          
          // Main content with AnimatedSwitcher for visceral transitions
          Expanded(
            child: AnimatedSwitcher(
              duration: DesignSystem.animMedium,
              switchInCurve: DesignSystem.animCurveDefault,
              switchOutCurve: DesignSystem.animCurveDefault,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ],
      ),
      // Premium NavigationBar with custom styling
      // Premium Floating Navigation
      floatingActionButton: FloatingNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
