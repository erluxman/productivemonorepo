import 'package:flutter/material.dart';
import 'package:productive_flutter/core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Animation<double> notchAnimation;
  final AnimationController fabAnimationController;
  final Function(int) onTabSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.notchAnimation,
    required this.fabAnimationController,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final shape = _createBottomAppBarShape();
    final visualAnimValue = _calculateVisualAnimationValue();

    return BottomAppBar(
      notchMargin: AppTheme.bottomNavBarNotchMargin,
      elevation: 8 + (visualAnimValue * 4),
      padding: EdgeInsets.zero,
      height: AppTheme.bottomNavBarHeight,
      shape: shape,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.dynamic_feed_rounded,
              label: 'Feed',
              isSelected: selectedIndex == 0,
              onTap: () => onTabSelected(0),
            ),
            SizedBox(width: 40 + (visualAnimValue * 12)),
            _buildNavItem(
              context: context,
              icon: Icons.inbox_rounded,
              label: 'Inbox',
              isSelected: selectedIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateVisualAnimationValue() {
    double visualAnimValue = notchAnimation.value;
    if (fabAnimationController.status == AnimationStatus.forward) {
      visualAnimValue = Curves.easeInOutCubic.transform(notchAnimation.value);
    }
    return visualAnimValue;
  }

  NotchedShape _createBottomAppBarShape() {
    return AnimatedNotchBottomAppBarShape(
      animation: notchAnimation,
      host: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.bottomNavBarBorderRadius),
        ),
      ),
      guest: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.fabBorderRadius),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Colors.grey[400];
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Padding(
            padding: AppTheme.navItemPadding,
            child: AnimatedContainer(
              duration: AppTheme.navItemAnimationDuration,
              curve: Curves.easeIn,
              width: isSelected ? 52.0 : 46.0,
              height: isSelected ? AppTheme.bottomNavBarHeight : 50.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  Center(
                    child: Icon(
                      icon,
                      size: isSelected
                          ? AppTheme.iconSizeMedium
                          : AppTheme.iconSizeSmall,
                      color: isSelected ? primaryColor : unselectedColor,
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: AppTheme.navItemAnimationDuration,
                    style: textTheme.labelSmall!.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? primaryColor : Colors.grey[600],
                      fontSize: 12,
                      fontFamily: textTheme.bodyMedium?.fontFamily,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedNotchBottomAppBarShape extends NotchedShape {
  final Animation<double> animation;
  final ShapeBorder host;
  final ShapeBorder guest;

  const AnimatedNotchBottomAppBarShape({
    required this.animation,
    required this.host,
    required this.guest,
  });

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || animation.value <= 0.0) {
      return this.host.getOuterPath(host);
    }

    final notchProgress = animation.value;
    final standardNotchedShape = AutomaticNotchedShape(this.host, this.guest);
    final notchedPath = standardNotchedShape.getOuterPath(host, guest);

    if (animation.value >= 1.0) {
      return notchedPath;
    }

    double adjustedProgress = notchProgress;

    if (notchProgress > 0.5) {
      final t = (notchProgress - 0.5) * 2.0;
      final easedT = Curves.easeInOutCubic.transform(t) * 0.5;
      adjustedProgress = 0.5 + easedT;
    }

    final adjustedGuest = Rect.fromCenter(
      center: guest.center,
      width: guest.width * adjustedProgress,
      height: guest.height * adjustedProgress,
    );

    return standardNotchedShape.getOuterPath(host, adjustedGuest);
  }
}
