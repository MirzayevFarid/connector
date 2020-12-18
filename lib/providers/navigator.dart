import 'package:flutter/material.dart';
import 'package:connector/routes/tabs.dart';

class NavigatorProvider with ChangeNotifier {
  NavigatorState activeTabNavigator;
  String currentTab;
  String currentRoute;
  bool hasBottomBar = true;
  bool showNotificationIndicator = false;

  NavigatorProvider() {
    currentTab = 'home';
    currentRoute = '/home';
  }

  bool get isBottomBarVisible => hasBottomBar;
  String get currentTabInfo => currentTab;
  bool get notificationIndicator => showNotificationIndicator;

  changeBottomBarVisiblity(bool v) {
    Future.delayed(Duration(milliseconds: 200), () {
      hasBottomBar = v;
      notifyListeners();
    });
  }

  changeTab(String tabRoute) {
    currentTab = tabRoute;

    notifyListeners();
  }

  changeNotificationIndicatorVisiblity(bool v) {
    showNotificationIndicator = v;

    notifyListeners();
  }

  /// If you want to open the widget in another tab then set [tab] to related tab's route that defined in routes.dart
  changeRoute(
    Function(NavigatorState navigator) callback, {
    String tab,
    bool isBottomBarVisible: true,
  }) async {
    if (tab != null) changeTab(tab);
    hasBottomBar = isBottomBarVisible;

    callback(_getNavigator(currentTab));

    notifyListeners();
  }

  // Gets called before main navigator pop
  Future<bool> onWillPop() async {
    changeBottomBarVisiblity(true);

    NavigatorState activeTabNavigator = _getNavigator(currentTab);

    if (activeTabNavigator.canPop()) {
      activeTabNavigator.maybePop();
    } else {
      changeTab("home");
    }

    return false;
  }

  NavigatorState _getNavigator(String tab) {
    return tabs.firstWhere((item) => item.route == tab).navigator.currentState;
  }
}
