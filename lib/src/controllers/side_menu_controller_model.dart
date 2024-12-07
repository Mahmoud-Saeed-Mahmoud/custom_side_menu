part of 'side_menu_controller.dart';

/// A model representing the state of the side menu, including selection
/// and expansion indices.
///
/// This model is immutable and can be copied with modified values using
/// the [copyWith] method.
class SideMenuControllerModel {
  /// The initially selected index of the menu item.
  final int? initialSelectedIndex;

  /// The initially selected sub-index of the sub-menu item.
  final int? initialSelectedSubIndex;

  /// The initially expanded index of the menu item.
  final int? initialExpandedIndex;

  /// The currently expanded index of the menu item.
  final int? expandedIndex;

  /// The currently selected index of the menu item.
  final int? selectedIndex;

  /// The currently selected sub-index of the sub-menu item.
  final int? selectedSubIndex;

  /// Creates a [SideMenuControllerModel] with the given initial and current indices.
  SideMenuControllerModel({
    this.initialExpandedIndex,
    this.initialSelectedIndex,
    this.initialSelectedSubIndex,
    this.selectedIndex,
    this.selectedSubIndex,
    this.expandedIndex,
  });

  /// Creates a copy of this model with the given fields replaced with new values.
  ///
  /// If a value is not provided, the original value is retained.
  SideMenuControllerModel copyWith({
    int? expandedIndex,
    int? selectedIndex,
    int? selectedSubIndex,
  }) {
    return SideMenuControllerModel(
      initialExpandedIndex: initialExpandedIndex,
      initialSelectedIndex: initialSelectedIndex,
      initialSelectedSubIndex: initialSelectedSubIndex,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedSubIndex: selectedSubIndex,
      expandedIndex: expandedIndex,
    );
  }
}
