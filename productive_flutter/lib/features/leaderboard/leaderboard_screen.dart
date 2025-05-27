import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:productive_flutter/utils/extensions/navigation_extension.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTimeFilter = 0;
  final List<String> _timeFilters = ['Weekly', 'Monthly', 'All Time'];
  late AnimationController _tabAnimationController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for tab transitions
    _tabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize page controller for swipeable tabs
    _pageController = PageController(initialPage: _selectedTimeFilter);
  }

  @override
  void dispose() {
    _tabAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _animateToTimeFilter(int index) {
    if (_selectedTimeFilter == index) return;

    // Start animation based on direction
    if (index > _selectedTimeFilter) {
      _tabAnimationController.forward(from: 0.0);
    } else {
      _tabAnimationController.reverse(from: 1.0);
    }

    setState(() {
      _selectedTimeFilter = index;
    });

    // Animate to the selected page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTimeFilter(),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (index) {
                  // Don't call _animateToTimeFilter here to avoid infinite loop
                  // Instead, just update the state and animations directly
                  if (_selectedTimeFilter == index) return;

                  // Start animation based on direction
                  if (index > _selectedTimeFilter) {
                    _tabAnimationController.forward(from: 0.0);
                  } else {
                    _tabAnimationController.reverse(from: 1.0);
                  }

                  setState(() {
                    _selectedTimeFilter = index;
                  });
                },
                children: List.generate(_timeFilters.length, (pageIndex) {
                  return Column(
                    children: [
                      _buildTopThree(timeFilter: pageIndex),
                      Expanded(
                        child: _buildLeaderboardList(timeFilter: pageIndex),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(32),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / _timeFilters.length;

        return Stack(
          children: [
            // This is the sliding indicator
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: _selectedTimeFilter * tabWidth,
              top: 0,
              bottom: 0,
              width: tabWidth,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            // Row of text labels
            Row(
              children: List.generate(_timeFilters.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _animateToTimeFilter(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        _timeFilters[index],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _selectedTimeFilter == index
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTopThree({Key? key, required int timeFilter}) {
    // Different top three users based on the selected time filter
    List<Map<String, dynamic>> topUsers;

    switch (timeFilter) {
      case 0: // Weekly
        topUsers = [
          {'rank': 1, 'image': 'https://picsum.photos/seed/user1/200'},
          {'rank': 2, 'image': 'https://picsum.photos/seed/user2/200'},
          {'rank': 3, 'image': 'https://picsum.photos/seed/user3/200'},
        ];
        break;
      case 1: // Monthly
        topUsers = [
          {'rank': 1, 'image': 'https://picsum.photos/seed/user4/200'},
          {'rank': 2, 'image': 'https://picsum.photos/seed/user5/200'},
          {'rank': 3, 'image': 'https://picsum.photos/seed/user6/200'},
        ];
        break;
      case 2: // All Time
        topUsers = [
          {'rank': 1, 'image': 'https://picsum.photos/seed/user7/200'},
          {'rank': 2, 'image': 'https://picsum.photos/seed/user8/200'},
          {'rank': 3, 'image': 'https://picsum.photos/seed/user9/200'},
        ];
        break;
      default:
        topUsers = [
          {'rank': 1, 'image': 'https://picsum.photos/seed/user1/200'},
          {'rank': 2, 'image': 'https://picsum.photos/seed/user2/200'},
          {'rank': 3, 'image': 'https://picsum.photos/seed/user3/200'},
        ];
    }

    return SizedBox(
      key: key ?? ValueKey<String>('top_three_$timeFilter'),
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 40,
            bottom: 20,
            child: _buildTopUser(
              image: topUsers[2]['image'] as String,
              rank: 3,
              borderColor: Theme.of(context).colorScheme.tertiary,
              size: 80,
            ),
          ),
          Positioned(
            bottom: 40,
            child: _buildTopUser(
              image: topUsers[0]['image'] as String,
              rank: 1,
              borderColor: Colors.amber,
              size: 120,
              showCrown: true,
            ),
          ),
          Positioned(
            right: 40,
            bottom: 20,
            child: _buildTopUser(
              image: topUsers[1]['image'] as String,
              rank: 2,
              borderColor: Theme.of(context).colorScheme.secondary,
              size: 80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUser({
    required String image,
    required int rank,
    required Color borderColor,
    required double size,
    bool showCrown = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: size * 0.9,
              height: size * 0.9,
              margin: showCrown
                  ? const EdgeInsets.only(top: 40, bottom: 20)
                  : const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 4,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  memCacheHeight: 200,
                  memCacheWidth: 200,
                  maxHeightDiskCache: 200,
                  maxWidthDiskCache: 200,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: borderColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rank.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            if (showCrown)
              Positioned(
                top: 0,
                child: Lottie.asset(
                  'assets/lottie/crown.json',
                  height: 60,
                  width: 60,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboardList({Key? key, required int timeFilter}) {
    // Different mock data for each tab to demonstrate the animation
    List<Map<String, dynamic>> leaderboardData = [];

    switch (timeFilter) {
      case 0: // Weekly
        leaderboardData = [
          {
            'name': 'John Doe',
            'points': 402,
            'image': 'https://picsum.photos/seed/johndoe/100'
          },
          {
            'name': 'Sara Davis',
            'points': 400,
            'image': 'https://picsum.photos/seed/saradavis/100'
          },
          {
            'name': 'Leonardo Dicaprio',
            'points': 390,
            'image': 'https://picsum.photos/seed/leonardo/100'
          },
          {
            'name': 'Evana Lee',
            'points': 385,
            'image': 'https://picsum.photos/seed/evana/100'
          },
          {
            'name': 'Paul Walker',
            'points': 380,
            'image': 'https://picsum.photos/seed/paulwalker/100'
          },
          {
            'name': 'Hrithik Roshan',
            'points': 379,
            'image': 'https://picsum.photos/seed/hrithik/100'
          },
        ];
        break;
      case 1: // Monthly
        leaderboardData = [
          {
            'name': 'Sara Davis',
            'points': 1250,
            'image': 'https://picsum.photos/seed/saradavis/100'
          },
          {
            'name': 'John Doe',
            'points': 1102,
            'image': 'https://picsum.photos/seed/johndoe/100'
          },
          {
            'name': 'Evana Lee',
            'points': 985,
            'image': 'https://picsum.photos/seed/evana/100'
          },
          {
            'name': 'Leonardo Dicaprio',
            'points': 890,
            'image': 'https://picsum.photos/seed/leonardo/100'
          },
          {
            'name': 'Hrithik Roshan',
            'points': 879,
            'image': 'https://picsum.photos/seed/hrithik/100'
          },
          {
            'name': 'Paul Walker',
            'points': 780,
            'image': 'https://picsum.photos/seed/paulwalker/100'
          },
        ];
        break;
      case 2: // All Time
        leaderboardData = [
          {
            'name': 'Leonardo Dicaprio',
            'points': 4390,
            'image': 'https://picsum.photos/seed/leonardo/100'
          },
          {
            'name': 'Sara Davis',
            'points': 3780,
            'image': 'https://picsum.photos/seed/saradavis/100'
          },
          {
            'name': 'John Doe',
            'points': 3402,
            'image': 'https://picsum.photos/seed/johndoe/100'
          },
          {
            'name': 'Paul Walker',
            'points': 2980,
            'image': 'https://picsum.photos/seed/paulwalker/100'
          },
          {
            'name': 'Evana Lee',
            'points': 2785,
            'image': 'https://picsum.photos/seed/evana/100'
          },
          {
            'name': 'Hrithik Roshan',
            'points': 2379,
            'image': 'https://picsum.photos/seed/hrithik/100'
          },
        ];
        break;
      default:
        leaderboardData = [
          {
            'name': 'John Doe',
            'points': 402,
            'image': 'https://picsum.photos/seed/johndoe/100'
          },
          {
            'name': 'Sara Davis',
            'points': 400,
            'image': 'https://picsum.photos/seed/saradavis/100'
          },
          {
            'name': 'Leonardo Dicaprio',
            'points': 390,
            'image': 'https://picsum.photos/seed/leonardo/100'
          },
          {
            'name': 'Evana Lee',
            'points': 385,
            'image': 'https://picsum.photos/seed/evana/100'
          },
          {
            'name': 'Paul Walker',
            'points': 380,
            'image': 'https://picsum.photos/seed/paulwalker/100'
          },
          {
            'name': 'Hrithik Roshan',
            'points': 379,
            'image': 'https://picsum.photos/seed/hrithik/100'
          },
        ];
    }

    return ListView.separated(
      key: key ?? ValueKey<String>('leaderboard_list_$timeFilter'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: leaderboardData.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 0.1,
        color: Theme.of(context).dividerColor,
      ),
      itemBuilder: (context, index) {
        final data = leaderboardData[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: data['image'] as String,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                memCacheHeight: 100,
                memCacheWidth: 100,
                maxHeightDiskCache: 100,
                maxWidthDiskCache: 100,
              ),
            ),
          ),
          title: Text(
            data['name'] as String,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data['points'].toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.emoji_events,
                color: Colors.amber[600],
              ),
            ],
          ),
        );
      },
    );
  }
}
