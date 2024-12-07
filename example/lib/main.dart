import 'package:custom_side_menu/custom_side_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1a1c1e),
        scaffoldBackgroundColor: const Color(0xFFf5f5f5),
      ),
      home: const DashboardScreen(),
    );
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isFooterHovered = false;
  late final SideMenuController _menuController;
  Widget _currentContent = const Center(
    child: Text(
      'Select a menu item',
      style: TextStyle(fontSize: 24),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        onTap: () {},
      ),
      MenuItem(
        title: 'Analytics',
        icon: Icons.analytics,
        subItems: [
          MenuItem(
            title: 'Reports',
            icon: Icons.article,
            onTap: () {},
          ),
          MenuItem(
            title: 'Statistics',
            icon: Icons.bar_chart,
            onTap: () {},
          ),
        ],
      ),
      MenuItem(
        title: 'Users',
        icon: Icons.people,
        onTap: () {},
      ),
      MenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () {},
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          CustomSideMenuWidget(
            menuItems: menuItems,
            controller: _menuController,
            backgroundColor: Theme.of(context).primaryColor,
            selectedColor: Colors.white,
            unselectedColor: Colors.white70,
            menuTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            headerWidget: Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            footerWidget: MouseRegion(
              onEnter: (_) => setState(() => _isFooterHovered = true),
              onExit: (_) => setState(() => _isFooterHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isFooterHovered
                      ? Colors.white.withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white70,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _handleLogout(context),
                ),
              ),
            ),
            onItemSelected: _handleItemSelected,
          ),
          Expanded(
            child: _currentContent,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _menuController = SideMenuController(
      initialSelectedIndex: 0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _menuController.setSelectedIndex(1);
    });
  }

  void _handleItemSelected(MenuItem item, MenuItem? subItem) {
    setState(() {
      if (subItem != null) {
        _currentContent = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                subItem.title,
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        );
      } else {
        _currentContent = Center(
          child: Text(
            item.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        );
      }
    });
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your logout logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
