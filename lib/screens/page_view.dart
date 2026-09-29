import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/screens/homapage.dart';
import 'package:tanzania_stocks_app/screens/market_screen.dart';
import 'package:tanzania_stocks_app/widgets/floating_navigation_dock.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  late final PageController _pageController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: _selectedIndex == 0 ? Colors.black : Colors.grey[100],
      appBar: _selectedIndex == 0 ? null : _buildAppBar(context),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: const [
          Homepage(),
          MarketScreen(),
          _ActivityScreen(),
          _ProfileScreen(),
        ],
      ),
      bottomNavigationBar: FloatingNavigationDock(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ((MediaQuery.sizeOf(context).width - 240) / 2).clamp(
              16.0,
              100.0,
            ),
            vertical: 8,
          ).copyWith(bottom: 0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              height: 60,
              color: Colors.black,
              child: shadcn.NavigationBar(
                backgroundColor: Colors.transparent,
                selectedKey: ValueKey(_selectedIndex),
                labelType: shadcn.NavigationLabelType.selected,
                labelSize: shadcn.NavigationLabelSize.small,
                labelPosition: shadcn.NavigationLabelPosition.end,
                alignment: shadcn.NavigationBarAlignment.center,
                spacing: 3,
                padding: EdgeInsets.zero,
                onSelected: (key) {
                  if (key is! ValueKey<int> || key.value < 0 || key.value > 3) {
                    return;
                  }
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  _pageController.animateToPage(
                    key.value,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                  );
                },
                children: [
                  shadcn.NavigationItem(
                    key: const ValueKey(0),
                    label: const Text('Home'),
                    style: _navigationItemStyle,
                    child: shadcn.Icon(shadcn.LucideIcons.house, size: 18),
                    // child: const Icon(Icons.home_filled, size: 18),
                  ),
                  shadcn.NavigationItem(
                    key: const ValueKey(1),
                    label: const Text('Market'),
                    style: _navigationItemStyle,
                    // child: const Image(image:  AssetImage('assets/icons/market.png'), width: 18, height: 18),
                    child: const shadcn.Icon(
                      shadcn.LucideIcons.trendingUp,
                      size: 18,
                    ),
                  ),
                  shadcn.NavigationItem(
                    key: const ValueKey(2),
                    label: const Text('Activity'),
                    style: _navigationItemStyle,
                    child: const shadcn.Icon(
                      shadcn.LucideIcons.activity,
                      size: 18,
                    ),
                    // child: const Image(image:  AssetImage('assets/icons/portfolio.png'), width: 18, height: 18),
                    // child: const Icon(Icons.access_time_filled, size: 18),
                  ),
                  shadcn.NavigationItem(
                    key: const ValueKey(3),
                    label: const Text('Profile'),
                    style: _navigationItemStyle,
                    child: const shadcn.Icon(shadcn.LucideIcons.user, size: 18),
                    // child: const Image(image:  AssetImage('assets/icons/profile.png'), width: 18, height: 18),
                    // child: const Icon(Icons.person, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(['', 'Market', 'Activity', 'Profile'][_selectedIndex]),
      backgroundColor: Colors.grey[100],
      foregroundColor: shadcn.Theme.of(context).colorScheme.foreground,
      surfaceTintColor: Colors.transparent,
    );
  }
}

final _navigationItemStyle = shadcn.ButtonStyle.ghost(
  density: shadcn.ButtonDensity.icon,
).withForegroundColor(color: Colors.white);

class _ActivityScreen extends StatelessWidget {
  const _ActivityScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Activity'));
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile'));
  }
}
