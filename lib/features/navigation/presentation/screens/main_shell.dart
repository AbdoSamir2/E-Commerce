import 'package:flutter/material.dart';
import '../../../catalog/home_screen.dart';
import '../../../cart/logic/cart/cart_screen.dart';
import '../../../profile/screens/profile_screen.dart';

class MainShell extends StatefulWidget
{
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
{
  int _currentIndex = 0;
  bool _profileCreated = false;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const _CategoriesPlaceholder(),

    CartScreen(
      onStartShopping: () {
        setState(() {_currentIndex = 0;});
      },
    ),

    const SizedBox.shrink(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;

      if (index == 3 && !_profileCreated) {
        _screens[3] = const ProfileScreen();
        _profileCreated = true;
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CategoriesPlaceholder extends StatelessWidget
{
  const _CategoriesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Categories Screen'),
      ),
    );
  }
}