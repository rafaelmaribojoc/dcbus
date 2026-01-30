import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/design_system.dart';

/// Premium Floating Navigation Bar
/// Replaces standard BottomNavigationBar with an expandable glass menu
class FloatingNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNav> createState() => _FloatingNavState();
}

class _FloatingNavState extends State<FloatingNav> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), // Slower, smoother expansion
        vsync: this
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Bouncy/Elastic effect
      reverseCurve: Curves.easeInBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onItemTapped(int index) {
    widget.onTap(index);
    // Optional: Close menu on selection? 
    // Usually nav bars stay accessible. 
    // But since this is a "toggle to show", maybe we keep it plain.
    // Let's keep it user-controlled or auto-close if strictly requested.
    // For now, let's just switch tabs.
    // User requested: "when you press the icon button, it will show all... button"
    
    // If we want to mimic a true dock, we might want it always visible? 
    // No, user specifically said "press... it will show".
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expanded Menu
          SizeTransition(
            sizeFactor: _expandAnimation,
            axis: Axis.horizontal,
            child: FadeTransition(
              opacity: _expandAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? DesignSystem.darkSurface.withValues(alpha: 0.8)
                          : DesignSystem.lightSurface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: isDark ? DesignSystem.shadowDark : DesignSystem.shadowMedium,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavItem(
                          icon: Icons.dashboard_rounded,
                          label: 'Home',
                          isSelected: widget.currentIndex == 0,
                          onTap: () => _onItemTapped(0),
                        ),
                        const SizedBox(width: 8),
                        _NavItem(
                          icon: Icons.map_rounded,
                          label: 'Map',
                          isSelected: widget.currentIndex == 1,
                          onTap: () => _onItemTapped(1),
                        ),
                        const SizedBox(width: 8),
                        _NavItem(
                          icon: Icons.alt_route_rounded,
                          label: 'Routes',
                          isSelected: widget.currentIndex == 2,
                          onTap: () => _onItemTapped(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Toggle Button
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: DesignSystem.actionGradient,
                boxShadow: DesignSystem.glowShadow(DesignSystem.actionColor),
              ),
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.125).animate(_controller), // 45deg rotation
                child: Icon(
                  _isOpen ? Icons.close : Icons.grid_view_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignSystem.animFast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? DesignSystem.actionColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? DesignSystem.actionColor 
                  : (isDark ? Colors.white70 : Colors.black54),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: DesignSystem.labelM.copyWith(
                  color: DesignSystem.actionColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
