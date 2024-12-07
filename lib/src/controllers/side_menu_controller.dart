import 'package:flutter/foundation.dart';

part 'side_menu_controller_model.dart';

/// A controller that manages the state of a side menu, including selection
/// and expansion of menu items.
///
/// This controller extends [ValueNotifier] to notify listeners of changes
/// to the menu state.
class SideMenuController extends ValueNotifier<SideMenuControllerModel> {
  /// Creates a [SideMenuController] with optional initial indices for
  /// expansion, selection, and sub-selection.
  SideMenuController({
    int? initialExpandedIndex,
    int? initialSelectedIndex,
    int? initialSelectedSubIndex,
  }) : super(
          SideMenuControllerModel(
            initialExpandedIndex: initialExpandedIndex,
            initialSelectedIndex: initialSelectedIndex,
            initialSelectedSubIndex: initialSelectedSubIndex,
          ),
        );

  /// Sets the expanded index of the menu and notifies listeners of the change.
  ///
  /// [index] is the index of the menu item to be expanded. It can be null.
  void setExpandedIndex(int? index) {
    value = value.copyWith(expandedIndex: index);
    notifyListeners();
  }

  /// Sets the selected index of the menu and notifies listeners of the change.
  ///
  /// [index] is the index of the menu item to be selected. It can be null.
  void setSelectedIndex(int? index) {
    value = value.copyWith(selectedIndex: index);
    notifyListeners();
  }

  /// Sets the selected sub-index of the menu and notifies listeners of the change.
  ///
  /// [index] is the index of the sub-menu item to be selected. It can be null.
  void setSelectedSubIndex(int? index) {
    value = value.copyWith(selectedSubIndex: index);
    notifyListeners();
  }
}
