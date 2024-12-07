import 'package:flutter/material.dart';

/// A class representing a menu item in a side menu.
class MenuItem {
  /// The title of the menu item.
  final String title;

  /// The icon associated with the menu item.
  final IconData icon;

  /// The callback function to be executed when the menu item is tapped.
  final VoidCallback? onTap;

  /// A list of sub-items for expandable menu items.
  final List<MenuItem>? subItems;

  /// Creates a [MenuItem] with the given title, icon, optional tap callback, and optional sub-items.
  ///
  /// The [title] and [icon] parameters are required.
  MenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.subItems,
  });
}
