import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/main_container.dart';
import 'package:connector/pages/explore/main.dart';
import 'package:connector/pages/home/main.dart';
import 'package:connector/pages/notifications/main.dart';
import 'package:connector/pages/profile/main.dart';

List<ScrollController> scrollControllers = [
  ScrollController(),
  ScrollController(),
  ScrollController(),
  ScrollController(),
];

List<MainTabView> tabs = [
  MainTabView(
    route: 'home',
    page: Home(scrollController: scrollControllers[0]),
    text: "Home",
    assetImage: Icon(
      Icons.home_outlined,
      color: ORColorStyles.icon_color,
      size: 30,
    ),
    activeAssetImage: Icon(
      Icons.home_outlined,
      color: ORColorStyles.blue,
      size: 30,
    ),
  ),
  MainTabView(
    route: 'explore',
    page: Explore(scrollController: scrollControllers[1]),
    text: "Explore",
    assetImage: Icon(
      Icons.card_travel,
      color: ORColorStyles.icon_color,
      size: 30,
    ),
    activeAssetImage: Icon(
      Icons.card_travel,
      color: ORColorStyles.blue,
      size: 30,
    ),
  ),
  MainTabView(
    route: 'notifications',
    page: Notifications(scrollController: scrollControllers[2]),
    text: "Notifications",
    assetImage: Icon(
      Icons.notifications_none_outlined,
      color: ORColorStyles.icon_color,
      size: 30,
    ),
    activeAssetImage: Icon(
      Icons.notifications_none_outlined,
      color: ORColorStyles.blue,
      size: 30,
    ),
  ),
  MainTabView(
    route: 'profile',
    page: Profile(scrollController: scrollControllers[3]),
    text: "Profile",
    assetImage: Icon(
      Icons.account_circle_outlined,
      color: ORColorStyles.icon_color,
      size: 30,
    ),
    activeAssetImage: Icon(
      Icons.account_circle_outlined,
      color: ORColorStyles.blue,
      size: 30,
    ),
  ),
];
