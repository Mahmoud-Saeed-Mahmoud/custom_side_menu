# Custom Side Menu

A highly customizable Flutter side menu widget that provides an elegant and responsive navigation solution for your applications. Created with [Windsurf](https://www.codeium.com/windsurf), the next-generation IDE that brings the power of AI to your development workflow.

## Features

- 🎨 Fully customizable appearance
- 📱 Responsive design
- 🔄 Smooth animations
- 🌳 Support for nested menu items
- 🎯 State management with controller
- 🖱️ Hover effects
- 🎭 Custom header and footer widgets
- 🎨 Theming support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_side_menu: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:custom_side_menu/custom_side_menu.dart';

// Create menu items
final List<MenuItem> menuItems = [
  MenuItem(
    title: 'Dashboard',
    icon: Icons.dashboard,
    onTap: () {
      // Handle tap
    },
  ),
  MenuItem(
    title: 'Settings',
    icon: Icons.settings,
    subItems: [
      MenuItem(
        title: 'Profile',
        icon: Icons.person,
        onTap: () {
          // Handle tap
        },
      ),
      MenuItem(
        title: 'Preferences',
        icon: Icons.tune,
        onTap: () {
          // Handle tap
        },
      ),
    ],
  ),
];

// Create a controller
final controller = SideMenuController();

// Use the widget
CustomSideMenuWidget(
  menuItems: menuItems,
  controller: controller,
  backgroundColor: Colors.blue,
  selectedColor: Colors.white,
  unselectedColor: Colors.white70,
  width: 250,
  onItemSelected: (item, subItem) {
    // Handle selection
  },
)
```

### Customization

The side menu can be customized with various properties:

```dart
CustomSideMenuWidget(
  menuItems: menuItems,
  controller: controller,
  backgroundColor: Colors.blue,
  selectedColor: Colors.white,
  unselectedColor: Colors.white70,
  width: 250,
  menuTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  headerWidget: YourCustomHeaderWidget(),
  footerWidget: YourCustomFooterWidget(),
  onLogout: () {
    // Handle logout
  },
  onItemSelected: (item, subItem) {
    // Handle selection
  },
)
```

### Controller Usage

The `SideMenuController` allows you to programmatically control the menu state:

```dart
final controller = SideMenuController(
  initialSelectedIndex: 0,
  initialExpandedIndex: 1,
  initialSelectedSubIndex: 0,
);

// Later in your code
controller.setSelectedIndex(2);
controller.setExpandedIndex(2);
controller.setSelectedSubIndex(1);
```

## Additional Information

- Package is licensed under the MIT License
- Contributions are welcome at [GitHub Repository]
- For issues and feature requests, please file them on the GitHub repository
- For more examples, check the `/example` folder in the package

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
