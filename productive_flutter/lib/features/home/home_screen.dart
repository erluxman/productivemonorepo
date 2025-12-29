import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/core/theme/app_theme.dart';

import '../../core/user/providers/points_provider.dart';
import 'feeds/feed_page.dart';
import 'inbox/inbox_page.dart';
import 'inbox/widgets/add_todo_button.dart';
import 'inbox/widgets/bottom_nav_bar.dart';
import 'inbox/widgets/top_bar.dart';

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
