import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/design_system.dart';
import '../../../core/widgets/bouncy_button.dart';

/// Persistent banner showing current tracking status
/// Redesigned with Antigravity Design System
class TrackingBanner extends ConsumerWidget {
  const TrackingBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingState = ref.watch(trackingStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedSwitcher(
      duration: DesignSystem.animMedium,
      switchInCurve: DesignSystem.animCurveDefault,
      switchOutCurve: DesignSystem.animCurveDefault,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: trackingState.isTracking
          ? _TrackingBannerContent(
              key: const ValueKey('tracking'),
              routeName: trackingState.routeName ?? 'Unknown Route',
              isDark: isDark,
              onStop: () {
                ref.read(trackingStateProvider.notifier).stopTracking();
              },
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}

class _TrackingBannerContent extends StatelessWidget {
  final String routeName;
  final bool isDark;
  final VoidCallback onStop;

  const _TrackingBannerContent({
    super.key,
    required this.routeName,
    required this.isDark,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.spacingS,
        bottom: DesignSystem.spacingS,
        left: DesignSystem.spacingM,
        right: DesignSystem.spacingS,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? DesignSystem.actionColor.withValues(alpha: 0.2)
            : DesignSystem.actionColor.withValues(alpha: 0.1),
        boxShadow: DesignSystem.shadowLight,
      ),
      child: Row(
        children: [
          // Enhanced pulsing indicator
          const _PulsingIndicator(),
          const SizedBox(width: DesignSystem.spacingS),
          
          // Route info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tracking Active',
                  style: DesignSystem.labelL.copyWith(
                    color: DesignSystem.actionColor,
                  ),
                ),
                Text(
                  routeName,
                  style: DesignSystem.bodyM.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          
          // Stop button
          BouncyButton(
            onTap: onStop,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingS,
                vertical: DesignSystem.spacingXS,
              ),
              decoration: BoxDecoration(
                color: DesignSystem.errorColor.withValues(alpha: 0.1),
                borderRadius: DesignSystem.borderRadiusS,
                border: Border.all(
                  color: DesignSystem.errorColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stop_circle_outlined,
                    size: 18,
                    color: DesignSystem.errorColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Stop',
                    style: DesignSystem.labelM.copyWith(
                      color: DesignSystem.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced pulsing indicator with scale + opacity animation
class _PulsingIndicator extends StatefulWidget {
  const _PulsingIndicator();

  @override
  State<_PulsingIndicator> createState() => _PulsingIndicatorState();
}

class _PulsingIndicatorState extends State<_PulsingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value * 0.3,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: DesignSystem.actionColor,
                  ),
                ),
              ),
            ),
            // Inner solid dot
            Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DesignSystem.actionColor,
                  boxShadow: [
                    BoxShadow(
                      color: DesignSystem.actionColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

