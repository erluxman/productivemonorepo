import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/core/theme/app_theme.dart';

import '../../core/providers/points_provider.dart';
import 'pages/feed_page.dart';
import 'pages/inbox_page.dart';
import 'widgets/add_todo_button.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/top_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _fabAnimationController;
  late AnimationController _titleAnimationController;
  double _titleProgress = 0.0;
  late Animation<double> _notchAnimation;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: AppTheme.fabAnimationDuration,
      value: 1.0,
    );

    _notchAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50.0,
      ),
    ]).animate(_fabAnimationController);

    _titleAnimationController = AnimationController(
      vsync: this,
      duration: AppTheme.titleAnimationDuration,
    );

    _titleAnimationController.addListener(() {
      setState(() {
        _titleProgress = _titleAnimationController.value;
      });
    });

    _fabAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    _titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(pointsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              points: points,
              titleProgress: _titleProgress,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _handlePageChanged,
                children: const [
                  FeedPage(),
                  InboxPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? null
          : AddTodoButton(
              fabAnimationController: _fabAnimationController,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        notchAnimation: _notchAnimation,
        fabAnimationController: _fabAnimationController,
        onTabSelected: _animateToTab,
      ),
    );
  }

  void _handlePageChanged(int index) {
    setState(() => _selectedIndex = index);
    _animateTitle(index);
  }

  void _animateTitle(int index) {
    _titleAnimationController.animateTo(
      index == 0 ? 0.0 : 1.0,
      curve: Curves.easeInOutCubic,
      duration: AppTheme.titleAnimationDuration,
    );
  }

  void _animateToTab(int index) {
    if (_selectedIndex == index) return;
    _pageController.animateToPage(
      index,
      duration: AppTheme.fabAnimationDuration,
      curve: Curves.easeInOutCubic,
    );
  }
}

// Custom animated notch shape that smoothly transitions between states
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
      // When FAB is fully hidden, return a path without a notch
      return this.host.getOuterPath(host);
    }

    // Calculate the notch size based on animation value
    final notchProgress = animation.value;

    // Create a standard notched shape
    final standardNotchedShape = AutomaticNotchedShape(this.host, this.guest);
    final notchedPath = standardNotchedShape.getOuterPath(host, guest);

    if (animation.value >= 1.0) {
      // When FAB is fully visible, use standard notched path
      return notchedPath;
    }

    // Calculate a more gradual transition for healing the notch on appearance
    // Using a custom easing formula that makes healing slower
    double adjustedProgress = notchProgress;

    // Apply additional easing for notch healing when FAB is returning (appearing)
    // This slows down the first half of the healing animation
    if (notchProgress > 0.5) {
      // Apply stronger easing to the 0.5-1.0 range to make it even slower
      final t = (notchProgress - 0.5) * 2.0; // normalize to 0.0-1.0
      final easedT = Curves.easeInOutCubic.transform(t) *
          0.5; // slower easing, limit to 0.0-0.5
      adjustedProgress = 0.5 + easedT; // remap to 0.5-1.0 range
    }

    // During transition, adjust the guest rect to create a "healing" effect
    final adjustedGuest = Rect.fromCenter(
      center: guest.center,
      width: guest.width * adjustedProgress,
      height: guest.height * adjustedProgress,
    );

    // Create a transitional notched shape
    final transitionalShape = AutomaticNotchedShape(this.host, this.guest);
    return transitionalShape.getOuterPath(host, adjustedGuest);
  }
}
