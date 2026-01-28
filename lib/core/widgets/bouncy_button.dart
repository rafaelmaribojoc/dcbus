import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// Tactile button with ScaleTransition shrink-on-tap
/// Following Pillar I: Viscerality - "Interactive elements must acknowledge the user"
class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleAmount;
  final Duration duration;
  final HitTestBehavior behavior;

  const BouncyButton({
    super.key,
    required this.child,
    this.onTap,
    this.scaleAmount = 0.95,
    this.duration = DesignSystem.animFast,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Bouncy FAB wrapper with scale animation
class BouncyFab extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const BouncyFab({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onPressed,
      scaleAmount: 0.92,
      child: child,
    );
  }
}

/// Animated chip with scale feedback
class BouncyChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback? onTap;

  const BouncyChip({
    super.key,
    required this.label,
    this.selected = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? DesignSystem.actionColor;

    return BouncyButton(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignSystem.animFast,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingS,
          vertical: DesignSystem.spacingXS,
        ),
        decoration: BoxDecoration(
          color: selected
              ? effectiveColor.withValues(alpha: 0.2)
              : (isDark
                  ? DesignSystem.darkSurfaceVariant
                  : DesignSystem.lightSurfaceVariant),
          borderRadius: DesignSystem.borderRadiusS,
          border: Border.all(
            color: selected
                ? effectiveColor.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? effectiveColor
                : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}
