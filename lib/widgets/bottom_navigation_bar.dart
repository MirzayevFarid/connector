import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// commons
import 'package:connector/common/constants.dart';
import 'package:connector/helpers/statusbar_text_color.dart';

/// pages
import 'package:connector/main_container.dart';

/// routes
import 'package:connector/routes/tabs.dart';

/// providers
import 'package:provider/provider.dart';
import 'package:connector/providers/navigator.dart';

/// widgets
import 'package:connector/widgets/transparent_link.dart';

class ConnectorBottomNavigationBar extends StatefulWidget {
  ConnectorBottomNavigationBar({
    this.body,
    this.onTabSelected,
    this.controller,
    this.isBottomVisible,
  });

  final ValueChanged<int> onTabSelected;
  final TabController controller;
  final bool isBottomVisible;
  final Widget body;

  @override
  _ConnectorBottomNavigationBarState createState() =>
      _ConnectorBottomNavigationBarState();
}

class _ConnectorBottomNavigationBarState
    extends State<ConnectorBottomNavigationBar> {
  double _height = Constants.NAV_BAR_HEIGHT;
  bool hasNewNotification = true;
  NavigatorProvider navigationProvider;

  @override
  void initState() {
    super.initState();
    navigationProvider = context.read<NavigatorProvider>();
  }

  _updateIndex(MainTabView tab, int i) async {
    try {
      if (tab.route == navigationProvider.currentTab) {
        navigationProvider.changeRoute(
          (navigator) => navigator.canPop()
              ? navigator.maybePop()
              : scrollControllers[i].hasClients
                  ? scrollControllers[i].animateTo(
                      0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOutQuad,
                    )
                  : null,
        );
      }
    } catch (e) {
      // print(e);
    }

    navigationProvider.changeTab(tab.route);

    widget.controller
        .animateTo(tabs.indexOf(tab), duration: Duration(milliseconds: 2000));

    StatusbarTextHelper.changeColor(isDark: tab.isLight);
  }

  @override
  Widget build(BuildContext context) {
    NavigatorProvider navigation = context.watch<NavigatorProvider>();

    List<Widget> items = List.generate(tabs.length, (int index) {
      MainTabView tab = tabs[index];

      return _buildTabItem(
        item: tab,
        index: index,
        onPressed: (i) => _updateIndex(tab, i),
        isActive: tab.route == navigation.currentTab,
      );
    });
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      shape: CircularNotchedRectangle(),
      child: AnimatedSwitcher(
        duration: Duration(
          milliseconds: 200,
        ),
        switchInCurve: Curves.easeInOutQuad,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: widget.isBottomVisible
            ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: items,
              )
            : Container(
                height: 0,
              ),
      ),
    );
  }

  Widget _buildTabItem({
    MainTabView item,
    int index,
    ValueChanged<int> onPressed,
    bool isActive,
  }) {
    return Expanded(
      child: TransparentLink(
        onTap: () => onPressed(index),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(
                right: index == 1 ? 65 : 0, left: index == 2 ? 65 : 0),
            height: _height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: item.iconSize + 20,
                  height: item.iconSize + 20,
                  child: IconButton(
                    icon: isActive ? item.activeAssetImage : item.assetImage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
