import 'dart:math';

import 'package:flutter/material.dart';

import '../controllers/side_menu_controller.dart';
import '../models/side_menu_item_model.dart';

/// A customizable side menu widget for Flutter applications.
///
/// This widget creates a side menu with support for:
/// * Expandable menu items with sub-items
/// * Custom header and footer widgets
/// * Hover effects and animations
/// * Customizable colors and styles
/// * Selection state management
///
/// The menu can be controlled using [SideMenuController] which manages
/// the selection and expansion states of menu items.
class CustomSideMenuWidget extends StatefulWidget {
  /// List of menu items to be displayed in the side menu.
  final List<MenuItem> menuItems;

  /// Background color of the side menu.
  /// If not provided, uses the primary color from the current theme.
  final Color? backgroundColor;

  /// Color used for selected menu items.
  /// If not provided, uses white color.
  final Color? selectedColor;

  /// Color used for unselected menu items.
  /// If not provided, uses white color with 70% opacity.
  final Color? unselectedColor;

  /// Width of the side menu.
  /// Defaults to 250 logical pixels.
  final double width;

  /// Text style for menu items.
  /// The color of this style will be overridden based on selection state.
  final TextStyle? menuTextStyle;

  /// Optional widget to be displayed at the top of the side menu.
  final Widget? headerWidget;

  /// Height of the header section.
  /// This is used even if [headerWidget] is not provided.
  final double? headerHeight;

  /// Optional widget to be displayed at the bottom of the side menu.
  final Widget? footerWidget;

  /// Callback function called when the logout button is tapped.
  final VoidCallback? onLogout;

  /// Callback function called when a menu item is selected.
  /// Provides both the selected item and sub-item (if any).
  final Function(MenuItem item, MenuItem? subItem)? onItemSelected;

  /// Controller for managing the side menu's state.
  /// Handles selection and expansion states of menu items.
  final SideMenuController controller;

  /// Internal controller for state management.
  late final SideMenuController _sideMenuNotifier;

  /// Creates a [CustomSideMenuWidget].
  ///
  /// Requires [menuItems] and [controller] parameters.
  /// Other parameters are optional and provide customization options.
  CustomSideMenuWidget({
    super.key,
    required this.menuItems,
    required this.controller,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.width = 250,
    this.menuTextStyle,
    this.headerWidget,
    this.headerHeight,
    this.footerWidget,
    this.onLogout,
    this.onItemSelected,
  })  : assert(
          controller.value.initialSelectedIndex == null ||
              (controller.value.initialSelectedIndex! >= 0 &&
                  controller.value.initialSelectedIndex! < menuItems.length),
          'initialSelectedIndex must be null or within the range of menuItems',
        ),
        assert(
          controller.value.initialExpandedIndex == null ||
              (controller.value.initialExpandedIndex! >= 0 &&
                  controller.value.initialExpandedIndex! < menuItems.length),
          'initialExpandedIndex must be null or within the range of menuItems',
        ),
        assert(
          controller.value.initialSelectedSubIndex == null ||
              (controller.value.initialSelectedSubIndex! >= 0 &&
                  controller.value.initialSelectedSubIndex! <
                      menuItems[controller.value.initialSelectedIndex!]
                          .subItems!
                          .length),
          'initialSelectedSubIndex must be null or within the range of subItems of the selected menu item',
        ),
        assert(
          controller.value.initialExpandedIndex == null ||
              menuItems[controller.value.initialExpandedIndex!]
                  .subItems!
                  .isNotEmpty,
          'initialExpandedIndex must point to a menu item that has subItems',
        ),
        _sideMenuNotifier = controller;

  @override
  State<CustomSideMenuWidget> createState() => _CustomSideMenuWidgetState();
}

class _CustomSideMenuWidgetState extends State<CustomSideMenuWidget>
    with SingleTickerProviderStateMixin {
  /// Currently selected menu item index
  int? selectedIndex;

  /// Currently selected sub-item index
  int? selectedSubIndex;

  /// Map to track expanded state of menu items
  Map<int, bool> expandedItems = {};

  /// Map to track hover state of menu items
  Map<String, bool> hoveredItems = {};

  /// Animation controller for menu item expansion
  late AnimationController _controller;

  /// Animation for rotating menu item icons
  late Animation<double> iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Set initial selection and expansion
    if (widget.controller.value.initialSelectedIndex != null) {
      selectedIndex = widget.controller.value.initialSelectedIndex;
      selectedSubIndex = widget.controller.value.initialSelectedSubIndex;
    }

    if (widget.controller.value.initialExpandedIndex != null) {
      expandedItems[widget.controller.value.initialExpandedIndex!] = true;
      _controller.forward();
    }

    // Call onItemSelected with initial selection if any
    if (selectedIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final item = widget.menuItems[selectedIndex!];
        final subItem = selectedSubIndex != null && item.subItems != null
            ? item.subItems![selectedSubIndex!]
            : null;
        widget.onItemSelected?.call(item, subItem);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds the main structure of the side menu.
  ///
  /// Includes header, menu items list, and footer sections.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SideMenuControllerModel>(
      valueListenable: widget._sideMenuNotifier,
      builder: (context, value, child) => child!,
      child: Container(
        width: widget.width,
        color: widget.backgroundColor ?? Theme.of(context).primaryColor,
        child: Column(
          children: [
            if (widget.headerWidget != null)
              Container(
                height: widget.headerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ?? Theme.of(context).primaryColor,
                  border: Border(
                    bottom: BorderSide(
                      color: widget.unselectedColor?.withOpacity(0.2) ??
                          Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: widget.headerWidget,
              )
            else if (widget.headerHeight != null)
              Container(
                height: widget.headerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ?? Theme.of(context).primaryColor,
                  border: Border(
                    bottom: BorderSide(
                      color: widget.unselectedColor?.withOpacity(0.2) ??
                          Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: 0.6,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Icon(
                              Icons.dashboard,
                              color: widget.selectedColor ?? Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                              color: widget.selectedColor ?? Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.menuItems.length,
                itemBuilder: (context, index) {
                  final item = widget.menuItems[index];
                  return _buildSubMenu(item, index);
                },
              ),
            ),
            if (widget.footerWidget != null)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: widget.unselectedColor?.withOpacity(0.2) ??
                          Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: widget.footerWidget,
              ),
            if (widget.footerWidget == null)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: widget.unselectedColor?.withOpacity(0.2) ??
                          Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: MouseRegion(
                  onEnter: (_) => setState(() => hoveredItems['-1'] = true),
                  onExit: (_) => setState(() => hoveredItems['-1'] = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: hoveredItems['-1'] == true
                          ? widget.unselectedColor?.withOpacity(0.1) ??
                              Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: widget.unselectedColor ?? Colors.white70,
                      ),
                      title: Text(
                        'Logout',
                        style: widget.menuTextStyle?.copyWith(
                              color: widget.unselectedColor ?? Colors.white70,
                            ) ??
                            TextStyle(
                              color: widget.unselectedColor ?? Colors.white70,
                            ),
                      ),
                      onTap: widget.onLogout ?? () {},
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual menu item.
  ///
  /// Handles the item's appearance, hover effects, and selection state.
  /// If the item has sub-items, it also manages the expansion/collapse behavior.
  ///
  /// Parameters:
  ///   * [item] - The menu item to build
  ///   * [index] - The index of the item in the menu list
  Widget _buildMenuItem(MenuItem item, int index) {
    final bool hasSubItems = item.subItems?.isNotEmpty ?? false;
    final bool isSelected = widget.controller.value.selectedIndex == index &&
        widget.controller.value.selectedSubIndex == null;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredItems[index.toString()] = true),
      onExit: (_) => setState(() => hoveredItems[index.toString()] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.selectedColor?.withOpacity(0.1) ??
                  Colors.white.withOpacity(0.1)
              : hoveredItems[index.toString()] == true
                  ? widget.unselectedColor?.withOpacity(0.1) ??
                      Colors.white.withOpacity(0.1)
                  : Colors.transparent,
        ),
        child: ListTile(
          leading: Icon(
            item.icon,
            color: isSelected
                ? widget.selectedColor ?? Colors.white
                : widget.unselectedColor ?? Colors.white70,
          ),
          title: Text(
            item.title,
            style: widget.menuTextStyle?.copyWith(
                  color: isSelected
                      ? widget.selectedColor ?? Colors.white
                      : widget.unselectedColor ?? Colors.white70,
                ) ??
                TextStyle(
                  color: isSelected
                      ? widget.selectedColor ?? Colors.white
                      : widget.unselectedColor ?? Colors.white70,
                ),
          ),
          trailing: hasSubItems
              ? TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(
                    begin: expandedItems[index] == true ? 0.0 : -0.5 * pi,
                    end: expandedItems[index] == true ? -0.5 * pi : 0.0,
                  ),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value,
                      child: Icon(
                        Icons.chevron_right,
                        color: isSelected
                            ? widget.selectedColor ?? Colors.white
                            : widget.unselectedColor ?? Colors.white70,
                      ),
                    );
                  },
                )
              : null,
          onTap: () {
            setState(() {
              if (hasSubItems) {
                // Toggle current item
                expandedItems[index] = !(expandedItems[index] ?? false);
                // Close other expanded items
                expandedItems.forEach((key, _) {
                  if (key != index) {
                    expandedItems[key] = false;
                  }
                });
                widget.controller.setExpandedIndex(index);
              } else {
                // Close all expanded items when selecting a non-expandable item
                expandedItems.clear();
                selectedIndex = index;
                selectedSubIndex = null;
                widget.controller.setExpandedIndex(null);
                widget.controller.setSelectedSubIndex(null);
                widget.controller.setSelectedIndex(index);
                widget.onItemSelected?.call(item, null);
              }
            });
          },
        ),
      ),
    );
  }

  /// Builds a menu item with its submenu.
  ///
  /// Creates a column containing the main menu item and its expandable submenu.
  /// The submenu is animated and only visible when the parent item is expanded.
  ///
  /// Parameters:
  ///   * [item] - The parent menu item
  ///   * [index] - The index of the parent item
  Widget _buildSubMenu(MenuItem item, int index) {
    return Column(
      children: [
        _buildMenuItem(item, index),
        ClipRect(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: expandedItems[index] == true
                ? (item.subItems?.length ?? 0) * 48.0
                : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: item.subItems?.map((subItem) {
                      final subIndex =
                          '${index}_${item.subItems?.indexOf(subItem)}';
                      final bool isSubItemSelected =
                          widget.controller.value.selectedIndex == index &&
                              widget.controller.value.selectedSubIndex ==
                                  item.subItems?.indexOf(subItem);

                      return MouseRegion(
                        onEnter: (_) =>
                            setState(() => hoveredItems[subIndex] = true),
                        onExit: (_) =>
                            setState(() => hoveredItems[subIndex] = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSubItemSelected
                                ? widget.selectedColor?.withOpacity(0.1) ??
                                    Colors.white.withOpacity(0.1)
                                : hoveredItems[subIndex] == true
                                    ? widget.unselectedColor
                                            ?.withOpacity(0.1) ??
                                        Colors.white.withOpacity(0.1)
                                    : Colors.transparent,
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 64.0, right: 16.0),
                            leading: Icon(
                              subItem.icon,
                              color: isSubItemSelected
                                  ? widget.selectedColor ?? Colors.white
                                  : widget.unselectedColor ?? Colors.white70,
                            ),
                            title: Text(
                              subItem.title,
                              style: widget.menuTextStyle?.copyWith(
                                    color: isSubItemSelected
                                        ? widget.selectedColor ?? Colors.white
                                        : widget.unselectedColor ??
                                            Colors.white70,
                                  ) ??
                                  TextStyle(
                                    color: isSubItemSelected
                                        ? widget.selectedColor ?? Colors.white
                                        : widget.unselectedColor ??
                                            Colors.white70,
                                  ),
                            ),
                            onTap: () {
                              setState(() {
                                // Close all expanded items except the parent
                                expandedItems.clear();
                                expandedItems[index] = true;
                                widget.controller.setExpandedIndex(index);
                                widget.controller.setSelectedIndex(index);
                                widget.controller.setSelectedSubIndex(
                                    item.subItems?.indexOf(subItem));
                                widget.onItemSelected?.call(item, subItem);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList() ??
                    [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
